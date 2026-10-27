
/home/david/buster-fast-bench/codex-180-fix-20261026-main/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000018dd0d0 <run_backend_benchmark>:
 18dd0d0:	55                   	push   %rbp
 18dd0d1:	48 89 e5             	mov    %rsp,%rbp
 18dd0d4:	41 57                	push   %r15
 18dd0d6:	41 56                	push   %r14
 18dd0d8:	41 55                	push   %r13
 18dd0da:	41 54                	push   %r12
 18dd0dc:	53                   	push   %rbx
 18dd0dd:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
 18dd0e1:	48 81 ec c0 2c 00 00 	sub    $0x2cc0,%rsp
 18dd0e8:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18dd0f1:	48 89 84 24 80 2c 00 00 	mov    %rax,0x2c80(%rsp)
 18dd0f9:	83 ff 02             	cmp    $0x2,%edi
 18dd0fc:	0f 8c dc 01 00 00    	jl     18dd2de <run_backend_benchmark+0x20e>
 18dd102:	b8 04 00 00 00       	mov    $0x4,%eax
 18dd107:	41 bc 03 00 00 00    	mov    $0x3,%r12d
 18dd10d:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 18dd113:	48 89 f3             	mov    %rsi,%rbx
 18dd116:	41 89 fe             	mov    %edi,%r14d
 18dd119:	48 c7 84 24 18 01 00 00 00 00 00 00 	movq   $0x0,0x118(%rsp)
 18dd125:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
 18dd12a:	48 89 84 24 c8 00 00 00 	mov    %rax,0xc8(%rsp)
 18dd132:	b8 01 00 00 00       	mov    $0x1,%eax
 18dd137:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 18dd13f:	b8 00 00 04 00       	mov    $0x40000,%eax
 18dd144:	48 89 84 24 20 01 00 00 	mov    %rax,0x120(%rsp)
 18dd14c:	0f 1f 40 00          	nopl   0x0(%rax)
 18dd150:	41 8d 44 24 fe       	lea    -0x2(%r12),%eax
 18dd155:	48 8d 35 a7 15 d8 fe 	lea    -0x127ea59(%rip),%rsi        # 65e703 <fuzz_comment_end+0x14a39>
 18dd15c:	48 98                	cltq
 18dd15e:	4c 8b 2c c3          	mov    (%rbx,%rax,8),%r13
 18dd162:	4c 89 ef             	mov    %r13,%rdi
 18dd165:	e8 86 ce eb fe       	call   799ff0 <strcmp@plt>
 18dd16a:	85 c0                	test   %eax,%eax
 18dd16c:	75 32                	jne    18dd1a0 <run_backend_benchmark+0xd0>
 18dd16e:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
 18dd173:	44 39 f0             	cmp    %r14d,%eax
 18dd176:	7d 28                	jge    18dd1a0 <run_backend_benchmark+0xd0>
 18dd178:	48 98                	cltq
 18dd17a:	41 ff c7             	inc    %r15d
 18dd17d:	31 f6                	xor    %esi,%esi
 18dd17f:	31 d2                	xor    %edx,%edx
 18dd181:	48 8b 3c c3          	mov    (%rbx,%rax,8),%rdi
 18dd185:	e8 26 c5 eb fe       	call   7996b0 <strtoull@plt>
 18dd18a:	48 89 84 24 20 01 00 00 	mov    %rax,0x120(%rsp)
 18dd192:	b0 01                	mov    $0x1,%al
 18dd194:	e9 2a 01 00 00       	jmp    18dd2c3 <run_backend_benchmark+0x1f3>
 18dd199:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18dd1a0:	48 8d 35 a0 b8 d3 fe 	lea    -0x12c4760(%rip),%rsi        # 618a47 <foreign_touch.flags+0xf0a3>
 18dd1a7:	4c 89 ef             	mov    %r13,%rdi
 18dd1aa:	e8 41 ce eb fe       	call   799ff0 <strcmp@plt>
 18dd1af:	85 c0                	test   %eax,%eax
 18dd1b1:	75 2d                	jne    18dd1e0 <run_backend_benchmark+0x110>
 18dd1b3:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
 18dd1b8:	44 39 f0             	cmp    %r14d,%eax
 18dd1bb:	7d 23                	jge    18dd1e0 <run_backend_benchmark+0x110>
 18dd1bd:	48 98                	cltq
 18dd1bf:	41 ff c7             	inc    %r15d
 18dd1c2:	31 f6                	xor    %esi,%esi
 18dd1c4:	31 d2                	xor    %edx,%edx
 18dd1c6:	48 8b 3c c3          	mov    (%rbx,%rax,8),%rdi
 18dd1ca:	e8 e1 c4 eb fe       	call   7996b0 <strtoull@plt>
 18dd1cf:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 18dd1d7:	b0 01                	mov    $0x1,%al
 18dd1d9:	e9 e5 00 00 00       	jmp    18dd2c3 <run_backend_benchmark+0x1f3>
 18dd1de:	66 90                	xchg   %ax,%ax
 18dd1e0:	48 8d 35 3d 0f d2 fe 	lea    -0x12df0c3(%rip),%rsi        # 5fe124 <parse_test_openers+0x3c960>
 18dd1e7:	4c 89 ef             	mov    %r13,%rdi
 18dd1ea:	e8 01 ce eb fe       	call   799ff0 <strcmp@plt>
 18dd1ef:	85 c0                	test   %eax,%eax
 18dd1f1:	75 2d                	jne    18dd220 <run_backend_benchmark+0x150>
 18dd1f3:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
 18dd1f8:	44 39 f0             	cmp    %r14d,%eax
 18dd1fb:	7d 23                	jge    18dd220 <run_backend_benchmark+0x150>
 18dd1fd:	48 98                	cltq
 18dd1ff:	41 ff c7             	inc    %r15d
 18dd202:	31 f6                	xor    %esi,%esi
 18dd204:	31 d2                	xor    %edx,%edx
 18dd206:	48 8b 3c c3          	mov    (%rbx,%rax,8),%rdi
 18dd20a:	e8 a1 c4 eb fe       	call   7996b0 <strtoull@plt>
 18dd20f:	48 89 84 24 18 01 00 00 	mov    %rax,0x118(%rsp)
 18dd217:	b0 01                	mov    $0x1,%al
 18dd219:	e9 a5 00 00 00       	jmp    18dd2c3 <run_backend_benchmark+0x1f3>
 18dd21e:	66 90                	xchg   %ax,%ax
 18dd220:	48 8d 35 90 34 d5 fe 	lea    -0x12acb70(%rip),%rsi        # 6306b7 <foreign_touch.flags+0x26d13>
 18dd227:	4c 89 ef             	mov    %r13,%rdi
 18dd22a:	e8 c1 cd eb fe       	call   799ff0 <strcmp@plt>
 18dd22f:	85 c0                	test   %eax,%eax
 18dd231:	0f 85 d4 00 00 00    	jne    18dd30b <run_backend_benchmark+0x23b>
 18dd237:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
 18dd23c:	44 39 f0             	cmp    %r14d,%eax
 18dd23f:	0f 8d c6 00 00 00    	jge    18dd30b <run_backend_benchmark+0x23b>
 18dd245:	48 98                	cltq
 18dd247:	48 8d 35 ee ef d3 fe 	lea    -0x12c1012(%rip),%rsi        # 61c23c <foreign_touch.flags+0x12898>
 18dd24e:	41 ff c7             	inc    %r15d
 18dd251:	4c 8b 2c c3          	mov    (%rbx,%rax,8),%r13
 18dd255:	4c 89 ef             	mov    %r13,%rdi
 18dd258:	e8 93 cd eb fe       	call   799ff0 <strcmp@plt>
 18dd25d:	48 8b 9c 24 c8 00 00 00 	mov    0xc8(%rsp),%rbx
 18dd265:	85 c0                	test   %eax,%eax
 18dd267:	48 8d 35 d2 b7 d3 fe 	lea    -0x12c482e(%rip),%rsi        # 618a40 <foreign_touch.flags+0xf09c>
 18dd26e:	4c 89 ef             	mov    %r13,%rdi
 18dd271:	0f 44 d8             	cmove  %eax,%ebx
 18dd274:	e8 77 cd eb fe       	call   799ff0 <strcmp@plt>
 18dd279:	85 c0                	test   %eax,%eax
 18dd27b:	b8 01 00 00 00       	mov    $0x1,%eax
 18dd280:	48 8d 35 0c 15 d8 fe 	lea    -0x127eaf4(%rip),%rsi        # 65e793 <fuzz_comment_end+0x14ac9>
 18dd287:	4c 89 ef             	mov    %r13,%rdi
 18dd28a:	0f 44 d8             	cmove  %eax,%ebx
 18dd28d:	e8 5e cd eb fe       	call   799ff0 <strcmp@plt>
 18dd292:	85 c0                	test   %eax,%eax
 18dd294:	b8 02 00 00 00       	mov    $0x2,%eax
 18dd299:	48 8d 35 53 05 db fe 	lea    -0x124faad(%rip),%rsi        # 68d7f3 <fuzz_comment_end+0x43b29>
 18dd2a0:	4c 89 ef             	mov    %r13,%rdi
 18dd2a3:	0f 44 d8             	cmove  %eax,%ebx
 18dd2a6:	e8 45 cd eb fe       	call   799ff0 <strcmp@plt>
 18dd2ab:	85 c0                	test   %eax,%eax
 18dd2ad:	b9 03 00 00 00       	mov    $0x3,%ecx
 18dd2b2:	0f 44 d9             	cmove  %ecx,%ebx
 18dd2b5:	83 fb 04             	cmp    $0x4,%ebx
 18dd2b8:	48 89 9c 24 c8 00 00 00 	mov    %rbx,0xc8(%rsp)
 18dd2c0:	0f 95 c0             	setne  %al
 18dd2c3:	45 39 f4             	cmp    %r14d,%r12d
 18dd2c6:	7d 45                	jge    18dd30d <run_backend_benchmark+0x23d>
 18dd2c8:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
 18dd2cd:	41 ff c7             	inc    %r15d
 18dd2d0:	41 83 c4 02          	add    $0x2,%r12d
 18dd2d4:	84 c0                	test   %al,%al
 18dd2d6:	0f 85 74 fe ff ff    	jne    18dd150 <run_backend_benchmark+0x80>
 18dd2dc:	eb 2f                	jmp    18dd30d <run_backend_benchmark+0x23d>
 18dd2de:	b8 00 00 04 00       	mov    $0x40000,%eax
 18dd2e3:	31 c9                	xor    %ecx,%ecx
 18dd2e5:	48 89 84 24 20 01 00 00 	mov    %rax,0x120(%rsp)
 18dd2ed:	b8 01 00 00 00       	mov    $0x1,%eax
 18dd2f2:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 18dd2fa:	b8 04 00 00 00       	mov    $0x4,%eax
 18dd2ff:	48 89 84 24 c8 00 00 00 	mov    %rax,0xc8(%rsp)
 18dd307:	31 c0                	xor    %eax,%eax
 18dd309:	eb 0c                	jmp    18dd317 <run_backend_benchmark+0x247>
 18dd30b:	31 c0                	xor    %eax,%eax
 18dd30d:	48 8b 8c 24 18 01 00 00 	mov    0x118(%rsp),%rcx
 18dd315:	34 01                	xor    $0x1,%al
 18dd317:	84 c0                	test   %al,%al
 18dd319:	0f 85 1e 91 00 00    	jne    18e643d <run_backend_benchmark+0x936d>
 18dd31f:	48 83 bc 24 20 01 00 00 00 	cmpq   $0x0,0x120(%rsp)
 18dd328:	0f 84 0f 91 00 00    	je     18e643d <run_backend_benchmark+0x936d>
 18dd32e:	48 81 f9 10 27 00 00 	cmp    $0x2710,%rcx
 18dd335:	0f 87 02 91 00 00    	ja     18e643d <run_backend_benchmark+0x936d>
 18dd33b:	48 89 8c 24 18 01 00 00 	mov    %rcx,0x118(%rsp)
 18dd343:	41 b7 01             	mov    $0x1,%r15b
 18dd346:	48 8d 1d 33 f1 37 0d 	lea    0xd37f133(%rip),%rbx        # ec5c480 <x86_template_storage+0x40>
 18dd34d:	48 8d 0d 4c fc 98 00 	lea    0x98fc4c(%rip),%rcx        # 226cfa0 <x86_form_descriptions>
 18dd354:	45 31 e4             	xor    %r12d,%r12d
 18dd357:	eb 35                	jmp    18dd38e <run_backend_benchmark+0x2be>
 18dd359:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18dd360:	44 09 6b 0c          	or     %r13d,0xc(%rbx)
 18dd364:	49 ff c4             	inc    %r12
 18dd367:	48 8d 0d 32 fc 98 00 	lea    0x98fc32(%rip),%rcx        # 226cfa0 <x86_form_descriptions>
 18dd36e:	c5 f8 28 43 10       	vmovaps 0x10(%rbx),%xmm0
 18dd373:	c5 f8 29 43 20       	vmovaps %xmm0,0x20(%rbx)
 18dd378:	c5 f9 6f 03          	vmovdqa (%rbx),%xmm0
 18dd37c:	c5 f9 7f 43 30       	vmovdqa %xmm0,0x30(%rbx)
 18dd381:	48 83 c3 40          	add    $0x40,%rbx
 18dd385:	49 81 fc e0 61 00 00 	cmp    $0x61e0,%r12
 18dd38c:	74 72                	je     18dd400 <run_backend_benchmark+0x330>
 18dd38e:	be 00 00 00 00       	mov    $0x0,%esi
 18dd393:	4c 89 e0             	mov    %r12,%rax
 18dd396:	49 81 fc a0 20 00 00 	cmp    $0x20a0,%r12
 18dd39d:	73 36                	jae    18dd3d5 <run_backend_benchmark+0x305>
 18dd39f:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
 18dd3a3:	45 31 ed             	xor    %r13d,%r13d
 18dd3a6:	31 d2                	xor    %edx,%edx
 18dd3a8:	4c 8d 34 c1          	lea    (%rcx,%rax,8),%r14
 18dd3ac:	48 89 d9             	mov    %rbx,%rcx
 18dd3af:	4c 89 f7             	mov    %r14,%rdi
 18dd3b2:	e8 29 27 01 00       	call   18efae0 <build_template>
 18dd3b7:	84 c0                	test   %al,%al
 18dd3b9:	75 a5                	jne    18dd360 <run_backend_benchmark+0x290>
 18dd3bb:	4c 89 f7             	mov    %r14,%rdi
 18dd3be:	31 f6                	xor    %esi,%esi
 18dd3c0:	31 d2                	xor    %edx,%edx
 18dd3c2:	48 89 d9             	mov    %rbx,%rcx
 18dd3c5:	e8 16 27 01 00       	call   18efae0 <build_template>
 18dd3ca:	41 20 c7             	and    %al,%r15b
 18dd3cd:	41 bd 00 00 00 04    	mov    $0x4000000,%r13d
 18dd3d3:	eb 8b                	jmp    18dd360 <run_backend_benchmark+0x290>
 18dd3d5:	41 8d 8c 24 c0 be ff ff 	lea    -0x4140(%r12),%ecx
 18dd3dd:	41 8d 84 24 60 df ff ff 	lea    -0x20a0(%r12),%eax
 18dd3e5:	49 81 fc 40 41 00 00 	cmp    $0x4140,%r12
 18dd3ec:	be 01 00 00 00       	mov    $0x1,%esi
 18dd3f1:	0f 43 c1             	cmovae %ecx,%eax
 18dd3f4:	48 8d 0d a5 fb 98 00 	lea    0x98fba5(%rip),%rcx        # 226cfa0 <x86_form_descriptions>
 18dd3fb:	83 de ff             	sbb    $0xffffffff,%esi
 18dd3fe:	eb 9f                	jmp    18dd39f <run_backend_benchmark+0x2cf>
 18dd400:	48 8d 3d 79 f0 57 0d 	lea    0xd57f079(%rip),%rdi        # ee5c480 <x86_template_storage+0x200040>
 18dd407:	48 8d 35 72 f0 37 0d 	lea    0xd37f072(%rip),%rsi        # ec5c480 <x86_template_storage+0x40>
 18dd40e:	ba 00 78 18 00       	mov    $0x187800,%edx
 18dd413:	e8 88 cb eb fe       	call   799fa0 <memcpy@plt>
 18dd418:	41 f6 c7 01          	test   $0x1,%r15b
 18dd41c:	0f 84 94 90 00 00    	je     18e64b6 <run_backend_benchmark+0x93e6>
 18dd422:	48 8d 1d 97 68 70 0d 	lea    0xd706897(%rip),%rbx        # efe3cc0 <x86_effects_index>
 18dd429:	ba 40 41 00 00       	mov    $0x4140,%edx
 18dd42e:	48 c7 84 24 c0 00 00 00 00 00 00 00 	movq   $0x0,0xc0(%rsp)
 18dd43a:	31 f6                	xor    %esi,%esi
 18dd43c:	48 89 df             	mov    %rbx,%rdi
 18dd43f:	e8 3c ca eb fe       	call   799e80 <memset@plt>
 18dd444:	c5 fa 6f 05 94 f5 cc fe 	vmovdqu -0x1330a6c(%rip),%xmm0        # 5ac9e0 <x86_effects_unknown>
 18dd44c:	41 bd 01 00 00 00    	mov    $0x1,%r13d
 18dd452:	4c 8d 1d 67 b2 c6 fe 	lea    -0x1394d99(%rip),%r11        # 5486c0 <x86_effects_rows>
 18dd459:	66 b9 01 00          	mov    $0x1,%cx
 18dd45d:	66 b8 13 00          	mov    $0x13,%ax
 18dd461:	4c 8d 0d f8 8f c6 fe 	lea    -0x1397008(%rip),%r9        # 546460 <branch_sizing_patterns+0x7d0>
 18dd468:	4c 8d 35 c9 8f c6 fe 	lea    -0x1397037(%rip),%r14        # 546438 <branch_sizing_patterns+0x7a8>
 18dd46f:	4c 8d 25 ae 8f c6 fe 	lea    -0x1397052(%rip),%r12        # 546424 <branch_sizing_patterns+0x794>
 18dd476:	c5 f9 7f 05 82 a9 70 0d 	vmovdqa %xmm0,0xd70a982(%rip)        # efe7e00 <x86_effects_records>
 18dd47e:	66 90                	xchg   %ax,%ax
 18dd480:	0f b7 c0             	movzwl %ax,%eax
 18dd483:	0f b7 f9             	movzwl %cx,%edi
 18dd486:	45 89 ed             	mov    %r13d,%r13d
 18dd489:	4c 89 5c 24 58       	mov    %r11,0x58(%rsp)
 18dd48e:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
 18dd493:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18dd4a0:	66 83 3c 7b 00       	cmpw   $0x0,(%rbx,%rdi,2)
 18dd4a5:	0f 85 e5 0e 00 00    	jne    18de390 <run_backend_benchmark+0x12c0>
 18dd4ab:	49 81 fd ff 03 00 00 	cmp    $0x3ff,%r13
 18dd4b2:	0f 87 d8 0e 00 00    	ja     18de390 <run_backend_benchmark+0x12c0>
 18dd4b8:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
 18dd4bc:	48 8d 0d dd fa 98 00 	lea    0x98fadd(%rip),%rcx        # 226cfa0 <x86_form_descriptions>
 18dd4c3:	c7 84 24 00 0d 00 00 00 00 00 00 	movl   $0x0,0xd00(%rsp)
 18dd4ce:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 18dd4d7:	4c 89 ac 24 80 00 00 00 	mov    %r13,0x80(%rsp)
 18dd4df:	48 89 bc 24 a0 00 00 00 	mov    %rdi,0xa0(%rsp)
 18dd4e7:	0f b6 74 c1 1b       	movzbl 0x1b(%rcx,%rax,8),%esi
 18dd4ec:	48 8d 14 c1          	lea    (%rcx,%rax,8),%rdx
 18dd4f0:	48 89 94 24 b0 00 00 00 	mov    %rdx,0xb0(%rsp)
 18dd4f8:	ba 00 00 00 00       	mov    $0x0,%edx
 18dd4fd:	48 83 fe 0d          	cmp    $0xd,%rsi
 18dd501:	77 19                	ja     18dd51c <run_backend_benchmark+0x44c>
 18dd503:	48 8d 0d ba 8d c6 fe 	lea    -0x1397246(%rip),%rcx        # 5462c4 <branch_sizing_patterns+0x634>
 18dd50a:	48 8d 1d ff 8e c6 fe 	lea    -0x1397101(%rip),%rbx        # 546410 <branch_sizing_patterns+0x780>
 18dd511:	48 63 04 b1          	movslq (%rcx,%rsi,4),%rax
 18dd515:	48 01 c8             	add    %rcx,%rax
 18dd518:	ff e0                	jmp    *%rax
 18dd51a:	b2 01                	mov    $0x1,%dl
 18dd51c:	41 0f b7 43 06       	movzwl 0x6(%r11),%eax
 18dd521:	41 0f b7 7b 04       	movzwl 0x4(%r11),%edi
 18dd526:	45 31 ff             	xor    %r15d,%r15d
 18dd529:	45 31 d2             	xor    %r10d,%r10d
 18dd52c:	89 44 24 30          	mov    %eax,0x30(%rsp)
 18dd530:	e9 fe 09 00 00       	jmp    18ddf33 <run_backend_benchmark+0xe63>
 18dd535:	b0 05                	mov    $0x5,%al
 18dd537:	eb 02                	jmp    18dd53b <run_backend_benchmark+0x46b>
 18dd539:	b0 04                	mov    $0x4,%al
 18dd53b:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18dd540:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 18dd545:	be 02 00 00 00       	mov    $0x2,%esi
 18dd54a:	88 84 24 01 0d 00 00 	mov    %al,0xd01(%rsp)
 18dd551:	31 c0                	xor    %eax,%eax
 18dd553:	eb 5f                	jmp    18dd5b4 <run_backend_benchmark+0x4e4>
 18dd555:	41 0f b6 4b 0b       	movzbl 0xb(%r11),%ecx
 18dd55a:	41 0f b7 7b 04       	movzwl 0x4(%r11),%edi
 18dd55f:	45 0f b7 7b 06       	movzwl 0x6(%r11),%r15d
 18dd564:	be 02 00 00 00       	mov    $0x2,%esi
 18dd569:	c6 84 24 01 0d 00 00 05 	movb   $0x5,0xd01(%rsp)
 18dd571:	45 31 d2             	xor    %r10d,%r10d
 18dd574:	8d 41 ff             	lea    -0x1(%rcx),%eax
 18dd577:	3c 04                	cmp    $0x4,%al
 18dd579:	73 1f                	jae    18dd59a <run_backend_benchmark+0x4ca>
 18dd57b:	0f b6 c0             	movzbl %al,%eax
 18dd57e:	48 8d 15 f7 96 cd fe 	lea    -0x1326909(%rip),%rdx        # 5b6c7c <tier0_generate_expression.floating_operations+0x8>
 18dd585:	4c 8d 05 f4 96 cd fe 	lea    -0x132690c(%rip),%r8        # 5b6c80 <tier0_generate_expression.floating_operations+0xc>
 18dd58c:	0f b6 14 10          	movzbl (%rax,%rdx,1),%edx
 18dd590:	42 0f b6 04 00       	movzbl (%rax,%r8,1),%eax
 18dd595:	09 c7                	or     %eax,%edi
 18dd597:	41 09 d7             	or     %edx,%r15d
 18dd59a:	44 89 7c 24 30       	mov    %r15d,0x30(%rsp)
 18dd59f:	45 31 ff             	xor    %r15d,%r15d
 18dd5a2:	0f b6 c1             	movzbl %cl,%eax
 18dd5a5:	8d 48 ff             	lea    -0x1(%rax),%ecx
 18dd5a8:	83 f9 03             	cmp    $0x3,%ecx
 18dd5ab:	72 5e                	jb     18dd60b <run_backend_benchmark+0x53b>
 18dd5ad:	e9 b4 04 00 00       	jmp    18dda66 <run_backend_benchmark+0x996>
 18dd5b2:	b0 01                	mov    $0x1,%al
 18dd5b4:	41 0f b6 4b 0b       	movzbl 0xb(%r11),%ecx
 18dd5b9:	41 bf 00 00 00 00    	mov    $0x0,%r15d
 18dd5bf:	45 31 d2             	xor    %r10d,%r10d
 18dd5c2:	8d 51 ff             	lea    -0x1(%rcx),%edx
 18dd5c5:	80 fa 04             	cmp    $0x4,%dl
 18dd5c8:	73 0f                	jae    18dd5d9 <run_backend_benchmark+0x509>
 18dd5ca:	0f b6 d2             	movzbl %dl,%edx
 18dd5cd:	48 8d 3d a4 96 cd fe 	lea    -0x132695c(%rip),%rdi        # 5b6c78 <tier0_generate_expression.floating_operations+0x4>
 18dd5d4:	44 0f b6 3c 3a       	movzbl (%rdx,%rdi,1),%r15d
 18dd5d9:	41 0f b7 53 06       	movzwl 0x6(%r11),%edx
 18dd5de:	41 0f b7 7b 04       	movzwl 0x4(%r11),%edi
 18dd5e3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 18dd5e9:	4c 89 44 24 40       	mov    %r8,0x40(%rsp)
 18dd5ee:	89 54 24 30          	mov    %edx,0x30(%rsp)
 18dd5f2:	b2 01                	mov    $0x1,%dl
 18dd5f4:	84 c0                	test   %al,%al
 18dd5f6:	0f 85 37 09 00 00    	jne    18ddf33 <run_backend_benchmark+0xe63>
 18dd5fc:	0f b6 c1             	movzbl %cl,%eax
 18dd5ff:	8d 48 ff             	lea    -0x1(%rax),%ecx
 18dd602:	83 f9 03             	cmp    $0x3,%ecx
 18dd605:	0f 83 5b 04 00 00    	jae    18dda66 <run_backend_benchmark+0x996>
 18dd60b:	4c 8d 6e ff          	lea    -0x1(%rsi),%r13
 18dd60f:	48 8d 15 36 8e c6 fe 	lea    -0x13971ca(%rip),%rdx        # 54644c <branch_sizing_patterns+0x7bc>
 18dd616:	83 c6 fe             	add    $0xfffffffe,%esi
 18dd619:	45 89 eb             	mov    %r13d,%r11d
 18dd61c:	41 83 e3 07          	and    $0x7,%r11d
 18dd620:	83 fe 07             	cmp    $0x7,%esi
 18dd623:	73 0c                	jae    18dd631 <run_backend_benchmark+0x561>
 18dd625:	b9 01 00 00 00       	mov    $0x1,%ecx
 18dd62a:	31 f6                	xor    %esi,%esi
 18dd62c:	e9 4b 03 00 00       	jmp    18dd97c <run_backend_benchmark+0x8ac>
 18dd631:	49 83 e5 f8          	and    $0xfffffffffffffff8,%r13
 18dd635:	48 8d 35 c0 8d c6 fe 	lea    -0x1397240(%rip),%rsi        # 5463fc <branch_sizing_patterns+0x76c>
 18dd63c:	31 c9                	xor    %ecx,%ecx
 18dd63e:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 18dd647:	eb 14                	jmp    18dd65d <run_backend_benchmark+0x58d>
 18dd649:	83 cf 02             	or     $0x2,%edi
 18dd64c:	0f 1f 40 00          	nopl   0x0(%rax)
 18dd650:	48 83 c1 08          	add    $0x8,%rcx
 18dd654:	49 39 cd             	cmp    %rcx,%r13
 18dd657:	0f 84 0e 03 00 00    	je     18dd96b <run_backend_benchmark+0x89b>
 18dd65d:	0f b6 84 0c 01 0d 00 00 	movzbl 0xd01(%rsp,%rcx,1),%eax
 18dd665:	48 83 f8 04          	cmp    $0x4,%rax
 18dd669:	77 65                	ja     18dd6d0 <run_backend_benchmark+0x600>
 18dd66b:	4c 8d 05 4e 8d c6 fe 	lea    -0x13972b2(%rip),%r8        # 5463c0 <branch_sizing_patterns+0x730>
 18dd672:	49 63 04 80          	movslq (%r8,%rax,4),%rax
 18dd676:	4c 01 c0             	add    %r8,%rax
 18dd679:	ff e0                	jmp    *%rax
 18dd67b:	41 83 ca 01          	or     $0x1,%r10d
 18dd67f:	0f b6 84 0c 02 0d 00 00 	movzbl 0xd02(%rsp,%rcx,1),%eax
 18dd687:	48 83 f8 04          	cmp    $0x4,%rax
 18dd68b:	76 51                	jbe    18dd6de <run_backend_benchmark+0x60e>
 18dd68d:	e9 9e 00 00 00       	jmp    18dd730 <run_backend_benchmark+0x660>
 18dd692:	83 cf 02             	or     $0x2,%edi
 18dd695:	0f b6 84 0c 02 0d 00 00 	movzbl 0xd02(%rsp,%rcx,1),%eax
 18dd69d:	48 83 f8 04          	cmp    $0x4,%rax
 18dd6a1:	76 3b                	jbe    18dd6de <run_backend_benchmark+0x60e>
 18dd6a3:	e9 88 00 00 00       	jmp    18dd730 <run_backend_benchmark+0x660>
 18dd6a8:	b8 01 00 00 00       	mov    $0x1,%eax
 18dd6ad:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18dd6b2:	0f b6 84 0c 02 0d 00 00 	movzbl 0xd02(%rsp,%rcx,1),%eax
 18dd6ba:	48 83 f8 04          	cmp    $0x4,%rax
 18dd6be:	76 1e                	jbe    18dd6de <run_backend_benchmark+0x60e>
 18dd6c0:	eb 6e                	jmp    18dd730 <run_backend_benchmark+0x660>
 18dd6c2:	83 cf 01             	or     $0x1,%edi
 18dd6c5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18dd6d0:	0f b6 84 0c 02 0d 00 00 	movzbl 0xd02(%rsp,%rcx,1),%eax
 18dd6d8:	48 83 f8 04          	cmp    $0x4,%rax
 18dd6dc:	77 52                	ja     18dd730 <run_backend_benchmark+0x660>
 18dd6de:	4c 8d 05 ef 8c c6 fe 	lea    -0x1397311(%rip),%r8        # 5463d4 <branch_sizing_patterns+0x744>
 18dd6e5:	49 63 04 80          	movslq (%r8,%rax,4),%rax
 18dd6e9:	4c 01 c0             	add    %r8,%rax
 18dd6ec:	ff e0                	jmp    *%rax
 18dd6ee:	41 83 ca 01          	or     $0x1,%r10d
 18dd6f2:	eb 3c                	jmp    18dd730 <run_backend_benchmark+0x660>
 18dd6f4:	83 cf 02             	or     $0x2,%edi
 18dd6f7:	eb 37                	jmp    18dd730 <run_backend_benchmark+0x660>
 18dd6f9:	b8 01 00 00 00       	mov    $0x1,%eax
 18dd6fe:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18dd703:	eb 2b                	jmp    18dd730 <run_backend_benchmark+0x660>
 18dd705:	83 cf 01             	or     $0x1,%edi
 18dd708:	eb 26                	jmp    18dd730 <run_backend_benchmark+0x660>
 18dd70a:	41 83 cf 01          	or     $0x1,%r15d
 18dd70e:	0f b6 84 0c 02 0d 00 00 	movzbl 0xd02(%rsp,%rcx,1),%eax
 18dd716:	48 83 f8 04          	cmp    $0x4,%rax
 18dd71a:	76 c2                	jbe    18dd6de <run_backend_benchmark+0x60e>
 18dd71c:	eb 12                	jmp    18dd730 <run_backend_benchmark+0x660>
 18dd71e:	41 83 cf 01          	or     $0x1,%r15d
 18dd722:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18dd730:	0f b6 84 0c 03 0d 00 00 	movzbl 0xd03(%rsp,%rcx,1),%eax
 18dd738:	48 83 f8 04          	cmp    $0x4,%rax
 18dd73c:	77 62                	ja     18dd7a0 <run_backend_benchmark+0x6d0>
 18dd73e:	4c 8d 05 a3 8c c6 fe 	lea    -0x139735d(%rip),%r8        # 5463e8 <branch_sizing_patterns+0x758>
 18dd745:	49 63 04 80          	movslq (%r8,%rax,4),%rax
 18dd749:	4c 01 c0             	add    %r8,%rax
 18dd74c:	ff e0                	jmp    *%rax
 18dd74e:	41 83 ca 01          	or     $0x1,%r10d
 18dd752:	0f b6 84 0c 04 0d 00 00 	movzbl 0xd04(%rsp,%rcx,1),%eax
 18dd75a:	48 83 f8 04          	cmp    $0x4,%rax
 18dd75e:	76 4e                	jbe    18dd7ae <run_backend_benchmark+0x6de>
 18dd760:	e9 8b 00 00 00       	jmp    18dd7f0 <run_backend_benchmark+0x720>
 18dd765:	83 cf 02             	or     $0x2,%edi
 18dd768:	0f b6 84 0c 04 0d 00 00 	movzbl 0xd04(%rsp,%rcx,1),%eax
 18dd770:	48 83 f8 04          	cmp    $0x4,%rax
 18dd774:	76 38                	jbe    18dd7ae <run_backend_benchmark+0x6de>
 18dd776:	eb 78                	jmp    18dd7f0 <run_backend_benchmark+0x720>
 18dd778:	b8 01 00 00 00       	mov    $0x1,%eax
 18dd77d:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18dd782:	0f b6 84 0c 04 0d 00 00 	movzbl 0xd04(%rsp,%rcx,1),%eax
 18dd78a:	48 83 f8 04          	cmp    $0x4,%rax
 18dd78e:	76 1e                	jbe    18dd7ae <run_backend_benchmark+0x6de>
 18dd790:	eb 5e                	jmp    18dd7f0 <run_backend_benchmark+0x720>
 18dd792:	83 cf 01             	or     $0x1,%edi
 18dd795:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18dd7a0:	0f b6 84 0c 04 0d 00 00 	movzbl 0xd04(%rsp,%rcx,1),%eax
 18dd7a8:	48 83 f8 04          	cmp    $0x4,%rax
 18dd7ac:	77 42                	ja     18dd7f0 <run_backend_benchmark+0x720>
 18dd7ae:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18dd7b2:	48 01 f0             	add    %rsi,%rax
 18dd7b5:	ff e0                	jmp    *%rax
 18dd7b7:	41 83 ca 01          	or     $0x1,%r10d
 18dd7bb:	eb 33                	jmp    18dd7f0 <run_backend_benchmark+0x720>
 18dd7bd:	83 cf 02             	or     $0x2,%edi
 18dd7c0:	eb 2e                	jmp    18dd7f0 <run_backend_benchmark+0x720>
 18dd7c2:	b8 01 00 00 00       	mov    $0x1,%eax
 18dd7c7:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18dd7cc:	eb 22                	jmp    18dd7f0 <run_backend_benchmark+0x720>
 18dd7ce:	83 cf 01             	or     $0x1,%edi
 18dd7d1:	eb 1d                	jmp    18dd7f0 <run_backend_benchmark+0x720>
 18dd7d3:	41 83 cf 01          	or     $0x1,%r15d
 18dd7d7:	0f b6 84 0c 04 0d 00 00 	movzbl 0xd04(%rsp,%rcx,1),%eax
 18dd7df:	48 83 f8 04          	cmp    $0x4,%rax
 18dd7e3:	76 c9                	jbe    18dd7ae <run_backend_benchmark+0x6de>
 18dd7e5:	eb 09                	jmp    18dd7f0 <run_backend_benchmark+0x720>
 18dd7e7:	41 83 cf 01          	or     $0x1,%r15d
 18dd7eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18dd7f0:	0f b6 84 0c 05 0d 00 00 	movzbl 0xd05(%rsp,%rcx,1),%eax
 18dd7f8:	48 83 f8 04          	cmp    $0x4,%rax
 18dd7fc:	77 52                	ja     18dd850 <run_backend_benchmark+0x780>
 18dd7fe:	48 63 04 83          	movslq (%rbx,%rax,4),%rax
 18dd802:	48 01 d8             	add    %rbx,%rax
 18dd805:	ff e0                	jmp    *%rax
 18dd807:	41 83 ca 01          	or     $0x1,%r10d
 18dd80b:	0f b6 84 0c 06 0d 00 00 	movzbl 0xd06(%rsp,%rcx,1),%eax
 18dd813:	48 83 f8 04          	cmp    $0x4,%rax
 18dd817:	76 45                	jbe    18dd85e <run_backend_benchmark+0x78e>
 18dd819:	e9 82 00 00 00       	jmp    18dd8a0 <run_backend_benchmark+0x7d0>
 18dd81e:	83 cf 02             	or     $0x2,%edi
 18dd821:	0f b6 84 0c 06 0d 00 00 	movzbl 0xd06(%rsp,%rcx,1),%eax
 18dd829:	48 83 f8 04          	cmp    $0x4,%rax
 18dd82d:	76 2f                	jbe    18dd85e <run_backend_benchmark+0x78e>
 18dd82f:	eb 6f                	jmp    18dd8a0 <run_backend_benchmark+0x7d0>
 18dd831:	b8 01 00 00 00       	mov    $0x1,%eax
 18dd836:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18dd83b:	0f b6 84 0c 06 0d 00 00 	movzbl 0xd06(%rsp,%rcx,1),%eax
 18dd843:	48 83 f8 04          	cmp    $0x4,%rax
 18dd847:	76 15                	jbe    18dd85e <run_backend_benchmark+0x78e>
 18dd849:	eb 55                	jmp    18dd8a0 <run_backend_benchmark+0x7d0>
 18dd84b:	83 cf 01             	or     $0x1,%edi
 18dd84e:	66 90                	xchg   %ax,%ax
 18dd850:	0f b6 84 0c 06 0d 00 00 	movzbl 0xd06(%rsp,%rcx,1),%eax
 18dd858:	48 83 f8 04          	cmp    $0x4,%rax
 18dd85c:	77 42                	ja     18dd8a0 <run_backend_benchmark+0x7d0>
 18dd85e:	49 63 04 84          	movslq (%r12,%rax,4),%rax
 18dd862:	4c 01 e0             	add    %r12,%rax
 18dd865:	ff e0                	jmp    *%rax
 18dd867:	41 83 ca 01          	or     $0x1,%r10d
 18dd86b:	eb 33                	jmp    18dd8a0 <run_backend_benchmark+0x7d0>
 18dd86d:	83 cf 02             	or     $0x2,%edi
 18dd870:	eb 2e                	jmp    18dd8a0 <run_backend_benchmark+0x7d0>
 18dd872:	b8 01 00 00 00       	mov    $0x1,%eax
 18dd877:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18dd87c:	eb 22                	jmp    18dd8a0 <run_backend_benchmark+0x7d0>
 18dd87e:	83 cf 01             	or     $0x1,%edi
 18dd881:	eb 1d                	jmp    18dd8a0 <run_backend_benchmark+0x7d0>
 18dd883:	41 83 cf 01          	or     $0x1,%r15d
 18dd887:	0f b6 84 0c 06 0d 00 00 	movzbl 0xd06(%rsp,%rcx,1),%eax
 18dd88f:	48 83 f8 04          	cmp    $0x4,%rax
 18dd893:	76 c9                	jbe    18dd85e <run_backend_benchmark+0x78e>
 18dd895:	eb 09                	jmp    18dd8a0 <run_backend_benchmark+0x7d0>
 18dd897:	41 83 cf 01          	or     $0x1,%r15d
 18dd89b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18dd8a0:	0f b6 84 0c 07 0d 00 00 	movzbl 0xd07(%rsp,%rcx,1),%eax
 18dd8a8:	48 83 f8 04          	cmp    $0x4,%rax
 18dd8ac:	77 62                	ja     18dd910 <run_backend_benchmark+0x840>
 18dd8ae:	49 63 04 86          	movslq (%r14,%rax,4),%rax
 18dd8b2:	4c 01 f0             	add    %r14,%rax
 18dd8b5:	ff e0                	jmp    *%rax
 18dd8b7:	41 83 ca 01          	or     $0x1,%r10d
 18dd8bb:	0f b6 84 0c 08 0d 00 00 	movzbl 0xd08(%rsp,%rcx,1),%eax
 18dd8c3:	48 83 f8 04          	cmp    $0x4,%rax
 18dd8c7:	76 59                	jbe    18dd922 <run_backend_benchmark+0x852>
 18dd8c9:	e9 82 fd ff ff       	jmp    18dd650 <run_backend_benchmark+0x580>
 18dd8ce:	83 cf 02             	or     $0x2,%edi
 18dd8d1:	0f b6 84 0c 08 0d 00 00 	movzbl 0xd08(%rsp,%rcx,1),%eax
 18dd8d9:	48 83 f8 04          	cmp    $0x4,%rax
 18dd8dd:	76 43                	jbe    18dd922 <run_backend_benchmark+0x852>
 18dd8df:	e9 6c fd ff ff       	jmp    18dd650 <run_backend_benchmark+0x580>
 18dd8e4:	b8 01 00 00 00       	mov    $0x1,%eax
 18dd8e9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18dd8ee:	0f b6 84 0c 08 0d 00 00 	movzbl 0xd08(%rsp,%rcx,1),%eax
 18dd8f6:	48 83 f8 04          	cmp    $0x4,%rax
 18dd8fa:	76 26                	jbe    18dd922 <run_backend_benchmark+0x852>
 18dd8fc:	e9 4f fd ff ff       	jmp    18dd650 <run_backend_benchmark+0x580>
 18dd901:	83 cf 01             	or     $0x1,%edi
 18dd904:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 18dd910:	0f b6 84 0c 08 0d 00 00 	movzbl 0xd08(%rsp,%rcx,1),%eax
 18dd918:	48 83 f8 04          	cmp    $0x4,%rax
 18dd91c:	0f 87 2e fd ff ff    	ja     18dd650 <run_backend_benchmark+0x580>
 18dd922:	48 63 04 82          	movslq (%rdx,%rax,4),%rax
 18dd926:	48 01 d0             	add    %rdx,%rax
 18dd929:	ff e0                	jmp    *%rax
 18dd92b:	41 83 ca 01          	or     $0x1,%r10d
 18dd92f:	e9 1c fd ff ff       	jmp    18dd650 <run_backend_benchmark+0x580>
 18dd934:	b8 01 00 00 00       	mov    $0x1,%eax
 18dd939:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18dd93e:	e9 0d fd ff ff       	jmp    18dd650 <run_backend_benchmark+0x580>
 18dd943:	83 cf 01             	or     $0x1,%edi
 18dd946:	e9 05 fd ff ff       	jmp    18dd650 <run_backend_benchmark+0x580>
 18dd94b:	41 83 cf 01          	or     $0x1,%r15d
 18dd94f:	0f b6 84 0c 08 0d 00 00 	movzbl 0xd08(%rsp,%rcx,1),%eax
 18dd957:	48 83 f8 04          	cmp    $0x4,%rax
 18dd95b:	76 c5                	jbe    18dd922 <run_backend_benchmark+0x852>
 18dd95d:	e9 ee fc ff ff       	jmp    18dd650 <run_backend_benchmark+0x580>
 18dd962:	41 83 cf 01          	or     $0x1,%r15d
 18dd966:	e9 e5 fc ff ff       	jmp    18dd650 <run_backend_benchmark+0x580>
 18dd96b:	4d 85 db             	test   %r11,%r11
 18dd96e:	0f 84 b8 05 00 00    	je     18ddf2c <run_backend_benchmark+0xe5c>
 18dd974:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 18dd979:	48 ff c1             	inc    %rcx
 18dd97c:	48 8d 8c 0c 00 0d 00 00 	lea    0xd00(%rsp,%rcx,1),%rcx
 18dd984:	31 d2                	xor    %edx,%edx
 18dd986:	eb 10                	jmp    18dd998 <run_backend_benchmark+0x8c8>
 18dd988:	83 cf 02             	or     $0x2,%edi
 18dd98b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18dd990:	48 ff c2             	inc    %rdx
 18dd993:	49 39 d3             	cmp    %rdx,%r11
 18dd996:	74 38                	je     18dd9d0 <run_backend_benchmark+0x900>
 18dd998:	0f b6 04 11          	movzbl (%rcx,%rdx,1),%eax
 18dd99c:	48 83 f8 04          	cmp    $0x4,%rax
 18dd9a0:	77 ee                	ja     18dd990 <run_backend_benchmark+0x8c0>
 18dd9a2:	49 63 04 81          	movslq (%r9,%rax,4),%rax
 18dd9a6:	4c 01 c8             	add    %r9,%rax
 18dd9a9:	ff e0                	jmp    *%rax
 18dd9ab:	41 83 ca 01          	or     $0x1,%r10d
 18dd9af:	eb df                	jmp    18dd990 <run_backend_benchmark+0x8c0>
 18dd9b1:	be 01 00 00 00       	mov    $0x1,%esi
 18dd9b6:	eb d8                	jmp    18dd990 <run_backend_benchmark+0x8c0>
 18dd9b8:	83 cf 01             	or     $0x1,%edi
 18dd9bb:	eb d3                	jmp    18dd990 <run_backend_benchmark+0x8c0>
 18dd9bd:	41 83 cf 01          	or     $0x1,%r15d
 18dd9c1:	eb cd                	jmp    18dd990 <run_backend_benchmark+0x8c0>
 18dd9c3:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18dd9d0:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
 18dd9d5:	e9 52 05 00 00       	jmp    18ddf2c <run_backend_benchmark+0xe5c>
 18dd9da:	66 c7 84 24 01 0d 00 00 01 05 	movw   $0x501,0xd01(%rsp)
 18dd9e4:	be 03 00 00 00       	mov    $0x3,%esi
 18dd9e9:	eb 0d                	jmp    18dd9f8 <run_backend_benchmark+0x928>
 18dd9eb:	be 02 00 00 00       	mov    $0x2,%esi
 18dd9f0:	c6 84 24 01 0d 00 00 01 	movb   $0x1,0xd01(%rsp)
 18dd9f8:	41 0f b7 43 06       	movzwl 0x6(%r11),%eax
 18dd9fd:	41 0f b6 4b 0b       	movzbl 0xb(%r11),%ecx
 18dda02:	41 0f b7 7b 04       	movzwl 0x4(%r11),%edi
 18dda07:	45 31 ff             	xor    %r15d,%r15d
 18dda0a:	89 44 24 30          	mov    %eax,0x30(%rsp)
 18dda0e:	89 c8                	mov    %ecx,%eax
 18dda10:	ff c8                	dec    %eax
 18dda12:	83 f8 03             	cmp    $0x3,%eax
 18dda15:	77 3d                	ja     18dda54 <run_backend_benchmark+0x984>
 18dda17:	48 8d 15 de 88 c6 fe 	lea    -0x1397722(%rip),%rdx        # 5462fc <branch_sizing_patterns+0x66c>
 18dda1e:	48 63 04 82          	movslq (%rdx,%rax,4),%rax
 18dda22:	48 01 d0             	add    %rdx,%rax
 18dda25:	ff e0                	jmp    *%rax
 18dda27:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18dda2d:	0f b6 c1             	movzbl %cl,%eax
 18dda30:	8d 48 ff             	lea    -0x1(%rax),%ecx
 18dda33:	83 f9 03             	cmp    $0x3,%ecx
 18dda36:	0f 82 cf fb ff ff    	jb     18dd60b <run_backend_benchmark+0x53b>
 18dda3c:	eb 28                	jmp    18dda66 <run_backend_benchmark+0x996>
 18dda3e:	41 ba 01 00 00 00    	mov    $0x1,%r10d
 18dda44:	e9 c2 fb ff ff       	jmp    18dd60b <run_backend_benchmark+0x53b>
 18dda49:	41 ba 02 00 00 00    	mov    $0x2,%r10d
 18dda4f:	e9 b7 fb ff ff       	jmp    18dd60b <run_backend_benchmark+0x53b>
 18dda54:	45 31 d2             	xor    %r10d,%r10d
 18dda57:	0f b6 c1             	movzbl %cl,%eax
 18dda5a:	8d 48 ff             	lea    -0x1(%rax),%ecx
 18dda5d:	83 f9 03             	cmp    $0x3,%ecx
 18dda60:	0f 82 a5 fb ff ff    	jb     18dd60b <run_backend_benchmark+0x53b>
 18dda66:	83 f8 04             	cmp    $0x4,%eax
 18dda69:	75 30                	jne    18dda9b <run_backend_benchmark+0x9cb>
 18dda6b:	44 8b 4c 24 30       	mov    0x30(%rsp),%r9d
 18dda70:	48 8d 4e ff          	lea    -0x1(%rsi),%rcx
 18dda74:	83 c6 fe             	add    $0xfffffffe,%esi
 18dda77:	48 8d 15 1a 89 c6 fe 	lea    -0x13976e6(%rip),%rdx        # 546398 <branch_sizing_patterns+0x708>
 18dda7e:	41 89 cb             	mov    %ecx,%r11d
 18dda81:	41 83 e3 07          	and    $0x7,%r11d
 18dda85:	83 fe 07             	cmp    $0x7,%esi
 18dda88:	0f 83 d4 00 00 00    	jae    18ddb62 <run_backend_benchmark+0xa92>
 18dda8e:	41 bd 01 00 00 00    	mov    $0x1,%r13d
 18dda94:	31 db                	xor    %ebx,%ebx
 18dda96:	e9 2f 04 00 00       	jmp    18ddeca <run_backend_benchmark+0xdfa>
 18dda9b:	48 8d 56 ff          	lea    -0x1(%rsi),%rdx
 18dda9f:	83 c6 fe             	add    $0xfffffffe,%esi
 18ddaa2:	b8 01 00 00 00       	mov    $0x1,%eax
 18ddaa7:	89 d1                	mov    %edx,%ecx
 18ddaa9:	83 e1 07             	and    $0x7,%ecx
 18ddaac:	83 fe 07             	cmp    $0x7,%esi
 18ddaaf:	72 7d                	jb     18ddb2e <run_backend_benchmark+0xa5e>
 18ddab1:	48 83 e2 f8          	and    $0xfffffffffffffff8,%rdx
 18ddab5:	31 c0                	xor    %eax,%eax
 18ddab7:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18ddac0:	89 fe                	mov    %edi,%esi
 18ddac2:	83 ce 02             	or     $0x2,%esi
 18ddac5:	80 bc 04 01 0d 00 00 04 	cmpb   $0x4,0xd01(%rsp,%rax,1)
 18ddacd:	0f 44 fe             	cmove  %esi,%edi
 18ddad0:	80 bc 04 02 0d 00 00 04 	cmpb   $0x4,0xd02(%rsp,%rax,1)
 18ddad8:	0f 44 fe             	cmove  %esi,%edi
 18ddadb:	80 bc 04 03 0d 00 00 04 	cmpb   $0x4,0xd03(%rsp,%rax,1)
 18ddae3:	0f 44 fe             	cmove  %esi,%edi
 18ddae6:	80 bc 04 04 0d 00 00 04 	cmpb   $0x4,0xd04(%rsp,%rax,1)
 18ddaee:	0f 44 fe             	cmove  %esi,%edi
 18ddaf1:	80 bc 04 05 0d 00 00 04 	cmpb   $0x4,0xd05(%rsp,%rax,1)
 18ddaf9:	0f 44 fe             	cmove  %esi,%edi
 18ddafc:	80 bc 04 06 0d 00 00 04 	cmpb   $0x4,0xd06(%rsp,%rax,1)
 18ddb04:	0f 44 fe             	cmove  %esi,%edi
 18ddb07:	80 bc 04 07 0d 00 00 04 	cmpb   $0x4,0xd07(%rsp,%rax,1)
 18ddb0f:	0f 44 fe             	cmove  %esi,%edi
 18ddb12:	80 bc 04 08 0d 00 00 04 	cmpb   $0x4,0xd08(%rsp,%rax,1)
 18ddb1a:	0f 44 fe             	cmove  %esi,%edi
 18ddb1d:	48 83 c0 08          	add    $0x8,%rax
 18ddb21:	48 39 c2             	cmp    %rax,%rdx
 18ddb24:	75 9a                	jne    18ddac0 <run_backend_benchmark+0x9f0>
 18ddb26:	48 85 c9             	test   %rcx,%rcx
 18ddb29:	74 29                	je     18ddb54 <run_backend_benchmark+0xa84>
 18ddb2b:	48 ff c0             	inc    %rax
 18ddb2e:	48 8d 84 04 00 0d 00 00 	lea    0xd00(%rsp,%rax,1),%rax
 18ddb36:	31 d2                	xor    %edx,%edx
 18ddb38:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18ddb40:	89 fe                	mov    %edi,%esi
 18ddb42:	83 cf 02             	or     $0x2,%edi
 18ddb45:	80 3c 10 04          	cmpb   $0x4,(%rax,%rdx,1)
 18ddb49:	0f 45 fe             	cmovne %esi,%edi
 18ddb4c:	48 ff c2             	inc    %rdx
 18ddb4f:	48 39 d1             	cmp    %rdx,%rcx
 18ddb52:	75 ec                	jne    18ddb40 <run_backend_benchmark+0xa70>
 18ddb54:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 18ddb5d:	e9 cf 03 00 00       	jmp    18ddf31 <run_backend_benchmark+0xe61>
 18ddb62:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 18ddb66:	31 db                	xor    %ebx,%ebx
 18ddb68:	45 31 ed             	xor    %r13d,%r13d
 18ddb6b:	eb 10                	jmp    18ddb7d <run_backend_benchmark+0xaad>
 18ddb6d:	83 cf 02             	or     $0x2,%edi
 18ddb70:	49 83 c5 08          	add    $0x8,%r13
 18ddb74:	4c 39 e9             	cmp    %r13,%rcx
 18ddb77:	0f 84 45 03 00 00    	je     18ddec2 <run_backend_benchmark+0xdf2>
 18ddb7d:	42 0f b6 84 2c 01 0d 00 00 	movzbl 0xd01(%rsp,%r13,1),%eax
 18ddb86:	48 83 f8 04          	cmp    $0x4,%rax
 18ddb8a:	77 64                	ja     18ddbf0 <run_backend_benchmark+0xb20>
 18ddb8c:	48 8d 35 79 87 c6 fe 	lea    -0x1397887(%rip),%rsi        # 54630c <branch_sizing_patterns+0x67c>
 18ddb93:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18ddb97:	48 01 f0             	add    %rsi,%rax
 18ddb9a:	ff e0                	jmp    *%rax
 18ddb9c:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18ddba2:	42 0f b6 84 2c 02 0d 00 00 	movzbl 0xd02(%rsp,%r13,1),%eax
 18ddbab:	48 83 f8 04          	cmp    $0x4,%rax
 18ddbaf:	76 4e                	jbe    18ddbff <run_backend_benchmark+0xb2f>
 18ddbb1:	e9 9a 00 00 00       	jmp    18ddc50 <run_backend_benchmark+0xb80>
 18ddbb6:	83 cf 02             	or     $0x2,%edi
 18ddbb9:	42 0f b6 84 2c 02 0d 00 00 	movzbl 0xd02(%rsp,%r13,1),%eax
 18ddbc2:	48 83 f8 04          	cmp    $0x4,%rax
 18ddbc6:	76 37                	jbe    18ddbff <run_backend_benchmark+0xb2f>
 18ddbc8:	e9 83 00 00 00       	jmp    18ddc50 <run_backend_benchmark+0xb80>
 18ddbcd:	bb 03 00 00 00       	mov    $0x3,%ebx
 18ddbd2:	42 0f b6 84 2c 02 0d 00 00 	movzbl 0xd02(%rsp,%r13,1),%eax
 18ddbdb:	48 83 f8 04          	cmp    $0x4,%rax
 18ddbdf:	76 1e                	jbe    18ddbff <run_backend_benchmark+0xb2f>
 18ddbe1:	eb 6d                	jmp    18ddc50 <run_backend_benchmark+0xb80>
 18ddbe3:	41 83 c9 01          	or     $0x1,%r9d
 18ddbe7:	83 cf 01             	or     $0x1,%edi
 18ddbea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 18ddbf0:	42 0f b6 84 2c 02 0d 00 00 	movzbl 0xd02(%rsp,%r13,1),%eax
 18ddbf9:	48 83 f8 04          	cmp    $0x4,%rax
 18ddbfd:	77 51                	ja     18ddc50 <run_backend_benchmark+0xb80>
 18ddbff:	48 8d 35 1a 87 c6 fe 	lea    -0x13978e6(%rip),%rsi        # 546320 <branch_sizing_patterns+0x690>
 18ddc06:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18ddc0a:	48 01 f0             	add    %rsi,%rax
 18ddc0d:	ff e0                	jmp    *%rax
 18ddc0f:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18ddc15:	eb 39                	jmp    18ddc50 <run_backend_benchmark+0xb80>
 18ddc17:	83 cf 02             	or     $0x2,%edi
 18ddc1a:	eb 34                	jmp    18ddc50 <run_backend_benchmark+0xb80>
 18ddc1c:	bb 03 00 00 00       	mov    $0x3,%ebx
 18ddc21:	eb 2d                	jmp    18ddc50 <run_backend_benchmark+0xb80>
 18ddc23:	41 83 c9 01          	or     $0x1,%r9d
 18ddc27:	83 cf 01             	or     $0x1,%edi
 18ddc2a:	eb 24                	jmp    18ddc50 <run_backend_benchmark+0xb80>
 18ddc2c:	41 bf 03 00 00 00    	mov    $0x3,%r15d
 18ddc32:	42 0f b6 84 2c 02 0d 00 00 	movzbl 0xd02(%rsp,%r13,1),%eax
 18ddc3b:	48 83 f8 04          	cmp    $0x4,%rax
 18ddc3f:	76 be                	jbe    18ddbff <run_backend_benchmark+0xb2f>
 18ddc41:	eb 0d                	jmp    18ddc50 <run_backend_benchmark+0xb80>
 18ddc43:	41 bf 03 00 00 00    	mov    $0x3,%r15d
 18ddc49:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18ddc50:	42 0f b6 84 2c 03 0d 00 00 	movzbl 0xd03(%rsp,%r13,1),%eax
 18ddc59:	48 83 f8 04          	cmp    $0x4,%rax
 18ddc5d:	77 61                	ja     18ddcc0 <run_backend_benchmark+0xbf0>
 18ddc5f:	48 8d 35 ce 86 c6 fe 	lea    -0x1397932(%rip),%rsi        # 546334 <branch_sizing_patterns+0x6a4>
 18ddc66:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18ddc6a:	48 01 f0             	add    %rsi,%rax
 18ddc6d:	ff e0                	jmp    *%rax
 18ddc6f:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18ddc75:	42 0f b6 84 2c 04 0d 00 00 	movzbl 0xd04(%rsp,%r13,1),%eax
 18ddc7e:	48 83 f8 04          	cmp    $0x4,%rax
 18ddc82:	76 4b                	jbe    18ddccf <run_backend_benchmark+0xbff>
 18ddc84:	e9 97 00 00 00       	jmp    18ddd20 <run_backend_benchmark+0xc50>
 18ddc89:	83 cf 02             	or     $0x2,%edi
 18ddc8c:	42 0f b6 84 2c 04 0d 00 00 	movzbl 0xd04(%rsp,%r13,1),%eax
 18ddc95:	48 83 f8 04          	cmp    $0x4,%rax
 18ddc99:	76 34                	jbe    18ddccf <run_backend_benchmark+0xbff>
 18ddc9b:	e9 80 00 00 00       	jmp    18ddd20 <run_backend_benchmark+0xc50>
 18ddca0:	bb 03 00 00 00       	mov    $0x3,%ebx
 18ddca5:	42 0f b6 84 2c 04 0d 00 00 	movzbl 0xd04(%rsp,%r13,1),%eax
 18ddcae:	48 83 f8 04          	cmp    $0x4,%rax
 18ddcb2:	76 1b                	jbe    18ddccf <run_backend_benchmark+0xbff>
 18ddcb4:	eb 6a                	jmp    18ddd20 <run_backend_benchmark+0xc50>
 18ddcb6:	41 83 c9 01          	or     $0x1,%r9d
 18ddcba:	83 cf 01             	or     $0x1,%edi
 18ddcbd:	0f 1f 00             	nopl   (%rax)
 18ddcc0:	42 0f b6 84 2c 04 0d 00 00 	movzbl 0xd04(%rsp,%r13,1),%eax
 18ddcc9:	48 83 f8 04          	cmp    $0x4,%rax
 18ddccd:	77 51                	ja     18ddd20 <run_backend_benchmark+0xc50>
 18ddccf:	48 8d 35 72 86 c6 fe 	lea    -0x139798e(%rip),%rsi        # 546348 <branch_sizing_patterns+0x6b8>
 18ddcd6:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18ddcda:	48 01 f0             	add    %rsi,%rax
 18ddcdd:	ff e0                	jmp    *%rax
 18ddcdf:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18ddce5:	eb 39                	jmp    18ddd20 <run_backend_benchmark+0xc50>
 18ddce7:	83 cf 02             	or     $0x2,%edi
 18ddcea:	eb 34                	jmp    18ddd20 <run_backend_benchmark+0xc50>
 18ddcec:	bb 03 00 00 00       	mov    $0x3,%ebx
 18ddcf1:	eb 2d                	jmp    18ddd20 <run_backend_benchmark+0xc50>
 18ddcf3:	41 83 c9 01          	or     $0x1,%r9d
 18ddcf7:	83 cf 01             	or     $0x1,%edi
 18ddcfa:	eb 24                	jmp    18ddd20 <run_backend_benchmark+0xc50>
 18ddcfc:	41 bf 03 00 00 00    	mov    $0x3,%r15d
 18ddd02:	42 0f b6 84 2c 04 0d 00 00 	movzbl 0xd04(%rsp,%r13,1),%eax
 18ddd0b:	48 83 f8 04          	cmp    $0x4,%rax
 18ddd0f:	76 be                	jbe    18ddccf <run_backend_benchmark+0xbff>
 18ddd11:	eb 0d                	jmp    18ddd20 <run_backend_benchmark+0xc50>
 18ddd13:	41 bf 03 00 00 00    	mov    $0x3,%r15d
 18ddd19:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18ddd20:	42 0f b6 84 2c 05 0d 00 00 	movzbl 0xd05(%rsp,%r13,1),%eax
 18ddd29:	48 83 f8 04          	cmp    $0x4,%rax
 18ddd2d:	77 61                	ja     18ddd90 <run_backend_benchmark+0xcc0>
 18ddd2f:	48 8d 35 26 86 c6 fe 	lea    -0x13979da(%rip),%rsi        # 54635c <branch_sizing_patterns+0x6cc>
 18ddd36:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18ddd3a:	48 01 f0             	add    %rsi,%rax
 18ddd3d:	ff e0                	jmp    *%rax
 18ddd3f:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18ddd45:	42 0f b6 84 2c 06 0d 00 00 	movzbl 0xd06(%rsp,%r13,1),%eax
 18ddd4e:	48 83 f8 04          	cmp    $0x4,%rax
 18ddd52:	76 4b                	jbe    18ddd9f <run_backend_benchmark+0xccf>
 18ddd54:	e9 97 00 00 00       	jmp    18dddf0 <run_backend_benchmark+0xd20>
 18ddd59:	83 cf 02             	or     $0x2,%edi
 18ddd5c:	42 0f b6 84 2c 06 0d 00 00 	movzbl 0xd06(%rsp,%r13,1),%eax
 18ddd65:	48 83 f8 04          	cmp    $0x4,%rax
 18ddd69:	76 34                	jbe    18ddd9f <run_backend_benchmark+0xccf>
 18ddd6b:	e9 80 00 00 00       	jmp    18dddf0 <run_backend_benchmark+0xd20>
 18ddd70:	bb 03 00 00 00       	mov    $0x3,%ebx
 18ddd75:	42 0f b6 84 2c 06 0d 00 00 	movzbl 0xd06(%rsp,%r13,1),%eax
 18ddd7e:	48 83 f8 04          	cmp    $0x4,%rax
 18ddd82:	76 1b                	jbe    18ddd9f <run_backend_benchmark+0xccf>
 18ddd84:	eb 6a                	jmp    18dddf0 <run_backend_benchmark+0xd20>
 18ddd86:	41 83 c9 01          	or     $0x1,%r9d
 18ddd8a:	83 cf 01             	or     $0x1,%edi
 18ddd8d:	0f 1f 00             	nopl   (%rax)
 18ddd90:	42 0f b6 84 2c 06 0d 00 00 	movzbl 0xd06(%rsp,%r13,1),%eax
 18ddd99:	48 83 f8 04          	cmp    $0x4,%rax
 18ddd9d:	77 51                	ja     18dddf0 <run_backend_benchmark+0xd20>
 18ddd9f:	48 8d 35 ca 85 c6 fe 	lea    -0x1397a36(%rip),%rsi        # 546370 <branch_sizing_patterns+0x6e0>
 18ddda6:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18dddaa:	48 01 f0             	add    %rsi,%rax
 18dddad:	ff e0                	jmp    *%rax
 18dddaf:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18dddb5:	eb 39                	jmp    18dddf0 <run_backend_benchmark+0xd20>
 18dddb7:	83 cf 02             	or     $0x2,%edi
 18dddba:	eb 34                	jmp    18dddf0 <run_backend_benchmark+0xd20>
 18dddbc:	bb 03 00 00 00       	mov    $0x3,%ebx
 18dddc1:	eb 2d                	jmp    18dddf0 <run_backend_benchmark+0xd20>
 18dddc3:	41 83 c9 01          	or     $0x1,%r9d
 18dddc7:	83 cf 01             	or     $0x1,%edi
 18dddca:	eb 24                	jmp    18dddf0 <run_backend_benchmark+0xd20>
 18dddcc:	41 bf 03 00 00 00    	mov    $0x3,%r15d
 18dddd2:	42 0f b6 84 2c 06 0d 00 00 	movzbl 0xd06(%rsp,%r13,1),%eax
 18ddddb:	48 83 f8 04          	cmp    $0x4,%rax
 18ddddf:	76 be                	jbe    18ddd9f <run_backend_benchmark+0xccf>
 18ddde1:	eb 0d                	jmp    18dddf0 <run_backend_benchmark+0xd20>
 18ddde3:	41 bf 03 00 00 00    	mov    $0x3,%r15d
 18ddde9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18dddf0:	42 0f b6 84 2c 07 0d 00 00 	movzbl 0xd07(%rsp,%r13,1),%eax
 18dddf9:	48 83 f8 04          	cmp    $0x4,%rax
 18dddfd:	77 61                	ja     18dde60 <run_backend_benchmark+0xd90>
 18dddff:	48 8d 35 7e 85 c6 fe 	lea    -0x1397a82(%rip),%rsi        # 546384 <branch_sizing_patterns+0x6f4>
 18dde06:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18dde0a:	48 01 f0             	add    %rsi,%rax
 18dde0d:	ff e0                	jmp    *%rax
 18dde0f:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18dde15:	42 0f b6 84 2c 08 0d 00 00 	movzbl 0xd08(%rsp,%r13,1),%eax
 18dde1e:	48 83 f8 04          	cmp    $0x4,%rax
 18dde22:	76 4f                	jbe    18dde73 <run_backend_benchmark+0xda3>
 18dde24:	e9 47 fd ff ff       	jmp    18ddb70 <run_backend_benchmark+0xaa0>
 18dde29:	83 cf 02             	or     $0x2,%edi
 18dde2c:	42 0f b6 84 2c 08 0d 00 00 	movzbl 0xd08(%rsp,%r13,1),%eax
 18dde35:	48 83 f8 04          	cmp    $0x4,%rax
 18dde39:	76 38                	jbe    18dde73 <run_backend_benchmark+0xda3>
 18dde3b:	e9 30 fd ff ff       	jmp    18ddb70 <run_backend_benchmark+0xaa0>
 18dde40:	bb 03 00 00 00       	mov    $0x3,%ebx
 18dde45:	42 0f b6 84 2c 08 0d 00 00 	movzbl 0xd08(%rsp,%r13,1),%eax
 18dde4e:	48 83 f8 04          	cmp    $0x4,%rax
 18dde52:	76 1f                	jbe    18dde73 <run_backend_benchmark+0xda3>
 18dde54:	e9 17 fd ff ff       	jmp    18ddb70 <run_backend_benchmark+0xaa0>
 18dde59:	41 83 c9 01          	or     $0x1,%r9d
 18dde5d:	83 cf 01             	or     $0x1,%edi
 18dde60:	42 0f b6 84 2c 08 0d 00 00 	movzbl 0xd08(%rsp,%r13,1),%eax
 18dde69:	48 83 f8 04          	cmp    $0x4,%rax
 18dde6d:	0f 87 fd fc ff ff    	ja     18ddb70 <run_backend_benchmark+0xaa0>
 18dde73:	48 63 04 82          	movslq (%rdx,%rax,4),%rax
 18dde77:	48 01 d0             	add    %rdx,%rax
 18dde7a:	ff e0                	jmp    *%rax
 18dde7c:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18dde82:	e9 e9 fc ff ff       	jmp    18ddb70 <run_backend_benchmark+0xaa0>
 18dde87:	bb 03 00 00 00       	mov    $0x3,%ebx
 18dde8c:	e9 df fc ff ff       	jmp    18ddb70 <run_backend_benchmark+0xaa0>
 18dde91:	41 83 c9 01          	or     $0x1,%r9d
 18dde95:	83 cf 01             	or     $0x1,%edi
 18dde98:	e9 d3 fc ff ff       	jmp    18ddb70 <run_backend_benchmark+0xaa0>
 18dde9d:	41 bf 03 00 00 00    	mov    $0x3,%r15d
 18ddea3:	42 0f b6 84 2c 08 0d 00 00 	movzbl 0xd08(%rsp,%r13,1),%eax
 18ddeac:	48 83 f8 04          	cmp    $0x4,%rax
 18ddeb0:	76 c1                	jbe    18dde73 <run_backend_benchmark+0xda3>
 18ddeb2:	e9 b9 fc ff ff       	jmp    18ddb70 <run_backend_benchmark+0xaa0>
 18ddeb7:	41 bf 03 00 00 00    	mov    $0x3,%r15d
 18ddebd:	e9 ae fc ff ff       	jmp    18ddb70 <run_backend_benchmark+0xaa0>
 18ddec2:	4d 85 db             	test   %r11,%r11
 18ddec5:	74 5b                	je     18ddf22 <run_backend_benchmark+0xe52>
 18ddec7:	49 ff c5             	inc    %r13
 18ddeca:	4a 8d 8c 2c 00 0d 00 00 	lea    0xd00(%rsp,%r13,1),%rcx
 18dded2:	31 d2                	xor    %edx,%edx
 18dded4:	eb 12                	jmp    18ddee8 <run_backend_benchmark+0xe18>
 18dded6:	83 cf 02             	or     $0x2,%edi
 18dded9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18ddee0:	48 ff c2             	inc    %rdx
 18ddee3:	49 39 d3             	cmp    %rdx,%r11
 18ddee6:	74 3a                	je     18ddf22 <run_backend_benchmark+0xe52>
 18ddee8:	0f b6 04 11          	movzbl (%rcx,%rdx,1),%eax
 18ddeec:	48 83 f8 04          	cmp    $0x4,%rax
 18ddef0:	77 ee                	ja     18ddee0 <run_backend_benchmark+0xe10>
 18ddef2:	48 8d 35 b3 84 c6 fe 	lea    -0x1397b4d(%rip),%rsi        # 5463ac <branch_sizing_patterns+0x71c>
 18ddef9:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18ddefd:	48 01 f0             	add    %rsi,%rax
 18ddf00:	ff e0                	jmp    *%rax
 18ddf02:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18ddf08:	eb d6                	jmp    18ddee0 <run_backend_benchmark+0xe10>
 18ddf0a:	bb 03 00 00 00       	mov    $0x3,%ebx
 18ddf0f:	eb cf                	jmp    18ddee0 <run_backend_benchmark+0xe10>
 18ddf11:	41 83 c9 01          	or     $0x1,%r9d
 18ddf15:	83 cf 01             	or     $0x1,%edi
 18ddf18:	eb c6                	jmp    18ddee0 <run_backend_benchmark+0xe10>
 18ddf1a:	41 bf 03 00 00 00    	mov    $0x3,%r15d
 18ddf20:	eb be                	jmp    18ddee0 <run_backend_benchmark+0xe10>
 18ddf22:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
 18ddf27:	44 89 4c 24 30       	mov    %r9d,0x30(%rsp)
 18ddf2c:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18ddf31:	b2 01                	mov    $0x1,%dl
 18ddf33:	48 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%rax
 18ddf3b:	44 0f b7 48 16       	movzwl 0x16(%rax),%r9d
 18ddf40:	0f b7 48 18          	movzwl 0x18(%rax),%ecx
 18ddf44:	0f b7 40 1e          	movzwl 0x1e(%rax),%eax
 18ddf48:	45 85 c9             	test   %r9d,%r9d
 18ddf4b:	89 84 24 98 00 00 00 	mov    %eax,0x98(%rsp)
 18ddf52:	44 89 c8             	mov    %r9d,%eax
 18ddf55:	45 89 ce             	mov    %r9d,%r14d
 18ddf58:	89 4c 24 60          	mov    %ecx,0x60(%rsp)
 18ddf5c:	41 0f b6 4b 0c       	movzbl 0xc(%r11),%ecx
 18ddf61:	44 89 8c 24 90 00 00 00 	mov    %r9d,0x90(%rsp)
 18ddf69:	41 0f 95 c0          	setne  %r8b
 18ddf6d:	83 e0 0f             	and    $0xf,%eax
 18ddf70:	41 83 e6 10          	and    $0x10,%r14d
 18ddf74:	40 0f 94 c6          	sete   %sil
 18ddf78:	41 c1 ee 04          	shr    $0x4,%r14d
 18ddf7c:	85 c0                	test   %eax,%eax
 18ddf7e:	41 89 c3             	mov    %eax,%r11d
 18ddf81:	41 0f 95 c4          	setne  %r12b
 18ddf85:	45 20 f4             	and    %r14b,%r12b
 18ddf88:	41 83 eb 05          	sub    $0x5,%r11d
 18ddf8c:	0f 92 c3             	setb   %bl
 18ddf8f:	44 20 e3             	and    %r12b,%bl
 18ddf92:	41 83 fb 03          	cmp    $0x3,%r11d
 18ddf96:	41 0f 92 c3          	setb   %r11b
 18ddf9a:	45 20 de             	and    %r11b,%r14b
 18ddf9d:	45 85 d2             	test   %r10d,%r10d
 18ddfa0:	41 0f 94 c4          	sete   %r12b
 18ddfa4:	44 08 e6             	or     %r12b,%sil
 18ddfa7:	45 08 e0             	or     %r12b,%r8b
 18ddfaa:	44 08 de             	or     %r11b,%sil
 18ddfad:	41 20 d0             	and    %dl,%r8b
 18ddfb0:	40 08 de             	or     %bl,%sil
 18ddfb3:	44 20 c6             	and    %r8b,%sil
 18ddfb6:	45 0f b6 c6          	movzbl %r14b,%r8d
 18ddfba:	41 c1 e0 04          	shl    $0x4,%r8d
 18ddfbe:	45 09 d0             	or     %r10d,%r8d
 18ddfc1:	41 f6 c2 02          	test   $0x2,%r10b
 18ddfc5:	74 39                	je     18de000 <run_backend_benchmark+0xf30>
 18ddfc7:	84 db                	test   %bl,%bl
 18ddfc9:	74 35                	je     18de000 <run_backend_benchmark+0xf30>
 18ddfcb:	8d 50 ff             	lea    -0x1(%rax),%edx
 18ddfce:	41 b9 01 00 00 00    	mov    $0x1,%r9d
 18ddfd4:	45 31 e4             	xor    %r12d,%r12d
 18ddfd7:	83 fa 02             	cmp    $0x2,%edx
 18ddfda:	c4 42 69 f7 d1       	shlx   %edx,%r9d,%r10d
 18ddfdf:	ba 02 00 00 00       	mov    $0x2,%edx
 18ddfe4:	41 0f 94 c4          	sete   %r12b
 18ddfe8:	83 f8 03             	cmp    $0x3,%eax
 18ddfeb:	44 0f 42 e2          	cmovb  %edx,%r12d
 18ddfef:	85 c9                	test   %ecx,%ecx
 18ddff1:	41 0f 44 ca          	cmove  %r10d,%ecx
 18ddff5:	eb 3a                	jmp    18de031 <run_backend_benchmark+0xf61>
 18ddff7:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18de000:	41 83 e2 02          	and    $0x2,%r10d
 18de004:	45 31 e4             	xor    %r12d,%r12d
 18de007:	41 d1 ea             	shr    $1,%r10d
 18de00a:	45 20 f2             	and    %r14b,%r10b
 18de00d:	41 80 fa 01          	cmp    $0x1,%r10b
 18de011:	75 2d                	jne    18de040 <run_backend_benchmark+0xf70>
 18de013:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 18de018:	44 0f b6 50 0d       	movzbl 0xd(%rax),%r10d
 18de01d:	45 85 d2             	test   %r10d,%r10d
 18de020:	45 89 d4             	mov    %r10d,%r12d
 18de023:	0f 95 c0             	setne  %al
 18de026:	41 c1 ec 05          	shr    $0x5,%r12d
 18de02a:	41 83 e2 1f          	and    $0x1f,%r10d
 18de02e:	40 20 c6             	and    %al,%sil
 18de031:	42 8d 04 a5 00 00 00 00 	lea    0x0(,%r12,4),%eax
 18de039:	41 09 c0             	or     %eax,%r8d
 18de03c:	eb 05                	jmp    18de043 <run_backend_benchmark+0xf73>
 18de03e:	66 90                	xchg   %ax,%ax
 18de040:	45 31 d2             	xor    %r10d,%r10d
 18de043:	44 8b 4c 24 60       	mov    0x60(%rsp),%r9d
 18de048:	44 89 c8             	mov    %r9d,%eax
 18de04b:	83 e0 0f             	and    $0xf,%eax
 18de04e:	45 89 ce             	mov    %r9d,%r14d
 18de051:	41 83 e6 10          	and    $0x10,%r14d
 18de055:	0f 94 c2             	sete   %dl
 18de058:	41 c1 ee 04          	shr    $0x4,%r14d
 18de05c:	85 c0                	test   %eax,%eax
 18de05e:	41 89 c5             	mov    %eax,%r13d
 18de061:	41 0f 95 c3          	setne  %r11b
 18de065:	45 20 f3             	and    %r14b,%r11b
 18de068:	41 83 ed 05          	sub    $0x5,%r13d
 18de06c:	0f 92 c3             	setb   %bl
 18de06f:	44 20 db             	and    %r11b,%bl
 18de072:	41 83 fd 03          	cmp    $0x3,%r13d
 18de076:	41 0f 92 c3          	setb   %r11b
 18de07a:	45 20 de             	and    %r11b,%r14b
 18de07d:	45 85 ff             	test   %r15d,%r15d
 18de080:	41 0f 94 c5          	sete   %r13b
 18de084:	45 85 c9             	test   %r9d,%r9d
 18de087:	41 0f 95 c1          	setne  %r9b
 18de08b:	44 08 ea             	or     %r13b,%dl
 18de08e:	44 08 da             	or     %r11b,%dl
 18de091:	45 08 e9             	or     %r13b,%r9b
 18de094:	08 da                	or     %bl,%dl
 18de096:	44 20 ca             	and    %r9b,%dl
 18de099:	40 20 f2             	and    %sil,%dl
 18de09c:	41 0f b6 f6          	movzbl %r14b,%esi
 18de0a0:	c1 e6 04             	shl    $0x4,%esi
 18de0a3:	44 09 fe             	or     %r15d,%esi
 18de0a6:	41 f6 c7 02          	test   $0x2,%r15b
 18de0aa:	74 54                	je     18de100 <run_backend_benchmark+0x1030>
 18de0ac:	84 db                	test   %bl,%bl
 18de0ae:	74 50                	je     18de100 <run_backend_benchmark+0x1030>
 18de0b0:	44 8d 48 ff          	lea    -0x1(%rax),%r9d
 18de0b4:	45 31 e4             	xor    %r12d,%r12d
 18de0b7:	44 8b ac 24 98 00 00 00 	mov    0x98(%rsp),%r13d
 18de0bf:	41 ba 01 00 00 00    	mov    $0x1,%r10d
 18de0c5:	41 83 f9 02          	cmp    $0x2,%r9d
 18de0c9:	c4 42 31 f7 d2       	shlx   %r9d,%r10d,%r10d
 18de0ce:	41 0f 94 c4          	sete   %r12b
 18de0d2:	83 f8 03             	cmp    $0x3,%eax
 18de0d5:	b8 02 00 00 00       	mov    $0x2,%eax
 18de0da:	44 0f 42 e0          	cmovb  %eax,%r12d
 18de0de:	85 c9                	test   %ecx,%ecx
 18de0e0:	42 8d 04 a5 00 00 00 00 	lea    0x0(,%r12,4),%eax
 18de0e8:	41 0f 44 ca          	cmove  %r10d,%ecx
 18de0ec:	48 89 4c 24 78       	mov    %rcx,0x78(%rsp)
 18de0f1:	09 c6                	or     %eax,%esi
 18de0f3:	eb 4f                	jmp    18de144 <run_backend_benchmark+0x1074>
 18de0f5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18de100:	44 8b ac 24 98 00 00 00 	mov    0x98(%rsp),%r13d
 18de108:	41 83 e7 02          	and    $0x2,%r15d
 18de10c:	48 89 4c 24 78       	mov    %rcx,0x78(%rsp)
 18de111:	41 d1 ef             	shr    $1,%r15d
 18de114:	45 20 f7             	and    %r14b,%r15b
 18de117:	41 80 ff 01          	cmp    $0x1,%r15b
 18de11b:	75 27                	jne    18de144 <run_backend_benchmark+0x1074>
 18de11d:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 18de122:	44 0f b6 50 0d       	movzbl 0xd(%rax),%r10d
 18de127:	45 85 d2             	test   %r10d,%r10d
 18de12a:	45 89 d4             	mov    %r10d,%r12d
 18de12d:	0f 95 c0             	setne  %al
 18de130:	41 c1 ec 05          	shr    $0x5,%r12d
 18de134:	41 83 e2 1f          	and    $0x1f,%r10d
 18de138:	42 8d 0c a5 00 00 00 00 	lea    0x0(,%r12,4),%ecx
 18de140:	20 c2                	and    %al,%dl
 18de142:	09 ce                	or     %ecx,%esi
 18de144:	44 89 e8             	mov    %r13d,%eax
 18de147:	83 e0 0f             	and    $0xf,%eax
 18de14a:	45 89 ee             	mov    %r13d,%r14d
 18de14d:	41 83 e6 10          	and    $0x10,%r14d
 18de151:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 18de156:	41 0f 94 c7          	sete   %r15b
 18de15a:	41 c1 ee 04          	shr    $0x4,%r14d
 18de15e:	85 c0                	test   %eax,%eax
 18de160:	41 89 c3             	mov    %eax,%r11d
 18de163:	41 0f 95 c1          	setne  %r9b
 18de167:	45 20 f1             	and    %r14b,%r9b
 18de16a:	41 83 eb 05          	sub    $0x5,%r11d
 18de16e:	0f 92 c3             	setb   %bl
 18de171:	44 20 cb             	and    %r9b,%bl
 18de174:	41 83 fb 03          	cmp    $0x3,%r11d
 18de178:	41 0f 92 c1          	setb   %r9b
 18de17c:	45 20 ce             	and    %r9b,%r14b
 18de17f:	85 c9                	test   %ecx,%ecx
 18de181:	41 0f 94 c3          	sete   %r11b
 18de185:	45 85 ed             	test   %r13d,%r13d
 18de188:	41 0f 95 c5          	setne  %r13b
 18de18c:	45 08 df             	or     %r11b,%r15b
 18de18f:	45 08 cf             	or     %r9b,%r15b
 18de192:	45 08 dd             	or     %r11b,%r13b
 18de195:	41 08 df             	or     %bl,%r15b
 18de198:	45 20 ef             	and    %r13b,%r15b
 18de19b:	41 20 d7             	and    %dl,%r15b
 18de19e:	41 0f b6 d6          	movzbl %r14b,%edx
 18de1a2:	c1 e2 04             	shl    $0x4,%edx
 18de1a5:	09 ca                	or     %ecx,%edx
 18de1a7:	f6 c1 02             	test   $0x2,%cl
 18de1aa:	74 54                	je     18de200 <run_backend_benchmark+0x1130>
 18de1ac:	84 db                	test   %bl,%bl
 18de1ae:	74 50                	je     18de200 <run_backend_benchmark+0x1130>
 18de1b0:	44 8d 48 ff          	lea    -0x1(%rax),%r9d
 18de1b4:	45 31 e4             	xor    %r12d,%r12d
 18de1b7:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
 18de1bc:	4c 8b ac 24 80 00 00 00 	mov    0x80(%rsp),%r13
 18de1c4:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18de1c9:	41 ba 01 00 00 00    	mov    $0x1,%r10d
 18de1cf:	41 83 f9 02          	cmp    $0x2,%r9d
 18de1d3:	c4 42 31 f7 d2       	shlx   %r9d,%r10d,%r10d
 18de1d8:	41 0f 94 c4          	sete   %r12b
 18de1dc:	83 f8 03             	cmp    $0x3,%eax
 18de1df:	b8 02 00 00 00       	mov    $0x2,%eax
 18de1e4:	44 0f 42 e0          	cmovb  %eax,%r12d
 18de1e8:	42 8d 04 a5 00 00 00 00 	lea    0x0(,%r12,4),%eax
 18de1f0:	09 c2                	or     %eax,%edx
 18de1f2:	85 c9                	test   %ecx,%ecx
 18de1f4:	41 0f 44 ca          	cmove  %r10d,%ecx
 18de1f8:	eb 66                	jmp    18de260 <run_backend_benchmark+0x1190>
 18de1fa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 18de200:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 18de205:	4c 8b ac 24 80 00 00 00 	mov    0x80(%rsp),%r13
 18de20d:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18de212:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
 18de217:	83 e0 02             	and    $0x2,%eax
 18de21a:	d1 e8                	shr    $1,%eax
 18de21c:	44 20 f0             	and    %r14b,%al
 18de21f:	3c 01                	cmp    $0x1,%al
 18de221:	75 24                	jne    18de247 <run_backend_benchmark+0x1177>
 18de223:	45 0f b6 53 0d       	movzbl 0xd(%r11),%r10d
 18de228:	45 85 d2             	test   %r10d,%r10d
 18de22b:	45 89 d4             	mov    %r10d,%r12d
 18de22e:	0f 95 c0             	setne  %al
 18de231:	41 c1 ec 05          	shr    $0x5,%r12d
 18de235:	41 83 e2 1f          	and    $0x1f,%r10d
 18de239:	46 8d 0c a5 00 00 00 00 	lea    0x0(,%r12,4),%r9d
 18de241:	41 20 c7             	and    %al,%r15b
 18de244:	44 09 ca             	or     %r9d,%edx
 18de247:	85 c9                	test   %ecx,%ecx
 18de249:	75 15                	jne    18de260 <run_backend_benchmark+0x1190>
 18de24b:	48 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%rax
 18de253:	0f b6 48 1a          	movzbl 0x1a(%rax),%ecx
 18de257:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18de260:	4d 89 e9             	mov    %r13,%r9
 18de263:	49 c1 e1 04          	shl    $0x4,%r9
 18de267:	48 8d 05 92 9b 70 0d 	lea    0xd709b92(%rip),%rax        # efe7e00 <x86_effects_records>
 18de26e:	41 0f b7 5b 08       	movzwl 0x8(%r11),%ebx
 18de273:	49 01 c1             	add    %rax,%r9
 18de276:	48 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%rax
 18de27e:	0f b6 40 12          	movzbl 0x12(%rax),%eax
 18de282:	84 c0                	test   %al,%al
 18de284:	74 0a                	je     18de290 <run_backend_benchmark+0x11c0>
 18de286:	45 0f b6 73 12       	movzbl 0x12(%r11),%r14d
 18de28b:	eb 06                	jmp    18de293 <run_backend_benchmark+0x11c3>
 18de28d:	0f 1f 00             	nopl   (%rax)
 18de290:	45 31 f6             	xor    %r14d,%r14d
 18de293:	84 c0                	test   %al,%al
 18de295:	0f 94 c0             	sete   %al
 18de298:	c1 e6 05             	shl    $0x5,%esi
 18de29b:	c1 e2 0a             	shl    $0xa,%edx
 18de29e:	44 09 c6             	or     %r8d,%esi
 18de2a1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 18de2a7:	09 d6                	or     %edx,%esi
 18de2a9:	89 da                	mov    %ebx,%edx
 18de2ab:	83 e2 fd             	and    $0xfffffffd,%edx
 18de2ae:	41 83 fc 02          	cmp    $0x2,%r12d
 18de2b2:	44 8b 64 24 30       	mov    0x30(%rsp),%r12d
 18de2b7:	0f 44 da             	cmove  %edx,%ebx
 18de2ba:	f6 44 24 60 10       	testb  $0x10,0x60(%rsp)
 18de2bf:	0f 44 da             	cmove  %edx,%ebx
 18de2c2:	f6 84 24 90 00 00 00 10 	testb  $0x10,0x90(%rsp)
 18de2ca:	0f 44 da             	cmove  %edx,%ebx
 18de2cd:	8d 51 ff             	lea    -0x1(%rcx),%edx
 18de2d0:	83 fa 03             	cmp    $0x3,%edx
 18de2d3:	45 0f 42 c4          	cmovb  %r12d,%r8d
 18de2d7:	41 09 f8             	or     %edi,%r8d
 18de2da:	45 85 f6             	test   %r14d,%r14d
 18de2dd:	41 0f b6 7b 13       	movzbl 0x13(%r11),%edi
 18de2e2:	0f 95 c2             	setne  %dl
 18de2e5:	66 45 89 01          	mov    %r8w,(%r9)
 18de2e9:	66 45 89 61 02       	mov    %r12w,0x2(%r9)
 18de2ee:	66 41 89 71 04       	mov    %si,0x4(%r9)
 18de2f3:	66 41 89 59 06       	mov    %bx,0x6(%r9)
 18de2f8:	41 8b 5b 0e          	mov    0xe(%r11),%ebx
 18de2fc:	45 0f b6 43 0a       	movzbl 0xa(%r11),%r8d
 18de301:	4c 8d 25 1c 81 c6 fe 	lea    -0x1397ee4(%rip),%r12        # 546424 <branch_sizing_patterns+0x794>
 18de308:	08 c2                	or     %al,%dl
 18de30a:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 18de312:	44 20 fa             	and    %r15b,%dl
 18de315:	c1 e7 04             	shl    $0x4,%edi
 18de318:	41 89 59 08          	mov    %ebx,0x8(%r9)
 18de31c:	44 09 f7             	or     %r14d,%edi
 18de31f:	48 8d 1d 9a 59 70 0d 	lea    0xd70599a(%rip),%rbx        # efe3cc0 <x86_effects_index>
 18de326:	45 88 41 0c          	mov    %r8b,0xc(%r9)
 18de32a:	41 88 49 0d          	mov    %cl,0xd(%r9)
 18de32e:	45 88 51 0e          	mov    %r10b,0xe(%r9)
 18de332:	4c 8d 35 ff 80 c6 fe 	lea    -0x1397f01(%rip),%r14        # 546438 <branch_sizing_patterns+0x7a8>
 18de339:	41 88 79 0f          	mov    %dil,0xf(%r9)
 18de33d:	66 44 89 2c 43       	mov    %r13w,(%rbx,%rax,2)
 18de342:	49 ff c5             	inc    %r13
 18de345:	4c 8d 0d 14 81 c6 fe 	lea    -0x1397eec(%rip),%r9        # 546460 <branch_sizing_patterns+0x7d0>
 18de34c:	80 fa 01             	cmp    $0x1,%dl
 18de34f:	75 0f                	jne    18de360 <run_backend_benchmark+0x1290>
 18de351:	48 8d 78 01          	lea    0x1(%rax),%rdi
 18de355:	48 3b 44 24 70       	cmp    0x70(%rsp),%rax
 18de35a:	0f 82 40 f1 ff ff    	jb     18dd4a0 <run_backend_benchmark+0x3d0>
 18de360:	48 8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%rcx
 18de368:	48 ff c1             	inc    %rcx
 18de36b:	48 89 8c 24 c0 00 00 00 	mov    %rcx,0xc0(%rsp)
 18de373:	48 81 f9 bc 00 00 00 	cmp    $0xbc,%rcx
 18de37a:	74 6c                	je     18de3e8 <run_backend_benchmark+0x1318>
 18de37c:	84 d2                	test   %dl,%dl
 18de37e:	75 3a                	jne    18de3ba <run_backend_benchmark+0x12ea>
 18de380:	e9 31 81 00 00       	jmp    18e64b6 <run_backend_benchmark+0x93e6>
 18de385:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18de390:	48 8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%rcx
 18de398:	48 ff c1             	inc    %rcx
 18de39b:	48 89 8c 24 c0 00 00 00 	mov    %rcx,0xc0(%rsp)
 18de3a3:	48 81 f9 bc 00 00 00 	cmp    $0xbc,%rcx
 18de3aa:	0f 84 06 81 00 00    	je     18e64b6 <run_backend_benchmark+0x93e6>
 18de3b0:	31 d2                	xor    %edx,%edx
 18de3b2:	84 d2                	test   %dl,%dl
 18de3b4:	0f 84 fc 80 00 00    	je     18e64b6 <run_backend_benchmark+0x93e6>
 18de3ba:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18de3c2:	48 8d 15 f7 a2 c6 fe 	lea    -0x1395d09(%rip),%rdx        # 5486c0 <x86_effects_rows>
 18de3c9:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
 18de3cd:	4c 8d 1c 82          	lea    (%rdx,%rax,4),%r11
 18de3d1:	0f b7 0c 82          	movzwl (%rdx,%rax,4),%ecx
 18de3d5:	0f b7 44 82 02       	movzwl 0x2(%rdx,%rax,4),%eax
 18de3da:	66 39 c1             	cmp    %ax,%cx
 18de3dd:	0f 86 9d f0 ff ff    	jbe    18dd480 <run_backend_benchmark+0x3b0>
 18de3e3:	e9 ce 80 00 00       	jmp    18e64b6 <run_backend_benchmark+0x93e6>
 18de3e8:	84 d2                	test   %dl,%dl
 18de3ea:	0f 84 c6 80 00 00    	je     18e64b6 <run_backend_benchmark+0x93e6>
 18de3f0:	62 f3 7d 48 25 c0 ff 	vpternlogd $0xff,%zmm0,%zmm0,%zmm0
 18de3f7:	48 8d 3d 52 dc 70 0d 	lea    0xd70dc52(%rip),%rdi        # efec050 <x86_choice_rows>
 18de3fe:	ba 00 09 00 00       	mov    $0x900,%edx
 18de403:	31 f6                	xor    %esi,%esi
 18de405:	48 c7 05 30 dc 70 0d ff ff ff ff 	movq   $0xffffffffffffffff,0xd70dc30(%rip)        # efec040 <x86_choice_row_index+0x240>
 18de410:	45 31 f6             	xor    %r14d,%r14d
 18de413:	62 f1 fe 48 7f 05 e3 db 70 0d 	vmovdqu64 %zmm0,0xd70dbe3(%rip)        # efec000 <x86_choice_row_index+0x200>
 18de41d:	62 f1 fe 48 7f 05 99 db 70 0d 	vmovdqu64 %zmm0,0xd70db99(%rip)        # efebfc0 <x86_choice_row_index+0x1c0>
 18de427:	62 f1 fe 48 7f 05 4f db 70 0d 	vmovdqu64 %zmm0,0xd70db4f(%rip)        # efebf80 <x86_choice_row_index+0x180>
 18de431:	62 f1 fe 48 7f 05 05 db 70 0d 	vmovdqu64 %zmm0,0xd70db05(%rip)        # efebf40 <x86_choice_row_index+0x140>
 18de43b:	62 f1 fe 48 7f 05 bb da 70 0d 	vmovdqu64 %zmm0,0xd70dabb(%rip)        # efebf00 <x86_choice_row_index+0x100>
 18de445:	62 f1 fe 48 7f 05 71 da 70 0d 	vmovdqu64 %zmm0,0xd70da71(%rip)        # efebec0 <x86_choice_row_index+0xc0>
 18de44f:	62 f1 fe 48 7f 05 27 da 70 0d 	vmovdqu64 %zmm0,0xd70da27(%rip)        # efebe80 <x86_choice_row_index+0x80>
 18de459:	62 f1 fe 48 7f 05 dd d9 70 0d 	vmovdqu64 %zmm0,0xd70d9dd(%rip)        # efebe40 <x86_choice_row_index+0x40>
 18de463:	62 f1 fe 48 7f 05 93 d9 70 0d 	vmovdqu64 %zmm0,0xd70d993(%rip)        # efebe00 <x86_choice_row_index>
 18de46d:	c5 f8 77             	vzeroupper
 18de470:	e8 0b ba eb fe       	call   799e80 <memset@plt>
 18de475:	62 f2 7d 48 5a 0d f1 db cc fe 	vbroadcasti32x4 -0x133240f(%rip),%zmm1        # 5ac070 <x86_effects_unknown+0xa0>
 18de47f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18de483:	31 c0                	xor    %eax,%eax
 18de485:	62 f1 fd 48 7f 05 f1 e4 70 0d 	vmovdqa64 %zmm0,0xd70e4f1(%rip)        # efec980 <x86_choice_row_info>
 18de48f:	62 f1 fd 48 7f 05 27 e5 70 0d 	vmovdqa64 %zmm0,0xd70e527(%rip)        # efec9c0 <x86_choice_row_info+0x40>
 18de499:	62 f1 fd 48 7f 05 5d e5 70 0d 	vmovdqa64 %zmm0,0xd70e55d(%rip)        # efeca00 <x86_choice_forms_by_candidate>
 18de4a3:	62 f1 fd 48 7f 05 93 e5 70 0d 	vmovdqa64 %zmm0,0xd70e593(%rip)        # efeca40 <x86_choice_forms_by_candidate+0x40>
 18de4ad:	62 f1 fd 48 7f 05 c9 e5 70 0d 	vmovdqa64 %zmm0,0xd70e5c9(%rip)        # efeca80 <x86_choice_forms_by_candidate+0x80>
 18de4b7:	62 f1 fd 48 7f 05 ff e5 70 0d 	vmovdqa64 %zmm0,0xd70e5ff(%rip)        # efecac0 <x86_choice_forms_by_candidate+0xc0>
 18de4c1:	62 f1 fd 48 7f 05 35 e6 70 0d 	vmovdqa64 %zmm0,0xd70e635(%rip)        # efecb00 <x86_choice_forms_by_candidate+0x100>
 18de4cb:	62 f1 fd 48 7f 05 6b e6 70 0d 	vmovdqa64 %zmm0,0xd70e66b(%rip)        # efecb40 <x86_choice_forms_by_candidate+0x140>
 18de4d5:	62 f1 fd 48 7f 05 a1 e6 70 0d 	vmovdqa64 %zmm0,0xd70e6a1(%rip)        # efecb80 <x86_choice_forms_by_candidate+0x180>
 18de4df:	62 f1 fd 48 7f 05 d7 e6 70 0d 	vmovdqa64 %zmm0,0xd70e6d7(%rip)        # efecbc0 <x86_choice_forms_by_candidate+0x1c0>
 18de4e9:	62 f1 fd 48 7f 05 0d e7 70 0d 	vmovdqa64 %zmm0,0xd70e70d(%rip)        # efecc00 <x86_choice_forms_by_candidate+0x200>
 18de4f3:	62 f1 fd 48 7f 05 43 e7 70 0d 	vmovdqa64 %zmm0,0xd70e743(%rip)        # efecc40 <x86_choice_forms_by_candidate+0x240>
 18de4fd:	62 f1 fd 48 7f 05 79 e7 70 0d 	vmovdqa64 %zmm0,0xd70e779(%rip)        # efecc80 <x86_choice_forms_by_candidate+0x280>
 18de507:	62 f1 fd 48 7f 05 af e7 70 0d 	vmovdqa64 %zmm0,0xd70e7af(%rip)        # efeccc0 <x86_choice_forms_by_candidate+0x2c0>
 18de511:	62 f1 fd 48 7f 05 e5 e7 70 0d 	vmovdqa64 %zmm0,0xd70e7e5(%rip)        # efecd00 <x86_choice_forms_by_candidate+0x300>
 18de51b:	62 f1 fd 48 7f 05 1b e8 70 0d 	vmovdqa64 %zmm0,0xd70e81b(%rip)        # efecd40 <x86_choice_forms_by_candidate+0x340>
 18de525:	62 f1 fd 48 7f 05 51 e8 70 0d 	vmovdqa64 %zmm0,0xd70e851(%rip)        # efecd80 <x86_choice_forms_by_candidate+0x380>
 18de52f:	62 f1 fd 48 7f 05 87 e8 70 0d 	vmovdqa64 %zmm0,0xd70e887(%rip)        # efecdc0 <x86_choice_forms_by_candidate+0x3c0>
 18de539:	62 f1 fd 48 7f 0d bd e8 70 0d 	vmovdqa64 %zmm1,0xd70e8bd(%rip)        # efece00 <x86_choice_conditions_by_candidate>
 18de543:	62 f1 fd 48 7f 0d f3 e8 70 0d 	vmovdqa64 %zmm1,0xd70e8f3(%rip)        # efece40 <x86_choice_conditions_by_candidate+0x40>
 18de54d:	62 f1 fd 48 7f 0d 29 e9 70 0d 	vmovdqa64 %zmm1,0xd70e929(%rip)        # efece80 <x86_choice_conditions_by_candidate+0x80>
 18de557:	62 f1 fd 48 7f 0d 5f e9 70 0d 	vmovdqa64 %zmm1,0xd70e95f(%rip)        # efecec0 <x86_choice_conditions_by_candidate+0xc0>
 18de561:	62 f1 fd 48 7f 0d 95 e9 70 0d 	vmovdqa64 %zmm1,0xd70e995(%rip)        # efecf00 <x86_choice_conditions_by_candidate+0x100>
 18de56b:	62 f1 fd 48 7f 0d cb e9 70 0d 	vmovdqa64 %zmm1,0xd70e9cb(%rip)        # efecf40 <x86_choice_conditions_by_candidate+0x140>
 18de575:	62 f1 fd 48 7f 0d 01 ea 70 0d 	vmovdqa64 %zmm1,0xd70ea01(%rip)        # efecf80 <x86_choice_conditions_by_candidate+0x180>
 18de57f:	62 f1 fd 48 7f 0d 37 ea 70 0d 	vmovdqa64 %zmm1,0xd70ea37(%rip)        # efecfc0 <x86_choice_conditions_by_candidate+0x1c0>
 18de589:	62 f1 fd 48 7f 0d 6d ea 70 0d 	vmovdqa64 %zmm1,0xd70ea6d(%rip)        # efed000 <x86_choice_conditions_by_candidate+0x200>
 18de593:	62 f1 fd 48 7f 0d a3 ea 70 0d 	vmovdqa64 %zmm1,0xd70eaa3(%rip)        # efed040 <x86_choice_conditions_by_candidate+0x240>
 18de59d:	62 f1 fd 48 7f 0d d9 ea 70 0d 	vmovdqa64 %zmm1,0xd70ead9(%rip)        # efed080 <x86_choice_conditions_by_candidate+0x280>
 18de5a7:	62 f1 fd 48 7f 0d 0f eb 70 0d 	vmovdqa64 %zmm1,0xd70eb0f(%rip)        # efed0c0 <x86_choice_conditions_by_candidate+0x2c0>
 18de5b1:	62 f1 fd 48 7f 0d 45 eb 70 0d 	vmovdqa64 %zmm1,0xd70eb45(%rip)        # efed100 <x86_choice_conditions_by_candidate+0x300>
 18de5bb:	62 f1 fd 48 7f 0d 7b eb 70 0d 	vmovdqa64 %zmm1,0xd70eb7b(%rip)        # efed140 <x86_choice_conditions_by_candidate+0x340>
 18de5c5:	62 f1 fd 48 7f 0d b1 eb 70 0d 	vmovdqa64 %zmm1,0xd70ebb1(%rip)        # efed180 <x86_choice_conditions_by_candidate+0x380>
 18de5cf:	62 f1 fd 48 7f 0d e7 eb 70 0d 	vmovdqa64 %zmm1,0xd70ebe7(%rip)        # efed1c0 <x86_choice_conditions_by_candidate+0x3c0>
 18de5d9:	eb 27                	jmp    18de602 <run_backend_benchmark+0x1532>
 18de5db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18de5e0:	48 8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%rax
 18de5e8:	8b 94 24 d8 00 00 00 	mov    0xd8(%rsp),%edx
 18de5ef:	48 83 f8 3f          	cmp    $0x3f,%rax
 18de5f3:	48 8d 40 01          	lea    0x1(%rax),%rax
 18de5f7:	0f 92 c1             	setb   %cl
 18de5fa:	84 ca                	test   %cl,%dl
 18de5fc:	0f 84 95 06 00 00    	je     18dec97 <run_backend_benchmark+0x1bc7>
 18de602:	4c 6b d8 36          	imul   $0x36,%rax,%r11
 18de606:	49 89 c1             	mov    %rax,%r9
 18de609:	48 8d 05 60 af c6 fe 	lea    -0x13950a0(%rip),%rax        # 549570 <x86_choice_sources>
 18de610:	48 b9 11 11 11 11 11 88 88 08 	movabs $0x888881111111111,%rcx
 18de61a:	49 01 c3             	add    %rax,%r11
 18de61d:	4c 0f a3 c9          	bt     %r9,%rcx
 18de621:	b8 00 00 00 00       	mov    $0x0,%eax
 18de626:	72 38                	jb     18de660 <run_backend_benchmark+0x1590>
 18de628:	b8 01 00 00 00       	mov    $0x1,%eax
 18de62d:	48 ba 22 22 22 22 22 11 11 11 	movabs $0x1111112222222222,%rdx
 18de637:	c4 e2 b1 f7 c8       	shlx   %r9,%rax,%rcx
 18de63c:	b8 01 00 00 00       	mov    $0x1,%eax
 18de641:	48 85 d1             	test   %rdx,%rcx
 18de644:	75 1a                	jne    18de660 <run_backend_benchmark+0x1590>
 18de646:	48 b8 44 44 44 44 44 22 22 22 	movabs $0x2222224444444444,%rax
 18de650:	48 21 c1             	and    %rax,%rcx
 18de653:	b8 00 00 00 00       	mov    $0x0,%eax
 18de658:	48 83 f9 01          	cmp    $0x1,%rcx
 18de65c:	83 d0 02             	adc    $0x2,%eax
 18de65f:	90                   	nop
 18de660:	41 0f b6 13          	movzbl (%r11),%edx
 18de664:	48 8d 0d 95 d7 70 0d 	lea    0xd70d795(%rip),%rcx        # efebe00 <x86_choice_row_index>
 18de66b:	45 0f b6 43 02       	movzbl 0x2(%r11),%r8d
 18de670:	45 0f b6 63 01       	movzbl 0x1(%r11),%r12d
 18de675:	89 c7                	mov    %eax,%edi
 18de677:	45 8d 69 d5          	lea    -0x2b(%r9),%r13d
 18de67b:	4c 89 8c 24 e8 00 00 00 	mov    %r9,0xe8(%rsp)
 18de683:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
 18de687:	44 88 84 24 28 01 00 00 	mov    %r8b,0x128(%rsp)
 18de68f:	0f b7 34 79          	movzwl (%rcx,%rdi,2),%esi
 18de693:	66 44 89 0c 79       	mov    %r9w,(%rcx,%rdi,2)
 18de698:	4b 8d 0c c9          	lea    (%r9,%r9,8),%rcx
 18de69c:	48 8d 3d ad d9 70 0d 	lea    0xd70d9ad(%rip),%rdi        # efec050 <x86_choice_rows>
 18de6a3:	88 54 8f 20          	mov    %dl,0x20(%rdi,%rcx,4)
 18de6a7:	44 88 64 8f 21       	mov    %r12b,0x21(%rdi,%rcx,4)
 18de6ac:	44 88 44 8f 22       	mov    %r8b,0x22(%rdi,%rcx,4)
 18de6b1:	31 ff                	xor    %edi,%edi
 18de6b3:	41 83 fd 14          	cmp    $0x14,%r13d
 18de6b7:	4c 8d 05 c2 e2 70 0d 	lea    0xd70e2c2(%rip),%r8        # efec980 <x86_choice_row_info>
 18de6be:	40 0f 92 c7          	setb   %dil
 18de6c2:	8d 3c b8             	lea    (%rax,%rdi,4),%edi
 18de6c5:	66 43 89 3c 48       	mov    %di,(%r8,%r9,2)
 18de6ca:	41 0f b7 7b 04       	movzwl 0x4(%r11),%edi
 18de6cf:	4c 8d 05 2a 97 70 0d 	lea    0xd70972a(%rip),%r8        # efe7e00 <x86_effects_records>
 18de6d6:	81 e7 ff 7f 00 00    	and    $0x7fff,%edi
 18de6dc:	0f b7 3c 7b          	movzwl (%rbx,%rdi,2),%edi
 18de6e0:	c1 e7 04             	shl    $0x4,%edi
 18de6e3:	4d 8d 0c 38          	lea    (%r8,%rdi,1),%r9
 18de6e7:	42 0f b6 7c 07 0c    	movzbl 0xc(%rdi,%r8,1),%edi
 18de6ed:	4c 89 8c 24 a0 00 00 00 	mov    %r9,0xa0(%rsp)
 18de6f5:	48 89 bc 24 10 01 00 00 	mov    %rdi,0x110(%rsp)
 18de6fd:	40 38 d7             	cmp    %dl,%dil
 18de700:	75 2e                	jne    18de730 <run_backend_benchmark+0x1660>
 18de702:	66 83 fe ff          	cmp    $0xffff,%si
 18de706:	be 01 00 00 00       	mov    $0x1,%esi
 18de70b:	c4 e2 79 f7 c6       	shlx   %eax,%esi,%eax
 18de710:	0f 94 c2             	sete   %dl
 18de713:	44 39 e0             	cmp    %r12d,%eax
 18de716:	40 0f 94 c6          	sete   %sil
 18de71a:	45 38 61 0d          	cmp    %r12b,0xd(%r9)
 18de71e:	0f 94 c0             	sete   %al
 18de721:	40 20 d6             	and    %dl,%sil
 18de724:	40 20 c6             	and    %al,%sil
 18de727:	89 b4 24 d8 00 00 00 	mov    %esi,0xd8(%rsp)
 18de72e:	eb 0b                	jmp    18de73b <run_backend_benchmark+0x166b>
 18de730:	c7 84 24 d8 00 00 00 00 00 00 00 	movl   $0x0,0xd8(%rsp)
 18de73b:	48 8d 05 0e d9 70 0d 	lea    0xd70d90e(%rip),%rax        # efec050 <x86_choice_rows>
 18de742:	49 83 c3 06          	add    $0x6,%r11
 18de746:	be 3b 00 00 00       	mov    $0x3b,%esi
 18de74b:	bf 21 00 00 00       	mov    $0x21,%edi
 18de750:	44 89 a4 24 08 01 00 00 	mov    %r12d,0x108(%rsp)
 18de758:	44 89 ac 24 f8 00 00 00 	mov    %r13d,0xf8(%rsp)
 18de760:	48 8d 04 88          	lea    (%rax,%rcx,4),%rax
 18de764:	48 8b 8c 24 e8 00 00 00 	mov    0xe8(%rsp),%rcx
 18de76c:	4c 89 9c 24 e0 00 00 00 	mov    %r11,0xe0(%rsp)
 18de774:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
 18de779:	48 8d 05 80 e2 70 0d 	lea    0xd70e280(%rip),%rax        # efeca00 <x86_choice_forms_by_candidate>
 18de780:	48 8d 04 48          	lea    (%rax,%rcx,2),%rax
 18de784:	48 89 84 24 60 01 00 00 	mov    %rax,0x160(%rsp)
 18de78c:	48 8d 05 6d e6 70 0d 	lea    0xd70e66d(%rip),%rax        # efece00 <x86_choice_conditions_by_candidate>
 18de793:	48 8d 04 48          	lea    (%rax,%rcx,2),%rax
 18de797:	48 8b 8c 24 10 01 00 00 	mov    0x110(%rsp),%rcx
 18de79f:	48 89 84 24 38 01 00 00 	mov    %rax,0x138(%rsp)
 18de7a7:	31 c0                	xor    %eax,%eax
 18de7a9:	84 c9                	test   %cl,%cl
 18de7ab:	0f 95 c0             	setne  %al
 18de7ae:	c1 e0 18             	shl    $0x18,%eax
 18de7b1:	89 44 24 40          	mov    %eax,0x40(%rsp)
 18de7b5:	8d 41 e9             	lea    -0x17(%rcx),%eax
 18de7b8:	3c 02                	cmp    $0x2,%al
 18de7ba:	0f 93 c2             	setae  %dl
 18de7bd:	0f 42 f7             	cmovb  %edi,%esi
 18de7c0:	c0 e2 02             	shl    $0x2,%dl
 18de7c3:	89 b4 24 58 01 00 00 	mov    %esi,0x158(%rsp)
 18de7ca:	88 94 24 98 00 00 00 	mov    %dl,0x98(%rsp)
 18de7d1:	8d 51 e7             	lea    -0x19(%rcx),%edx
 18de7d4:	89 f1                	mov    %esi,%ecx
 18de7d6:	31 f6                	xor    %esi,%esi
 18de7d8:	80 e1 3a             	and    $0x3a,%cl
 18de7db:	89 54 24 58          	mov    %edx,0x58(%rsp)
 18de7df:	88 8c 24 50 01 00 00 	mov    %cl,0x150(%rsp)
 18de7e6:	eb 46                	jmp    18de82e <run_backend_benchmark+0x175e>
 18de7e8:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18de7f0:	66 ba 00 80          	mov    $0x8000,%dx
 18de7f4:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
 18de7f9:	48 8b 8c 24 60 01 00 00 	mov    0x160(%rsp),%rcx
 18de801:	66 89 3c 70          	mov    %di,(%rax,%rsi,2)
 18de805:	66 89 54 70 10       	mov    %dx,0x10(%rax,%rsi,2)
 18de80a:	48 89 f0             	mov    %rsi,%rax
 18de80d:	48 c1 e0 07          	shl    $0x7,%rax
 18de811:	48 ff c6             	inc    %rsi
 18de814:	66 89 3c 01          	mov    %di,(%rcx,%rax,1)
 18de818:	48 8b bc 24 38 01 00 00 	mov    0x138(%rsp),%rdi
 18de820:	66 89 14 07          	mov    %dx,(%rdi,%rax,1)
 18de824:	48 83 fe 08          	cmp    $0x8,%rsi
 18de828:	0f 84 b2 fd ff ff    	je     18de5e0 <run_backend_benchmark+0x1510>
 18de82e:	48 8d 04 76          	lea    (%rsi,%rsi,2),%rax
 18de832:	41 0f b7 3c 43       	movzwl (%r11,%rax,2),%edi
 18de837:	85 ff                	test   %edi,%edi
 18de839:	74 b5                	je     18de7f0 <run_backend_benchmark+0x1720>
 18de83b:	89 f9                	mov    %edi,%ecx
 18de83d:	81 e1 ff 7f 00 00    	and    $0x7fff,%ecx
 18de843:	ba 60 df ff ff       	mov    $0xffffdf60,%edx
 18de848:	41 b8 c0 be ff ff    	mov    $0xffffbec0,%r8d
 18de84e:	49 8d 04 43          	lea    (%r11,%rax,2),%rax
 18de852:	48 89 74 24 70       	mov    %rsi,0x70(%rsp)
 18de857:	89 bc 24 c0 00 00 00 	mov    %edi,0xc0(%rsp)
 18de85e:	66 81 f9 a0 20       	cmp    $0x20a0,%cx
 18de863:	41 0f 42 d6          	cmovb  %r14d,%edx
 18de867:	66 81 f9 40 41       	cmp    $0x4140,%cx
 18de86c:	41 0f 43 d0          	cmovae %r8d,%edx
 18de870:	01 ca                	add    %ecx,%edx
 18de872:	48 8d 0d 87 95 70 0d 	lea    0xd709587(%rip),%rcx        # efe7e00 <x86_effects_records>
 18de879:	81 fa a0 20 00 00    	cmp    $0x20a0,%edx
 18de87f:	41 0f 43 d6          	cmovae %r14d,%edx
 18de883:	0f b7 14 53          	movzwl (%rbx,%rdx,2),%edx
 18de887:	c1 e2 04             	shl    $0x4,%edx
 18de88a:	48 01 ca             	add    %rcx,%rdx
 18de88d:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
 18de892:	41 83 fd 14          	cmp    $0x14,%r13d
 18de896:	73 38                	jae    18de8d0 <run_backend_benchmark+0x1800>
 18de898:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18de8a0:	44 0f b7 40 02       	movzwl 0x2(%rax),%r8d
 18de8a5:	0f b6 51 09          	movzbl 0x9(%rcx),%edx
 18de8a9:	44 0f b7 49 06       	movzwl 0x6(%rcx),%r9d
 18de8ae:	44 89 84 24 d0 00 00 00 	mov    %r8d,0xd0(%rsp)
 18de8b6:	88 54 24 60          	mov    %dl,0x60(%rsp)
 18de8ba:	0f b6 51 0a          	movzbl 0xa(%rcx),%edx
 18de8be:	41 f6 c0 20          	test   $0x20,%r8b
 18de8c2:	0f 85 e6 00 00 00    	jne    18de9ae <run_backend_benchmark+0x18de>
 18de8c8:	0f b6 74 24 60       	movzbl 0x60(%rsp),%esi
 18de8cd:	eb 21                	jmp    18de8f0 <run_backend_benchmark+0x1820>
 18de8cf:	90                   	nop
 18de8d0:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18de8d8:	44 0f b7 49 06       	movzwl 0x6(%rcx),%r9d
 18de8dd:	0f b6 71 09          	movzbl 0x9(%rcx),%esi
 18de8e1:	0f b6 51 0a          	movzbl 0xa(%rcx),%edx
 18de8e5:	0f b7 48 02          	movzwl 0x2(%rax),%ecx
 18de8e9:	89 8c 24 d0 00 00 00 	mov    %ecx,0xd0(%rsp)
 18de8f0:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
 18de8f5:	0f b6 ca             	movzbl %dl,%ecx
 18de8f8:	41 83 e1 20          	and    $0x20,%r9d
 18de8fc:	40 0f b6 f6          	movzbl %sil,%esi
 18de900:	0f b6 40 04          	movzbl 0x4(%rax),%eax
 18de904:	89 ca                	mov    %ecx,%edx
 18de906:	c1 e2 10             	shl    $0x10,%edx
 18de909:	45 85 c9             	test   %r9d,%r9d
 18de90c:	41 0f 44 d1          	cmove  %r9d,%edx
 18de910:	03 54 24 40          	add    0x40(%rsp),%edx
 18de914:	c1 e1 08             	shl    $0x8,%ecx
 18de917:	41 0f b6 7f 0a       	movzbl 0xa(%r15),%edi
 18de91c:	45 0f b6 57 0c       	movzbl 0xc(%r15),%r10d
 18de921:	09 d1                	or     %edx,%ecx
 18de923:	09 ce                	or     %ecx,%esi
 18de925:	41 89 f8             	mov    %edi,%r8d
 18de928:	41 c1 e0 10          	shl    $0x10,%r8d
 18de92c:	41 f6 47 06 20       	testb  $0x20,0x6(%r15)
 18de931:	45 0f 44 c6          	cmove  %r14d,%r8d
 18de935:	45 31 c9             	xor    %r9d,%r9d
 18de938:	45 84 d2             	test   %r10b,%r10b
 18de93b:	41 0f 95 c1          	setne  %r9b
 18de93f:	c1 e7 08             	shl    $0x8,%edi
 18de942:	c1 ea 10             	shr    $0x10,%edx
 18de945:	44 09 c7             	or     %r8d,%edi
 18de948:	45 0f b6 47 09       	movzbl 0x9(%r15),%r8d
 18de94d:	41 c1 e1 18          	shl    $0x18,%r9d
 18de951:	44 09 cf             	or     %r9d,%edi
 18de954:	41 89 f1             	mov    %esi,%r9d
 18de957:	41 09 f8             	or     %edi,%r8d
 18de95a:	09 cf                	or     %ecx,%edi
 18de95c:	c1 e9 08             	shr    $0x8,%ecx
 18de95f:	45 09 c1             	or     %r8d,%r9d
 18de962:	c1 ef 08             	shr    $0x8,%edi
 18de965:	c4 e2 68 f2 c9       	andn   %ecx,%edx,%ecx
 18de96a:	41 21 f0             	and    %esi,%r8d
 18de96d:	41 09 f9             	or     %edi,%r9d
 18de970:	41 f7 d1             	not    %r9d
 18de973:	41 09 c9             	or     %ecx,%r9d
 18de976:	44 89 c1             	mov    %r8d,%ecx
 18de979:	41 c1 e8 10          	shr    $0x10,%r8d
 18de97d:	20 c1                	and    %al,%cl
 18de97f:	41 20 c0             	and    %al,%r8b
 18de982:	0f b6 c9             	movzbl %cl,%ecx
 18de985:	41 0f b6 c0          	movzbl %r8b,%eax
 18de989:	44 09 c9             	or     %r9d,%ecx
 18de98c:	09 c8                	or     %ecx,%eax
 18de98e:	b9 3f 00 00 00       	mov    $0x3f,%ecx
 18de993:	f7 d0                	not    %eax
 18de995:	83 e0 3f             	and    $0x3f,%eax
 18de998:	45 84 d2             	test   %r10b,%r10b
 18de99b:	0f 44 c1             	cmove  %ecx,%eax
 18de99e:	80 bc 24 10 01 00 00 00 	cmpb   $0x0,0x110(%rsp)
 18de9a6:	0f 44 c1             	cmove  %ecx,%eax
 18de9a9:	e9 55 02 00 00       	jmp    18dec03 <run_backend_benchmark+0x1b33>
 18de9ae:	0f b6 70 04          	movzbl 0x4(%rax),%esi
 18de9b2:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 18de9b7:	45 31 e4             	xor    %r12d,%r12d
 18de9ba:	44 0f b6 5c 24 60    	movzbl 0x60(%rsp),%r11d
 18de9c0:	41 b8 3b 00 00 00    	mov    $0x3b,%r8d
 18de9c6:	0f b6 48 09          	movzbl 0x9(%rax),%ecx
 18de9ca:	0f b6 58 0a          	movzbl 0xa(%rax),%ebx
 18de9ce:	88 8c 24 b0 00 00 00 	mov    %cl,0xb0(%rsp)
 18de9d5:	0f b7 48 06          	movzwl 0x6(%rax),%ecx
 18de9d9:	89 8c 24 80 00 00 00 	mov    %ecx,0x80(%rsp)
 18de9e0:	0f b6 48 0c          	movzbl 0xc(%rax),%ecx
 18de9e4:	84 c9                	test   %cl,%cl
 18de9e6:	8d 41 e9             	lea    -0x17(%rcx),%eax
 18de9e9:	48 89 8c 24 00 01 00 00 	mov    %rcx,0x100(%rsp)
 18de9f1:	41 0f 95 c4          	setne  %r12b
 18de9f5:	41 c1 e4 18          	shl    $0x18,%r12d
 18de9f9:	3c 02                	cmp    $0x2,%al
 18de9fb:	b8 21 00 00 00       	mov    $0x21,%eax
 18dea00:	44 0f 42 c0          	cmovb  %eax,%r8d
 18dea04:	8d 41 e7             	lea    -0x19(%rcx),%eax
 18dea07:	40 0f 93 c7          	setae  %dil
 18dea0b:	89 84 24 90 00 00 00 	mov    %eax,0x90(%rsp)
 18dea12:	44 89 c0             	mov    %r8d,%eax
 18dea15:	40 c0 e7 02          	shl    $0x2,%dil
 18dea19:	44 89 84 24 30 01 00 00 	mov    %r8d,0x130(%rsp)
 18dea21:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 18dea27:	24 3a                	and    $0x3a,%al
 18dea29:	40 88 7c 24 78       	mov    %dil,0x78(%rsp)
 18dea2e:	88 84 24 f0 00 00 00 	mov    %al,0xf0(%rsp)
 18dea35:	31 c0                	xor    %eax,%eax
 18dea37:	eb 23                	jmp    18dea5c <run_backend_benchmark+0x198c>
 18dea39:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18dea40:	44 0f b6 5c 24 60    	movzbl 0x60(%rsp),%r11d
 18dea46:	09 c8                	or     %ecx,%eax
 18dea48:	43 8d 0c 00          	lea    (%r8,%r8,1),%ecx
 18dea4c:	45 89 f9             	mov    %r15d,%r9d
 18dea4f:	41 83 f8 11          	cmp    $0x11,%r8d
 18dea53:	41 89 c8             	mov    %ecx,%r8d
 18dea56:	0f 83 7d 01 00 00    	jae    18debd9 <run_backend_benchmark+0x1b09>
 18dea5c:	44 8b 54 24 40       	mov    0x40(%rsp),%r10d
 18dea61:	44 89 df             	mov    %r11d,%edi
 18dea64:	41 89 d5             	mov    %edx,%r13d
 18dea67:	45 89 cf             	mov    %r9d,%r15d
 18dea6a:	41 f6 c1 20          	test   $0x20,%r9b
 18dea6e:	74 5e                	je     18deace <run_backend_benchmark+0x19fe>
 18dea70:	4c 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%r10
 18dea78:	89 d1                	mov    %edx,%ecx
 18dea7a:	41 89 d5             	mov    %edx,%r13d
 18dea7d:	44 89 df             	mov    %r11d,%edi
 18dea80:	45 0f b6 4a 0f       	movzbl 0xf(%r10),%r9d
 18dea85:	41 80 e1 0f          	and    $0xf,%r9b
 18dea89:	41 80 f9 02          	cmp    $0x2,%r9b
 18dea8d:	75 32                	jne    18deac1 <run_backend_benchmark+0x19f1>
 18dea8f:	80 7c 24 58 02       	cmpb   $0x2,0x58(%rsp)
 18dea94:	0f 92 c1             	setb   %cl
 18dea97:	41 80 7a 0d 00       	cmpb   $0x0,0xd(%r10)
 18dea9c:	41 0f 94 c5          	sete   %r13b
 18deaa0:	41 20 cd             	and    %cl,%r13b
 18deaa3:	75 0a                	jne    18deaaf <run_backend_benchmark+0x19df>
 18deaa5:	0f b6 bc 24 58 01 00 00 	movzbl 0x158(%rsp),%edi
 18deaad:	eb 08                	jmp    18deab7 <run_backend_benchmark+0x19e7>
 18deaaf:	0f b6 bc 24 50 01 00 00 	movzbl 0x150(%rsp),%edi
 18deab7:	44 02 ac 24 98 00 00 00 	add    0x98(%rsp),%r13b
 18deabf:	31 c9                	xor    %ecx,%ecx
 18deac1:	44 0f b6 d1          	movzbl %cl,%r10d
 18deac5:	41 c1 e2 10          	shl    $0x10,%r10d
 18deac9:	44 03 54 24 40       	add    0x40(%rsp),%r10d
 18deace:	f6 84 24 80 00 00 00 20 	testb  $0x20,0x80(%rsp)
 18dead6:	41 89 de             	mov    %ebx,%r14d
 18dead9:	0f b6 8c 24 b0 00 00 00 	movzbl 0xb0(%rsp),%ecx
 18deae1:	45 89 e1             	mov    %r12d,%r9d
 18deae4:	74 65                	je     18deb4b <run_backend_benchmark+0x1a7b>
 18deae6:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 18deaeb:	41 89 d9             	mov    %ebx,%r9d
 18deaee:	41 89 de             	mov    %ebx,%r14d
 18deaf1:	44 0f b6 59 0f       	movzbl 0xf(%rcx),%r11d
 18deaf6:	0f b6 8c 24 b0 00 00 00 	movzbl 0xb0(%rsp),%ecx
 18deafe:	41 80 e3 0f          	and    $0xf,%r11b
 18deb02:	41 80 fb 02          	cmp    $0x2,%r11b
 18deb06:	75 38                	jne    18deb40 <run_backend_benchmark+0x1a70>
 18deb08:	80 bc 24 90 00 00 00 02 	cmpb   $0x2,0x90(%rsp)
 18deb10:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 18deb15:	0f 92 c1             	setb   %cl
 18deb18:	41 80 79 0d 00       	cmpb   $0x0,0xd(%r9)
 18deb1d:	41 0f 94 c6          	sete   %r14b
 18deb21:	41 20 ce             	and    %cl,%r14b
 18deb24:	75 0a                	jne    18deb30 <run_backend_benchmark+0x1a60>
 18deb26:	0f b6 8c 24 30 01 00 00 	movzbl 0x130(%rsp),%ecx
 18deb2e:	eb 08                	jmp    18deb38 <run_backend_benchmark+0x1a68>
 18deb30:	0f b6 8c 24 f0 00 00 00 	movzbl 0xf0(%rsp),%ecx
 18deb38:	44 02 74 24 78       	add    0x78(%rsp),%r14b
 18deb3d:	45 31 c9             	xor    %r9d,%r9d
 18deb40:	45 0f b6 c9          	movzbl %r9b,%r9d
 18deb44:	41 c1 e1 10          	shl    $0x10,%r9d
 18deb48:	45 09 e1             	or     %r12d,%r9d
 18deb4b:	45 0f b6 dd          	movzbl %r13b,%r11d
 18deb4f:	45 0f b6 f6          	movzbl %r14b,%r14d
 18deb53:	40 0f b6 ff          	movzbl %dil,%edi
 18deb57:	0f b6 c9             	movzbl %cl,%ecx
 18deb5a:	45 89 d5             	mov    %r10d,%r13d
 18deb5d:	41 c1 ed 10          	shr    $0x10,%r13d
 18deb61:	41 c1 e3 08          	shl    $0x8,%r11d
 18deb65:	41 c1 e6 08          	shl    $0x8,%r14d
 18deb69:	45 01 d3             	add    %r10d,%r11d
 18deb6c:	45 01 ce             	add    %r9d,%r14d
 18deb6f:	44 09 f1             	or     %r14d,%ecx
 18deb72:	45 09 de             	or     %r11d,%r14d
 18deb75:	44 09 df             	or     %r11d,%edi
 18deb78:	41 c1 eb 08          	shr    $0x8,%r11d
 18deb7c:	c4 42 10 f2 db       	andn   %r11d,%r13d,%r11d
 18deb81:	41 89 fd             	mov    %edi,%r13d
 18deb84:	41 09 cd             	or     %ecx,%r13d
 18deb87:	41 c1 ee 08          	shr    $0x8,%r14d
 18deb8b:	21 f9                	and    %edi,%ecx
 18deb8d:	89 f7                	mov    %esi,%edi
 18deb8f:	45 09 f5             	or     %r14d,%r13d
 18deb92:	40 20 cf             	and    %cl,%dil
 18deb95:	c1 e9 10             	shr    $0x10,%ecx
 18deb98:	41 f7 d5             	not    %r13d
 18deb9b:	40 20 f1             	and    %sil,%cl
 18deb9e:	40 0f b6 ff          	movzbl %dil,%edi
 18deba2:	45 09 dd             	or     %r11d,%r13d
 18deba5:	0f b6 c9             	movzbl %cl,%ecx
 18deba8:	44 09 ef             	or     %r13d,%edi
 18debab:	09 f9                	or     %edi,%ecx
 18debad:	41 f7 c1 00 00 00 01 	test   $0x1000000,%r9d
 18debb4:	bf 3f 00 00 00       	mov    $0x3f,%edi
 18debb9:	f7 d1                	not    %ecx
 18debbb:	0f 44 cf             	cmove  %edi,%ecx
 18debbe:	41 f7 c2 00 00 00 01 	test   $0x1000000,%r10d
 18debc5:	0f 44 cf             	cmove  %edi,%ecx
 18debc8:	44 21 c1             	and    %r8d,%ecx
 18debcb:	0f 84 6f fe ff ff    	je     18dea40 <run_backend_benchmark+0x1970>
 18debd1:	44 89 c1             	mov    %r8d,%ecx
 18debd4:	e9 67 fe ff ff       	jmp    18dea40 <run_backend_benchmark+0x1970>
 18debd9:	4c 8b 9c 24 e0 00 00 00 	mov    0xe0(%rsp),%r11
 18debe1:	44 8b a4 24 08 01 00 00 	mov    0x108(%rsp),%r12d
 18debe9:	44 8b ac 24 f8 00 00 00 	mov    0xf8(%rsp),%r13d
 18debf1:	4c 8b 94 24 00 01 00 00 	mov    0x100(%rsp),%r10
 18debf9:	48 8d 1d c0 50 70 0d 	lea    0xd7050c0(%rip),%rbx        # efe3cc0 <x86_effects_index>
 18dec00:	45 31 f6             	xor    %r14d,%r14d
 18dec03:	31 c9                	xor    %ecx,%ecx
 18dec05:	a9 ea ff ff ff       	test   $0xffffffea,%eax
 18dec0a:	0f 95 c2             	setne  %dl
 18dec0d:	45 84 d2             	test   %r10b,%r10b
 18dec10:	74 19                	je     18dec2b <run_backend_benchmark+0x1b5b>
 18dec12:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
 18dec17:	0f b6 76 0f          	movzbl 0xf(%rsi),%esi
 18dec1b:	40 80 e6 0f          	and    $0xf,%sil
 18dec1f:	74 17                	je     18dec38 <run_backend_benchmark+0x1b68>
 18dec21:	40 3a b4 24 28 01 00 00 	cmp    0x128(%rsp),%sil
 18dec29:	74 0d                	je     18dec38 <run_backend_benchmark+0x1b68>
 18dec2b:	c7 84 24 d8 00 00 00 00 00 00 00 	movl   $0x0,0xd8(%rsp)
 18dec36:	eb 1e                	jmp    18dec56 <run_backend_benchmark+0x1b86>
 18dec38:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
 18dec3d:	8b bc 24 d8 00 00 00 	mov    0xd8(%rsp),%edi
 18dec44:	44 38 66 0d          	cmp    %r12b,0xd(%rsi)
 18dec48:	40 0f 96 c6          	setbe  %sil
 18dec4c:	40 20 f7             	and    %sil,%dil
 18dec4f:	89 bc 24 d8 00 00 00 	mov    %edi,0xd8(%rsp)
 18dec56:	89 c6                	mov    %eax,%esi
 18dec58:	89 c7                	mov    %eax,%edi
 18dec5a:	83 e6 01             	and    $0x1,%esi
 18dec5d:	83 e7 04             	and    $0x4,%edi
 18dec60:	88 d1                	mov    %dl,%cl
 18dec62:	83 e0 10             	and    $0x10,%eax
 18dec65:	8b 94 24 d0 00 00 00 	mov    0xd0(%rsp),%edx
 18dec6c:	c1 e6 0b             	shl    $0xb,%esi
 18dec6f:	c1 e7 0a             	shl    $0xa,%edi
 18dec72:	c1 e0 09             	shl    $0x9,%eax
 18dec75:	c1 e1 0e             	shl    $0xe,%ecx
 18dec78:	09 f7                	or     %esi,%edi
 18dec7a:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
 18dec7f:	09 f8                	or     %edi,%eax
 18dec81:	8b bc 24 c0 00 00 00 	mov    0xc0(%rsp),%edi
 18dec88:	09 c1                	or     %eax,%ecx
 18dec8a:	09 ca                	or     %ecx,%edx
 18dec8c:	81 ca 80 00 00 00    	or     $0x80,%edx
 18dec92:	e9 5d fb ff ff       	jmp    18de7f4 <run_backend_benchmark+0x1724>
 18dec97:	89 d1                	mov    %edx,%ecx
 18dec99:	f6 c1 01             	test   $0x1,%cl
 18dec9c:	0f 84 14 78 00 00    	je     18e64b6 <run_backend_benchmark+0x93e6>
 18deca2:	80 3d 57 e5 70 0d 00 	cmpb   $0x0,0xd70e557(%rip)        # efed200 <tier0_initialized>
 18deca9:	0f 85 94 37 00 00    	jne    18e2443 <run_backend_benchmark+0x5373>
 18decaf:	48 8d 3d 5a e5 70 0d 	lea    0xd70e55a(%rip),%rdi        # efed210 <tier0_slot_bases>
 18decb6:	ba 00 08 00 00       	mov    $0x800,%edx
 18decbb:	31 f6                	xor    %esi,%esi
 18decbd:	c5 f8 77             	vzeroupper
 18decc0:	e8 bb b1 eb fe       	call   799e80 <memset@plt>
 18decc5:	62 f1 7c 48 28 0d 31 71 c6 fe 	vmovaps -0x1398ecf(%rip),%zmm1        # 545e00 <branch_sizing_patterns+0x170>
 18deccf:	62 f3 7d 48 25 c0 ff 	vpternlogd $0xff,%zmm0,%zmm0,%zmm0
 18decd6:	62 f1 fd 48 6f 15 60 71 c6 fe 	vmovdqa64 -0x1398ea0(%rip),%zmm2        # 545e40 <branch_sizing_patterns+0x1b0>
 18dece0:	c7 05 26 ed 70 0d 00 00 00 00 	movl   $0x0,0xd70ed26(%rip)        # efeda10 <tier0_template_count>
 18decea:	c6 05 4f ee 70 0d 01 	movb   $0x1,0xd70ee4f(%rip)        # efedb40 <tier0_builder+0x100>
 18decf1:	c7 05 85 6e 71 0d 20 00 00 00 	movl   $0x20,0xd716e85(%rip)        # eff5b80 <tier0_slot_count>
 18decfb:	62 f1 fe 48 7f 05 7b ee 70 0d 	vmovdqu64 %zmm0,0xd70ee7b(%rip)        # efedb80 <tier0_slots>
 18ded05:	c4 e2 79 22 05 b2 75 c6 fe 	vpmovsxbq -0x1398a4e(%rip),%xmm0        # 5462c0 <branch_sizing_patterns+0x630>
 18ded0e:	62 f1 7c 48 29 0d a8 ae 72 0d 	vmovaps %zmm1,0xd72aea8(%rip)        # f009bc0 <tier0_integer_window>
 18ded18:	62 f1 fd 48 6f 0d 5e 71 c6 fe 	vmovdqa64 -0x1398ea2(%rip),%zmm1        # 545e80 <branch_sizing_patterns+0x1f0>
 18ded22:	62 f1 fd 48 7f 15 14 af 72 0d 	vmovdqa64 %zmm2,0xd72af14(%rip)        # f009c40 <tier0_floating_window>
 18ded2c:	62 f1 fd 48 7f 05 ca ae 72 0d 	vmovdqa64 %zmm0,0xd72aeca(%rip)        # f009c00 <tier0_integer_window+0x40>
 18ded36:	62 f1 fd 48 7f 0d 40 af 72 0d 	vmovdqa64 %zmm1,0xd72af40(%rip)        # f009c80 <tier0_floating_window+0x40>
 18ded40:	c5 f8 77             	vzeroupper
 18ded43:	e8 98 1c 01 00       	call   18f09e0 <tier0_define_templates>
 18ded48:	8b 05 32 6e 71 0d    	mov    0xd716e32(%rip),%eax        # eff5b80 <tier0_slot_count>
 18ded4e:	48 85 c0             	test   %rax,%rax
 18ded51:	0f 84 4d 01 00 00    	je     18deea4 <run_backend_benchmark+0x1dd4>
 18ded57:	48 01 c0             	add    %rax,%rax
 18ded5a:	48 8d 15 1f ee 70 0d 	lea    0xd70ee1f(%rip),%rdx        # efedb80 <tier0_slots>
 18ded61:	48 8d 35 28 6e 71 0d 	lea    0xd716e28(%rip),%rsi        # eff5b90 <tier0_template_infos>
 18ded68:	31 c9                	xor    %ecx,%ecx
 18ded6a:	eb 11                	jmp    18ded7d <run_backend_benchmark+0x1cad>
 18ded6c:	0f 1f 40 00          	nopl   0x0(%rax)
 18ded70:	48 83 c1 02          	add    $0x2,%rcx
 18ded74:	48 39 c8             	cmp    %rcx,%rax
 18ded77:	0f 84 27 01 00 00    	je     18deea4 <run_backend_benchmark+0x1dd4>
 18ded7d:	0f b7 3c 11          	movzwl (%rcx,%rdx,1),%edi
 18ded81:	66 83 ff fd          	cmp    $0xfffd,%di
 18ded85:	7f e9                	jg     18ded70 <run_backend_benchmark+0x1ca0>
 18ded87:	81 e7 ff 7f 00 00    	and    $0x7fff,%edi
 18ded8d:	48 8d 3c bf          	lea    (%rdi,%rdi,4),%rdi
 18ded91:	44 0f b6 4c fe 13    	movzbl 0x13(%rsi,%rdi,8),%r9d
 18ded97:	44 0f b6 54 fe 3b    	movzbl 0x3b(%rsi,%rdi,8),%r10d
 18ded9d:	45 89 c8             	mov    %r9d,%r8d
 18deda0:	45 89 d3             	mov    %r10d,%r11d
 18deda3:	41 c0 e8 02          	shr    $0x2,%r8b
 18deda7:	41 c0 eb 02          	shr    $0x2,%r11b
 18dedab:	41 80 e0 03          	and    $0x3,%r8b
 18dedaf:	41 80 e3 03          	and    $0x3,%r11b
 18dedb3:	41 0f b6 d8          	movzbl %r8b,%ebx
 18dedb7:	45 0f b6 c3          	movzbl %r11b,%r8d
 18dedbb:	44 38 c3             	cmp    %r8b,%bl
 18dedbe:	44 0f 47 c3          	cmova  %ebx,%r8d
 18dedc2:	41 80 e1 03          	and    $0x3,%r9b
 18dedc6:	41 80 e2 03          	and    $0x3,%r10b
 18dedca:	45 0f b6 d9          	movzbl %r9b,%r11d
 18dedce:	45 0f b6 ca          	movzbl %r10b,%r9d
 18dedd2:	44 8b 54 fe 40       	mov    0x40(%rsi,%rdi,8),%r10d
 18dedd7:	45 38 cb             	cmp    %r9b,%r11b
 18dedda:	45 0f 47 cb          	cmova  %r11d,%r9d
 18dedde:	44 0f b6 5c fe 63    	movzbl 0x63(%rsi,%rdi,8),%r11d
 18dede4:	44 0b 54 fe 18       	or     0x18(%rsi,%rdi,8),%r10d
 18dede9:	44 89 db             	mov    %r11d,%ebx
 18dedec:	c0 eb 02             	shr    $0x2,%bl
 18dedef:	80 e3 03             	and    $0x3,%bl
 18dedf2:	0f b6 db             	movzbl %bl,%ebx
 18dedf5:	41 38 d8             	cmp    %bl,%r8b
 18dedf8:	44 0f 46 c3          	cmovbe %ebx,%r8d
 18dedfc:	41 80 e3 03          	and    $0x3,%r11b
 18dee00:	45 0f b6 db          	movzbl %r11b,%r11d
 18dee04:	45 38 d9             	cmp    %r11b,%r9b
 18dee07:	45 0f 46 cb          	cmovbe %r11d,%r9d
 18dee0b:	44 0f b7 5c fe 0d    	movzwl 0xd(%rsi,%rdi,8),%r11d
 18dee11:	44 0b 54 fe 68       	or     0x68(%rsi,%rdi,8),%r10d
 18dee16:	c4 c1 79 6e c3       	vmovd  %r11d,%xmm0
 18dee1b:	44 0f b7 5c fe 35    	movzwl 0x35(%rsi,%rdi,8),%r11d
 18dee21:	c4 c1 79 6e cb       	vmovd  %r11d,%xmm1
 18dee26:	44 0f b7 5c fe 5d    	movzwl 0x5d(%rsi,%rdi,8),%r11d
 18dee2c:	c5 f1 de c0          	vpmaxub %xmm0,%xmm1,%xmm0
 18dee30:	c4 c1 79 6e cb       	vmovd  %r11d,%xmm1
 18dee35:	44 0f b7 9c fe 85 00 00 00 	movzwl 0x85(%rsi,%rdi,8),%r11d
 18dee3e:	c4 c1 79 6e d3       	vmovd  %r11d,%xmm2
 18dee43:	c5 e9 de c9          	vpmaxub %xmm1,%xmm2,%xmm1
 18dee47:	c5 f1 de c0          	vpmaxub %xmm0,%xmm1,%xmm0
 18dee4b:	c4 e3 79 14 44 fe 0d 00 	vpextrb $0x0,%xmm0,0xd(%rsi,%rdi,8)
 18dee53:	c4 e3 79 14 44 fe 0e 01 	vpextrb $0x1,%xmm0,0xe(%rsi,%rdi,8)
 18dee5b:	44 0f b6 9c fe 8b 00 00 00 	movzbl 0x8b(%rsi,%rdi,8),%r11d
 18dee64:	44 89 db             	mov    %r11d,%ebx
 18dee67:	c0 eb 02             	shr    $0x2,%bl
 18dee6a:	80 e3 03             	and    $0x3,%bl
 18dee6d:	0f b6 db             	movzbl %bl,%ebx
 18dee70:	41 38 d8             	cmp    %bl,%r8b
 18dee73:	44 0f 46 c3          	cmovbe %ebx,%r8d
 18dee77:	41 80 e3 03          	and    $0x3,%r11b
 18dee7b:	45 0f b6 db          	movzbl %r11b,%r11d
 18dee7f:	45 38 d9             	cmp    %r11b,%r9b
 18dee82:	45 0f 46 cb          	cmovbe %r11d,%r9d
 18dee86:	41 c0 e0 02          	shl    $0x2,%r8b
 18dee8a:	45 08 c8             	or     %r9b,%r8b
 18dee8d:	44 88 44 fe 13       	mov    %r8b,0x13(%rsi,%rdi,8)
 18dee92:	44 0b 94 fe 90 00 00 00 	or     0x90(%rsi,%rdi,8),%r10d
 18dee9a:	44 89 54 fe 18       	mov    %r10d,0x18(%rsi,%rdi,8)
 18dee9f:	e9 cc fe ff ff       	jmp    18ded70 <run_backend_benchmark+0x1ca0>
 18deea4:	80 3d 95 ec 70 0d 00 	cmpb   $0x0,0xd70ec95(%rip)        # efedb40 <tier0_builder+0x100>
 18deeab:	0f 84 fe 75 00 00    	je     18e64af <run_backend_benchmark+0x93df>
 18deeb1:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18deeb5:	62 f1 fd 48 7f 44 24 37 	vmovdqa64 %zmm0,0xdc0(%rsp)
 18deebd:	62 f1 fd 48 7f 44 24 36 	vmovdqa64 %zmm0,0xd80(%rsp)
 18deec5:	62 f1 fd 48 7f 44 24 35 	vmovdqa64 %zmm0,0xd40(%rsp)
 18deecd:	62 f1 fd 48 7f 44 24 34 	vmovdqa64 %zmm0,0xd00(%rsp)
 18deed5:	c4 e2 79 20 05 12 78 cd fe 	vpmovsxbw -0x13287ee(%rip),%xmm0        # 5b66f0 <x86_semantics_benchmark_code.registers+0xf8>
 18deede:	c4 e2 79 20 0d 11 78 cd fe 	vpmovsxbw -0x13287ef(%rip),%xmm1        # 5b66f8 <x86_semantics_benchmark_code.registers+0x100>
 18deee7:	c5 f9 6e 1d 91 d1 cc fe 	vmovd  -0x1332e6f(%rip),%xmm3        # 5ac080 <x86_effects_unknown+0xb0>
 18deeef:	b0 01                	mov    $0x1,%al
 18deef1:	48 8d 15 18 e3 70 0d 	lea    0xd70e318(%rip),%rdx        # efed210 <tier0_slot_bases>
 18deef8:	b9 01 00 00 00       	mov    $0x1,%ecx
 18deefd:	c5 e9 76 d2          	vpcmpeqd %xmm2,%xmm2,%xmm2
 18def01:	45 31 db             	xor    %r11d,%r11d
 18def04:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
 18def08:	45 31 d2             	xor    %r10d,%r10d
 18def0b:	89 44 24 30          	mov    %eax,0x30(%rsp)
 18def0f:	48 8d 05 6a ec 70 0d 	lea    0xd70ec6a(%rip),%rax        # efedb80 <tier0_slots>
 18def16:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
 18def1b:	eb 40                	jmp    18def5d <run_backend_benchmark+0x1e8d>
 18def1d:	0f 1f 00             	nopl   (%rax)
 18def20:	c5 f9 6f ac 24 80 02 00 00 	vmovdqa 0x280(%rsp),%xmm5
 18def29:	48 c1 e6 04          	shl    $0x4,%rsi
 18def2d:	ff c1                	inc    %ecx
 18def2f:	c5 f9 7f ac 34 00 0d 00 00 	vmovdqa %xmm5,0xd00(%rsp,%rsi,1)
 18def38:	83 fa 10             	cmp    $0x10,%edx
 18def3b:	48 8d 35 fe ae 7c 0d 	lea    0xd7caefe(%rip),%rsi        # f0a9e40 <tier0_vector_rows>
 18def42:	41 0f 43 d3          	cmovae %r11d,%edx
 18def46:	48 83 44 24 40 20    	addq   $0x20,0x40(%rsp)
 18def4c:	41 88 14 32          	mov    %dl,(%r10,%rsi,1)
 18def50:	49 ff c2             	inc    %r10
 18def53:	49 83 fa 40          	cmp    $0x40,%r10
 18def57:	0f 84 d9 03 00 00    	je     18df336 <run_backend_benchmark+0x2266>
 18def5d:	48 be 80 ff ff ff bb 37 33 03 	movabs $0x33337bbffffff80,%rsi
 18def67:	4b 8d 14 52          	lea    (%r10,%r10,2),%rdx
 18def6b:	4c 8d 05 2e b4 c6 fe 	lea    -0x1394bd2(%rip),%r8        # 54a3a0 <tier0_shapes>
 18def72:	45 8d 4a ed          	lea    -0x13(%r10),%r9d
 18def76:	41 8d 5a e2          	lea    -0x1e(%r10),%ebx
 18def7a:	46 8d 34 d5 10 ff ff ff 	lea    -0xf0(,%r10,8),%r14d
 18def82:	45 8d 7a f5          	lea    -0xb(%r10),%r15d
 18def86:	45 8d 62 f0          	lea    -0x10(%r10),%r12d
 18def8a:	4c 0f a3 d6          	bt     %r10,%rsi
 18def8e:	40 0f 92 c6          	setb   %sil
 18def92:	41 0f b6 7c 10 02    	movzbl 0x2(%r8,%rdx,1),%edi
 18def98:	40 c0 e6 02          	shl    $0x2,%sil
 18def9c:	41 0a 34 10          	or     (%r8,%rdx,1),%sil
 18defa0:	41 8d 52 ea          	lea    -0x16(%r10),%edx
 18defa4:	45 89 d0             	mov    %r10d,%r8d
 18defa7:	89 94 24 b0 00 00 00 	mov    %edx,0xb0(%rsp)
 18defae:	40 c0 e7 03          	shl    $0x3,%dil
 18defb2:	40 08 f7             	or     %sil,%dil
 18defb5:	83 fa 06             	cmp    $0x6,%edx
 18defb8:	0f 92 c2             	setb   %dl
 18defbb:	41 83 e0 3e          	and    $0x3e,%r8d
 18defbf:	41 83 f8 24          	cmp    $0x24,%r8d
 18defc3:	40 0f 94 c6          	sete   %sil
 18defc7:	40 00 f6             	add    %sil,%sil
 18defca:	41 83 f9 02          	cmp    $0x2,%r9d
 18defce:	41 0f 92 c1          	setb   %r9b
 18defd2:	41 c0 e1 02          	shl    $0x2,%r9b
 18defd6:	83 fb 06             	cmp    $0x6,%ebx
 18defd9:	48 bb 08 00 08 00 00 08 00 00 	movabs $0x80000080008,%rbx
 18defe3:	c4 e2 8b f7 db       	shrx   %r14,%rbx,%rbx
 18defe8:	41 0f 43 db          	cmovae %r11d,%ebx
 18defec:	49 83 fa 0d          	cmp    $0xd,%r10
 18deff0:	41 0f 94 c6          	sete   %r14b
 18deff4:	41 08 d6             	or     %dl,%r14b
 18deff7:	41 c0 e6 04          	shl    $0x4,%r14b
 18deffb:	41 83 ff 02          	cmp    $0x2,%r15d
 18defff:	41 0f 92 c7          	setb   %r15b
 18df003:	41 83 fc 05          	cmp    $0x5,%r12d
 18df007:	41 0f 92 c4          	setb   %r12b
 18df00b:	45 08 fc             	or     %r15b,%r12b
 18df00e:	45 89 d7             	mov    %r10d,%r15d
 18df011:	41 83 e7 3c          	and    $0x3c,%r15d
 18df015:	41 c0 e4 05          	shl    $0x5,%r12b
 18df019:	41 83 ff 24          	cmp    $0x24,%r15d
 18df01d:	41 0f 94 c7          	sete   %r15b
 18df021:	41 c0 e7 06          	shl    $0x6,%r15b
 18df025:	45 08 cf             	or     %r9b,%r15b
 18df028:	41 08 f7             	or     %sil,%r15b
 18df02b:	41 08 d7             	or     %dl,%r15b
 18df02e:	48 8d 15 8b ac 7c 0d 	lea    0xd7cac8b(%rip),%rdx        # f0a9cc0 <tier0_vector_shapes>
 18df035:	45 08 e7             	or     %r12b,%r15b
 18df038:	41 88 3c 12          	mov    %dil,(%r10,%rdx,1)
 18df03c:	48 8d 3d fd ac 7c 0d 	lea    0xd7cacfd(%rip),%rdi        # f0a9d40 <tier0_vector_accesses>
 18df043:	48 8d 15 b6 ac 7c 0d 	lea    0xd7cacb6(%rip),%rdx        # f0a9d00 <tier0_vector_kind_flags>
 18df04a:	45 08 f7             	or     %r14b,%r15b
 18df04d:	45 88 14 3a          	mov    %r10b,(%r10,%rdi,1)
 18df051:	41 08 df             	or     %bl,%r15b
 18df054:	45 88 3c 12          	mov    %r15b,(%r10,%rdx,1)
 18df058:	41 83 f8 04          	cmp    $0x4,%r8d
 18df05c:	74 06                	je     18df064 <run_backend_benchmark+0x1f94>
 18df05e:	41 83 f8 20          	cmp    $0x20,%r8d
 18df062:	75 2c                	jne    18df090 <run_backend_benchmark+0x1fc0>
 18df064:	44 89 d2             	mov    %r10d,%edx
 18df067:	44 89 d6             	mov    %r10d,%esi
 18df06a:	c1 ee 04             	shr    $0x4,%esi
 18df06d:	83 e2 01             	and    $0x1,%edx
 18df070:	01 f2                	add    %esi,%edx
 18df072:	8d 72 2e             	lea    0x2e(%rdx),%esi
 18df075:	41 88 74 3a 40       	mov    %sil,0x40(%r10,%rdi,1)
 18df07a:	8d 72 32             	lea    0x32(%rdx),%esi
 18df07d:	80 c2 36             	add    $0x36,%dl
 18df080:	41 88 b4 3a 80 00 00 00 	mov    %sil,0x80(%r10,%rdi,1)
 18df088:	eb 16                	jmp    18df0a0 <run_backend_benchmark+0x1fd0>
 18df08a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 18df090:	44 89 d2             	mov    %r10d,%edx
 18df093:	45 88 54 3a 40       	mov    %r10b,0x40(%r10,%rdi,1)
 18df098:	45 88 94 3a 80 00 00 00 	mov    %r10b,0x80(%r10,%rdi,1)
 18df0a0:	49 83 fa 3a          	cmp    $0x3a,%r10
 18df0a4:	41 88 94 3a c0 00 00 00 	mov    %dl,0xc0(%r10,%rdi,1)
 18df0ac:	41 bb 00 00 00 00    	mov    $0x0,%r11d
 18df0b2:	40 0f 92 c6          	setb   %sil
 18df0b6:	49 83 fa 09          	cmp    $0x9,%r10
 18df0ba:	40 0f 95 c7          	setne  %dil
 18df0be:	49 83 fa 0a          	cmp    $0xa,%r10
 18df0c2:	41 0f 94 c0          	sete   %r8b
 18df0c6:	49 83 fa 1d          	cmp    $0x1d,%r10
 18df0ca:	0f 94 c2             	sete   %dl
 18df0cd:	40 84 fe             	test   %dil,%sil
 18df0d0:	0f 84 fa 01 00 00    	je     18df2d0 <run_backend_benchmark+0x2200>
 18df0d6:	41 08 d0             	or     %dl,%r8b
 18df0d9:	45 31 c9             	xor    %r9d,%r9d
 18df0dc:	44 88 44 24 60       	mov    %r8b,0x60(%rsp)
 18df0e1:	eb 23                	jmp    18df106 <run_backend_benchmark+0x2036>
 18df0e3:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18df0f0:	44 0f b6 44 24 60    	movzbl 0x60(%rsp),%r8d
 18df0f6:	49 ff c1             	inc    %r9
 18df0f9:	4c 89 f8             	mov    %r15,%rax
 18df0fc:	49 83 f9 10          	cmp    $0x10,%r9
 18df100:	0f 84 d3 01 00 00    	je     18df2d9 <run_backend_benchmark+0x2209>
 18df106:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 18df10b:	46 0f b7 34 4a       	movzwl (%rdx,%r9,2),%r14d
 18df110:	ba 07 00 04 00       	mov    $0x40007,%edx
 18df115:	c5 fb 92 ca          	kmovd  %edx,%k1
 18df119:	66 ba ef 01          	mov    $0x1ef,%dx
 18df11d:	62 b1 ff c9 6f ac 70 02 00 00 00 	vmovdqu16 0x2(%rax,%r14,2),%zmm5{%k1}{z}
 18df128:	c5 fb 92 ca          	kmovd  %edx,%k1
 18df12c:	46 0f b7 7c 70 28    	movzwl 0x28(%rax,%r14,2),%r15d
 18df132:	42 0f b7 54 70 1a    	movzwl 0x1a(%rax,%r14,2),%edx
 18df138:	42 0f b7 74 70 24    	movzwl 0x24(%rax,%r14,2),%esi
 18df13e:	4a 8d 3c 70          	lea    (%rax,%r14,2),%rdi
 18df142:	62 b1 ff a9 6f b4 70 12 00 00 00 	vmovdqu16 0x12(%rax,%r14,2),%ymm6{%k1}{z}
 18df14d:	49 83 fa 0a          	cmp    $0xa,%r10
 18df151:	75 3d                	jne    18df190 <run_backend_benchmark+0x20c0>
 18df153:	4c 8d 1d b6 e0 70 0d 	lea    0xd70e0b6(%rip),%r11        # efed210 <tier0_slot_bases>
 18df15a:	45 31 ed             	xor    %r13d,%r13d
 18df15d:	45 0f b6 e0          	movzbl %r8b,%r12d
 18df161:	43 0f b7 9c 4b 40 01 00 00 	movzwl 0x140(%r11,%r9,2),%ebx
 18df16a:	c5 fa 7e 7c 58 08    	vmovq  0x8(%rax,%rbx,2),%xmm7
 18df170:	62 f1 45 08 75 c2    	vpcmpeqw %xmm2,%xmm7,%k0
 18df176:	c5 fb 93 d8          	kmovd  %k0,%ebx
 18df17a:	f6 c3 0f             	test   $0xf,%bl
 18df17d:	bb 08 00 00 00       	mov    $0x8,%ebx
 18df182:	45 0f 45 e5          	cmovne %r13d,%r12d
 18df186:	45 31 c0             	xor    %r8d,%r8d
 18df189:	eb 50                	jmp    18df1db <run_backend_benchmark+0x210b>
 18df18b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18df190:	c5 fa 7e 7f 32       	vmovq  0x32(%rdi),%xmm7
 18df195:	c5 7a 7e 47 2a       	vmovq  0x2a(%rdi),%xmm8
 18df19a:	49 83 fa 1d          	cmp    $0x1d,%r10
 18df19e:	0f 94 c3             	sete   %bl
 18df1a1:	62 f1 45 08 75 c2    	vpcmpeqw %xmm2,%xmm7,%k0
 18df1a7:	c5 7b 93 e0          	kmovd  %k0,%r12d
 18df1ab:	62 f1 3d 08 75 c2    	vpcmpeqw %xmm2,%xmm8,%k0
 18df1b1:	41 f6 c4 0f          	test   $0xf,%r12b
 18df1b5:	45 0f b6 e0          	movzbl %r8b,%r12d
 18df1b9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 18df1bf:	c5 7b 93 e8          	kmovd  %k0,%r13d
 18df1c3:	45 0f 45 e0          	cmovne %r8d,%r12d
 18df1c7:	41 f6 c5 0f          	test   $0xf,%r13b
 18df1cb:	41 0f 94 c5          	sete   %r13b
 18df1cf:	41 20 dd             	and    %bl,%r13b
 18df1d2:	bb 1d 00 00 00       	mov    $0x1d,%ebx
 18df1d7:	41 c0 e5 07          	shl    $0x7,%r13b
 18df1db:	62 f2 f5 28 8d f6    	vpermw %ymm6,%ymm1,%ymm6
 18df1e1:	62 f2 fd 48 8d ed    	vpermw %zmm5,%zmm0,%zmm5
 18df1e7:	66 83 fa ff          	cmp    $0xffff,%dx
 18df1eb:	41 0f 95 c3          	setne  %r11b
 18df1ef:	66 83 fe ff          	cmp    $0xffff,%si
 18df1f3:	0f 95 c2             	setne  %dl
 18df1f6:	62 f1 4d 08 75 c2    	vpcmpeqw %xmm2,%xmm6,%k0
 18df1fc:	c5 f9 98 c0          	kortestb %k0,%k0
 18df200:	62 f1 55 08 75 c2    	vpcmpeqw %xmm2,%xmm5,%k0
 18df206:	62 f3 d5 08 3f ca 04 	vpcmpneqw %xmm2,%xmm5,%k1
 18df20d:	62 f2 7e 08 38 e9    	vpmovm2d %k1,%xmm5
 18df213:	62 f2 7e 08 38 f0    	vpmovm2d %k0,%xmm6
 18df219:	c4 e3 49 02 ed 01    	vpblendd $0x1,%xmm5,%xmm6,%xmm5
 18df21f:	40 0f 94 c6          	sete   %sil
 18df223:	44 20 da             	and    %r11b,%dl
 18df226:	4c 8d 1c 58          	lea    (%rax,%rbx,2),%r11
 18df22a:	62 f2 7e 08 39 cd    	vpmovd2m %xmm5,%k1
 18df230:	62 f2 65 09 66 2d e6 cd cc fe 	vpblendmb -0x133321a(%rip),%xmm3,%xmm5{%k1}        # 5ac020 <x86_effects_unknown+0x50>
 18df23a:	40 20 f2             	and    %sil,%dl
 18df23d:	66 41 83 ff ff       	cmp    $0xffff,%r15w
 18df242:	49 89 c7             	mov    %rax,%r15
 18df245:	40 0f 95 c6          	setne  %sil
 18df249:	c0 e2 05             	shl    $0x5,%dl
 18df24c:	41 c0 e4 06          	shl    $0x6,%r12b
 18df250:	40 c0 e6 04          	shl    $0x4,%sil
 18df254:	66 43 83 3c 73 ff    	cmpw   $0xffff,(%r11,%r14,2)
 18df25a:	45 0f b6 dc          	movzbl %r12b,%r11d
 18df25e:	45 0f 44 d8          	cmove  %r8d,%r11d
 18df262:	c5 c9 72 d5 10       	vpsrld $0x10,%xmm5,%xmm6
 18df267:	41 08 d3             	or     %dl,%r11b
 18df26a:	c5 d1 eb ee          	vpor   %xmm6,%xmm5,%xmm5
 18df26e:	c5 c9 71 d5 08       	vpsrlw $0x8,%xmm5,%xmm6
 18df273:	c5 d1 eb ee          	vpor   %xmm6,%xmm5,%xmm5
 18df277:	c5 f9 7e eb          	vmovd  %xmm5,%ebx
 18df27b:	40 08 f3             	or     %sil,%bl
 18df27e:	41 08 db             	or     %bl,%r11b
 18df281:	45 08 eb             	or     %r13b,%r11b
 18df284:	83 bc 24 b0 00 00 00 05 	cmpl   $0x5,0xb0(%rsp)
 18df28c:	46 88 9c 0c 80 02 00 00 	mov    %r11b,0x280(%rsp,%r9,1)
 18df294:	41 bb 00 00 00 00    	mov    $0x0,%r11d
 18df29a:	0f 87 50 fe ff ff    	ja     18df0f0 <run_backend_benchmark+0x2020>
 18df2a0:	66 83 7f 08 ff       	cmpw   $0xffff,0x8(%rdi)
 18df2a5:	c4 e3 79 30 c0 02    	kshiftrb $0x2,%k0,%k0
 18df2ab:	c5 fb 93 d0          	kmovd  %k0,%edx
 18df2af:	40 0f 95 c6          	setne  %sil
 18df2b3:	40 30 d6             	xor    %dl,%sil
 18df2b6:	8b 54 24 30          	mov    0x30(%rsp),%edx
 18df2ba:	40 20 f2             	and    %sil,%dl
 18df2bd:	89 54 24 30          	mov    %edx,0x30(%rsp)
 18df2c1:	e9 2a fe ff ff       	jmp    18df0f0 <run_backend_benchmark+0x2020>
 18df2c6:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18df2d0:	c5 f9 7f a4 24 80 02 00 00 	vmovdqa %xmm4,0x280(%rsp)
 18df2d9:	48 8d bc 24 00 0d 00 00 	lea    0xd00(%rsp),%rdi
 18df2e1:	89 ce                	mov    %ecx,%esi
 18df2e3:	45 31 c0             	xor    %r8d,%r8d
 18df2e6:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18df2f0:	c5 fa 6f 2f          	vmovdqu (%rdi),%xmm5
 18df2f4:	89 ca                	mov    %ecx,%edx
 18df2f6:	c5 d1 ef ac 24 80 02 00 00 	vpxor  0x280(%rsp),%xmm5,%xmm5
 18df2ff:	c4 e2 79 17 ed       	vptest %xmm5,%xmm5
 18df304:	41 0f 44 d0          	cmove  %r8d,%edx
 18df308:	49 ff c0             	inc    %r8
 18df30b:	49 39 f0             	cmp    %rsi,%r8
 18df30e:	73 08                	jae    18df318 <run_backend_benchmark+0x2248>
 18df310:	48 83 c7 10          	add    $0x10,%rdi
 18df314:	39 ca                	cmp    %ecx,%edx
 18df316:	74 d8                	je     18df2f0 <run_backend_benchmark+0x2220>
 18df318:	39 ca                	cmp    %ecx,%edx
 18df31a:	0f 85 18 fc ff ff    	jne    18def38 <run_backend_benchmark+0x1e68>
 18df320:	83 f9 0f             	cmp    $0xf,%ecx
 18df323:	0f 86 f7 fb ff ff    	jbe    18def20 <run_backend_benchmark+0x1e50>
 18df329:	c7 44 24 30 00 00 00 00 	movl   $0x0,0x30(%rsp)
 18df331:	e9 02 fc ff ff       	jmp    18def38 <run_backend_benchmark+0x1e68>
 18df336:	62 f1 7c 48 28 44 24 34 	vmovaps 0xd00(%rsp),%zmm0
 18df33e:	62 f1 7c 48 28 54 24 36 	vmovaps 0xd80(%rsp),%zmm2
 18df346:	62 f1 7c 48 28 5c 24 37 	vmovaps 0xdc0(%rsp),%zmm3
 18df34e:	62 f1 fd 48 6f 4c 24 35 	vmovdqa64 0xd40(%rsp),%zmm1
 18df356:	48 8d 35 02 ad 7c 0d 	lea    0xd7cad02(%rip),%rsi        # f0aa05f <tier0_vector_convert_home+0x1f>
 18df35d:	48 8d 15 ac de 70 0d 	lea    0xd70deac(%rip),%rdx        # efed210 <tier0_slot_bases>
 18df364:	31 ff                	xor    %edi,%edi
 18df366:	62 f1 7c 48 29 05 10 ab 7c 0d 	vmovaps %zmm0,0xd7cab10(%rip)        # f0a9e80 <tier0_vector_properties>
 18df370:	62 f2 7d 48 5a 05 16 cd cc fe 	vbroadcasti32x4 -0x13332ea(%rip),%zmm0        # 5ac090 <x86_effects_unknown+0xc0>
 18df37a:	62 f1 7c 48 29 1d bc ab 7c 0d 	vmovaps %zmm3,0xd7cabbc(%rip)        # f0a9f40 <tier0_vector_properties+0xc0>
 18df384:	62 f1 7c 48 29 15 72 ab 7c 0d 	vmovaps %zmm2,0xd7cab72(%rip)        # f0a9f00 <tier0_vector_properties+0x80>
 18df38e:	62 f2 7d 48 5a 1d 08 cd cc fe 	vbroadcasti32x4 -0x13332f8(%rip),%zmm3        # 5ac0a0 <x86_effects_unknown+0xd0>
 18df398:	62 f2 7d 48 5a 15 0e cd cc fe 	vbroadcasti32x4 -0x13332f2(%rip),%zmm2        # 5ac0b0 <x86_effects_unknown+0xe0>
 18df3a2:	62 f1 fd 48 7f 0d 14 ab 7c 0d 	vmovdqa64 %zmm1,0xd7cab14(%rip)        # f0a9ec0 <tier0_vector_properties+0x40>
 18df3ac:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18df3b0:	62 f1 fd 48 7f 05 46 ac 7c 0d 	vmovdqa64 %zmm0,0xd7cac46(%rip)        # f0aa000 <tier0_vector_integer>
 18df3ba:	c5 f9 76 c0          	vpcmpeqd %xmm0,%xmm0,%xmm0
 18df3be:	62 f1 fd 48 7f 1d b8 ab 7c 0d 	vmovdqa64 %zmm3,0xd7cabb8(%rip)        # f0a9f80 <tier0_vector_stacks>
 18df3c8:	62 f1 fd 48 7f 15 ee ab 7c 0d 	vmovdqa64 %zmm2,0xd7cabee(%rip)        # f0a9fc0 <tier0_vector_wide>
 18df3d2:	e9 82 00 00 00       	jmp    18df459 <run_backend_benchmark+0x2389>
 18df3d7:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18df3e0:	0f b7 8c 7a 22 01 00 00 	movzwl 0x122(%rdx,%rdi,2),%ecx
 18df3e8:	62 f3 fd 08 3f 4c 48 02 04 	vpcmpneqw 0x20(%rax,%rcx,2),%xmm0,%k1
 18df3f1:	62 f1 7f 89 6f 15 35 cc cc fe 	vmovdqu8 -0x13333cb(%rip),%xmm2{%k1}{z}        # 5ac030 <x86_effects_unknown+0x60>
 18df3fb:	c5 f9 d6 56 f1       	vmovq  %xmm2,-0xf(%rsi)
 18df400:	c5 fa 7e 54 48 30    	vmovq  0x30(%rax,%rcx,2),%xmm2
 18df406:	62 f3 ed 08 3f c8 04 	vpcmpneqw %xmm0,%xmm2,%k1
 18df40d:	62 f1 7f 89 6f 15 29 cc cc fe 	vmovdqu8 -0x13333d7(%rip),%xmm2{%k1}{z}        # 5ac040 <x86_effects_unknown+0x70>
 18df417:	c5 f9 7e 56 f9       	vmovd  %xmm2,-0x7(%rsi)
 18df41c:	c5 f9 6e 54 48 38    	vmovd  0x38(%rax,%rcx,2),%xmm2
 18df422:	62 f3 ed 08 3f c8 04 	vpcmpneqw %xmm0,%xmm2,%k1
 18df429:	62 f1 7f 89 6f 15 1d cc cc fe 	vmovdqu8 -0x13333e3(%rip),%xmm2{%k1}{z}        # 5ac050 <x86_effects_unknown+0x80>
 18df433:	c4 e3 79 14 56 fd 00 	vpextrb $0x0,%xmm2,-0x3(%rsi)
 18df43a:	c4 e3 79 14 56 fe 01 	vpextrb $0x1,%xmm2,-0x2(%rsi)
 18df441:	66 c7 46 ff 00 00    	movw   $0x0,-0x1(%rsi)
 18df447:	48 83 c7 02          	add    $0x2,%rdi
 18df44b:	48 83 c6 20          	add    $0x20,%rsi
 18df44f:	48 83 ff 10          	cmp    $0x10,%rdi
 18df453:	0f 84 b3 00 00 00    	je     18df50c <run_backend_benchmark+0x243c>
 18df459:	48 83 ff 0e          	cmp    $0xe,%rdi
 18df45d:	0f 83 7d 00 00 00    	jae    18df4e0 <run_backend_benchmark+0x2410>
 18df463:	0f b7 8c 7a 20 01 00 00 	movzwl 0x120(%rdx,%rdi,2),%ecx
 18df46b:	62 f3 fd 08 3f 4c 48 02 04 	vpcmpneqw 0x20(%rax,%rcx,2),%xmm0,%k1
 18df474:	62 f1 7f 89 6f 15 b2 cb cc fe 	vmovdqu8 -0x133344e(%rip),%xmm2{%k1}{z}        # 5ac030 <x86_effects_unknown+0x60>
 18df47e:	c5 f9 d6 56 e1       	vmovq  %xmm2,-0x1f(%rsi)
 18df483:	c5 fa 7e 54 48 30    	vmovq  0x30(%rax,%rcx,2),%xmm2
 18df489:	62 f3 ed 08 3f c8 04 	vpcmpneqw %xmm0,%xmm2,%k1
 18df490:	62 f1 7f 89 6f 15 a6 cb cc fe 	vmovdqu8 -0x133345a(%rip),%xmm2{%k1}{z}        # 5ac040 <x86_effects_unknown+0x70>
 18df49a:	c5 f9 7e 56 e9       	vmovd  %xmm2,-0x17(%rsi)
 18df49f:	c5 f9 6e 54 48 38    	vmovd  0x38(%rax,%rcx,2),%xmm2
 18df4a5:	62 f3 ed 08 3f c8 04 	vpcmpneqw %xmm0,%xmm2,%k1
 18df4ac:	62 f1 7f 89 6f 15 9a cb cc fe 	vmovdqu8 -0x1333466(%rip),%xmm2{%k1}{z}        # 5ac050 <x86_effects_unknown+0x80>
 18df4b6:	c4 e3 79 14 56 ed 00 	vpextrb $0x0,%xmm2,-0x13(%rsi)
 18df4bd:	c4 e3 79 14 56 ee 01 	vpextrb $0x1,%xmm2,-0x12(%rsi)
 18df4c4:	66 c7 46 ef 00 00    	movw   $0x0,-0x11(%rsi)
 18df4ca:	48 83 ff 0e          	cmp    $0xe,%rdi
 18df4ce:	0f 82 0c ff ff ff    	jb     18df3e0 <run_backend_benchmark+0x2310>
 18df4d4:	eb 1c                	jmp    18df4f2 <run_backend_benchmark+0x2422>
 18df4d6:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18df4e0:	48 8d 4e e1          	lea    -0x1f(%rsi),%rcx
 18df4e4:	c5 f9 7f 09          	vmovdqa %xmm1,(%rcx)
 18df4e8:	48 83 ff 0e          	cmp    $0xe,%rdi
 18df4ec:	0f 82 ee fe ff ff    	jb     18df3e0 <run_backend_benchmark+0x2310>
 18df4f2:	48 8d 4e f1          	lea    -0xf(%rsi),%rcx
 18df4f6:	c5 f9 7f 09          	vmovdqa %xmm1,(%rcx)
 18df4fa:	48 83 c7 02          	add    $0x2,%rdi
 18df4fe:	48 83 c6 20          	add    $0x20,%rsi
 18df502:	48 83 ff 10          	cmp    $0x10,%rdi
 18df506:	0f 85 4d ff ff ff    	jne    18df459 <run_backend_benchmark+0x2389>
 18df50c:	f6 44 24 30 01       	testb  $0x1,0x30(%rsp)
 18df511:	0f 84 98 6f 00 00    	je     18e64af <run_backend_benchmark+0x93df>
 18df517:	8b 15 f3 e4 70 0d    	mov    0xd70e4f3(%rip),%edx        # efeda10 <tier0_template_count>
 18df51d:	48 81 fa 01 10 00 00 	cmp    $0x1001,%rdx
 18df524:	48 89 94 24 80 00 00 00 	mov    %rdx,0x80(%rsp)
 18df52c:	0f 92 c1             	setb   %cl
 18df52f:	88 4c 24 60          	mov    %cl,0x60(%rsp)
 18df533:	48 85 d2             	test   %rdx,%rdx
 18df536:	0f 84 47 02 00 00    	je     18df783 <run_backend_benchmark+0x26b3>
 18df53c:	48 8d 3d 4d 66 71 0d 	lea    0xd71664d(%rip),%rdi        # eff5b90 <tier0_template_infos>
 18df543:	45 31 c9             	xor    %r9d,%r9d
 18df546:	45 31 db             	xor    %r11d,%r11d
 18df549:	e9 d9 00 00 00       	jmp    18df627 <run_backend_benchmark+0x2557>
 18df54e:	66 90                	xchg   %ax,%ax
 18df550:	0f b6 54 24 30       	movzbl 0x30(%rsp),%edx
 18df555:	31 db                	xor    %ebx,%ebx
 18df557:	49 89 ca             	mov    %rcx,%r10
 18df55a:	48 be 00 00 00 00 00 70 00 00 	movabs $0x700000000000,%rsi
 18df564:	20 54 24 60          	and    %dl,0x60(%rsp)
 18df568:	80 bc 24 b0 00 00 00 00 	cmpb   $0x0,0xb0(%rsp)
 18df570:	48 ba 00 00 00 00 00 00 1c 00 	movabs $0x1c000000000000,%rdx
 18df57a:	0f 95 c3             	setne  %bl
 18df57d:	49 c1 e2 32          	shl    $0x32,%r10
 18df581:	48 81 f9 ff 00 00 00 	cmp    $0xff,%rcx
 18df588:	4c 89 c1             	mov    %r8,%rcx
 18df58b:	4c 0f 44 d2          	cmove  %rdx,%r10
 18df58f:	48 c1 e1 2f          	shl    $0x2f,%rcx
 18df593:	49 81 f8 ff 00 00 00 	cmp    $0xff,%r8
 18df59a:	48 ba 00 00 00 00 00 80 03 00 	movabs $0x3800000000000,%rdx
 18df5a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 18df5aa:	48 0f 44 ca          	cmove  %rdx,%rcx
 18df5ae:	4c 89 e2             	mov    %r12,%rdx
 18df5b1:	48 c1 e2 2c          	shl    $0x2c,%rdx
 18df5b5:	49 81 fc ff 00 00 00 	cmp    $0xff,%r12
 18df5bc:	48 0f 44 d6          	cmove  %rsi,%rdx
 18df5c0:	80 7f 02 00          	cmpb   $0x0,0x2(%rdi)
 18df5c4:	48 be 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rsi
 18df5ce:	48 8d b6 00 00 e0 ff 	lea    -0x200000(%rsi),%rsi
 18df5d5:	4c 0f 45 c6          	cmovne %rsi,%r8
 18df5d9:	48 c1 e3 25          	shl    $0x25,%rbx
 18df5dd:	4c 09 d1             	or     %r10,%rcx
 18df5e0:	49 c1 e1 35          	shl    $0x35,%r9
 18df5e4:	49 ff c3             	inc    %r11
 18df5e7:	48 09 d3             	or     %rdx,%rbx
 18df5ea:	0f b6 57 05          	movzbl 0x5(%rdi),%edx
 18df5ee:	4c 09 c9             	or     %r9,%rcx
 18df5f1:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 18df5f6:	48 83 c7 28          	add    $0x28,%rdi
 18df5fa:	48 09 d9             	or     %rbx,%rcx
 18df5fd:	4c 09 c1             	or     %r8,%rcx
 18df600:	4c 09 f1             	or     %r14,%rcx
 18df603:	48 c1 e2 26          	shl    $0x26,%rdx
 18df607:	48 09 d1             	or     %rdx,%rcx
 18df60a:	48 8d 15 2f eb 7c 0d 	lea    0xd7ceb2f(%rip),%rdx        # f0ae140 <tier0_template_words>
 18df611:	49 89 0c 11          	mov    %rcx,(%r9,%rdx,1)
 18df615:	49 83 c1 08          	add    $0x8,%r9
 18df619:	4c 39 9c 24 80 00 00 00 	cmp    %r11,0x80(%rsp)
 18df621:	0f 84 5c 01 00 00    	je     18df783 <run_backend_benchmark+0x26b3>
 18df627:	44 8b 77 18          	mov    0x18(%rdi),%r14d
 18df62b:	0f b6 74 24 60       	movzbl 0x60(%rsp),%esi
 18df630:	45 85 f6             	test   %r14d,%r14d
 18df633:	74 0a                	je     18df63f <run_backend_benchmark+0x256f>
 18df635:	41 83 fe 04          	cmp    $0x4,%r14d
 18df639:	0f 94 c1             	sete   %cl
 18df63c:	40 20 ce             	and    %cl,%sil
 18df63f:	0f b6 57 0f          	movzbl 0xf(%rdi),%edx
 18df643:	41 b0 01             	mov    $0x1,%r8b
 18df646:	b1 01                	mov    $0x1,%cl
 18df648:	88 94 24 b0 00 00 00 	mov    %dl,0xb0(%rsp)
 18df64f:	84 d2                	test   %dl,%dl
 18df651:	74 07                	je     18df65a <run_backend_benchmark+0x258a>
 18df653:	83 7f 14 00          	cmpl   $0x0,0x14(%rdi)
 18df657:	0f 94 c1             	sete   %cl
 18df65a:	44 0f b6 7f 04       	movzbl 0x4(%rdi),%r15d
 18df65f:	49 81 ff ff 00 00 00 	cmp    $0xff,%r15
 18df666:	74 09                	je     18df671 <run_backend_benchmark+0x25a1>
 18df668:	66 83 7f 06 40       	cmpw   $0x40,0x6(%rdi)
 18df66d:	41 0f 92 c0          	setb   %r8b
 18df671:	48 8b 57 20          	mov    0x20(%rdi),%rdx
 18df675:	44 88 44 24 30       	mov    %r8b,0x30(%rsp)
 18df67a:	4c 8d 05 bf aa 7c 0d 	lea    0xd7caabf(%rip),%r8        # f0aa140 <tier0_masks>
 18df681:	4c 89 4c 24 40       	mov    %r9,0x40(%rsp)
 18df686:	4b 89 14 01          	mov    %rdx,(%r9,%r8,1)
 18df68a:	44 0f b6 47 0c       	movzbl 0xc(%rdi),%r8d
 18df68f:	44 0f b6 4f 0b       	movzbl 0xb(%rdi),%r9d
 18df694:	ba 00 80 07 00       	mov    $0x78000,%edx
 18df699:	45 89 c4             	mov    %r8d,%r12d
 18df69c:	41 c1 e4 0f          	shl    $0xf,%r12d
 18df6a0:	41 81 f8 ff 00 00 00 	cmp    $0xff,%r8d
 18df6a7:	4c 0f 44 e2          	cmove  %rdx,%r12
 18df6ab:	49 81 f9 ff 00 00 00 	cmp    $0xff,%r9
 18df6b2:	75 13                	jne    18df6c7 <run_backend_benchmark+0x25f7>
 18df6b4:	80 7f 10 00          	cmpb   $0x0,0x10(%rdi)
 18df6b8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
 18df6be:	ba 07 00 00 00       	mov    $0x7,%edx
 18df6c3:	4c 0f 44 ca          	cmove  %rdx,%r9
 18df6c7:	0f b6 5f 01          	movzbl 0x1(%rdi),%ebx
 18df6cb:	40 20 ce             	and    %cl,%sil
 18df6ce:	31 c9                	xor    %ecx,%ecx
 18df6d0:	45 85 f6             	test   %r14d,%r14d
 18df6d3:	44 0f b6 47 0d       	movzbl 0xd(%rdi),%r8d
 18df6d8:	44 0f b6 77 0e       	movzbl 0xe(%rdi),%r14d
 18df6dd:	8b 17                	mov    (%rdi),%edx
 18df6df:	44 0f b6 57 03       	movzbl 0x3(%rdi),%r10d
 18df6e4:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 18df6ea:	0f 95 c1             	setne  %cl
 18df6ed:	40 88 74 24 60       	mov    %sil,0x60(%rsp)
 18df6f2:	c1 e1 17             	shl    $0x17,%ecx
 18df6f5:	48 89 de             	mov    %rbx,%rsi
 18df6f8:	48 c1 e6 1e          	shl    $0x1e,%rsi
 18df6fc:	41 c1 e0 13          	shl    $0x13,%r8d
 18df700:	41 c1 e6 15          	shl    $0x15,%r14d
 18df704:	c1 e2 18             	shl    $0x18,%edx
 18df707:	48 81 ce 00 00 00 08 	or     $0x8000000,%rsi
 18df70e:	48 81 fb ff 00 00 00 	cmp    $0xff,%rbx
 18df715:	4c 89 d3             	mov    %r10,%rbx
 18df718:	49 0f 44 f5          	cmove  %r13,%rsi
 18df71c:	48 c1 e3 20          	shl    $0x20,%rbx
 18df720:	48 81 cb 00 00 00 10 	or     $0x10000000,%rbx
 18df727:	49 81 fa ff 00 00 00 	cmp    $0xff,%r10
 18df72e:	49 0f 44 dd          	cmove  %r13,%rbx
 18df732:	4d 09 c6             	or     %r8,%r14
 18df735:	4c 09 e1             	or     %r12,%rcx
 18df738:	44 0f b6 67 08       	movzbl 0x8(%rdi),%r12d
 18df73d:	44 0f b6 47 09       	movzbl 0x9(%rdi),%r8d
 18df742:	49 09 d6             	or     %rdx,%r14
 18df745:	49 09 f6             	or     %rsi,%r14
 18df748:	49 09 de             	or     %rbx,%r14
 18df74b:	49 09 ce             	or     %rcx,%r14
 18df74e:	0f b6 4f 0a          	movzbl 0xa(%rdi),%ecx
 18df752:	4d 09 de             	or     %r11,%r14
 18df755:	41 81 ff ff 00 00 00 	cmp    $0xff,%r15d
 18df75c:	0f 84 ee fd ff ff    	je     18df550 <run_backend_benchmark+0x2480>
 18df762:	0f b7 57 06          	movzwl 0x6(%rdi),%edx
 18df766:	49 c1 e7 22          	shl    $0x22,%r15
 18df76a:	48 c1 e2 3a          	shl    $0x3a,%rdx
 18df76e:	4c 09 fa             	or     %r15,%rdx
 18df771:	4c 09 f2             	or     %r14,%rdx
 18df774:	48 81 ca 00 00 00 20 	or     $0x20000000,%rdx
 18df77b:	49 89 d6             	mov    %rdx,%r14
 18df77e:	e9 cd fd ff ff       	jmp    18df550 <run_backend_benchmark+0x2480>
 18df783:	48 be 00 60 00 ff ff ff ff fe 	movabs $0xfeffffffff006000,%rsi
 18df78d:	48 bf 00 10 00 00 00 00 00 01 	movabs $0x100000000001000,%rdi
 18df797:	4c 8d 35 ba 29 7d 0d 	lea    0xd7d29ba(%rip),%r14        # f0b2158 <tier0_slot_words+0x18>
 18df79e:	49 b9 00 a0 07 00 00 f0 ff 00 	movabs $0xfff0000007a000,%r9
 18df7a8:	4c 8d 1d 91 e9 7c 0d 	lea    0xd7ce991(%rip),%r11        # f0ae140 <tier0_template_words>
 18df7af:	31 db                	xor    %ebx,%ebx
 18df7b1:	eb 2e                	jmp    18df7e1 <run_backend_benchmark+0x2711>
 18df7b3:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18df7c0:	48 8b 9c 24 b0 00 00 00 	mov    0xb0(%rsp),%rbx
 18df7c8:	4c 8b 74 24 40       	mov    0x40(%rsp),%r14
 18df7cd:	48 ff c3             	inc    %rbx
 18df7d0:	49 81 c6 00 10 00 00 	add    $0x1000,%r14
 18df7d7:	48 83 fb 40          	cmp    $0x40,%rbx
 18df7db:	0f 84 4f 02 00 00    	je     18dfa30 <run_backend_benchmark+0x2960>
 18df7e1:	48 89 9c 24 b0 00 00 00 	mov    %rbx,0xb0(%rsp)
 18df7e9:	48 c1 e3 05          	shl    $0x5,%rbx
 18df7ed:	48 8d 0d 1c da 70 0d 	lea    0xd70da1c(%rip),%rcx        # efed210 <tier0_slot_bases>
 18df7f4:	4c 89 74 24 40       	mov    %r14,0x40(%rsp)
 18df7f9:	45 31 ff             	xor    %r15d,%r15d
 18df7fc:	48 01 cb             	add    %rcx,%rbx
 18df7ff:	eb 1f                	jmp    18df820 <run_backend_benchmark+0x2750>
 18df801:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18df810:	49 ff c7             	inc    %r15
 18df813:	49 81 c6 00 01 00 00 	add    $0x100,%r14
 18df81a:	49 83 ff 10          	cmp    $0x10,%r15
 18df81e:	74 a0                	je     18df7c0 <run_backend_benchmark+0x26f0>
 18df820:	42 0f b7 0c 7b       	movzwl (%rbx,%r15,2),%ecx
 18df825:	45 31 ed             	xor    %r13d,%r13d
 18df828:	4c 8d 64 48 06       	lea    0x6(%rax,%rcx,2),%r12
 18df82d:	eb 14                	jmp    18df843 <run_backend_benchmark+0x2773>
 18df82f:	90                   	nop
 18df830:	b9 00 40 00 00       	mov    $0x4000,%ecx
 18df835:	4b 89 0c ee          	mov    %rcx,(%r14,%r13,8)
 18df839:	49 83 c5 04          	add    $0x4,%r13
 18df83d:	49 83 fd 20          	cmp    $0x20,%r13
 18df841:	74 cd                	je     18df810 <run_backend_benchmark+0x2740>
 18df843:	43 0f b7 54 6c fa    	movzwl -0x6(%r12,%r13,2),%edx
 18df849:	4c 89 c9             	mov    %r9,%rcx
 18df84c:	81 fa fe ff 00 00    	cmp    $0xfffe,%edx
 18df852:	74 6c                	je     18df8c0 <run_backend_benchmark+0x27f0>
 18df854:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
 18df85a:	75 14                	jne    18df870 <run_backend_benchmark+0x27a0>
 18df85c:	b9 00 40 00 00       	mov    $0x4000,%ecx
 18df861:	eb 5d                	jmp    18df8c0 <run_backend_benchmark+0x27f0>
 18df863:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18df870:	41 89 d0             	mov    %edx,%r8d
 18df873:	81 e2 ff 7f 00 00    	and    $0x7fff,%edx
 18df879:	89 d1                	mov    %edx,%ecx
 18df87b:	49 8b 0c cb          	mov    (%r11,%rcx,8),%rcx
 18df87f:	66 45 85 c0          	test   %r8w,%r8w
 18df883:	79 3b                	jns    18df8c0 <run_backend_benchmark+0x27f0>
 18df885:	4d 8b 44 d3 08       	mov    0x8(%r11,%rdx,8),%r8
 18df88a:	4d 8b 54 d3 10       	mov    0x10(%r11,%rdx,8),%r10
 18df88f:	49 8b 54 d3 18       	mov    0x18(%r11,%rdx,8),%rdx
 18df894:	49 31 c8             	xor    %rcx,%r8
 18df897:	49 31 ca             	xor    %rcx,%r10
 18df89a:	48 31 ca             	xor    %rcx,%rdx
 18df89d:	4d 09 c2             	or     %r8,%r10
 18df8a0:	4c 09 d2             	or     %r10,%rdx
 18df8a3:	48 85 f2             	test   %rsi,%rdx
 18df8a6:	ba 00 10 00 00       	mov    $0x1000,%edx
 18df8ab:	48 0f 44 d7          	cmove  %rdi,%rdx
 18df8af:	48 09 d1             	or     %rdx,%rcx
 18df8b2:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18df8c0:	43 0f b7 54 6c fc    	movzwl -0x4(%r12,%r13,2),%edx
 18df8c6:	4b 89 4c ee e8       	mov    %rcx,-0x18(%r14,%r13,8)
 18df8cb:	4c 89 c9             	mov    %r9,%rcx
 18df8ce:	81 fa fe ff 00 00    	cmp    $0xfffe,%edx
 18df8d4:	74 6a                	je     18df940 <run_backend_benchmark+0x2870>
 18df8d6:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
 18df8dc:	75 12                	jne    18df8f0 <run_backend_benchmark+0x2820>
 18df8de:	b9 00 40 00 00       	mov    $0x4000,%ecx
 18df8e3:	eb 5b                	jmp    18df940 <run_backend_benchmark+0x2870>
 18df8e5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18df8f0:	41 89 d0             	mov    %edx,%r8d
 18df8f3:	81 e2 ff 7f 00 00    	and    $0x7fff,%edx
 18df8f9:	89 d1                	mov    %edx,%ecx
 18df8fb:	49 8b 0c cb          	mov    (%r11,%rcx,8),%rcx
 18df8ff:	66 45 85 c0          	test   %r8w,%r8w
 18df903:	79 3b                	jns    18df940 <run_backend_benchmark+0x2870>
 18df905:	4d 8b 44 d3 08       	mov    0x8(%r11,%rdx,8),%r8
 18df90a:	4d 8b 54 d3 10       	mov    0x10(%r11,%rdx,8),%r10
 18df90f:	49 8b 54 d3 18       	mov    0x18(%r11,%rdx,8),%rdx
 18df914:	49 31 c8             	xor    %rcx,%r8
 18df917:	49 31 ca             	xor    %rcx,%r10
 18df91a:	48 31 ca             	xor    %rcx,%rdx
 18df91d:	4d 09 c2             	or     %r8,%r10
 18df920:	4c 09 d2             	or     %r10,%rdx
 18df923:	48 85 f2             	test   %rsi,%rdx
 18df926:	ba 00 10 00 00       	mov    $0x1000,%edx
 18df92b:	48 0f 44 d7          	cmove  %rdi,%rdx
 18df92f:	48 09 d1             	or     %rdx,%rcx
 18df932:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18df940:	43 0f b7 54 6c fe    	movzwl -0x2(%r12,%r13,2),%edx
 18df946:	4b 89 4c ee f0       	mov    %rcx,-0x10(%r14,%r13,8)
 18df94b:	4c 89 c9             	mov    %r9,%rcx
 18df94e:	81 fa fe ff 00 00    	cmp    $0xfffe,%edx
 18df954:	74 6a                	je     18df9c0 <run_backend_benchmark+0x28f0>
 18df956:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
 18df95c:	75 12                	jne    18df970 <run_backend_benchmark+0x28a0>
 18df95e:	b9 00 40 00 00       	mov    $0x4000,%ecx
 18df963:	eb 5b                	jmp    18df9c0 <run_backend_benchmark+0x28f0>
 18df965:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18df970:	41 89 d0             	mov    %edx,%r8d
 18df973:	81 e2 ff 7f 00 00    	and    $0x7fff,%edx
 18df979:	89 d1                	mov    %edx,%ecx
 18df97b:	49 8b 0c cb          	mov    (%r11,%rcx,8),%rcx
 18df97f:	66 45 85 c0          	test   %r8w,%r8w
 18df983:	79 3b                	jns    18df9c0 <run_backend_benchmark+0x28f0>
 18df985:	4d 8b 44 d3 08       	mov    0x8(%r11,%rdx,8),%r8
 18df98a:	4d 8b 54 d3 10       	mov    0x10(%r11,%rdx,8),%r10
 18df98f:	49 8b 54 d3 18       	mov    0x18(%r11,%rdx,8),%rdx
 18df994:	49 31 c8             	xor    %rcx,%r8
 18df997:	49 31 ca             	xor    %rcx,%r10
 18df99a:	48 31 ca             	xor    %rcx,%rdx
 18df99d:	4d 09 c2             	or     %r8,%r10
 18df9a0:	4c 09 d2             	or     %r10,%rdx
 18df9a3:	48 85 f2             	test   %rsi,%rdx
 18df9a6:	ba 00 10 00 00       	mov    $0x1000,%edx
 18df9ab:	48 0f 44 d7          	cmove  %rdi,%rdx
 18df9af:	48 09 d1             	or     %rdx,%rcx
 18df9b2:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18df9c0:	43 0f b7 14 6c       	movzwl (%r12,%r13,2),%edx
 18df9c5:	4b 89 4c ee f8       	mov    %rcx,-0x8(%r14,%r13,8)
 18df9ca:	4c 89 c9             	mov    %r9,%rcx
 18df9cd:	81 fa fe ff 00 00    	cmp    $0xfffe,%edx
 18df9d3:	0f 84 5c fe ff ff    	je     18df835 <run_backend_benchmark+0x2765>
 18df9d9:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
 18df9df:	0f 84 4b fe ff ff    	je     18df830 <run_backend_benchmark+0x2760>
 18df9e5:	41 89 d0             	mov    %edx,%r8d
 18df9e8:	81 e2 ff 7f 00 00    	and    $0x7fff,%edx
 18df9ee:	89 d1                	mov    %edx,%ecx
 18df9f0:	49 8b 0c cb          	mov    (%r11,%rcx,8),%rcx
 18df9f4:	66 45 85 c0          	test   %r8w,%r8w
 18df9f8:	0f 89 37 fe ff ff    	jns    18df835 <run_backend_benchmark+0x2765>
 18df9fe:	4d 8b 44 d3 08       	mov    0x8(%r11,%rdx,8),%r8
 18dfa03:	4d 8b 54 d3 10       	mov    0x10(%r11,%rdx,8),%r10
 18dfa08:	49 8b 54 d3 18       	mov    0x18(%r11,%rdx,8),%rdx
 18dfa0d:	49 31 c8             	xor    %rcx,%r8
 18dfa10:	49 31 ca             	xor    %rcx,%r10
 18dfa13:	48 31 ca             	xor    %rcx,%rdx
 18dfa16:	4d 09 c2             	or     %r8,%r10
 18dfa19:	4c 09 d2             	or     %r10,%rdx
 18dfa1c:	48 85 f2             	test   %rsi,%rdx
 18dfa1f:	ba 00 10 00 00       	mov    $0x1000,%edx
 18dfa24:	48 0f 44 d7          	cmove  %rdi,%rdx
 18dfa28:	48 09 d1             	or     %rdx,%rcx
 18dfa2b:	e9 05 fe ff ff       	jmp    18df835 <run_backend_benchmark+0x2765>
 18dfa30:	f6 44 24 60 01       	testb  $0x1,0x60(%rsp)
 18dfa35:	0f 84 74 6a 00 00    	je     18e64af <run_backend_benchmark+0x93df>
 18dfa3b:	c5 f9 6f 05 1d c6 cc fe 	vmovdqa -0x13339e3(%rip),%xmm0        # 5ac060 <x86_effects_unknown+0x90>
 18dfa43:	62 f2 7d 48 5a 0d 73 c6 cc fe 	vbroadcasti32x4 -0x133398d(%rip),%zmm1        # 5ac0c0 <x86_effects_unknown+0xf0>
 18dfa4d:	62 f2 7d 48 5a 15 79 c6 cc fe 	vbroadcasti32x4 -0x1333987(%rip),%zmm2        # 5ac0d0 <x86_effects_unknown+0x100>
 18dfa57:	62 f2 7d 48 5a 1d 7f c6 cc fe 	vbroadcasti32x4 -0x1333981(%rip),%zmm3        # 5ac0e0 <x86_effects_unknown+0x110>
 18dfa61:	62 f2 7d 48 5a 25 85 c6 cc fe 	vbroadcasti32x4 -0x133397b(%rip),%zmm4        # 5ac0f0 <x86_effects_unknown+0x120>
 18dfa6b:	62 f2 7d 48 5a 2d 8b c6 cc fe 	vbroadcasti32x4 -0x1333975(%rip),%zmm5        # 5ac100 <x86_effects_unknown+0x130>
 18dfa75:	62 f2 7d 48 5a 35 91 c6 cc fe 	vbroadcasti32x4 -0x133396f(%rip),%zmm6        # 5ac110 <x86_effects_unknown+0x140>
 18dfa7f:	62 f2 7d 48 5a 3d 97 c6 cc fe 	vbroadcasti32x4 -0x1333969(%rip),%zmm7        # 5ac120 <x86_effects_unknown+0x150>
 18dfa89:	48 b8 00 00 01 00 00 00 00 01 	movabs $0x100000000010000,%rax
 18dfa93:	c4 e1 fc 46 c8       	kxnorq %k0,%k0,%k1
 18dfa98:	c4 e1 fc 46 e0       	kxnorq %k0,%k0,%k4
 18dfa9d:	c4 e1 fc 46 e8       	kxnorq %k0,%k0,%k5
 18dfaa2:	48 8d 0d f7 d4 98 00 	lea    0x98d4f7(%rip),%rcx        # 226cfa0 <x86_form_descriptions>
 18dfaa9:	31 d2                	xor    %edx,%edx
 18dfaab:	c4 e1 fb 92 d0       	kmovq  %rax,%k2
 18dfab0:	48 b8 01 00 00 00 00 01 00 00 	movabs $0x10000000001,%rax
 18dfaba:	c4 e1 f8 91 94 24 80 00 00 00 	kmovq  %k2,0x80(%rsp)
 18dfac4:	c4 e1 fb 92 d8       	kmovq  %rax,%k3
 18dfac9:	c4 e1 fc 46 d0       	kxnorq %k0,%k0,%k2
 18dface:	66 90                	xchg   %ax,%ax
 18dfad0:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
 18dfad5:	c4 e1 f8 91 8c 24 b0 00 00 00 	kmovq  %k1,0xb0(%rsp)
 18dfadf:	c4 e1 f8 90 8c 24 80 00 00 00 	kmovq  0x80(%rsp),%k1
 18dfae9:	c4 e1 f8 91 6c 24 30 	kmovq  %k5,0x30(%rsp)
 18dfaf0:	c4 e1 f8 91 64 24 60 	kmovq  %k4,0x60(%rsp)
 18dfaf7:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 18dfafc:	48 8d 14 80          	lea    (%rax,%rax,4),%rdx
 18dfb00:	62 71 7f c9 6f 8c d1 5b 00 00 00 	vmovdqu8 0x5b(%rcx,%rdx,8),%zmm9{%k1}{z}
 18dfb0b:	62 71 7f cb 6f 84 d1 1b 00 00 00 	vmovdqu8 0x1b(%rcx,%rdx,8),%zmm8{%k3}{z}
 18dfb16:	62 71 7f c9 6f 94 d1 db 02 00 00 	vmovdqu8 0x2db(%rcx,%rdx,8),%zmm10{%k1}{z}
 18dfb21:	62 e1 7f c9 6f ac d1 7b 03 00 00 	vmovdqu8 0x37b(%rcx,%rdx,8),%zmm21{%k1}{z}
 18dfb2c:	62 e1 7f c9 6f b4 d1 db 07 00 00 	vmovdqu8 0x7db(%rcx,%rdx,8),%zmm22{%k1}{z}
 18dfb37:	62 e1 7f cb 6f 9c d1 9b 07 00 00 	vmovdqu8 0x79b(%rcx,%rdx,8),%zmm19{%k3}{z}
 18dfb42:	62 e1 7f cb 6f a4 d1 3b 03 00 00 	vmovdqu8 0x33b(%rcx,%rdx,8),%zmm20{%k3}{z}
 18dfb4d:	62 61 7f c9 6f 8c d1 1b 04 00 00 	vmovdqu8 0x41b(%rcx,%rdx,8),%zmm25{%k1}{z}
 18dfb58:	62 61 7f cb 6f 84 d1 db 03 00 00 	vmovdqu8 0x3db(%rcx,%rdx,8),%zmm24{%k3}{z}
 18dfb63:	62 e1 7f c9 6f 94 d1 bb 04 00 00 	vmovdqu8 0x4bb(%rcx,%rdx,8),%zmm18{%k1}{z}
 18dfb6e:	62 e1 7f cb 6f bc d1 3b 08 00 00 	vmovdqu8 0x83b(%rcx,%rdx,8),%zmm23{%k3}{z}
 18dfb79:	62 71 7f c9 6f 9c d1 5b 05 00 00 	vmovdqu8 0x55b(%rcx,%rdx,8),%zmm11{%k1}{z}
 18dfb84:	62 71 7f cb 6f bc d1 1b 05 00 00 	vmovdqu8 0x51b(%rcx,%rdx,8),%zmm15{%k3}{z}
 18dfb8f:	62 e1 7f cb 6f 84 d1 bb 05 00 00 	vmovdqu8 0x5bb(%rcx,%rdx,8),%zmm16{%k3}{z}
 18dfb9a:	62 e1 7f c9 6f 8c d1 fb 05 00 00 	vmovdqu8 0x5fb(%rcx,%rdx,8),%zmm17{%k1}{z}
 18dfba5:	62 71 7f cb 6f b4 d1 5b 06 00 00 	vmovdqu8 0x65b(%rcx,%rdx,8),%zmm14{%k3}{z}
 18dfbb0:	62 71 7f c9 6f ac d1 9b 06 00 00 	vmovdqu8 0x69b(%rcx,%rdx,8),%zmm13{%k1}{z}
 18dfbbb:	62 71 7f cb 6f a4 d1 fb 06 00 00 	vmovdqu8 0x6fb(%rcx,%rdx,8),%zmm12{%k3}{z}
 18dfbc6:	62 52 7d 48 7d c1    	vpermt2b %zmm9,%zmm0,%zmm8
 18dfbcc:	62 71 7f cb 6f 8c d1 9b 02 00 00 	vmovdqu8 0x29b(%rcx,%rdx,8),%zmm9{%k3}{z}
 18dfbd7:	62 a2 7d 48 7d de    	vpermt2b %zmm22,%zmm0,%zmm19
 18dfbdd:	62 a3 7d 48 39 ee 03 	vextracti32x4 $0x3,%zmm21,%xmm22
 18dfbe4:	62 a3 7d 28 39 ed 01 	vextracti32x4 $0x1,%ymm21,%xmm21
 18dfbeb:	62 c1 7d 08 7e e2    	vmovd  %xmm20,%r10d
 18dfbf1:	62 41 7d 08 7e c7    	vmovd  %xmm24,%r15d
 18dfbf7:	62 c1 7d 08 7e fd    	vmovd  %xmm23,%r13d
 18dfbfd:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18dfc04:	62 52 7d 48 7d fb    	vpermt2b %zmm11,%zmm0,%zmm15
 18dfc0a:	62 71 7f c9 6f 9c d1 3b 07 00 00 	vmovdqu8 0x73b(%rcx,%rdx,8),%zmm11{%k1}{z}
 18dfc15:	c4 63 39 20 84 d1 bb 00 00 00 04 	vpinsrb $0x4,0xbb(%rcx,%rdx,8),%xmm8,%xmm8
 18dfc20:	62 e3 7d 08 14 f6 08 	vpextrb $0x8,%xmm22,%esi
 18dfc27:	62 e1 7f c9 6f b4 d1 7b 08 00 00 	vmovdqu8 0x87b(%rcx,%rdx,8),%zmm22{%k1}{z}
 18dfc32:	62 e1 7d 08 7e ef    	vmovd  %xmm21,%edi
 18dfc38:	62 a3 7d 48 39 e5 02 	vextracti32x4 $0x2,%zmm20,%xmm21
 18dfc3f:	62 23 7d 48 39 cc 03 	vextracti32x4 $0x3,%zmm25,%xmm20
 18dfc46:	62 c3 7d 08 14 e9 08 	vpextrb $0x8,%xmm21,%r9d
 18dfc4d:	62 23 7d 28 39 cd 01 	vextracti32x4 $0x1,%ymm25,%xmm21
 18dfc54:	62 c3 7d 08 14 e0 08 	vpextrb $0x8,%xmm20,%r8d
 18dfc5b:	62 e1 7f cb 6f a4 d1 db 08 00 00 	vmovdqu8 0x8db(%rcx,%rdx,8),%zmm20{%k3}{z}
 18dfc66:	62 61 7f c9 6f 8c d1 1b 0e 00 00 	vmovdqu8 0xe1b(%rcx,%rdx,8),%zmm25{%k1}{z}
 18dfc71:	62 c1 7d 08 7e eb    	vmovd  %xmm21,%r11d
 18dfc77:	62 23 7d 48 39 c5 02 	vextracti32x4 $0x2,%zmm24,%xmm21
 18dfc7e:	62 83 7d 48 39 d0 03 	vextracti32x4 $0x3,%zmm18,%xmm24
 18dfc85:	62 a3 7d 28 39 d2 01 	vextracti32x4 $0x1,%ymm18,%xmm18
 18dfc8c:	62 c3 7d 08 14 ee 08 	vpextrb $0x8,%xmm21,%r14d
 18dfc93:	62 e1 7f c9 6f ac d1 1b 09 00 00 	vmovdqu8 0x91b(%rcx,%rdx,8),%zmm21{%k1}{z}
 18dfc9e:	62 63 7d 08 14 c3 08 	vpextrb $0x8,%xmm24,%ebx
 18dfca5:	c4 63 39 20 84 d1 e3 00 00 00 05 	vpinsrb $0x5,0xe3(%rcx,%rdx,8),%xmm8,%xmm8
 18dfcb0:	62 c3 65 00 20 dd 04 	vpinsrb $0x4,%r13d,%xmm19,%xmm19
 18dfcb7:	62 c3 7d 08 14 fd 08 	vpextrb $0x8,%xmm23,%r13d
 18dfcbe:	62 e1 7f c9 6f bc d1 bb 09 00 00 	vmovdqu8 0x9bb(%rcx,%rdx,8),%zmm23{%k1}{z}
 18dfcc9:	62 c3 65 00 20 dd 05 	vpinsrb $0x5,%r13d,%xmm19,%xmm19
 18dfcd0:	62 52 7d 48 7d ca    	vpermt2b %zmm10,%zmm0,%zmm9
 18dfcd6:	62 71 7f cb 6f 94 d1 7b 04 00 00 	vmovdqu8 0x47b(%rcx,%rdx,8),%zmm10{%k3}{z}
 18dfce1:	c4 63 39 20 84 d1 0b 01 00 00 06 	vpinsrb $0x6,0x10b(%rcx,%rdx,8),%xmm8,%xmm8
 18dfcec:	c4 63 39 20 84 d1 33 01 00 00 07 	vpinsrb $0x7,0x133(%rcx,%rdx,8),%xmm8,%xmm8
 18dfcf7:	c4 43 31 20 ca 04    	vpinsrb $0x4,%r10d,%xmm9,%xmm9
 18dfcfd:	c4 43 31 20 c9 05    	vpinsrb $0x5,%r9d,%xmm9,%xmm9
 18dfd03:	c4 63 31 20 cf 06    	vpinsrb $0x6,%edi,%xmm9,%xmm9
 18dfd09:	62 13 7d 48 39 d0 02 	vextracti32x4 $0x2,%zmm10,%xmm24
 18dfd10:	c4 63 31 20 ce 07    	vpinsrb $0x7,%esi,%xmm9,%xmm9
 18dfd16:	c4 63 39 20 84 d1 5b 01 00 00 08 	vpinsrb $0x8,0x15b(%rcx,%rdx,8),%xmm8,%xmm8
 18dfd21:	62 43 7d 08 14 c4 08 	vpextrb $0x8,%xmm24,%r12d
 18dfd28:	62 83 7d 48 39 f0 03 	vextracti32x4 $0x3,%zmm22,%xmm24
 18dfd2f:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 18dfd36:	c4 43 31 20 cf 08    	vpinsrb $0x8,%r15d,%xmm9,%xmm9
 18dfd3c:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18dfd43:	62 61 7f cb 6f 84 d1 7b 09 00 00 	vmovdqu8 0x97b(%rcx,%rdx,8),%zmm24{%k3}{z}
 18dfd4e:	62 c1 7d 08 7e f5    	vmovd  %xmm22,%r13d
 18dfd54:	62 a3 7d 48 39 e6 02 	vextracti32x4 $0x2,%zmm20,%xmm22
 18dfd5b:	c4 43 31 20 ce 09    	vpinsrb $0x9,%r14d,%xmm9,%xmm9
 18dfd61:	62 c3 65 00 20 dd 06 	vpinsrb $0x6,%r13d,%xmm19,%xmm19
 18dfd68:	62 c1 7d 08 7e d5    	vmovd  %xmm18,%r13d
 18dfd6e:	62 a3 7d 48 39 ea 03 	vextracti32x4 $0x3,%zmm21,%xmm18
 18dfd75:	c4 43 31 20 cb 0a    	vpinsrb $0xa,%r11d,%xmm9,%xmm9
 18dfd7b:	62 e3 65 00 20 d8 07 	vpinsrb $0x7,%eax,%xmm19,%xmm19
 18dfd82:	62 e1 7d 08 7e e0    	vmovd  %xmm20,%eax
 18dfd88:	62 a3 7d 28 39 ec 01 	vextracti32x4 $0x1,%ymm21,%xmm20
 18dfd8f:	c4 43 31 20 c8 0b    	vpinsrb $0xb,%r8d,%xmm9,%xmm9
 18dfd95:	c4 63 39 20 84 d1 83 01 00 00 09 	vpinsrb $0x9,0x183(%rcx,%rdx,8),%xmm8,%xmm8
 18dfda0:	62 e3 65 00 20 d8 08 	vpinsrb $0x8,%eax,%xmm19,%xmm19
 18dfda7:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18dfdae:	62 e1 7f c9 6f b4 d1 7b 0d 00 00 	vmovdqu8 0xd7b(%rcx,%rdx,8),%zmm22{%k1}{z}
 18dfdb9:	62 e3 65 00 20 d8 09 	vpinsrb $0x9,%eax,%xmm19,%xmm19
 18dfdc0:	62 e1 7d 08 7e e0    	vmovd  %xmm20,%eax
 18dfdc6:	62 a3 7d 48 39 fc 03 	vextracti32x4 $0x3,%zmm23,%xmm20
 18dfdcd:	62 e3 65 00 20 d8 0a 	vpinsrb $0xa,%eax,%xmm19,%xmm19
 18dfdd4:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 18dfddb:	62 a3 7d 48 39 ca 03 	vextracti32x4 $0x3,%zmm17,%xmm18
 18dfde2:	62 a3 7d 28 39 c9 01 	vextracti32x4 $0x1,%ymm17,%xmm17
 18dfde9:	62 e3 65 00 20 d8 0b 	vpinsrb $0xb,%eax,%xmm19,%xmm19
 18dfdf0:	c4 63 39 20 84 d1 ab 01 00 00 0a 	vpinsrb $0xa,0x1ab(%rcx,%rdx,8),%xmm8,%xmm8
 18dfdfb:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18dfe01:	62 23 7d 48 39 c5 02 	vextracti32x4 $0x2,%zmm24,%xmm21
 18dfe08:	62 61 7f cb 6f 84 d1 db 0d 00 00 	vmovdqu8 0xddb(%rcx,%rdx,8),%zmm24{%k3}{z}
 18dfe13:	62 e3 65 00 20 d8 0c 	vpinsrb $0xc,%eax,%xmm19,%xmm19
 18dfe1a:	62 e3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%eax
 18dfe21:	62 a3 7d 28 39 fd 01 	vextracti32x4 $0x1,%ymm23,%xmm21
 18dfe28:	62 e1 7f c9 6f bc d1 7b 12 00 00 	vmovdqu8 0x127b(%rcx,%rdx,8),%zmm23{%k1}{z}
 18dfe33:	62 e3 65 00 20 d8 0d 	vpinsrb $0xd,%eax,%xmm19,%xmm19
 18dfe3a:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18dfe40:	62 e1 7f cb 6f ac d1 3b 0d 00 00 	vmovdqu8 0xd3b(%rcx,%rdx,8),%zmm21{%k3}{z}
 18dfe4b:	c4 63 39 20 84 d1 d3 01 00 00 0b 	vpinsrb $0xb,0x1d3(%rcx,%rdx,8),%xmm8,%xmm8
 18dfe56:	62 e3 65 00 20 d8 0e 	vpinsrb $0xe,%eax,%xmm19,%xmm19
 18dfe5d:	62 e3 7d 08 14 e0 08 	vpextrb $0x8,%xmm20,%eax
 18dfe64:	62 e1 7f cb 6f a4 d1 9b 11 00 00 	vmovdqu8 0x119b(%rcx,%rdx,8),%zmm20{%k3}{z}
 18dfe6f:	62 e3 65 00 20 d8 0f 	vpinsrb $0xf,%eax,%xmm19,%xmm19
 18dfe76:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 18dfe7c:	62 a3 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm16,%xmm16
 18dfe83:	c4 63 01 20 f8 04    	vpinsrb $0x4,%eax,%xmm15,%xmm15
 18dfe89:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18dfe90:	62 33 7d 48 39 f0 02 	vextracti32x4 $0x2,%zmm14,%xmm16
 18dfe97:	c4 63 01 20 f8 05    	vpinsrb $0x5,%eax,%xmm15,%xmm15
 18dfe9d:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 18dfea3:	62 e1 7f cb 6f 8c d1 bb 0f 00 00 	vmovdqu8 0xfbb(%rcx,%rdx,8),%zmm17{%k3}{z}
 18dfeae:	c4 63 39 20 84 d1 fb 01 00 00 0c 	vpinsrb $0xc,0x1fb(%rcx,%rdx,8),%xmm8,%xmm8
 18dfeb9:	c4 63 01 20 f8 06    	vpinsrb $0x6,%eax,%xmm15,%xmm15
 18dfebf:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 18dfec6:	62 e1 7f c9 6f 94 d1 fb 0f 00 00 	vmovdqu8 0xffb(%rcx,%rdx,8),%zmm18{%k1}{z}
 18dfed1:	c4 63 01 20 f8 07    	vpinsrb $0x7,%eax,%xmm15,%xmm15
 18dfed7:	c5 79 7e f0          	vmovd  %xmm14,%eax
 18dfedb:	62 41 7d 08 7e c7    	vmovd  %xmm24,%r15d
 18dfee1:	c4 63 01 20 f0 08    	vpinsrb $0x8,%eax,%xmm15,%xmm14
 18dfee7:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18dfeee:	c4 43 7d 39 ef 01    	vextracti128 $0x1,%ymm13,%xmm15
 18dfef4:	62 53 7d 48 39 ed 03 	vextracti32x4 $0x3,%zmm13,%xmm13
 18dfefb:	62 e1 7f cb 6f 84 d1 1b 0f 00 00 	vmovdqu8 0xf1b(%rcx,%rdx,8),%zmm16{%k3}{z}
 18dff06:	c4 63 09 20 f0 09    	vpinsrb $0x9,%eax,%xmm14,%xmm14
 18dff0c:	c5 79 7e f8          	vmovd  %xmm15,%eax
 18dff10:	62 53 7d 48 39 e7 02 	vextracti32x4 $0x2,%zmm12,%xmm15
 18dff17:	62 c1 7d 08 7e ea    	vmovd  %xmm21,%r10d
 18dff1d:	c4 63 39 20 84 d1 23 02 00 00 0d 	vpinsrb $0xd,0x223(%rcx,%rdx,8),%xmm8,%xmm8
 18dff28:	c4 63 09 20 f0 0a    	vpinsrb $0xa,%eax,%xmm14,%xmm14
 18dff2e:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18dff34:	62 53 7d 48 39 dd 03 	vextracti32x4 $0x3,%zmm11,%xmm13
 18dff3b:	c4 43 7d 39 db 01    	vextracti128 $0x1,%ymm11,%xmm11
 18dff41:	c4 63 09 20 f0 0b    	vpinsrb $0xb,%eax,%xmm14,%xmm14
 18dff47:	c5 79 7e e0          	vmovd  %xmm12,%eax
 18dff4b:	c4 63 09 20 e0 0c    	vpinsrb $0xc,%eax,%xmm14,%xmm12
 18dff51:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 18dff57:	62 71 7f c9 6f bc d1 db 11 00 00 	vmovdqu8 0x11db(%rcx,%rdx,8),%zmm15{%k1}{z}
 18dff62:	62 71 7f cb 6f b4 d1 5b 10 00 00 	vmovdqu8 0x105b(%rcx,%rdx,8),%zmm14{%k3}{z}
 18dff6d:	c4 63 19 20 e0 0d    	vpinsrb $0xd,%eax,%xmm12,%xmm12
 18dff73:	c5 79 7e d8          	vmovd  %xmm11,%eax
 18dff77:	c4 63 39 20 84 d1 4b 02 00 00 0e 	vpinsrb $0xe,0x24b(%rcx,%rdx,8),%xmm8,%xmm8
 18dff82:	c4 63 19 20 d8 0e    	vpinsrb $0xe,%eax,%xmm12,%xmm11
 18dff88:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18dff8e:	62 71 7f c9 6f a4 d1 5b 0f 00 00 	vmovdqu8 0xf5b(%rcx,%rdx,8),%zmm12{%k1}{z}
 18dff99:	62 71 7f c9 6f ac d1 9b 10 00 00 	vmovdqu8 0x109b(%rcx,%rdx,8),%zmm13{%k1}{z}
 18dffa4:	c4 63 21 20 d8 0f    	vpinsrb $0xf,%eax,%xmm11,%xmm11
 18dffaa:	c5 79 7e d0          	vmovd  %xmm10,%eax
 18dffae:	c4 63 31 20 c8 0c    	vpinsrb $0xc,%eax,%xmm9,%xmm9
 18dffb4:	62 33 25 28 38 d3 01 	vinserti32x4 $0x1,%xmm19,%ymm11,%ymm10
 18dffbb:	62 71 7f c9 6f 9c d1 db 0c 00 00 	vmovdqu8 0xcdb(%rcx,%rdx,8),%zmm11{%k1}{z}
 18dffc6:	62 e1 7f c9 6f 9c d1 bb 0e 00 00 	vmovdqu8 0xebb(%rcx,%rdx,8),%zmm19{%k1}{z}
 18dffd1:	c4 43 31 20 cc 0d    	vpinsrb $0xd,%r12d,%xmm9,%xmm9
 18dffd7:	c4 63 39 20 84 d1 73 02 00 00 0f 	vpinsrb $0xf,0x273(%rcx,%rdx,8),%xmm8,%xmm8
 18dffe2:	c4 43 31 20 cd 0e    	vpinsrb $0xe,%r13d,%xmm9,%xmm9
 18dffe8:	c4 63 31 20 cb 0f    	vpinsrb $0xf,%ebx,%xmm9,%xmm9
 18dffee:	62 c2 7d 48 7d e7    	vpermt2b %zmm15,%zmm0,%zmm20
 18dfff4:	62 c3 7d 48 39 f7 03 	vextracti32x4 $0x3,%zmm22,%xmm15
 18dfffb:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 18e0002:	62 e1 7d 08 7e f7    	vmovd  %xmm22,%edi
 18e0008:	62 a3 7d 48 39 ee 02 	vextracti32x4 $0x2,%zmm21,%xmm22
 18e000f:	62 23 7d 48 39 cd 03 	vextracti32x4 $0x3,%zmm25,%xmm21
 18e0016:	c4 63 79 14 fe 08    	vpextrb $0x8,%xmm15,%esi
 18e001c:	62 71 7f c9 6f bc d1 3b 11 00 00 	vmovdqu8 0x113b(%rcx,%rdx,8),%zmm15{%k1}{z}
 18e0027:	62 c3 7d 08 14 f1 08 	vpextrb $0x8,%xmm22,%r9d
 18e002e:	62 e1 7f cb 6f b4 d1 3b 12 00 00 	vmovdqu8 0x123b(%rcx,%rdx,8),%zmm22{%k3}{z}
 18e0039:	62 c3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%r8d
 18e0040:	62 23 7d 28 39 cd 01 	vextracti32x4 $0x1,%ymm25,%xmm21
 18e0047:	62 c2 7d 48 7d c4    	vpermt2b %zmm12,%zmm0,%zmm16
 18e004d:	62 71 7f cb 6f a4 d1 fb 10 00 00 	vmovdqu8 0x10fb(%rcx,%rdx,8),%zmm12{%k3}{z}
 18e0058:	62 61 7f cb 6f 8c d1 3b 1c 00 00 	vmovdqu8 0x1c3b(%rcx,%rdx,8),%zmm25{%k3}{z}
 18e0063:	62 c1 7d 08 7e eb    	vmovd  %xmm21,%r11d
 18e0069:	62 23 7d 48 39 c5 02 	vextracti32x4 $0x2,%zmm24,%xmm21
 18e0070:	62 83 7d 48 39 d8 03 	vextracti32x4 $0x3,%zmm19,%xmm24
 18e0077:	62 c3 7d 08 14 ee 08 	vpextrb $0x8,%xmm21,%r14d
 18e007e:	62 e1 7f cb 6f ac d1 db 12 00 00 	vmovdqu8 0x12db(%rcx,%rdx,8),%zmm21{%k3}{z}
 18e0089:	62 a3 7d 28 39 db 01 	vextracti32x4 $0x1,%ymm19,%xmm19
 18e0090:	62 63 7d 08 14 c3 08 	vpextrb $0x8,%xmm24,%ebx
 18e0097:	c4 43 3d 38 c1 01    	vinserti128 $0x1,%xmm9,%ymm8,%ymm8
 18e009d:	62 71 7f cb 6f 8c d1 1b 0a 00 00 	vmovdqu8 0xa1b(%rcx,%rdx,8),%zmm9{%k3}{z}
 18e00a8:	62 53 bd 48 3a c2 01 	vinserti64x4 $0x1,%ymm10,%zmm8,%zmm8
 18e00af:	62 71 7f c9 6f 94 d1 5b 0a 00 00 	vmovdqu8 0xa5b(%rcx,%rdx,8),%zmm10{%k1}{z}
 18e00ba:	62 f1 3d 48 74 c3    	vpcmpeqb %zmm3,%zmm8,%k0
 18e00c0:	62 f1 3d 48 74 fc    	vpcmpeqb %zmm4,%zmm8,%k7
 18e00c6:	c4 e1 fc 45 f7       	korq   %k7,%k0,%k6
 18e00cb:	62 c1 7d 08 7e f5    	vmovd  %xmm22,%r13d
 18e00d1:	62 a3 7d 48 39 f6 02 	vextracti32x4 $0x2,%zmm22,%xmm22
 18e00d8:	62 c3 5d 00 20 e5 04 	vpinsrb $0x4,%r13d,%xmm20,%xmm20
 18e00df:	62 c3 7d 08 14 f5 08 	vpextrb $0x8,%xmm22,%r13d
 18e00e6:	62 e1 7f cb 6f b4 d1 7b 13 00 00 	vmovdqu8 0x137b(%rcx,%rdx,8),%zmm22{%k3}{z}
 18e00f1:	62 c3 5d 00 20 e5 05 	vpinsrb $0x5,%r13d,%xmm20,%xmm20
 18e00f8:	62 52 7d 48 7d ca    	vpermt2b %zmm10,%zmm0,%zmm9
 18e00fe:	62 71 7f cb 6f 94 d1 9b 0c 00 00 	vmovdqu8 0xc9b(%rcx,%rdx,8),%zmm10{%k3}{z}
 18e0109:	c4 63 31 20 8c d1 bb 0a 00 00 04 	vpinsrb $0x4,0xabb(%rcx,%rdx,8),%xmm9,%xmm9
 18e0114:	c4 63 31 20 8c d1 e3 0a 00 00 05 	vpinsrb $0x5,0xae3(%rcx,%rdx,8),%xmm9,%xmm9
 18e011f:	62 52 7d 48 7d d3    	vpermt2b %zmm11,%zmm0,%zmm10
 18e0125:	62 71 7f cb 6f 9c d1 7b 0e 00 00 	vmovdqu8 0xe7b(%rcx,%rdx,8),%zmm11{%k3}{z}
 18e0130:	c4 63 31 20 8c d1 0b 0b 00 00 06 	vpinsrb $0x6,0xb0b(%rcx,%rdx,8),%xmm9,%xmm9
 18e013b:	c4 63 31 20 8c d1 33 0b 00 00 07 	vpinsrb $0x7,0xb33(%rcx,%rdx,8),%xmm9,%xmm9
 18e0146:	c4 43 29 20 d2 04    	vpinsrb $0x4,%r10d,%xmm10,%xmm10
 18e014c:	c4 43 29 20 d1 05    	vpinsrb $0x5,%r9d,%xmm10,%xmm10
 18e0152:	c4 63 29 20 d7 06    	vpinsrb $0x6,%edi,%xmm10,%xmm10
 18e0158:	62 13 7d 48 39 d8 02 	vextracti32x4 $0x2,%zmm11,%xmm24
 18e015f:	c4 63 29 20 d6 07    	vpinsrb $0x7,%esi,%xmm10,%xmm10
 18e0165:	c4 63 31 20 8c d1 5b 0b 00 00 08 	vpinsrb $0x8,0xb5b(%rcx,%rdx,8),%xmm9,%xmm9
 18e0170:	62 43 7d 08 14 c4 08 	vpextrb $0x8,%xmm24,%r12d
 18e0177:	62 83 7d 48 39 f8 03 	vextracti32x4 $0x3,%zmm23,%xmm24
 18e017e:	62 a3 7d 28 39 ff 01 	vextracti32x4 $0x1,%ymm23,%xmm23
 18e0185:	c4 43 29 20 d7 08    	vpinsrb $0x8,%r15d,%xmm10,%xmm10
 18e018b:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e0192:	62 61 7f c9 6f 84 d1 1b 13 00 00 	vmovdqu8 0x131b(%rcx,%rdx,8),%zmm24{%k1}{z}
 18e019d:	62 c1 7d 08 7e fd    	vmovd  %xmm23,%r13d
 18e01a3:	62 e1 7f c9 6f bc d1 bb 13 00 00 	vmovdqu8 0x13bb(%rcx,%rdx,8),%zmm23{%k1}{z}
 18e01ae:	c4 43 29 20 d6 09    	vpinsrb $0x9,%r14d,%xmm10,%xmm10
 18e01b4:	62 c3 5d 00 20 e5 06 	vpinsrb $0x6,%r13d,%xmm20,%xmm20
 18e01bb:	62 c1 7d 08 7e dd    	vmovd  %xmm19,%r13d
 18e01c1:	c4 43 29 20 d3 0a    	vpinsrb $0xa,%r11d,%xmm10,%xmm10
 18e01c7:	62 e3 5d 00 20 e0 07 	vpinsrb $0x7,%eax,%xmm20,%xmm20
 18e01ce:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18e01d4:	62 a3 7d 48 39 ed 02 	vextracti32x4 $0x2,%zmm21,%xmm21
 18e01db:	c4 43 29 20 d0 0b    	vpinsrb $0xb,%r8d,%xmm10,%xmm10
 18e01e1:	c4 63 31 20 8c d1 83 0b 00 00 09 	vpinsrb $0x9,0xb83(%rcx,%rdx,8),%xmm9,%xmm9
 18e01ec:	62 e3 5d 00 20 e0 08 	vpinsrb $0x8,%eax,%xmm20,%xmm20
 18e01f3:	62 e3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%eax
 18e01fa:	62 e3 5d 00 20 e0 09 	vpinsrb $0x9,%eax,%xmm20,%xmm20
 18e0201:	c4 63 31 20 8c d1 ab 0b 00 00 0a 	vpinsrb $0xa,0xbab(%rcx,%rdx,8),%xmm9,%xmm9
 18e020c:	62 23 7d 28 39 c5 01 	vextracti32x4 $0x1,%ymm24,%xmm21
 18e0213:	62 23 7d 48 39 c3 03 	vextracti32x4 $0x3,%zmm24,%xmm19
 18e021a:	62 83 7d 48 39 f0 02 	vextracti32x4 $0x2,%zmm22,%xmm24
 18e0221:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18e0227:	62 a3 7d 48 39 fd 03 	vextracti32x4 $0x3,%zmm23,%xmm21
 18e022e:	62 e3 5d 00 20 e0 0a 	vpinsrb $0xa,%eax,%xmm20,%xmm20
 18e0235:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 18e023c:	62 a3 7d 48 39 d3 03 	vextracti32x4 $0x3,%zmm18,%xmm19
 18e0243:	62 a3 7d 28 39 d2 01 	vextracti32x4 $0x1,%ymm18,%xmm18
 18e024a:	c4 63 31 20 8c d1 d3 0b 00 00 0b 	vpinsrb $0xb,0xbd3(%rcx,%rdx,8),%xmm9,%xmm9
 18e0255:	62 e3 5d 00 20 e0 0b 	vpinsrb $0xb,%eax,%xmm20,%xmm20
 18e025c:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 18e0262:	62 a3 7d 28 39 fe 01 	vextracti32x4 $0x1,%ymm23,%xmm22
 18e0269:	62 e1 7f cb 6f bc d1 db 17 00 00 	vmovdqu8 0x17db(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e0274:	62 e3 5d 00 20 e0 0c 	vpinsrb $0xc,%eax,%xmm20,%xmm20
 18e027b:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e0282:	62 61 7f c9 6f 84 d1 bb 18 00 00 	vmovdqu8 0x18bb(%rcx,%rdx,8),%zmm24{%k1}{z}
 18e028d:	62 e3 5d 00 20 e0 0d 	vpinsrb $0xd,%eax,%xmm20,%xmm20
 18e0294:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 18e029a:	62 e1 7f c9 6f b4 d1 1b 18 00 00 	vmovdqu8 0x181b(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e02a5:	62 e3 5d 00 20 e0 0e 	vpinsrb $0xe,%eax,%xmm20,%xmm20
 18e02ac:	62 e3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%eax
 18e02b3:	62 e1 7f cb 6f ac d1 3b 17 00 00 	vmovdqu8 0x173b(%rcx,%rdx,8),%zmm21{%k3}{z}
 18e02be:	c4 63 31 20 8c d1 fb 0b 00 00 0c 	vpinsrb $0xc,0xbfb(%rcx,%rdx,8),%xmm9,%xmm9
 18e02c9:	62 e3 5d 00 20 e0 0f 	vpinsrb $0xf,%eax,%xmm20,%xmm20
 18e02d0:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 18e02d6:	62 a3 7d 48 39 c9 02 	vextracti32x4 $0x2,%zmm17,%xmm17
 18e02dd:	62 e3 7d 00 20 c0 04 	vpinsrb $0x4,%eax,%xmm16,%xmm16
 18e02e4:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 18e02eb:	62 33 7d 48 39 f1 02 	vextracti32x4 $0x2,%zmm14,%xmm17
 18e02f2:	62 e3 7d 00 20 c0 05 	vpinsrb $0x5,%eax,%xmm16,%xmm16
 18e02f9:	62 e1 7d 08 7e d0    	vmovd  %xmm18,%eax
 18e02ff:	62 e1 7f c9 6f 94 d1 7b 17 00 00 	vmovdqu8 0x177b(%rcx,%rdx,8),%zmm18{%k1}{z}
 18e030a:	62 e3 7d 00 20 c0 06 	vpinsrb $0x6,%eax,%xmm16,%xmm16
 18e0311:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 18e0318:	62 e1 7f c9 6f 9c d1 fb 19 00 00 	vmovdqu8 0x19fb(%rcx,%rdx,8),%zmm19{%k1}{z}
 18e0323:	c4 63 31 20 8c d1 23 0c 00 00 0d 	vpinsrb $0xd,0xc23(%rcx,%rdx,8),%xmm9,%xmm9
 18e032e:	62 e3 7d 00 20 c0 07 	vpinsrb $0x7,%eax,%xmm16,%xmm16
 18e0335:	c5 79 7e f0          	vmovd  %xmm14,%eax
 18e0339:	62 c1 7d 08 7e ff    	vmovd  %xmm23,%r15d
 18e033f:	62 73 7d 00 20 f0 08 	vpinsrb $0x8,%eax,%xmm16,%xmm14
 18e0346:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 18e034d:	62 33 7d 28 39 e8 01 	vextracti32x4 $0x1,%ymm13,%xmm16
 18e0354:	62 53 7d 48 39 ed 03 	vextracti32x4 $0x3,%zmm13,%xmm13
 18e035b:	62 e1 7f cb 6f 8c d1 bb 19 00 00 	vmovdqu8 0x19bb(%rcx,%rdx,8),%zmm17{%k3}{z}
 18e0366:	c4 63 09 20 f0 09    	vpinsrb $0x9,%eax,%xmm14,%xmm14
 18e036c:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 18e0372:	62 33 7d 48 39 e0 02 	vextracti32x4 $0x2,%zmm12,%xmm16
 18e0379:	c4 63 09 20 f0 0a    	vpinsrb $0xa,%eax,%xmm14,%xmm14
 18e037f:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18e0385:	62 53 7d 48 39 fd 03 	vextracti32x4 $0x3,%zmm15,%xmm13
 18e038c:	62 c1 7d 08 7e ea    	vmovd  %xmm21,%r10d
 18e0392:	c4 63 31 20 8c d1 4b 0c 00 00 0e 	vpinsrb $0xe,0xc4b(%rcx,%rdx,8),%xmm9,%xmm9
 18e039d:	c4 63 09 20 f0 0b    	vpinsrb $0xb,%eax,%xmm14,%xmm14
 18e03a3:	c5 79 7e e0          	vmovd  %xmm12,%eax
 18e03a7:	c4 63 09 20 e0 0c    	vpinsrb $0xc,%eax,%xmm14,%xmm12
 18e03ad:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18e03b4:	c4 43 7d 39 fe 01    	vextracti128 $0x1,%ymm15,%xmm14
 18e03ba:	62 e1 7f c9 6f 84 d1 db 1b 00 00 	vmovdqu8 0x1bdb(%rcx,%rdx,8),%zmm16{%k1}{z}
 18e03c5:	62 71 7f cb 6f bc d1 1b 19 00 00 	vmovdqu8 0x191b(%rcx,%rdx,8),%zmm15{%k3}{z}
 18e03d0:	c4 63 19 20 e0 0d    	vpinsrb $0xd,%eax,%xmm12,%xmm12
 18e03d6:	c5 79 7e f0          	vmovd  %xmm14,%eax
 18e03da:	62 71 7f cb 6f b4 d1 5b 1a 00 00 	vmovdqu8 0x1a5b(%rcx,%rdx,8),%zmm14{%k3}{z}
 18e03e5:	c4 63 19 20 e0 0e    	vpinsrb $0xe,%eax,%xmm12,%xmm12
 18e03eb:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18e03f1:	62 71 7f c9 6f ac d1 5b 19 00 00 	vmovdqu8 0x195b(%rcx,%rdx,8),%zmm13{%k1}{z}
 18e03fc:	c4 63 31 20 8c d1 73 0c 00 00 0f 	vpinsrb $0xf,0xc73(%rcx,%rdx,8),%xmm9,%xmm9
 18e0407:	c4 63 19 20 e0 0f    	vpinsrb $0xf,%eax,%xmm12,%xmm12
 18e040d:	c5 79 7e d8          	vmovd  %xmm11,%eax
 18e0411:	c4 63 29 20 d0 0c    	vpinsrb $0xc,%eax,%xmm10,%xmm10
 18e0417:	62 33 1d 28 38 dc 01 	vinserti32x4 $0x1,%xmm20,%ymm12,%ymm11
 18e041e:	62 71 7f c9 6f a4 d1 db 16 00 00 	vmovdqu8 0x16db(%rcx,%rdx,8),%zmm12{%k1}{z}
 18e0429:	62 e1 7f cb 6f a4 d1 9b 1b 00 00 	vmovdqu8 0x1b9b(%rcx,%rdx,8),%zmm20{%k3}{z}
 18e0434:	62 61 7d 08 7e c8    	vmovd  %xmm25,%eax
 18e043a:	c4 43 29 20 d4 0d    	vpinsrb $0xd,%r12d,%xmm10,%xmm10
 18e0440:	c4 43 29 20 d5 0e    	vpinsrb $0xe,%r13d,%xmm10,%xmm10
 18e0446:	c4 63 29 20 d3 0f    	vpinsrb $0xf,%ebx,%xmm10,%xmm10
 18e044c:	62 52 7d 48 7d fd    	vpermt2b %zmm13,%zmm0,%zmm15
 18e0452:	62 71 7f c9 6f ac d1 9b 1a 00 00 	vmovdqu8 0x1a9b(%rcx,%rdx,8),%zmm13{%k1}{z}
 18e045d:	c4 43 35 38 ca 01    	vinserti128 $0x1,%xmm10,%ymm9,%ymm9
 18e0463:	62 71 7f cb 6f 94 d1 1b 14 00 00 	vmovdqu8 0x141b(%rcx,%rdx,8),%zmm10{%k3}{z}
 18e046e:	62 53 b5 48 3a cb 01 	vinserti64x4 $0x1,%ymm11,%zmm9,%zmm9
 18e0475:	62 71 7f c9 6f 9c d1 5b 14 00 00 	vmovdqu8 0x145b(%rcx,%rdx,8),%zmm11{%k1}{z}
 18e0480:	62 a2 7d 48 7d e0    	vpermt2b %zmm16,%zmm0,%zmm20
 18e0486:	62 a3 7d 48 39 d0 03 	vextracti32x4 $0x3,%zmm18,%xmm16
 18e048d:	62 a3 7d 28 39 d2 01 	vextracti32x4 $0x1,%ymm18,%xmm18
 18e0494:	62 e1 7d 08 7e d7    	vmovd  %xmm18,%edi
 18e049a:	62 a3 7d 48 39 ea 02 	vextracti32x4 $0x2,%zmm21,%xmm18
 18e04a1:	62 a3 7d 48 39 f5 03 	vextracti32x4 $0x3,%zmm22,%xmm21
 18e04a8:	62 e3 7d 08 14 c6 08 	vpextrb $0x8,%xmm16,%esi
 18e04af:	62 e1 7f cb 6f 84 d1 fb 1a 00 00 	vmovdqu8 0x1afb(%rcx,%rdx,8),%zmm16{%k3}{z}
 18e04ba:	62 f1 35 48 74 ee    	vpcmpeqb %zmm6,%zmm9,%k5
 18e04c0:	62 f1 35 48 74 e4    	vpcmpeqb %zmm4,%zmm9,%k4
 18e04c6:	62 c3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%r8d
 18e04cd:	62 a3 7d 28 39 f5 01 	vextracti32x4 $0x1,%ymm22,%xmm21
 18e04d4:	62 e1 7f c9 6f b4 d1 7b 1c 00 00 	vmovdqu8 0x1c7b(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e04df:	62 c3 7d 08 14 d1 08 	vpextrb $0x8,%xmm18,%r9d
 18e04e6:	62 e1 7f c9 6f 94 d1 3b 1b 00 00 	vmovdqu8 0x1b3b(%rcx,%rdx,8),%zmm18{%k1}{z}
 18e04f1:	62 c1 7d 08 7e eb    	vmovd  %xmm21,%r11d
 18e04f7:	62 a3 7d 48 39 fd 02 	vextracti32x4 $0x2,%zmm23,%xmm21
 18e04fe:	62 e1 7f cb 6f bc d1 db 1c 00 00 	vmovdqu8 0x1cdb(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e0509:	62 c3 7d 08 14 ee 08 	vpextrb $0x8,%xmm21,%r14d
 18e0510:	62 23 7d 48 39 c5 03 	vextracti32x4 $0x3,%zmm24,%xmm21
 18e0517:	62 e3 7d 08 14 eb 08 	vpextrb $0x8,%xmm21,%ebx
 18e051e:	62 e3 5d 00 20 e0 04 	vpinsrb $0x4,%eax,%xmm20,%xmm20
 18e0525:	62 52 7d 48 7d d3    	vpermt2b %zmm11,%zmm0,%zmm10
 18e052b:	62 71 7f cb 6f 9c d1 9b 16 00 00 	vmovdqu8 0x169b(%rcx,%rdx,8),%zmm11{%k3}{z}
 18e0536:	c4 63 29 20 94 d1 bb 14 00 00 04 	vpinsrb $0x4,0x14bb(%rcx,%rdx,8),%xmm10,%xmm10
 18e0541:	c4 63 29 20 94 d1 e3 14 00 00 05 	vpinsrb $0x5,0x14e3(%rcx,%rdx,8),%xmm10,%xmm10
 18e054c:	62 52 7d 48 7d dc    	vpermt2b %zmm12,%zmm0,%zmm11
 18e0552:	62 71 7f cb 6f a4 d1 7b 18 00 00 	vmovdqu8 0x187b(%rcx,%rdx,8),%zmm12{%k3}{z}
 18e055d:	c4 63 29 20 94 d1 0b 15 00 00 06 	vpinsrb $0x6,0x150b(%rcx,%rdx,8),%xmm10,%xmm10
 18e0568:	c4 63 29 20 94 d1 33 15 00 00 07 	vpinsrb $0x7,0x1533(%rcx,%rdx,8),%xmm10,%xmm10
 18e0573:	c4 43 21 20 da 04    	vpinsrb $0x4,%r10d,%xmm11,%xmm11
 18e0579:	c4 43 21 20 d9 05    	vpinsrb $0x5,%r9d,%xmm11,%xmm11
 18e057f:	c4 63 21 20 df 06    	vpinsrb $0x6,%edi,%xmm11,%xmm11
 18e0585:	62 33 7d 48 39 e5 02 	vextracti32x4 $0x2,%zmm12,%xmm21
 18e058c:	c4 63 21 20 de 07    	vpinsrb $0x7,%esi,%xmm11,%xmm11
 18e0592:	c4 63 29 20 94 d1 5b 15 00 00 08 	vpinsrb $0x8,0x155b(%rcx,%rdx,8),%xmm10,%xmm10
 18e059d:	62 c3 7d 08 14 ec 08 	vpextrb $0x8,%xmm21,%r12d
 18e05a4:	62 23 7d 28 39 c5 01 	vextracti32x4 $0x1,%ymm24,%xmm21
 18e05ab:	62 03 7d 48 39 c8 02 	vextracti32x4 $0x2,%zmm25,%xmm24
 18e05b2:	c4 43 21 20 df 08    	vpinsrb $0x8,%r15d,%xmm11,%xmm11
 18e05b8:	62 c1 7d 08 7e ed    	vmovd  %xmm21,%r13d
 18e05be:	62 e1 7f c9 6f ac d1 1b 1d 00 00 	vmovdqu8 0x1d1b(%rcx,%rdx,8),%zmm21{%k1}{z}
 18e05c9:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e05d0:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 18e05d7:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 18e05de:	c4 43 21 20 de 09    	vpinsrb $0x9,%r14d,%xmm11,%xmm11
 18e05e4:	62 e3 5d 00 20 e0 05 	vpinsrb $0x5,%eax,%xmm20,%xmm20
 18e05eb:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e05f1:	62 61 7f cb 6f 84 d1 7b 1d 00 00 	vmovdqu8 0x1d7b(%rcx,%rdx,8),%zmm24{%k3}{z}
 18e05fc:	c4 43 21 20 db 0a    	vpinsrb $0xa,%r11d,%xmm11,%xmm11
 18e0602:	62 e3 5d 00 20 e0 06 	vpinsrb $0x6,%eax,%xmm20,%xmm20
 18e0609:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18e0610:	62 e1 7f c9 6f b4 d1 bb 1d 00 00 	vmovdqu8 0x1dbb(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e061b:	c4 43 21 20 d8 0b    	vpinsrb $0xb,%r8d,%xmm11,%xmm11
 18e0621:	c4 63 29 20 94 d1 83 15 00 00 09 	vpinsrb $0x9,0x1583(%rcx,%rdx,8),%xmm10,%xmm10
 18e062c:	62 e3 5d 00 20 e0 07 	vpinsrb $0x7,%eax,%xmm20,%xmm20
 18e0633:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e0639:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18e0640:	62 e3 5d 00 20 e0 08 	vpinsrb $0x8,%eax,%xmm20,%xmm20
 18e0647:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e064e:	62 e3 5d 00 20 e0 09 	vpinsrb $0x9,%eax,%xmm20,%xmm20
 18e0655:	c4 63 29 20 94 d1 ab 15 00 00 0a 	vpinsrb $0xa,0x15ab(%rcx,%rdx,8),%xmm10,%xmm10
 18e0660:	62 a3 7d 48 39 ef 03 	vextracti32x4 $0x3,%zmm21,%xmm23
 18e0667:	62 a3 7d 28 39 ed 01 	vextracti32x4 $0x1,%ymm21,%xmm21
 18e066e:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18e0674:	62 a3 7d 48 39 dd 03 	vextracti32x4 $0x3,%zmm19,%xmm21
 18e067b:	62 a3 7d 28 39 db 01 	vextracti32x4 $0x1,%ymm19,%xmm19
 18e0682:	62 e3 5d 00 20 e0 0a 	vpinsrb $0xa,%eax,%xmm20,%xmm20
 18e0689:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e0690:	62 a3 7d 48 39 f7 03 	vextracti32x4 $0x3,%zmm22,%xmm23
 18e0697:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 18e069e:	c4 63 29 20 94 d1 d3 15 00 00 0b 	vpinsrb $0xb,0x15d3(%rcx,%rdx,8),%xmm10,%xmm10
 18e06a9:	62 e3 5d 00 20 e0 0b 	vpinsrb $0xb,%eax,%xmm20,%xmm20
 18e06b0:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e06b6:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18e06bd:	62 e3 5d 00 20 e0 0c 	vpinsrb $0xc,%eax,%xmm20,%xmm20
 18e06c4:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e06cb:	62 61 7f c9 6f 84 d1 1b 22 00 00 	vmovdqu8 0x221b(%rcx,%rdx,8),%zmm24{%k1}{z}
 18e06d6:	62 e3 5d 00 20 e0 0d 	vpinsrb $0xd,%eax,%xmm20,%xmm20
 18e06dd:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 18e06e3:	62 e1 7f c9 6f b4 d1 bb 22 00 00 	vmovdqu8 0x22bb(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e06ee:	62 e3 5d 00 20 e0 0e 	vpinsrb $0xe,%eax,%xmm20,%xmm20
 18e06f5:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e06fc:	62 e1 7f cb 6f bc d1 db 21 00 00 	vmovdqu8 0x21db(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e0707:	c4 63 29 20 94 d1 fb 15 00 00 0c 	vpinsrb $0xc,0x15fb(%rcx,%rdx,8),%xmm10,%xmm10
 18e0712:	62 e3 5d 00 20 e0 0f 	vpinsrb $0xf,%eax,%xmm20,%xmm20
 18e0719:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 18e071f:	62 a3 7d 48 39 c9 02 	vextracti32x4 $0x2,%zmm17,%xmm17
 18e0726:	c4 63 01 20 f8 04    	vpinsrb $0x4,%eax,%xmm15,%xmm15
 18e072c:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 18e0733:	62 33 7d 48 39 f1 02 	vextracti32x4 $0x2,%zmm14,%xmm17
 18e073a:	c4 63 01 20 f8 05    	vpinsrb $0x5,%eax,%xmm15,%xmm15
 18e0740:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 18e0746:	62 e1 7f c9 6f 9c d1 7b 21 00 00 	vmovdqu8 0x217b(%rcx,%rdx,8),%zmm19{%k1}{z}
 18e0751:	c4 63 01 20 f8 06    	vpinsrb $0x6,%eax,%xmm15,%xmm15
 18e0757:	62 e3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%eax
 18e075e:	62 e1 7f cb 6f ac d1 9b 25 00 00 	vmovdqu8 0x259b(%rcx,%rdx,8),%zmm21{%k3}{z}
 18e0769:	c4 63 29 20 94 d1 23 16 00 00 0d 	vpinsrb $0xd,0x1623(%rcx,%rdx,8),%xmm10,%xmm10
 18e0774:	c4 63 01 20 f8 07    	vpinsrb $0x7,%eax,%xmm15,%xmm15
 18e077a:	c5 79 7e f0          	vmovd  %xmm14,%eax
 18e077e:	c4 63 01 20 f0 08    	vpinsrb $0x8,%eax,%xmm15,%xmm14
 18e0784:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 18e078b:	c4 43 7d 39 ef 01    	vextracti128 $0x1,%ymm13,%xmm15
 18e0791:	62 53 7d 48 39 ed 03 	vextracti32x4 $0x3,%zmm13,%xmm13
 18e0798:	62 e1 7f c9 6f 8c d1 db 25 00 00 	vmovdqu8 0x25db(%rcx,%rdx,8),%zmm17{%k1}{z}
 18e07a3:	c4 63 09 20 f0 09    	vpinsrb $0x9,%eax,%xmm14,%xmm14
 18e07a9:	c5 79 7e f8          	vmovd  %xmm15,%eax
 18e07ad:	62 c3 7d 48 39 c7 02 	vextracti32x4 $0x2,%zmm16,%xmm15
 18e07b4:	c4 63 09 20 f0 0a    	vpinsrb $0xa,%eax,%xmm14,%xmm14
 18e07ba:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18e07c0:	62 c3 7d 48 39 d5 03 	vextracti32x4 $0x3,%zmm18,%xmm13
 18e07c7:	62 c1 7d 08 7e ff    	vmovd  %xmm23,%r15d
 18e07cd:	c4 63 29 20 94 d1 4b 16 00 00 0e 	vpinsrb $0xe,0x164b(%rcx,%rdx,8),%xmm10,%xmm10
 18e07d8:	c4 63 09 20 f0 0b    	vpinsrb $0xb,%eax,%xmm14,%xmm14
 18e07de:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 18e07e4:	62 e1 7f cb 6f 84 d1 bb 23 00 00 	vmovdqu8 0x23bb(%rcx,%rdx,8),%zmm16{%k3}{z}
 18e07ef:	c4 63 09 20 f0 0c    	vpinsrb $0xc,%eax,%xmm14,%xmm14
 18e07f5:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 18e07fb:	62 c3 7d 28 39 d7 01 	vextracti32x4 $0x1,%ymm18,%xmm15
 18e0802:	62 e1 7f c9 6f 94 d1 fb 23 00 00 	vmovdqu8 0x23fb(%rcx,%rdx,8),%zmm18{%k1}{z}
 18e080d:	c4 63 09 20 f0 0d    	vpinsrb $0xd,%eax,%xmm14,%xmm14
 18e0813:	c5 79 7e f8          	vmovd  %xmm15,%eax
 18e0817:	62 71 7f cb 6f bc d1 1b 23 00 00 	vmovdqu8 0x231b(%rcx,%rdx,8),%zmm15{%k3}{z}
 18e0822:	c4 63 09 20 f0 0e    	vpinsrb $0xe,%eax,%xmm14,%xmm14
 18e0828:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18e082e:	c4 63 29 20 94 d1 73 16 00 00 0f 	vpinsrb $0xf,0x1673(%rcx,%rdx,8),%xmm10,%xmm10
 18e0839:	c4 63 09 20 e8 0f    	vpinsrb $0xf,%eax,%xmm14,%xmm13
 18e083f:	c5 79 7e e0          	vmovd  %xmm12,%eax
 18e0843:	62 71 7f c9 6f b4 d1 5b 23 00 00 	vmovdqu8 0x235b(%rcx,%rdx,8),%zmm14{%k1}{z}
 18e084e:	c4 63 21 20 d8 0c    	vpinsrb $0xc,%eax,%xmm11,%xmm11
 18e0854:	62 33 15 28 38 e4 01 	vinserti32x4 $0x1,%xmm20,%ymm13,%ymm12
 18e085b:	62 e1 7f cb 6f a4 d1 3b 21 00 00 	vmovdqu8 0x213b(%rcx,%rdx,8),%zmm20{%k3}{z}
 18e0866:	62 71 7f c9 6f ac d1 db 20 00 00 	vmovdqu8 0x20db(%rcx,%rdx,8),%zmm13{%k1}{z}
 18e0871:	62 a2 7d 48 7d e9    	vpermt2b %zmm17,%zmm0,%zmm21
 18e0877:	62 a3 7d 48 39 d9 03 	vextracti32x4 $0x3,%zmm19,%xmm17
 18e087e:	62 a3 7d 28 39 db 01 	vextracti32x4 $0x1,%ymm19,%xmm19
 18e0885:	c4 43 21 20 dc 0d    	vpinsrb $0xd,%r12d,%xmm11,%xmm11
 18e088b:	62 e1 7d 08 7e df    	vmovd  %xmm19,%edi
 18e0891:	62 e3 7d 08 14 ce 08 	vpextrb $0x8,%xmm17,%esi
 18e0898:	62 e1 7f c9 6f 8c d1 9b 24 00 00 	vmovdqu8 0x249b(%rcx,%rdx,8),%zmm17{%k1}{z}
 18e08a3:	c4 43 21 20 dd 0e    	vpinsrb $0xe,%r13d,%xmm11,%xmm11
 18e08a9:	c4 63 21 20 db 0f    	vpinsrb $0xf,%ebx,%xmm11,%xmm11
 18e08af:	c4 43 2d 38 d3 01    	vinserti128 $0x1,%xmm11,%ymm10,%ymm10
 18e08b5:	62 71 7f cb 6f 9c d1 1b 1e 00 00 	vmovdqu8 0x1e1b(%rcx,%rdx,8),%zmm11{%k3}{z}
 18e08c0:	62 52 7d 48 7d fe    	vpermt2b %zmm14,%zmm0,%zmm15
 18e08c6:	62 71 7f cb 6f b4 d1 5b 24 00 00 	vmovdqu8 0x245b(%rcx,%rdx,8),%zmm14{%k3}{z}
 18e08d1:	62 53 ad 48 3a d4 01 	vinserti64x4 $0x1,%ymm12,%zmm10,%zmm10
 18e08d8:	62 71 7f c9 6f a4 d1 5b 1e 00 00 	vmovdqu8 0x1e5b(%rcx,%rdx,8),%zmm12{%k1}{z}
 18e08e3:	62 a3 7d 48 39 e3 02 	vextracti32x4 $0x2,%zmm20,%xmm19
 18e08ea:	62 c1 7d 08 7e e2    	vmovd  %xmm20,%r10d
 18e08f0:	62 a3 7d 48 39 fc 02 	vextracti32x4 $0x2,%zmm23,%xmm20
 18e08f7:	62 a3 7d 48 39 f7 03 	vextracti32x4 $0x3,%zmm22,%xmm23
 18e08fe:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 18e0905:	62 c3 7d 08 14 d9 08 	vpextrb $0x8,%xmm19,%r9d
 18e090c:	62 23 7d 48 39 c3 03 	vextracti32x4 $0x3,%zmm24,%xmm19
 18e0913:	62 03 7d 28 39 c0 01 	vextracti32x4 $0x1,%ymm24,%xmm24
 18e091a:	62 c3 7d 08 14 fe 08 	vpextrb $0x8,%xmm23,%r14d
 18e0921:	62 c3 7d 08 14 e3 08 	vpextrb $0x8,%xmm20,%r11d
 18e0928:	62 e1 7f c9 6f a4 d1 3b 25 00 00 	vmovdqu8 0x253b(%rcx,%rdx,8),%zmm20{%k1}{z}
 18e0933:	62 f1 2d 48 74 c4    	vpcmpeqb %zmm4,%zmm10,%k0
 18e0939:	62 61 7d 08 7e c3    	vmovd  %xmm24,%ebx
 18e093f:	62 61 7f cb 6f 84 d1 3b 26 00 00 	vmovdqu8 0x263b(%rcx,%rdx,8),%zmm24{%k3}{z}
 18e094a:	62 c3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%r8d
 18e0951:	62 e1 7f cb 6f 9c d1 fb 24 00 00 	vmovdqu8 0x24fb(%rcx,%rdx,8),%zmm19{%k3}{z}
 18e095c:	62 52 7d 48 7d dc    	vpermt2b %zmm12,%zmm0,%zmm11
 18e0962:	62 71 7f cb 6f a4 d1 9b 20 00 00 	vmovdqu8 0x209b(%rcx,%rdx,8),%zmm12{%k3}{z}
 18e096d:	c4 63 21 20 9c d1 bb 1e 00 00 04 	vpinsrb $0x4,0x1ebb(%rcx,%rdx,8),%xmm11,%xmm11
 18e0978:	62 41 7d 08 7e c5    	vmovd  %xmm24,%r13d
 18e097e:	62 c3 55 00 20 ed 04 	vpinsrb $0x4,%r13d,%xmm21,%xmm21
 18e0985:	62 c1 7d 08 7e f5    	vmovd  %xmm22,%r13d
 18e098b:	c4 63 21 20 9c d1 e3 1e 00 00 05 	vpinsrb $0x5,0x1ee3(%rcx,%rdx,8),%xmm11,%xmm11
 18e0996:	62 52 7d 48 7d e5    	vpermt2b %zmm13,%zmm0,%zmm12
 18e099c:	62 71 7f cb 6f ac d1 7b 22 00 00 	vmovdqu8 0x227b(%rcx,%rdx,8),%zmm13{%k3}{z}
 18e09a7:	c4 63 21 20 9c d1 0b 1f 00 00 06 	vpinsrb $0x6,0x1f0b(%rcx,%rdx,8),%xmm11,%xmm11
 18e09b2:	c4 63 21 20 9c d1 33 1f 00 00 07 	vpinsrb $0x7,0x1f33(%rcx,%rdx,8),%xmm11,%xmm11
 18e09bd:	c4 43 19 20 e2 04    	vpinsrb $0x4,%r10d,%xmm12,%xmm12
 18e09c3:	44 0f b6 94 d1 a2 01 00 00 	movzbl 0x1a2(%rcx,%rdx,8),%r10d
 18e09cc:	c4 43 19 20 e1 05    	vpinsrb $0x5,%r9d,%xmm12,%xmm12
 18e09d2:	44 0f b6 8c d1 ca 01 00 00 	movzbl 0x1ca(%rcx,%rdx,8),%r9d
 18e09db:	c4 63 19 20 e7 06    	vpinsrb $0x6,%edi,%xmm12,%xmm12
 18e09e1:	0f b6 bc d1 1a 02 00 00 	movzbl 0x21a(%rcx,%rdx,8),%edi
 18e09e9:	62 33 7d 48 39 ef 02 	vextracti32x4 $0x2,%zmm13,%xmm23
 18e09f0:	c4 63 19 20 e6 07    	vpinsrb $0x7,%esi,%xmm12,%xmm12
 18e09f6:	0f b6 b4 d1 42 02 00 00 	movzbl 0x242(%rcx,%rdx,8),%esi
 18e09fe:	62 c3 7d 08 14 fc 08 	vpextrb $0x8,%xmm23,%r12d
 18e0a05:	62 23 7d 48 39 c7 02 	vextracti32x4 $0x2,%zmm24,%xmm23
 18e0a0c:	62 61 7f cb 6f 84 d1 db 26 00 00 	vmovdqu8 0x26db(%rcx,%rdx,8),%zmm24{%k3}{z}
 18e0a17:	c4 63 21 20 9c d1 5b 1f 00 00 08 	vpinsrb $0x8,0x1f5b(%rcx,%rdx,8),%xmm11,%xmm11
 18e0a22:	c4 43 19 20 e7 08    	vpinsrb $0x8,%r15d,%xmm12,%xmm12
 18e0a28:	44 0f b6 bc d1 02 01 00 00 	movzbl 0x102(%rcx,%rdx,8),%r15d
 18e0a31:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e0a38:	62 e1 7f c9 6f bc d1 7b 26 00 00 	vmovdqu8 0x267b(%rcx,%rdx,8),%zmm23{%k1}{z}
 18e0a43:	c4 43 19 20 e3 09    	vpinsrb $0x9,%r11d,%xmm12,%xmm12
 18e0a49:	44 0f b6 9c d1 7a 01 00 00 	movzbl 0x17a(%rcx,%rdx,8),%r11d
 18e0a52:	62 e3 55 00 20 e8 05 	vpinsrb $0x5,%eax,%xmm21,%xmm21
 18e0a59:	c4 63 19 20 e3 0a    	vpinsrb $0xa,%ebx,%xmm12,%xmm12
 18e0a5f:	0f b6 9c d1 52 01 00 00 	movzbl 0x152(%rcx,%rdx,8),%ebx
 18e0a67:	c4 43 19 20 e0 0b    	vpinsrb $0xb,%r8d,%xmm12,%xmm12
 18e0a6d:	44 0f b6 84 d1 f2 01 00 00 	movzbl 0x1f2(%rcx,%rdx,8),%r8d
 18e0a76:	c4 63 21 20 9c d1 83 1f 00 00 09 	vpinsrb $0x9,0x1f83(%rcx,%rdx,8),%xmm11,%xmm11
 18e0a81:	c4 63 21 20 9c d1 ab 1f 00 00 0a 	vpinsrb $0xa,0x1fab(%rcx,%rdx,8),%xmm11,%xmm11
 18e0a8c:	62 a3 7d 28 39 fe 01 	vextracti32x4 $0x1,%ymm23,%xmm22
 18e0a93:	62 a3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm23,%xmm23
 18e0a9a:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 18e0aa0:	62 e1 7f c9 6f b4 d1 1b 27 00 00 	vmovdqu8 0x271b(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e0aab:	62 e3 55 00 20 e8 06 	vpinsrb $0x6,%eax,%xmm21,%xmm21
 18e0ab2:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e0ab9:	62 e1 7f cb 6f bc d1 7b 27 00 00 	vmovdqu8 0x277b(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e0ac4:	62 e3 55 00 20 e8 07 	vpinsrb $0x7,%eax,%xmm21,%xmm21
 18e0acb:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e0ad1:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18e0ad8:	c4 63 21 20 9c d1 d3 1f 00 00 0b 	vpinsrb $0xb,0x1fd3(%rcx,%rdx,8),%xmm11,%xmm11
 18e0ae3:	62 e3 55 00 20 e8 08 	vpinsrb $0x8,%eax,%xmm21,%xmm21
 18e0aea:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e0af1:	62 e3 55 00 20 e8 09 	vpinsrb $0x9,%eax,%xmm21,%xmm21
 18e0af8:	c4 63 21 20 9c d1 fb 1f 00 00 0c 	vpinsrb $0xc,0x1ffb(%rcx,%rdx,8),%xmm11,%xmm11
 18e0b03:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 18e0b0a:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 18e0b11:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e0b17:	62 61 7f c9 6f 84 d1 bb 27 00 00 	vmovdqu8 0x27bb(%rcx,%rdx,8),%zmm24{%k1}{z}
 18e0b22:	62 e3 55 00 20 e8 0a 	vpinsrb $0xa,%eax,%xmm21,%xmm21
 18e0b29:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18e0b30:	62 a3 7d 48 39 d6 03 	vextracti32x4 $0x3,%zmm18,%xmm22
 18e0b37:	62 a3 7d 28 39 d2 01 	vextracti32x4 $0x1,%ymm18,%xmm18
 18e0b3e:	c4 63 21 20 9c d1 23 20 00 00 0d 	vpinsrb $0xd,0x2023(%rcx,%rdx,8),%xmm11,%xmm11
 18e0b49:	62 e3 55 00 20 e8 0b 	vpinsrb $0xb,%eax,%xmm21,%xmm21
 18e0b50:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e0b56:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18e0b5d:	62 e3 55 00 20 e8 0c 	vpinsrb $0xc,%eax,%xmm21,%xmm21
 18e0b64:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e0b6b:	62 e3 55 00 20 e8 0d 	vpinsrb $0xd,%eax,%xmm21,%xmm21
 18e0b72:	c4 63 21 20 9c d1 4b 20 00 00 0e 	vpinsrb $0xe,0x204b(%rcx,%rdx,8),%xmm11,%xmm11
 18e0b7d:	62 23 7d 48 39 c7 03 	vextracti32x4 $0x3,%zmm24,%xmm23
 18e0b84:	62 03 7d 28 39 c0 01 	vextracti32x4 $0x1,%ymm24,%xmm24
 18e0b8b:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e0b91:	62 61 7f cb 6f 84 d1 32 08 00 00 	vmovdqu8 0x832(%rcx,%rdx,8),%zmm24{%k3}{z}
 18e0b9c:	c4 63 21 20 9c d1 73 20 00 00 0f 	vpinsrb $0xf,0x2073(%rcx,%rdx,8),%xmm11,%xmm11
 18e0ba7:	62 e3 55 00 20 e8 0e 	vpinsrb $0xe,%eax,%xmm21,%xmm21
 18e0bae:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e0bb5:	62 e1 7f cb 6f bc d1 92 07 00 00 	vmovdqu8 0x792(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e0bc0:	62 e3 55 00 20 e8 0f 	vpinsrb $0xf,%eax,%xmm21,%xmm21
 18e0bc7:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 18e0bcd:	62 a3 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm16,%xmm16
 18e0bd4:	c4 63 01 20 f8 04    	vpinsrb $0x4,%eax,%xmm15,%xmm15
 18e0bda:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18e0be1:	62 33 7d 48 39 f0 02 	vextracti32x4 $0x2,%zmm14,%xmm16
 18e0be8:	c4 63 01 20 f8 05    	vpinsrb $0x5,%eax,%xmm15,%xmm15
 18e0bee:	62 e1 7d 08 7e d0    	vmovd  %xmm18,%eax
 18e0bf4:	62 e1 7f cb 6f 94 d1 32 03 00 00 	vmovdqu8 0x332(%rcx,%rdx,8),%zmm18{%k3}{z}
 18e0bff:	c4 63 01 20 f8 06    	vpinsrb $0x6,%eax,%xmm15,%xmm15
 18e0c05:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18e0c0c:	62 e1 7f c9 6f b4 d1 d2 07 00 00 	vmovdqu8 0x7d2(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e0c17:	c4 63 01 20 f8 07    	vpinsrb $0x7,%eax,%xmm15,%xmm15
 18e0c1d:	c5 79 7e f0          	vmovd  %xmm14,%eax
 18e0c21:	c4 63 01 20 f0 08    	vpinsrb $0x8,%eax,%xmm15,%xmm14
 18e0c27:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18e0c2e:	62 c3 7d 28 39 cf 01 	vextracti32x4 $0x1,%ymm17,%xmm15
 18e0c35:	62 a3 7d 48 39 d8 02 	vextracti32x4 $0x2,%zmm19,%xmm16
 18e0c3c:	c4 63 09 20 f0 09    	vpinsrb $0x9,%eax,%xmm14,%xmm14
 18e0c42:	c5 79 7e f8          	vmovd  %xmm15,%eax
 18e0c46:	62 c3 7d 48 39 cf 03 	vextracti32x4 $0x3,%zmm17,%xmm15
 18e0c4d:	62 e1 7f cb 6f 8c d1 92 02 00 00 	vmovdqu8 0x292(%rcx,%rdx,8),%zmm17{%k3}{z}
 18e0c58:	c4 63 09 20 f0 0a    	vpinsrb $0xa,%eax,%xmm14,%xmm14
 18e0c5e:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 18e0c64:	62 c3 7d 48 39 e7 03 	vextracti32x4 $0x3,%zmm20,%xmm15
 18e0c6b:	c4 63 09 20 f0 0b    	vpinsrb $0xb,%eax,%xmm14,%xmm14
 18e0c71:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 18e0c77:	62 e1 7f c9 6f 9c d1 72 03 00 00 	vmovdqu8 0x372(%rcx,%rdx,8),%zmm19{%k1}{z}
 18e0c82:	c4 63 09 20 f0 0c    	vpinsrb $0xc,%eax,%xmm14,%xmm14
 18e0c88:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18e0c8f:	62 a3 7d 28 39 e0 01 	vextracti32x4 $0x1,%ymm20,%xmm16
 18e0c96:	62 e1 7f cb 6f a4 d1 12 05 00 00 	vmovdqu8 0x512(%rcx,%rdx,8),%zmm20{%k3}{z}
 18e0ca1:	c4 63 09 20 f0 0d    	vpinsrb $0xd,%eax,%xmm14,%xmm14
 18e0ca7:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 18e0cad:	62 e1 7f cb 6f 84 d1 d2 03 00 00 	vmovdqu8 0x3d2(%rcx,%rdx,8),%zmm16{%k3}{z}
 18e0cb8:	62 a2 7d 48 7d fe    	vpermt2b %zmm22,%zmm0,%zmm23
 18e0cbe:	62 e1 7f c9 6f b4 d1 72 08 00 00 	vmovdqu8 0x872(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e0cc9:	c4 63 09 20 f0 0e    	vpinsrb $0xe,%eax,%xmm14,%xmm14
 18e0ccf:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 18e0cd5:	62 71 7f c9 6f bc d1 12 04 00 00 	vmovdqu8 0x412(%rcx,%rdx,8),%zmm15{%k1}{z}
 18e0ce0:	c4 63 09 20 f0 0f    	vpinsrb $0xf,%eax,%xmm14,%xmm14
 18e0ce6:	c5 79 7e e8          	vmovd  %xmm13,%eax
 18e0cea:	c4 63 19 20 e0 0c    	vpinsrb $0xc,%eax,%xmm12,%xmm12
 18e0cf0:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e0cf6:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18e0cfd:	62 33 0d 28 38 ed 01 	vinserti32x4 $0x1,%xmm21,%ymm14,%ymm13
 18e0d04:	62 e1 7f c9 6f ac d1 52 05 00 00 	vmovdqu8 0x552(%rcx,%rdx,8),%zmm21{%k1}{z}
 18e0d0f:	62 71 7f cb 6f b4 d1 72 04 00 00 	vmovdqu8 0x472(%rcx,%rdx,8),%zmm14{%k3}{z}
 18e0d1a:	c4 43 19 20 e4 0d    	vpinsrb $0xd,%r12d,%xmm12,%xmm12
 18e0d20:	44 0f b6 a4 d1 da 00 00 00 	movzbl 0xda(%rcx,%rdx,8),%r12d
 18e0d29:	c4 43 19 20 e5 0e    	vpinsrb $0xe,%r13d,%xmm12,%xmm12
 18e0d2f:	44 0f b6 ac d1 b2 00 00 00 	movzbl 0xb2(%rcx,%rdx,8),%r13d
 18e0d38:	62 e3 45 00 20 f8 04 	vpinsrb $0x4,%eax,%xmm23,%xmm23
 18e0d3f:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e0d46:	c4 43 19 20 e6 0f    	vpinsrb $0xf,%r14d,%xmm12,%xmm12
 18e0d4c:	44 0f b6 b4 d1 2a 01 00 00 	movzbl 0x12a(%rcx,%rdx,8),%r14d
 18e0d55:	62 e3 45 00 20 f8 05 	vpinsrb $0x5,%eax,%xmm23,%xmm23
 18e0d5c:	c4 43 25 38 dc 01    	vinserti128 $0x1,%xmm12,%ymm11,%ymm11
 18e0d62:	62 71 7f cb 6f a4 d1 12 00 00 00 	vmovdqu8 0x12(%rcx,%rdx,8),%zmm12{%k3}{z}
 18e0d6d:	62 53 a5 48 3a dd 01 	vinserti64x4 $0x1,%ymm13,%zmm11,%zmm11
 18e0d74:	62 71 7f c9 6f ac d1 52 00 00 00 	vmovdqu8 0x52(%rcx,%rdx,8),%zmm13{%k1}{z}
 18e0d7f:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 18e0d86:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 18e0d8d:	62 f1 25 48 74 fb    	vpcmpeqb %zmm3,%zmm11,%k7
 18e0d93:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e0d99:	62 61 7f cb 6f 84 d1 d2 08 00 00 	vmovdqu8 0x8d2(%rcx,%rdx,8),%zmm24{%k3}{z}
 18e0da4:	62 e3 45 00 20 f8 06 	vpinsrb $0x6,%eax,%xmm23,%xmm23
 18e0dab:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18e0db2:	62 e1 7f c9 6f b4 d1 12 09 00 00 	vmovdqu8 0x912(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e0dbd:	62 a2 7d 48 7d e5    	vpermt2b %zmm21,%zmm0,%zmm20
 18e0dc3:	62 e1 7f cb 6f ac d1 b2 05 00 00 	vmovdqu8 0x5b2(%rcx,%rdx,8),%zmm21{%k3}{z}
 18e0dce:	62 e3 45 00 20 f8 07 	vpinsrb $0x7,%eax,%xmm23,%xmm23
 18e0dd5:	62 52 7d 48 7d e5    	vpermt2b %zmm13,%zmm0,%zmm12
 18e0ddb:	62 71 7f c9 6f ac d1 d2 02 00 00 	vmovdqu8 0x2d2(%rcx,%rdx,8),%zmm13{%k1}{z}
 18e0de6:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e0dec:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18e0df3:	62 e3 45 00 20 f8 08 	vpinsrb $0x8,%eax,%xmm23,%xmm23
 18e0dfa:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e0e01:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 18e0e08:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 18e0e0f:	62 e3 45 00 20 f8 09 	vpinsrb $0x9,%eax,%xmm23,%xmm23
 18e0e16:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e0e1c:	62 61 7f cb 6f 84 d1 72 09 00 00 	vmovdqu8 0x972(%rcx,%rdx,8),%zmm24{%k3}{z}
 18e0e27:	62 e3 45 00 20 f8 0a 	vpinsrb $0xa,%eax,%xmm23,%xmm23
 18e0e2e:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18e0e35:	62 e1 7f c9 6f b4 d1 b2 09 00 00 	vmovdqu8 0x9b2(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e0e40:	c4 43 19 20 e5 04    	vpinsrb $0x4,%r13d,%xmm12,%xmm12
 18e0e46:	44 0f b6 ac d1 b2 0a 00 00 	movzbl 0xab2(%rcx,%rdx,8),%r13d
 18e0e4f:	62 e3 45 00 20 f8 0b 	vpinsrb $0xb,%eax,%xmm23,%xmm23
 18e0e56:	c4 43 19 20 e4 05    	vpinsrb $0x5,%r12d,%xmm12,%xmm12
 18e0e5c:	44 0f b6 a4 d1 da 0a 00 00 	movzbl 0xada(%rcx,%rdx,8),%r12d
 18e0e65:	c4 43 19 20 e7 06    	vpinsrb $0x6,%r15d,%xmm12,%xmm12
 18e0e6b:	44 0f b6 bc d1 02 0b 00 00 	movzbl 0xb02(%rcx,%rdx,8),%r15d
 18e0e74:	62 c2 7d 48 7d cd    	vpermt2b %zmm13,%zmm0,%zmm17
 18e0e7a:	62 71 7f c9 6f ac d1 b2 04 00 00 	vmovdqu8 0x4b2(%rcx,%rdx,8),%zmm13{%k1}{z}
 18e0e85:	c4 43 19 20 e6 07    	vpinsrb $0x7,%r14d,%xmm12,%xmm12
 18e0e8b:	44 0f b6 b4 d1 2a 0b 00 00 	movzbl 0xb2a(%rcx,%rdx,8),%r14d
 18e0e94:	c4 63 19 20 e3 08    	vpinsrb $0x8,%ebx,%xmm12,%xmm12
 18e0e9a:	0f b6 9c d1 52 0b 00 00 	movzbl 0xb52(%rcx,%rdx,8),%ebx
 18e0ea2:	c4 43 19 20 e3 09    	vpinsrb $0x9,%r11d,%xmm12,%xmm12
 18e0ea8:	44 0f b6 9c d1 7a 0b 00 00 	movzbl 0xb7a(%rcx,%rdx,8),%r11d
 18e0eb1:	c4 43 19 20 e2 0a    	vpinsrb $0xa,%r10d,%xmm12,%xmm12
 18e0eb7:	44 0f b6 94 d1 a2 0b 00 00 	movzbl 0xba2(%rcx,%rdx,8),%r10d
 18e0ec0:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e0ec6:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18e0ecd:	c4 43 19 20 e1 0b    	vpinsrb $0xb,%r9d,%xmm12,%xmm12
 18e0ed3:	44 0f b6 8c d1 ca 0b 00 00 	movzbl 0xbca(%rcx,%rdx,8),%r9d
 18e0edc:	62 e3 45 00 20 f8 0c 	vpinsrb $0xc,%eax,%xmm23,%xmm23
 18e0ee3:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e0eea:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 18e0ef1:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 18e0ef8:	c4 43 19 20 e0 0c    	vpinsrb $0xc,%r8d,%xmm12,%xmm12
 18e0efe:	44 0f b6 84 d1 f2 0b 00 00 	movzbl 0xbf2(%rcx,%rdx,8),%r8d
 18e0f07:	62 e3 45 00 20 f8 0d 	vpinsrb $0xd,%eax,%xmm23,%xmm23
 18e0f0e:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e0f14:	62 61 7f c9 6f 84 d1 f2 05 00 00 	vmovdqu8 0x5f2(%rcx,%rdx,8),%zmm24{%k1}{z}
 18e0f1f:	c4 63 19 20 e7 0d    	vpinsrb $0xd,%edi,%xmm12,%xmm12
 18e0f25:	0f b6 bc d1 1a 0c 00 00 	movzbl 0xc1a(%rcx,%rdx,8),%edi
 18e0f2d:	62 e3 45 00 20 f8 0e 	vpinsrb $0xe,%eax,%xmm23,%xmm23
 18e0f34:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18e0f3b:	c4 63 19 20 e6 0e    	vpinsrb $0xe,%esi,%xmm12,%xmm12
 18e0f41:	0f b6 b4 d1 42 0c 00 00 	movzbl 0xc42(%rcx,%rdx,8),%esi
 18e0f49:	62 e3 45 00 20 f0 0f 	vpinsrb $0xf,%eax,%xmm23,%xmm22
 18e0f50:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18e0f56:	62 a3 7d 48 39 ef 02 	vextracti32x4 $0x2,%zmm21,%xmm23
 18e0f5d:	62 e1 7f cb 6f ac d1 52 06 00 00 	vmovdqu8 0x652(%rcx,%rdx,8),%zmm21{%k3}{z}
 18e0f68:	62 e3 5d 00 20 e0 04 	vpinsrb $0x4,%eax,%xmm20,%xmm20
 18e0f6f:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e0f76:	62 e3 5d 00 20 e0 05 	vpinsrb $0x5,%eax,%xmm20,%xmm20
 18e0f7d:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 18e0f84:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 18e0f8b:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e0f91:	62 e1 7f c9 6f bc d1 92 06 00 00 	vmovdqu8 0x692(%rcx,%rdx,8),%zmm23{%k1}{z}
 18e0f9c:	62 e3 5d 00 20 e0 06 	vpinsrb $0x6,%eax,%xmm20,%xmm20
 18e0fa3:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e0faa:	62 61 7f cb 6f 84 d1 f2 06 00 00 	vmovdqu8 0x6f2(%rcx,%rdx,8),%zmm24{%k3}{z}
 18e0fb5:	62 e3 5d 00 20 e0 07 	vpinsrb $0x7,%eax,%xmm20,%xmm20
 18e0fbc:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18e0fc2:	62 a3 7d 48 39 ed 02 	vextracti32x4 $0x2,%zmm21,%xmm21
 18e0fc9:	62 e3 5d 00 20 e0 08 	vpinsrb $0x8,%eax,%xmm20,%xmm20
 18e0fd0:	62 e3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%eax
 18e0fd7:	62 e3 5d 00 20 e0 09 	vpinsrb $0x9,%eax,%xmm20,%xmm20
 18e0fde:	62 a3 7d 28 39 fd 01 	vextracti32x4 $0x1,%ymm23,%xmm21
 18e0fe5:	62 a3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm23,%xmm23
 18e0fec:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18e0ff2:	62 e1 7f c9 6f ac d1 32 07 00 00 	vmovdqu8 0x732(%rcx,%rdx,8),%zmm21{%k1}{z}
 18e0ffd:	62 e3 5d 00 20 e0 0a 	vpinsrb $0xa,%eax,%xmm20,%xmm20
 18e1004:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e100b:	62 a3 7d 48 39 df 03 	vextracti32x4 $0x3,%zmm19,%xmm23
 18e1012:	62 a3 7d 28 39 db 01 	vextracti32x4 $0x1,%ymm19,%xmm19
 18e1019:	62 e3 5d 00 20 e0 0b 	vpinsrb $0xb,%eax,%xmm20,%xmm20
 18e1020:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e1026:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18e102d:	62 e3 5d 00 20 e0 0c 	vpinsrb $0xc,%eax,%xmm20,%xmm20
 18e1034:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e103b:	62 e3 5d 00 20 e0 0d 	vpinsrb $0xd,%eax,%xmm20,%xmm20
 18e1042:	62 83 7d 48 39 e8 03 	vextracti32x4 $0x3,%zmm21,%xmm24
 18e1049:	62 a3 7d 28 39 ed 01 	vextracti32x4 $0x1,%ymm21,%xmm21
 18e1050:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18e1056:	62 e1 7f cb 6f ac d1 12 0f 00 00 	vmovdqu8 0xf12(%rcx,%rdx,8),%zmm21{%k3}{z}
 18e1061:	62 e3 5d 00 20 e0 0e 	vpinsrb $0xe,%eax,%xmm20,%xmm20
 18e1068:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e106f:	62 61 7f cb 6f 84 d1 32 12 00 00 	vmovdqu8 0x1232(%rcx,%rdx,8),%zmm24{%k3}{z}
 18e107a:	62 e3 5d 00 20 e0 0f 	vpinsrb $0xf,%eax,%xmm20,%xmm20
 18e1081:	62 e1 7d 08 7e d0    	vmovd  %xmm18,%eax
 18e1087:	62 a3 7d 48 39 d2 02 	vextracti32x4 $0x2,%zmm18,%xmm18
 18e108e:	62 e3 75 00 20 c8 04 	vpinsrb $0x4,%eax,%xmm17,%xmm17
 18e1095:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 18e109c:	62 a3 7d 48 39 c2 02 	vextracti32x4 $0x2,%zmm16,%xmm18
 18e10a3:	62 e3 75 00 20 c8 05 	vpinsrb $0x5,%eax,%xmm17,%xmm17
 18e10aa:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 18e10b0:	62 e1 7f cb 6f 9c d1 32 0d 00 00 	vmovdqu8 0xd32(%rcx,%rdx,8),%zmm19{%k3}{z}
 18e10bb:	62 e3 75 00 20 c8 06 	vpinsrb $0x6,%eax,%xmm17,%xmm17
 18e10c2:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e10c9:	62 e1 7f cb 6f bc d1 92 11 00 00 	vmovdqu8 0x1192(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e10d4:	62 e3 75 00 20 c8 07 	vpinsrb $0x7,%eax,%xmm17,%xmm17
 18e10db:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 18e10e1:	62 e3 75 00 20 c0 08 	vpinsrb $0x8,%eax,%xmm17,%xmm16
 18e10e8:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 18e10ef:	62 33 7d 28 39 f9 01 	vextracti32x4 $0x1,%ymm15,%xmm17
 18e10f6:	62 53 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm15,%xmm15
 18e10fd:	62 e1 7f cb 6f 94 d1 92 0c 00 00 	vmovdqu8 0xc92(%rcx,%rdx,8),%zmm18{%k3}{z}
 18e1108:	62 e3 7d 00 20 c0 09 	vpinsrb $0x9,%eax,%xmm16,%xmm16
 18e110f:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 18e1115:	62 33 7d 48 39 f1 02 	vextracti32x4 $0x2,%zmm14,%xmm17
 18e111c:	62 e3 7d 00 20 c0 0a 	vpinsrb $0xa,%eax,%xmm16,%xmm16
 18e1123:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 18e1129:	62 53 7d 48 39 ef 03 	vextracti32x4 $0x3,%zmm13,%xmm15
 18e1130:	c4 43 7d 39 ed 01    	vextracti128 $0x1,%ymm13,%xmm13
 18e1136:	62 e3 7d 00 20 c0 0b 	vpinsrb $0xb,%eax,%xmm16,%xmm16
 18e113d:	c5 79 7e f0          	vmovd  %xmm14,%eax
 18e1141:	62 73 7d 00 20 f0 0c 	vpinsrb $0xc,%eax,%xmm16,%xmm14
 18e1148:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 18e114f:	62 e1 7f cb 6f 8c d1 d2 0d 00 00 	vmovdqu8 0xdd2(%rcx,%rdx,8),%zmm17{%k3}{z}
 18e115a:	62 e1 7f c9 6f 84 d1 12 0e 00 00 	vmovdqu8 0xe12(%rcx,%rdx,8),%zmm16{%k1}{z}
 18e1165:	c4 63 09 20 f0 0d    	vpinsrb $0xd,%eax,%xmm14,%xmm14
 18e116b:	c5 79 7e e8          	vmovd  %xmm13,%eax
 18e116f:	c4 63 09 20 e8 0e    	vpinsrb $0xe,%eax,%xmm14,%xmm13
 18e1175:	62 33 5d 20 38 f6 01 	vinserti32x4 $0x1,%xmm22,%ymm20,%ymm14
 18e117c:	62 e1 7f c9 6f b4 d1 52 0f 00 00 	vmovdqu8 0xf52(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e1187:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 18e118d:	62 e1 7f c9 6f a4 d1 72 0d 00 00 	vmovdqu8 0xd72(%rcx,%rdx,8),%zmm20{%k1}{z}
 18e1198:	62 71 7f cb 6f bc d1 72 0e 00 00 	vmovdqu8 0xe72(%rcx,%rdx,8),%zmm15{%k3}{z}
 18e11a3:	c4 63 11 20 e8 0f    	vpinsrb $0xf,%eax,%xmm13,%xmm13
 18e11a9:	0f b6 84 d1 6a 02 00 00 	movzbl 0x26a(%rcx,%rdx,8),%eax
 18e11b1:	c4 63 19 20 e0 0f    	vpinsrb $0xf,%eax,%xmm12,%xmm12
 18e11b7:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e11bd:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18e11c4:	c4 43 1d 38 e5 01    	vinserti128 $0x1,%xmm13,%ymm12,%ymm12
 18e11ca:	62 71 7f cb 6f ac d1 12 0a 00 00 	vmovdqu8 0xa12(%rcx,%rdx,8),%zmm13{%k3}{z}
 18e11d5:	62 a2 7d 48 7d ee    	vpermt2b %zmm22,%zmm0,%zmm21
 18e11db:	62 e1 7f c9 6f b4 d1 d2 11 00 00 	vmovdqu8 0x11d2(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e11e6:	62 53 9d 48 3a e6 01 	vinserti64x4 $0x1,%ymm14,%zmm12,%zmm12
 18e11ed:	62 71 7f c9 6f b4 d1 52 0a 00 00 	vmovdqu8 0xa52(%rcx,%rdx,8),%zmm14{%k1}{z}
 18e11f8:	62 a2 7d 48 7d fe    	vpermt2b %zmm22,%zmm0,%zmm23
 18e11fe:	62 e1 7f c9 6f b4 d1 72 12 00 00 	vmovdqu8 0x1272(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e1209:	62 52 7d 48 7d ee    	vpermt2b %zmm14,%zmm0,%zmm13
 18e120f:	62 71 7f c9 6f b4 d1 d2 0c 00 00 	vmovdqu8 0xcd2(%rcx,%rdx,8),%zmm14{%k1}{z}
 18e121a:	62 e3 45 00 20 f8 04 	vpinsrb $0x4,%eax,%xmm23,%xmm23
 18e1221:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e1228:	c4 43 11 20 ed 04    	vpinsrb $0x4,%r13d,%xmm13,%xmm13
 18e122e:	44 0f b6 ac d1 b2 14 00 00 	movzbl 0x14b2(%rcx,%rdx,8),%r13d
 18e1237:	62 e3 45 00 20 f8 05 	vpinsrb $0x5,%eax,%xmm23,%xmm23
 18e123e:	c4 43 11 20 ec 05    	vpinsrb $0x5,%r12d,%xmm13,%xmm13
 18e1244:	44 0f b6 a4 d1 da 14 00 00 	movzbl 0x14da(%rcx,%rdx,8),%r12d
 18e124d:	c4 43 11 20 ef 06    	vpinsrb $0x6,%r15d,%xmm13,%xmm13
 18e1253:	44 0f b6 bc d1 02 15 00 00 	movzbl 0x1502(%rcx,%rdx,8),%r15d
 18e125c:	62 83 7d 48 39 f0 03 	vextracti32x4 $0x3,%zmm22,%xmm24
 18e1263:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 18e126a:	62 c2 7d 48 7d d6    	vpermt2b %zmm14,%zmm0,%zmm18
 18e1270:	62 71 7f c9 6f b4 d1 b2 0e 00 00 	vmovdqu8 0xeb2(%rcx,%rdx,8),%zmm14{%k1}{z}
 18e127b:	c4 43 11 20 ee 07    	vpinsrb $0x7,%r14d,%xmm13,%xmm13
 18e1281:	44 0f b6 b4 d1 2a 15 00 00 	movzbl 0x152a(%rcx,%rdx,8),%r14d
 18e128a:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 18e1290:	c4 63 11 20 eb 08    	vpinsrb $0x8,%ebx,%xmm13,%xmm13
 18e1296:	0f b6 9c d1 52 15 00 00 	movzbl 0x1552(%rcx,%rdx,8),%ebx
 18e129e:	62 e3 45 00 20 f0 06 	vpinsrb $0x6,%eax,%xmm23,%xmm22
 18e12a5:	62 e1 7f cb 6f bc d1 d2 12 00 00 	vmovdqu8 0x12d2(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e12b0:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e12b7:	62 61 7f c9 6f 84 d1 12 13 00 00 	vmovdqu8 0x1312(%rcx,%rdx,8),%zmm24{%k1}{z}
 18e12c2:	c4 43 11 20 eb 09    	vpinsrb $0x9,%r11d,%xmm13,%xmm13
 18e12c8:	44 0f b6 9c d1 7a 15 00 00 	movzbl 0x157a(%rcx,%rdx,8),%r11d
 18e12d1:	62 e3 4d 00 20 f0 07 	vpinsrb $0x7,%eax,%xmm22,%xmm22
 18e12d8:	c4 43 11 20 ea 0a    	vpinsrb $0xa,%r10d,%xmm13,%xmm13
 18e12de:	44 0f b6 94 d1 a2 15 00 00 	movzbl 0x15a2(%rcx,%rdx,8),%r10d
 18e12e7:	c4 43 11 20 e9 0b    	vpinsrb $0xb,%r9d,%xmm13,%xmm13
 18e12ed:	44 0f b6 8c d1 ca 15 00 00 	movzbl 0x15ca(%rcx,%rdx,8),%r9d
 18e12f6:	c4 43 11 20 e8 0c    	vpinsrb $0xc,%r8d,%xmm13,%xmm13
 18e12fc:	44 0f b6 84 d1 f2 15 00 00 	movzbl 0x15f2(%rcx,%rdx,8),%r8d
 18e1305:	c4 63 11 20 ef 0d    	vpinsrb $0xd,%edi,%xmm13,%xmm13
 18e130b:	0f b6 bc d1 1a 16 00 00 	movzbl 0x161a(%rcx,%rdx,8),%edi
 18e1313:	c4 63 11 20 ee 0e    	vpinsrb $0xe,%esi,%xmm13,%xmm13
 18e1319:	0f b6 b4 d1 42 16 00 00 	movzbl 0x1642(%rcx,%rdx,8),%esi
 18e1321:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e1327:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18e132e:	62 e3 4d 00 20 f0 08 	vpinsrb $0x8,%eax,%xmm22,%xmm22
 18e1335:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e133c:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 18e1343:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 18e134a:	62 e3 4d 00 20 f0 09 	vpinsrb $0x9,%eax,%xmm22,%xmm22
 18e1351:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e1357:	62 e1 7f cb 6f bc d1 72 13 00 00 	vmovdqu8 0x1372(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e1362:	62 e3 4d 00 20 f0 0a 	vpinsrb $0xa,%eax,%xmm22,%xmm22
 18e1369:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e1370:	62 61 7f c9 6f 84 d1 b2 13 00 00 	vmovdqu8 0x13b2(%rcx,%rdx,8),%zmm24{%k1}{z}
 18e137b:	62 e3 4d 00 20 f0 0b 	vpinsrb $0xb,%eax,%xmm22,%xmm22
 18e1382:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e1388:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18e138f:	62 e3 4d 00 20 f0 0c 	vpinsrb $0xc,%eax,%xmm22,%xmm22
 18e1396:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e139d:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 18e13a4:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 18e13ab:	62 e3 4d 00 20 f0 0d 	vpinsrb $0xd,%eax,%xmm22,%xmm22
 18e13b2:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e13b8:	62 e1 7f cb 6f bc d1 b2 0f 00 00 	vmovdqu8 0xfb2(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e13c3:	62 e3 4d 00 20 f0 0e 	vpinsrb $0xe,%eax,%xmm22,%xmm22
 18e13ca:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e13d1:	62 61 7f c9 6f 84 d1 f2 0f 00 00 	vmovdqu8 0xff2(%rcx,%rdx,8),%zmm24{%k1}{z}
 18e13dc:	62 e3 4d 00 20 f0 0f 	vpinsrb $0xf,%eax,%xmm22,%xmm22
 18e13e3:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e13e9:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18e13f0:	62 e3 55 00 20 e8 04 	vpinsrb $0x4,%eax,%xmm21,%xmm21
 18e13f7:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e13fe:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 18e1405:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 18e140c:	62 e3 55 00 20 e8 05 	vpinsrb $0x5,%eax,%xmm21,%xmm21
 18e1413:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e1419:	62 e1 7f cb 6f bc d1 52 10 00 00 	vmovdqu8 0x1052(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e1424:	62 e3 55 00 20 e8 06 	vpinsrb $0x6,%eax,%xmm21,%xmm21
 18e142b:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e1432:	62 e3 55 00 20 e8 07 	vpinsrb $0x7,%eax,%xmm21,%xmm21
 18e1439:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e143f:	62 83 7d 48 39 f8 02 	vextracti32x4 $0x2,%zmm23,%xmm24
 18e1446:	62 e1 7f c9 6f bc d1 92 10 00 00 	vmovdqu8 0x1092(%rcx,%rdx,8),%zmm23{%k1}{z}
 18e1451:	62 e3 55 00 20 e8 08 	vpinsrb $0x8,%eax,%xmm21,%xmm21
 18e1458:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e145f:	62 e3 55 00 20 e8 09 	vpinsrb $0x9,%eax,%xmm21,%xmm21
 18e1466:	62 83 7d 28 39 f8 01 	vextracti32x4 $0x1,%ymm23,%xmm24
 18e146d:	62 a3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm23,%xmm23
 18e1474:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e147a:	62 61 7f cb 6f 84 d1 f2 10 00 00 	vmovdqu8 0x10f2(%rcx,%rdx,8),%zmm24{%k3}{z}
 18e1485:	62 e3 55 00 20 e8 0a 	vpinsrb $0xa,%eax,%xmm21,%xmm21
 18e148c:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e1493:	62 e1 7f c9 6f bc d1 32 11 00 00 	vmovdqu8 0x1132(%rcx,%rdx,8),%zmm23{%k1}{z}
 18e149e:	62 e3 55 00 20 e8 0b 	vpinsrb $0xb,%eax,%xmm21,%xmm21
 18e14a5:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e14ab:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18e14b2:	62 e3 55 00 20 e8 0c 	vpinsrb $0xc,%eax,%xmm21,%xmm21
 18e14b9:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e14c0:	62 83 7d 28 39 f8 01 	vextracti32x4 $0x1,%ymm23,%xmm24
 18e14c7:	62 a3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm23,%xmm23
 18e14ce:	62 e3 55 00 20 e8 0d 	vpinsrb $0xd,%eax,%xmm21,%xmm21
 18e14d5:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e14db:	62 83 7d 48 39 e0 03 	vextracti32x4 $0x3,%zmm20,%xmm24
 18e14e2:	62 a3 7d 28 39 e4 01 	vextracti32x4 $0x1,%ymm20,%xmm20
 18e14e9:	62 e3 55 00 20 e8 0e 	vpinsrb $0xe,%eax,%xmm21,%xmm21
 18e14f0:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e14f7:	62 e1 7f cb 6f bc d1 92 1b 00 00 	vmovdqu8 0x1b92(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e1502:	62 e3 55 00 20 e8 0f 	vpinsrb $0xf,%eax,%xmm21,%xmm21
 18e1509:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 18e150f:	62 a3 7d 48 39 db 02 	vextracti32x4 $0x2,%zmm19,%xmm19
 18e1516:	62 e3 6d 00 20 d0 04 	vpinsrb $0x4,%eax,%xmm18,%xmm18
 18e151d:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 18e1524:	62 a3 7d 48 39 cb 02 	vextracti32x4 $0x2,%zmm17,%xmm19
 18e152b:	62 e3 6d 00 20 d0 05 	vpinsrb $0x5,%eax,%xmm18,%xmm18
 18e1532:	62 e1 7d 08 7e e0    	vmovd  %xmm20,%eax
 18e1538:	62 e1 7f c9 6f a4 d1 72 17 00 00 	vmovdqu8 0x1772(%rcx,%rdx,8),%zmm20{%k1}{z}
 18e1543:	62 e3 6d 00 20 d0 06 	vpinsrb $0x6,%eax,%xmm18,%xmm18
 18e154a:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e1551:	62 61 7f cb 6f 84 d1 32 1c 00 00 	vmovdqu8 0x1c32(%rcx,%rdx,8),%zmm24{%k3}{z}
 18e155c:	62 e3 6d 00 20 d0 07 	vpinsrb $0x7,%eax,%xmm18,%xmm18
 18e1563:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 18e1569:	62 e3 6d 00 20 c8 08 	vpinsrb $0x8,%eax,%xmm18,%xmm17
 18e1570:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 18e1577:	62 a3 7d 28 39 c2 01 	vextracti32x4 $0x1,%ymm16,%xmm18
 18e157e:	62 a3 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm16,%xmm16
 18e1585:	62 e1 7f cb 6f 9c d1 32 17 00 00 	vmovdqu8 0x1732(%rcx,%rdx,8),%zmm19{%k3}{z}
 18e1590:	62 e3 75 00 20 c8 09 	vpinsrb $0x9,%eax,%xmm17,%xmm17
 18e1597:	62 e1 7d 08 7e d0    	vmovd  %xmm18,%eax
 18e159d:	62 33 7d 48 39 fa 02 	vextracti32x4 $0x2,%zmm15,%xmm18
 18e15a4:	62 e3 75 00 20 c8 0a 	vpinsrb $0xa,%eax,%xmm17,%xmm17
 18e15ab:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18e15b2:	62 33 7d 48 39 f0 03 	vextracti32x4 $0x3,%zmm14,%xmm16
 18e15b9:	c4 43 7d 39 f6 01    	vextracti128 $0x1,%ymm14,%xmm14
 18e15bf:	62 e3 75 00 20 c8 0b 	vpinsrb $0xb,%eax,%xmm17,%xmm17
 18e15c6:	c5 79 7e f8          	vmovd  %xmm15,%eax
 18e15ca:	62 73 75 00 20 f8 0c 	vpinsrb $0xc,%eax,%xmm17,%xmm15
 18e15d1:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 18e15d8:	62 e1 7f cb 6f 94 d1 92 16 00 00 	vmovdqu8 0x1692(%rcx,%rdx,8),%zmm18{%k3}{z}
 18e15e3:	62 e1 7f cb 6f 8c d1 d2 17 00 00 	vmovdqu8 0x17d2(%rcx,%rdx,8),%zmm17{%k3}{z}
 18e15ee:	c4 63 01 20 f8 0d    	vpinsrb $0xd,%eax,%xmm15,%xmm15
 18e15f4:	c5 79 7e f0          	vmovd  %xmm14,%eax
 18e15f8:	c4 63 01 20 f0 0e    	vpinsrb $0xe,%eax,%xmm15,%xmm14
 18e15fe:	62 33 55 20 38 fe 01 	vinserti32x4 $0x1,%xmm22,%ymm21,%ymm15
 18e1605:	62 e1 7f c9 6f b4 d1 52 19 00 00 	vmovdqu8 0x1952(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e1610:	62 e1 7f cb 6f ac d1 12 19 00 00 	vmovdqu8 0x1912(%rcx,%rdx,8),%zmm21{%k3}{z}
 18e161b:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18e1622:	62 e1 7f c9 6f 84 d1 12 18 00 00 	vmovdqu8 0x1812(%rcx,%rdx,8),%zmm16{%k1}{z}
 18e162d:	c4 63 09 20 f0 0f    	vpinsrb $0xf,%eax,%xmm14,%xmm14
 18e1633:	0f b6 84 d1 6a 0c 00 00 	movzbl 0xc6a(%rcx,%rdx,8),%eax
 18e163b:	c4 63 11 20 e8 0f    	vpinsrb $0xf,%eax,%xmm13,%xmm13
 18e1641:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e1647:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18e164e:	c4 43 15 38 ee 01    	vinserti128 $0x1,%xmm14,%ymm13,%ymm13
 18e1654:	62 71 7f cb 6f b4 d1 12 14 00 00 	vmovdqu8 0x1412(%rcx,%rdx,8),%zmm14{%k3}{z}
 18e165f:	62 a2 7d 48 7d ee    	vpermt2b %zmm22,%zmm0,%zmm21
 18e1665:	62 e1 7f c9 6f b4 d1 d2 1b 00 00 	vmovdqu8 0x1bd2(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e1670:	62 53 95 48 3a ef 01 	vinserti64x4 $0x1,%ymm15,%zmm13,%zmm13
 18e1677:	62 71 7f c9 6f bc d1 52 14 00 00 	vmovdqu8 0x1452(%rcx,%rdx,8),%zmm15{%k1}{z}
 18e1682:	62 a2 7d 48 7d fe    	vpermt2b %zmm22,%zmm0,%zmm23
 18e1688:	62 e1 7f c9 6f b4 d1 72 1c 00 00 	vmovdqu8 0x1c72(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e1693:	62 52 7d 48 7d f7    	vpermt2b %zmm15,%zmm0,%zmm14
 18e1699:	62 71 7f c9 6f bc d1 d2 16 00 00 	vmovdqu8 0x16d2(%rcx,%rdx,8),%zmm15{%k1}{z}
 18e16a4:	62 e3 45 00 20 f8 04 	vpinsrb $0x4,%eax,%xmm23,%xmm23
 18e16ab:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e16b2:	c4 43 09 20 f5 04    	vpinsrb $0x4,%r13d,%xmm14,%xmm14
 18e16b8:	62 e3 45 00 20 f8 05 	vpinsrb $0x5,%eax,%xmm23,%xmm23
 18e16bf:	c4 43 09 20 f4 05    	vpinsrb $0x5,%r12d,%xmm14,%xmm14
 18e16c5:	c4 43 09 20 f7 06    	vpinsrb $0x6,%r15d,%xmm14,%xmm14
 18e16cb:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 18e16d2:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 18e16d9:	62 c2 7d 48 7d d7    	vpermt2b %zmm15,%zmm0,%zmm18
 18e16df:	62 71 7f cb 6f bc d1 72 18 00 00 	vmovdqu8 0x1872(%rcx,%rdx,8),%zmm15{%k3}{z}
 18e16ea:	c4 43 09 20 f6 07    	vpinsrb $0x7,%r14d,%xmm14,%xmm14
 18e16f0:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e16f6:	62 61 7f cb 6f 84 d1 d2 1c 00 00 	vmovdqu8 0x1cd2(%rcx,%rdx,8),%zmm24{%k3}{z}
 18e1701:	c4 63 09 20 f3 08    	vpinsrb $0x8,%ebx,%xmm14,%xmm14
 18e1707:	62 e3 45 00 20 f8 06 	vpinsrb $0x6,%eax,%xmm23,%xmm23
 18e170e:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18e1715:	62 e1 7f c9 6f b4 d1 12 1d 00 00 	vmovdqu8 0x1d12(%rcx,%rdx,8),%zmm22{%k1}{z}
 18e1720:	c4 43 09 20 f3 09    	vpinsrb $0x9,%r11d,%xmm14,%xmm14
 18e1726:	62 e3 45 00 20 f8 07 	vpinsrb $0x7,%eax,%xmm23,%xmm23
 18e172d:	c4 43 09 20 f2 0a    	vpinsrb $0xa,%r10d,%xmm14,%xmm14
 18e1733:	c4 43 09 20 f1 0b    	vpinsrb $0xb,%r9d,%xmm14,%xmm14
 18e1739:	c4 43 09 20 f0 0c    	vpinsrb $0xc,%r8d,%xmm14,%xmm14
 18e173f:	c4 63 09 20 f7 0d    	vpinsrb $0xd,%edi,%xmm14,%xmm14
 18e1745:	c4 63 09 20 f6 0e    	vpinsrb $0xe,%esi,%xmm14,%xmm14
 18e174b:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e1751:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18e1758:	62 e3 45 00 20 f8 08 	vpinsrb $0x8,%eax,%xmm23,%xmm23
 18e175f:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e1766:	62 83 7d 48 39 f0 03 	vextracti32x4 $0x3,%zmm22,%xmm24
 18e176d:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 18e1774:	62 e3 45 00 20 f8 09 	vpinsrb $0x9,%eax,%xmm23,%xmm23
 18e177b:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 18e1781:	62 e3 45 00 20 f0 0a 	vpinsrb $0xa,%eax,%xmm23,%xmm22
 18e1788:	62 e1 7f cb 6f bc d1 72 1d 00 00 	vmovdqu8 0x1d72(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e1793:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e179a:	62 61 7f c9 6f 84 d1 b2 1d 00 00 	vmovdqu8 0x1db2(%rcx,%rdx,8),%zmm24{%k1}{z}
 18e17a5:	62 e3 4d 00 20 f0 0b 	vpinsrb $0xb,%eax,%xmm22,%xmm22
 18e17ac:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e17b2:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18e17b9:	62 e3 4d 00 20 f0 0c 	vpinsrb $0xc,%eax,%xmm22,%xmm22
 18e17c0:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e17c7:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 18e17ce:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 18e17d5:	62 e3 4d 00 20 f0 0d 	vpinsrb $0xd,%eax,%xmm22,%xmm22
 18e17dc:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e17e2:	62 e1 7f cb 6f bc d1 b2 19 00 00 	vmovdqu8 0x19b2(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e17ed:	62 e3 4d 00 20 f0 0e 	vpinsrb $0xe,%eax,%xmm22,%xmm22
 18e17f4:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e17fb:	62 61 7f c9 6f 84 d1 f2 19 00 00 	vmovdqu8 0x19f2(%rcx,%rdx,8),%zmm24{%k1}{z}
 18e1806:	62 e3 4d 00 20 f0 0f 	vpinsrb $0xf,%eax,%xmm22,%xmm22
 18e180d:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e1813:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18e181a:	62 e3 55 00 20 e8 04 	vpinsrb $0x4,%eax,%xmm21,%xmm21
 18e1821:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e1828:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 18e182f:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 18e1836:	62 e3 55 00 20 e8 05 	vpinsrb $0x5,%eax,%xmm21,%xmm21
 18e183d:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e1843:	62 e1 7f cb 6f bc d1 52 1a 00 00 	vmovdqu8 0x1a52(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e184e:	62 e3 55 00 20 e8 06 	vpinsrb $0x6,%eax,%xmm21,%xmm21
 18e1855:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e185c:	62 61 7f c9 6f 84 d1 92 1a 00 00 	vmovdqu8 0x1a92(%rcx,%rdx,8),%zmm24{%k1}{z}
 18e1867:	62 e3 55 00 20 e8 07 	vpinsrb $0x7,%eax,%xmm21,%xmm21
 18e186e:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e1874:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18e187b:	62 e3 55 00 20 e8 08 	vpinsrb $0x8,%eax,%xmm21,%xmm21
 18e1882:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e1889:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 18e1890:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 18e1897:	62 e3 55 00 20 e8 09 	vpinsrb $0x9,%eax,%xmm21,%xmm21
 18e189e:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e18a4:	62 e1 7f cb 6f bc d1 f2 1a 00 00 	vmovdqu8 0x1af2(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e18af:	62 e3 55 00 20 e8 0a 	vpinsrb $0xa,%eax,%xmm21,%xmm21
 18e18b6:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e18bd:	62 e3 55 00 20 e8 0b 	vpinsrb $0xb,%eax,%xmm21,%xmm21
 18e18c4:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e18ca:	62 83 7d 48 39 f8 02 	vextracti32x4 $0x2,%zmm23,%xmm24
 18e18d1:	62 e1 7f c9 6f bc d1 32 1b 00 00 	vmovdqu8 0x1b32(%rcx,%rdx,8),%zmm23{%k1}{z}
 18e18dc:	62 e3 55 00 20 e8 0c 	vpinsrb $0xc,%eax,%xmm21,%xmm21
 18e18e3:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e18ea:	62 e3 55 00 20 e8 0d 	vpinsrb $0xd,%eax,%xmm21,%xmm21
 18e18f1:	62 83 7d 28 39 f8 01 	vextracti32x4 $0x1,%ymm23,%xmm24
 18e18f8:	62 a3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm23,%xmm23
 18e18ff:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e1905:	62 61 7f c9 6f 84 d1 b2 18 00 00 	vmovdqu8 0x18b2(%rcx,%rdx,8),%zmm24{%k1}{z}
 18e1910:	62 e3 55 00 20 e8 0e 	vpinsrb $0xe,%eax,%xmm21,%xmm21
 18e1917:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e191e:	62 a3 7d 48 39 e7 03 	vextracti32x4 $0x3,%zmm20,%xmm23
 18e1925:	62 a3 7d 28 39 e4 01 	vextracti32x4 $0x1,%ymm20,%xmm20
 18e192c:	62 e3 55 00 20 e8 0f 	vpinsrb $0xf,%eax,%xmm21,%xmm21
 18e1933:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 18e1939:	62 a3 7d 48 39 db 02 	vextracti32x4 $0x2,%zmm19,%xmm19
 18e1940:	62 e3 6d 00 20 d0 04 	vpinsrb $0x4,%eax,%xmm18,%xmm18
 18e1947:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 18e194e:	62 a3 7d 48 39 cb 02 	vextracti32x4 $0x2,%zmm17,%xmm19
 18e1955:	62 e3 6d 00 20 d0 05 	vpinsrb $0x5,%eax,%xmm18,%xmm18
 18e195c:	62 e1 7d 08 7e e0    	vmovd  %xmm20,%eax
 18e1962:	62 e1 7f c9 6f a4 d1 52 23 00 00 	vmovdqu8 0x2352(%rcx,%rdx,8),%zmm20{%k1}{z}
 18e196d:	62 e3 6d 00 20 d0 06 	vpinsrb $0x6,%eax,%xmm18,%xmm18
 18e1974:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e197b:	62 e1 7f cb 6f bc d1 32 21 00 00 	vmovdqu8 0x2132(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e1986:	62 e3 6d 00 20 d0 07 	vpinsrb $0x7,%eax,%xmm18,%xmm18
 18e198d:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 18e1993:	62 e3 6d 00 20 c8 08 	vpinsrb $0x8,%eax,%xmm18,%xmm17
 18e199a:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 18e19a1:	62 a3 7d 28 39 c2 01 	vextracti32x4 $0x1,%ymm16,%xmm18
 18e19a8:	62 a3 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm16,%xmm16
 18e19af:	62 e1 7f cb 6f 9c d1 d2 21 00 00 	vmovdqu8 0x21d2(%rcx,%rdx,8),%zmm19{%k3}{z}
 18e19ba:	62 e3 75 00 20 c8 09 	vpinsrb $0x9,%eax,%xmm17,%xmm17
 18e19c1:	62 e1 7d 08 7e d0    	vmovd  %xmm18,%eax
 18e19c7:	62 33 7d 48 39 fa 02 	vextracti32x4 $0x2,%zmm15,%xmm18
 18e19ce:	62 e3 75 00 20 c8 0a 	vpinsrb $0xa,%eax,%xmm17,%xmm17
 18e19d5:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18e19dc:	62 23 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm16
 18e19e3:	62 e3 75 00 20 c8 0b 	vpinsrb $0xb,%eax,%xmm17,%xmm17
 18e19ea:	c5 79 7e f8          	vmovd  %xmm15,%eax
 18e19ee:	62 73 75 00 20 f8 0c 	vpinsrb $0xc,%eax,%xmm17,%xmm15
 18e19f5:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 18e19fc:	62 23 7d 28 39 c1 01 	vextracti32x4 $0x1,%ymm24,%xmm17
 18e1a03:	62 e1 7f cb 6f 94 d1 12 23 00 00 	vmovdqu8 0x2312(%rcx,%rdx,8),%zmm18{%k3}{z}
 18e1a0e:	62 61 7f c9 6f 84 d1 12 22 00 00 	vmovdqu8 0x2212(%rcx,%rdx,8),%zmm24{%k1}{z}
 18e1a19:	c4 63 01 20 f8 0d    	vpinsrb $0xd,%eax,%xmm15,%xmm15
 18e1a1f:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 18e1a25:	62 e1 7f c9 6f 8c d1 d2 20 00 00 	vmovdqu8 0x20d2(%rcx,%rdx,8),%zmm17{%k1}{z}
 18e1a30:	c4 63 01 20 f8 0e    	vpinsrb $0xe,%eax,%xmm15,%xmm15
 18e1a36:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18e1a3d:	62 a3 55 20 38 c6 01 	vinserti32x4 $0x1,%xmm22,%ymm21,%ymm16
 18e1a44:	62 e1 7f c9 6f ac d1 72 21 00 00 	vmovdqu8 0x2172(%rcx,%rdx,8),%zmm21{%k1}{z}
 18e1a4f:	62 e1 7f cb 6f b4 d1 92 25 00 00 	vmovdqu8 0x2592(%rcx,%rdx,8),%zmm22{%k3}{z}
 18e1a5a:	62 c1 7d 08 7e fa    	vmovd  %xmm23,%r10d
 18e1a60:	c4 63 01 20 f8 0f    	vpinsrb $0xf,%eax,%xmm15,%xmm15
 18e1a66:	0f b6 84 d1 6a 16 00 00 	movzbl 0x166a(%rcx,%rdx,8),%eax
 18e1a6e:	c4 63 09 20 f0 0f    	vpinsrb $0xf,%eax,%xmm14,%xmm14
 18e1a74:	62 a2 7d 48 7d d4    	vpermt2b %zmm20,%zmm0,%zmm18
 18e1a7a:	62 e1 7f c9 6f a4 d1 d2 25 00 00 	vmovdqu8 0x25d2(%rcx,%rdx,8),%zmm20{%k1}{z}
 18e1a85:	c4 43 0d 38 f7 01    	vinserti128 $0x1,%xmm15,%ymm14,%ymm14
 18e1a8b:	62 71 7f cb 6f bc d1 12 1e 00 00 	vmovdqu8 0x1e12(%rcx,%rdx,8),%zmm15{%k3}{z}
 18e1a96:	62 33 8d 48 3a f0 01 	vinserti64x4 $0x1,%ymm16,%zmm14,%zmm14
 18e1a9d:	62 e1 7f c9 6f 84 d1 52 1e 00 00 	vmovdqu8 0x1e52(%rcx,%rdx,8),%zmm16{%k1}{z}
 18e1aa8:	62 a2 7d 48 7d f4    	vpermt2b %zmm20,%zmm0,%zmm22
 18e1aae:	62 a3 7d 48 39 ec 03 	vextracti32x4 $0x3,%zmm21,%xmm20
 18e1ab5:	62 a3 7d 28 39 ed 01 	vextracti32x4 $0x1,%ymm21,%xmm21
 18e1abc:	62 e3 7d 08 14 e6 08 	vpextrb $0x8,%xmm20,%esi
 18e1ac3:	62 e1 7f c9 6f a4 d1 b2 22 00 00 	vmovdqu8 0x22b2(%rcx,%rdx,8),%zmm20{%k1}{z}
 18e1ace:	62 e1 7d 08 7e ef    	vmovd  %xmm21,%edi
 18e1ad4:	62 a3 7d 48 39 fd 02 	vextracti32x4 $0x2,%zmm23,%xmm21
 18e1adb:	62 23 7d 48 39 c7 03 	vextracti32x4 $0x3,%zmm24,%xmm23
 18e1ae2:	62 03 7d 28 39 c0 01 	vextracti32x4 $0x1,%ymm24,%xmm24
 18e1ae9:	62 32 7d 48 7d f8    	vpermt2b %zmm16,%zmm0,%zmm15
 18e1aef:	62 e1 7f cb 6f 84 d1 92 20 00 00 	vmovdqu8 0x2092(%rcx,%rdx,8),%zmm16{%k3}{z}
 18e1afa:	62 41 7d 08 7e c3    	vmovd  %xmm24,%r11d
 18e1b00:	62 83 7d 48 39 d8 02 	vextracti32x4 $0x2,%zmm19,%xmm24
 18e1b07:	62 c3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%r8d
 18e1b0e:	62 e1 7f c9 6f bc d1 72 26 00 00 	vmovdqu8 0x2672(%rcx,%rdx,8),%zmm23{%k1}{z}
 18e1b19:	62 c3 7d 08 14 e9 08 	vpextrb $0x8,%xmm21,%r9d
 18e1b20:	62 e1 7f c9 6f ac d1 f2 23 00 00 	vmovdqu8 0x23f2(%rcx,%rdx,8),%zmm21{%k1}{z}
 18e1b2b:	62 43 7d 08 14 c6 08 	vpextrb $0x8,%xmm24,%r14d
 18e1b32:	62 83 7d 48 39 e0 03 	vextracti32x4 $0x3,%zmm20,%xmm24
 18e1b39:	62 a3 7d 28 39 e4 01 	vextracti32x4 $0x1,%ymm20,%xmm20
 18e1b40:	62 a2 7d 48 7d c1    	vpermt2b %zmm17,%zmm0,%zmm16
 18e1b46:	62 e1 7f cb 6f 8c d1 72 22 00 00 	vmovdqu8 0x2272(%rcx,%rdx,8),%zmm17{%k3}{z}
 18e1b51:	62 63 7d 08 14 c3 08 	vpextrb $0x8,%xmm24,%ebx
 18e1b58:	62 83 7d 48 39 f9 03 	vextracti32x4 $0x3,%zmm23,%xmm25
 18e1b5f:	62 a3 7d 28 39 ff 01 	vextracti32x4 $0x1,%ymm23,%xmm23
 18e1b66:	62 83 7d 48 39 ea 03 	vextracti32x4 $0x3,%zmm21,%xmm26
 18e1b6d:	62 63 7d 08 14 c8 08 	vpextrb $0x8,%xmm25,%eax
 18e1b74:	62 43 7d 08 14 d4 08 	vpextrb $0x8,%xmm26,%r12d
 18e1b7b:	62 c3 7d 00 20 c2 04 	vpinsrb $0x4,%r10d,%xmm16,%xmm16
 18e1b82:	62 c3 7d 00 20 c1 05 	vpinsrb $0x5,%r9d,%xmm16,%xmm16
 18e1b89:	62 e3 7d 00 20 c7 06 	vpinsrb $0x6,%edi,%xmm16,%xmm16
 18e1b90:	62 83 7d 48 39 c8 02 	vextracti32x4 $0x2,%zmm17,%xmm24
 18e1b97:	62 e3 7d 00 20 c6 07 	vpinsrb $0x7,%esi,%xmm16,%xmm16
 18e1b9e:	62 43 7d 08 14 c7 08 	vpextrb $0x8,%xmm24,%r15d
 18e1ba5:	62 61 7f cb 6f 84 d1 32 26 00 00 	vmovdqu8 0x2632(%rcx,%rdx,8),%zmm24{%k3}{z}
 18e1bb0:	62 41 7d 08 7e c5    	vmovd  %xmm24,%r13d
 18e1bb6:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18e1bbd:	62 c3 4d 00 20 f5 04 	vpinsrb $0x4,%r13d,%xmm22,%xmm22
 18e1bc4:	62 43 7d 08 14 c5 08 	vpextrb $0x8,%xmm24,%r13d
 18e1bcb:	62 61 7f c9 6f 84 d1 12 27 00 00 	vmovdqu8 0x2712(%rcx,%rdx,8),%zmm24{%k1}{z}
 18e1bd6:	62 c3 4d 00 20 f5 05 	vpinsrb $0x5,%r13d,%xmm22,%xmm22
 18e1bdd:	62 c1 7d 08 7e fd    	vmovd  %xmm23,%r13d
 18e1be3:	62 c3 4d 00 20 f5 06 	vpinsrb $0x6,%r13d,%xmm22,%xmm22
 18e1bea:	62 e3 4d 00 20 f0 07 	vpinsrb $0x7,%eax,%xmm22,%xmm22
 18e1bf1:	62 23 7d 48 39 c7 03 	vextracti32x4 $0x3,%zmm24,%xmm23
 18e1bf8:	62 03 7d 28 39 c0 01 	vextracti32x4 $0x1,%ymm24,%xmm24
 18e1bff:	62 c3 7d 08 14 fd 08 	vpextrb $0x8,%xmm23,%r13d
 18e1c06:	62 e1 7f cb 6f bc d1 d2 26 00 00 	vmovdqu8 0x26d2(%rcx,%rdx,8),%zmm23{%k3}{z}
 18e1c11:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18e1c17:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18e1c1e:	62 e3 4d 00 20 f0 08 	vpinsrb $0x8,%eax,%xmm22,%xmm22
 18e1c25:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18e1c2c:	62 e1 7f c9 6f bc d1 b2 27 00 00 	vmovdqu8 0x27b2(%rcx,%rdx,8),%zmm23{%k1}{z}
 18e1c37:	62 e3 4d 00 20 f0 09 	vpinsrb $0x9,%eax,%xmm22,%xmm22
 18e1c3e:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18e1c44:	62 e3 4d 00 20 f0 0a 	vpinsrb $0xa,%eax,%xmm22,%xmm22
 18e1c4b:	62 c3 4d 00 20 f5 0b 	vpinsrb $0xb,%r13d,%xmm22,%xmm22
 18e1c52:	62 83 7d 48 39 f8 03 	vextracti32x4 $0x3,%zmm23,%xmm24
 18e1c59:	62 a3 7d 28 39 ff 01 	vextracti32x4 $0x1,%ymm23,%xmm23
 18e1c60:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18e1c67:	62 61 7f cb 6f 84 d1 72 27 00 00 	vmovdqu8 0x2772(%rcx,%rdx,8),%zmm24{%k3}{z}
 18e1c72:	62 41 7d 08 7e c5    	vmovd  %xmm24,%r13d
 18e1c78:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18e1c7f:	62 c3 4d 00 20 f5 0c 	vpinsrb $0xc,%r13d,%xmm22,%xmm22
 18e1c86:	62 43 7d 08 14 c5 08 	vpextrb $0x8,%xmm24,%r13d
 18e1c8d:	62 c3 4d 00 20 f5 0d 	vpinsrb $0xd,%r13d,%xmm22,%xmm22
 18e1c94:	62 c1 7d 08 7e fd    	vmovd  %xmm23,%r13d
 18e1c9a:	62 c3 4d 00 20 f5 0e 	vpinsrb $0xe,%r13d,%xmm22,%xmm22
 18e1ca1:	62 c1 7d 08 7e dd    	vmovd  %xmm19,%r13d
 18e1ca7:	62 e1 7f cb 6f 9c d1 b2 23 00 00 	vmovdqu8 0x23b2(%rcx,%rdx,8),%zmm19{%k3}{z}
 18e1cb2:	62 e3 4d 00 20 f0 0f 	vpinsrb $0xf,%eax,%xmm22,%xmm22
 18e1cb9:	62 c3 7d 00 20 c5 08 	vpinsrb $0x8,%r13d,%xmm16,%xmm16
 18e1cc0:	62 c3 7d 00 20 c6 09 	vpinsrb $0x9,%r14d,%xmm16,%xmm16
 18e1cc7:	62 c3 7d 00 20 c3 0a 	vpinsrb $0xa,%r11d,%xmm16,%xmm16
 18e1cce:	62 c3 7d 00 20 c0 0b 	vpinsrb $0xb,%r8d,%xmm16,%xmm16
 18e1cd5:	4c 8d 05 64 04 81 0d 	lea    0xd810464(%rip),%r8        # f0f2140 <tier0_choice_shapes>
 18e1cdc:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 18e1ce2:	62 a3 7d 48 39 db 02 	vextracti32x4 $0x2,%zmm19,%xmm19
 18e1ce9:	62 e3 6d 00 20 d0 04 	vpinsrb $0x4,%eax,%xmm18,%xmm18
 18e1cf0:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 18e1cf7:	62 a3 7d 28 39 eb 01 	vextracti32x4 $0x1,%ymm21,%xmm19
 18e1cfe:	62 e3 6d 00 20 d0 05 	vpinsrb $0x5,%eax,%xmm18,%xmm18
 18e1d05:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 18e1d0b:	62 e1 7f cb 6f 9c d1 52 24 00 00 	vmovdqu8 0x2452(%rcx,%rdx,8),%zmm19{%k3}{z}
 18e1d16:	62 e3 6d 00 20 d0 06 	vpinsrb $0x6,%eax,%xmm18,%xmm18
 18e1d1d:	62 e1 7d 08 7e e0    	vmovd  %xmm20,%eax
 18e1d23:	62 e1 7f c9 6f a4 d1 92 24 00 00 	vmovdqu8 0x2492(%rcx,%rdx,8),%zmm20{%k1}{z}
 18e1d2e:	62 c3 6d 00 20 d4 07 	vpinsrb $0x7,%r12d,%xmm18,%xmm18
 18e1d35:	62 c1 7d 08 7e dc    	vmovd  %xmm19,%r12d
 18e1d3b:	62 a3 7d 48 39 db 02 	vextracti32x4 $0x2,%zmm19,%xmm19
 18e1d42:	62 c3 6d 00 20 d4 08 	vpinsrb $0x8,%r12d,%xmm18,%xmm18
 18e1d49:	62 c3 7d 08 14 dc 08 	vpextrb $0x8,%xmm19,%r12d
 18e1d50:	62 a3 7d 28 39 e3 01 	vextracti32x4 $0x1,%ymm20,%xmm19
 18e1d57:	62 a3 7d 48 39 e4 03 	vextracti32x4 $0x3,%zmm20,%xmm20
 18e1d5e:	62 c3 6d 00 20 d4 09 	vpinsrb $0x9,%r12d,%xmm18,%xmm18
 18e1d65:	62 c1 7d 08 7e dc    	vmovd  %xmm19,%r12d
 18e1d6b:	62 e1 7f cb 6f 9c d1 f2 24 00 00 	vmovdqu8 0x24f2(%rcx,%rdx,8),%zmm19{%k3}{z}
 18e1d76:	62 c3 6d 00 20 d4 0a 	vpinsrb $0xa,%r12d,%xmm18,%xmm18
 18e1d7d:	62 c3 7d 08 14 e4 08 	vpextrb $0x8,%xmm20,%r12d
 18e1d84:	62 e1 7f c9 6f a4 d1 32 25 00 00 	vmovdqu8 0x2532(%rcx,%rdx,8),%zmm20{%k1}{z}
 18e1d8f:	62 f1 3d 48 74 ce    	vpcmpeqb %zmm6,%zmm8,%k1
 18e1d95:	62 c3 6d 00 20 d4 0b 	vpinsrb $0xb,%r12d,%xmm18,%xmm18
 18e1d9c:	62 c1 7d 08 7e dc    	vmovd  %xmm19,%r12d
 18e1da2:	62 a3 7d 48 39 db 02 	vextracti32x4 $0x2,%zmm19,%xmm19
 18e1da9:	62 c3 6d 00 20 d4 0c 	vpinsrb $0xc,%r12d,%xmm18,%xmm18
 18e1db0:	62 c3 7d 08 14 dc 08 	vpextrb $0x8,%xmm19,%r12d
 18e1db7:	62 a3 7d 28 39 e3 01 	vextracti32x4 $0x1,%ymm20,%xmm19
 18e1dbe:	62 c3 6d 00 20 d4 0d 	vpinsrb $0xd,%r12d,%xmm18,%xmm18
 18e1dc5:	62 c1 7d 08 7e dc    	vmovd  %xmm19,%r12d
 18e1dcb:	62 a3 7d 48 39 e3 03 	vextracti32x4 $0x3,%zmm20,%xmm19
 18e1dd2:	62 e1 9d 48 db e2    	vpandq %zmm2,%zmm12,%zmm20
 18e1dd8:	62 c3 6d 00 20 d4 0e 	vpinsrb $0xe,%r12d,%xmm18,%xmm18
 18e1ddf:	62 c3 7d 08 14 dc 08 	vpextrb $0x8,%xmm19,%r12d
 18e1de6:	62 71 dd 40 eb c7    	vporq  %zmm7,%zmm20,%zmm8
 18e1dec:	62 c3 6d 00 20 d4 0f 	vpinsrb $0xf,%r12d,%xmm18,%xmm18
 18e1df3:	62 c1 7d 08 7e cc    	vmovd  %xmm17,%r12d
 18e1df9:	62 c1 7f 49 6f e0    	vmovdqu8 %zmm8,%zmm20{%k1}
 18e1dff:	62 71 8d 48 db c2    	vpandq %zmm2,%zmm14,%zmm8
 18e1e05:	62 f1 35 48 74 cb    	vpcmpeqb %zmm3,%zmm9,%k1
 18e1e0b:	62 c3 7d 00 20 c4 0c 	vpinsrb $0xc,%r12d,%xmm16,%xmm16
 18e1e12:	62 a3 6d 20 38 ce 01 	vinserti32x4 $0x1,%xmm22,%ymm18,%ymm17
 18e1e19:	62 e1 bd 48 eb d7    	vporq  %zmm7,%zmm8,%zmm18
 18e1e1f:	c4 e1 f4 45 e4       	korq   %k4,%k1,%k4
 18e1e24:	62 c3 7d 00 20 c7 0d 	vpinsrb $0xd,%r15d,%xmm16,%xmm16
 18e1e2b:	62 e3 7d 00 20 c0 0e 	vpinsrb $0xe,%eax,%xmm16,%xmm16
 18e1e32:	0f b6 84 d1 b2 1e 00 00 	movzbl 0x1eb2(%rcx,%rdx,8),%eax
 18e1e3a:	62 e3 7d 00 20 c3 0f 	vpinsrb $0xf,%ebx,%xmm16,%xmm16
 18e1e41:	c4 63 01 20 f8 04    	vpinsrb $0x4,%eax,%xmm15,%xmm15
 18e1e47:	0f b6 84 d1 da 1e 00 00 	movzbl 0x1eda(%rcx,%rdx,8),%eax
 18e1e4f:	c4 63 01 20 f8 05    	vpinsrb $0x5,%eax,%xmm15,%xmm15
 18e1e55:	0f b6 84 d1 02 1f 00 00 	movzbl 0x1f02(%rcx,%rdx,8),%eax
 18e1e5d:	c4 63 01 20 f8 06    	vpinsrb $0x6,%eax,%xmm15,%xmm15
 18e1e63:	0f b6 84 d1 2a 1f 00 00 	movzbl 0x1f2a(%rcx,%rdx,8),%eax
 18e1e6b:	c4 63 01 20 f8 07    	vpinsrb $0x7,%eax,%xmm15,%xmm15
 18e1e71:	0f b6 84 d1 52 1f 00 00 	movzbl 0x1f52(%rcx,%rdx,8),%eax
 18e1e79:	c4 63 01 20 f8 08    	vpinsrb $0x8,%eax,%xmm15,%xmm15
 18e1e7f:	0f b6 84 d1 7a 1f 00 00 	movzbl 0x1f7a(%rcx,%rdx,8),%eax
 18e1e87:	c4 63 01 20 f8 09    	vpinsrb $0x9,%eax,%xmm15,%xmm15
 18e1e8d:	0f b6 84 d1 a2 1f 00 00 	movzbl 0x1fa2(%rcx,%rdx,8),%eax
 18e1e95:	c4 63 01 20 f8 0a    	vpinsrb $0xa,%eax,%xmm15,%xmm15
 18e1e9b:	0f b6 84 d1 ca 1f 00 00 	movzbl 0x1fca(%rcx,%rdx,8),%eax
 18e1ea3:	c4 63 01 20 f8 0b    	vpinsrb $0xb,%eax,%xmm15,%xmm15
 18e1ea9:	0f b6 84 d1 f2 1f 00 00 	movzbl 0x1ff2(%rcx,%rdx,8),%eax
 18e1eb1:	c4 63 01 20 f8 0c    	vpinsrb $0xc,%eax,%xmm15,%xmm15
 18e1eb7:	0f b6 84 d1 1a 20 00 00 	movzbl 0x201a(%rcx,%rdx,8),%eax
 18e1ebf:	c4 63 01 20 f8 0d    	vpinsrb $0xd,%eax,%xmm15,%xmm15
 18e1ec5:	0f b6 84 d1 42 20 00 00 	movzbl 0x2042(%rcx,%rdx,8),%eax
 18e1ecd:	c4 63 01 20 f8 0e    	vpinsrb $0xe,%eax,%xmm15,%xmm15
 18e1ed3:	0f b6 84 d1 6a 20 00 00 	movzbl 0x206a(%rcx,%rdx,8),%eax
 18e1edb:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 18e1ee0:	c4 63 01 20 f8 0f    	vpinsrb $0xf,%eax,%xmm15,%xmm15
 18e1ee6:	62 33 05 28 38 f8 01 	vinserti32x4 $0x1,%xmm16,%ymm15,%ymm15
 18e1eed:	62 33 85 48 3a f9 01 	vinserti64x4 $0x1,%ymm17,%zmm15,%zmm15
 18e1ef4:	62 e1 95 48 db ca    	vpandq %zmm2,%zmm13,%zmm17
 18e1efa:	62 e1 f5 40 eb df    	vporq  %zmm7,%zmm17,%zmm19
 18e1f00:	62 f3 05 4a 3e d1 01 	vpcmpltub %zmm1,%zmm15,%k2{%k2}
 18e1f07:	62 a1 7f 4d 6f cb    	vmovdqu8 %zmm19,%zmm17{%k5}
 18e1f0d:	62 f1 2d 48 74 ee    	vpcmpeqb %zmm6,%zmm10,%k5
 18e1f13:	62 e1 85 48 db da    	vpandq %zmm2,%zmm15,%zmm19
 18e1f19:	62 31 7f 4d 6f c2    	vmovdqu8 %zmm18,%zmm8{%k5}
 18e1f1f:	62 f1 2d 48 74 eb    	vpcmpeqb %zmm3,%zmm10,%k5
 18e1f25:	62 e1 f5 40 eb d5    	vporq  %zmm5,%zmm17,%zmm18
 18e1f2b:	62 71 e5 40 eb d7    	vporq  %zmm7,%zmm19,%zmm10
 18e1f31:	c4 e1 d4 45 c8       	korq   %k0,%k5,%k1
 18e1f36:	62 f1 25 48 74 c4    	vpcmpeqb %zmm4,%zmm11,%k0
 18e1f3c:	62 f1 25 48 74 ee    	vpcmpeqb %zmm6,%zmm11,%k5
 18e1f42:	62 71 dd 40 eb dd    	vporq  %zmm5,%zmm20,%zmm11
 18e1f48:	62 a1 7f 4c 6f ca    	vmovdqu8 %zmm18,%zmm17{%k4}
 18e1f4e:	c4 e1 f8 90 64 24 60 	kmovq  0x60(%rsp),%k4
 18e1f55:	62 c1 7f 4e 6f e3    	vmovdqu8 %zmm11,%zmm20{%k6}
 18e1f5b:	62 71 bd 48 eb dd    	vporq  %zmm5,%zmm8,%zmm11
 18e1f61:	62 c1 7f 4d 6f da    	vmovdqu8 %zmm10,%zmm19{%k5}
 18e1f67:	c4 e1 f8 90 6c 24 30 	kmovq  0x30(%rsp),%k5
 18e1f6e:	c4 e1 c4 45 f8       	korq   %k0,%k7,%k7
 18e1f73:	62 71 e5 40 eb d5    	vporq  %zmm5,%zmm19,%zmm10
 18e1f79:	62 a1 fe 48 7f 24 02 	vmovdqu64 %zmm20,(%rdx,%r8,1)
 18e1f80:	62 a1 fe 48 7f 4c 02 01 	vmovdqu64 %zmm17,0x40(%rdx,%r8,1)
 18e1f88:	62 51 7f 49 6f c3    	vmovdqu8 %zmm11,%zmm8{%k1}
 18e1f8e:	c4 e1 f8 90 8c 24 b0 00 00 00 	kmovq  0xb0(%rsp),%k1
 18e1f98:	62 c1 7f 4f 6f da    	vmovdqu8 %zmm10,%zmm19{%k7}
 18e1f9e:	62 31 fe 48 7f 44 02 02 	vmovdqu64 %zmm8,0x80(%rdx,%r8,1)
 18e1fa6:	62 a1 fe 48 7f 5c 02 03 	vmovdqu64 %zmm19,0xc0(%rdx,%r8,1)
 18e1fae:	48 81 c2 00 01 00 00 	add    $0x100,%rdx
 18e1fb5:	62 f3 15 4c 3e e1 01 	vpcmpltub %zmm1,%zmm13,%k4{%k4}
 18e1fbc:	62 f3 0d 4d 3e e9 01 	vpcmpltub %zmm1,%zmm14,%k5{%k5}
 18e1fc3:	62 f3 1d 49 3e c9 01 	vpcmpltub %zmm1,%zmm12,%k1{%k1}
 18e1fca:	48 81 fa 00 20 00 00 	cmp    $0x2000,%rdx
 18e1fd1:	0f 85 f9 da ff ff    	jne    18dfad0 <run_backend_benchmark+0x2a00>
 18e1fd7:	c4 e2 7d 5a 0d e0 a0 cc fe 	vbroadcasti128 -0x1335f20(%rip),%ymm1        # 5ac0c0 <x86_effects_unknown+0xf0>
 18e1fe0:	c4 e2 7d 5a 15 e7 a0 cc fe 	vbroadcasti128 -0x1335f19(%rip),%ymm2        # 5ac0d0 <x86_effects_unknown+0x100>
 18e1fe9:	c4 e2 7d 5a 1d ee a0 cc fe 	vbroadcasti128 -0x1335f12(%rip),%ymm3        # 5ac0e0 <x86_effects_unknown+0x110>
 18e1ff2:	c4 e2 7d 5a 25 f5 a0 cc fe 	vbroadcasti128 -0x1335f0b(%rip),%ymm4        # 5ac0f0 <x86_effects_unknown+0x120>
 18e1ffb:	c4 e2 7d 5a 2d 0c a1 cc fe 	vbroadcasti128 -0x1335ef4(%rip),%ymm5        # 5ac110 <x86_effects_unknown+0x140>
 18e2004:	c4 e2 7d 5a 35 13 a1 cc fe 	vbroadcasti128 -0x1335eed(%rip),%ymm6        # 5ac120 <x86_effects_unknown+0x150>
 18e200d:	c4 e2 7d 5a 3d ea a0 cc fe 	vbroadcasti128 -0x1335f16(%rip),%ymm7        # 5ac100 <x86_effects_unknown+0x130>
 18e2016:	c4 e1 dc 41 c1       	kandq  %k1,%k4,%k0
 18e201b:	c4 e1 ec 41 cd       	kandq  %k5,%k2,%k1
 18e2020:	31 c0                	xor    %eax,%eax
 18e2022:	48 8d 0d 89 af 9d 00 	lea    0x9daf89(%rip),%rcx        # 22bcfb2 <x86_form_descriptions+0x50012>
 18e2029:	48 be 00 00 01 00 00 00 00 01 	movabs $0x100000000010000,%rsi
 18e2033:	48 bf 01 00 00 00 00 01 00 00 	movabs $0x10000000001,%rdi
 18e203d:	c4 e1 f4 41 c0       	kandq  %k0,%k1,%k0
 18e2042:	c4 e1 f8 98 c0       	kortestq %k0,%k0
 18e2047:	0f 92 c0             	setb   %al
 18e204a:	31 d2                	xor    %edx,%edx
 18e204c:	83 c8 fe             	or     $0xfffffffe,%eax
 18e204f:	c5 fb 92 c8          	kmovd  %eax,%k1
 18e2053:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18e2060:	c4 e1 fb 92 d6       	kmovq  %rsi,%k2
 18e2065:	c4 e1 fb 92 df       	kmovq  %rdi,%k3
 18e206a:	62 71 7f ca 6f 81 c9 02 00 00 	vmovdqu8 0x2c9(%rcx),%zmm8{%k2}{z}
 18e2074:	62 71 7f cb 6f 89 89 02 00 00 	vmovdqu8 0x289(%rcx),%zmm9{%k3}{z}
 18e207e:	62 71 7f ca 6f 91 69 03 00 00 	vmovdqu8 0x369(%rcx),%zmm10{%k2}{z}
 18e2088:	62 71 7f cb 6f 99 c9 03 00 00 	vmovdqu8 0x3c9(%rcx),%zmm11{%k3}{z}
 18e2092:	62 71 7f ca 6f a1 09 04 00 00 	vmovdqu8 0x409(%rcx),%zmm12{%k2}{z}
 18e209c:	62 71 7f cb 6f b9 60 04 00 00 	vmovdqu8 0x460(%rcx),%zmm15{%k3}{z}
 18e20a6:	62 e1 7f ca 6f 81 a0 04 00 00 	vmovdqu8 0x4a0(%rcx),%zmm16{%k2}{z}
 18e20b0:	62 52 7d 48 7d c8    	vpermt2b %zmm8,%zmm0,%zmm9
 18e20b6:	62 71 7f cb 6f 81 29 03 00 00 	vmovdqu8 0x329(%rcx),%zmm8{%k3}{z}
 18e20c0:	62 53 7d 48 39 d5 03 	vextracti32x4 $0x3,%zmm10,%xmm13
 18e20c7:	62 53 7d 48 39 c6 02 	vextracti32x4 $0x2,%zmm8,%xmm14
 18e20ce:	c5 79 7e c0          	vmovd  %xmm8,%eax
 18e20d2:	c4 63 31 20 c0 04    	vpinsrb $0x4,%eax,%xmm9,%xmm8
 18e20d8:	c4 63 79 14 f0 08    	vpextrb $0x8,%xmm14,%eax
 18e20de:	c4 43 7d 39 d1 01    	vextracti128 $0x1,%ymm10,%xmm9
 18e20e4:	62 53 7d 48 39 e2 03 	vextracti32x4 $0x3,%zmm12,%xmm10
 18e20eb:	62 71 7f ca 6f 71 10 	vmovdqu8 0x400(%rcx),%zmm14{%k2}{z}
 18e20f2:	c4 63 39 20 c0 05    	vpinsrb $0x5,%eax,%xmm8,%xmm8
 18e20f8:	c5 79 7e c8          	vmovd  %xmm9,%eax
 18e20fc:	62 71 7f cb 6f 89 69 04 00 00 	vmovdqu8 0x469(%rcx),%zmm9{%k3}{z}
 18e2106:	c4 63 39 20 c0 06    	vpinsrb $0x6,%eax,%xmm8,%xmm8
 18e210c:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18e2112:	62 53 7d 48 39 dd 02 	vextracti32x4 $0x2,%zmm11,%xmm13
 18e2119:	c4 63 39 20 c0 07    	vpinsrb $0x7,%eax,%xmm8,%xmm8
 18e211f:	c5 79 7e d8          	vmovd  %xmm11,%eax
 18e2123:	c4 43 7d 39 e3 01    	vextracti128 $0x1,%ymm12,%xmm11
 18e2129:	c4 63 39 20 c0 08    	vpinsrb $0x8,%eax,%xmm8,%xmm8
 18e212f:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18e2135:	62 71 7f cb 6f 69 0f 	vmovdqu8 0x3c0(%rcx),%zmm13{%k3}{z}
 18e213c:	c4 63 39 20 c0 09    	vpinsrb $0x9,%eax,%xmm8,%xmm8
 18e2142:	c5 79 7e d8          	vmovd  %xmm11,%eax
 18e2146:	c4 63 39 20 c0 0a    	vpinsrb $0xa,%eax,%xmm8,%xmm8
 18e214c:	c4 63 79 14 d0 08    	vpextrb $0x8,%xmm10,%eax
 18e2152:	62 71 7f ca 6f 91 a9 04 00 00 	vmovdqu8 0x4a9(%rcx),%zmm10{%k2}{z}
 18e215c:	c4 63 39 20 c0 0b    	vpinsrb $0xb,%eax,%xmm8,%xmm8
 18e2162:	c5 79 7e c8          	vmovd  %xmm9,%eax
 18e2166:	62 53 7d 48 39 cc 02 	vextracti32x4 $0x2,%zmm9,%xmm12
 18e216d:	c4 63 39 20 c0 0c    	vpinsrb $0xc,%eax,%xmm8,%xmm8
 18e2173:	c4 63 79 14 e0 08    	vpextrb $0x8,%xmm12,%eax
 18e2179:	62 71 7f ca 6f 61 0b 	vmovdqu8 0x2c0(%rcx),%zmm12{%k2}{z}
 18e2180:	c4 63 39 20 c0 0d    	vpinsrb $0xd,%eax,%xmm8,%xmm8
 18e2186:	c4 43 7d 39 d1 01    	vextracti128 $0x1,%ymm10,%xmm9
 18e218c:	62 53 7d 48 39 d3 03 	vextracti32x4 $0x3,%zmm10,%xmm11
 18e2193:	62 71 7f ca 6f 51 01 	vmovdqu8 0x40(%rcx),%zmm10{%k2}{z}
 18e219a:	c5 79 7e c8          	vmovd  %xmm9,%eax
 18e219e:	62 71 7f cb 6f 09    	vmovdqu8 (%rcx),%zmm9{%k3}{z}
 18e21a4:	c4 63 39 20 c0 0e    	vpinsrb $0xe,%eax,%xmm8,%xmm8
 18e21aa:	c4 63 79 14 d8 08    	vpextrb $0x8,%xmm11,%eax
 18e21b0:	62 71 7f cb 6f 59 0a 	vmovdqu8 0x280(%rcx),%zmm11{%k3}{z}
 18e21b7:	c4 63 39 20 c0 0f    	vpinsrb $0xf,%eax,%xmm8,%xmm8
 18e21bd:	62 52 7d 48 7d ca    	vpermt2b %zmm10,%zmm0,%zmm9
 18e21c3:	62 71 7f cb 6f 91 20 03 00 00 	vmovdqu8 0x320(%rcx),%zmm10{%k3}{z}
 18e21cd:	62 52 7d 48 7d dc    	vpermt2b %zmm12,%zmm0,%zmm11
 18e21d3:	62 71 7f ca 6f a1 60 03 00 00 	vmovdqu8 0x360(%rcx),%zmm12{%k2}{z}
 18e21dd:	c5 79 7e d0          	vmovd  %xmm10,%eax
 18e21e1:	62 53 7d 48 39 d2 02 	vextracti32x4 $0x2,%zmm10,%xmm10
 18e21e8:	62 33 7d 48 39 e1 03 	vextracti32x4 $0x3,%zmm12,%xmm17
 18e21ef:	c4 63 21 20 d8 04    	vpinsrb $0x4,%eax,%xmm11,%xmm11
 18e21f5:	c4 63 79 14 d0 08    	vpextrb $0x8,%xmm10,%eax
 18e21fb:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 18e2201:	c4 63 21 20 d0 05    	vpinsrb $0x5,%eax,%xmm11,%xmm10
 18e2207:	c5 79 7e e0          	vmovd  %xmm12,%eax
 18e220b:	c4 43 7d 39 f4 01    	vextracti128 $0x1,%ymm14,%xmm12
 18e2211:	62 53 7d 48 39 f3 03 	vextracti32x4 $0x3,%zmm14,%xmm11
 18e2218:	c4 63 29 20 d0 06    	vpinsrb $0x6,%eax,%xmm10,%xmm10
 18e221e:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 18e2225:	c4 63 29 20 d0 07    	vpinsrb $0x7,%eax,%xmm10,%xmm10
 18e222b:	c5 79 7e e8          	vmovd  %xmm13,%eax
 18e222f:	62 53 7d 48 39 ed 02 	vextracti32x4 $0x2,%zmm13,%xmm13
 18e2236:	c4 63 29 20 d0 08    	vpinsrb $0x8,%eax,%xmm10,%xmm10
 18e223c:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18e2242:	c4 63 29 20 d0 09    	vpinsrb $0x9,%eax,%xmm10,%xmm10
 18e2248:	c5 79 7e e0          	vmovd  %xmm12,%eax
 18e224c:	62 71 7f cb 6f a1 09 00 00 00 	vmovdqu8 0x9(%rcx),%zmm12{%k3}{z}
 18e2256:	c4 63 29 20 d0 0a    	vpinsrb $0xa,%eax,%xmm10,%xmm10
 18e225c:	c4 63 79 14 d8 08    	vpextrb $0x8,%xmm11,%eax
 18e2262:	62 53 7d 48 39 fb 02 	vextracti32x4 $0x2,%zmm15,%xmm11
 18e2269:	c4 63 29 20 d0 0b    	vpinsrb $0xb,%eax,%xmm10,%xmm10
 18e226f:	c5 79 7e f8          	vmovd  %xmm15,%eax
 18e2273:	c4 63 29 20 d0 0c    	vpinsrb $0xc,%eax,%xmm10,%xmm10
 18e2279:	c4 63 79 14 d8 08    	vpextrb $0x8,%xmm11,%eax
 18e227f:	62 c3 7d 28 39 c3 01 	vextracti32x4 $0x1,%ymm16,%xmm11
 18e2286:	c4 63 29 20 d0 0d    	vpinsrb $0xd,%eax,%xmm10,%xmm10
 18e228c:	c5 79 7e d8          	vmovd  %xmm11,%eax
 18e2290:	62 c3 7d 48 39 c3 03 	vextracti32x4 $0x3,%zmm16,%xmm11
 18e2297:	c4 63 29 20 d0 0e    	vpinsrb $0xe,%eax,%xmm10,%xmm10
 18e229d:	c4 63 79 14 d8 08    	vpextrb $0x8,%xmm11,%eax
 18e22a3:	62 71 7f ca 6f 99 49 00 00 00 	vmovdqu8 0x49(%rcx),%zmm11{%k2}{z}
 18e22ad:	c4 63 29 20 d0 0f    	vpinsrb $0xf,%eax,%xmm10,%xmm10
 18e22b3:	0f b6 81 a0 00 00 00 	movzbl 0xa0(%rcx),%eax
 18e22ba:	c4 63 31 20 c8 04    	vpinsrb $0x4,%eax,%xmm9,%xmm9
 18e22c0:	0f b6 81 c8 00 00 00 	movzbl 0xc8(%rcx),%eax
 18e22c7:	62 52 7d 48 7d e3    	vpermt2b %zmm11,%zmm0,%zmm12
 18e22cd:	c4 63 19 20 99 a9 00 00 00 04 	vpinsrb $0x4,0xa9(%rcx),%xmm12,%xmm11
 18e22d7:	c4 63 31 20 c8 05    	vpinsrb $0x5,%eax,%xmm9,%xmm9
 18e22dd:	0f b6 81 f0 00 00 00 	movzbl 0xf0(%rcx),%eax
 18e22e4:	c4 63 21 20 99 d1 00 00 00 05 	vpinsrb $0x5,0xd1(%rcx),%xmm11,%xmm11
 18e22ee:	c4 63 31 20 c8 06    	vpinsrb $0x6,%eax,%xmm9,%xmm9
 18e22f4:	0f b6 81 18 01 00 00 	movzbl 0x118(%rcx),%eax
 18e22fb:	c4 63 21 20 99 f9 00 00 00 06 	vpinsrb $0x6,0xf9(%rcx),%xmm11,%xmm11
 18e2305:	c4 63 31 20 c8 07    	vpinsrb $0x7,%eax,%xmm9,%xmm9
 18e230b:	0f b6 81 40 01 00 00 	movzbl 0x140(%rcx),%eax
 18e2312:	c4 63 21 20 99 21 01 00 00 07 	vpinsrb $0x7,0x121(%rcx),%xmm11,%xmm11
 18e231c:	c4 63 21 20 99 49 01 00 00 08 	vpinsrb $0x8,0x149(%rcx),%xmm11,%xmm11
 18e2326:	c4 63 31 20 c8 08    	vpinsrb $0x8,%eax,%xmm9,%xmm9
 18e232c:	0f b6 81 68 01 00 00 	movzbl 0x168(%rcx),%eax
 18e2333:	c4 63 21 20 99 71 01 00 00 09 	vpinsrb $0x9,0x171(%rcx),%xmm11,%xmm11
 18e233d:	c4 63 31 20 c8 09    	vpinsrb $0x9,%eax,%xmm9,%xmm9
 18e2343:	0f b6 81 90 01 00 00 	movzbl 0x190(%rcx),%eax
 18e234a:	c4 63 21 20 99 99 01 00 00 0a 	vpinsrb $0xa,0x199(%rcx),%xmm11,%xmm11
 18e2354:	c4 63 31 20 c8 0a    	vpinsrb $0xa,%eax,%xmm9,%xmm9
 18e235a:	0f b6 81 b8 01 00 00 	movzbl 0x1b8(%rcx),%eax
 18e2361:	c4 63 21 20 99 c1 01 00 00 0b 	vpinsrb $0xb,0x1c1(%rcx),%xmm11,%xmm11
 18e236b:	c4 63 31 20 c8 0b    	vpinsrb $0xb,%eax,%xmm9,%xmm9
 18e2371:	0f b6 81 e0 01 00 00 	movzbl 0x1e0(%rcx),%eax
 18e2378:	c4 63 21 20 99 e9 01 00 00 0c 	vpinsrb $0xc,0x1e9(%rcx),%xmm11,%xmm11
 18e2382:	c4 63 21 20 99 11 02 00 00 0d 	vpinsrb $0xd,0x211(%rcx),%xmm11,%xmm11
 18e238c:	c4 63 31 20 c8 0c    	vpinsrb $0xc,%eax,%xmm9,%xmm9
 18e2392:	0f b6 81 08 02 00 00 	movzbl 0x208(%rcx),%eax
 18e2399:	c4 63 21 20 99 39 02 00 00 0e 	vpinsrb $0xe,0x239(%rcx),%xmm11,%xmm11
 18e23a3:	c4 63 31 20 c8 0d    	vpinsrb $0xd,%eax,%xmm9,%xmm9
 18e23a9:	0f b6 81 30 02 00 00 	movzbl 0x230(%rcx),%eax
 18e23b0:	c4 63 21 20 99 61 02 00 00 0f 	vpinsrb $0xf,0x261(%rcx),%xmm11,%xmm11
 18e23ba:	c4 63 31 20 c8 0e    	vpinsrb $0xe,%eax,%xmm9,%xmm9
 18e23c0:	0f b6 81 58 02 00 00 	movzbl 0x258(%rcx),%eax
 18e23c7:	48 81 c1 00 05 00 00 	add    $0x500,%rcx
 18e23ce:	c4 63 31 20 c8 0f    	vpinsrb $0xf,%eax,%xmm9,%xmm9
 18e23d4:	c4 43 25 38 c0 01    	vinserti128 $0x1,%xmm8,%ymm11,%ymm8
 18e23da:	c4 43 35 38 ca 01    	vinserti128 $0x1,%xmm10,%ymm9,%ymm9
 18e23e0:	62 f1 3d 28 74 c3    	vpcmpeqb %ymm3,%ymm8,%k0
 18e23e6:	62 f1 3d 28 74 d4    	vpcmpeqb %ymm4,%ymm8,%k2
 18e23ec:	62 f1 3d 28 74 dd    	vpcmpeqb %ymm5,%ymm8,%k3
 18e23f2:	62 f3 35 29 3e c9 01 	vpcmpltub %ymm1,%ymm9,%k1{%k1}
 18e23f9:	c5 35 db ca          	vpand  %ymm2,%ymm9,%ymm9
 18e23fd:	c4 e1 fd 45 d2       	kord   %k2,%k0,%k2
 18e2402:	c5 35 eb c6          	vpor   %ymm6,%ymm9,%ymm8
 18e2406:	62 51 7f 2b 6f c8    	vmovdqu8 %ymm8,%ymm9{%k3}
 18e240c:	c5 35 eb c7          	vpor   %ymm7,%ymm9,%ymm8
 18e2410:	62 51 7f 2a 6f c8    	vmovdqu8 %ymm8,%ymm9{%k2}
 18e2416:	c4 21 7e 7f 8c 02 00 20 00 00 	vmovdqu %ymm9,0x2000(%rdx,%r8,1)
 18e2420:	48 83 c2 20          	add    $0x20,%rdx
 18e2424:	48 81 fa a0 00 00 00 	cmp    $0xa0,%rdx
 18e242b:	0f 85 2f fc ff ff    	jne    18e2060 <run_backend_benchmark+0x4f90>
 18e2431:	c4 e1 f9 98 c9       	kortestd %k1,%k1
 18e2436:	0f 92 05 c3 ad 70 0d 	setb   0xd70adc3(%rip)        # efed200 <tier0_initialized>
 18e243d:	0f 83 73 40 00 00    	jae    18e64b6 <run_backend_benchmark+0x93e6>
 18e2443:	48 8d bc 24 00 0d 00 00 	lea    0xd00(%rsp),%rdi
 18e244b:	c5 f8 77             	vzeroupper
 18e244e:	e8 1d 4f 00 00       	call   18e7370 <tier0_tables_open>
 18e2453:	84 c0                	test   %al,%al
 18e2455:	0f 84 5b 40 00 00    	je     18e64b6 <run_backend_benchmark+0x93e6>
 18e245b:	49 be 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%r14
 18e2465:	ba 03 00 00 00       	mov    $0x3,%edx
 18e246a:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18e246f:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18e2475:	45 31 ed             	xor    %r13d,%r13d
 18e2478:	31 ff                	xor    %edi,%edi
 18e247a:	45 31 c9             	xor    %r9d,%r9d
 18e247d:	4c 89 f6             	mov    %r14,%rsi
 18e2480:	e8 0b 7c eb fe       	call   79a090 <mmap@plt>
 18e2485:	48 89 84 24 60 01 00 00 	mov    %rax,0x160(%rsp)
 18e248d:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18e2491:	74 5e                	je     18e24f1 <run_backend_benchmark+0x5421>
 18e2493:	4c 8d a8 ff ff 20 00 	lea    0x20ffff(%rax),%r13
 18e249a:	ba 0f 00 00 00       	mov    $0xf,%edx
 18e249f:	48 89 c7             	mov    %rax,%rdi
 18e24a2:	49 81 e5 00 00 e0 ff 	and    $0xffffffffffe00000,%r13
 18e24a9:	4c 89 eb             	mov    %r13,%rbx
 18e24ac:	48 29 c3             	sub    %rax,%rbx
 18e24af:	48 8d 8b 00 00 ff ff 	lea    -0x10000(%rbx),%rcx
 18e24b6:	48 89 de             	mov    %rbx,%rsi
 18e24b9:	48 89 8c 24 38 01 00 00 	mov    %rcx,0x138(%rsp)
 18e24c1:	e8 7a 7b eb fe       	call   79a040 <madvise@plt>
 18e24c6:	4c 89 f6             	mov    %r14,%rsi
 18e24c9:	48 29 de             	sub    %rbx,%rsi
 18e24cc:	ba 0e 00 00 00       	mov    $0xe,%edx
 18e24d1:	4c 89 ef             	mov    %r13,%rdi
 18e24d4:	e8 67 7b eb fe       	call   79a040 <madvise@plt>
 18e24d9:	49 81 c5 00 00 ff ff 	add    $0xffffffffffff0000,%r13
 18e24e0:	49 8d 86 00 00 e0 ff 	lea    -0x200000(%r14),%rax
 18e24e7:	48 89 84 24 98 00 00 00 	mov    %rax,0x98(%rsp)
 18e24ef:	eb 18                	jmp    18e2509 <run_backend_benchmark+0x5439>
 18e24f1:	48 c7 84 24 38 01 00 00 00 00 00 00 	movq   $0x0,0x138(%rsp)
 18e24fd:	48 c7 84 24 98 00 00 00 00 00 00 00 	movq   $0x0,0x98(%rsp)
 18e2509:	ba 03 00 00 00       	mov    $0x3,%edx
 18e250e:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18e2513:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18e2519:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18e251d:	c5 fd 7f 84 24 e0 01 00 00 	vmovdqa %ymm0,0x1e0(%rsp)
 18e2526:	31 ff                	xor    %edi,%edi
 18e2528:	4c 89 f6             	mov    %r14,%rsi
 18e252b:	45 31 c9             	xor    %r9d,%r9d
 18e252e:	4d 89 f4             	mov    %r14,%r12
 18e2531:	c5 f8 77             	vzeroupper
 18e2534:	e8 57 7b eb fe       	call   79a090 <mmap@plt>
 18e2539:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18e253d:	74 65                	je     18e25a4 <run_backend_benchmark+0x54d4>
 18e253f:	48 8d 98 ff ff 20 00 	lea    0x20ffff(%rax),%rbx
 18e2546:	ba 0f 00 00 00       	mov    $0xf,%edx
 18e254b:	48 89 c7             	mov    %rax,%rdi
 18e254e:	48 81 e3 00 00 e0 ff 	and    $0xffffffffffe00000,%rbx
 18e2555:	49 89 de             	mov    %rbx,%r14
 18e2558:	49 29 c6             	sub    %rax,%r14
 18e255b:	4c 89 f6             	mov    %r14,%rsi
 18e255e:	4d 8d be 00 00 ff ff 	lea    -0x10000(%r14),%r15
 18e2565:	e8 d6 7a eb fe       	call   79a040 <madvise@plt>
 18e256a:	4c 89 e6             	mov    %r12,%rsi
 18e256d:	4c 29 f6             	sub    %r14,%rsi
 18e2570:	ba 0e 00 00 00       	mov    $0xe,%edx
 18e2575:	48 89 df             	mov    %rbx,%rdi
 18e2578:	e8 c3 7a eb fe       	call   79a040 <madvise@plt>
 18e257d:	48 81 c3 00 00 ff ff 	add    $0xffffffffffff0000,%rbx
 18e2584:	49 8d 84 24 00 00 e0 ff 	lea    -0x200000(%r12),%rax
 18e258c:	48 89 9c 24 e0 01 00 00 	mov    %rbx,0x1e0(%rsp)
 18e2594:	48 89 84 24 f0 01 00 00 	mov    %rax,0x1f0(%rsp)
 18e259c:	4c 89 bc 24 f8 01 00 00 	mov    %r15,0x1f8(%rsp)
 18e25a4:	49 bc 00 00 20 00 01 00 00 00 	movabs $0x100200000,%r12
 18e25ae:	ba 03 00 00 00       	mov    $0x3,%edx
 18e25b3:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18e25b8:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18e25be:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18e25c2:	c5 fd 7f 84 24 c0 01 00 00 	vmovdqa %ymm0,0x1c0(%rsp)
 18e25cb:	31 ff                	xor    %edi,%edi
 18e25cd:	45 31 c9             	xor    %r9d,%r9d
 18e25d0:	4c 89 e6             	mov    %r12,%rsi
 18e25d3:	c5 f8 77             	vzeroupper
 18e25d6:	e8 b5 7a eb fe       	call   79a090 <mmap@plt>
 18e25db:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18e25df:	74 65                	je     18e2646 <run_backend_benchmark+0x5576>
 18e25e1:	48 8d 98 ff ff 20 00 	lea    0x20ffff(%rax),%rbx
 18e25e8:	ba 0f 00 00 00       	mov    $0xf,%edx
 18e25ed:	48 89 c7             	mov    %rax,%rdi
 18e25f0:	48 81 e3 00 00 e0 ff 	and    $0xffffffffffe00000,%rbx
 18e25f7:	49 89 de             	mov    %rbx,%r14
 18e25fa:	49 29 c6             	sub    %rax,%r14
 18e25fd:	4c 89 f6             	mov    %r14,%rsi
 18e2600:	4d 8d be 00 00 ff ff 	lea    -0x10000(%r14),%r15
 18e2607:	e8 34 7a eb fe       	call   79a040 <madvise@plt>
 18e260c:	4c 89 e6             	mov    %r12,%rsi
 18e260f:	4c 29 f6             	sub    %r14,%rsi
 18e2612:	ba 0e 00 00 00       	mov    $0xe,%edx
 18e2617:	48 89 df             	mov    %rbx,%rdi
 18e261a:	e8 21 7a eb fe       	call   79a040 <madvise@plt>
 18e261f:	48 81 c3 00 00 ff ff 	add    $0xffffffffffff0000,%rbx
 18e2626:	49 8d 84 24 00 00 e0 ff 	lea    -0x200000(%r12),%rax
 18e262e:	48 89 9c 24 c0 01 00 00 	mov    %rbx,0x1c0(%rsp)
 18e2636:	48 89 84 24 d0 01 00 00 	mov    %rax,0x1d0(%rsp)
 18e263e:	4c 89 bc 24 d8 01 00 00 	mov    %r15,0x1d8(%rsp)
 18e2646:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
 18e264e:	49 8d 4d 07          	lea    0x7(%r13),%rcx
 18e2652:	31 db                	xor    %ebx,%ebx
 18e2654:	b8 00 00 00 00       	mov    $0x0,%eax
 18e2659:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18e265d:	62 f1 fe 48 7f 44 24 06 	vmovdqu64 %zmm0,0x180(%rsp)
 18e2665:	62 f1 fe 48 7f 84 24 70 01 00 00 	vmovdqu64 %zmm0,0x170(%rsp)
 18e2670:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 18e2674:	48 89 ca             	mov    %rcx,%rdx
 18e2677:	4c 29 ea             	sub    %r13,%rdx
 18e267a:	72 2c                	jb     18e26a8 <run_backend_benchmark+0x55d8>
 18e267c:	4c 89 f0             	mov    %r14,%rax
 18e267f:	48 29 d0             	sub    %rdx,%rax
 18e2682:	40 0f 92 c6          	setb   %sil
 18e2686:	48 3d 00 00 80 00    	cmp    $0x800000,%rax
 18e268c:	0f 92 c0             	setb   %al
 18e268f:	31 db                	xor    %ebx,%ebx
 18e2691:	40 08 f0             	or     %sil,%al
 18e2694:	b8 00 00 00 00       	mov    $0x0,%eax
 18e2699:	75 0d                	jne    18e26a8 <run_backend_benchmark+0x55d8>
 18e269b:	48 81 c2 00 00 80 00 	add    $0x800000,%rdx
 18e26a2:	48 89 c8             	mov    %rcx,%rax
 18e26a5:	48 89 d3             	mov    %rdx,%rbx
 18e26a8:	4a 8d 4c 2b 07       	lea    0x7(%rbx,%r13,1),%rcx
 18e26ad:	4a 8d 34 2b          	lea    (%rbx,%r13,1),%rsi
 18e26b1:	48 89 84 24 68 01 00 00 	mov    %rax,0x168(%rsp)
 18e26b9:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 18e26bd:	48 39 f1             	cmp    %rsi,%rcx
 18e26c0:	0f 83 1c 3c 00 00    	jae    18e62e2 <run_backend_benchmark+0x9212>
 18e26c6:	31 c9                	xor    %ecx,%ecx
 18e26c8:	48 89 ca             	mov    %rcx,%rdx
 18e26cb:	31 c9                	xor    %ecx,%ecx
 18e26cd:	48 c7 84 24 78 01 00 00 00 00 00 00 	movq   $0x0,0x178(%rsp)
 18e26d9:	48 89 ce             	mov    %rcx,%rsi
 18e26dc:	31 c9                	xor    %ecx,%ecx
 18e26de:	48 c7 84 24 80 01 00 00 00 00 00 00 	movq   $0x0,0x180(%rsp)
 18e26ea:	49 89 c8             	mov    %rcx,%r8
 18e26ed:	48 c7 84 24 88 01 00 00 00 00 00 00 	movq   $0x0,0x188(%rsp)
 18e26f9:	31 c9                	xor    %ecx,%ecx
 18e26fb:	45 31 c9             	xor    %r9d,%r9d
 18e26fe:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 18e2704:	4c 89 8c 24 90 01 00 00 	mov    %r9,0x190(%rsp)
 18e270c:	48 85 c0             	test   %rax,%rax
 18e270f:	0f 84 d6 3e 00 00    	je     18e65eb <run_backend_benchmark+0x951b>
 18e2715:	48 85 d2             	test   %rdx,%rdx
 18e2718:	0f 84 cd 3e 00 00    	je     18e65eb <run_backend_benchmark+0x951b>
 18e271e:	48 85 f6             	test   %rsi,%rsi
 18e2721:	0f 84 c4 3e 00 00    	je     18e65eb <run_backend_benchmark+0x951b>
 18e2727:	4d 85 c0             	test   %r8,%r8
 18e272a:	0f 84 bb 3e 00 00    	je     18e65eb <run_backend_benchmark+0x951b>
 18e2730:	48 85 c9             	test   %rcx,%rcx
 18e2733:	0f 84 b2 3e 00 00    	je     18e65eb <run_backend_benchmark+0x951b>
 18e2739:	4d 85 c9             	test   %r9,%r9
 18e273c:	0f 84 a9 3e 00 00    	je     18e65eb <run_backend_benchmark+0x951b>
 18e2742:	48 c7 84 24 d8 00 00 00 00 00 00 00 	movq   $0x0,0xd8(%rsp)
 18e274e:	4c 89 6c 24 50       	mov    %r13,0x50(%rsp)
 18e2753:	4a 8d 74 2b 07       	lea    0x7(%rbx,%r13,1),%rsi
 18e2758:	4c 01 eb             	add    %r13,%rbx
 18e275b:	48 83 e6 f8          	and    $0xfffffffffffffff8,%rsi
 18e275f:	48 39 de             	cmp    %rbx,%rsi
 18e2762:	0f 82 83 3e 00 00    	jb     18e65eb <run_backend_benchmark+0x951b>
 18e2768:	48 89 df             	mov    %rbx,%rdi
 18e276b:	48 89 f3             	mov    %rsi,%rbx
 18e276e:	4c 29 eb             	sub    %r13,%rbx
 18e2771:	4c 89 f0             	mov    %r14,%rax
 18e2774:	48 29 d8             	sub    %rbx,%rax
 18e2777:	0f 92 c1             	setb   %cl
 18e277a:	48 3d a0 0d 00 00    	cmp    $0xda0,%rax
 18e2780:	0f 92 c2             	setb   %dl
 18e2783:	08 ca                	or     %cl,%dl
 18e2785:	74 0a                	je     18e2791 <run_backend_benchmark+0x56c1>
 18e2787:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
 18e278c:	45 31 c0             	xor    %r8d,%r8d
 18e278f:	eb 2f                	jmp    18e27c0 <run_backend_benchmark+0x56f0>
 18e2791:	48 81 c7 a7 0d 00 00 	add    $0xda7,%rdi
 18e2798:	48 8d 86 a0 0d 00 00 	lea    0xda0(%rsi),%rax
 18e279f:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
 18e27a3:	48 39 c7             	cmp    %rax,%rdi
 18e27a6:	0f 82 3f 3e 00 00    	jb     18e65eb <run_backend_benchmark+0x951b>
 18e27ac:	48 89 fb             	mov    %rdi,%rbx
 18e27af:	4c 29 eb             	sub    %r13,%rbx
 18e27b2:	4c 89 f0             	mov    %r14,%rax
 18e27b5:	49 89 f0             	mov    %rsi,%r8
 18e27b8:	48 89 7c 24 58       	mov    %rdi,0x58(%rsp)
 18e27bd:	48 29 d8             	sub    %rbx,%rax
 18e27c0:	4c 39 f3             	cmp    %r14,%rbx
 18e27c3:	0f 87 22 3e 00 00    	ja     18e65eb <run_backend_benchmark+0x951b>
 18e27c9:	48 3d 58 3a 00 00    	cmp    $0x3a58,%rax
 18e27cf:	0f 82 16 3e 00 00    	jb     18e65eb <run_backend_benchmark+0x951b>
 18e27d5:	4d 85 c0             	test   %r8,%r8
 18e27d8:	0f 84 0d 3e 00 00    	je     18e65eb <run_backend_benchmark+0x951b>
 18e27de:	48 83 7c 24 58 00    	cmpq   $0x0,0x58(%rsp)
 18e27e4:	0f 84 01 3e 00 00    	je     18e65eb <run_backend_benchmark+0x951b>
 18e27ea:	48 8b 84 24 48 01 00 00 	mov    0x148(%rsp),%rax
 18e27f2:	48 8b 8c 24 d8 00 00 00 	mov    0xd8(%rsp),%rcx
 18e27fa:	49 8d 78 18          	lea    0x18(%r8),%rdi
 18e27fe:	ba 88 0d 00 00       	mov    $0xd88,%edx
 18e2803:	31 f6                	xor    %esi,%esi
 18e2805:	4c 8d b3 58 3a 00 00 	lea    0x3a58(%rbx),%r14
 18e280c:	4c 89 84 24 80 00 00 00 	mov    %r8,0x80(%rsp)
 18e2814:	4c 8d 3c 01          	lea    (%rcx,%rax,1),%r15
 18e2818:	c5 f8 77             	vzeroupper
 18e281b:	e8 60 76 eb fe       	call   799e80 <memset@plt>
 18e2820:	48 8b 84 24 98 00 00 00 	mov    0x98(%rsp),%rax
 18e2828:	48 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%rsi
 18e2830:	4e 8d 8c 2b 58 3a 00 00 	lea    0x3a58(%rbx,%r13,1),%r9
 18e2838:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18e2840:	4c 89 bc 24 80 02 00 00 	mov    %r15,0x280(%rsp)
 18e2848:	4c 89 bc 24 30 01 00 00 	mov    %r15,0x130(%rsp)
 18e2850:	4c 29 f0             	sub    %r14,%rax
 18e2853:	41 c7 82 70 0d 00 00 08 00 00 00 	movl   $0x8,0xd70(%r10)
 18e285e:	66 41 c7 82 99 0d 00 00 00 00 	movw   $0x0,0xd99(%r10)
 18e2868:	41 c6 82 9b 0d 00 00 00 	movb   $0x0,0xd9b(%r10)
 18e2870:	41 c7 42 1c 00 9c 00 00 	movl   $0x9c00,0x1c(%r10)
 18e2878:	41 c7 42 4c 00 02 00 00 	movl   $0x200,0x4c(%r10)
 18e2880:	41 c7 42 7c 08 01 00 00 	movl   $0x108,0x7c(%r10)
 18e2888:	41 c7 82 94 00 00 00 00 21 00 00 	movl   $0x2100,0x94(%r10)
 18e2893:	49 c7 82 88 0d 00 00 00 a0 0f 00 	movq   $0xfa000,0xd88(%r10)
 18e289e:	0f 92 c1             	setb   %cl
 18e28a1:	48 3d 00 9c 00 00    	cmp    $0x9c00,%rax
 18e28a7:	0f 92 c0             	setb   %al
 18e28aa:	48 81 c3 58 d6 00 00 	add    $0xd658,%rbx
 18e28b1:	08 c8                	or     %cl,%al
 18e28b3:	84 c0                	test   %al,%al
 18e28b5:	48 89 f0             	mov    %rsi,%rax
 18e28b8:	49 0f 45 de          	cmovne %r14,%rbx
 18e28bc:	41 be 00 00 00 00    	mov    $0x0,%r14d
 18e28c2:	4d 0f 45 ce          	cmovne %r14,%r9
 18e28c6:	48 29 d8             	sub    %rbx,%rax
 18e28c9:	4e 8d 1c 2b          	lea    (%rbx,%r13,1),%r11
 18e28cd:	0f 92 c1             	setb   %cl
 18e28d0:	48 3d 00 9c 00 00    	cmp    $0x9c00,%rax
 18e28d6:	48 8d 83 00 9c 00 00 	lea    0x9c00(%rbx),%rax
 18e28dd:	4d 89 0a             	mov    %r9,(%r10)
 18e28e0:	4c 89 4c 24 40       	mov    %r9,0x40(%rsp)
 18e28e5:	0f 92 c2             	setb   %dl
 18e28e8:	08 ca                	or     %cl,%dl
 18e28ea:	84 d2                	test   %dl,%dl
 18e28ec:	48 0f 45 c3          	cmovne %rbx,%rax
 18e28f0:	4d 0f 45 de          	cmovne %r14,%r11
 18e28f4:	4a 8d 5c 28 07       	lea    0x7(%rax,%r13,1),%rbx
 18e28f9:	4a 8d 14 28          	lea    (%rax,%r13,1),%rdx
 18e28fd:	4d 89 5a 08          	mov    %r11,0x8(%r10)
 18e2901:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
 18e2905:	48 39 d3             	cmp    %rdx,%rbx
 18e2908:	72 20                	jb     18e292a <run_backend_benchmark+0x585a>
 18e290a:	48 89 d9             	mov    %rbx,%rcx
 18e290d:	4c 29 e9             	sub    %r13,%rcx
 18e2910:	48 89 f7             	mov    %rsi,%rdi
 18e2913:	48 29 cf             	sub    %rcx,%rdi
 18e2916:	41 0f 92 c0          	setb   %r8b
 18e291a:	48 81 ff 00 e0 04 00 	cmp    $0x4e000,%rdi
 18e2921:	40 0f 92 c7          	setb   %dil
 18e2925:	44 08 c7             	or     %r8b,%dil
 18e2928:	74 04                	je     18e292e <run_backend_benchmark+0x585e>
 18e292a:	31 db                	xor    %ebx,%ebx
 18e292c:	eb 14                	jmp    18e2942 <run_backend_benchmark+0x5872>
 18e292e:	48 89 da             	mov    %rbx,%rdx
 18e2931:	48 81 c1 00 e0 04 00 	add    $0x4e000,%rcx
 18e2938:	48 81 c2 00 e0 04 00 	add    $0x4e000,%rdx
 18e293f:	48 89 c8             	mov    %rcx,%rax
 18e2942:	48 89 f1             	mov    %rsi,%rcx
 18e2945:	48 29 c1             	sub    %rax,%rcx
 18e2948:	49 89 5a 10          	mov    %rbx,0x10(%r10)
 18e294c:	4c 89 9c 24 b0 00 00 00 	mov    %r11,0xb0(%rsp)
 18e2954:	48 89 5c 24 60       	mov    %rbx,0x60(%rsp)
 18e2959:	40 0f 92 c7          	setb   %dil
 18e295d:	48 81 f9 00 02 00 00 	cmp    $0x200,%rcx
 18e2964:	0f 92 c1             	setb   %cl
 18e2967:	40 08 f9             	or     %dil,%cl
 18e296a:	48 8d b8 00 02 00 00 	lea    0x200(%rax),%rdi
 18e2971:	84 c9                	test   %cl,%cl
 18e2973:	48 0f 45 f8          	cmovne %rax,%rdi
 18e2977:	49 0f 45 d6          	cmovne %r14,%rdx
 18e297b:	48 89 f0             	mov    %rsi,%rax
 18e297e:	48 29 f8             	sub    %rdi,%rax
 18e2981:	4e 8d 3c 2f          	lea    (%rdi,%r13,1),%r15
 18e2985:	49 89 52 20          	mov    %rdx,0x20(%r10)
 18e2989:	0f 92 c1             	setb   %cl
 18e298c:	48 3d 00 02 00 00    	cmp    $0x200,%rax
 18e2992:	48 8d 87 00 02 00 00 	lea    0x200(%rdi),%rax
 18e2999:	41 0f 92 c0          	setb   %r8b
 18e299d:	41 08 c8             	or     %cl,%r8b
 18e29a0:	45 84 c0             	test   %r8b,%r8b
 18e29a3:	48 0f 45 c7          	cmovne %rdi,%rax
 18e29a7:	4d 0f 45 fe          	cmovne %r14,%r15
 18e29ab:	4e 8d 4c 28 03       	lea    0x3(%rax,%r13,1),%r9
 18e29b0:	4e 8d 04 28          	lea    (%rax,%r13,1),%r8
 18e29b4:	4d 89 7a 28          	mov    %r15,0x28(%r10)
 18e29b8:	4c 89 7c 24 78       	mov    %r15,0x78(%rsp)
 18e29bd:	49 83 e1 fc          	and    $0xfffffffffffffffc,%r9
 18e29c1:	4d 39 c1             	cmp    %r8,%r9
 18e29c4:	73 05                	jae    18e29cb <run_backend_benchmark+0x58fb>
 18e29c6:	45 31 c9             	xor    %r9d,%r9d
 18e29c9:	eb 41                	jmp    18e2a0c <run_backend_benchmark+0x593c>
 18e29cb:	4c 89 c9             	mov    %r9,%rcx
 18e29ce:	4c 29 e9             	sub    %r13,%rcx
 18e29d1:	48 89 f7             	mov    %rsi,%rdi
 18e29d4:	48 29 cf             	sub    %rcx,%rdi
 18e29d7:	41 0f 92 c2          	setb   %r10b
 18e29db:	48 81 ff 00 08 00 00 	cmp    $0x800,%rdi
 18e29e2:	40 0f 92 c7          	setb   %dil
 18e29e6:	44 08 d7             	or     %r10b,%dil
 18e29e9:	74 05                	je     18e29f0 <run_backend_benchmark+0x5920>
 18e29eb:	45 31 c9             	xor    %r9d,%r9d
 18e29ee:	eb 14                	jmp    18e2a04 <run_backend_benchmark+0x5934>
 18e29f0:	4d 89 c8             	mov    %r9,%r8
 18e29f3:	48 81 c1 00 08 00 00 	add    $0x800,%rcx
 18e29fa:	49 81 c0 00 08 00 00 	add    $0x800,%r8
 18e2a01:	48 89 c8             	mov    %rcx,%rax
 18e2a04:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18e2a0c:	48 89 f1             	mov    %rsi,%rcx
 18e2a0f:	48 29 c1             	sub    %rax,%rcx
 18e2a12:	4c 8d b8 00 02 00 00 	lea    0x200(%rax),%r15
 18e2a19:	4d 89 4a 30          	mov    %r9,0x30(%r10)
 18e2a1d:	40 0f 92 c7          	setb   %dil
 18e2a21:	48 81 f9 00 02 00 00 	cmp    $0x200,%rcx
 18e2a28:	0f 92 c1             	setb   %cl
 18e2a2b:	40 08 f9             	or     %dil,%cl
 18e2a2e:	84 c9                	test   %cl,%cl
 18e2a30:	4c 0f 45 f8          	cmovne %rax,%r15
 18e2a34:	4d 0f 45 c6          	cmovne %r14,%r8
 18e2a38:	4f 8d 5c 2f 03       	lea    0x3(%r15,%r13,1),%r11
 18e2a3d:	4d 89 42 38          	mov    %r8,0x38(%r10)
 18e2a41:	4f 8d 14 2f          	lea    (%r15,%r13,1),%r10
 18e2a45:	49 83 e3 fc          	and    $0xfffffffffffffffc,%r11
 18e2a49:	4c 89 d8             	mov    %r11,%rax
 18e2a4c:	4c 29 e8             	sub    %r13,%rax
 18e2a4f:	4d 39 d3             	cmp    %r10,%r11
 18e2a52:	72 19                	jb     18e2a6d <run_backend_benchmark+0x599d>
 18e2a54:	48 89 f1             	mov    %rsi,%rcx
 18e2a57:	48 29 c1             	sub    %rax,%rcx
 18e2a5a:	40 0f 92 c7          	setb   %dil
 18e2a5e:	48 81 f9 20 04 00 00 	cmp    $0x420,%rcx
 18e2a65:	0f 92 c1             	setb   %cl
 18e2a68:	40 08 f9             	or     %dil,%cl
 18e2a6b:	74 15                	je     18e2a82 <run_backend_benchmark+0x59b2>
 18e2a6d:	31 db                	xor    %ebx,%ebx
 18e2a6f:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18e2a77:	48 89 59 50          	mov    %rbx,0x50(%rcx)
 18e2a7b:	4d 39 d3             	cmp    %r10,%r11
 18e2a7e:	72 5a                	jb     18e2ada <run_backend_benchmark+0x5a0a>
 18e2a80:	eb 3f                	jmp    18e2ac1 <run_backend_benchmark+0x59f1>
 18e2a82:	49 81 c2 23 04 00 00 	add    $0x423,%r10
 18e2a89:	49 89 c7             	mov    %rax,%r15
 18e2a8c:	4c 89 d9             	mov    %r11,%rcx
 18e2a8f:	49 81 c7 20 04 00 00 	add    $0x420,%r15
 18e2a96:	48 81 c1 20 04 00 00 	add    $0x420,%rcx
 18e2a9d:	4c 89 db             	mov    %r11,%rbx
 18e2aa0:	49 83 e2 fc          	and    $0xfffffffffffffffc,%r10
 18e2aa4:	4c 89 d0             	mov    %r10,%rax
 18e2aa7:	4c 29 e8             	sub    %r13,%rax
 18e2aaa:	4d 89 d3             	mov    %r10,%r11
 18e2aad:	49 89 ca             	mov    %rcx,%r10
 18e2ab0:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18e2ab8:	48 89 59 50          	mov    %rbx,0x50(%rcx)
 18e2abc:	4d 39 d3             	cmp    %r10,%r11
 18e2abf:	72 19                	jb     18e2ada <run_backend_benchmark+0x5a0a>
 18e2ac1:	48 89 f1             	mov    %rsi,%rcx
 18e2ac4:	48 29 c1             	sub    %rax,%rcx
 18e2ac7:	40 0f 92 c7          	setb   %dil
 18e2acb:	48 81 f9 20 04 00 00 	cmp    $0x420,%rcx
 18e2ad2:	0f 92 c1             	setb   %cl
 18e2ad5:	40 08 f9             	or     %dil,%cl
 18e2ad8:	74 05                	je     18e2adf <run_backend_benchmark+0x5a0f>
 18e2ada:	45 31 e4             	xor    %r12d,%r12d
 18e2add:	eb 24                	jmp    18e2b03 <run_backend_benchmark+0x5a33>
 18e2adf:	4d 89 dc             	mov    %r11,%r12
 18e2ae2:	4e 8d 9c 28 23 04 00 00 	lea    0x423(%rax,%r13,1),%r11
 18e2aea:	4e 8d 94 28 20 04 00 00 	lea    0x420(%rax,%r13,1),%r10
 18e2af2:	4c 8d b8 20 04 00 00 	lea    0x420(%rax),%r15
 18e2af9:	49 83 e3 fc          	and    $0xfffffffffffffffc,%r11
 18e2afd:	4c 89 d8             	mov    %r11,%rax
 18e2b00:	4c 29 e8             	sub    %r13,%rax
 18e2b03:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18e2b0b:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
 18e2b10:	48 89 5c 24 70       	mov    %rbx,0x70(%rsp)
 18e2b15:	4c 89 a4 24 c0 00 00 00 	mov    %r12,0xc0(%rsp)
 18e2b1d:	4c 89 61 58          	mov    %r12,0x58(%rcx)
 18e2b21:	4d 39 d3             	cmp    %r10,%r11
 18e2b24:	72 19                	jb     18e2b3f <run_backend_benchmark+0x5a6f>
 18e2b26:	48 89 f1             	mov    %rsi,%rcx
 18e2b29:	48 29 c1             	sub    %rax,%rcx
 18e2b2c:	40 0f 92 c7          	setb   %dil
 18e2b30:	48 81 f9 20 04 00 00 	cmp    $0x420,%rcx
 18e2b37:	0f 92 c1             	setb   %cl
 18e2b3a:	40 08 f9             	or     %dil,%cl
 18e2b3d:	74 05                	je     18e2b44 <run_backend_benchmark+0x5a74>
 18e2b3f:	45 31 db             	xor    %r11d,%r11d
 18e2b42:	eb 11                	jmp    18e2b55 <run_backend_benchmark+0x5a85>
 18e2b44:	4e 8d 94 28 20 04 00 00 	lea    0x420(%rax,%r13,1),%r10
 18e2b4c:	48 05 20 04 00 00    	add    $0x420,%rax
 18e2b52:	49 89 c7             	mov    %rax,%r15
 18e2b55:	48 89 f0             	mov    %rsi,%rax
 18e2b58:	4c 29 f8             	sub    %r15,%rax
 18e2b5b:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 18e2b63:	4c 89 84 24 90 00 00 00 	mov    %r8,0x90(%rsp)
 18e2b6b:	0f 92 c1             	setb   %cl
 18e2b6e:	48 3d 08 01 00 00    	cmp    $0x108,%rax
 18e2b74:	49 8d 87 08 01 00 00 	lea    0x108(%r15),%rax
 18e2b7b:	40 0f 92 c7          	setb   %dil
 18e2b7f:	40 08 cf             	or     %cl,%dil
 18e2b82:	40 84 ff             	test   %dil,%dil
 18e2b85:	49 0f 45 c7          	cmovne %r15,%rax
 18e2b89:	4d 0f 45 d6          	cmovne %r14,%r10
 18e2b8d:	4c 89 5a 60          	mov    %r11,0x60(%rdx)
 18e2b91:	4e 8d 7c 28 03       	lea    0x3(%rax,%r13,1),%r15
 18e2b96:	4e 8d 24 28          	lea    (%rax,%r13,1),%r12
 18e2b9a:	4c 89 52 68          	mov    %r10,0x68(%rdx)
 18e2b9e:	49 83 e7 fc          	and    $0xfffffffffffffffc,%r15
 18e2ba2:	4d 39 e7             	cmp    %r12,%r15
 18e2ba5:	72 1f                	jb     18e2bc6 <run_backend_benchmark+0x5af6>
 18e2ba7:	4c 89 f9             	mov    %r15,%rcx
 18e2baa:	4c 29 e9             	sub    %r13,%rcx
 18e2bad:	48 89 f7             	mov    %rsi,%rdi
 18e2bb0:	48 29 cf             	sub    %rcx,%rdi
 18e2bb3:	0f 92 c3             	setb   %bl
 18e2bb6:	48 81 ff 20 04 00 00 	cmp    $0x420,%rdi
 18e2bbd:	40 0f 92 c7          	setb   %dil
 18e2bc1:	40 08 df             	or     %bl,%dil
 18e2bc4:	74 05                	je     18e2bcb <run_backend_benchmark+0x5afb>
 18e2bc6:	45 31 ff             	xor    %r15d,%r15d
 18e2bc9:	eb 14                	jmp    18e2bdf <run_backend_benchmark+0x5b0f>
 18e2bcb:	4d 89 fc             	mov    %r15,%r12
 18e2bce:	48 81 c1 20 04 00 00 	add    $0x420,%rcx
 18e2bd5:	49 81 c4 20 04 00 00 	add    $0x420,%r12
 18e2bdc:	48 89 c8             	mov    %rcx,%rax
 18e2bdf:	48 89 f1             	mov    %rsi,%rcx
 18e2be2:	48 29 c1             	sub    %rax,%rcx
 18e2be5:	4c 89 ea             	mov    %r13,%rdx
 18e2be8:	4c 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%r8
 18e2bf0:	40 0f 92 c7          	setb   %dil
 18e2bf4:	48 81 f9 00 21 00 00 	cmp    $0x2100,%rcx
 18e2bfb:	0f 92 c1             	setb   %cl
 18e2bfe:	40 08 f9             	or     %dil,%cl
 18e2c01:	48 8d b8 00 21 00 00 	lea    0x2100(%rax),%rdi
 18e2c08:	84 c9                	test   %cl,%cl
 18e2c0a:	48 0f 45 f8          	cmovne %rax,%rdi
 18e2c0e:	4d 0f 45 e6          	cmovne %r14,%r12
 18e2c12:	48 89 f0             	mov    %rsi,%rax
 18e2c15:	4d 89 78 70          	mov    %r15,0x70(%r8)
 18e2c19:	48 29 f8             	sub    %rdi,%rax
 18e2c1c:	4e 8d 2c 2f          	lea    (%rdi,%r13,1),%r13
 18e2c20:	4d 89 a0 80 00 00 00 	mov    %r12,0x80(%r8)
 18e2c27:	0f 92 c1             	setb   %cl
 18e2c2a:	48 3d 00 21 00 00    	cmp    $0x2100,%rax
 18e2c30:	0f 92 c0             	setb   %al
 18e2c33:	08 c8                	or     %cl,%al
 18e2c35:	48 8d 8f 00 21 00 00 	lea    0x2100(%rdi),%rcx
 18e2c3c:	84 c0                	test   %al,%al
 18e2c3e:	48 89 f0             	mov    %rsi,%rax
 18e2c41:	48 0f 45 cf          	cmovne %rdi,%rcx
 18e2c45:	4d 0f 45 ee          	cmovne %r14,%r13
 18e2c49:	48 29 c8             	sub    %rcx,%rax
 18e2c4c:	4c 8d b1 00 02 00 00 	lea    0x200(%rcx),%r14
 18e2c53:	4d 89 a8 88 00 00 00 	mov    %r13,0x88(%r8)
 18e2c5a:	40 0f 92 c7          	setb   %dil
 18e2c5e:	48 3d 00 02 00 00    	cmp    $0x200,%rax
 18e2c64:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
 18e2c68:	0f 92 c3             	setb   %bl
 18e2c6b:	40 08 fb             	or     %dil,%bl
 18e2c6e:	31 ff                	xor    %edi,%edi
 18e2c70:	84 db                	test   %bl,%bl
 18e2c72:	4c 0f 45 f1          	cmovne %rcx,%r14
 18e2c76:	48 0f 45 c7          	cmovne %rdi,%rax
 18e2c7a:	49 8d 4c 16 07       	lea    0x7(%r14,%rdx,1),%rcx
 18e2c7f:	49 8d 3c 16          	lea    (%r14,%rdx,1),%rdi
 18e2c83:	49 89 40 40          	mov    %rax,0x40(%r8)
 18e2c87:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 18e2c8b:	48 39 f9             	cmp    %rdi,%rcx
 18e2c8e:	72 1f                	jb     18e2caf <run_backend_benchmark+0x5bdf>
 18e2c90:	48 89 cb             	mov    %rcx,%rbx
 18e2c93:	48 29 d3             	sub    %rdx,%rbx
 18e2c96:	48 89 f2             	mov    %rsi,%rdx
 18e2c99:	48 29 da             	sub    %rbx,%rdx
 18e2c9c:	40 0f 92 c6          	setb   %sil
 18e2ca0:	48 81 fa 00 20 00 00 	cmp    $0x2000,%rdx
 18e2ca7:	0f 92 c2             	setb   %dl
 18e2caa:	40 08 f2             	or     %sil,%dl
 18e2cad:	74 04                	je     18e2cb3 <run_backend_benchmark+0x5be3>
 18e2caf:	31 c9                	xor    %ecx,%ecx
 18e2cb1:	eb 14                	jmp    18e2cc7 <run_backend_benchmark+0x5bf7>
 18e2cb3:	48 89 cf             	mov    %rcx,%rdi
 18e2cb6:	48 81 c3 00 20 00 00 	add    $0x2000,%rbx
 18e2cbd:	48 81 c7 00 20 00 00 	add    $0x2000,%rdi
 18e2cc4:	49 89 de             	mov    %rbx,%r14
 18e2cc7:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 18e2ccf:	4c 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%r8
 18e2cd7:	4c 29 f2             	sub    %r14,%rdx
 18e2cda:	49 89 88 d8 01 00 00 	mov    %rcx,0x1d8(%r8)
 18e2ce1:	40 0f 92 c6          	setb   %sil
 18e2ce5:	48 81 fa 00 a0 0f 00 	cmp    $0xfa000,%rdx
 18e2cec:	0f 92 c2             	setb   %dl
 18e2cef:	40 08 f2             	or     %sil,%dl
 18e2cf2:	49 8d b6 00 a0 0f 00 	lea    0xfa000(%r14),%rsi
 18e2cf9:	84 d2                	test   %dl,%dl
 18e2cfb:	49 0f 45 f6          	cmovne %r14,%rsi
 18e2cff:	41 be 00 00 00 00    	mov    $0x0,%r14d
 18e2d05:	4c 0f 44 f7          	cmove  %rdi,%r14
 18e2d09:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18e2d0f:	48 89 b4 24 a0 00 00 00 	mov    %rsi,0xa0(%rsp)
 18e2d17:	4d 89 b0 78 0d 00 00 	mov    %r14,0xd78(%r8)
 18e2d1e:	0f 84 78 38 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2d24:	48 83 bc 24 b0 00 00 00 00 	cmpq   $0x0,0xb0(%rsp)
 18e2d2d:	0f 84 69 38 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2d33:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
 18e2d39:	0f 84 5d 38 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2d3f:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
 18e2d45:	0f 84 51 38 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2d4b:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
 18e2d51:	0f 84 45 38 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2d57:	4d 85 c9             	test   %r9,%r9
 18e2d5a:	0f 84 3c 38 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2d60:	48 83 bc 24 90 00 00 00 00 	cmpq   $0x0,0x90(%rsp)
 18e2d69:	0f 84 2d 38 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2d6f:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
 18e2d75:	0f 84 21 38 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2d7b:	48 83 bc 24 c0 00 00 00 00 	cmpq   $0x0,0xc0(%rsp)
 18e2d84:	0f 84 12 38 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2d8a:	4d 85 db             	test   %r11,%r11
 18e2d8d:	0f 84 09 38 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2d93:	4d 85 d2             	test   %r10,%r10
 18e2d96:	0f 84 00 38 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2d9c:	4d 85 e4             	test   %r12,%r12
 18e2d9f:	0f 84 f7 37 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2da5:	48 85 c0             	test   %rax,%rax
 18e2da8:	0f 84 ee 37 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2dae:	4d 85 ed             	test   %r13,%r13
 18e2db1:	0f 84 e5 37 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2db7:	4d 85 ff             	test   %r15,%r15
 18e2dba:	0f 84 dc 37 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2dc0:	48 85 c9             	test   %rcx,%rcx
 18e2dc3:	0f 84 d3 37 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2dc9:	4d 85 f6             	test   %r14,%r14
 18e2dcc:	0f 84 ca 37 00 00    	je     18e659c <run_backend_benchmark+0x94cc>
 18e2dd2:	48 8b 8c 24 30 01 00 00 	mov    0x130(%rsp),%rcx
 18e2dda:	48 b8 15 7c 4a 7f b9 79 37 9e 	movabs $0x9e3779b97f4a7c15,%rax
 18e2de4:	49 bc b9 e5 e4 1c 6d 47 58 bf 	movabs $0xbf58476d1ce4e5b9,%r12
 18e2dee:	c6 07 00             	movb   $0x0,(%rdi)
 18e2df1:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 18e2df9:	45 31 c9             	xor    %r9d,%r9d
 18e2dfc:	4c 8d 2c 01          	lea    (%rcx,%rax,1),%r13
 18e2e00:	48 c7 87 90 0d 00 00 00 00 00 00 	movq   $0x0,0xd90(%rdi)
 18e2e0b:	c6 87 ec 02 00 00 00 	movb   $0x0,0x2ec(%rdi)
 18e2e12:	4c 89 e8             	mov    %r13,%rax
 18e2e15:	48 c1 e8 1e          	shr    $0x1e,%rax
 18e2e19:	4c 31 e8             	xor    %r13,%rax
 18e2e1c:	49 0f af c4          	imul   %r12,%rax
 18e2e20:	48 89 c1             	mov    %rax,%rcx
 18e2e23:	48 c1 e9 1b          	shr    $0x1b,%rcx
 18e2e27:	48 31 c1             	xor    %rax,%rcx
 18e2e2a:	48 b8 eb 11 31 13 bb 49 d0 94 	movabs $0x94d049bb133111eb,%rax
 18e2e34:	48 0f af c8          	imul   %rax,%rcx
 18e2e38:	48 b8 8f e3 38 8e e3 38 8e e3 	movabs $0xe38e38e38e38e38f,%rax
 18e2e42:	48 89 ca             	mov    %rcx,%rdx
 18e2e45:	48 c1 ea 1f          	shr    $0x1f,%rdx
 18e2e49:	48 31 ca             	xor    %rcx,%rdx
 18e2e4c:	c4 e2 fb f6 c0       	mulx   %rax,%rax,%rax
 18e2e51:	48 c1 e8 03          	shr    $0x3,%rax
 18e2e55:	8d 04 c0             	lea    (%rax,%rax,8),%eax
 18e2e58:	29 c2                	sub    %eax,%edx
 18e2e5a:	48 8d 87 ed 02 00 00 	lea    0x2ed(%rdi),%rax
 18e2e61:	83 c2 04             	add    $0x4,%edx
 18e2e64:	48 89 84 24 d0 00 00 00 	mov    %rax,0xd0(%rsp)
 18e2e6c:	89 97 e4 02 00 00    	mov    %edx,0x2e4(%rdi)
 18e2e72:	eb 4f                	jmp    18e2ec3 <run_backend_benchmark+0x5df3>
 18e2e74:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 18e2e80:	4d 89 fd             	mov    %r15,%r13
 18e2e83:	80 7c 24 30 00       	cmpb   $0x0,0x30(%rsp)
 18e2e88:	48 8d 35 ff e6 d3 fe 	lea    -0x12c1901(%rip),%rsi        # 62158e <foreign_touch.flags+0x17bea>
 18e2e8f:	48 8d 05 59 89 de fe 	lea    -0x12176a7(%rip),%rax        # 6cb7ef <pp_string_value.meaning+0x38237>
 18e2e96:	4c 89 f7             	mov    %r14,%rdi
 18e2e99:	48 0f 45 f0          	cmovne %rax,%rsi
 18e2e9d:	31 c0                	xor    %eax,%eax
 18e2e9f:	e8 ec ed 01 00       	call   1901c90 <tier0_text>
 18e2ea4:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 18e2eac:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 18e2eb1:	8b 87 e4 02 00 00    	mov    0x2e4(%rdi),%eax
 18e2eb7:	49 ff c1             	inc    %r9
 18e2eba:	49 39 c1             	cmp    %rax,%r9
 18e2ebd:	0f 83 a8 07 00 00    	jae    18e366b <run_backend_benchmark+0x659b>
 18e2ec3:	48 b8 15 7c 4a 7f b9 79 37 9e 	movabs $0x9e3779b97f4a7c15,%rax
 18e2ecd:	48 be eb 11 31 13 bb 49 d0 94 	movabs $0x94d049bb133111eb,%rsi
 18e2ed7:	4d 8d 7c 05 00       	lea    0x0(%r13,%rax,1),%r15
 18e2edc:	4c 89 f8             	mov    %r15,%rax
 18e2edf:	48 c1 e8 1e          	shr    $0x1e,%rax
 18e2ee3:	4c 31 f8             	xor    %r15,%rax
 18e2ee6:	49 0f af c4          	imul   %r12,%rax
 18e2eea:	48 89 c1             	mov    %rax,%rcx
 18e2eed:	48 c1 e9 1b          	shr    $0x1b,%rcx
 18e2ef1:	48 31 c1             	xor    %rax,%rcx
 18e2ef4:	48 0f af ce          	imul   %rsi,%rcx
 18e2ef8:	48 89 c8             	mov    %rcx,%rax
 18e2efb:	48 c1 e8 1f          	shr    $0x1f,%rax
 18e2eff:	48 31 c8             	xor    %rcx,%rax
 18e2f02:	48 b9 25 49 92 24 49 92 24 49 	movabs $0x4924924924924925,%rcx
 18e2f0c:	48 89 c2             	mov    %rax,%rdx
 18e2f0f:	48 d1 ea             	shr    $1,%rdx
 18e2f12:	c4 e2 f3 f6 c9       	mulx   %rcx,%rcx,%rcx
 18e2f17:	48 d1 e9             	shr    $1,%rcx
 18e2f1a:	48 89 ca             	mov    %rcx,%rdx
 18e2f1d:	48 c1 e2 04          	shl    $0x4,%rdx
 18e2f21:	48 01 c9             	add    %rcx,%rcx
 18e2f24:	48 29 d1             	sub    %rdx,%rcx
 18e2f27:	48 01 c1             	add    %rax,%rcx
 18e2f2a:	48 8d 05 9f 75 c6 fe 	lea    -0x1398a61(%rip),%rax        # 54a4d0 <tier0_generate_class.classes>
 18e2f31:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
 18e2f35:	0f b6 d8             	movzbl %al,%ebx
 18e2f38:	8d 4b fb             	lea    -0x5(%rbx),%ecx
 18e2f3b:	83 f9 04             	cmp    $0x4,%ecx
 18e2f3e:	72 09                	jb     18e2f49 <run_backend_benchmark+0x5e79>
 18e2f40:	83 fb 0a             	cmp    $0xa,%ebx
 18e2f43:	0f 85 47 02 00 00    	jne    18e3190 <run_backend_benchmark+0x60c0>
 18e2f49:	48 b9 2a f8 94 fe 72 f3 6e 3c 	movabs $0x3c6ef372fe94f82a,%rcx
 18e2f53:	49 01 cd             	add    %rcx,%r13
 18e2f56:	4c 89 e9             	mov    %r13,%rcx
 18e2f59:	48 c1 e9 1e          	shr    $0x1e,%rcx
 18e2f5d:	4d 89 ef             	mov    %r13,%r15
 18e2f60:	4c 31 e9             	xor    %r13,%rcx
 18e2f63:	49 0f af cc          	imul   %r12,%rcx
 18e2f67:	48 89 ca             	mov    %rcx,%rdx
 18e2f6a:	48 c1 ea 1b          	shr    $0x1b,%rdx
 18e2f6e:	48 31 ca             	xor    %rcx,%rdx
 18e2f71:	48 0f af d6          	imul   %rsi,%rdx
 18e2f75:	48 be c3 f5 28 5c 8f c2 f5 28 	movabs $0x28f5c28f5c28f5c3,%rsi
 18e2f7f:	48 89 d1             	mov    %rdx,%rcx
 18e2f82:	48 c1 e9 1f          	shr    $0x1f,%rcx
 18e2f86:	48 31 d1             	xor    %rdx,%rcx
 18e2f89:	48 89 ca             	mov    %rcx,%rdx
 18e2f8c:	48 c1 ea 02          	shr    $0x2,%rdx
 18e2f90:	c4 e2 eb f6 d6       	mulx   %rsi,%rdx,%rdx
 18e2f95:	42 88 84 0f 98 00 00 00 	mov    %al,0x98(%rdi,%r9,1)
 18e2f9d:	b8 01 00 00 00       	mov    $0x1,%eax
 18e2fa2:	48 c1 ea 02          	shr    $0x2,%rdx
 18e2fa6:	48 6b d2 64          	imul   $0x64,%rdx,%rdx
 18e2faa:	48 29 d1             	sub    %rdx,%rcx
 18e2fad:	48 83 f9 1e          	cmp    $0x1e,%rcx
 18e2fb1:	b9 10 00 00 00       	mov    $0x10,%ecx
 18e2fb6:	0f 92 c2             	setb   %dl
 18e2fb9:	0f 42 c1             	cmovb  %ecx,%eax
 18e2fbc:	41 89 d5             	mov    %edx,%r13d
 18e2fbf:	42 89 84 8f d8 00 00 00 	mov    %eax,0xd8(%rdi,%r9,4)
 18e2fc7:	48 8d 35 38 7d dd fe 	lea    -0x12282c8(%rip),%rsi        # 6bad06 <pp_string_value.meaning+0x2774e>
 18e2fce:	48 8d 15 df 6a cd fe 	lea    -0x1329521(%rip),%rdx        # 5b9ab4 <c_fragment_reader_cursor_tests.leaf_phases+0x58>
 18e2fd5:	4c 8d 05 93 10 e2 fe 	lea    -0x11def6d(%rip),%r8        # 70406f <pp_string_value.meaning+0x70ab7>
 18e2fdc:	4c 89 4c 24 40       	mov    %r9,0x40(%rsp)
 18e2fe1:	49 89 fe             	mov    %rdi,%r14
 18e2fe4:	8b 87 e0 01 00 00    	mov    0x1e0(%rdi),%eax
 18e2fea:	42 89 84 8f e4 01 00 00 	mov    %eax,0x1e4(%rdi,%r9,4)
 18e2ff2:	42 c6 84 0f ed 02 00 00 00 	movb   $0x0,0x2ed(%rdi,%r9,1)
 18e2ffb:	48 8d 05 7e bc 9d 00 	lea    0x9dbc7e(%rip),%rax        # 22bec80 <tier0_c_type.names>
 18e3002:	48 8b 0c d8          	mov    (%rax,%rbx,8),%rcx
 18e3006:	31 c0                	xor    %eax,%eax
 18e3008:	48 89 8c 24 b0 00 00 00 	mov    %rcx,0xb0(%rsp)
 18e3010:	e8 7b ec 01 00       	call   1901c90 <tier0_text>
 18e3015:	4c 89 f7             	mov    %r14,%rdi
 18e3018:	45 84 ed             	test   %r13b,%r13b
 18e301b:	74 23                	je     18e3040 <run_backend_benchmark+0x5f70>
 18e301d:	48 8d 35 ed 7c dd fe 	lea    -0x1228313(%rip),%rsi        # 6bad11 <pp_string_value.meaning+0x27759>
 18e3024:	ba 10 00 00 00       	mov    $0x10,%edx
 18e3029:	31 c0                	xor    %eax,%eax
 18e302b:	e8 60 ec 01 00       	call   1901c90 <tier0_text>
 18e3030:	eb 1c                	jmp    18e304e <run_backend_benchmark+0x5f7e>
 18e3032:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18e3040:	48 8d 35 2c 9f da fe 	lea    -0x12560d4(%rip),%rsi        # 68cf73 <fuzz_comment_end+0x432a9>
 18e3047:	31 c0                	xor    %eax,%eax
 18e3049:	e8 42 ec 01 00       	call   1901c90 <tier0_text>
 18e304e:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 18e3053:	49 b8 eb 11 31 13 bb 49 d0 94 	movabs $0x94d049bb133111eb,%r8
 18e305d:	44 89 6c 24 30       	mov    %r13d,0x30(%rsp)
 18e3062:	41 83 bc 86 d8 00 00 00 00 	cmpl   $0x0,0xd8(%r14,%rax,4)
 18e306b:	0f 84 0f fe ff ff    	je     18e2e80 <run_backend_benchmark+0x5db0>
 18e3071:	48 b8 15 7c 4a 7f b9 79 37 9e 	movabs $0x9e3779b97f4a7c15,%rax
 18e307b:	4d 8d 2c 07          	lea    (%r15,%rax,1),%r13
 18e307f:	4c 89 e8             	mov    %r13,%rax
 18e3082:	48 c1 e8 1e          	shr    $0x1e,%rax
 18e3086:	4c 89 ac 24 80 02 00 00 	mov    %r13,0x280(%rsp)
 18e308e:	4c 31 e8             	xor    %r13,%rax
 18e3091:	49 0f af c4          	imul   %r12,%rax
 18e3095:	48 89 c1             	mov    %rax,%rcx
 18e3098:	48 c1 e9 1b          	shr    $0x1b,%rcx
 18e309c:	48 31 c1             	xor    %rax,%rcx
 18e309f:	49 0f af c8          	imul   %r8,%rcx
 18e30a3:	48 89 c8             	mov    %rcx,%rax
 18e30a6:	48 c1 e8 1f          	shr    $0x1f,%rax
 18e30aa:	48 31 c8             	xor    %rcx,%rax
 18e30ad:	48 b9 cd cc cc cc cc cc cc cc 	movabs $0xcccccccccccccccd,%rcx
 18e30b7:	48 89 c2             	mov    %rax,%rdx
 18e30ba:	c4 e2 f3 f6 c9       	mulx   %rcx,%rcx,%rcx
 18e30bf:	48 c1 e9 03          	shr    $0x3,%rcx
 18e30c3:	48 01 c9             	add    %rcx,%rcx
 18e30c6:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
 18e30ca:	48 29 c8             	sub    %rcx,%rax
 18e30cd:	48 83 f8 06          	cmp    $0x6,%rax
 18e30d1:	73 6d                	jae    18e3140 <run_backend_benchmark+0x6070>
 18e30d3:	48 b9 2a f8 94 fe 72 f3 6e 3c 	movabs $0x3c6ef372fe94f82a,%rcx
 18e30dd:	49 01 cf             	add    %rcx,%r15
 18e30e0:	4c 89 f9             	mov    %r15,%rcx
 18e30e3:	48 c1 e9 1e          	shr    $0x1e,%rcx
 18e30e7:	4c 89 bc 24 80 02 00 00 	mov    %r15,0x280(%rsp)
 18e30ef:	4c 31 f9             	xor    %r15,%rcx
 18e30f2:	49 0f af cc          	imul   %r12,%rcx
 18e30f6:	48 89 ce             	mov    %rcx,%rsi
 18e30f9:	48 c1 ee 1b          	shr    $0x1b,%rsi
 18e30fd:	48 31 ce             	xor    %rcx,%rsi
 18e3100:	48 b9 e1 83 0f 3e f8 e0 83 0f 	movabs $0xf83e0f83e0f83e1,%rcx
 18e310a:	49 0f af f0          	imul   %r8,%rsi
 18e310e:	48 89 f2             	mov    %rsi,%rdx
 18e3111:	48 c1 ea 1f          	shr    $0x1f,%rdx
 18e3115:	48 31 f2             	xor    %rsi,%rdx
 18e3118:	c4 e2 f3 f6 c9       	mulx   %rcx,%rcx,%rcx
 18e311d:	48 d1 e9             	shr    $1,%rcx
 18e3120:	48 89 ce             	mov    %rcx,%rsi
 18e3123:	48 c1 e6 05          	shl    $0x5,%rsi
 18e3127:	48 01 ce             	add    %rcx,%rsi
 18e312a:	48 f7 de             	neg    %rsi
 18e312d:	4c 8d 64 32 f0       	lea    -0x10(%rdx,%rsi,1),%r12
 18e3132:	eb 4d                	jmp    18e3181 <run_backend_benchmark+0x60b1>
 18e3134:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 18e3140:	48 83 f8 08          	cmp    $0x8,%rax
 18e3144:	73 5f                	jae    18e31a5 <run_backend_benchmark+0x60d5>
 18e3146:	48 b9 2a f8 94 fe 72 f3 6e 3c 	movabs $0x3c6ef372fe94f82a,%rcx
 18e3150:	49 01 cf             	add    %rcx,%r15
 18e3153:	4c 89 f9             	mov    %r15,%rcx
 18e3156:	48 c1 e9 1e          	shr    $0x1e,%rcx
 18e315a:	4c 89 bc 24 80 02 00 00 	mov    %r15,0x280(%rsp)
 18e3162:	4c 31 f9             	xor    %r15,%rcx
 18e3165:	49 0f af cc          	imul   %r12,%rcx
 18e3169:	48 89 ca             	mov    %rcx,%rdx
 18e316c:	48 c1 ea 1b          	shr    $0x1b,%rdx
 18e3170:	48 31 ca             	xor    %rcx,%rdx
 18e3173:	49 0f af d0          	imul   %r8,%rdx
 18e3177:	49 89 d4             	mov    %rdx,%r12
 18e317a:	49 c1 ec 1f          	shr    $0x1f,%r12
 18e317e:	49 31 d4             	xor    %rdx,%r12
 18e3181:	4d 89 fd             	mov    %r15,%r13
 18e3184:	ff cb                	dec    %ebx
 18e3186:	83 fb 09             	cmp    $0x9,%ebx
 18e3189:	76 2f                	jbe    18e31ba <run_backend_benchmark+0x60ea>
 18e318b:	e9 70 01 00 00       	jmp    18e3300 <run_backend_benchmark+0x6230>
 18e3190:	42 88 84 0f 98 00 00 00 	mov    %al,0x98(%rdi,%r9,1)
 18e3198:	b8 01 00 00 00       	mov    $0x1,%eax
 18e319d:	45 31 ed             	xor    %r13d,%r13d
 18e31a0:	e9 1a fe ff ff       	jmp    18e2fbf <run_backend_benchmark+0x5eef>
 18e31a5:	0f 95 c1             	setne  %cl
 18e31a8:	44 0f b6 e1          	movzbl %cl,%r12d
 18e31ac:	49 f7 dc             	neg    %r12
 18e31af:	ff cb                	dec    %ebx
 18e31b1:	83 fb 09             	cmp    $0x9,%ebx
 18e31b4:	0f 87 46 01 00 00    	ja     18e3300 <run_backend_benchmark+0x6230>
 18e31ba:	48 8d 15 b3 32 c6 fe 	lea    -0x139cd4d(%rip),%rdx        # 546474 <branch_sizing_patterns+0x7e4>
 18e31c1:	48 63 0c 9a          	movslq (%rdx,%rbx,4),%rcx
 18e31c5:	48 01 d1             	add    %rdx,%rcx
 18e31c8:	ff e1                	jmp    *%rcx
 18e31ca:	4d 0f be e4          	movsbq %r12b,%r12
 18e31ce:	e9 2d 01 00 00       	jmp    18e3300 <run_backend_benchmark+0x6230>
 18e31d3:	45 89 e4             	mov    %r12d,%r12d
 18e31d6:	e9 25 01 00 00       	jmp    18e3300 <run_backend_benchmark+0x6230>
 18e31db:	45 0f b6 e4          	movzbl %r12b,%r12d
 18e31df:	e9 1c 01 00 00       	jmp    18e3300 <run_backend_benchmark+0x6230>
 18e31e4:	c4 c1 02 2a c4       	vcvtsi2ss %r12d,%xmm15,%xmm0
 18e31e9:	c5 fa 59 05 67 38 cd fe 	vmulss -0x132c799(%rip),%xmm0,%xmm0        # 5b6a58 <tier0_emit_x87.operations+0x8>
 18e31f1:	c5 fa 10 15 63 38 cd fe 	vmovss -0x132c79d(%rip),%xmm2        # 5b6a5c <tier0_emit_x87.operations+0xc>
 18e31f9:	48 83 f8 08          	cmp    $0x8,%rax
 18e31fd:	41 8b 96 e0 01 00 00 	mov    0x1e0(%r14),%edx
 18e3204:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18e3208:	48 8d 35 a5 68 cd fe 	lea    -0x132975b(%rip),%rsi        # 5b9ab4 <c_fragment_reader_cursor_tests.leaf_phases+0x58>
 18e320f:	4c 89 f7             	mov    %r14,%rdi
 18e3212:	0f 94 c1             	sete   %cl
 18e3215:	0f 92 c0             	setb   %al
 18e3218:	c5 fb 92 c9          	kmovd  %ecx,%k1
 18e321c:	49 8b 8e d8 01 00 00 	mov    0x1d8(%r14),%rcx
 18e3223:	62 f1 6e 09 10 d1    	vmovss %xmm1,%xmm2,%xmm2{%k1}
 18e3229:	c5 fb 92 c8          	kmovd  %eax,%k1
 18e322d:	62 f1 6e 09 10 d0    	vmovss %xmm0,%xmm2,%xmm2{%k1}
 18e3233:	c5 f9 7e d0          	vmovd  %xmm2,%eax
 18e3237:	c5 f8 29 54 24 60    	vmovaps %xmm2,0x60(%rsp)
 18e323d:	48 89 04 d1          	mov    %rax,(%rcx,%rdx,8)
 18e3241:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 18e3248:	31 c0                	xor    %eax,%eax
 18e324a:	e8 41 ea 01 00       	call   1901c90 <tier0_text>
 18e324f:	c5 f8 28 44 24 60    	vmovaps 0x60(%rsp),%xmm0
 18e3255:	4c 89 f7             	mov    %r14,%rdi
 18e3258:	48 8d 35 18 9d da fe 	lea    -0x12562e8(%rip),%rsi        # 68cf77 <fuzz_comment_end+0x432ad>
 18e325f:	c5 fa 5a c0          	vcvtss2sd %xmm0,%xmm0,%xmm0
 18e3263:	eb 78                	jmp    18e32dd <run_backend_benchmark+0x620d>
 18e3265:	c4 c1 03 2a c4       	vcvtsi2sd %r12d,%xmm15,%xmm0
 18e326a:	c5 fb 59 05 36 34 cd fe 	vmulsd -0x132cbca(%rip),%xmm0,%xmm0        # 5b66a8 <x86_semantics_benchmark_code.registers+0xb0>
 18e3272:	c5 fb 10 15 36 34 cd fe 	vmovsd -0x132cbca(%rip),%xmm2        # 5b66b0 <x86_semantics_benchmark_code.registers+0xb8>
 18e327a:	48 83 f8 08          	cmp    $0x8,%rax
 18e327e:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18e3282:	48 8d 35 2b 68 cd fe 	lea    -0x13297d5(%rip),%rsi        # 5b9ab4 <c_fragment_reader_cursor_tests.leaf_phases+0x58>
 18e3289:	4c 89 f7             	mov    %r14,%rdi
 18e328c:	0f 94 c1             	sete   %cl
 18e328f:	0f 92 c0             	setb   %al
 18e3292:	c5 fb 92 c9          	kmovd  %ecx,%k1
 18e3296:	41 8b 8e e0 01 00 00 	mov    0x1e0(%r14),%ecx
 18e329d:	62 f1 ef 09 10 d1    	vmovsd %xmm1,%xmm2,%xmm2{%k1}
 18e32a3:	c5 fb 92 c8          	kmovd  %eax,%k1
 18e32a7:	49 8b 86 d8 01 00 00 	mov    0x1d8(%r14),%rax
 18e32ae:	62 f1 ef 09 10 d0    	vmovsd %xmm0,%xmm2,%xmm2{%k1}
 18e32b4:	c5 f9 29 54 24 60    	vmovapd %xmm2,0x60(%rsp)
 18e32ba:	c5 fb 11 14 c8       	vmovsd %xmm2,(%rax,%rcx,8)
 18e32bf:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 18e32c6:	31 c0                	xor    %eax,%eax
 18e32c8:	e8 c3 e9 01 00       	call   1901c90 <tier0_text>
 18e32cd:	c5 f8 28 44 24 60    	vmovaps 0x60(%rsp),%xmm0
 18e32d3:	48 8d 35 ba 30 d3 fe 	lea    -0x12ccf46(%rip),%rsi        # 616394 <foreign_touch.flags+0xc9f0>
 18e32da:	4c 89 f7             	mov    %r14,%rdi
 18e32dd:	b0 01                	mov    $0x1,%al
 18e32df:	e8 ac e9 01 00       	call   1901c90 <tier0_text>
 18e32e4:	eb 60                	jmp    18e3346 <run_backend_benchmark+0x6276>
 18e32e6:	4d 0f bf e4          	movswq %r12w,%r12
 18e32ea:	eb 14                	jmp    18e3300 <run_backend_benchmark+0x6230>
 18e32ec:	45 0f b7 e4          	movzwl %r12w,%r12d
 18e32f0:	eb 0e                	jmp    18e3300 <run_backend_benchmark+0x6230>
 18e32f2:	4d 63 e4             	movslq %r12d,%r12
 18e32f5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18e3300:	49 8b 86 d8 01 00 00 	mov    0x1d8(%r14),%rax
 18e3307:	41 8b 8e e0 01 00 00 	mov    0x1e0(%r14),%ecx
 18e330e:	48 8d 35 9f 67 cd fe 	lea    -0x1329861(%rip),%rsi        # 5b9ab4 <c_fragment_reader_cursor_tests.leaf_phases+0x58>
 18e3315:	4c 89 f7             	mov    %r14,%rdi
 18e3318:	4c 89 24 c8          	mov    %r12,(%rax,%rcx,8)
 18e331c:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 18e3323:	31 c0                	xor    %eax,%eax
 18e3325:	e8 66 e9 01 00       	call   1901c90 <tier0_text>
 18e332a:	48 8b 94 24 b0 00 00 00 	mov    0xb0(%rsp),%rdx
 18e3332:	48 8d 35 ad bd ce fe 	lea    -0x1314253(%rip),%rsi        # 5cf0e6 <parse_test_openers+0xd922>
 18e3339:	4c 89 f7             	mov    %r14,%rdi
 18e333c:	4c 89 e1             	mov    %r12,%rcx
 18e333f:	31 c0                	xor    %eax,%eax
 18e3341:	e8 4a e9 01 00       	call   1901c90 <tier0_text>
 18e3346:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 18e334b:	49 bc b9 e5 e4 1c 6d 47 58 bf 	movabs $0xbf58476d1ce4e5b9,%r12
 18e3355:	49 b8 eb 11 31 13 bb 49 d0 94 	movabs $0x94d049bb133111eb,%r8
 18e335f:	41 83 bc 86 d8 00 00 00 02 	cmpl   $0x2,0xd8(%r14,%rax,4)
 18e3368:	0f 82 15 fb ff ff    	jb     18e2e83 <run_backend_benchmark+0x5db3>
 18e336e:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 18e3374:	eb 7a                	jmp    18e33f0 <run_backend_benchmark+0x6320>
 18e3376:	45 89 e4             	mov    %r12d,%r12d
 18e3379:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18e3380:	49 8b 86 d8 01 00 00 	mov    0x1d8(%r14),%rax
 18e3387:	41 8b 8e e0 01 00 00 	mov    0x1e0(%r14),%ecx
 18e338e:	48 8d 35 78 f7 d4 fe 	lea    -0x12b0888(%rip),%rsi        # 632b0d <foreign_touch.flags+0x29169>
 18e3395:	4c 89 f7             	mov    %r14,%rdi
 18e3398:	4c 89 24 c8          	mov    %r12,(%rax,%rcx,8)
 18e339c:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 18e33a3:	31 c0                	xor    %eax,%eax
 18e33a5:	e8 e6 e8 01 00       	call   1901c90 <tier0_text>
 18e33aa:	48 8b 94 24 b0 00 00 00 	mov    0xb0(%rsp),%rdx
 18e33b2:	48 8d 35 2d bd ce fe 	lea    -0x13142d3(%rip),%rsi        # 5cf0e6 <parse_test_openers+0xd922>
 18e33b9:	4c 89 f7             	mov    %r14,%rdi
 18e33bc:	4c 89 e1             	mov    %r12,%rcx
 18e33bf:	31 c0                	xor    %eax,%eax
 18e33c1:	e8 ca e8 01 00       	call   1901c90 <tier0_text>
 18e33c6:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 18e33cb:	41 ff c7             	inc    %r15d
 18e33ce:	49 bc b9 e5 e4 1c 6d 47 58 bf 	movabs $0xbf58476d1ce4e5b9,%r12
 18e33d8:	49 b8 eb 11 31 13 bb 49 d0 94 	movabs $0x94d049bb133111eb,%r8
 18e33e2:	45 3b bc 86 d8 00 00 00 	cmp    0xd8(%r14,%rax,4),%r15d
 18e33ea:	0f 83 93 fa ff ff    	jae    18e2e83 <run_backend_benchmark+0x5db3>
 18e33f0:	48 b8 15 7c 4a 7f b9 79 37 9e 	movabs $0x9e3779b97f4a7c15,%rax
 18e33fa:	48 be cd cc cc cc cc cc cc cc 	movabs $0xcccccccccccccccd,%rsi
 18e3404:	49 8d 4c 05 00       	lea    0x0(%r13,%rax,1),%rcx
 18e3409:	48 89 c8             	mov    %rcx,%rax
 18e340c:	48 c1 e8 1e          	shr    $0x1e,%rax
 18e3410:	48 89 8c 24 80 02 00 00 	mov    %rcx,0x280(%rsp)
 18e3418:	48 31 c8             	xor    %rcx,%rax
 18e341b:	49 0f af c4          	imul   %r12,%rax
 18e341f:	48 89 c2             	mov    %rax,%rdx
 18e3422:	48 c1 ea 1b          	shr    $0x1b,%rdx
 18e3426:	48 31 c2             	xor    %rax,%rdx
 18e3429:	49 0f af d0          	imul   %r8,%rdx
 18e342d:	48 89 d0             	mov    %rdx,%rax
 18e3430:	48 c1 e8 1f          	shr    $0x1f,%rax
 18e3434:	48 31 d0             	xor    %rdx,%rax
 18e3437:	48 89 c2             	mov    %rax,%rdx
 18e343a:	c4 e2 eb f6 d6       	mulx   %rsi,%rdx,%rdx
 18e343f:	48 c1 ea 03          	shr    $0x3,%rdx
 18e3443:	48 01 d2             	add    %rdx,%rdx
 18e3446:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
 18e344a:	48 29 d0             	sub    %rdx,%rax
 18e344d:	48 83 f8 05          	cmp    $0x5,%rax
 18e3451:	77 6d                	ja     18e34c0 <run_backend_benchmark+0x63f0>
 18e3453:	48 b9 2a f8 94 fe 72 f3 6e 3c 	movabs $0x3c6ef372fe94f82a,%rcx
 18e345d:	49 01 cd             	add    %rcx,%r13
 18e3460:	4c 89 e9             	mov    %r13,%rcx
 18e3463:	48 c1 e9 1e          	shr    $0x1e,%rcx
 18e3467:	4c 89 ac 24 80 02 00 00 	mov    %r13,0x280(%rsp)
 18e346f:	4c 31 e9             	xor    %r13,%rcx
 18e3472:	49 0f af cc          	imul   %r12,%rcx
 18e3476:	48 89 ce             	mov    %rcx,%rsi
 18e3479:	48 c1 ee 1b          	shr    $0x1b,%rsi
 18e347d:	48 31 ce             	xor    %rcx,%rsi
 18e3480:	48 b9 e1 83 0f 3e f8 e0 83 0f 	movabs $0xf83e0f83e0f83e1,%rcx
 18e348a:	49 0f af f0          	imul   %r8,%rsi
 18e348e:	48 89 f2             	mov    %rsi,%rdx
 18e3491:	48 c1 ea 1f          	shr    $0x1f,%rdx
 18e3495:	48 31 f2             	xor    %rsi,%rdx
 18e3498:	c4 e2 f3 f6 c9       	mulx   %rcx,%rcx,%rcx
 18e349d:	48 d1 e9             	shr    $1,%rcx
 18e34a0:	48 89 ce             	mov    %rcx,%rsi
 18e34a3:	48 c1 e6 05          	shl    $0x5,%rsi
 18e34a7:	48 01 ce             	add    %rcx,%rsi
 18e34aa:	48 f7 de             	neg    %rsi
 18e34ad:	4c 8d 64 32 f0       	lea    -0x10(%rdx,%rsi,1),%r12
 18e34b2:	83 fb 09             	cmp    $0x9,%ebx
 18e34b5:	76 73                	jbe    18e352a <run_backend_benchmark+0x645a>
 18e34b7:	e9 c4 fe ff ff       	jmp    18e3380 <run_backend_benchmark+0x62b0>
 18e34bc:	0f 1f 40 00          	nopl   0x0(%rax)
 18e34c0:	48 83 f8 07          	cmp    $0x7,%rax
 18e34c4:	77 4a                	ja     18e3510 <run_backend_benchmark+0x6440>
 18e34c6:	48 b9 2a f8 94 fe 72 f3 6e 3c 	movabs $0x3c6ef372fe94f82a,%rcx
 18e34d0:	49 01 cd             	add    %rcx,%r13
 18e34d3:	4c 89 e9             	mov    %r13,%rcx
 18e34d6:	48 c1 e9 1e          	shr    $0x1e,%rcx
 18e34da:	4c 89 ac 24 80 02 00 00 	mov    %r13,0x280(%rsp)
 18e34e2:	4c 31 e9             	xor    %r13,%rcx
 18e34e5:	49 0f af cc          	imul   %r12,%rcx
 18e34e9:	48 89 ca             	mov    %rcx,%rdx
 18e34ec:	48 c1 ea 1b          	shr    $0x1b,%rdx
 18e34f0:	48 31 ca             	xor    %rcx,%rdx
 18e34f3:	49 0f af d0          	imul   %r8,%rdx
 18e34f7:	49 89 d4             	mov    %rdx,%r12
 18e34fa:	49 c1 ec 1f          	shr    $0x1f,%r12
 18e34fe:	49 31 d4             	xor    %rdx,%r12
 18e3501:	83 fb 09             	cmp    $0x9,%ebx
 18e3504:	76 24                	jbe    18e352a <run_backend_benchmark+0x645a>
 18e3506:	e9 75 fe ff ff       	jmp    18e3380 <run_backend_benchmark+0x62b0>
 18e350b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18e3510:	45 31 e4             	xor    %r12d,%r12d
 18e3513:	48 83 f8 08          	cmp    $0x8,%rax
 18e3517:	49 89 cd             	mov    %rcx,%r13
 18e351a:	41 0f 95 c4          	setne  %r12b
 18e351e:	49 f7 dc             	neg    %r12
 18e3521:	83 fb 09             	cmp    $0x9,%ebx
 18e3524:	0f 87 56 fe ff ff    	ja     18e3380 <run_backend_benchmark+0x62b0>
 18e352a:	48 8d 15 6b 2f c6 fe 	lea    -0x139d095(%rip),%rdx        # 54649c <branch_sizing_patterns+0x80c>
 18e3531:	48 63 0c 9a          	movslq (%rdx,%rbx,4),%rcx
 18e3535:	48 01 d1             	add    %rdx,%rcx
 18e3538:	ff e1                	jmp    *%rcx
 18e353a:	4d 0f be e4          	movsbq %r12b,%r12
 18e353e:	e9 3d fe ff ff       	jmp    18e3380 <run_backend_benchmark+0x62b0>
 18e3543:	45 0f b6 e4          	movzbl %r12b,%r12d
 18e3547:	e9 34 fe ff ff       	jmp    18e3380 <run_backend_benchmark+0x62b0>
 18e354c:	c4 c1 02 2a c4       	vcvtsi2ss %r12d,%xmm15,%xmm0
 18e3551:	c5 fa 59 05 ff 34 cd fe 	vmulss -0x132cb01(%rip),%xmm0,%xmm0        # 5b6a58 <tier0_emit_x87.operations+0x8>
 18e3559:	c5 fa 10 15 fb 34 cd fe 	vmovss -0x132cb05(%rip),%xmm2        # 5b6a5c <tier0_emit_x87.operations+0xc>
 18e3561:	48 83 f8 08          	cmp    $0x8,%rax
 18e3565:	41 8b 96 e0 01 00 00 	mov    0x1e0(%r14),%edx
 18e356c:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18e3570:	48 8d 35 96 f5 d4 fe 	lea    -0x12b0a6a(%rip),%rsi        # 632b0d <foreign_touch.flags+0x29169>
 18e3577:	4c 89 f7             	mov    %r14,%rdi
 18e357a:	0f 94 c1             	sete   %cl
 18e357d:	0f 92 c0             	setb   %al
 18e3580:	c5 fb 92 c9          	kmovd  %ecx,%k1
 18e3584:	49 8b 8e d8 01 00 00 	mov    0x1d8(%r14),%rcx
 18e358b:	62 f1 6e 09 10 d1    	vmovss %xmm1,%xmm2,%xmm2{%k1}
 18e3591:	c5 fb 92 c8          	kmovd  %eax,%k1
 18e3595:	62 f1 6e 09 10 d0    	vmovss %xmm0,%xmm2,%xmm2{%k1}
 18e359b:	c5 f9 7e d0          	vmovd  %xmm2,%eax
 18e359f:	c5 f8 29 54 24 60    	vmovaps %xmm2,0x60(%rsp)
 18e35a5:	48 89 04 d1          	mov    %rax,(%rcx,%rdx,8)
 18e35a9:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 18e35b0:	31 c0                	xor    %eax,%eax
 18e35b2:	e8 d9 e6 01 00       	call   1901c90 <tier0_text>
 18e35b7:	c5 f8 28 44 24 60    	vmovaps 0x60(%rsp),%xmm0
 18e35bd:	4c 89 f7             	mov    %r14,%rdi
 18e35c0:	48 8d 35 b0 99 da fe 	lea    -0x1256650(%rip),%rsi        # 68cf77 <fuzz_comment_end+0x432ad>
 18e35c7:	c5 fa 5a c0          	vcvtss2sd %xmm0,%xmm0,%xmm0
 18e35cb:	eb 78                	jmp    18e3645 <run_backend_benchmark+0x6575>
 18e35cd:	c4 c1 03 2a c4       	vcvtsi2sd %r12d,%xmm15,%xmm0
 18e35d2:	c5 fb 59 05 ce 30 cd fe 	vmulsd -0x132cf32(%rip),%xmm0,%xmm0        # 5b66a8 <x86_semantics_benchmark_code.registers+0xb0>
 18e35da:	c5 fb 10 15 ce 30 cd fe 	vmovsd -0x132cf32(%rip),%xmm2        # 5b66b0 <x86_semantics_benchmark_code.registers+0xb8>
 18e35e2:	48 83 f8 08          	cmp    $0x8,%rax
 18e35e6:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18e35ea:	48 8d 35 1c f5 d4 fe 	lea    -0x12b0ae4(%rip),%rsi        # 632b0d <foreign_touch.flags+0x29169>
 18e35f1:	4c 89 f7             	mov    %r14,%rdi
 18e35f4:	0f 94 c1             	sete   %cl
 18e35f7:	0f 92 c0             	setb   %al
 18e35fa:	c5 fb 92 c9          	kmovd  %ecx,%k1
 18e35fe:	41 8b 8e e0 01 00 00 	mov    0x1e0(%r14),%ecx
 18e3605:	62 f1 ef 09 10 d1    	vmovsd %xmm1,%xmm2,%xmm2{%k1}
 18e360b:	c5 fb 92 c8          	kmovd  %eax,%k1
 18e360f:	49 8b 86 d8 01 00 00 	mov    0x1d8(%r14),%rax
 18e3616:	62 f1 ef 09 10 d0    	vmovsd %xmm0,%xmm2,%xmm2{%k1}
 18e361c:	c5 f9 29 54 24 60    	vmovapd %xmm2,0x60(%rsp)
 18e3622:	c5 fb 11 14 c8       	vmovsd %xmm2,(%rax,%rcx,8)
 18e3627:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 18e362e:	31 c0                	xor    %eax,%eax
 18e3630:	e8 5b e6 01 00       	call   1901c90 <tier0_text>
 18e3635:	c5 f8 28 44 24 60    	vmovaps 0x60(%rsp),%xmm0
 18e363b:	48 8d 35 52 2d d3 fe 	lea    -0x12cd2ae(%rip),%rsi        # 616394 <foreign_touch.flags+0xc9f0>
 18e3642:	4c 89 f7             	mov    %r14,%rdi
 18e3645:	b0 01                	mov    $0x1,%al
 18e3647:	e8 44 e6 01 00       	call   1901c90 <tier0_text>
 18e364c:	e9 75 fd ff ff       	jmp    18e33c6 <run_backend_benchmark+0x62f6>
 18e3651:	4d 0f bf e4          	movswq %r12w,%r12
 18e3655:	e9 26 fd ff ff       	jmp    18e3380 <run_backend_benchmark+0x62b0>
 18e365a:	45 0f b7 e4          	movzwl %r12w,%r12d
 18e365e:	e9 1d fd ff ff       	jmp    18e3380 <run_backend_benchmark+0x62b0>
 18e3663:	4d 63 e4             	movslq %r12d,%r12
 18e3666:	e9 15 fd ff ff       	jmp    18e3380 <run_backend_benchmark+0x62b0>
 18e366b:	48 8d 35 d8 e0 d7 fe 	lea    -0x1281f28(%rip),%rsi        # 66174a <fuzz_comment_end+0x17a80>
 18e3672:	c7 87 e8 02 00 00 ff ff ff ff 	movl   $0xffffffff,0x2e8(%rdi)
 18e367c:	31 c0                	xor    %eax,%eax
 18e367e:	4c 89 ac 24 80 02 00 00 	mov    %r13,0x280(%rsp)
 18e3686:	45 31 f6             	xor    %r14d,%r14d
 18e3689:	49 89 fc             	mov    %rdi,%r12
 18e368c:	e8 ff e5 01 00       	call   1901c90 <tier0_text>
 18e3691:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18e3696:	48 8d 1d 0b 6e c6 fe 	lea    -0x13991f5(%rip),%rbx        # 54a4a8 <tier0_program_class_type.types+0x38>
 18e369d:	4c 8d bc 24 80 02 00 00 	lea    0x280(%rsp),%r15
 18e36a5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18e36b0:	41 80 bc 24 98 0d 00 00 01 	cmpb   $0x1,0xd98(%r12)
 18e36b9:	0f 84 1e 2f 00 00    	je     18e65dd <run_backend_benchmark+0x950d>
 18e36bf:	4c 89 e7             	mov    %r12,%rdi
 18e36c2:	44 89 f6             	mov    %r14d,%esi
 18e36c5:	4c 89 fa             	mov    %r15,%rdx
 18e36c8:	48 89 d9             	mov    %rbx,%rcx
 18e36cb:	e8 b0 e8 01 00       	call   1901f80 <tier0_generate_function>
 18e36d0:	41 ff c6             	inc    %r14d
 18e36d3:	41 83 fe 08          	cmp    $0x8,%r14d
 18e36d7:	75 d7                	jne    18e36b0 <run_backend_benchmark+0x65e0>
 18e36d9:	41 80 bc 24 98 0d 00 00 00 	cmpb   $0x0,0xd98(%r12)
 18e36e2:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
 18e36ea:	0f 85 f5 2e 00 00    	jne    18e65e5 <run_backend_benchmark+0x9515>
 18e36f0:	41 8b 84 24 70 0d 00 00 	mov    0xd70(%r12),%eax
 18e36f8:	4d 89 e1             	mov    %r12,%r9
 18e36fb:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 18e3701:	48 89 84 24 90 00 00 00 	mov    %rax,0x90(%rsp)
 18e3709:	48 85 c0             	test   %rax,%rax
 18e370c:	74 2a                	je     18e3738 <run_backend_benchmark+0x6668>
 18e370e:	62 62 fd 48 59 05 a0 2f cd fe 	vpbroadcastq -0x132d060(%rip),%zmm24        # 5b66b8 <x86_semantics_benchmark_code.registers+0xc0>
 18e3718:	4c 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%r10
 18e3720:	4c 8d 3d 49 6d c6 fe 	lea    -0x13992b7(%rip),%r15        # 54a470 <tier0_program_class_type.types>
 18e3727:	83 f8 10             	cmp    $0x10,%eax
 18e372a:	73 28                	jae    18e3754 <run_backend_benchmark+0x6684>
 18e372c:	31 c0                	xor    %eax,%eax
 18e372e:	45 31 db             	xor    %r11d,%r11d
 18e3731:	31 d2                	xor    %edx,%edx
 18e3733:	e9 36 09 00 00       	jmp    18e406e <run_backend_benchmark+0x6f9e>
 18e3738:	4c 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%r10
 18e3740:	45 31 db             	xor    %r11d,%r11d
 18e3743:	ba 08 00 00 00       	mov    $0x8,%edx
 18e3748:	4c 8d 3d 21 6d c6 fe 	lea    -0x13992df(%rip),%r15        # 54a470 <tier0_program_class_type.types>
 18e374f:	e9 5e 09 00 00       	jmp    18e40b2 <run_backend_benchmark+0x6fe2>
 18e3754:	49 8d 89 70 03 00 00 	lea    0x370(%r9),%rcx
 18e375b:	62 f2 fd 48 7c c1    	vpbroadcastq %rcx,%zmm0
 18e3761:	83 f8 40             	cmp    $0x40,%eax
 18e3764:	73 0c                	jae    18e3772 <run_backend_benchmark+0x66a2>
 18e3766:	31 c0                	xor    %eax,%eax
 18e3768:	45 31 db             	xor    %r11d,%r11d
 18e376b:	31 d2                	xor    %edx,%edx
 18e376d:	e9 e3 06 00 00       	jmp    18e3e55 <run_backend_benchmark+0x6d85>
 18e3772:	62 f1 fd 48 6f 35 04 2a c6 fe 	vmovdqa64 -0x139d5fc(%rip),%zmm6        # 546180 <branch_sizing_patterns+0x4f0>
 18e377c:	62 f1 fd 48 6f 3d ba 29 c6 fe 	vmovdqa64 -0x139d646(%rip),%zmm7        # 546140 <branch_sizing_patterns+0x4b0>
 18e3786:	62 62 fd 48 59 0d 30 2f cd fe 	vpbroadcastq -0x132d0d0(%rip),%zmm25        # 5b66c0 <x86_semantics_benchmark_code.registers+0xc8>
 18e3790:	62 62 fd 48 59 15 2e 2f cd fe 	vpbroadcastq -0x132d0d2(%rip),%zmm26        # 5b66c8 <x86_semantics_benchmark_code.registers+0xd0>
 18e379a:	62 62 fd 48 59 1d 2c 2f cd fe 	vpbroadcastq -0x132d0d4(%rip),%zmm27        # 5b66d0 <x86_semantics_benchmark_code.registers+0xd8>
 18e37a4:	62 62 fd 48 59 25 2a 2f cd fe 	vpbroadcastq -0x132d0d6(%rip),%zmm28        # 5b66d8 <x86_semantics_benchmark_code.registers+0xe0>
 18e37ae:	83 e0 c0             	and    $0xffffffc0,%eax
 18e37b1:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18e37b5:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18e37ba:	c4 41 31 ef c9       	vpxor  %xmm9,%xmm9,%xmm9
 18e37bf:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
 18e37c4:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18e37c8:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18e37cc:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 18e37d0:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
 18e37d4:	48 89 c2             	mov    %rax,%rdx
 18e37d7:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18e37e0:	62 12 cd 48 40 d8    	vpmullq %zmm24,%zmm6,%zmm11
 18e37e6:	62 12 c5 48 40 e0    	vpmullq %zmm24,%zmm7,%zmm12
 18e37ec:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18e37f0:	c5 fd 46 d0          	kxnorb %k0,%k0,%k2
 18e37f4:	62 91 cd 48 d4 f4    	vpaddq %zmm28,%zmm6,%zmm6
 18e37fa:	62 91 c5 48 d4 fc    	vpaddq %zmm28,%zmm7,%zmm7
 18e3800:	48 83 c2 c0          	add    $0xffffffffffffffc0,%rdx
 18e3804:	62 51 fd 48 d4 fb    	vpaddq %zmm11,%zmm0,%zmm15
 18e380a:	62 51 fd 48 d4 ec    	vpaddq %zmm12,%zmm0,%zmm13
 18e3810:	c4 61 f9 7e ff       	vmovq  %xmm15,%rdi
 18e3815:	c4 63 f9 16 fe 01    	vpextrq $0x1,%xmm15,%rsi
 18e381b:	62 33 7d 28 39 fb 01 	vextracti32x4 $0x1,%ymm15,%xmm19
 18e3822:	62 33 7d 48 39 fd 02 	vextracti32x4 $0x2,%zmm15,%xmm21
 18e3829:	62 81 85 48 d4 d3    	vpaddq %zmm27,%zmm15,%zmm18
 18e382f:	62 81 95 48 d4 cb    	vpaddq %zmm27,%zmm13,%zmm17
 18e3835:	62 81 85 48 d4 c2    	vpaddq %zmm26,%zmm15,%zmm16
 18e383b:	62 11 95 48 d4 f2    	vpaddq %zmm26,%zmm13,%zmm14
 18e3841:	0f b6 7f 1e          	movzbl 0x1e(%rdi),%edi
 18e3845:	62 c3 fd 08 16 d3 01 	vpextrq $0x1,%xmm18,%r11
 18e384c:	62 a3 7d 28 39 d6 01 	vextracti32x4 $0x1,%ymm18,%xmm22
 18e3853:	62 a3 7d 48 39 d7 02 	vextracti32x4 $0x2,%zmm18,%xmm23
 18e385a:	62 e1 7d 08 6e e7    	vmovd  %edi,%xmm20
 18e3860:	62 e3 5d 00 20 66 1e 01 	vpinsrb $0x1,0x1e(%rsi),%xmm20,%xmm20
 18e3868:	62 e1 fd 08 7e df    	vmovq  %xmm19,%rdi
 18e386e:	62 e3 fd 08 16 de 01 	vpextrq $0x1,%xmm19,%rsi
 18e3875:	62 e3 5d 00 20 5f 1e 02 	vpinsrb $0x2,0x1e(%rdi),%xmm20,%xmm19
 18e387d:	62 e1 fd 08 7e ef    	vmovq  %xmm21,%rdi
 18e3883:	62 33 7d 48 39 fc 03 	vextracti32x4 $0x3,%zmm15,%xmm20
 18e388a:	62 11 85 48 d4 f9    	vpaddq %zmm25,%zmm15,%zmm15
 18e3890:	62 e3 65 00 20 5e 1e 03 	vpinsrb $0x3,0x1e(%rsi),%xmm19,%xmm19
 18e3898:	62 e3 fd 08 16 ee 01 	vpextrq $0x1,%xmm21,%rsi
 18e389f:	62 e3 65 00 20 5f 1e 04 	vpinsrb $0x4,0x1e(%rdi),%xmm19,%xmm19
 18e38a7:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18e38ad:	62 e3 65 00 20 5e 1e 05 	vpinsrb $0x5,0x1e(%rsi),%xmm19,%xmm19
 18e38b5:	62 e3 fd 08 16 e6 01 	vpextrq $0x1,%xmm20,%rsi
 18e38bc:	62 33 7d 28 39 ec 01 	vextracti32x4 $0x1,%ymm13,%xmm20
 18e38c3:	62 e3 65 00 20 5f 1e 06 	vpinsrb $0x6,0x1e(%rdi),%xmm19,%xmm19
 18e38cb:	c4 61 f9 7e ef       	vmovq  %xmm13,%rdi
 18e38d0:	62 e3 65 00 20 5e 1e 07 	vpinsrb $0x7,0x1e(%rsi),%xmm19,%xmm19
 18e38d8:	c4 63 f9 16 ee 01    	vpextrq $0x1,%xmm13,%rsi
 18e38de:	62 e3 65 00 20 5f 1e 08 	vpinsrb $0x8,0x1e(%rdi),%xmm19,%xmm19
 18e38e6:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18e38ec:	62 e3 65 00 20 5e 1e 09 	vpinsrb $0x9,0x1e(%rsi),%xmm19,%xmm19
 18e38f4:	62 e3 fd 08 16 e6 01 	vpextrq $0x1,%xmm20,%rsi
 18e38fb:	62 33 7d 48 39 ec 02 	vextracti32x4 $0x2,%zmm13,%xmm20
 18e3902:	62 e3 65 00 20 5f 1e 0a 	vpinsrb $0xa,0x1e(%rdi),%xmm19,%xmm19
 18e390a:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18e3910:	62 e3 65 00 20 5e 1e 0b 	vpinsrb $0xb,0x1e(%rsi),%xmm19,%xmm19
 18e3918:	62 e3 fd 08 16 e6 01 	vpextrq $0x1,%xmm20,%rsi
 18e391f:	62 33 7d 48 39 ec 03 	vextracti32x4 $0x3,%zmm13,%xmm20
 18e3926:	62 11 95 48 d4 e9    	vpaddq %zmm25,%zmm13,%zmm13
 18e392c:	62 c1 fd 08 7e e0    	vmovq  %xmm20,%r8
 18e3932:	62 e3 65 00 20 5f 1e 0c 	vpinsrb $0xc,0x1e(%rdi),%xmm19,%xmm19
 18e393a:	62 e1 fd 08 7e d7    	vmovq  %xmm18,%rdi
 18e3940:	62 a3 7d 48 39 d2 03 	vextracti32x4 $0x3,%zmm18,%xmm18
 18e3947:	0f b6 7f 1e          	movzbl 0x1e(%rdi),%edi
 18e394b:	62 e3 65 00 20 5e 1e 0d 	vpinsrb $0xd,0x1e(%rsi),%xmm19,%xmm19
 18e3953:	62 e3 fd 08 16 e6 01 	vpextrq $0x1,%xmm20,%rsi
 18e395a:	62 e1 7d 08 6e ef    	vmovd  %edi,%xmm21
 18e3960:	62 c3 55 00 20 6b 1e 01 	vpinsrb $0x1,0x1e(%r11),%xmm21,%xmm21
 18e3968:	62 e1 fd 08 7e f7    	vmovq  %xmm22,%rdi
 18e396e:	62 c3 65 00 20 58 1e 0e 	vpinsrb $0xe,0x1e(%r8),%xmm19,%xmm19
 18e3976:	62 c3 fd 08 16 c0 01 	vpextrq $0x1,%xmm16,%r8
 18e397d:	62 e3 55 00 20 6f 1e 02 	vpinsrb $0x2,0x1e(%rdi),%xmm21,%xmm21
 18e3985:	62 e3 fd 08 16 f7 01 	vpextrq $0x1,%xmm22,%rdi
 18e398c:	62 e3 55 00 20 6f 1e 03 	vpinsrb $0x3,0x1e(%rdi),%xmm21,%xmm21
 18e3994:	62 e1 fd 08 7e ff    	vmovq  %xmm23,%rdi
 18e399a:	62 e3 55 00 20 6f 1e 04 	vpinsrb $0x4,0x1e(%rdi),%xmm21,%xmm21
 18e39a2:	62 e3 fd 08 16 ff 01 	vpextrq $0x1,%xmm23,%rdi
 18e39a9:	62 e3 55 00 20 6f 1e 05 	vpinsrb $0x5,0x1e(%rdi),%xmm21,%xmm21
 18e39b1:	62 e1 fd 08 7e d7    	vmovq  %xmm18,%rdi
 18e39b7:	62 e3 55 00 20 67 1e 06 	vpinsrb $0x6,0x1e(%rdi),%xmm21,%xmm20
 18e39bf:	62 e3 fd 08 16 d7 01 	vpextrq $0x1,%xmm18,%rdi
 18e39c6:	62 a3 7d 28 39 c5 01 	vextracti32x4 $0x1,%ymm16,%xmm21
 18e39cd:	62 e3 5d 00 20 57 1e 07 	vpinsrb $0x7,0x1e(%rdi),%xmm20,%xmm18
 18e39d5:	62 e1 fd 08 7e cf    	vmovq  %xmm17,%rdi
 18e39db:	62 a3 7d 28 39 cc 01 	vextracti32x4 $0x1,%ymm17,%xmm20
 18e39e2:	62 e3 6d 00 20 57 1e 08 	vpinsrb $0x8,0x1e(%rdi),%xmm18,%xmm18
 18e39ea:	62 e3 fd 08 16 cf 01 	vpextrq $0x1,%xmm17,%rdi
 18e39f1:	62 e3 6d 00 20 57 1e 09 	vpinsrb $0x9,0x1e(%rdi),%xmm18,%xmm18
 18e39f9:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18e39ff:	62 e3 6d 00 20 57 1e 0a 	vpinsrb $0xa,0x1e(%rdi),%xmm18,%xmm18
 18e3a07:	62 e3 fd 08 16 e7 01 	vpextrq $0x1,%xmm20,%rdi
 18e3a0e:	62 a3 7d 48 39 cc 02 	vextracti32x4 $0x2,%zmm17,%xmm20
 18e3a15:	62 a3 7d 48 39 c9 03 	vextracti32x4 $0x3,%zmm17,%xmm17
 18e3a1c:	62 e3 6d 00 20 57 1e 0b 	vpinsrb $0xb,0x1e(%rdi),%xmm18,%xmm18
 18e3a24:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18e3a2a:	62 e3 6d 00 20 57 1e 0c 	vpinsrb $0xc,0x1e(%rdi),%xmm18,%xmm18
 18e3a32:	62 e3 fd 08 16 e7 01 	vpextrq $0x1,%xmm20,%rdi
 18e3a39:	62 e3 6d 00 20 57 1e 0d 	vpinsrb $0xd,0x1e(%rdi),%xmm18,%xmm18
 18e3a41:	62 e1 fd 08 7e cf    	vmovq  %xmm17,%rdi
 18e3a47:	62 e3 6d 00 20 57 1e 0e 	vpinsrb $0xe,0x1e(%rdi),%xmm18,%xmm18
 18e3a4f:	62 e1 fd 08 7e c7    	vmovq  %xmm16,%rdi
 18e3a55:	0f b6 7f 1e          	movzbl 0x1e(%rdi),%edi
 18e3a59:	62 e1 7d 08 6e e7    	vmovd  %edi,%xmm20
 18e3a5f:	62 c3 5d 00 20 60 1e 01 	vpinsrb $0x1,0x1e(%r8),%xmm20,%xmm20
 18e3a67:	62 e1 fd 08 7e ef    	vmovq  %xmm21,%rdi
 18e3a6d:	62 e3 5d 00 20 67 1e 02 	vpinsrb $0x2,0x1e(%rdi),%xmm20,%xmm20
 18e3a75:	62 e3 fd 08 16 ef 01 	vpextrq $0x1,%xmm21,%rdi
 18e3a7c:	62 a3 7d 48 39 c5 02 	vextracti32x4 $0x2,%zmm16,%xmm21
 18e3a83:	62 a3 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm16,%xmm16
 18e3a8a:	62 e3 5d 00 20 67 1e 03 	vpinsrb $0x3,0x1e(%rdi),%xmm20,%xmm20
 18e3a92:	62 e1 fd 08 7e ef    	vmovq  %xmm21,%rdi
 18e3a98:	62 e3 5d 00 20 67 1e 04 	vpinsrb $0x4,0x1e(%rdi),%xmm20,%xmm20
 18e3aa0:	62 e3 fd 08 16 ef 01 	vpextrq $0x1,%xmm21,%rdi
 18e3aa7:	62 e3 5d 00 20 67 1e 05 	vpinsrb $0x5,0x1e(%rdi),%xmm20,%xmm20
 18e3aaf:	62 e1 fd 08 7e c7    	vmovq  %xmm16,%rdi
 18e3ab5:	62 e3 5d 00 20 67 1e 06 	vpinsrb $0x6,0x1e(%rdi),%xmm20,%xmm20
 18e3abd:	62 e3 fd 08 16 c7 01 	vpextrq $0x1,%xmm16,%rdi
 18e3ac4:	62 e3 5d 00 20 47 1e 07 	vpinsrb $0x7,0x1e(%rdi),%xmm20,%xmm16
 18e3acc:	c4 61 f9 7e f7       	vmovq  %xmm14,%rdi
 18e3ad1:	62 33 7d 28 39 f4 01 	vextracti32x4 $0x1,%ymm14,%xmm20
 18e3ad8:	62 e3 7d 00 20 47 1e 08 	vpinsrb $0x8,0x1e(%rdi),%xmm16,%xmm16
 18e3ae0:	c4 63 f9 16 f7 01    	vpextrq $0x1,%xmm14,%rdi
 18e3ae6:	62 e3 7d 00 20 47 1e 09 	vpinsrb $0x9,0x1e(%rdi),%xmm16,%xmm16
 18e3aee:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18e3af4:	62 e3 7d 00 20 47 1e 0a 	vpinsrb $0xa,0x1e(%rdi),%xmm16,%xmm16
 18e3afc:	62 e3 fd 08 16 e7 01 	vpextrq $0x1,%xmm20,%rdi
 18e3b03:	62 33 7d 48 39 f4 02 	vextracti32x4 $0x2,%zmm14,%xmm20
 18e3b0a:	62 e3 7d 00 20 47 1e 0b 	vpinsrb $0xb,0x1e(%rdi),%xmm16,%xmm16
 18e3b12:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18e3b18:	62 e3 7d 00 20 47 1e 0c 	vpinsrb $0xc,0x1e(%rdi),%xmm16,%xmm16
 18e3b20:	62 e3 fd 08 16 e7 01 	vpextrq $0x1,%xmm20,%rdi
 18e3b27:	62 33 7d 48 39 f4 03 	vextracti32x4 $0x3,%zmm14,%xmm20
 18e3b2e:	62 73 7d 00 20 77 1e 0d 	vpinsrb $0xd,0x1e(%rdi),%xmm16,%xmm14
 18e3b36:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18e3b3c:	62 e3 0d 08 20 47 1e 0e 	vpinsrb $0xe,0x1e(%rdi),%xmm14,%xmm16
 18e3b44:	c4 61 f9 7e ff       	vmovq  %xmm15,%rdi
 18e3b49:	62 73 65 00 20 76 1e 0f 	vpinsrb $0xf,0x1e(%rsi),%xmm19,%xmm14
 18e3b51:	c4 63 f9 16 fe 01    	vpextrq $0x1,%xmm15,%rsi
 18e3b57:	62 33 7d 28 39 fb 01 	vextracti32x4 $0x1,%ymm15,%xmm19
 18e3b5e:	0f b6 7f 1e          	movzbl 0x1e(%rdi),%edi
 18e3b62:	62 e1 7d 08 6e ef    	vmovd  %edi,%xmm21
 18e3b68:	62 e3 55 00 20 6e 1e 01 	vpinsrb $0x1,0x1e(%rsi),%xmm21,%xmm21
 18e3b70:	62 e1 fd 08 7e df    	vmovq  %xmm19,%rdi
 18e3b76:	62 e3 fd 08 16 de 01 	vpextrq $0x1,%xmm19,%rsi
 18e3b7d:	62 33 7d 48 39 fb 02 	vextracti32x4 $0x2,%zmm15,%xmm19
 18e3b84:	62 53 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm15,%xmm15
 18e3b8b:	62 e3 55 00 20 6f 1e 02 	vpinsrb $0x2,0x1e(%rdi),%xmm21,%xmm21
 18e3b93:	62 e1 fd 08 7e df    	vmovq  %xmm19,%rdi
 18e3b99:	62 e3 55 00 20 6e 1e 03 	vpinsrb $0x3,0x1e(%rsi),%xmm21,%xmm21
 18e3ba1:	62 e3 fd 08 16 de 01 	vpextrq $0x1,%xmm19,%rsi
 18e3ba8:	62 e3 55 00 20 5f 1e 04 	vpinsrb $0x4,0x1e(%rdi),%xmm21,%xmm19
 18e3bb0:	62 e3 fd 08 16 cf 01 	vpextrq $0x1,%xmm17,%rdi
 18e3bb7:	62 e3 6d 00 20 57 1e 0f 	vpinsrb $0xf,0x1e(%rdi),%xmm18,%xmm18
 18e3bbf:	c4 61 f9 7e ff       	vmovq  %xmm15,%rdi
 18e3bc4:	62 e3 65 00 20 4e 1e 05 	vpinsrb $0x5,0x1e(%rsi),%xmm19,%xmm17
 18e3bcc:	c4 63 f9 16 fe 01    	vpextrq $0x1,%xmm15,%rsi
 18e3bd2:	62 a1 55 00 ef ed    	vpxord %xmm21,%xmm21,%xmm21
 18e3bd8:	62 73 75 00 20 7f 1e 06 	vpinsrb $0x6,0x1e(%rdi),%xmm17,%xmm15
 18e3be0:	c4 61 f9 7e ef       	vmovq  %xmm13,%rdi
 18e3be5:	62 33 7d 28 39 e9 01 	vextracti32x4 $0x1,%ymm13,%xmm17
 18e3bec:	62 a1 65 00 ef db    	vpxord %xmm19,%xmm19,%xmm19
 18e3bf2:	62 a2 7d 4a 91 9c 21 90 02 00 00 	vpgatherqd 0x290(%rcx,%zmm12,1),%ymm19{%k2}
 18e3bfd:	c4 63 01 20 7e 1e 07 	vpinsrb $0x7,0x1e(%rsi),%xmm15,%xmm15
 18e3c04:	c4 63 f9 16 ee 01    	vpextrq $0x1,%xmm13,%rsi
 18e3c0a:	c4 63 01 20 7f 1e 08 	vpinsrb $0x8,0x1e(%rdi),%xmm15,%xmm15
 18e3c11:	62 e1 fd 08 7e cf    	vmovq  %xmm17,%rdi
 18e3c17:	c4 63 01 20 7e 1e 09 	vpinsrb $0x9,0x1e(%rsi),%xmm15,%xmm15
 18e3c1e:	62 e3 fd 08 16 ce 01 	vpextrq $0x1,%xmm17,%rsi
 18e3c25:	62 33 7d 48 39 e9 02 	vextracti32x4 $0x2,%zmm13,%xmm17
 18e3c2c:	62 53 7d 48 39 ed 03 	vextracti32x4 $0x3,%zmm13,%xmm13
 18e3c33:	c4 63 01 20 7f 1e 0a 	vpinsrb $0xa,0x1e(%rdi),%xmm15,%xmm15
 18e3c3a:	62 e1 fd 08 7e cf    	vmovq  %xmm17,%rdi
 18e3c40:	c4 63 01 20 7e 1e 0b 	vpinsrb $0xb,0x1e(%rsi),%xmm15,%xmm15
 18e3c47:	62 e3 fd 08 16 ce 01 	vpextrq $0x1,%xmm17,%rsi
 18e3c4e:	62 a1 75 00 ef c9    	vpxord %xmm17,%xmm17,%xmm17
 18e3c54:	c4 63 01 20 7f 1e 0c 	vpinsrb $0xc,0x1e(%rdi),%xmm15,%xmm15
 18e3c5b:	c4 63 01 20 7e 1e 0d 	vpinsrb $0xd,0x1e(%rsi),%xmm15,%xmm15
 18e3c62:	62 e3 fd 08 16 e6 01 	vpextrq $0x1,%xmm20,%rsi
 18e3c69:	62 a1 5d 00 ef e4    	vpxord %xmm20,%xmm20,%xmm20
 18e3c6f:	62 e3 7d 00 20 46 1e 0f 	vpinsrb $0xf,0x1e(%rsi),%xmm16,%xmm16
 18e3c77:	c4 61 f9 7e ee       	vmovq  %xmm13,%rsi
 18e3c7c:	c4 63 01 20 7e 1e 0e 	vpinsrb $0xe,0x1e(%rsi),%xmm15,%xmm15
 18e3c83:	c4 63 f9 16 ee 01    	vpextrq $0x1,%xmm13,%rsi
 18e3c89:	c4 63 01 20 6e 1e 0f 	vpinsrb $0xf,0x1e(%rsi),%xmm15,%xmm13
 18e3c90:	c4 41 01 ef ff       	vpxor  %xmm15,%xmm15,%xmm15
 18e3c95:	62 32 7d 49 91 7c 21 04 	vpgatherqd 0x10(%rcx,%zmm12,1),%ymm15{%k1}
 18e3c9d:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18e3ca1:	62 a2 7d 49 91 4c 19 04 	vpgatherqd 0x10(%rcx,%zmm11,1),%ymm17{%k1}
 18e3ca9:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18e3cad:	62 a2 7d 49 91 a4 19 90 02 00 00 	vpgatherqd 0x290(%rcx,%zmm11,1),%ymm20{%k1}
 18e3cb8:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18e3cbc:	62 53 f5 40 3a ff 01 	vinserti64x4 $0x1,%ymm15,%zmm17,%zmm15
 18e3cc3:	62 a1 75 00 ef c9    	vpxord %xmm17,%xmm17,%xmm17
 18e3cc9:	62 a2 7d 49 91 8c 21 10 05 00 00 	vpgatherqd 0x510(%rcx,%zmm12,1),%ymm17{%k1}
 18e3cd4:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18e3cd8:	62 a2 7d 49 91 ac 19 10 05 00 00 	vpgatherqd 0x510(%rcx,%zmm11,1),%ymm21{%k1}
 18e3ce3:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18e3ce7:	62 a3 dd 40 3a db 01 	vinserti64x4 $0x1,%ymm19,%zmm20,%zmm19
 18e3cee:	62 a1 5d 00 ef e4    	vpxord %xmm20,%xmm20,%xmm20
 18e3cf4:	62 f1 05 48 fe ed    	vpaddd %zmm5,%zmm15,%zmm5
 18e3cfa:	62 a2 7d 49 91 a4 21 90 07 00 00 	vpgatherqd 0x790(%rcx,%zmm12,1),%ymm20{%k1}
 18e3d05:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18e3d09:	62 51 65 40 fe c0    	vpaddd %zmm8,%zmm19,%zmm8
 18e3d0f:	62 33 d5 40 3a e1 01 	vinserti64x4 $0x1,%ymm17,%zmm21,%zmm12
 18e3d16:	62 a1 75 00 ef c9    	vpxord %xmm17,%xmm17,%xmm17
 18e3d1c:	62 a2 7d 49 91 8c 19 90 07 00 00 	vpgatherqd 0x790(%rcx,%zmm11,1),%ymm17{%k1}
 18e3d27:	62 d1 55 00 71 f6 07 	vpsllw $0x7,%xmm14,%xmm21
 18e3d2e:	62 52 7d 48 31 f6    	vpmovzxbd %xmm14,%zmm14
 18e3d34:	62 b2 7e 08 29 d5    	vpmovb2m %xmm21,%k2
 18e3d3a:	62 b1 55 00 71 f0 07 	vpsllw $0x7,%xmm16,%xmm21
 18e3d41:	62 a2 7d 48 31 c0    	vpmovzxbd %xmm16,%zmm16
 18e3d47:	62 51 1d 48 fe c9    	vpaddd %zmm9,%zmm12,%zmm9
 18e3d4d:	62 b2 7e 08 29 cd    	vpmovb2m %xmm21,%k1
 18e3d53:	62 d1 75 4a fe cf    	vpaddd %zmm15,%zmm1,%zmm1{%k2}
 18e3d59:	62 d1 65 49 fe dc    	vpaddd %zmm12,%zmm3,%zmm3{%k1}
 18e3d5f:	62 d1 55 48 fa ee    	vpsubd %zmm14,%zmm5,%zmm5
 18e3d65:	62 33 f5 40 3a dc 01 	vinserti64x4 $0x1,%ymm20,%zmm17,%zmm11
 18e3d6c:	62 b1 5d 00 71 f2 07 	vpsllw $0x7,%xmm18,%xmm20
 18e3d73:	62 a2 7d 48 31 d2    	vpmovzxbd %xmm18,%zmm18
 18e3d79:	62 31 35 48 fa c8    	vpsubd %zmm16,%zmm9,%zmm9
 18e3d7f:	62 b2 7e 08 29 dc    	vpmovb2m %xmm20,%k3
 18e3d85:	62 d1 5d 00 71 f5 07 	vpsllw $0x7,%xmm13,%xmm20
 18e3d8c:	62 52 7d 48 31 ed    	vpmovzxbd %xmm13,%zmm13
 18e3d92:	62 51 25 48 fe d2    	vpaddd %zmm10,%zmm11,%zmm10
 18e3d98:	62 b2 7e 08 29 e4    	vpmovb2m %xmm20,%k4
 18e3d9e:	62 b1 6d 4b fe d3    	vpaddd %zmm19,%zmm2,%zmm2{%k3}
 18e3da4:	62 d1 5d 4c fe e3    	vpaddd %zmm11,%zmm4,%zmm4{%k4}
 18e3daa:	62 31 3d 48 fa c2    	vpsubd %zmm18,%zmm8,%zmm8
 18e3db0:	62 51 2d 48 fa d5    	vpsubd %zmm13,%zmm10,%zmm10
 18e3db6:	0f 85 24 fa ff ff    	jne    18e37e0 <run_backend_benchmark+0x6710>
 18e3dbc:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 18e3dc2:	62 f1 5d 48 fe d3    	vpaddd %zmm3,%zmm4,%zmm2
 18e3dc8:	62 f1 3d 48 fe ed    	vpaddd %zmm5,%zmm8,%zmm5
 18e3dce:	62 d1 2d 48 fe f1    	vpaddd %zmm9,%zmm10,%zmm6
 18e3dd4:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18e3ddc:	62 f1 4d 48 fe ed    	vpaddd %zmm5,%zmm6,%zmm5
 18e3de2:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 18e3de8:	62 f3 fd 48 3b ee 01 	vextracti64x4 $0x1,%zmm5,%ymm6
 18e3def:	62 f3 fd 48 3b ca 01 	vextracti64x4 $0x1,%zmm1,%ymm2
 18e3df6:	62 f1 55 48 fe ee    	vpaddd %zmm6,%zmm5,%zmm5
 18e3dfc:	62 f1 75 48 fe ca    	vpaddd %zmm2,%zmm1,%zmm1
 18e3e02:	c4 e3 7d 39 ee 01    	vextracti128 $0x1,%ymm5,%xmm6
 18e3e08:	c4 e3 7d 39 ca 01    	vextracti128 $0x1,%ymm1,%xmm2
 18e3e0e:	c5 d1 fe ee          	vpaddd %xmm6,%xmm5,%xmm5
 18e3e12:	c5 f1 fe ca          	vpaddd %xmm2,%xmm1,%xmm1
 18e3e16:	c5 f9 70 f5 ee       	vpshufd $0xee,%xmm5,%xmm6
 18e3e1b:	c5 f9 70 d1 ee       	vpshufd $0xee,%xmm1,%xmm2
 18e3e20:	c5 d1 fe ee          	vpaddd %xmm6,%xmm5,%xmm5
 18e3e24:	c5 f1 fe ca          	vpaddd %xmm2,%xmm1,%xmm1
 18e3e28:	c5 f9 70 f5 55       	vpshufd $0x55,%xmm5,%xmm6
 18e3e2d:	c5 f9 70 d1 55       	vpshufd $0x55,%xmm1,%xmm2
 18e3e32:	c5 d1 fe ee          	vpaddd %xmm6,%xmm5,%xmm5
 18e3e36:	c5 f1 fe ca          	vpaddd %xmm2,%xmm1,%xmm1
 18e3e3a:	c4 c1 79 7e eb       	vmovd  %xmm5,%r11d
 18e3e3f:	c5 f9 7e ca          	vmovd  %xmm1,%edx
 18e3e43:	39 f0                	cmp    %esi,%eax
 18e3e45:	0f 84 61 02 00 00    	je     18e40ac <run_backend_benchmark+0x6fdc>
 18e3e4b:	40 f6 c6 30          	test   $0x30,%sil
 18e3e4f:	0f 84 19 02 00 00    	je     18e406e <run_backend_benchmark+0x6f9e>
 18e3e55:	48 89 c6             	mov    %rax,%rsi
 18e3e58:	62 f2 fd 48 7c e6    	vpbroadcastq %rsi,%zmm4
 18e3e5e:	62 f1 dd 48 eb 1d d8 22 c6 fe 	vporq  -0x139dd28(%rip),%zmm4,%zmm3        # 546140 <branch_sizing_patterns+0x4b0>
 18e3e68:	62 f1 dd 48 eb 25 0e 23 c6 fe 	vporq  -0x139dcf2(%rip),%zmm4,%zmm4        # 546180 <branch_sizing_patterns+0x4f0>
 18e3e72:	62 72 fd 48 59 15 64 28 cd fe 	vpbroadcastq -0x132d79c(%rip),%zmm10        # 5b66e0 <x86_semantics_benchmark_code.registers+0xe8>
 18e3e7c:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 18e3e84:	83 e0 f0             	and    $0xfffffff0,%eax
 18e3e87:	c4 c1 79 6e d3       	vmovd  %r11d,%xmm2
 18e3e8c:	c5 f9 6e ca          	vmovd  %edx,%xmm1
 18e3e90:	48 29 c6             	sub    %rax,%rsi
 18e3e93:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18e3ea0:	62 92 dd 48 40 f0    	vpmullq %zmm24,%zmm4,%zmm6
 18e3ea6:	62 92 e5 48 40 e8    	vpmullq %zmm24,%zmm3,%zmm5
 18e3eac:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18e3eb0:	c5 fd 46 d0          	kxnorb %k0,%k0,%k2
 18e3eb4:	62 d1 dd 48 d4 e2    	vpaddq %zmm10,%zmm4,%zmm4
 18e3eba:	62 d1 e5 48 d4 da    	vpaddq %zmm10,%zmm3,%zmm3
 18e3ec0:	48 83 c6 10          	add    $0x10,%rsi
 18e3ec4:	62 f1 fd 48 d4 fe    	vpaddq %zmm6,%zmm0,%zmm7
 18e3eca:	c4 e1 f9 7e fa       	vmovq  %xmm7,%rdx
 18e3ecf:	c4 e3 f9 16 ff 01    	vpextrq $0x1,%xmm7,%rdi
 18e3ed5:	c4 c3 7d 39 f8 01    	vextracti128 $0x1,%ymm7,%xmm8
 18e3edb:	0f b6 52 1e          	movzbl 0x1e(%rdx),%edx
 18e3edf:	c5 79 6e ca          	vmovd  %edx,%xmm9
 18e3ee3:	c4 63 31 20 4f 1e 01 	vpinsrb $0x1,0x1e(%rdi),%xmm9,%xmm9
 18e3eea:	c4 61 f9 7e c2       	vmovq  %xmm8,%rdx
 18e3eef:	c4 63 f9 16 c7 01    	vpextrq $0x1,%xmm8,%rdi
 18e3ef5:	62 d3 7d 48 39 f8 02 	vextracti32x4 $0x2,%zmm7,%xmm8
 18e3efc:	62 f3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm7,%xmm7
 18e3f03:	c4 63 31 20 4a 1e 02 	vpinsrb $0x2,0x1e(%rdx),%xmm9,%xmm9
 18e3f0a:	c4 61 f9 7e c2       	vmovq  %xmm8,%rdx
 18e3f0f:	c4 63 31 20 4f 1e 03 	vpinsrb $0x3,0x1e(%rdi),%xmm9,%xmm9
 18e3f16:	c4 63 f9 16 c7 01    	vpextrq $0x1,%xmm8,%rdi
 18e3f1c:	62 71 fd 48 d4 c5    	vpaddq %zmm5,%zmm0,%zmm8
 18e3f22:	c4 63 31 20 4a 1e 04 	vpinsrb $0x4,0x1e(%rdx),%xmm9,%xmm9
 18e3f29:	c4 e3 f9 16 fa 01    	vpextrq $0x1,%xmm7,%rdx
 18e3f2f:	c4 63 31 20 4f 1e 05 	vpinsrb $0x5,0x1e(%rdi),%xmm9,%xmm9
 18e3f36:	c4 e1 f9 7e ff       	vmovq  %xmm7,%rdi
 18e3f3b:	c4 e3 31 20 7f 1e 06 	vpinsrb $0x6,0x1e(%rdi),%xmm9,%xmm7
 18e3f42:	c4 61 f9 7e c7       	vmovq  %xmm8,%rdi
 18e3f47:	c4 43 7d 39 c1 01    	vextracti128 $0x1,%ymm8,%xmm9
 18e3f4d:	c4 e3 41 20 7a 1e 07 	vpinsrb $0x7,0x1e(%rdx),%xmm7,%xmm7
 18e3f54:	c4 63 f9 16 c2 01    	vpextrq $0x1,%xmm8,%rdx
 18e3f5a:	c4 e3 41 20 7f 1e 08 	vpinsrb $0x8,0x1e(%rdi),%xmm7,%xmm7
 18e3f61:	c4 61 f9 7e cf       	vmovq  %xmm9,%rdi
 18e3f66:	c4 e3 41 20 7a 1e 09 	vpinsrb $0x9,0x1e(%rdx),%xmm7,%xmm7
 18e3f6d:	c4 63 f9 16 ca 01    	vpextrq $0x1,%xmm9,%rdx
 18e3f73:	62 53 7d 48 39 c1 02 	vextracti32x4 $0x2,%zmm8,%xmm9
 18e3f7a:	62 53 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm8,%xmm8
 18e3f81:	c4 e3 41 20 7f 1e 0a 	vpinsrb $0xa,0x1e(%rdi),%xmm7,%xmm7
 18e3f88:	c4 61 f9 7e cf       	vmovq  %xmm9,%rdi
 18e3f8d:	c4 e3 41 20 7a 1e 0b 	vpinsrb $0xb,0x1e(%rdx),%xmm7,%xmm7
 18e3f94:	c4 63 f9 16 ca 01    	vpextrq $0x1,%xmm9,%rdx
 18e3f9a:	c4 e3 41 20 7f 1e 0c 	vpinsrb $0xc,0x1e(%rdi),%xmm7,%xmm7
 18e3fa1:	c4 61 f9 7e c7       	vmovq  %xmm8,%rdi
 18e3fa6:	c4 e3 41 20 7a 1e 0d 	vpinsrb $0xd,0x1e(%rdx),%xmm7,%xmm7
 18e3fad:	c4 63 f9 16 c2 01    	vpextrq $0x1,%xmm8,%rdx
 18e3fb3:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18e3fb8:	62 72 7d 49 91 44 29 04 	vpgatherqd 0x10(%rcx,%zmm5,1),%ymm8{%k1}
 18e3fc0:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18e3fc4:	62 f2 7d 4a 91 6c 31 04 	vpgatherqd 0x10(%rcx,%zmm6,1),%ymm5{%k2}
 18e3fcc:	c4 e3 41 20 7f 1e 0e 	vpinsrb $0xe,0x1e(%rdi),%xmm7,%xmm7
 18e3fd3:	62 d3 d5 48 3a e8 01 	vinserti64x4 $0x1,%ymm8,%zmm5,%zmm5
 18e3fda:	62 f1 55 48 fe d2    	vpaddd %zmm2,%zmm5,%zmm2
 18e3fe0:	c4 e3 41 20 7a 1e 0f 	vpinsrb $0xf,0x1e(%rdx),%xmm7,%xmm7
 18e3fe7:	c5 c9 71 f7 07       	vpsllw $0x7,%xmm7,%xmm6
 18e3fec:	62 f2 7d 48 31 ff    	vpmovzxbd %xmm7,%zmm7
 18e3ff2:	62 f2 7e 08 29 ce    	vpmovb2m %xmm6,%k1
 18e3ff8:	62 f1 75 49 fe cd    	vpaddd %zmm5,%zmm1,%zmm1{%k1}
 18e3ffe:	62 f1 6d 48 fa d7    	vpsubd %zmm7,%zmm2,%zmm2
 18e4004:	0f 85 96 fe ff ff    	jne    18e3ea0 <run_backend_benchmark+0x6dd0>
 18e400a:	62 f3 fd 48 3b d0 01 	vextracti64x4 $0x1,%zmm2,%ymm0
 18e4011:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18e4017:	c4 e3 7d 39 c2 01    	vextracti128 $0x1,%ymm0,%xmm2
 18e401d:	c5 f9 fe c2          	vpaddd %xmm2,%xmm0,%xmm0
 18e4021:	c5 f9 70 d0 ee       	vpshufd $0xee,%xmm0,%xmm2
 18e4026:	c5 f9 fe c2          	vpaddd %xmm2,%xmm0,%xmm0
 18e402a:	c5 f9 70 d0 55       	vpshufd $0x55,%xmm0,%xmm2
 18e402f:	c5 f9 fe c2          	vpaddd %xmm2,%xmm0,%xmm0
 18e4033:	c4 c1 79 7e c3       	vmovd  %xmm0,%r11d
 18e4038:	62 f3 fd 48 3b c8 01 	vextracti64x4 $0x1,%zmm1,%ymm0
 18e403f:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 18e4045:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 18e404b:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 18e404f:	c5 f9 70 c8 ee       	vpshufd $0xee,%xmm0,%xmm1
 18e4054:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 18e4058:	c5 f9 70 c8 55       	vpshufd $0x55,%xmm0,%xmm1
 18e405d:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 18e4061:	c5 f9 7e c2          	vmovd  %xmm0,%edx
 18e4065:	3b 84 24 90 00 00 00 	cmp    0x90(%rsp),%eax
 18e406c:	74 3e                	je     18e40ac <run_backend_benchmark+0x6fdc>
 18e406e:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 18e4076:	48 29 c1             	sub    %rax,%rcx
 18e4079:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
 18e407d:	49 8d 84 c1 8e 03 00 00 	lea    0x38e(%r9,%rax,8),%rax
 18e4085:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18e4090:	8b 70 f2             	mov    -0xe(%rax),%esi
 18e4093:	0f b6 38             	movzbl (%rax),%edi
 18e4096:	41 01 f3             	add    %esi,%r11d
 18e4099:	41 29 fb             	sub    %edi,%r11d
 18e409c:	85 ff                	test   %edi,%edi
 18e409e:	0f 44 f7             	cmove  %edi,%esi
 18e40a1:	48 83 c0 28          	add    $0x28,%rax
 18e40a5:	01 f2                	add    %esi,%edx
 18e40a7:	48 ff c9             	dec    %rcx
 18e40aa:	75 e4                	jne    18e4090 <run_backend_benchmark+0x6fc0>
 18e40ac:	ff c2                	inc    %edx
 18e40ae:	48 c1 e2 03          	shl    $0x3,%rdx
 18e40b2:	41 8b 49 78          	mov    0x78(%r9),%ecx
 18e40b6:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 18e40be:	4b 8d 7c 2a 03       	lea    0x3(%r10,%r13,1),%rdi
 18e40c3:	4f 8d 04 2a          	lea    (%r10,%r13,1),%r8
 18e40c7:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
 18e40cb:	01 c8                	add    %ecx,%eax
 18e40cd:	8d 70 01             	lea    0x1(%rax),%esi
 18e40d0:	48 89 84 24 f0 00 00 00 	mov    %rax,0xf0(%rsp)
 18e40d8:	4c 39 c7             	cmp    %r8,%rdi
 18e40db:	73 14                	jae    18e40f1 <run_backend_benchmark+0x7021>
 18e40dd:	48 c7 44 24 60 00 00 00 00 	movq   $0x0,0x60(%rsp)
 18e40e6:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 18e40ef:	eb 5c                	jmp    18e414d <run_backend_benchmark+0x707d>
 18e40f1:	48 89 7c 24 30       	mov    %rdi,0x30(%rsp)
 18e40f6:	48 8d 04 b5 00 00 00 00 	lea    0x0(,%rsi,4),%rax
 18e40fe:	4c 29 ef             	sub    %r13,%rdi
 18e4101:	4d 89 f0             	mov    %r14,%r8
 18e4104:	49 29 f8             	sub    %rdi,%r8
 18e4107:	72 2b                	jb     18e4134 <run_backend_benchmark+0x7064>
 18e4109:	4c 39 c0             	cmp    %r8,%rax
 18e410c:	77 26                	ja     18e4134 <run_backend_benchmark+0x7064>
 18e410e:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 18e4113:	48 01 c7             	add    %rax,%rdi
 18e4116:	49 89 fa             	mov    %rdi,%r10
 18e4119:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
 18e411e:	49 01 c0             	add    %rax,%r8
 18e4121:	4c 89 c7             	mov    %r8,%rdi
 18e4124:	4c 29 ef             	sub    %r13,%rdi
 18e4127:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
 18e412c:	4d 89 f0             	mov    %r14,%r8
 18e412f:	49 29 f8             	sub    %rdi,%r8
 18e4132:	eb 09                	jmp    18e413d <run_backend_benchmark+0x706d>
 18e4134:	48 c7 44 24 60 00 00 00 00 	movq   $0x0,0x60(%rsp)
 18e413d:	4c 39 f7             	cmp    %r14,%rdi
 18e4140:	77 a4                	ja     18e40e6 <run_backend_benchmark+0x7016>
 18e4142:	4c 39 c0             	cmp    %r8,%rax
 18e4145:	77 9f                	ja     18e40e6 <run_backend_benchmark+0x7016>
 18e4147:	48 01 c7             	add    %rax,%rdi
 18e414a:	49 89 fa             	mov    %rdi,%r10
 18e414d:	49 8b 81 90 0d 00 00 	mov    0xd90(%r9),%rax
 18e4154:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 18e415a:	4c 89 94 24 a0 00 00 00 	mov    %r10,0xa0(%rsp)
 18e4162:	4c 89 9c 24 58 01 00 00 	mov    %r11,0x158(%rsp)
 18e416a:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18e416f:	4c 89 f0             	mov    %r14,%rax
 18e4172:	4c 29 d0             	sub    %r10,%rax
 18e4175:	40 0f 93 c7          	setae  %dil
 18e4179:	48 39 f0             	cmp    %rsi,%rax
 18e417c:	0f 93 c0             	setae  %al
 18e417f:	40 20 f8             	and    %dil,%al
 18e4182:	4c 0f 45 c6          	cmovne %rsi,%r8
 18e4186:	4d 01 d0             	add    %r10,%r8
 18e4189:	4f 8d 54 05 03       	lea    0x3(%r13,%r8,1),%r10
 18e418e:	4b 8d 3c 28          	lea    (%r8,%r13,1),%rdi
 18e4192:	49 83 e2 fc          	and    $0xfffffffffffffffc,%r10
 18e4196:	49 39 fa             	cmp    %rdi,%r10
 18e4199:	73 22                	jae    18e41bd <run_backend_benchmark+0x70ed>
 18e419b:	4c 89 c7             	mov    %r8,%rdi
 18e419e:	48 c7 44 24 70 00 00 00 00 	movq   $0x0,0x70(%rsp)
 18e41a7:	45 31 ed             	xor    %r13d,%r13d
 18e41aa:	48 c7 44 24 78 00 00 00 00 	movq   $0x0,0x78(%rsp)
 18e41b3:	31 f6                	xor    %esi,%esi
 18e41b5:	4d 89 ca             	mov    %r9,%r10
 18e41b8:	e9 1e 01 00 00       	jmp    18e42db <run_backend_benchmark+0x720b>
 18e41bd:	41 8b b9 90 00 00 00 	mov    0x90(%r9),%edi
 18e41c4:	4d 89 f1             	mov    %r14,%r9
 18e41c7:	45 8d 5c 3b 01       	lea    0x1(%r11,%rdi,1),%r11d
 18e41cc:	4c 89 d7             	mov    %r10,%rdi
 18e41cf:	4c 29 ef             	sub    %r13,%rdi
 18e41d2:	49 29 f9             	sub    %rdi,%r9
 18e41d5:	72 29                	jb     18e4200 <run_backend_benchmark+0x7130>
 18e41d7:	4a 8d 1c 9d 00 00 00 00 	lea    0x0(,%r11,4),%rbx
 18e41df:	4c 39 cb             	cmp    %r9,%rbx
 18e41e2:	77 1c                	ja     18e4200 <run_backend_benchmark+0x7130>
 18e41e4:	4d 89 d5             	mov    %r10,%r13
 18e41e7:	48 01 df             	add    %rbx,%rdi
 18e41ea:	49 01 da             	add    %rbx,%r10
 18e41ed:	4d 89 f1             	mov    %r14,%r9
 18e41f0:	49 89 f8             	mov    %rdi,%r8
 18e41f3:	4c 89 d7             	mov    %r10,%rdi
 18e41f6:	48 2b 7c 24 50       	sub    0x50(%rsp),%rdi
 18e41fb:	49 29 f9             	sub    %rdi,%r9
 18e41fe:	eb 03                	jmp    18e4203 <run_backend_benchmark+0x7133>
 18e4200:	45 31 ed             	xor    %r13d,%r13d
 18e4203:	4c 39 f7             	cmp    %r14,%rdi
 18e4206:	77 3e                	ja     18e4246 <run_backend_benchmark+0x7176>
 18e4208:	49 c1 e3 03          	shl    $0x3,%r11
 18e420c:	4d 39 cb             	cmp    %r9,%r11
 18e420f:	77 35                	ja     18e4246 <run_backend_benchmark+0x7176>
 18e4211:	4c 8b 4c 24 50       	mov    0x50(%rsp),%r9
 18e4216:	4c 01 df             	add    %r11,%rdi
 18e4219:	4d 8d 5c 39 03       	lea    0x3(%r9,%rdi,1),%r11
 18e421e:	4e 8d 04 0f          	lea    (%rdi,%r9,1),%r8
 18e4222:	49 83 e3 fc          	and    $0xfffffffffffffffc,%r11
 18e4226:	4d 39 c3             	cmp    %r8,%r11
 18e4229:	73 29                	jae    18e4254 <run_backend_benchmark+0x7184>
 18e422b:	4c 89 54 24 78       	mov    %r10,0x78(%rsp)
 18e4230:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18e4238:	48 c7 44 24 70 00 00 00 00 	movq   $0x0,0x70(%rsp)
 18e4241:	e9 93 00 00 00       	jmp    18e42d9 <run_backend_benchmark+0x7209>
 18e4246:	48 c7 44 24 78 00 00 00 00 	movq   $0x0,0x78(%rsp)
 18e424f:	4d 89 d3             	mov    %r10,%r11
 18e4252:	eb 14                	jmp    18e4268 <run_backend_benchmark+0x7198>
 18e4254:	49 89 f8             	mov    %rdi,%r8
 18e4257:	4c 89 df             	mov    %r11,%rdi
 18e425a:	4c 29 cf             	sub    %r9,%rdi
 18e425d:	4d 89 f1             	mov    %r14,%r9
 18e4260:	4c 89 54 24 78       	mov    %r10,0x78(%rsp)
 18e4265:	49 29 f9             	sub    %rdi,%r9
 18e4268:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18e4270:	4c 39 f7             	cmp    %r14,%rdi
 18e4273:	77 2a                	ja     18e429f <run_backend_benchmark+0x71cf>
 18e4275:	48 c1 e6 04          	shl    $0x4,%rsi
 18e4279:	4c 39 ce             	cmp    %r9,%rsi
 18e427c:	77 21                	ja     18e429f <run_backend_benchmark+0x71cf>
 18e427e:	4c 8b 4c 24 50       	mov    0x50(%rsp),%r9
 18e4283:	48 01 f7             	add    %rsi,%rdi
 18e4286:	49 8d 74 39 03       	lea    0x3(%r9,%rdi,1),%rsi
 18e428b:	4e 8d 04 0f          	lea    (%rdi,%r9,1),%r8
 18e428f:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 18e4293:	4c 39 c6             	cmp    %r8,%rsi
 18e4296:	73 15                	jae    18e42ad <run_backend_benchmark+0x71dd>
 18e4298:	4c 89 5c 24 70       	mov    %r11,0x70(%rsp)
 18e429d:	eb 3a                	jmp    18e42d9 <run_backend_benchmark+0x7209>
 18e429f:	48 c7 44 24 70 00 00 00 00 	movq   $0x0,0x70(%rsp)
 18e42a8:	4c 89 de             	mov    %r11,%rsi
 18e42ab:	eb 14                	jmp    18e42c1 <run_backend_benchmark+0x71f1>
 18e42ad:	49 89 f8             	mov    %rdi,%r8
 18e42b0:	48 89 f7             	mov    %rsi,%rdi
 18e42b3:	4c 29 cf             	sub    %r9,%rdi
 18e42b6:	4d 89 f1             	mov    %r14,%r9
 18e42b9:	4c 89 5c 24 70       	mov    %r11,0x70(%rsp)
 18e42be:	49 29 f9             	sub    %rdi,%r9
 18e42c1:	4c 39 f7             	cmp    %r14,%rdi
 18e42c4:	77 10                	ja     18e42d6 <run_backend_benchmark+0x7206>
 18e42c6:	ff c1                	inc    %ecx
 18e42c8:	48 c1 e1 02          	shl    $0x2,%rcx
 18e42cc:	4c 39 c9             	cmp    %r9,%rcx
 18e42cf:	77 05                	ja     18e42d6 <run_backend_benchmark+0x7206>
 18e42d1:	48 01 cf             	add    %rcx,%rdi
 18e42d4:	eb 05                	jmp    18e42db <run_backend_benchmark+0x720b>
 18e42d6:	4c 89 c7             	mov    %r8,%rdi
 18e42d9:	31 f6                	xor    %esi,%esi
 18e42db:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18e42e0:	4c 89 f1             	mov    %r14,%rcx
 18e42e3:	49 89 b3 08 3a 00 00 	mov    %rsi,0x3a08(%r11)
 18e42ea:	41 8b 5a 78          	mov    0x78(%r10),%ebx
 18e42ee:	4c 8b 54 24 50       	mov    0x50(%rsp),%r10
 18e42f3:	ff c3                	inc    %ebx
 18e42f5:	48 29 f9             	sub    %rdi,%rcx
 18e42f8:	41 0f 92 c0          	setb   %r8b
 18e42fc:	48 39 d9             	cmp    %rbx,%rcx
 18e42ff:	4a 8d 0c 17          	lea    (%rdi,%r10,1),%rcx
 18e4303:	41 0f 92 c1          	setb   %r9b
 18e4307:	45 08 c1             	or     %r8b,%r9b
 18e430a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 18e4310:	45 84 c9             	test   %r9b,%r9b
 18e4313:	49 0f 45 d8          	cmovne %r8,%rbx
 18e4317:	49 0f 45 c8          	cmovne %r8,%rcx
 18e431b:	48 01 fb             	add    %rdi,%rbx
 18e431e:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18e4324:	49 89 8b 40 3a 00 00 	mov    %rcx,0x3a40(%r11)
 18e432b:	74 17                	je     18e4344 <run_backend_benchmark+0x7274>
 18e432d:	4a 8d 7c 13 03       	lea    0x3(%rbx,%r10,1),%rdi
 18e4332:	4e 8d 04 13          	lea    (%rbx,%r10,1),%r8
 18e4336:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
 18e433a:	4c 39 c7             	cmp    %r8,%rdi
 18e433d:	73 2e                	jae    18e436d <run_backend_benchmark+0x729d>
 18e433f:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18e4344:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18e434c:	49 8d 93 48 3a 00 00 	lea    0x3a48(%r11),%rdx
 18e4353:	49 c7 83 48 3a 00 00 00 00 00 00 	movq   $0x0,0x3a48(%r11)
 18e435e:	31 ff                	xor    %edi,%edi
 18e4360:	48 89 94 24 b0 00 00 00 	mov    %rdx,0xb0(%rsp)
 18e4368:	e9 92 00 00 00       	jmp    18e43ff <run_backend_benchmark+0x732f>
 18e436d:	49 89 f8             	mov    %rdi,%r8
 18e4370:	4d 29 d0             	sub    %r10,%r8
 18e4373:	4d 89 f1             	mov    %r14,%r9
 18e4376:	4d 29 c1             	sub    %r8,%r9
 18e4379:	72 31                	jb     18e43ac <run_backend_benchmark+0x72dc>
 18e437b:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18e4383:	45 8b 92 90 00 00 00 	mov    0x90(%r10),%r10d
 18e438a:	41 ff c2             	inc    %r10d
 18e438d:	49 c1 e2 02          	shl    $0x2,%r10
 18e4391:	4d 39 ca             	cmp    %r9,%r10
 18e4394:	77 16                	ja     18e43ac <run_backend_benchmark+0x72dc>
 18e4396:	49 89 f9             	mov    %rdi,%r9
 18e4399:	4c 01 d7             	add    %r10,%rdi
 18e439c:	4c 89 c3             	mov    %r8,%rbx
 18e439f:	4c 01 d3             	add    %r10,%rbx
 18e43a2:	49 89 f8             	mov    %rdi,%r8
 18e43a5:	4c 2b 44 24 50       	sub    0x50(%rsp),%r8
 18e43aa:	eb 03                	jmp    18e43af <run_backend_benchmark+0x72df>
 18e43ac:	45 31 c9             	xor    %r9d,%r9d
 18e43af:	4c 8b 54 24 58       	mov    0x58(%rsp),%r10
 18e43b4:	4d 8d 9a 48 3a 00 00 	lea    0x3a48(%r10),%r11
 18e43bb:	4d 89 8a 48 3a 00 00 	mov    %r9,0x3a48(%r10)
 18e43c2:	4d 89 f1             	mov    %r14,%r9
 18e43c5:	4d 29 c1             	sub    %r8,%r9
 18e43c8:	4c 89 9c 24 b0 00 00 00 	mov    %r11,0xb0(%rsp)
 18e43d0:	72 1e                	jb     18e43f0 <run_backend_benchmark+0x7320>
 18e43d2:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18e43da:	4c 39 ca             	cmp    %r9,%rdx
 18e43dd:	77 08                	ja     18e43e7 <run_backend_benchmark+0x7317>
 18e43df:	49 01 d0             	add    %rdx,%r8
 18e43e2:	4c 89 c3             	mov    %r8,%rbx
 18e43e5:	eb 02                	jmp    18e43e9 <run_backend_benchmark+0x7319>
 18e43e7:	31 ff                	xor    %edi,%edi
 18e43e9:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18e43ee:	eb 0f                	jmp    18e43ff <run_backend_benchmark+0x732f>
 18e43f0:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18e43f5:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18e43fd:	31 ff                	xor    %edi,%edi
 18e43ff:	49 89 bb 50 3a 00 00 	mov    %rdi,0x3a50(%r11)
 18e4406:	31 d2                	xor    %edx,%edx
 18e4408:	41 80 ba ec 02 00 00 01 	cmpb   $0x1,0x2ec(%r10)
 18e4410:	75 14                	jne    18e4426 <run_backend_benchmark+0x7356>
 18e4412:	41 8b 92 e4 02 00 00 	mov    0x2e4(%r10),%edx
 18e4419:	4c 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%r8
 18e4421:	41 8d 54 10 01       	lea    0x1(%r8,%rdx,1),%edx
 18e4426:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 18e442b:	41 89 90 18 3a 00 00 	mov    %edx,0x3a18(%r8)
 18e4432:	41 80 ba ec 02 00 00 01 	cmpb   $0x1,0x2ec(%r10)
 18e443a:	75 1d                	jne    18e4459 <run_backend_benchmark+0x7389>
 18e443c:	4d 89 f1             	mov    %r14,%r9
 18e443f:	49 29 d9             	sub    %rbx,%r9
 18e4442:	72 15                	jb     18e4459 <run_backend_benchmark+0x7389>
 18e4444:	41 89 d0             	mov    %edx,%r8d
 18e4447:	4d 39 c1             	cmp    %r8,%r9
 18e444a:	72 0d                	jb     18e4459 <run_backend_benchmark+0x7389>
 18e444c:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
 18e4451:	48 01 da             	add    %rbx,%rdx
 18e4454:	4c 01 c3             	add    %r8,%rbx
 18e4457:	eb 02                	jmp    18e445b <run_backend_benchmark+0x738b>
 18e4459:	31 d2                	xor    %edx,%edx
 18e445b:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 18e4463:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 18e4468:	4c 03 44 24 50       	add    0x50(%rsp),%r8
 18e446d:	4c 89 84 24 a0 00 00 00 	mov    %r8,0xa0(%rsp)
 18e4475:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 18e447a:	49 89 90 10 3a 00 00 	mov    %rdx,0x3a10(%r8)
 18e4481:	41 0f 95 c0          	setne  %r8b
 18e4485:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
 18e448b:	0f 84 9e 20 00 00    	je     18e652f <run_backend_benchmark+0x945f>
 18e4491:	4d 85 c9             	test   %r9,%r9
 18e4494:	0f 84 95 20 00 00    	je     18e652f <run_backend_benchmark+0x945f>
 18e449a:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
 18e44a0:	0f 84 89 20 00 00    	je     18e652f <run_backend_benchmark+0x945f>
 18e44a6:	41 20 c0             	and    %al,%r8b
 18e44a9:	0f 84 80 20 00 00    	je     18e652f <run_backend_benchmark+0x945f>
 18e44af:	4d 85 ed             	test   %r13,%r13
 18e44b2:	0f 84 77 20 00 00    	je     18e652f <run_backend_benchmark+0x945f>
 18e44b8:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
 18e44be:	0f 84 6b 20 00 00    	je     18e652f <run_backend_benchmark+0x945f>
 18e44c4:	48 85 f6             	test   %rsi,%rsi
 18e44c7:	0f 84 62 20 00 00    	je     18e652f <run_backend_benchmark+0x945f>
 18e44cd:	48 85 c9             	test   %rcx,%rcx
 18e44d0:	0f 84 59 20 00 00    	je     18e652f <run_backend_benchmark+0x945f>
 18e44d6:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18e44dc:	74 1b                	je     18e44f9 <run_backend_benchmark+0x7429>
 18e44de:	48 85 ff             	test   %rdi,%rdi
 18e44e1:	0f 84 48 20 00 00    	je     18e652f <run_backend_benchmark+0x945f>
 18e44e7:	48 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%rax
 18e44ef:	48 83 38 00          	cmpq   $0x0,(%rax)
 18e44f3:	0f 84 36 20 00 00    	je     18e652f <run_backend_benchmark+0x945f>
 18e44f9:	41 0f b6 82 ec 02 00 00 	movzbl 0x2ec(%r10),%eax
 18e4501:	3c 01                	cmp    $0x1,%al
 18e4503:	75 09                	jne    18e450e <run_backend_benchmark+0x743e>
 18e4505:	48 85 d2             	test   %rdx,%rdx
 18e4508:	0f 84 21 20 00 00    	je     18e652f <run_backend_benchmark+0x945f>
 18e450e:	48 89 9c 24 10 01 00 00 	mov    %rbx,0x110(%rsp)
 18e4516:	48 8b 5c 24 58       	mov    0x58(%rsp),%rbx
 18e451b:	4c 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%r14
 18e4523:	84 c0                	test   %al,%al
 18e4525:	74 62                	je     18e4589 <run_backend_benchmark+0x74b9>
 18e4527:	c6 02 00             	movb   $0x0,(%rdx)
 18e452a:	48 8b b4 24 d0 00 00 00 	mov    0xd0(%rsp),%rsi
 18e4532:	48 8b bb 10 3a 00 00 	mov    0x3a10(%rbx),%rdi
 18e4539:	41 8b 92 e4 02 00 00 	mov    0x2e4(%r10),%edx
 18e4540:	48 ff c7             	inc    %rdi
 18e4543:	c5 f8 77             	vzeroupper
 18e4546:	e8 55 5a eb fe       	call   799fa0 <memcpy@plt>
 18e454b:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18e4553:	48 8b 83 10 3a 00 00 	mov    0x3a10(%rbx),%rax
 18e455a:	4c 89 f2             	mov    %r14,%rdx
 18e455d:	8b 89 e4 02 00 00    	mov    0x2e4(%rcx),%ecx
 18e4563:	48 8d 7c 08 01       	lea    0x1(%rax,%rcx,1),%rdi
 18e4568:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18e4570:	48 8d b1 2d 03 00 00 	lea    0x32d(%rcx),%rsi
 18e4577:	e8 24 5a eb fe       	call   799fa0 <memcpy@plt>
 18e457c:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 18e4581:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18e4589:	41 bb 00 00 00 00    	mov    $0x0,%r11d
 18e458f:	45 85 f6             	test   %r14d,%r14d
 18e4592:	0f 84 52 01 00 00    	je     18e46ea <run_backend_benchmark+0x761a>
 18e4598:	49 8d 8a 70 03 00 00 	lea    0x370(%r10),%rcx
 18e459f:	31 c0                	xor    %eax,%eax
 18e45a1:	31 d2                	xor    %edx,%edx
 18e45a3:	eb 1c                	jmp    18e45c1 <run_backend_benchmark+0x74f1>
 18e45a5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18e45b0:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 18e45b5:	48 ff c2             	inc    %rdx
 18e45b8:	4c 39 f2             	cmp    %r14,%rdx
 18e45bb:	0f 84 2b 01 00 00    	je     18e46ec <run_backend_benchmark+0x761c>
 18e45c1:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18e45c7:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
 18e45cb:	48 8d 34 f9          	lea    (%rcx,%rdi,8),%rsi
 18e45cf:	74 2f                	je     18e4600 <run_backend_benchmark+0x7530>
 18e45d1:	44 0f b6 46 1d       	movzbl 0x1d(%rsi),%r8d
 18e45d6:	49 81 f8 ff 00 00 00 	cmp    $0xff,%r8
 18e45dd:	74 21                	je     18e4600 <run_backend_benchmark+0x7530>
 18e45df:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 18e45e4:	4d 6b c0 74          	imul   $0x74,%r8,%r8
 18e45e8:	4f 8d 44 01 68       	lea    0x68(%r9,%r8,1),%r8
 18e45ed:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 18e45f2:	eb 20                	jmp    18e4614 <run_backend_benchmark+0x7544>
 18e45f4:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 18e4600:	44 8b 46 1c          	mov    0x1c(%rsi),%r8d
 18e4604:	41 80 f8 0e          	cmp    $0xe,%r8b
 18e4608:	45 0f 43 c3          	cmovae %r11d,%r8d
 18e460c:	45 0f b6 c0          	movzbl %r8b,%r8d
 18e4610:	4f 8d 04 87          	lea    (%r15,%r8,4),%r8
 18e4614:	45 8b 00             	mov    (%r8),%r8d
 18e4617:	0f b6 7c f9 1e       	movzbl 0x1e(%rcx,%rdi,8),%edi
 18e461c:	45 89 04 91          	mov    %r8d,(%r9,%rdx,4)
 18e4620:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 18e4625:	44 8b 46 10          	mov    0x10(%rsi),%r8d
 18e4629:	41 29 f8             	sub    %edi,%r8d
 18e462c:	45 89 04 91          	mov    %r8d,(%r9,%rdx,4)
 18e4630:	4c 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%r9
 18e4638:	41 c6 04 11 00       	movb   $0x0,(%r9,%rdx,1)
 18e463d:	39 7e 10             	cmp    %edi,0x10(%rsi)
 18e4640:	0f 86 6a ff ff ff    	jbe    18e45b0 <run_backend_benchmark+0x74e0>
 18e4646:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18e464c:	75 73                	jne    18e46c1 <run_backend_benchmark+0x75f1>
 18e464e:	eb 1d                	jmp    18e466d <run_backend_benchmark+0x759d>
 18e4650:	45 0f b6 c0          	movzbl %r8b,%r8d
 18e4654:	41 89 c1             	mov    %eax,%r9d
 18e4657:	ff c0                	inc    %eax
 18e4659:	ff c7                	inc    %edi
 18e465b:	47 8b 04 87          	mov    (%r15,%r8,4),%r8d
 18e465f:	47 89 44 8d 00       	mov    %r8d,0x0(%r13,%r9,4)
 18e4664:	3b 7e 10             	cmp    0x10(%rsi),%edi
 18e4667:	0f 83 43 ff ff ff    	jae    18e45b0 <run_backend_benchmark+0x74e0>
 18e466d:	44 8b 46 08          	mov    0x8(%rsi),%r8d
 18e4671:	4d 8b 4a 20          	mov    0x20(%r10),%r9
 18e4675:	41 01 f8             	add    %edi,%r8d
 18e4678:	47 0f b6 04 01       	movzbl (%r9,%r8,1),%r8d
 18e467d:	41 80 f8 0e          	cmp    $0xe,%r8b
 18e4681:	72 cd                	jb     18e4650 <run_backend_benchmark+0x7580>
 18e4683:	45 31 c0             	xor    %r8d,%r8d
 18e4686:	eb c8                	jmp    18e4650 <run_backend_benchmark+0x7580>
 18e4688:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18e4690:	4d 8b 4a 20          	mov    0x20(%r10),%r9
 18e4694:	47 0f b6 04 01       	movzbl (%r9,%r8,1),%r8d
 18e4699:	41 80 f8 0e          	cmp    $0xe,%r8b
 18e469d:	45 0f 43 c3          	cmovae %r11d,%r8d
 18e46a1:	45 0f b6 c0          	movzbl %r8b,%r8d
 18e46a5:	4f 8d 04 87          	lea    (%r15,%r8,4),%r8
 18e46a9:	45 8b 00             	mov    (%r8),%r8d
 18e46ac:	41 89 c1             	mov    %eax,%r9d
 18e46af:	ff c0                	inc    %eax
 18e46b1:	ff c7                	inc    %edi
 18e46b3:	47 89 44 8d 00       	mov    %r8d,0x0(%r13,%r9,4)
 18e46b8:	3b 7e 10             	cmp    0x10(%rsi),%edi
 18e46bb:	0f 83 ef fe ff ff    	jae    18e45b0 <run_backend_benchmark+0x74e0>
 18e46c1:	44 8b 46 08          	mov    0x8(%rsi),%r8d
 18e46c5:	4d 8b 4a 40          	mov    0x40(%r10),%r9
 18e46c9:	41 01 f8             	add    %edi,%r8d
 18e46cc:	47 0f b6 0c 01       	movzbl (%r9,%r8,1),%r9d
 18e46d1:	49 81 f9 ff 00 00 00 	cmp    $0xff,%r9
 18e46d8:	74 b6                	je     18e4690 <run_backend_benchmark+0x75c0>
 18e46da:	4c 8b 64 24 40       	mov    0x40(%rsp),%r12
 18e46df:	4d 6b c1 74          	imul   $0x74,%r9,%r8
 18e46e3:	4f 8d 44 04 68       	lea    0x68(%r12,%r8,1),%r8
 18e46e8:	eb bf                	jmp    18e46a9 <run_backend_benchmark+0x75d9>
 18e46ea:	31 c0                	xor    %eax,%eax
 18e46ec:	41 83 7a 78 00       	cmpl   $0x0,0x78(%r10)
 18e46f1:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 18e46f6:	0f 84 19 02 00 00    	je     18e4915 <run_backend_benchmark+0x7845>
 18e46fc:	49 8d 8a 70 03 00 00 	lea    0x370(%r10),%rcx
 18e4703:	31 d2                	xor    %edx,%edx
 18e4705:	eb 40                	jmp    18e4747 <run_backend_benchmark+0x7677>
 18e4707:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18e4710:	49 8b 7a 50          	mov    0x50(%r10),%rdi
 18e4714:	41 8b b2 e4 02 00 00 	mov    0x2e4(%r10),%esi
 18e471b:	8b 3c 97             	mov    (%rdi,%rdx,4),%edi
 18e471e:	8d 74 3e 01          	lea    0x1(%rsi,%rdi,1),%esi
 18e4722:	48 8b bb 08 3a 00 00 	mov    0x3a08(%rbx),%rdi
 18e4729:	89 34 97             	mov    %esi,(%rdi,%rdx,4)
 18e472c:	48 8b b3 40 3a 00 00 	mov    0x3a40(%rbx),%rsi
 18e4733:	c6 04 16 00          	movb   $0x0,(%rsi,%rdx,1)
 18e4737:	48 ff c2             	inc    %rdx
 18e473a:	41 8b 72 78          	mov    0x78(%r10),%esi
 18e473e:	48 39 f2             	cmp    %rsi,%rdx
 18e4741:	0f 83 ce 01 00 00    	jae    18e4915 <run_backend_benchmark+0x7845>
 18e4747:	49 8b 72 50          	mov    0x50(%r10),%rsi
 18e474b:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18e4751:	8b 34 96             	mov    (%rsi,%rdx,4),%esi
 18e4754:	48 8d 34 b6          	lea    (%rsi,%rsi,4),%rsi
 18e4758:	48 8d 34 f1          	lea    (%rcx,%rsi,8),%rsi
 18e475c:	74 22                	je     18e4780 <run_backend_benchmark+0x76b0>
 18e475e:	0f b6 7e 1d          	movzbl 0x1d(%rsi),%edi
 18e4762:	48 81 ff ff 00 00 00 	cmp    $0xff,%rdi
 18e4769:	74 15                	je     18e4780 <run_backend_benchmark+0x76b0>
 18e476b:	4c 8b 64 24 40       	mov    0x40(%rsp),%r12
 18e4770:	48 6b f7 74          	imul   $0x74,%rdi,%rsi
 18e4774:	49 8d 74 34 68       	lea    0x68(%r12,%rsi,1),%rsi
 18e4779:	eb 18                	jmp    18e4793 <run_backend_benchmark+0x76c3>
 18e477b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18e4780:	8b 76 1c             	mov    0x1c(%rsi),%esi
 18e4783:	40 80 fe 0e          	cmp    $0xe,%sil
 18e4787:	41 0f 43 f3          	cmovae %r11d,%esi
 18e478b:	40 0f b6 f6          	movzbl %sil,%esi
 18e478f:	49 8d 34 b7          	lea    (%r15,%rsi,4),%rsi
 18e4793:	8b 36                	mov    (%rsi),%esi
 18e4795:	41 8d 3c 16          	lea    (%r14,%rdx,1),%edi
 18e4799:	4c 8b a4 24 a0 00 00 00 	mov    0xa0(%rsp),%r12
 18e47a1:	41 89 34 b9          	mov    %esi,(%r9,%rdi,4)
 18e47a5:	49 8b 72 60          	mov    0x60(%r10),%rsi
 18e47a9:	8b 34 96             	mov    (%rsi,%rdx,4),%esi
 18e47ac:	41 89 34 b8          	mov    %esi,(%r8,%rdi,4)
 18e47b0:	41 c6 04 3c 00       	movb   $0x0,(%r12,%rdi,1)
 18e47b5:	49 8b 72 60          	mov    0x60(%r10),%rsi
 18e47b9:	83 3c 96 00          	cmpl   $0x0,(%rsi,%rdx,4)
 18e47bd:	0f 84 c1 00 00 00    	je     18e4884 <run_backend_benchmark+0x77b4>
 18e47c3:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18e47c9:	0f 84 e1 00 00 00    	je     18e48b0 <run_backend_benchmark+0x77e0>
 18e47cf:	31 f6                	xor    %esi,%esi
 18e47d1:	eb 45                	jmp    18e4818 <run_backend_benchmark+0x7748>
 18e47d3:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18e47e0:	4c 8b 64 24 40       	mov    0x40(%rsp),%r12
 18e47e5:	4d 6b c9 74          	imul   $0x74,%r9,%r9
 18e47e9:	4d 89 d6             	mov    %r10,%r14
 18e47ec:	47 8b 54 0c 68       	mov    0x68(%r12,%r9,1),%r10d
 18e47f1:	47 89 54 85 00       	mov    %r10d,0x0(%r13,%r8,4)
 18e47f6:	47 8b 4c 0c 5c       	mov    0x5c(%r12,%r9,1),%r9d
 18e47fb:	4c 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%r8
 18e4803:	ff c6                	inc    %esi
 18e4805:	4d 89 f2             	mov    %r14,%r10
 18e4808:	4d 8b 00             	mov    (%r8),%r8
 18e480b:	45 89 0c b8          	mov    %r9d,(%r8,%rdi,4)
 18e480f:	49 8b 7e 60          	mov    0x60(%r14),%rdi
 18e4813:	3b 34 97             	cmp    (%rdi,%rdx,4),%esi
 18e4816:	73 58                	jae    18e4870 <run_backend_benchmark+0x77a0>
 18e4818:	49 8b 7a 58          	mov    0x58(%r10),%rdi
 18e481c:	4d 8b 8a 88 00 00 00 	mov    0x88(%r10),%r9
 18e4823:	44 8d 04 30          	lea    (%rax,%rsi,1),%r8d
 18e4827:	45 89 c0             	mov    %r8d,%r8d
 18e482a:	8b 3c 97             	mov    (%rdi,%rdx,4),%edi
 18e482d:	01 f7                	add    %esi,%edi
 18e482f:	45 0f b6 0c 39       	movzbl (%r9,%rdi,1),%r9d
 18e4834:	49 81 f9 ff 00 00 00 	cmp    $0xff,%r9
 18e483b:	75 a3                	jne    18e47e0 <run_backend_benchmark+0x7710>
 18e483d:	4d 8b 8a 80 00 00 00 	mov    0x80(%r10),%r9
 18e4844:	4d 89 d6             	mov    %r10,%r14
 18e4847:	45 0f b6 14 39       	movzbl (%r9,%rdi,1),%r10d
 18e484c:	45 31 c9             	xor    %r9d,%r9d
 18e484f:	41 80 fa 0e          	cmp    $0xe,%r10b
 18e4853:	45 0f 43 d1          	cmovae %r9d,%r10d
 18e4857:	45 0f b6 d2          	movzbl %r10b,%r10d
 18e485b:	47 8b 14 97          	mov    (%r15,%r10,4),%r10d
 18e485f:	47 89 54 85 00       	mov    %r10d,0x0(%r13,%r8,4)
 18e4864:	eb 95                	jmp    18e47fb <run_backend_benchmark+0x772b>
 18e4866:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18e4870:	4c 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%r14
 18e4878:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 18e487d:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 18e4882:	01 f0                	add    %esi,%eax
 18e4884:	49 8b 7a 68          	mov    0x68(%r10),%rdi
 18e4888:	48 85 ff             	test   %rdi,%rdi
 18e488b:	0f 84 7f fe ff ff    	je     18e4710 <run_backend_benchmark+0x7640>
 18e4891:	31 f6                	xor    %esi,%esi
 18e4893:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
 18e4897:	0f 85 85 fe ff ff    	jne    18e4722 <run_backend_benchmark+0x7652>
 18e489d:	e9 6e fe ff ff       	jmp    18e4710 <run_backend_benchmark+0x7640>
 18e48a2:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18e48b0:	31 f6                	xor    %esi,%esi
 18e48b2:	eb 28                	jmp    18e48dc <run_backend_benchmark+0x780c>
 18e48b4:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 18e48c0:	40 0f b6 ff          	movzbl %dil,%edi
 18e48c4:	44 8d 04 30          	lea    (%rax,%rsi,1),%r8d
 18e48c8:	ff c6                	inc    %esi
 18e48ca:	41 8b 3c bf          	mov    (%r15,%rdi,4),%edi
 18e48ce:	43 89 7c 85 00       	mov    %edi,0x0(%r13,%r8,4)
 18e48d3:	49 8b 7a 60          	mov    0x60(%r10),%rdi
 18e48d7:	3b 34 97             	cmp    (%rdi,%rdx,4),%esi
 18e48da:	73 24                	jae    18e4900 <run_backend_benchmark+0x7830>
 18e48dc:	49 8b 7a 58          	mov    0x58(%r10),%rdi
 18e48e0:	4d 8b 82 80 00 00 00 	mov    0x80(%r10),%r8
 18e48e7:	8b 3c 97             	mov    (%rdi,%rdx,4),%edi
 18e48ea:	01 f7                	add    %esi,%edi
 18e48ec:	41 0f b6 3c 38       	movzbl (%r8,%rdi,1),%edi
 18e48f1:	40 80 ff 0e          	cmp    $0xe,%dil
 18e48f5:	72 c9                	jb     18e48c0 <run_backend_benchmark+0x77f0>
 18e48f7:	31 ff                	xor    %edi,%edi
 18e48f9:	eb c5                	jmp    18e48c0 <run_backend_benchmark+0x77f0>
 18e48fb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18e4900:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 18e4905:	01 f0                	add    %esi,%eax
 18e4907:	49 8b 7a 68          	mov    0x68(%r10),%rdi
 18e490b:	48 85 ff             	test   %rdi,%rdi
 18e490e:	75 81                	jne    18e4891 <run_backend_benchmark+0x77c1>
 18e4910:	e9 fb fd ff ff       	jmp    18e4710 <run_backend_benchmark+0x7640>
 18e4915:	64 48 8b 34 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%rsi
 18e491e:	48 85 f6             	test   %rsi,%rsi
 18e4921:	74 36                	je     18e4959 <run_backend_benchmark+0x7889>
 18e4923:	64 48 8b 14 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rdx
 18e492c:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18e4931:	4c 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%r9
 18e4939:	45 89 cb             	mov    %r9d,%r11d
 18e493c:	45 85 c9             	test   %r9d,%r9d
 18e493f:	0f 84 0a 02 00 00    	je     18e4b4f <run_backend_benchmark+0x7a7f>
 18e4945:	41 83 f9 08          	cmp    $0x8,%r9d
 18e4949:	0f 83 93 00 00 00    	jae    18e49e2 <run_backend_benchmark+0x7912>
 18e494f:	31 c0                	xor    %eax,%eax
 18e4951:	45 31 e4             	xor    %r12d,%r12d
 18e4954:	e9 97 01 00 00       	jmp    18e4af0 <run_backend_benchmark+0x7a20>
 18e4959:	49 be 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%r14
 18e4963:	ba 03 00 00 00       	mov    $0x3,%edx
 18e4968:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18e496d:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18e4973:	31 ff                	xor    %edi,%edi
 18e4975:	45 31 c9             	xor    %r9d,%r9d
 18e4978:	4c 89 f6             	mov    %r14,%rsi
 18e497b:	c5 f8 77             	vzeroupper
 18e497e:	e8 0d 57 eb fe       	call   79a090 <mmap@plt>
 18e4983:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18e4987:	0f 84 74 01 00 00    	je     18e4b01 <run_backend_benchmark+0x7a31>
 18e498d:	4c 8d b8 ff ff 20 00 	lea    0x20ffff(%rax),%r15
 18e4994:	ba 0f 00 00 00       	mov    $0xf,%edx
 18e4999:	48 89 c7             	mov    %rax,%rdi
 18e499c:	49 81 e7 00 00 e0 ff 	and    $0xffffffffffe00000,%r15
 18e49a3:	4d 89 fc             	mov    %r15,%r12
 18e49a6:	49 29 c4             	sub    %rax,%r12
 18e49a9:	4c 89 e6             	mov    %r12,%rsi
 18e49ac:	49 8d 9c 24 00 00 ff ff 	lea    -0x10000(%r12),%rbx
 18e49b4:	e8 87 56 eb fe       	call   79a040 <madvise@plt>
 18e49b9:	4c 89 f6             	mov    %r14,%rsi
 18e49bc:	4c 29 e6             	sub    %r12,%rsi
 18e49bf:	ba 0e 00 00 00       	mov    $0xe,%edx
 18e49c4:	4c 89 ff             	mov    %r15,%rdi
 18e49c7:	e8 74 56 eb fe       	call   79a040 <madvise@plt>
 18e49cc:	4c 89 fe             	mov    %r15,%rsi
 18e49cf:	48 81 c6 00 00 ff ff 	add    $0xffffffffffff0000,%rsi
 18e49d6:	49 8d 86 00 00 e0 ff 	lea    -0x200000(%r14),%rax
 18e49dd:	e9 25 01 00 00       	jmp    18e4b07 <run_backend_benchmark+0x7a37>
 18e49e2:	41 83 f9 20          	cmp    $0x20,%r9d
 18e49e6:	73 0a                	jae    18e49f2 <run_backend_benchmark+0x7922>
 18e49e8:	31 c0                	xor    %eax,%eax
 18e49ea:	45 31 e4             	xor    %r12d,%r12d
 18e49ed:	e9 a4 00 00 00       	jmp    18e4a96 <run_backend_benchmark+0x79c6>
 18e49f2:	44 89 d8             	mov    %r11d,%eax
 18e49f5:	83 e0 e0             	and    $0xffffffe0,%eax
 18e49f8:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18e49fc:	31 c9                	xor    %ecx,%ecx
 18e49fe:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18e4a02:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18e4a06:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 18e4a0a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 18e4a10:	62 d2 7d 48 35 6c 88 01 	vpmovzxdq 0x20(%r8,%rcx,4),%zmm5
 18e4a18:	62 d2 7d 48 35 24 88 	vpmovzxdq (%r8,%rcx,4),%zmm4
 18e4a1f:	62 d2 7d 48 35 74 88 02 	vpmovzxdq 0x40(%r8,%rcx,4),%zmm6
 18e4a27:	62 f1 f5 48 d4 cd    	vpaddq %zmm5,%zmm1,%zmm1
 18e4a2d:	62 d2 7d 48 35 6c 88 03 	vpmovzxdq 0x60(%r8,%rcx,4),%zmm5
 18e4a35:	62 f1 fd 48 d4 c4    	vpaddq %zmm4,%zmm0,%zmm0
 18e4a3b:	62 f1 ed 48 d4 d6    	vpaddq %zmm6,%zmm2,%zmm2
 18e4a41:	48 83 c1 20          	add    $0x20,%rcx
 18e4a45:	62 f1 e5 48 d4 dd    	vpaddq %zmm5,%zmm3,%zmm3
 18e4a4b:	48 39 c8             	cmp    %rcx,%rax
 18e4a4e:	75 c0                	jne    18e4a10 <run_backend_benchmark+0x7940>
 18e4a50:	62 f1 f5 48 d4 c0    	vpaddq %zmm0,%zmm1,%zmm0
 18e4a56:	62 f1 ed 48 d4 c0    	vpaddq %zmm0,%zmm2,%zmm0
 18e4a5c:	62 f1 e5 48 d4 c0    	vpaddq %zmm0,%zmm3,%zmm0
 18e4a62:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
 18e4a69:	62 f1 fd 48 d4 c1    	vpaddq %zmm1,%zmm0,%zmm0
 18e4a6f:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 18e4a75:	c5 f9 d4 c1          	vpaddq %xmm1,%xmm0,%xmm0
 18e4a79:	c5 f9 70 c8 ee       	vpshufd $0xee,%xmm0,%xmm1
 18e4a7e:	c5 f9 d4 c1          	vpaddq %xmm1,%xmm0,%xmm0
 18e4a82:	c4 c1 f9 7e c4       	vmovq  %xmm0,%r12
 18e4a87:	44 39 d8             	cmp    %r11d,%eax
 18e4a8a:	0f 84 c2 00 00 00    	je     18e4b52 <run_backend_benchmark+0x7a82>
 18e4a90:	41 f6 c3 18          	test   $0x18,%r11b
 18e4a94:	74 5a                	je     18e4af0 <run_backend_benchmark+0x7a20>
 18e4a96:	48 89 c1             	mov    %rax,%rcx
 18e4a99:	44 89 d8             	mov    %r11d,%eax
 18e4a9c:	83 e0 f8             	and    $0xfffffff8,%eax
 18e4a9f:	c4 c1 f9 6e c4       	vmovq  %r12,%xmm0
 18e4aa4:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 18e4ab0:	62 d2 7d 48 35 0c 88 	vpmovzxdq (%r8,%rcx,4),%zmm1
 18e4ab7:	48 83 c1 08          	add    $0x8,%rcx
 18e4abb:	62 f1 fd 48 d4 c1    	vpaddq %zmm1,%zmm0,%zmm0
 18e4ac1:	48 39 c8             	cmp    %rcx,%rax
 18e4ac4:	75 ea                	jne    18e4ab0 <run_backend_benchmark+0x79e0>
 18e4ac6:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
 18e4acd:	62 f1 fd 48 d4 c1    	vpaddq %zmm1,%zmm0,%zmm0
 18e4ad3:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 18e4ad9:	c5 f9 d4 c1          	vpaddq %xmm1,%xmm0,%xmm0
 18e4add:	c5 f9 70 c8 ee       	vpshufd $0xee,%xmm0,%xmm1
 18e4ae2:	c5 f9 d4 c1          	vpaddq %xmm1,%xmm0,%xmm0
 18e4ae6:	c4 c1 f9 7e c4       	vmovq  %xmm0,%r12
 18e4aeb:	44 39 d8             	cmp    %r11d,%eax
 18e4aee:	74 62                	je     18e4b52 <run_backend_benchmark+0x7a82>
 18e4af0:	41 8b 0c 80          	mov    (%r8,%rax,4),%ecx
 18e4af4:	48 ff c0             	inc    %rax
 18e4af7:	49 01 cc             	add    %rcx,%r12
 18e4afa:	49 39 c3             	cmp    %rax,%r11
 18e4afd:	75 f1                	jne    18e4af0 <run_backend_benchmark+0x7a20>
 18e4aff:	eb 51                	jmp    18e4b52 <run_backend_benchmark+0x7a82>
 18e4b01:	31 f6                	xor    %esi,%esi
 18e4b03:	31 c0                	xor    %eax,%eax
 18e4b05:	31 db                	xor    %ebx,%ebx
 18e4b07:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18e4b0c:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 18e4b11:	4c 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%r9
 18e4b19:	64 48 89 34 25 10 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff10
 18e4b22:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 18e4b2f:	64 48 89 04 25 20 ff ff ff 	mov    %rax,%fs:0xffffffffffffff20
 18e4b38:	31 d2                	xor    %edx,%edx
 18e4b3a:	64 48 89 1c 25 28 ff ff ff 	mov    %rbx,%fs:0xffffffffffffff28
 18e4b43:	45 89 cb             	mov    %r9d,%r11d
 18e4b46:	45 85 c9             	test   %r9d,%r9d
 18e4b49:	0f 85 f6 fd ff ff    	jne    18e4945 <run_backend_benchmark+0x7875>
 18e4b4f:	45 31 e4             	xor    %r12d,%r12d
 18e4b52:	48 8d 4c 32 3f       	lea    0x3f(%rdx,%rsi,1),%rcx
 18e4b57:	48 8d 04 32          	lea    (%rdx,%rsi,1),%rax
 18e4b5b:	48 89 94 24 50 01 00 00 	mov    %rdx,0x150(%rsp)
 18e4b63:	48 83 e1 c0          	and    $0xffffffffffffffc0,%rcx
 18e4b67:	48 39 c1             	cmp    %rax,%rcx
 18e4b6a:	0f 83 9c 09 00 00    	jae    18e550c <run_backend_benchmark+0x843c>
 18e4b70:	48 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%rdx
 18e4b78:	48 8d 8c 24 80 0e 00 00 	lea    0xe80(%rsp),%rcx
 18e4b80:	45 85 c9             	test   %r9d,%r9d
 18e4b83:	0f 84 9c 00 00 00    	je     18e4c25 <run_backend_benchmark+0x7b55>
 18e4b89:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
 18e4b8e:	45 31 f6             	xor    %r14d,%r14d
 18e4b91:	45 31 ff             	xor    %r15d,%r15d
 18e4b94:	4c 89 9c 24 d0 00 00 00 	mov    %r11,0xd0(%rsp)
 18e4b9c:	4c 89 ac 24 c0 00 00 00 	mov    %r13,0xc0(%rsp)
 18e4ba4:	48 8d 58 08          	lea    0x8(%rax),%rbx
 18e4ba8:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18e4bb0:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
 18e4bb5:	47 8b 24 b0          	mov    (%r8,%r14,4),%r12d
 18e4bb9:	45 31 c0             	xor    %r8d,%r8d
 18e4bbc:	42 80 3c 32 00       	cmpb   $0x0,(%rdx,%r14,1)
 18e4bc1:	4b 8d 74 bd 00       	lea    0x0(%r13,%r15,4),%rsi
 18e4bc6:	49 89 cd             	mov    %rcx,%r13
 18e4bc9:	48 89 cf             	mov    %rcx,%rdi
 18e4bcc:	46 8b 0c b0          	mov    (%rax,%r14,4),%r9d
 18e4bd0:	4b 8d 04 fa          	lea    (%r10,%r15,8),%rax
 18e4bd4:	41 0f 95 c0          	setne  %r8b
 18e4bd8:	44 89 e2             	mov    %r12d,%edx
 18e4bdb:	44 89 e1             	mov    %r12d,%ecx
 18e4bde:	48 89 04 24          	mov    %rax,(%rsp)
 18e4be2:	c5 f8 77             	vzeroupper
 18e4be5:	e8 96 bb 02 00       	call   1910780 <abi_assign_call>
 18e4bea:	4c 89 e9             	mov    %r13,%rcx
 18e4bed:	48 89 43 f8          	mov    %rax,-0x8(%rbx)
 18e4bf1:	48 89 13             	mov    %rdx,(%rbx)
 18e4bf4:	4c 8b 9c 24 d0 00 00 00 	mov    0xd0(%rsp),%r11
 18e4bfc:	4c 8b ac 24 c0 00 00 00 	mov    0xc0(%rsp),%r13
 18e4c04:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 18e4c09:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18e4c0e:	48 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%rdx
 18e4c16:	4d 01 e7             	add    %r12,%r15
 18e4c19:	49 ff c6             	inc    %r14
 18e4c1c:	48 83 c3 10          	add    $0x10,%rbx
 18e4c20:	4d 39 f3             	cmp    %r14,%r11
 18e4c23:	75 8b                	jne    18e4bb0 <run_backend_benchmark+0x7ae0>
 18e4c25:	48 8b 8c 24 50 01 00 00 	mov    0x150(%rsp),%rcx
 18e4c2d:	64 48 3b 0c 25 18 ff ff ff 	cmp    %fs:0xffffffffffffff18,%rcx
 18e4c36:	0f 87 fd 26 00 00    	ja     18e7339 <run_backend_benchmark+0xa269>
 18e4c3c:	48 8b 94 24 90 00 00 00 	mov    0x90(%rsp),%rdx
 18e4c44:	64 48 89 0c 25 18 ff ff ff 	mov    %rcx,%fs:0xffffffffffffff18
 18e4c4d:	8b 8c 24 58 01 00 00 	mov    0x158(%rsp),%ecx
 18e4c54:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
 18e4c59:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18e4c5e:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 18e4c66:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
 18e4c6a:	48 89 d0             	mov    %rdx,%rax
 18e4c6d:	48 c1 e0 04          	shl    $0x4,%rax
 18e4c71:	49 8d 0c ca          	lea    (%r10,%rcx,8),%rcx
 18e4c75:	4c 01 c0             	add    %r8,%rax
 18e4c78:	49 89 8b 28 3a 00 00 	mov    %rcx,0x3a28(%r11)
 18e4c7f:	49 89 83 38 3a 00 00 	mov    %rax,0x3a38(%r11)
 18e4c86:	85 d2                	test   %edx,%edx
 18e4c88:	0f 84 3c 0a 00 00    	je     18e56ca <run_backend_benchmark+0x85fa>
 18e4c8e:	4c 8d a7 70 03 00 00 	lea    0x370(%rdi),%r12
 18e4c95:	45 31 c9             	xor    %r9d,%r9d
 18e4c98:	45 31 ed             	xor    %r13d,%r13d
 18e4c9b:	c7 44 24 60 00 00 00 00 	movl   $0x0,0x60(%rsp)
 18e4ca3:	4c 89 a4 24 c0 00 00 00 	mov    %r12,0xc0(%rsp)
 18e4cab:	e9 e1 00 00 00       	jmp    18e4d91 <run_backend_benchmark+0x7cc1>
 18e4cb0:	89 93 b0 00 00 00    	mov    %edx,0xb0(%rbx)
 18e4cb6:	48 8b 94 24 b0 00 00 00 	mov    0xb0(%rsp),%rdx
 18e4cbe:	48 8b 12             	mov    (%rdx),%rdx
 18e4cc1:	48 89 93 a0 00 00 00 	mov    %rdx,0xa0(%rbx)
 18e4cc8:	41 8b 56 14          	mov    0x14(%r14),%edx
 18e4ccc:	48 c1 e2 02          	shl    $0x2,%rdx
 18e4cd0:	48 03 57 70          	add    0x70(%rdi),%rdx
 18e4cd4:	41 29 cd             	sub    %ecx,%r13d
 18e4cd7:	48 89 93 a8 00 00 00 	mov    %rdx,0xa8(%rbx)
 18e4cde:	49 ff c1             	inc    %r9
 18e4ce1:	41 01 c5             	add    %eax,%r13d
 18e4ce4:	41 8b 46 14          	mov    0x14(%r14),%eax
 18e4ce8:	48 c1 e0 02          	shl    $0x2,%rax
 18e4cec:	49 03 83 08 3a 00 00 	add    0x3a08(%r11),%rax
 18e4cf3:	48 89 43 48          	mov    %rax,0x48(%rbx)
 18e4cf7:	41 8b 46 14          	mov    0x14(%r14),%eax
 18e4cfb:	48 c1 e0 02          	shl    $0x2,%rax
 18e4cff:	48 03 47 58          	add    0x58(%rdi),%rax
 18e4d03:	48 89 43 50          	mov    %rax,0x50(%rbx)
 18e4d07:	41 8b 46 14          	mov    0x14(%r14),%eax
 18e4d0b:	48 c1 e0 02          	shl    $0x2,%rax
 18e4d0f:	48 03 47 60          	add    0x60(%rdi),%rax
 18e4d13:	48 89 43 58          	mov    %rax,0x58(%rbx)
 18e4d17:	41 8b 46 14          	mov    0x14(%r14),%eax
 18e4d1b:	49 03 83 40 3a 00 00 	add    0x3a40(%r11),%rax
 18e4d22:	48 89 43 60          	mov    %rax,0x60(%rbx)
 18e4d26:	41 8b 46 14          	mov    0x14(%r14),%eax
 18e4d2a:	48 c1 e0 04          	shl    $0x4,%rax
 18e4d2e:	49 03 83 38 3a 00 00 	add    0x3a38(%r11),%rax
 18e4d35:	48 89 43 68          	mov    %rax,0x68(%rbx)
 18e4d39:	49 8b 83 28 3a 00 00 	mov    0x3a28(%r11),%rax
 18e4d40:	48 89 43 70          	mov    %rax,0x70(%rbx)
 18e4d44:	48 8b 87 80 00 00 00 	mov    0x80(%rdi),%rax
 18e4d4b:	48 89 43 78          	mov    %rax,0x78(%rbx)
 18e4d4f:	41 8b 46 18          	mov    0x18(%r14),%eax
 18e4d53:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
 18e4d59:	8b 87 90 00 00 00    	mov    0x90(%rdi),%eax
 18e4d5f:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
 18e4d65:	49 8b 83 10 3a 00 00 	mov    0x3a10(%r11),%rax
 18e4d6c:	48 89 83 b8 00 00 00 	mov    %rax,0xb8(%rbx)
 18e4d73:	41 8b 83 18 3a 00 00 	mov    0x3a18(%r11),%eax
 18e4d7a:	89 83 c0 00 00 00    	mov    %eax,0xc0(%rbx)
 18e4d80:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 18e4d88:	49 39 c1             	cmp    %rax,%r9
 18e4d8b:	0f 84 e0 03 00 00    	je     18e5171 <run_backend_benchmark+0x80a1>
 18e4d91:	49 69 c9 e8 00 00 00 	imul   $0xe8,%r9,%rcx
 18e4d98:	4b 8d 04 89          	lea    (%r9,%r9,4),%rax
 18e4d9c:	4d 8d 34 c4          	lea    (%r12,%rax,8),%r14
 18e4da0:	62 d1 fe 48 7f a4 0b a8 00 00 00 	vmovdqu64 %zmm4,0xa8(%r11,%rcx,1)
 18e4dab:	62 d1 fe 48 7f 64 0b 02 	vmovdqu64 %zmm4,0x80(%r11,%rcx,1)
 18e4db3:	62 d1 fe 48 7f 64 0b 01 	vmovdqu64 %zmm4,0x40(%r11,%rcx,1)
 18e4dbb:	62 d1 fe 48 7f 24 0b 	vmovdqu64 %zmm4,(%r11,%rcx,1)
 18e4dc2:	49 8d 1c 0b          	lea    (%r11,%rcx,1),%rbx
 18e4dc6:	41 8b 14 c4          	mov    (%r12,%rax,8),%edx
 18e4dca:	48 03 17             	add    (%rdi),%rdx
 18e4dcd:	49 89 14 0b          	mov    %rdx,(%r11,%rcx,1)
 18e4dd1:	41 8b 14 c4          	mov    (%r12,%rax,8),%edx
 18e4dd5:	48 03 57 08          	add    0x8(%rdi),%rdx
 18e4dd9:	49 89 54 0b 08       	mov    %rdx,0x8(%r11,%rcx,1)
 18e4dde:	41 8b 14 c4          	mov    (%r12,%rax,8),%edx
 18e4de2:	48 c1 e2 03          	shl    $0x3,%rdx
 18e4de6:	48 03 57 10          	add    0x10(%rdi),%rdx
 18e4dea:	49 89 54 0b 10       	mov    %rdx,0x10(%r11,%rcx,1)
 18e4def:	41 8b 54 c4 04       	mov    0x4(%r12,%rax,8),%edx
 18e4df4:	41 89 54 0b 18       	mov    %edx,0x18(%r11,%rcx,1)
 18e4df9:	41 8b 54 c4 08       	mov    0x8(%r12,%rax,8),%edx
 18e4dfe:	48 03 57 20          	add    0x20(%rdi),%rdx
 18e4e02:	49 89 54 0b 20       	mov    %rdx,0x20(%r11,%rcx,1)
 18e4e07:	41 8b 54 c4 08       	mov    0x8(%r12,%rax,8),%edx
 18e4e0c:	48 03 57 28          	add    0x28(%rdi),%rdx
 18e4e10:	49 89 54 0b 28       	mov    %rdx,0x28(%r11,%rcx,1)
 18e4e15:	41 8b 4c c4 0c       	mov    0xc(%r12,%rax,8),%ecx
 18e4e1a:	48 85 c9             	test   %rcx,%rcx
 18e4e1d:	0f 84 0d 01 00 00    	je     18e4f30 <run_backend_benchmark+0x7e60>
 18e4e23:	48 8b 47 30          	mov    0x30(%rdi),%rax
 18e4e27:	48 85 c0             	test   %rax,%rax
 18e4e2a:	0f 84 00 01 00 00    	je     18e4f30 <run_backend_benchmark+0x7e60>
 18e4e30:	41 8b 56 08          	mov    0x8(%r14),%edx
 18e4e34:	83 f9 08             	cmp    $0x8,%ecx
 18e4e37:	72 1d                	jb     18e4e56 <run_backend_benchmark+0x7d86>
 18e4e39:	48 8d 71 ff          	lea    -0x1(%rcx),%rsi
 18e4e3d:	89 d7                	mov    %edx,%edi
 18e4e3f:	01 f7                	add    %esi,%edi
 18e4e41:	40 0f 92 c7          	setb   %dil
 18e4e45:	48 c1 ee 20          	shr    $0x20,%rsi
 18e4e49:	40 0f 95 c6          	setne  %sil
 18e4e4d:	40 08 fe             	or     %dil,%sil
 18e4e50:	0f 84 2b 02 00 00    	je     18e5081 <run_backend_benchmark+0x7fb1>
 18e4e56:	4d 89 cf             	mov    %r9,%r15
 18e4e59:	31 f6                	xor    %esi,%esi
 18e4e5b:	31 ff                	xor    %edi,%edi
 18e4e5d:	49 89 c9             	mov    %rcx,%r9
 18e4e60:	49 83 e1 07          	and    $0x7,%r9
 18e4e64:	49 89 f0             	mov    %rsi,%r8
 18e4e67:	74 1f                	je     18e4e88 <run_backend_benchmark+0x7db8>
 18e4e69:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18e4e70:	46 8d 14 02          	lea    (%rdx,%r8,1),%r10d
 18e4e74:	42 83 3c 90 00       	cmpl   $0x0,(%rax,%r10,4)
 18e4e79:	41 0f 95 c2          	setne  %r10b
 18e4e7d:	49 ff c0             	inc    %r8
 18e4e80:	44 08 d7             	or     %r10b,%dil
 18e4e83:	49 ff c9             	dec    %r9
 18e4e86:	75 e8                	jne    18e4e70 <run_backend_benchmark+0x7da0>
 18e4e88:	48 29 ce             	sub    %rcx,%rsi
 18e4e8b:	48 83 fe f8          	cmp    $0xfffffffffffffff8,%rsi
 18e4e8f:	77 65                	ja     18e4ef6 <run_backend_benchmark+0x7e26>
 18e4e91:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18e4ea0:	42 8d 74 02 01       	lea    0x1(%rdx,%r8,1),%esi
 18e4ea5:	46 8d 0c 02          	lea    (%rdx,%r8,1),%r9d
 18e4ea9:	46 8d 54 02 03       	lea    0x3(%rdx,%r8,1),%r10d
 18e4eae:	8b 34 b0             	mov    (%rax,%rsi,4),%esi
 18e4eb1:	42 0b 34 88          	or     (%rax,%r9,4),%esi
 18e4eb5:	46 8d 4c 02 02       	lea    0x2(%rdx,%r8,1),%r9d
 18e4eba:	42 0b 34 88          	or     (%rax,%r9,4),%esi
 18e4ebe:	46 8d 4c 02 04       	lea    0x4(%rdx,%r8,1),%r9d
 18e4ec3:	42 0b 34 90          	or     (%rax,%r10,4),%esi
 18e4ec7:	46 8d 54 02 05       	lea    0x5(%rdx,%r8,1),%r10d
 18e4ecc:	42 0b 34 88          	or     (%rax,%r9,4),%esi
 18e4ed0:	46 8d 4c 02 06       	lea    0x6(%rdx,%r8,1),%r9d
 18e4ed5:	42 0b 34 90          	or     (%rax,%r10,4),%esi
 18e4ed9:	46 8d 54 02 07       	lea    0x7(%rdx,%r8,1),%r10d
 18e4ede:	42 0b 34 88          	or     (%rax,%r9,4),%esi
 18e4ee2:	42 0b 34 90          	or     (%rax,%r10,4),%esi
 18e4ee6:	40 0f 95 c6          	setne  %sil
 18e4eea:	49 83 c0 08          	add    $0x8,%r8
 18e4eee:	40 08 f7             	or     %sil,%dil
 18e4ef1:	4c 39 c1             	cmp    %r8,%rcx
 18e4ef4:	75 aa                	jne    18e4ea0 <run_backend_benchmark+0x7dd0>
 18e4ef6:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18e4efb:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
 18e4f00:	4d 89 f9             	mov    %r15,%r9
 18e4f03:	40 f6 c7 01          	test   $0x1,%dil
 18e4f07:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 18e4f0f:	74 1f                	je     18e4f30 <run_backend_benchmark+0x7e60>
 18e4f11:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
 18e4f15:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
 18e4f1c:	41 8b 46 08          	mov    0x8(%r14),%eax
 18e4f20:	48 03 47 38          	add    0x38(%rdi),%rax
 18e4f24:	eb 17                	jmp    18e4f3d <run_backend_benchmark+0x7e6d>
 18e4f26:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18e4f30:	31 c0                	xor    %eax,%eax
 18e4f32:	48 c7 83 88 00 00 00 00 00 00 00 	movq   $0x0,0x88(%rbx)
 18e4f3d:	48 89 83 90 00 00 00 	mov    %rax,0x90(%rbx)
 18e4f44:	4d 89 cf             	mov    %r9,%r15
 18e4f47:	49 c1 e7 04          	shl    $0x4,%r15
 18e4f4b:	41 8b 46 0c          	mov    0xc(%r14),%eax
 18e4f4f:	89 43 30             	mov    %eax,0x30(%rbx)
 18e4f52:	41 8b 46 10          	mov    0x10(%r14),%eax
 18e4f56:	89 43 34             	mov    %eax,0x34(%rbx)
 18e4f59:	44 89 e8             	mov    %r13d,%eax
 18e4f5c:	49 8d 34 c2          	lea    (%r10,%rax,8),%rsi
 18e4f60:	48 89 73 38          	mov    %rsi,0x38(%rbx)
 18e4f64:	4b 8b 44 38 08       	mov    0x8(%r8,%r15,1),%rax
 18e4f69:	48 89 43 40          	mov    %rax,0x40(%rbx)
 18e4f6d:	41 80 7e 1e 00       	cmpb   $0x0,0x1e(%r14)
 18e4f72:	0f 84 d8 00 00 00    	je     18e5050 <run_backend_benchmark+0x7f80>
 18e4f78:	44 89 6c 24 30       	mov    %r13d,0x30(%rsp)
 18e4f7d:	44 8b 6c 24 60       	mov    0x60(%rsp),%r13d
 18e4f82:	49 8b 83 50 3a 00 00 	mov    0x3a50(%r11),%rax
 18e4f89:	4d 89 cc             	mov    %r9,%r12
 18e4f8c:	44 89 e9             	mov    %r13d,%ecx
 18e4f8f:	48 8d 14 c8          	lea    (%rax,%rcx,8),%rdx
 18e4f93:	48 8d 7c c8 08       	lea    0x8(%rax,%rcx,8),%rdi
 18e4f98:	48 89 94 24 a0 00 00 00 	mov    %rdx,0xa0(%rsp)
 18e4fa0:	48 ba 00 00 00 00 07 ff 01 00 	movabs $0x1ff0700000000,%rdx
 18e4faa:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
 18e4fae:	41 8b 56 10          	mov    0x10(%r14),%edx
 18e4fb2:	ff ca                	dec    %edx
 18e4fb4:	48 c1 e2 03          	shl    $0x3,%rdx
 18e4fb8:	c5 f8 77             	vzeroupper
 18e4fbb:	e8 e0 4f eb fe       	call   799fa0 <memcpy@plt>
 18e4fc0:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 18e4fc8:	4d 89 e1             	mov    %r12,%r9
 18e4fcb:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
 18e4fd0:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18e4fd5:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 18e4fdd:	4c 8b a4 24 c0 00 00 00 	mov    0xc0(%rsp),%r12
 18e4fe5:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18e4fea:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
 18e4fee:	48 89 43 38          	mov    %rax,0x38(%rbx)
 18e4ff2:	41 8b 46 10          	mov    0x10(%r14),%eax
 18e4ff6:	41 0f b6 4e 1e       	movzbl 0x1e(%r14),%ecx
 18e4ffb:	41 01 c5             	add    %eax,%r13d
 18e4ffe:	44 89 6c 24 60       	mov    %r13d,0x60(%rsp)
 18e5003:	44 8b 6c 24 30       	mov    0x30(%rsp),%r13d
 18e5008:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18e500e:	74 4e                	je     18e505e <run_backend_benchmark+0x7f8e>
 18e5010:	41 0f b6 76 1d       	movzbl 0x1d(%r14),%esi
 18e5015:	31 d2                	xor    %edx,%edx
 18e5017:	48 81 fe ff 00 00 00 	cmp    $0xff,%rsi
 18e501e:	0f 84 8c fc ff ff    	je     18e4cb0 <run_backend_benchmark+0x7be0>
 18e5024:	4d 01 c7             	add    %r8,%r15
 18e5027:	41 80 7f 08 01       	cmpb   $0x1,0x8(%r15)
 18e502c:	0f 85 7e fc ff ff    	jne    18e4cb0 <run_backend_benchmark+0x7be0>
 18e5032:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
 18e5037:	48 6b d6 74          	imul   $0x74,%rsi,%rdx
 18e503b:	41 8b 54 17 5c       	mov    0x5c(%r15,%rdx,1),%edx
 18e5040:	e9 6b fc ff ff       	jmp    18e4cb0 <run_backend_benchmark+0x7be0>
 18e5045:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18e5050:	41 8b 46 10          	mov    0x10(%r14),%eax
 18e5054:	31 c9                	xor    %ecx,%ecx
 18e5056:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18e505c:	75 b2                	jne    18e5010 <run_backend_benchmark+0x7f40>
 18e505e:	48 8b 94 24 b0 00 00 00 	mov    0xb0(%rsp),%rdx
 18e5066:	c7 83 b0 00 00 00 00 00 00 00 	movl   $0x0,0xb0(%rbx)
 18e5070:	48 8b 12             	mov    (%rdx),%rdx
 18e5073:	48 89 93 a0 00 00 00 	mov    %rdx,0xa0(%rbx)
 18e507a:	31 d2                	xor    %edx,%edx
 18e507c:	e9 53 fc ff ff       	jmp    18e4cd4 <run_backend_benchmark+0x7c04>
 18e5081:	4d 89 cf             	mov    %r9,%r15
 18e5084:	83 f9 40             	cmp    $0x40,%ecx
 18e5087:	73 09                	jae    18e5092 <run_backend_benchmark+0x7fc2>
 18e5089:	31 f6                	xor    %esi,%esi
 18e508b:	31 ff                	xor    %edi,%edi
 18e508d:	e9 92 00 00 00       	jmp    18e5124 <run_backend_benchmark+0x8054>
 18e5092:	c5 fc 47 c0          	kxorw  %k0,%k0,%k0
 18e5096:	89 ce                	mov    %ecx,%esi
 18e5098:	83 e6 c0             	and    $0xffffffc0,%esi
 18e509b:	89 d7                	mov    %edx,%edi
 18e509d:	c5 fc 47 c8          	kxorw  %k0,%k0,%k1
 18e50a1:	c5 fc 47 d0          	kxorw  %k0,%k0,%k2
 18e50a5:	c5 fc 47 d8          	kxorw  %k0,%k0,%k3
 18e50a9:	49 89 f0             	mov    %rsi,%r8
 18e50ac:	0f 1f 40 00          	nopl   0x0(%rax)
 18e50b0:	41 89 f9             	mov    %edi,%r9d
 18e50b3:	62 b1 fe 48 6f 04 88 	vmovdqu64 (%rax,%r9,4),%zmm0
 18e50ba:	62 b1 fe 48 6f 4c 88 01 	vmovdqu64 0x40(%rax,%r9,4),%zmm1
 18e50c2:	62 b1 fe 48 6f 5c 88 03 	vmovdqu64 0xc0(%rax,%r9,4),%zmm3
 18e50ca:	62 b1 fe 48 6f 54 88 02 	vmovdqu64 0x80(%rax,%r9,4),%zmm2
 18e50d2:	83 c7 40             	add    $0x40,%edi
 18e50d5:	49 83 c0 c0          	add    $0xffffffffffffffc0,%r8
 18e50d9:	62 f2 7d 48 27 e0    	vptestmd %zmm0,%zmm0,%k4
 18e50df:	62 f2 65 48 27 eb    	vptestmd %zmm3,%zmm3,%k5
 18e50e5:	c5 fc 45 c4          	korw   %k4,%k0,%k0
 18e50e9:	62 f2 75 48 27 e1    	vptestmd %zmm1,%zmm1,%k4
 18e50ef:	c5 e4 45 dd          	korw   %k5,%k3,%k3
 18e50f3:	c5 f4 45 cc          	korw   %k4,%k1,%k1
 18e50f7:	62 f2 6d 48 27 e2    	vptestmd %zmm2,%zmm2,%k4
 18e50fd:	c5 ec 45 d4          	korw   %k4,%k2,%k2
 18e5101:	75 ad                	jne    18e50b0 <run_backend_benchmark+0x7fe0>
 18e5103:	c5 f4 45 c0          	korw   %k0,%k1,%k0
 18e5107:	c5 ec 45 c0          	korw   %k0,%k2,%k0
 18e510b:	c5 f8 98 d8          	kortestw %k0,%k3
 18e510f:	40 0f 95 c7          	setne  %dil
 18e5113:	39 ce                	cmp    %ecx,%esi
 18e5115:	0f 84 db fd ff ff    	je     18e4ef6 <run_backend_benchmark+0x7e26>
 18e511b:	f6 c1 38             	test   $0x38,%cl
 18e511e:	0f 84 39 fd ff ff    	je     18e4e5d <run_backend_benchmark+0x7d8d>
 18e5124:	49 89 f0             	mov    %rsi,%r8
 18e5127:	89 ce                	mov    %ecx,%esi
 18e5129:	83 e6 f8             	and    $0xfffffff8,%esi
 18e512c:	40 84 ff             	test   %dil,%dil
 18e512f:	40 0f 95 c7          	setne  %dil
 18e5133:	c5 fb 92 c7          	kmovd  %edi,%k0
 18e5137:	89 d7                	mov    %edx,%edi
 18e5139:	44 01 c7             	add    %r8d,%edi
 18e513c:	49 29 f0             	sub    %rsi,%r8
 18e513f:	90                   	nop
 18e5140:	41 89 f9             	mov    %edi,%r9d
 18e5143:	c4 a1 7e 6f 04 88    	vmovdqu (%rax,%r9,4),%ymm0
 18e5149:	83 c7 08             	add    $0x8,%edi
 18e514c:	49 83 c0 08          	add    $0x8,%r8
 18e5150:	62 f2 7d 28 27 c8    	vptestmd %ymm0,%ymm0,%k1
 18e5156:	c5 fd 45 c1          	korb   %k1,%k0,%k0
 18e515a:	75 e4                	jne    18e5140 <run_backend_benchmark+0x8070>
 18e515c:	c5 f9 98 c0          	kortestb %k0,%k0
 18e5160:	40 0f 95 c7          	setne  %dil
 18e5164:	39 ce                	cmp    %ecx,%esi
 18e5166:	0f 85 f1 fc ff ff    	jne    18e4e5d <run_backend_benchmark+0x7d8d>
 18e516c:	e9 85 fd ff ff       	jmp    18e4ef6 <run_backend_benchmark+0x7e26>
 18e5171:	41 89 83 00 3a 00 00 	mov    %eax,0x3a00(%r11)
 18e5178:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18e517d:	48 8b 9c 24 10 01 00 00 	mov    0x110(%rsp),%rbx
 18e5185:	4d 89 df             	mov    %r11,%r15
 18e5188:	31 c9                	xor    %ecx,%ecx
 18e518a:	48 8b b4 24 a8 01 00 00 	mov    0x1a8(%rsp),%rsi
 18e5192:	48 8b 94 24 b0 01 00 00 	mov    0x1b0(%rsp),%rdx
 18e519a:	44 8b b4 24 98 01 00 00 	mov    0x198(%rsp),%r14d
 18e51a2:	48 8b 84 24 a0 01 00 00 	mov    0x1a0(%rsp),%rax
 18e51aa:	48 89 b4 24 a0 00 00 00 	mov    %rsi,0xa0(%rsp)
 18e51b2:	48 89 94 24 80 00 00 00 	mov    %rdx,0x80(%rsp)
 18e51ba:	48 8b b4 24 68 01 00 00 	mov    0x168(%rsp),%rsi
 18e51c2:	48 8b 94 24 70 01 00 00 	mov    0x170(%rsp),%rdx
 18e51ca:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
 18e51cf:	48 89 74 24 78       	mov    %rsi,0x78(%rsp)
 18e51d4:	48 89 94 24 90 00 00 00 	mov    %rdx,0x90(%rsp)
 18e51dc:	48 8b b4 24 78 01 00 00 	mov    0x178(%rsp),%rsi
 18e51e4:	48 8b 94 24 80 01 00 00 	mov    0x180(%rsp),%rdx
 18e51ec:	48 89 74 24 70       	mov    %rsi,0x70(%rsp)
 18e51f1:	48 89 94 24 b0 00 00 00 	mov    %rdx,0xb0(%rsp)
 18e51f9:	48 8b b4 24 88 01 00 00 	mov    0x188(%rsp),%rsi
 18e5201:	48 8b 94 24 90 01 00 00 	mov    0x190(%rsp),%rdx
 18e5209:	48 89 74 24 60       	mov    %rsi,0x60(%rsp)
 18e520e:	48 89 94 24 c0 00 00 00 	mov    %rdx,0xc0(%rsp)
 18e5216:	eb 33                	jmp    18e524b <run_backend_benchmark+0x817b>
 18e5218:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18e5220:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18e5225:	4c 89 e3             	mov    %r12,%rbx
 18e5228:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 18e522d:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 18e5232:	49 81 c7 e8 00 00 00 	add    $0xe8,%r15
 18e5239:	8b 80 00 3a 00 00    	mov    0x3a00(%rax),%eax
 18e523f:	48 ff c1             	inc    %rcx
 18e5242:	48 39 c1             	cmp    %rax,%rcx
 18e5245:	0f 83 c8 04 00 00    	jae    18e5713 <run_backend_benchmark+0x8643>
 18e524b:	41 81 fe 00 00 10 00 	cmp    $0x100000,%r14d
 18e5252:	0f 83 bb 04 00 00    	jae    18e5713 <run_backend_benchmark+0x8643>
 18e5258:	49 89 dc             	mov    %rbx,%r12
 18e525b:	48 8d 9c 24 e0 01 00 00 	lea    0x1e0(%rsp),%rbx
 18e5263:	48 8d bc 24 80 02 00 00 	lea    0x280(%rsp),%rdi
 18e526b:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
 18e5270:	4c 89 fe             	mov    %r15,%rsi
 18e5273:	48 89 da             	mov    %rbx,%rdx
 18e5276:	c5 f8 77             	vzeroupper
 18e5279:	e8 d2 99 01 00       	call   18fec50 <tier0_compile_scalar>
 18e527e:	48 8d bc 24 18 02 00 00 	lea    0x218(%rsp),%rdi
 18e5286:	4c 89 fe             	mov    %r15,%rsi
 18e5289:	48 89 da             	mov    %rbx,%rdx
 18e528c:	e8 df a8 01 00       	call   18ffb70 <tier0_compile>
 18e5291:	8b 9c 24 dc 02 00 00 	mov    0x2dc(%rsp),%ebx
 18e5298:	3b 9c 24 74 02 00 00 	cmp    0x274(%rsp),%ebx
 18e529f:	0f 85 9d 12 00 00    	jne    18e6542 <run_backend_benchmark+0x9472>
 18e52a5:	44 8b ac 24 88 02 00 00 	mov    0x288(%rsp),%r13d
 18e52ad:	44 3b ac 24 20 02 00 00 	cmp    0x220(%rsp),%r13d
 18e52b5:	0f 85 87 12 00 00    	jne    18e6542 <run_backend_benchmark+0x9472>
 18e52bb:	8b 84 24 a0 02 00 00 	mov    0x2a0(%rsp),%eax
 18e52c2:	3b 84 24 38 02 00 00 	cmp    0x238(%rsp),%eax
 18e52c9:	0f 85 73 12 00 00    	jne    18e6542 <run_backend_benchmark+0x9472>
 18e52cf:	48 8b bc 24 80 02 00 00 	mov    0x280(%rsp),%rdi
 18e52d7:	48 8b b4 24 18 02 00 00 	mov    0x218(%rsp),%rsi
 18e52df:	4c 89 ea             	mov    %r13,%rdx
 18e52e2:	48 c1 e2 04          	shl    $0x4,%rdx
 18e52e6:	e8 25 4b eb fe       	call   799e10 <bcmp@plt>
 18e52eb:	85 c0                	test   %eax,%eax
 18e52ed:	0f 85 4f 12 00 00    	jne    18e6542 <run_backend_benchmark+0x9472>
 18e52f3:	85 db                	test   %ebx,%ebx
 18e52f5:	0f 85 25 ff ff ff    	jne    18e5220 <run_backend_benchmark+0x8150>
 18e52fb:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
 18e5300:	44 89 f0             	mov    %r14d,%eax
 18e5303:	48 8b 94 24 90 00 00 00 	mov    0x90(%rsp),%rdx
 18e530b:	4d 8d 45 01          	lea    0x1(%r13),%r8
 18e530f:	4c 89 e3             	mov    %r12,%rbx
 18e5312:	4c 89 3c c1          	mov    %r15,(%rcx,%rax,8)
 18e5316:	48 6b c8 68          	imul   $0x68,%rax,%rcx
 18e531a:	62 f1 fe 48 6f 84 24 18 02 00 00 	vmovdqu64 0x218(%rsp),%zmm0
 18e5325:	62 f1 fe 48 6f 4c 24 09 	vmovdqu64 0x240(%rsp),%zmm1
 18e532d:	62 f1 fe 48 7f 8c 0a 28 00 00 00 	vmovdqu64 %zmm1,0x28(%rdx,%rcx,1)
 18e5338:	62 f1 fe 48 7f 04 0a 	vmovdqu64 %zmm0,(%rdx,%rcx,1)
 18e533f:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
 18e5344:	49 8d 74 14 03       	lea    0x3(%r12,%rdx,1),%rsi
 18e5349:	49 8d 0c 14          	lea    (%r12,%rdx,1),%rcx
 18e534d:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 18e5351:	48 89 f7             	mov    %rsi,%rdi
 18e5354:	48 29 d7             	sub    %rdx,%rdi
 18e5357:	48 39 ce             	cmp    %rcx,%rsi
 18e535a:	73 2c                	jae    18e5388 <run_backend_benchmark+0x82b8>
 18e535c:	4c 8b 4c 24 70       	mov    0x70(%rsp),%r9
 18e5361:	49 8d 14 c1          	lea    (%r9,%rax,8),%rdx
 18e5365:	49 c7 04 c1 00 00 00 00 	movq   $0x0,(%r9,%rax,8)
 18e536d:	48 39 ce             	cmp    %rcx,%rsi
 18e5370:	0f 82 99 00 00 00    	jb     18e540f <run_backend_benchmark+0x833f>
 18e5376:	4c 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%r9
 18e537e:	49 29 f9             	sub    %rdi,%r9
 18e5381:	73 4f                	jae    18e53d2 <run_backend_benchmark+0x8302>
 18e5383:	e9 87 00 00 00       	jmp    18e540f <run_backend_benchmark+0x833f>
 18e5388:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 18e5390:	48 29 fa             	sub    %rdi,%rdx
 18e5393:	72 c7                	jb     18e535c <run_backend_benchmark+0x828c>
 18e5395:	4d 89 c1             	mov    %r8,%r9
 18e5398:	49 c1 e1 04          	shl    $0x4,%r9
 18e539c:	49 39 d1             	cmp    %rdx,%r9
 18e539f:	77 bb                	ja     18e535c <run_backend_benchmark+0x828c>
 18e53a1:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
 18e53a6:	4c 01 cf             	add    %r9,%rdi
 18e53a9:	49 01 f1             	add    %rsi,%r9
 18e53ac:	48 89 fb             	mov    %rdi,%rbx
 18e53af:	4c 89 cf             	mov    %r9,%rdi
 18e53b2:	48 2b 7c 24 50       	sub    0x50(%rsp),%rdi
 18e53b7:	48 8d 14 c1          	lea    (%rcx,%rax,8),%rdx
 18e53bb:	48 89 34 c1          	mov    %rsi,(%rcx,%rax,8)
 18e53bf:	4c 89 c9             	mov    %r9,%rcx
 18e53c2:	4c 89 ce             	mov    %r9,%rsi
 18e53c5:	4c 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%r9
 18e53cd:	49 29 f9             	sub    %rdi,%r9
 18e53d0:	72 3d                	jb     18e540f <run_backend_benchmark+0x833f>
 18e53d2:	49 c1 e0 02          	shl    $0x2,%r8
 18e53d6:	4d 39 c8             	cmp    %r9,%r8
 18e53d9:	77 34                	ja     18e540f <run_backend_benchmark+0x833f>
 18e53db:	48 89 fb             	mov    %rdi,%rbx
 18e53de:	4c 01 c3             	add    %r8,%rbx
 18e53e1:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
 18e53e6:	49 89 f1             	mov    %rsi,%r9
 18e53e9:	49 8d 74 18 03       	lea    0x3(%r8,%rbx,1),%rsi
 18e53ee:	4a 8d 0c 03          	lea    (%rbx,%r8,1),%rcx
 18e53f2:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 18e53f6:	48 89 f7             	mov    %rsi,%rdi
 18e53f9:	4c 29 c7             	sub    %r8,%rdi
 18e53fc:	4c 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%r8
 18e5404:	4d 89 0c c0          	mov    %r9,(%r8,%rax,8)
 18e5408:	48 39 ce             	cmp    %rcx,%rsi
 18e540b:	72 51                	jb     18e545e <run_backend_benchmark+0x838e>
 18e540d:	eb 14                	jmp    18e5423 <run_backend_benchmark+0x8353>
 18e540f:	45 31 c9             	xor    %r9d,%r9d
 18e5412:	4c 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%r8
 18e541a:	4d 89 0c c0          	mov    %r9,(%r8,%rax,8)
 18e541e:	48 39 ce             	cmp    %rcx,%rsi
 18e5421:	72 3b                	jb     18e545e <run_backend_benchmark+0x838e>
 18e5423:	4c 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%r10
 18e542b:	49 29 fa             	sub    %rdi,%r10
 18e542e:	72 2e                	jb     18e545e <run_backend_benchmark+0x838e>
 18e5430:	44 8b 84 24 48 02 00 00 	mov    0x248(%rsp),%r8d
 18e5438:	41 b9 00 00 00 00    	mov    $0x0,%r9d
 18e543e:	4e 8d 04 85 40 00 00 00 	lea    0x40(,%r8,4),%r8
 18e5446:	4d 39 d0             	cmp    %r10,%r8
 18e5449:	77 16                	ja     18e5461 <run_backend_benchmark+0x8391>
 18e544b:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 18e5450:	49 01 f8             	add    %rdi,%r8
 18e5453:	49 89 f1             	mov    %rsi,%r9
 18e5456:	4c 89 c3             	mov    %r8,%rbx
 18e5459:	4c 01 c1             	add    %r8,%rcx
 18e545c:	eb 03                	jmp    18e5461 <run_backend_benchmark+0x8391>
 18e545e:	45 31 c9             	xor    %r9d,%r9d
 18e5461:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 18e5466:	48 8b bc 24 98 00 00 00 	mov    0x98(%rsp),%rdi
 18e546e:	4c 89 0c c6          	mov    %r9,(%rsi,%rax,8)
 18e5472:	4b 8d 74 ad 00       	lea    0x0(%r13,%r13,4),%rsi
 18e5477:	48 29 df             	sub    %rbx,%rdi
 18e547a:	41 0f 92 c0          	setb   %r8b
 18e547e:	48 8d 74 76 40       	lea    0x40(%rsi,%rsi,2),%rsi
 18e5483:	48 39 fe             	cmp    %rdi,%rsi
 18e5486:	40 0f 97 c7          	seta   %dil
 18e548a:	44 08 c7             	or     %r8b,%dil
 18e548d:	4c 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%r8
 18e5495:	bf 00 00 00 00       	mov    $0x0,%edi
 18e549a:	48 0f 45 cf          	cmovne %rdi,%rcx
 18e549e:	48 0f 45 f7          	cmovne %rdi,%rsi
 18e54a2:	49 89 0c c0          	mov    %rcx,(%r8,%rax,8)
 18e54a6:	48 83 3a 00          	cmpq   $0x0,(%rdx)
 18e54aa:	0f 84 49 10 00 00    	je     18e64f9 <run_backend_benchmark+0x9429>
 18e54b0:	48 8b 94 24 b0 00 00 00 	mov    0xb0(%rsp),%rdx
 18e54b8:	48 83 3c c2 00       	cmpq   $0x0,(%rdx,%rax,8)
 18e54bd:	0f 84 36 10 00 00    	je     18e64f9 <run_backend_benchmark+0x9429>
 18e54c3:	41 8b 57 18          	mov    0x18(%r15),%edx
 18e54c7:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
 18e54cc:	41 ff c6             	inc    %r14d
 18e54cf:	4c 01 ac 24 a0 00 00 00 	add    %r13,0xa0(%rsp)
 18e54d7:	48 01 54 24 30       	add    %rdx,0x30(%rsp)
 18e54dc:	8b 94 24 6c 02 00 00 	mov    0x26c(%rsp),%edx
 18e54e3:	48 01 94 24 80 00 00 00 	add    %rdx,0x80(%rsp)
 18e54eb:	48 83 3c c7 00       	cmpq   $0x0,(%rdi,%rax,8)
 18e54f0:	0f 84 ad 10 00 00    	je     18e65a3 <run_backend_benchmark+0x94d3>
 18e54f6:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18e54fb:	48 85 c9             	test   %rcx,%rcx
 18e54fe:	0f 84 a4 10 00 00    	je     18e65a8 <run_backend_benchmark+0x94d8>
 18e5504:	48 01 f3             	add    %rsi,%rbx
 18e5507:	e9 1c fd ff ff       	jmp    18e5228 <run_backend_benchmark+0x8158>
 18e550c:	64 48 8b 04 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rax
 18e5515:	49 89 ce             	mov    %rcx,%r14
 18e5518:	48 29 f1             	sub    %rsi,%rcx
 18e551b:	49 89 f7             	mov    %rsi,%r15
 18e551e:	48 89 c6             	mov    %rax,%rsi
 18e5521:	48 29 ce             	sub    %rcx,%rsi
 18e5524:	0f 82 46 f6 ff ff    	jb     18e4b70 <run_backend_benchmark+0x7aa0>
 18e552a:	49 8d 54 24 11       	lea    0x11(%r12),%rdx
 18e552f:	48 39 f2             	cmp    %rsi,%rdx
 18e5532:	0f 87 38 f6 ff ff    	ja     18e4b70 <run_backend_benchmark+0x7aa0>
 18e5538:	48 01 d1             	add    %rdx,%rcx
 18e553b:	64 48 89 0c 25 18 ff ff ff 	mov    %rcx,%fs:0xffffffffffffff18
 18e5544:	4d 85 f6             	test   %r14,%r14
 18e5547:	0f 84 23 f6 ff ff    	je     18e4b70 <run_backend_benchmark+0x7aa0>
 18e554d:	49 8d 4c 24 10       	lea    0x10(%r12),%rcx
 18e5552:	48 89 ce             	mov    %rcx,%rsi
 18e5555:	48 c1 ee 3e          	shr    $0x3e,%rsi
 18e5559:	0f 85 11 f6 ff ff    	jne    18e4b70 <run_backend_benchmark+0x7aa0>
 18e555f:	4a 8d 5c 32 03       	lea    0x3(%rdx,%r14,1),%rbx
 18e5564:	4a 8d 34 32          	lea    (%rdx,%r14,1),%rsi
 18e5568:	48 83 e3 fc          	and    $0xfffffffffffffffc,%rbx
 18e556c:	48 39 f3             	cmp    %rsi,%rbx
 18e556f:	0f 82 fb f5 ff ff    	jb     18e4b70 <run_backend_benchmark+0x7aa0>
 18e5575:	48 89 de             	mov    %rbx,%rsi
 18e5578:	4c 29 fe             	sub    %r15,%rsi
 18e557b:	48 89 c7             	mov    %rax,%rdi
 18e557e:	48 29 f7             	sub    %rsi,%rdi
 18e5581:	0f 82 e9 f5 ff ff    	jb     18e4b70 <run_backend_benchmark+0x7aa0>
 18e5587:	48 c1 e1 02          	shl    $0x2,%rcx
 18e558b:	48 39 f9             	cmp    %rdi,%rcx
 18e558e:	0f 87 dc f5 ff ff    	ja     18e4b70 <run_backend_benchmark+0x7aa0>
 18e5594:	48 01 ce             	add    %rcx,%rsi
 18e5597:	64 48 89 34 25 18 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff18
 18e55a0:	48 85 db             	test   %rbx,%rbx
 18e55a3:	0f 84 c7 f5 ff ff    	je     18e4b70 <run_backend_benchmark+0x7aa0>
 18e55a9:	48 8d 34 0b          	lea    (%rbx,%rcx,1),%rsi
 18e55ad:	48 89 c7             	mov    %rax,%rdi
 18e55b0:	48 89 b4 24 28 01 00 00 	mov    %rsi,0x128(%rsp)
 18e55b8:	4c 29 fe             	sub    %r15,%rsi
 18e55bb:	48 29 f7             	sub    %rsi,%rdi
 18e55be:	0f 82 ac f5 ff ff    	jb     18e4b70 <run_backend_benchmark+0x7aa0>
 18e55c4:	48 39 f9             	cmp    %rdi,%rcx
 18e55c7:	0f 87 a3 f5 ff ff    	ja     18e4b70 <run_backend_benchmark+0x7aa0>
 18e55cd:	48 01 ce             	add    %rcx,%rsi
 18e55d0:	48 8d 3c 0b          	lea    (%rbx,%rcx,1),%rdi
 18e55d4:	64 48 89 34 25 18 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff18
 18e55dd:	48 85 ff             	test   %rdi,%rdi
 18e55e0:	0f 84 8a f5 ff ff    	je     18e4b70 <run_backend_benchmark+0x7aa0>
 18e55e6:	48 8d 34 0b          	lea    (%rbx,%rcx,1),%rsi
 18e55ea:	48 89 c7             	mov    %rax,%rdi
 18e55ed:	48 01 ce             	add    %rcx,%rsi
 18e55f0:	48 89 b4 24 00 01 00 00 	mov    %rsi,0x100(%rsp)
 18e55f8:	4c 29 fe             	sub    %r15,%rsi
 18e55fb:	48 29 f7             	sub    %rsi,%rdi
 18e55fe:	0f 82 6c f5 ff ff    	jb     18e4b70 <run_backend_benchmark+0x7aa0>
 18e5604:	48 39 f9             	cmp    %rdi,%rcx
 18e5607:	0f 87 63 f5 ff ff    	ja     18e4b70 <run_backend_benchmark+0x7aa0>
 18e560d:	48 01 ce             	add    %rcx,%rsi
 18e5610:	48 83 bc 24 00 01 00 00 00 	cmpq   $0x0,0x100(%rsp)
 18e5619:	64 48 89 34 25 18 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff18
 18e5622:	0f 84 48 f5 ff ff    	je     18e4b70 <run_backend_benchmark+0x7aa0>
 18e5628:	48 8b bc 24 00 01 00 00 	mov    0x100(%rsp),%rdi
 18e5630:	48 8d 34 0f          	lea    (%rdi,%rcx,1),%rsi
 18e5634:	48 8d 7c 0f 04       	lea    0x4(%rdi,%rcx,1),%rdi
 18e5639:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
 18e563d:	48 39 f7             	cmp    %rsi,%rdi
 18e5640:	0f 82 2a f5 ff ff    	jb     18e4b70 <run_backend_benchmark+0x7aa0>
 18e5646:	48 89 f9             	mov    %rdi,%rcx
 18e5649:	4c 29 f9             	sub    %r15,%rcx
 18e564c:	48 29 c8             	sub    %rcx,%rax
 18e564f:	0f 82 1b f5 ff ff    	jb     18e4b70 <run_backend_benchmark+0x7aa0>
 18e5655:	4a 8d 34 dd 00 00 00 00 	lea    0x0(,%r11,8),%rsi
 18e565d:	48 39 c6             	cmp    %rax,%rsi
 18e5660:	0f 87 0a f5 ff ff    	ja     18e4b70 <run_backend_benchmark+0x7aa0>
 18e5666:	48 01 f1             	add    %rsi,%rcx
 18e5669:	64 48 89 0c 25 18 ff ff ff 	mov    %rcx,%fs:0xffffffffffffff18
 18e5672:	48 85 ff             	test   %rdi,%rdi
 18e5675:	0f 84 f5 f4 ff ff    	je     18e4b70 <run_backend_benchmark+0x7aa0>
 18e567b:	48 89 bc 24 e0 00 00 00 	mov    %rdi,0xe0(%rsp)
 18e5683:	48 89 9c 24 08 01 00 00 	mov    %rbx,0x108(%rsp)
 18e568b:	4c 89 ac 24 c0 00 00 00 	mov    %r13,0xc0(%rsp)
 18e5693:	4c 89 9c 24 d0 00 00 00 	mov    %r11,0xd0(%rsp)
 18e569b:	4c 89 f7             	mov    %r14,%rdi
 18e569e:	31 f6                	xor    %esi,%esi
 18e56a0:	4c 89 cb             	mov    %r9,%rbx
 18e56a3:	c5 f8 77             	vzeroupper
 18e56a6:	e8 d5 47 eb fe       	call   799e80 <memset@plt>
 18e56ab:	85 db                	test   %ebx,%ebx
 18e56ad:	0f 84 04 04 00 00    	je     18e5ab7 <run_backend_benchmark+0x89e7>
 18e56b3:	83 bc 24 f0 00 00 00 01 	cmpl   $0x1,0xf0(%rsp)
 18e56bb:	0f 85 ba 00 00 00    	jne    18e577b <run_backend_benchmark+0x86ab>
 18e56c1:	31 c9                	xor    %ecx,%ecx
 18e56c3:	31 c0                	xor    %eax,%eax
 18e56c5:	e9 f7 02 00 00       	jmp    18e59c1 <run_backend_benchmark+0x88f1>
 18e56ca:	41 89 93 00 3a 00 00 	mov    %edx,0x3a00(%r11)
 18e56d1:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18e56d6:	48 8b 9c 24 10 01 00 00 	mov    0x110(%rsp),%rbx
 18e56de:	48 8b 84 24 a0 01 00 00 	mov    0x1a0(%rsp),%rax
 18e56e6:	48 8b 94 24 a8 01 00 00 	mov    0x1a8(%rsp),%rdx
 18e56ee:	48 8b 8c 24 b0 01 00 00 	mov    0x1b0(%rsp),%rcx
 18e56f6:	44 8b b4 24 98 01 00 00 	mov    0x198(%rsp),%r14d
 18e56fe:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
 18e5703:	48 89 94 24 a0 00 00 00 	mov    %rdx,0xa0(%rsp)
 18e570b:	48 89 8c 24 80 00 00 00 	mov    %rcx,0x80(%rsp)
 18e5713:	44 89 b4 24 98 01 00 00 	mov    %r14d,0x198(%rsp)
 18e571b:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 18e5720:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18e5728:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 18e5730:	48 ff 84 24 d8 00 00 00 	incq   0xd8(%rsp)
 18e5738:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
 18e5740:	49 bf 00 00 20 00 01 00 00 00 	movabs $0x100200000,%r15
 18e574a:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 18e5750:	48 89 84 24 a0 01 00 00 	mov    %rax,0x1a0(%rsp)
 18e5758:	48 89 8c 24 a8 01 00 00 	mov    %rcx,0x1a8(%rsp)
 18e5760:	48 89 94 24 b0 01 00 00 	mov    %rdx,0x1b0(%rsp)
 18e5768:	48 3b 84 24 20 01 00 00 	cmp    0x120(%rsp),%rax
 18e5770:	0f 82 dd cf ff ff    	jb     18e2753 <run_backend_benchmark+0x5683>
 18e5776:	e9 3c 10 00 00       	jmp    18e67b7 <run_backend_benchmark+0x96e7>
 18e577b:	48 8b 84 24 d0 00 00 00 	mov    0xd0(%rsp),%rax
 18e5783:	83 e0 fe             	and    $0xfffffffe,%eax
 18e5786:	31 c9                	xor    %ecx,%ecx
 18e5788:	4c 89 b4 24 e8 00 00 00 	mov    %r14,0xe8(%rsp)
 18e5790:	48 89 84 24 40 01 00 00 	mov    %rax,0x140(%rsp)
 18e5798:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
 18e579d:	48 8d 70 1a          	lea    0x1a(%rax),%rsi
 18e57a1:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 18e57a9:	48 ff c0             	inc    %rax
 18e57ac:	48 89 84 24 f8 00 00 00 	mov    %rax,0xf8(%rsp)
 18e57b4:	31 c0                	xor    %eax,%eax
 18e57b6:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 18e57bb:	4c 8b 6c 24 60       	mov    0x60(%rsp),%r13
 18e57c0:	4c 8b 9c 24 b0 0e 00 00 	mov    0xeb0(%rsp),%r11
 18e57c8:	44 8b 04 8a          	mov    (%rdx,%rcx,4),%r8d
 18e57cc:	41 8b 5c 8d 00       	mov    0x0(%r13,%rcx,4),%ebx
 18e57d1:	49 81 f8 00 80 00 00 	cmp    $0x8000,%r8
 18e57d8:	41 0f 93 c1          	setae  %r9b
 18e57dc:	83 e3 f8             	and    $0xfffffff8,%ebx
 18e57df:	45 8b 7c 1b 02       	mov    0x2(%r11,%rbx,1),%r15d
 18e57e4:	41 0f b6 3c 1b       	movzbl (%r11,%rbx,1),%edi
 18e57e9:	45 0f b6 54 1b 01    	movzbl 0x1(%r11,%rbx,1),%r10d
 18e57ef:	44 89 bc 24 80 02 00 00 	mov    %r15d,0x280(%rsp)
 18e57f7:	45 89 d7             	mov    %r10d,%r15d
 18e57fa:	45 0f b7 5c 1b 06    	movzwl 0x6(%r11,%rbx,1),%r11d
 18e5800:	66 44 89 9c 24 84 02 00 00 	mov    %r11w,0x284(%rsp)
 18e5809:	45 31 db             	xor    %r11d,%r11d
 18e580c:	40 80 ff 02          	cmp    $0x2,%dil
 18e5810:	c7 46 e6 00 00 00 00 	movl   $0x0,-0x1a(%rsi)
 18e5817:	c6 46 ea 04          	movb   $0x4,-0x16(%rsi)
 18e581b:	41 0f 94 c3          	sete   %r11b
 18e581f:	41 c0 e1 06          	shl    $0x6,%r9b
 18e5823:	41 80 e2 08          	and    $0x8,%r10b
 18e5827:	c4 c1 79 6e c3       	vmovd  %r11d,%xmm0
 18e582c:	41 c0 ea 03          	shr    $0x3,%r10b
 18e5830:	c4 e3 79 20 c7 03    	vpinsrb $0x3,%edi,%xmm0,%xmm0
 18e5836:	48 8b bc 24 e0 00 00 00 	mov    0xe0(%rsp),%rdi
 18e583e:	45 20 da             	and    %r11b,%r10b
 18e5841:	c5 f9 7e 46 eb       	vmovd  %xmm0,-0x15(%rsi)
 18e5846:	44 88 7e ef          	mov    %r15b,-0x11(%rsi)
 18e584a:	41 c0 e2 05          	shl    $0x5,%r10b
 18e584e:	8b 9c 24 80 02 00 00 	mov    0x280(%rsp),%ebx
 18e5855:	89 5e f0             	mov    %ebx,-0x10(%rsi)
 18e5858:	0f b7 9c 24 84 02 00 00 	movzwl 0x284(%rsp),%ebx
 18e5860:	66 89 5e f4          	mov    %bx,-0xc(%rsi)
 18e5864:	42 8d 1c dd 00 00 00 00 	lea    0x0(,%r11,8),%ebx
 18e586c:	48 89 04 cf          	mov    %rax,(%rdi,%rcx,8)
 18e5870:	bf 00 00 00 00       	mov    $0x0,%edi
 18e5875:	41 08 d9             	or     %bl,%r9b
 18e5878:	48 8b 9c 24 f8 00 00 00 	mov    0xf8(%rsp),%rbx
 18e5880:	80 7c 0b ff 00       	cmpb   $0x0,-0x1(%rbx,%rcx,1)
 18e5885:	41 0f 95 c3          	setne  %r11b
 18e5889:	45 08 ca             	or     %r9b,%r10b
 18e588c:	41 c0 e3 04          	shl    $0x4,%r11b
 18e5890:	45 08 da             	or     %r11b,%r10b
 18e5893:	41 fe c2             	inc    %r10b
 18e5896:	4d 85 c0             	test   %r8,%r8
 18e5899:	45 0f b6 ca          	movzbl %r10b,%r9d
 18e589d:	44 0f 44 cf          	cmove  %edi,%r9d
 18e58a1:	48 8b bc 24 e8 00 00 00 	mov    0xe8(%rsp),%rdi
 18e58a9:	44 08 0c 07          	or     %r9b,(%rdi,%rax,1)
 18e58ad:	4c 01 c0             	add    %r8,%rax
 18e58b0:	44 8b 44 8a 04       	mov    0x4(%rdx,%rcx,4),%r8d
 18e58b5:	41 8b 5c 8d 04       	mov    0x4(%r13,%rcx,4),%ebx
 18e58ba:	4c 8b 9c 24 b0 0e 00 00 	mov    0xeb0(%rsp),%r11
 18e58c2:	48 8b 94 24 e0 00 00 00 	mov    0xe0(%rsp),%rdx
 18e58ca:	49 81 f8 00 80 00 00 	cmp    $0x8000,%r8
 18e58d1:	41 0f 93 c1          	setae  %r9b
 18e58d5:	83 e3 f8             	and    $0xfffffff8,%ebx
 18e58d8:	45 8b 7c 1b 02       	mov    0x2(%r11,%rbx,1),%r15d
 18e58dd:	41 0f b6 3c 1b       	movzbl (%r11,%rbx,1),%edi
 18e58e2:	45 0f b6 54 1b 01    	movzbl 0x1(%r11,%rbx,1),%r10d
 18e58e8:	44 89 bc 24 80 02 00 00 	mov    %r15d,0x280(%rsp)
 18e58f0:	45 0f b7 5c 1b 06    	movzwl 0x6(%r11,%rbx,1),%r11d
 18e58f6:	66 44 89 9c 24 84 02 00 00 	mov    %r11w,0x284(%rsp)
 18e58ff:	45 31 db             	xor    %r11d,%r11d
 18e5902:	40 80 ff 02          	cmp    $0x2,%dil
 18e5906:	c7 46 f6 00 00 00 00 	movl   $0x0,-0xa(%rsi)
 18e590d:	c6 46 fa 04          	movb   $0x4,-0x6(%rsi)
 18e5911:	41 0f 94 c3          	sete   %r11b
 18e5915:	41 c0 e1 06          	shl    $0x6,%r9b
 18e5919:	c4 c1 79 6e c3       	vmovd  %r11d,%xmm0
 18e591e:	c4 e3 79 20 c7 03    	vpinsrb $0x3,%edi,%xmm0,%xmm0
 18e5924:	48 8b bc 24 e8 00 00 00 	mov    0xe8(%rsp),%rdi
 18e592c:	c5 f9 7e 46 fb       	vmovd  %xmm0,-0x5(%rsi)
 18e5931:	44 88 56 ff          	mov    %r10b,-0x1(%rsi)
 18e5935:	41 80 e2 08          	and    $0x8,%r10b
 18e5939:	8b 9c 24 80 02 00 00 	mov    0x280(%rsp),%ebx
 18e5940:	41 c0 ea 03          	shr    $0x3,%r10b
 18e5944:	45 20 da             	and    %r11b,%r10b
 18e5947:	41 c0 e2 05          	shl    $0x5,%r10b
 18e594b:	89 1e                	mov    %ebx,(%rsi)
 18e594d:	0f b7 9c 24 84 02 00 00 	movzwl 0x284(%rsp),%ebx
 18e5955:	66 89 5e 04          	mov    %bx,0x4(%rsi)
 18e5959:	42 8d 1c dd 00 00 00 00 	lea    0x0(,%r11,8),%ebx
 18e5961:	48 89 44 ca 08       	mov    %rax,0x8(%rdx,%rcx,8)
 18e5966:	ba 00 00 00 00       	mov    $0x0,%edx
 18e596b:	41 08 d9             	or     %bl,%r9b
 18e596e:	48 8b 9c 24 f8 00 00 00 	mov    0xf8(%rsp),%rbx
 18e5976:	80 3c 0b 00          	cmpb   $0x0,(%rbx,%rcx,1)
 18e597a:	41 0f 95 c3          	setne  %r11b
 18e597e:	45 08 ca             	or     %r9b,%r10b
 18e5981:	41 c0 e3 04          	shl    $0x4,%r11b
 18e5985:	45 08 da             	or     %r11b,%r10b
 18e5988:	41 fe c2             	inc    %r10b
 18e598b:	4d 85 c0             	test   %r8,%r8
 18e598e:	45 0f b6 ca          	movzbl %r10b,%r9d
 18e5992:	44 0f 44 ca          	cmove  %edx,%r9d
 18e5996:	48 83 c1 02          	add    $0x2,%rcx
 18e599a:	48 83 c6 20          	add    $0x20,%rsi
 18e599e:	44 08 0c 07          	or     %r9b,(%rdi,%rax,1)
 18e59a2:	4c 01 c0             	add    %r8,%rax
 18e59a5:	48 39 8c 24 40 01 00 00 	cmp    %rcx,0x140(%rsp)
 18e59ad:	0f 85 03 fe ff ff    	jne    18e57b6 <run_backend_benchmark+0x86e6>
 18e59b3:	f6 84 24 d0 00 00 00 01 	testb  $0x1,0xd0(%rsp)
 18e59bb:	0f 84 f6 00 00 00    	je     18e5ab7 <run_backend_benchmark+0x89e7>
 18e59c1:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 18e59c6:	48 8b bc 24 b0 0e 00 00 	mov    0xeb0(%rsp),%rdi
 18e59ce:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 18e59d3:	44 8b 04 8e          	mov    (%rsi,%rcx,4),%r8d
 18e59d7:	8b 14 8a             	mov    (%rdx,%rcx,4),%edx
 18e59da:	41 83 e0 f8          	and    $0xfffffff8,%r8d
 18e59de:	46 8b 54 07 02       	mov    0x2(%rdi,%r8,1),%r10d
 18e59e3:	46 0f b6 0c 07       	movzbl (%rdi,%r8,1),%r9d
 18e59e8:	42 0f b6 74 07 01    	movzbl 0x1(%rdi,%r8,1),%esi
 18e59ee:	44 89 94 24 80 02 00 00 	mov    %r10d,0x280(%rsp)
 18e59f6:	4c 8b 54 24 70       	mov    0x70(%rsp),%r10
 18e59fb:	42 0f b7 7c 07 06    	movzwl 0x6(%rdi,%r8,1),%edi
 18e5a01:	66 89 bc 24 84 02 00 00 	mov    %di,0x284(%rsp)
 18e5a09:	31 ff                	xor    %edi,%edi
 18e5a0b:	41 80 f9 02          	cmp    $0x2,%r9b
 18e5a0f:	40 0f 94 c7          	sete   %dil
 18e5a13:	c5 f9 6e c7          	vmovd  %edi,%xmm0
 18e5a17:	c4 c3 79 20 c1 03    	vpinsrb $0x3,%r9d,%xmm0,%xmm0
 18e5a1d:	49 89 c9             	mov    %rcx,%r9
 18e5a20:	49 c1 e1 04          	shl    $0x4,%r9
 18e5a24:	43 c7 04 0a 00 00 00 00 	movl   $0x0,(%r10,%r9,1)
 18e5a2c:	43 c6 44 0a 04 04    	movb   $0x4,0x4(%r10,%r9,1)
 18e5a32:	c4 81 79 7e 44 0a 05 	vmovd  %xmm0,0x5(%r10,%r9,1)
 18e5a39:	43 88 74 0a 09       	mov    %sil,0x9(%r10,%r9,1)
 18e5a3e:	40 80 e6 08          	and    $0x8,%sil
 18e5a42:	44 8b 84 24 80 02 00 00 	mov    0x280(%rsp),%r8d
 18e5a4a:	40 c0 ee 03          	shr    $0x3,%sil
 18e5a4e:	81 fa 00 80 00 00    	cmp    $0x8000,%edx
 18e5a54:	47 89 44 0a 0a       	mov    %r8d,0xa(%r10,%r9,1)
 18e5a59:	44 0f b7 84 24 84 02 00 00 	movzwl 0x284(%rsp),%r8d
 18e5a62:	66 47 89 44 0a 0e    	mov    %r8w,0xe(%r10,%r9,1)
 18e5a68:	41 0f 93 c1          	setae  %r9b
 18e5a6c:	44 8d 04 fd 00 00 00 00 	lea    0x0(,%rdi,8),%r8d
 18e5a74:	4c 8b 94 24 e0 00 00 00 	mov    0xe0(%rsp),%r10
 18e5a7c:	40 20 fe             	and    %dil,%sil
 18e5a7f:	41 c0 e1 06          	shl    $0x6,%r9b
 18e5a83:	40 c0 e6 05          	shl    $0x5,%sil
 18e5a87:	45 08 c1             	or     %r8b,%r9b
 18e5a8a:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 18e5a92:	49 89 04 ca          	mov    %rax,(%r10,%rcx,8)
 18e5a96:	41 80 3c 08 00       	cmpb   $0x0,(%r8,%rcx,1)
 18e5a9b:	0f 95 c1             	setne  %cl
 18e5a9e:	44 08 ce             	or     %r9b,%sil
 18e5aa1:	c0 e1 04             	shl    $0x4,%cl
 18e5aa4:	40 08 ce             	or     %cl,%sil
 18e5aa7:	40 fe c6             	inc    %sil
 18e5aaa:	85 d2                	test   %edx,%edx
 18e5aac:	40 0f b6 ce          	movzbl %sil,%ecx
 18e5ab0:	0f 44 ca             	cmove  %edx,%ecx
 18e5ab3:	41 08 0c 06          	or     %cl,(%r14,%rax,1)
 18e5ab7:	62 62 7d 48 58 05 ab 0f cd fe 	vpbroadcastd -0x132f055(%rip),%zmm24        # 5b6a6c <tier0_emit_x87.operations+0x1c>
 18e5ac1:	62 62 7d 48 58 0d a5 0f cd fe 	vpbroadcastd -0x132f05b(%rip),%zmm25        # 5b6a70 <tier0_emit_x87.operations+0x20>
 18e5acb:	62 62 7d 48 58 25 c7 0f cd fe 	vpbroadcastd -0x132f039(%rip),%zmm28        # 5b6a9c <tier0_emit_x87.operations+0x4c>
 18e5ad5:	62 62 7d 48 58 2d c1 0f cd fe 	vpbroadcastd -0x132f03f(%rip),%zmm29        # 5b6aa0 <tier0_emit_x87.operations+0x50>
 18e5adf:	62 61 fd 48 6f 35 17 07 c6 fe 	vmovdqa64 -0x139f8e9(%rip),%zmm30        # 546200 <branch_sizing_patterns+0x570>
 18e5ae9:	62 62 7d 48 58 3d b1 0f cd fe 	vpbroadcastd -0x132f04f(%rip),%zmm31        # 5b6aa4 <tier0_emit_x87.operations+0x54>
 18e5af3:	62 e2 7d 48 58 2d ab 0f cd fe 	vpbroadcastd -0x132f055(%rip),%zmm21        # 5b6aa8 <tier0_emit_x87.operations+0x58>
 18e5afd:	62 e2 7d 48 58 35 ad 0f cd fe 	vpbroadcastd -0x132f053(%rip),%zmm22        # 5b6ab4 <tier0_emit_x87.operations+0x64>
 18e5b07:	62 e2 7d 48 58 3d a7 0f cd fe 	vpbroadcastd -0x132f059(%rip),%zmm23        # 5b6ab8 <tier0_emit_x87.operations+0x68>
 18e5b11:	62 61 fd 48 6f 15 25 07 c6 fe 	vmovdqa64 -0x139f8db(%rip),%zmm26        # 546240 <branch_sizing_patterns+0x5b0>
 18e5b1b:	62 61 fd 48 6f 1d 5b 07 c6 fe 	vmovdqa64 -0x139f8a5(%rip),%zmm27        # 546280 <branch_sizing_patterns+0x5f0>
 18e5b25:	43 c6 04 26 01       	movb   $0x1,(%r14,%r12,1)
 18e5b2a:	62 a1 5d 00 ef e4    	vpxord %xmm20,%xmm20,%xmm20
 18e5b30:	4d 85 e4             	test   %r12,%r12
 18e5b33:	0f 84 ec 05 00 00    	je     18e6125 <run_backend_benchmark+0x9055>
 18e5b39:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 18e5b3e:	49 ff c6             	inc    %r14
 18e5b41:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18e5b45:	4d 89 e5             	mov    %r12,%r13
 18e5b48:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 18e5b4c:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18e5b50:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18e5b54:	31 d2                	xor    %edx,%edx
 18e5b56:	48 83 c0 40          	add    $0x40,%rax
 18e5b5a:	48 89 84 24 40 01 00 00 	mov    %rax,0x140(%rsp)
 18e5b62:	44 89 ee             	mov    %r13d,%esi
 18e5b65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 18e5b6a:	49 83 ed 10          	sub    $0x10,%r13
 18e5b6e:	48 8b bc 24 88 0e 00 00 	mov    0xe88(%rsp),%rdi
 18e5b76:	4c 8b 84 24 90 0e 00 00 	mov    0xe90(%rsp),%r8
 18e5b7e:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
 18e5b83:	c4 e2 49 f7 f0       	shlx   %esi,%eax,%esi
 18e5b88:	b8 ff ff 00 00       	mov    $0xffff,%eax
 18e5b8d:	f7 d6                	not    %esi
 18e5b8f:	0f 43 f0             	cmovae %eax,%esi
 18e5b92:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18e5b9a:	c5 fb 92 d6          	kmovd  %esi,%k2
 18e5b9e:	c5 f8 91 94 24 e8 00 00 00 	kmovw  %k2,0xe8(%rsp)
 18e5ba7:	c4 e1 f8 90 ca       	kmovq  %k2,%k1
 18e5bac:	62 f1 7e ca 6f 04 90 	vmovdqu32 (%rax,%rdx,4),%zmm0{%k2}{z}
 18e5bb3:	62 f1 5d 48 72 d0 03 	vpsrld $0x3,%zmm0,%zmm4
 18e5bba:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18e5bbe:	62 f2 7d 49 90 04 a7 	vpgatherdd (%rdi,%zmm4,4),%zmm0{%k1}
 18e5bc5:	c4 e1 f8 90 ca       	kmovq  %k2,%k1
 18e5bca:	62 52 7d 49 90 1c a0 	vpgatherdd (%r8,%zmm4,4),%zmm11{%k1}
 18e5bd1:	62 d1 7f 8a 6f a4 16 ff ff ff ff 	vmovdqu8 -0x1(%r14,%rdx,1),%xmm4{%k2}{z}
 18e5bdc:	62 92 7d 48 27 d0    	vptestmd %zmm24,%zmm0,%k2
 18e5be2:	62 f1 45 48 72 d0 03 	vpsrld $0x3,%zmm0,%zmm7
 18e5be9:	62 f1 35 48 72 d0 01 	vpsrld $0x1,%zmm0,%zmm9
 18e5bf0:	62 11 35 48 db c1    	vpandd %zmm25,%zmm9,%zmm8
 18e5bf6:	62 91 45 48 db f9    	vpandd %zmm25,%zmm7,%zmm7
 18e5bfc:	62 d1 35 48 72 f1 1f 	vpslld $0x1f,%zmm9,%zmm9
 18e5c03:	62 72 7d 48 31 d4    	vpmovzxbd %xmm4,%zmm10
 18e5c09:	c5 d9 71 f4 07       	vpsllw $0x7,%xmm4,%xmm4
 18e5c0e:	62 f2 7e 08 29 e4    	vpmovb2m %xmm4,%k4
 18e5c14:	c4 e3 f9 32 c4 01    	kshiftlw $0x1,%k4,%k0
 18e5c1a:	c5 fc 45 ec          	korw   %k4,%k0,%k5
 18e5c1e:	62 b3 2d 48 03 e4 0f 	valignd $0xf,%zmm20,%zmm10,%zmm4
 18e5c25:	c4 e3 f9 32 c5 02    	kshiftlw $0x2,%k5,%k0
 18e5c2b:	62 d1 0d 48 72 d2 03 	vpsrld $0x3,%zmm10,%zmm14
 18e5c32:	c5 d4 45 d8          	korw   %k0,%k5,%k3
 18e5c36:	62 f1 2d 48 eb e4    	vpord  %zmm4,%zmm10,%zmm4
 18e5c3c:	c4 e3 f9 32 c3 04    	kshiftlw $0x4,%k3,%k0
 18e5c42:	62 d1 7d 4c 6f e2    	vmovdqa32 %zmm10,%zmm4{%k4}
 18e5c48:	62 b3 dd 48 03 f4 07 	valignq $0x7,%zmm20,%zmm4,%zmm6
 18e5c4f:	c5 e4 45 f0          	korw   %k0,%k3,%k6
 18e5c53:	62 71 2d 58 db 15 33 0e cd fe 	vpandd -0x132f1cd(%rip){1to16},%zmm10,%zmm10        # 5b6a90 <tier0_emit_x87.operations+0x40>
 18e5c5d:	c4 e3 f9 32 c6 08    	kshiftlw $0x8,%k6,%k0
 18e5c63:	62 73 7d 58 25 15 26 0e cd fe f8 	vpternlogd $0xf8,-0x132f1da(%rip){1to16},%zmm0,%zmm10        # 5b6a94 <tier0_emit_x87.operations+0x44>
 18e5c6e:	62 f1 5d 48 eb f6    	vpord  %zmm6,%zmm4,%zmm6
 18e5c74:	c5 cc 45 f8          	korw   %k0,%k6,%k7
 18e5c78:	62 f2 7d 58 27 05 e6 0d cd fe 	vptestmd -0x132f21a(%rip){1to16},%zmm0,%k0        # 5b6a68 <tier0_emit_x87.operations+0x18>
 18e5c82:	62 f1 7d 4d 6f f4    	vmovdqa32 %zmm4,%zmm6{%k5}
 18e5c88:	62 b3 cd 48 03 e4 06 	valignq $0x6,%zmm20,%zmm6,%zmm4
 18e5c8f:	c5 f8 44 cf          	knotw  %k7,%k1
 18e5c93:	62 f1 7d c9 6f c9    	vmovdqa32 %zmm1,%zmm1{%k1}{z}
 18e5c99:	c5 f8 91 8c 24 f8 00 00 00 	kmovw  %k1,0xf8(%rsp)
 18e5ca2:	62 f1 4d 48 eb e4    	vpord  %zmm4,%zmm6,%zmm4
 18e5ca8:	62 f1 7d 4b 6f e6    	vmovdqa32 %zmm6,%zmm4{%k3}
 18e5cae:	62 b3 dd 48 03 f4 04 	valignq $0x4,%zmm20,%zmm4,%zmm6
 18e5cb5:	62 f1 75 48 eb f6    	vpord  %zmm6,%zmm1,%zmm6
 18e5cbb:	62 f1 7d 4e 6f f1    	vmovdqa32 %zmm1,%zmm6{%k6}
 18e5cc1:	62 f1 4d 48 eb cc    	vpord  %zmm4,%zmm6,%zmm1
 18e5cc7:	62 71 75 58 db 2d 8f 0d cd fe 	vpandd -0x132f271(%rip){1to16},%zmm1,%zmm13        # 5b6a60 <tier0_emit_x87.operations+0x10>
 18e5cd1:	62 f1 5d 48 72 d0 02 	vpsrld $0x2,%zmm0,%zmm4
 18e5cd8:	62 91 7d 48 db f1    	vpandd %zmm25,%zmm0,%zmm6
 18e5cde:	62 91 5d 48 db e1    	vpandd %zmm25,%zmm4,%zmm4
 18e5ce4:	62 d2 15 4a 27 cd    	vptestmd %zmm13,%zmm13,%k1{%k2}
 18e5cea:	c5 fc 45 c1          	korw   %k1,%k0,%k0
 18e5cee:	c5 7b 93 c8          	kmovd  %k0,%r9d
 18e5cf2:	c4 e2 30 f2 fe       	andn   %esi,%r9d,%edi
 18e5cf7:	c5 fb 92 cf          	kmovd  %edi,%k1
 18e5cfb:	62 e1 3d c9 fe c7    	vpaddd %zmm7,%zmm8,%zmm16{%k1}{z}
 18e5d01:	62 71 5d c9 fe fe    	vpaddd %zmm6,%zmm4,%zmm15{%k1}{z}
 18e5d07:	62 b1 1d 48 72 f0 10 	vpslld $0x10,%zmm16,%zmm12
 18e5d0e:	62 d2 06 48 27 c7    	vptestnmd %zmm15,%zmm15,%k0
 18e5d14:	62 c1 1d 48 eb cf    	vpord  %zmm15,%zmm12,%zmm17
 18e5d1a:	62 11 0d 48 db e1    	vpandd %zmm25,%zmm14,%zmm12
 18e5d20:	c5 fb 93 f8          	kmovd  %k0,%edi
 18e5d24:	62 51 75 40 fe e4    	vpaddd %zmm12,%zmm17,%zmm12
 18e5d2a:	62 33 1d 48 03 f4 0f 	valignd $0xf,%zmm20,%zmm12,%zmm14
 18e5d31:	62 51 1d 48 fe f6    	vpaddd %zmm14,%zmm12,%zmm14
 18e5d37:	62 51 7d 4c 6f f4    	vmovdqa32 %zmm12,%zmm14{%k4}
 18e5d3d:	62 33 8d 48 03 e4 07 	valignq $0x7,%zmm20,%zmm14,%zmm12
 18e5d44:	62 51 0d 48 fe e4    	vpaddd %zmm12,%zmm14,%zmm12
 18e5d4a:	62 51 7d 4d 6f e6    	vmovdqa32 %zmm14,%zmm12{%k5}
 18e5d50:	62 33 9d 48 03 f4 06 	valignq $0x6,%zmm20,%zmm12,%zmm14
 18e5d57:	62 51 1d 48 fe f6    	vpaddd %zmm14,%zmm12,%zmm14
 18e5d5d:	62 51 7d 4b 6f f4    	vmovdqa32 %zmm12,%zmm14{%k3}
 18e5d63:	62 33 8d 48 03 e4 04 	valignq $0x4,%zmm20,%zmm14,%zmm12
 18e5d6a:	62 e1 0d 48 fe d3    	vpaddd %zmm3,%zmm14,%zmm18
 18e5d70:	62 c1 7d 4f 6f d6    	vmovdqa32 %zmm14,%zmm18{%k7}
 18e5d76:	62 d1 6d 40 fe dc    	vpaddd %zmm12,%zmm18,%zmm3
 18e5d7c:	62 b1 7d 4e 6f da    	vmovdqa32 %zmm18,%zmm3{%k6}
 18e5d82:	62 a1 65 48 fa d1    	vpsubd %zmm17,%zmm3,%zmm18
 18e5d88:	62 71 6d 50 db 25 2a 0d cd fe 	vpandd -0x132f2d6(%rip){1to16},%zmm18,%zmm12        # 5b6abc <tier0_emit_x87.operations+0x6c>
 18e5d92:	62 f3 1d 58 1f 0d df 0c cd fe 01 	vpcmpltd -0x132f321(%rip){1to16},%zmm12,%k1        # 5b6a7c <tier0_emit_x87.operations+0x2c>
 18e5d9d:	62 51 1d 48 fe f7    	vpaddd %zmm15,%zmm12,%zmm14
 18e5da3:	62 f3 0d 58 1f 05 c6 0c cd fe 01 	vpcmpltd -0x132f33a(%rip){1to16},%zmm14,%k0        # 5b6a74 <tier0_emit_x87.operations+0x24>
 18e5dae:	62 b1 0d 48 72 d2 10 	vpsrld $0x10,%zmm18,%zmm14
 18e5db5:	62 f1 1d 48 fe f6    	vpaddd %zmm6,%zmm12,%zmm6
 18e5dbb:	62 12 1d 48 3b e5    	vpminud %zmm29,%zmm12,%zmm12
 18e5dc1:	62 a1 0d 48 fe d8    	vpaddd %zmm16,%zmm14,%zmm19
 18e5dc7:	62 51 0d 48 fe c0    	vpaddd %zmm8,%zmm14,%zmm8
 18e5dcd:	62 92 4d 48 3b f5    	vpminud %zmm29,%zmm6,%zmm6
 18e5dd3:	c5 7b 93 d8          	kmovd  %k0,%r11d
 18e5dd7:	62 b2 7e 40 27 c0    	vptestnmd %zmm16,%zmm16,%k0
 18e5ddd:	c5 fb 93 d8          	kmovd  %k0,%ebx
 18e5de1:	62 f3 65 50 1f 05 8c 0c cd fe 01 	vpcmpltd -0x132f374(%rip){1to16},%zmm19,%k0        # 5b6a78 <tier0_emit_x87.operations+0x28>
 18e5dec:	41 09 fb             	or     %edi,%r11d
 18e5def:	c5 fb 93 c8          	kmovd  %k0,%ecx
 18e5df3:	62 b2 75 40 27 c1    	vptestmd %zmm17,%zmm17,%k0
 18e5df9:	c5 fb 93 c0          	kmovd  %k0,%eax
 18e5dfd:	62 d2 05 49 27 c7    	vptestmd %zmm15,%zmm15,%k0{%k1}
 18e5e03:	62 f3 6d 50 1e 0d 72 0c cd fe 01 	vpcmpltud -0x132f38e(%rip){1to16},%zmm18,%k1        # 5b6a80 <tier0_emit_x87.operations+0x30>
 18e5e0e:	09 d9                	or     %ebx,%ecx
 18e5e10:	44 21 d9             	and    %r11d,%ecx
 18e5e13:	c4 e2 70 f2 f8       	andn   %eax,%ecx,%edi
 18e5e18:	48 8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%rcx
 18e5e20:	62 b2 7d 41 27 c8    	vptestmd %zmm16,%zmm16,%k1{%k1}
 18e5e26:	c5 f4 45 c0          	korw   %k0,%k1,%k0
 18e5e2a:	c5 7b 93 d0          	kmovd  %k0,%r10d
 18e5e2e:	62 f2 7e 58 27 05 2c 0c cd fe 	vptestnmd -0x132f3d4(%rip){1to16},%zmm0,%k0        # 5b6a64 <tier0_emit_x87.operations+0x14>
 18e5e38:	41 21 fa             	and    %edi,%r10d
 18e5e3b:	44 09 cf             	or     %r9d,%edi
 18e5e3e:	21 f7                	and    %esi,%edi
 18e5e40:	41 89 f9             	mov    %edi,%r9d
 18e5e43:	31 f7                	xor    %esi,%edi
 18e5e45:	c5 7b 93 c0          	kmovd  %k0,%r8d
 18e5e49:	62 f2 75 5a 27 05 39 0c cd fe 	vptestmd -0x132f3c7(%rip){1to16},%zmm1,%k0{%k2}        # 5b6a8c <tier0_emit_x87.operations+0x3c>
 18e5e53:	62 d2 7e 48 39 d1    	vpmovd2m %zmm9,%k2
 18e5e59:	62 11 fd 48 6f cf    	vmovdqa64 %zmm31,%zmm9
 18e5e5f:	62 f1 7d 48 70 c9 ff 	vpshufd $0xff,%zmm1,%zmm1
 18e5e66:	45 21 c1             	and    %r8d,%r9d
 18e5e69:	62 11 0d 4a eb c8    	vpord  %zmm24,%zmm14,%zmm9{%k2}
 18e5e6f:	44 21 c7             	and    %r8d,%edi
 18e5e72:	62 f3 f5 48 43 c9 ff 	vshufi64x2 $0xff,%zmm1,%zmm1,%zmm1
 18e5e79:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
 18e5e7e:	41 89 f8             	mov    %edi,%r8d
 18e5e81:	62 51 7d c9 6f db    	vmovdqa32 %zmm11,%zmm11{%k1}{z}
 18e5e87:	62 33 25 48 03 fc 0f 	valignd $0xf,%zmm20,%zmm11,%zmm15
 18e5e8e:	62 51 25 48 fe ff    	vpaddd %zmm15,%zmm11,%zmm15
 18e5e94:	62 51 7d 4c 6f fb    	vmovdqa32 %zmm11,%zmm15{%k4}
 18e5e9a:	62 a3 85 48 03 c4 07 	valignq $0x7,%zmm20,%zmm15,%zmm16
 18e5ea1:	62 a1 05 48 fe c0    	vpaddd %zmm16,%zmm15,%zmm16
 18e5ea7:	c5 7b 93 d8          	kmovd  %k0,%r11d
 18e5eab:	62 d2 16 48 27 c5    	vptestnmd %zmm13,%zmm13,%k0
 18e5eb1:	62 f1 15 48 72 d0 14 	vpsrld $0x14,%zmm0,%zmm13
 18e5eb8:	62 c1 7d 4d 6f c7    	vmovdqa32 %zmm15,%zmm16{%k5}
 18e5ebe:	62 33 fd 40 03 fc 06 	valignq $0x6,%zmm20,%zmm16,%zmm15
 18e5ec5:	c5 fb 93 d8          	kmovd  %k0,%ebx
 18e5ec9:	62 d2 2d 48 27 c2    	vptestmd %zmm10,%zmm10,%k0
 18e5ecf:	c5 fb 93 c0          	kmovd  %k0,%eax
 18e5ed3:	44 21 db             	and    %r11d,%ebx
 18e5ed6:	62 51 7d 40 fe ff    	vpaddd %zmm15,%zmm16,%zmm15
 18e5edc:	09 d8                	or     %ebx,%eax
 18e5ede:	62 31 7d 4b 6f f8    	vmovdqa32 %zmm16,%zmm15{%k3}
 18e5ee4:	62 e1 05 48 fe c5    	vpaddd %zmm5,%zmm15,%zmm16
 18e5eea:	62 f1 15 58 db 2d 90 0b cd fe 	vpandd -0x132f470(%rip){1to16},%zmm13,%zmm5        # 5b6a84 <tier0_emit_x87.operations+0x34>
 18e5ef4:	62 33 85 48 03 d4 04 	valignq $0x4,%zmm20,%zmm15,%zmm10
 18e5efb:	44 09 d0             	or     %r10d,%eax
 18e5efe:	62 c1 7d 4f 6f c7    	vmovdqa32 %zmm15,%zmm16{%k7}
 18e5f04:	62 f1 55 58 66 05 7a 0b cd fe 	vpcmpgtd -0x132f486(%rip){1to16},%zmm5,%k0        # 5b6a88 <tier0_emit_x87.operations+0x38>
 18e5f0e:	62 72 35 40 47 ed    	vpsllvd %zmm5,%zmm25,%zmm13
 18e5f14:	62 d1 7d 40 fe ea    	vpaddd %zmm10,%zmm16,%zmm5
 18e5f1a:	62 b1 7d 4e 6f e8    	vmovdqa32 %zmm16,%zmm5{%k6}
 18e5f20:	62 51 55 48 fa d3    	vpsubd %zmm11,%zmm5,%zmm10
 18e5f26:	62 53 25 48 25 db ff 	vpternlogd $0xff,%zmm11,%zmm11,%zmm11
 18e5f2d:	62 51 15 48 fe db    	vpaddd %zmm11,%zmm13,%zmm11
 18e5f33:	62 51 2d 48 db db    	vpandd %zmm11,%zmm10,%zmm11
 18e5f39:	62 73 7d 58 25 1d 54 0b cd fe f8 	vpternlogd $0xf8,-0x132f4ac(%rip){1to16},%zmm0,%zmm11        # 5b6a98 <tier0_emit_x87.operations+0x48>
 18e5f44:	62 d2 25 48 27 fb    	vptestmd %zmm11,%zmm11,%k7
 18e5f4a:	c5 fc 45 c7          	korw   %k7,%k0,%k0
 18e5f4e:	c5 7b 93 d0          	kmovd  %k0,%r10d
 18e5f52:	45 21 ca             	and    %r9d,%r10d
 18e5f55:	41 09 c2             	or     %eax,%r10d
 18e5f58:	48 8b 84 24 40 01 00 00 	mov    0x140(%rsp),%rax
 18e5f60:	41 21 f2             	and    %esi,%r10d
 18e5f63:	c1 ee 08             	shr    $0x8,%esi
 18e5f66:	c4 c1 7b 92 c2       	kmovd  %r10d,%k0
 18e5f6b:	62 72 7e 48 38 d8    	vpmovm2d %k0,%zmm11
 18e5f71:	62 d1 25 48 72 d3 1f 	vpsrld $0x1f,%zmm11,%zmm11
 18e5f78:	62 51 25 49 eb dd    	vpord  %zmm13,%zmm11,%zmm11{%k1}
 18e5f7e:	62 33 25 48 03 ec 0f 	valignd $0xf,%zmm20,%zmm11,%zmm13
 18e5f85:	62 51 25 48 eb ed    	vpord  %zmm13,%zmm11,%zmm13
 18e5f8b:	62 51 7d 4c 6f eb    	vmovdqa32 %zmm11,%zmm13{%k4}
 18e5f91:	62 33 95 48 03 dc 07 	valignq $0x7,%zmm20,%zmm13,%zmm11
 18e5f98:	62 51 15 48 eb fb    	vpord  %zmm11,%zmm13,%zmm15
 18e5f9e:	62 51 7d 4d 6f fd    	vmovdqa32 %zmm13,%zmm15{%k5}
 18e5fa4:	62 33 85 48 03 dc 06 	valignq $0x6,%zmm20,%zmm15,%zmm11
 18e5fab:	62 51 05 48 eb db    	vpord  %zmm11,%zmm15,%zmm11
 18e5fb1:	62 51 7d 4b 6f df    	vmovdqa32 %zmm15,%zmm11{%k3}
 18e5fb7:	c5 f8 90 9c 24 f8 00 00 00 	kmovw  0xf8(%rsp),%k3
 18e5fc0:	62 33 a5 48 03 fc 04 	valignq $0x4,%zmm20,%zmm11,%zmm15
 18e5fc7:	62 71 7d cb 6f ea    	vmovdqa32 %zmm2,%zmm13{%k3}{z}
 18e5fcd:	62 d1 15 48 eb d7    	vpord  %zmm15,%zmm13,%zmm2
 18e5fd3:	62 f1 05 48 72 f0 1f 	vpslld $0x1f,%zmm0,%zmm15
 18e5fda:	62 d2 7e 48 39 d7    	vpmovd2m %zmm15,%k2
 18e5fe0:	62 d1 7d 4e 6f d5    	vmovdqa32 %zmm13,%zmm2{%k6}
 18e5fe6:	62 12 1d 4a 36 ce    	vpermd %zmm30,%zmm12,%zmm9{%k2}
 18e5fec:	62 f2 45 48 27 d7    	vptestmd %zmm7,%zmm7,%k2
 18e5ff2:	62 91 fd 48 6f ff    	vmovdqa64 %zmm31,%zmm7
 18e5ff8:	62 91 3d 4a eb f8    	vpord  %zmm24,%zmm8,%zmm7{%k2}
 18e5ffe:	62 f2 5e 48 27 d4    	vptestnmd %zmm4,%zmm4,%k2
 18e6004:	62 92 4d 48 36 e6    	vpermd %zmm30,%zmm6,%zmm4
 18e600a:	62 51 7d c9 6f c2    	vmovdqa32 %zmm10,%zmm8{%k1}{z}
 18e6010:	62 f1 7d 4a 6f e7    	vmovdqa32 %zmm7,%zmm4{%k2}
 18e6016:	62 92 7d 48 27 d4    	vptestmd %zmm28,%zmm0,%k2
 18e601c:	62 b1 fd 48 6f fd    	vmovdqa64 %zmm21,%zmm7
 18e6022:	62 f1 7d 48 72 f0 0e 	vpslld $0xe,%zmm0,%zmm0
 18e6029:	c5 7b 93 ca          	kmovd  %k2,%r9d
 18e602d:	62 d2 5d 4a 64 f1    	vpblendmd %zmm9,%zmm4,%zmm6{%k2}
 18e6033:	62 b1 7d 48 db c6    	vpandd %zmm22,%zmm0,%zmm0
 18e6039:	45 21 c8             	and    %r9d,%r8d
 18e603c:	c4 c1 7b 92 d0       	kmovd  %r8d,%k2
 18e6041:	c4 62 30 f2 c7       	andn   %edi,%r9d,%r8d
 18e6046:	62 f1 45 4a 72 f4 08 	vpslld $0x8,%zmm4,%zmm7{%k2}
 18e604d:	c5 fb 92 d7          	kmovd  %edi,%k2
 18e6051:	62 72 7d ca 58 0d 51 0a cd fe 	vpbroadcastd -0x132f5af(%rip),%zmm9{%k2}{z}        # 5b6aac <tier0_emit_x87.operations+0x5c>
 18e605b:	62 f2 05 42 64 e6    	vpblendmd %zmm6,%zmm31,%zmm4{%k2}
 18e6061:	c4 c1 7b 92 d0       	kmovd  %r8d,%k2
 18e6066:	62 d1 fd 48 6f f0    	vmovdqa64 %zmm8,%zmm6
 18e606c:	62 b1 7d 4a eb c7    	vpord  %zmm23,%zmm0,%zmm0{%k2}
 18e6072:	62 f1 45 48 eb e4    	vpord  %zmm4,%zmm7,%zmm4
 18e6078:	62 72 7d 49 58 0d 2e 0a cd fe 	vpbroadcastd -0x132f5d2(%rip),%zmm9{%k1}        # 5b6ab0 <tier0_emit_x87.operations+0x60>
 18e6082:	c5 f8 90 8c 24 e8 00 00 00 	kmovw  0xe8(%rsp),%k1
 18e608b:	62 d3 5d 48 25 c1 fe 	vpternlogd $0xfe,%zmm9,%zmm4,%zmm0
 18e6092:	62 d1 7f 89 6f 24 16 	vmovdqu8 (%r14,%rdx,1),%xmm4{%k1}{z}
 18e6099:	62 f2 2d 40 7e f0    	vpermt2d %zmm0,%zmm26,%zmm6
 18e609f:	62 72 25 40 7e c0    	vpermt2d %zmm0,%zmm27,%zmm8
 18e60a5:	62 f1 fe 49 7f 74 d0 ff 	vmovdqu64 %zmm6,-0x40(%rax,%rdx,8){%k1}
 18e60ad:	c5 fb 92 ce          	kmovd  %esi,%k1
 18e60b1:	48 8b b4 24 28 01 00 00 	mov    0x128(%rsp),%rsi
 18e60b9:	62 71 fe 49 7f 04 d0 	vmovdqu64 %zmm8,(%rax,%rdx,8){%k1}
 18e60c0:	c5 f9 71 f4 07       	vpsllw $0x7,%xmm4,%xmm0
 18e60c5:	62 f2 7e 08 29 c8    	vpmovb2m %xmm0,%k1
 18e60cb:	62 d1 6d 48 eb c3    	vpord  %zmm11,%zmm2,%zmm0
 18e60d1:	62 f1 7d 48 70 d3 ff 	vpshufd $0xff,%zmm3,%zmm2
 18e60d8:	62 f1 7e 49 7f 1c 91 	vmovdqu32 %zmm3,(%rcx,%rdx,4){%k1}
 18e60df:	48 8b 8c 24 00 01 00 00 	mov    0x100(%rsp),%rcx
 18e60e7:	62 f3 ed 48 43 da ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm3
 18e60ee:	62 f1 7d 48 70 d5 ff 	vpshufd $0xff,%zmm5,%zmm2
 18e60f5:	62 f1 7e 49 7f 2c 96 	vmovdqu32 %zmm5,(%rsi,%rdx,4){%k1}
 18e60fc:	62 f3 ed 48 43 ea ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm5
 18e6103:	62 f1 7e 49 7f 04 91 	vmovdqu32 %zmm0,(%rcx,%rdx,4){%k1}
 18e610a:	62 f1 7d 48 70 c0 ff 	vpshufd $0xff,%zmm0,%zmm0
 18e6111:	48 83 c2 10          	add    $0x10,%rdx
 18e6115:	62 f3 fd 48 43 d0 ff 	vshufi64x2 $0xff,%zmm0,%zmm0,%zmm2
 18e611c:	4c 39 e2             	cmp    %r12,%rdx
 18e611f:	0f 82 3d fa ff ff    	jb     18e5b62 <run_backend_benchmark+0x8a92>
 18e6125:	83 bc 24 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rsp)
 18e612d:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 18e6135:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18e613a:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 18e613f:	48 8b 8c 24 d0 00 00 00 	mov    0xd0(%rsp),%rcx
 18e6147:	48 8b bc 24 e0 00 00 00 	mov    0xe0(%rsp),%rdi
 18e614f:	0f 84 d0 ea ff ff    	je     18e4c25 <run_backend_benchmark+0x7b55>
 18e6155:	4c 8b 64 24 70       	mov    0x70(%rsp),%r12
 18e615a:	4c 8d 3c 8d 00 00 00 00 	lea    0x0(,%rcx,4),%r15
 18e6162:	45 31 f6             	xor    %r14d,%r14d
 18e6165:	31 db                	xor    %ebx,%ebx
 18e6167:	eb 2f                	jmp    18e6198 <run_backend_benchmark+0x90c8>
 18e6169:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 18e6171:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 18e6176:	48 8b bc 24 e0 00 00 00 	mov    0xe0(%rsp),%rdi
 18e617e:	4d 89 ec             	mov    %r13,%r12
 18e6181:	48 ff c3             	inc    %rbx
 18e6184:	49 83 c4 10          	add    $0x10,%r12
 18e6188:	49 83 c6 04          	add    $0x4,%r14
 18e618c:	48 ff c0             	inc    %rax
 18e618f:	4d 39 f7             	cmp    %r14,%r15
 18e6192:	0f 84 8d ea ff ff    	je     18e4c25 <run_backend_benchmark+0x7b55>
 18e6198:	42 8b 14 32          	mov    (%rdx,%r14,1),%edx
 18e619c:	4c 8b 8c 24 28 01 00 00 	mov    0x128(%rsp),%r9
 18e61a4:	48 8b b4 24 00 01 00 00 	mov    0x100(%rsp),%rsi
 18e61ac:	48 89 84 24 a0 00 00 00 	mov    %rax,0xa0(%rsp)
 18e61b4:	48 85 d2             	test   %rdx,%rdx
 18e61b7:	74 5b                	je     18e6214 <run_backend_benchmark+0x9144>
 18e61b9:	4e 8b 04 77          	mov    (%rdi,%r14,2),%r8
 18e61bd:	48 8b 84 24 08 01 00 00 	mov    0x108(%rsp),%rax
 18e61c5:	4c 8b 5c 24 70       	mov    0x70(%rsp),%r11
 18e61ca:	4d 89 e5             	mov    %r12,%r13
 18e61cd:	49 89 dc             	mov    %rbx,%r12
 18e61d0:	49 c1 e4 04          	shl    $0x4,%r12
 18e61d4:	49 01 d0             	add    %rdx,%r8
 18e61d7:	4d 01 dc             	add    %r11,%r12
 18e61da:	42 8b 4c 80 fc       	mov    -0x4(%rax,%r8,4),%ecx
 18e61df:	42 8b 44 86 fc       	mov    -0x4(%rsi,%r8,4),%eax
 18e61e4:	47 8b 44 81 fc       	mov    -0x4(%r9,%r8,4),%r8d
 18e61e9:	41 b9 04 00 00 00    	mov    $0x4,%r9d
 18e61ef:	89 c6                	mov    %eax,%esi
 18e61f1:	83 ce 01             	or     $0x1,%esi
 18e61f4:	0f b7 f9             	movzwl %cx,%edi
 18e61f7:	f3 0f bd f6          	lzcnt  %esi,%esi
 18e61fb:	83 f6 1f             	xor    $0x1f,%esi
 18e61fe:	83 fe 05             	cmp    $0x5,%esi
 18e6201:	41 0f 42 f1          	cmovb  %r9d,%esi
 18e6205:	83 ff 06             	cmp    $0x6,%edi
 18e6208:	41 b9 06 00 00 00    	mov    $0x6,%r9d
 18e620e:	41 0f 43 f9          	cmovae %r9d,%edi
 18e6212:	eb 20                	jmp    18e6234 <run_backend_benchmark+0x9164>
 18e6214:	48 8b 84 24 08 01 00 00 	mov    0x108(%rsp),%rax
 18e621c:	4c 8b 5c 24 70       	mov    0x70(%rsp),%r11
 18e6221:	45 31 c0             	xor    %r8d,%r8d
 18e6224:	4d 89 e5             	mov    %r12,%r13
 18e6227:	8b 08                	mov    (%rax),%ecx
 18e6229:	8b 06                	mov    (%rsi),%eax
 18e622b:	43 0f b6 7c b3 05    	movzbl 0x5(%r11,%r14,4),%edi
 18e6231:	40 b6 04             	mov    $0x4,%sil
 18e6234:	c1 e9 10             	shr    $0x10,%ecx
 18e6237:	41 b9 08 00 00 00    	mov    $0x8,%r9d
 18e623d:	45 89 04 24          	mov    %r8d,(%r12)
 18e6241:	43 88 74 b3 04       	mov    %sil,0x4(%r11,%r14,4)
 18e6246:	be 00 00 00 00       	mov    $0x0,%esi
 18e624b:	43 88 7c b3 05       	mov    %dil,0x5(%r11,%r14,4)
 18e6250:	83 f9 08             	cmp    $0x8,%ecx
 18e6253:	41 0f 43 c9          	cmovae %r9d,%ecx
 18e6257:	48 85 d2             	test   %rdx,%rdx
 18e625a:	0f 44 ce             	cmove  %esi,%ecx
 18e625d:	43 88 4c b3 06       	mov    %cl,0x6(%r11,%r14,4)
 18e6262:	0f 84 01 ff ff ff    	je     18e6169 <run_backend_benchmark+0x9099>
 18e6268:	83 e0 01             	and    $0x1,%eax
 18e626b:	0f 84 f8 fe ff ff    	je     18e6169 <run_backend_benchmark+0x9099>
 18e6271:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 18e6276:	48 8b bc 24 a0 00 00 00 	mov    0xa0(%rsp),%rdi
 18e627e:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 18e6283:	48 8b b4 24 c0 00 00 00 	mov    0xc0(%rsp),%rsi
 18e628b:	42 8b 0c 30          	mov    (%rax,%r14,1),%ecx
 18e628f:	48 8b 84 24 e0 00 00 00 	mov    0xe0(%rsp),%rax
 18e6297:	47 8b 0c 33          	mov    (%r11,%r14,1),%r9d
 18e629b:	39 d1                	cmp    %edx,%ecx
 18e629d:	4a 8b 04 70          	mov    (%rax,%r14,2),%rax
 18e62a1:	0f 43 ca             	cmovae %edx,%ecx
 18e62a4:	45 31 c0             	xor    %r8d,%r8d
 18e62a7:	80 3f 00             	cmpb   $0x0,(%rdi)
 18e62aa:	48 8d bc 24 80 0e 00 00 	lea    0xe80(%rsp),%rdi
 18e62b2:	48 8d 34 86          	lea    (%rsi,%rax,4),%rsi
 18e62b6:	49 8d 04 c2          	lea    (%r10,%rax,8),%rax
 18e62ba:	41 0f 95 c0          	setne  %r8b
 18e62be:	48 89 04 24          	mov    %rax,(%rsp)
 18e62c2:	c5 f8 77             	vzeroupper
 18e62c5:	e8 b6 a4 02 00       	call   1910780 <abi_assign_call>
 18e62ca:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18e62cf:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
 18e62d4:	49 89 04 24          	mov    %rax,(%r12)
 18e62d8:	4a 89 54 b1 08       	mov    %rdx,0x8(%rcx,%r14,4)
 18e62dd:	e9 87 fe ff ff       	jmp    18e6169 <run_backend_benchmark+0x9099>
 18e62e2:	48 89 cf             	mov    %rcx,%rdi
 18e62e5:	4c 29 ef             	sub    %r13,%rdi
 18e62e8:	4c 89 f2             	mov    %r14,%rdx
 18e62eb:	48 29 fa             	sub    %rdi,%rdx
 18e62ee:	41 0f 92 c0          	setb   %r8b
 18e62f2:	48 81 fa 00 00 80 06 	cmp    $0x6800000,%rdx
 18e62f9:	0f 92 c2             	setb   %dl
 18e62fc:	44 08 c2             	or     %r8b,%dl
 18e62ff:	80 fa 01             	cmp    $0x1,%dl
 18e6302:	75 04                	jne    18e6308 <run_backend_benchmark+0x9238>
 18e6304:	31 d2                	xor    %edx,%edx
 18e6306:	eb 39                	jmp    18e6341 <run_backend_benchmark+0x9271>
 18e6308:	48 81 c6 07 00 80 06 	add    $0x6800007,%rsi
 18e630f:	48 81 c7 00 00 80 06 	add    $0x6800000,%rdi
 18e6316:	48 8d 91 00 00 80 06 	lea    0x6800000(%rcx),%rdx
 18e631d:	48 89 8c 24 70 01 00 00 	mov    %rcx,0x170(%rsp)
 18e6325:	48 83 e6 f8          	and    $0xfffffffffffffff8,%rsi
 18e6329:	48 89 fb             	mov    %rdi,%rbx
 18e632c:	48 39 d6             	cmp    %rdx,%rsi
 18e632f:	0f 82 93 c3 ff ff    	jb     18e26c8 <run_backend_benchmark+0x55f8>
 18e6335:	48 89 f7             	mov    %rsi,%rdi
 18e6338:	4c 29 ef             	sub    %r13,%rdi
 18e633b:	48 89 ca             	mov    %rcx,%rdx
 18e633e:	48 89 f1             	mov    %rsi,%rcx
 18e6341:	4c 89 f6             	mov    %r14,%rsi
 18e6344:	48 29 fe             	sub    %rdi,%rsi
 18e6347:	41 0f 92 c0          	setb   %r8b
 18e634b:	48 81 fe 00 00 80 00 	cmp    $0x800000,%rsi
 18e6352:	40 0f 92 c6          	setb   %sil
 18e6356:	44 08 c6             	or     %r8b,%sil
 18e6359:	40 80 fe 01          	cmp    $0x1,%sil
 18e635d:	75 10                	jne    18e636f <run_backend_benchmark+0x929f>
 18e635f:	48 c7 84 24 78 01 00 00 00 00 00 00 	movq   $0x0,0x178(%rsp)
 18e636b:	31 f6                	xor    %esi,%esi
 18e636d:	eb 38                	jmp    18e63a7 <run_backend_benchmark+0x92d7>
 18e636f:	4e 8d 84 2f 07 00 80 00 	lea    0x800007(%rdi,%r13,1),%r8
 18e6377:	4a 8d b4 2f 00 00 80 00 	lea    0x800000(%rdi,%r13,1),%rsi
 18e637f:	48 8d 9f 00 00 80 00 	lea    0x800000(%rdi),%rbx
 18e6386:	48 89 8c 24 78 01 00 00 	mov    %rcx,0x178(%rsp)
 18e638e:	49 83 e0 f8          	and    $0xfffffffffffffff8,%r8
 18e6392:	49 39 f0             	cmp    %rsi,%r8
 18e6395:	0f 82 3e c3 ff ff    	jb     18e26d9 <run_backend_benchmark+0x5609>
 18e639b:	4c 89 c7             	mov    %r8,%rdi
 18e639e:	4c 29 ef             	sub    %r13,%rdi
 18e63a1:	48 89 ce             	mov    %rcx,%rsi
 18e63a4:	4c 89 c1             	mov    %r8,%rcx
 18e63a7:	4d 89 f0             	mov    %r14,%r8
 18e63aa:	49 29 f8             	sub    %rdi,%r8
 18e63ad:	41 0f 92 c1          	setb   %r9b
 18e63b1:	49 81 f8 00 00 80 00 	cmp    $0x800000,%r8
 18e63b8:	41 0f 92 c0          	setb   %r8b
 18e63bc:	45 08 c8             	or     %r9b,%r8b
 18e63bf:	41 80 f8 01          	cmp    $0x1,%r8b
 18e63c3:	75 11                	jne    18e63d6 <run_backend_benchmark+0x9306>
 18e63c5:	48 c7 84 24 80 01 00 00 00 00 00 00 	movq   $0x0,0x180(%rsp)
 18e63d1:	45 31 c0             	xor    %r8d,%r8d
 18e63d4:	eb 38                	jmp    18e640e <run_backend_benchmark+0x933e>
 18e63d6:	4e 8d 8c 2f 07 00 80 00 	lea    0x800007(%rdi,%r13,1),%r9
 18e63de:	4e 8d 84 2f 00 00 80 00 	lea    0x800000(%rdi,%r13,1),%r8
 18e63e6:	48 8d 9f 00 00 80 00 	lea    0x800000(%rdi),%rbx
 18e63ed:	48 89 8c 24 80 01 00 00 	mov    %rcx,0x180(%rsp)
 18e63f5:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
 18e63f9:	4d 39 c1             	cmp    %r8,%r9
 18e63fc:	0f 82 e8 c2 ff ff    	jb     18e26ea <run_backend_benchmark+0x561a>
 18e6402:	4c 89 cf             	mov    %r9,%rdi
 18e6405:	4c 29 ef             	sub    %r13,%rdi
 18e6408:	49 89 c8             	mov    %rcx,%r8
 18e640b:	4c 89 c9             	mov    %r9,%rcx
 18e640e:	4d 89 f1             	mov    %r14,%r9
 18e6411:	49 29 f9             	sub    %rdi,%r9
 18e6414:	41 0f 92 c2          	setb   %r10b
 18e6418:	49 81 f9 00 00 80 00 	cmp    $0x800000,%r9
 18e641f:	41 0f 92 c1          	setb   %r9b
 18e6423:	45 08 d1             	or     %r10b,%r9b
 18e6426:	41 80 f9 01          	cmp    $0x1,%r9b
 18e642a:	75 26                	jne    18e6452 <run_backend_benchmark+0x9382>
 18e642c:	48 c7 84 24 88 01 00 00 00 00 00 00 	movq   $0x0,0x188(%rsp)
 18e6438:	45 31 d2             	xor    %r10d,%r10d
 18e643b:	eb 4d                	jmp    18e648a <run_backend_benchmark+0x93ba>
 18e643d:	48 8b 05 24 3d b2 00 	mov    0xb23d24(%rip),%rax        # 240a168 <stderr@GLIBC_2.2.5>
 18e6444:	48 8d 3d c2 82 d7 fe 	lea    -0x1287d3e(%rip),%rdi        # 65e70d <fuzz_comment_end+0x14a43>
 18e644b:	be 7a 00 00 00       	mov    $0x7a,%esi
 18e6450:	eb 77                	jmp    18e64c9 <run_backend_benchmark+0x93f9>
 18e6452:	4e 8d 8c 2f 07 00 80 00 	lea    0x800007(%rdi,%r13,1),%r9
 18e645a:	4e 8d 94 2f 00 00 80 00 	lea    0x800000(%rdi,%r13,1),%r10
 18e6462:	48 8d 9f 00 00 80 00 	lea    0x800000(%rdi),%rbx
 18e6469:	48 89 8c 24 88 01 00 00 	mov    %rcx,0x188(%rsp)
 18e6471:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
 18e6475:	4d 39 d1             	cmp    %r10,%r9
 18e6478:	0f 82 7d c2 ff ff    	jb     18e26fb <run_backend_benchmark+0x562b>
 18e647e:	4c 89 cf             	mov    %r9,%rdi
 18e6481:	4c 29 ef             	sub    %r13,%rdi
 18e6484:	49 89 ca             	mov    %rcx,%r10
 18e6487:	4c 89 c9             	mov    %r9,%rcx
 18e648a:	4d 89 f1             	mov    %r14,%r9
 18e648d:	49 29 f9             	sub    %rdi,%r9
 18e6490:	41 0f 92 c3          	setb   %r11b
 18e6494:	49 81 f9 00 00 80 00 	cmp    $0x800000,%r9
 18e649b:	41 0f 92 c1          	setb   %r9b
 18e649f:	45 08 d9             	or     %r11b,%r9b
 18e64a2:	74 40                	je     18e64e4 <run_backend_benchmark+0x9414>
 18e64a4:	45 31 c9             	xor    %r9d,%r9d
 18e64a7:	4c 89 d1             	mov    %r10,%rcx
 18e64aa:	e9 4f c2 ff ff       	jmp    18e26fe <run_backend_benchmark+0x562e>
 18e64af:	c6 05 4a 6d 70 0d 00 	movb   $0x0,0xd706d4a(%rip)        # efed200 <tier0_initialized>
 18e64b6:	48 8b 05 ab 3c b2 00 	mov    0xb23cab(%rip),%rax        # 240a168 <stderr@GLIBC_2.2.5>
 18e64bd:	48 8d 3d 4f 70 dd fe 	lea    -0x1228fb1(%rip),%rdi        # 6bd513 <pp_string_value.meaning+0x29f5b>
 18e64c4:	be 2d 00 00 00       	mov    $0x2d,%esi
 18e64c9:	48 8b 08             	mov    (%rax),%rcx
 18e64cc:	ba 01 00 00 00       	mov    $0x1,%edx
 18e64d1:	c5 f8 77             	vzeroupper
 18e64d4:	e8 f7 3a eb fe       	call   799fd0 <fwrite@plt>
 18e64d9:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 18e64df:	e9 a7 02 00 00       	jmp    18e678b <run_backend_benchmark+0x96bb>
 18e64e4:	48 81 c7 00 00 80 00 	add    $0x800000,%rdi
 18e64eb:	49 89 c9             	mov    %rcx,%r9
 18e64ee:	4c 89 d1             	mov    %r10,%rcx
 18e64f1:	48 89 fb             	mov    %rdi,%rbx
 18e64f4:	e9 05 c2 ff ff       	jmp    18e26fe <run_backend_benchmark+0x562e>
 18e64f9:	41 8b 47 18          	mov    0x18(%r15),%eax
 18e64fd:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 18e6502:	48 8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%rsi
 18e650a:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 18e6512:	41 ff c6             	inc    %r14d
 18e6515:	48 01 c1             	add    %rax,%rcx
 18e6518:	8b 84 24 6c 02 00 00 	mov    0x26c(%rsp),%eax
 18e651f:	4c 01 ee             	add    %r13,%rsi
 18e6522:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18e6527:	48 01 c2             	add    %rax,%rdx
 18e652a:	e9 8e 00 00 00       	jmp    18e65bd <run_backend_benchmark+0x94ed>
 18e652f:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18e6534:	4d 85 ed             	test   %r13,%r13
 18e6537:	0f 85 b3 00 00 00    	jne    18e65f0 <run_backend_benchmark+0x9520>
 18e653d:	e9 d5 00 00 00       	jmp    18e6617 <run_backend_benchmark+0x9547>
 18e6542:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 18e6547:	44 89 b4 24 98 01 00 00 	mov    %r14d,0x198(%rsp)
 18e654f:	48 8b 94 24 30 01 00 00 	mov    0x130(%rsp),%rdx
 18e6557:	48 8d 35 37 e8 db fe 	lea    -0x12417c9(%rip),%rsi        # 6a4d95 <pp_string_value.meaning+0x117dd>
 18e655e:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 18e6563:	48 89 84 24 a0 01 00 00 	mov    %rax,0x1a0(%rsp)
 18e656b:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 18e6573:	48 89 84 24 a8 01 00 00 	mov    %rax,0x1a8(%rsp)
 18e657b:	48 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%rax
 18e6583:	48 89 84 24 b0 01 00 00 	mov    %rax,0x1b0(%rsp)
 18e658b:	48 8b 05 d6 3b b2 00 	mov    0xb23bd6(%rip),%rax        # 240a168 <stderr@GLIBC_2.2.5>
 18e6592:	48 8b 38             	mov    (%rax),%rdi
 18e6595:	31 c0                	xor    %eax,%eax
 18e6597:	e8 d4 36 eb fe       	call   799c70 <fprintf@plt>
 18e659c:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18e65a1:	eb 3a                	jmp    18e65dd <run_backend_benchmark+0x950d>
 18e65a3:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18e65a8:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 18e65ad:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 18e65b5:	48 8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%rsi
 18e65bd:	44 89 b4 24 98 01 00 00 	mov    %r14d,0x198(%rsp)
 18e65c5:	48 89 8c 24 a0 01 00 00 	mov    %rcx,0x1a0(%rsp)
 18e65cd:	48 89 b4 24 a8 01 00 00 	mov    %rsi,0x1a8(%rsp)
 18e65d5:	48 89 94 24 b0 01 00 00 	mov    %rdx,0x1b0(%rsp)
 18e65dd:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
 18e65e5:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 18e65eb:	4d 85 ed             	test   %r13,%r13
 18e65ee:	74 27                	je     18e6617 <run_backend_benchmark+0x9547>
 18e65f0:	4c 2b ac 24 38 01 00 00 	sub    0x138(%rsp),%r13
 18e65f8:	48 83 bc 24 60 01 00 00 ff 	cmpq   $0xffffffffffffffff,0x160(%rsp)
 18e6601:	49 8d b6 00 00 20 00 	lea    0x200000(%r14),%rsi
 18e6608:	49 0f 44 f6          	cmove  %r14,%rsi
 18e660c:	4c 89 ef             	mov    %r13,%rdi
 18e660f:	c5 f8 77             	vzeroupper
 18e6612:	e8 d9 31 eb fe       	call   7997f0 <munmap@plt>
 18e6617:	48 8b bc 24 e0 01 00 00 	mov    0x1e0(%rsp),%rdi
 18e661f:	48 85 ff             	test   %rdi,%rdi
 18e6622:	74 37                	je     18e665b <run_backend_benchmark+0x958b>
 18e6624:	48 8b 84 24 f0 01 00 00 	mov    0x1f0(%rsp),%rax
 18e662c:	48 2b bc 24 f8 01 00 00 	sub    0x1f8(%rsp),%rdi
 18e6634:	48 8d 88 ff 0f 00 00 	lea    0xfff(%rax),%rcx
 18e663b:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
 18e6642:	48 3d 01 00 01 00    	cmp    $0x10001,%rax
 18e6648:	48 8d b1 00 00 20 00 	lea    0x200000(%rcx),%rsi
 18e664f:	48 0f 42 f1          	cmovb  %rcx,%rsi
 18e6653:	c5 f8 77             	vzeroupper
 18e6656:	e8 95 31 eb fe       	call   7997f0 <munmap@plt>
 18e665b:	48 8b bc 24 c0 01 00 00 	mov    0x1c0(%rsp),%rdi
 18e6663:	48 85 ff             	test   %rdi,%rdi
 18e6666:	74 37                	je     18e669f <run_backend_benchmark+0x95cf>
 18e6668:	48 8b 84 24 d0 01 00 00 	mov    0x1d0(%rsp),%rax
 18e6670:	48 2b bc 24 d8 01 00 00 	sub    0x1d8(%rsp),%rdi
 18e6678:	48 8d 88 ff 0f 00 00 	lea    0xfff(%rax),%rcx
 18e667f:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
 18e6686:	48 3d 01 00 01 00    	cmp    $0x10001,%rax
 18e668c:	48 8d b1 00 00 20 00 	lea    0x200000(%rcx),%rsi
 18e6693:	48 0f 42 f1          	cmovb  %rcx,%rsi
 18e6697:	c5 f8 77             	vzeroupper
 18e669a:	e8 51 31 eb fe       	call   7997f0 <munmap@plt>
 18e669f:	48 8b bc 24 20 0e 00 00 	mov    0xe20(%rsp),%rdi
 18e66a7:	48 8d 9c 24 20 0e 00 00 	lea    0xe20(%rsp),%rbx
 18e66af:	48 85 ff             	test   %rdi,%rdi
 18e66b2:	74 37                	je     18e66eb <run_backend_benchmark+0x961b>
 18e66b4:	48 8b 84 24 30 0e 00 00 	mov    0xe30(%rsp),%rax
 18e66bc:	48 2b bc 24 38 0e 00 00 	sub    0xe38(%rsp),%rdi
 18e66c4:	48 8d 88 ff 0f 00 00 	lea    0xfff(%rax),%rcx
 18e66cb:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
 18e66d2:	48 3d 01 00 01 00    	cmp    $0x10001,%rax
 18e66d8:	48 8d b1 00 00 20 00 	lea    0x200000(%rcx),%rsi
 18e66df:	48 0f 42 f1          	cmovb  %rcx,%rsi
 18e66e3:	c5 f8 77             	vzeroupper
 18e66e6:	e8 05 31 eb fe       	call   7997f0 <munmap@plt>
 18e66eb:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18e66ef:	c5 fd 7f 03          	vmovdqa %ymm0,(%rbx)
 18e66f3:	48 8d 9c 24 40 0e 00 00 	lea    0xe40(%rsp),%rbx
 18e66fb:	48 8b bc 24 40 0e 00 00 	mov    0xe40(%rsp),%rdi
 18e6703:	48 85 ff             	test   %rdi,%rdi
 18e6706:	74 3b                	je     18e6743 <run_backend_benchmark+0x9673>
 18e6708:	48 8b 84 24 50 0e 00 00 	mov    0xe50(%rsp),%rax
 18e6710:	48 2b bc 24 58 0e 00 00 	sub    0xe58(%rsp),%rdi
 18e6718:	48 8d 88 ff 0f 00 00 	lea    0xfff(%rax),%rcx
 18e671f:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
 18e6726:	48 3d 01 00 01 00    	cmp    $0x10001,%rax
 18e672c:	48 8d b1 00 00 20 00 	lea    0x200000(%rcx),%rsi
 18e6733:	48 0f 42 f1          	cmovb  %rcx,%rsi
 18e6737:	c5 f8 77             	vzeroupper
 18e673a:	e8 b1 30 eb fe       	call   7997f0 <munmap@plt>
 18e673f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18e6743:	c5 fd 7f 03          	vmovdqa %ymm0,(%rbx)
 18e6747:	48 8b bc 24 40 0f 00 00 	mov    0xf40(%rsp),%rdi
 18e674f:	48 85 ff             	test   %rdi,%rdi
 18e6752:	74 37                	je     18e678b <run_backend_benchmark+0x96bb>
 18e6754:	48 8b 84 24 50 0f 00 00 	mov    0xf50(%rsp),%rax
 18e675c:	48 2b bc 24 58 0f 00 00 	sub    0xf58(%rsp),%rdi
 18e6764:	48 8d 88 ff 0f 00 00 	lea    0xfff(%rax),%rcx
 18e676b:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
 18e6772:	48 3d 01 00 01 00    	cmp    $0x10001,%rax
 18e6778:	48 8d b1 00 00 20 00 	lea    0x200000(%rcx),%rsi
 18e677f:	48 0f 42 f1          	cmovb  %rcx,%rsi
 18e6783:	c5 f8 77             	vzeroupper
 18e6786:	e8 65 30 eb fe       	call   7997f0 <munmap@plt>
 18e678b:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18e6794:	48 3b 84 24 80 2c 00 00 	cmp    0x2c80(%rsp),%rax
 18e679c:	0f 85 b9 0b 00 00    	jne    18e735b <run_backend_benchmark+0xa28b>
 18e67a2:	44 89 e0             	mov    %r12d,%eax
 18e67a5:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
 18e67a9:	5b                   	pop    %rbx
 18e67aa:	41 5c                	pop    %r12
 18e67ac:	41 5d                	pop    %r13
 18e67ae:	41 5e                	pop    %r14
 18e67b0:	41 5f                	pop    %r15
 18e67b2:	5d                   	pop    %rbp
 18e67b3:	c5 f8 77             	vzeroupper
 18e67b6:	c3                   	ret
 18e67b7:	48 bb 00 00 00 00 90 00 00 00 	movabs $0x9000000000,%rbx
 18e67c1:	48 8d b4 24 80 02 00 00 	lea    0x280(%rsp),%rsi
 18e67c9:	bf 2a 01 00 00       	mov    $0x12a,%edi
 18e67ce:	41 b9 08 00 00 00    	mov    $0x8,%r9d
 18e67d4:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 18e67d9:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18e67df:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18e67e3:	62 f1 fe 48 7f 84 24 90 02 00 00 	vmovdqu64 %zmm0,0x290(%rsp)
 18e67ee:	62 f1 fe 48 7f 84 24 d0 02 00 00 	vmovdqu64 %zmm0,0x2d0(%rsp)
 18e67f9:	31 d2                	xor    %edx,%edx
 18e67fb:	31 c0                	xor    %eax,%eax
 18e67fd:	48 89 9c 24 80 02 00 00 	mov    %rbx,0x280(%rsp)
 18e6805:	48 c7 84 24 88 02 00 00 00 00 00 00 	movq   $0x0,0x288(%rsp)
 18e6811:	48 c7 84 24 a8 02 00 00 60 00 00 00 	movq   $0x60,0x2a8(%rsp)
 18e681d:	c5 f8 77             	vzeroupper
 18e6820:	e8 3b 38 eb fe       	call   79a060 <syscall@plt>
 18e6825:	48 8d b4 24 80 02 00 00 	lea    0x280(%rsp),%rsi
 18e682d:	bf 2a 01 00 00       	mov    $0x12a,%edi
 18e6832:	41 b9 08 00 00 00    	mov    $0x8,%r9d
 18e6838:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 18e683d:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18e6843:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18e6847:	48 89 84 24 80 00 00 00 	mov    %rax,0x80(%rsp)
 18e684f:	41 89 c6             	mov    %eax,%r14d
 18e6852:	62 f1 fe 48 7f 84 24 90 02 00 00 	vmovdqu64 %zmm0,0x290(%rsp)
 18e685d:	62 f1 fe 48 7f 84 24 d0 02 00 00 	vmovdqu64 %zmm0,0x2d0(%rsp)
 18e6868:	48 89 9c 24 80 02 00 00 	mov    %rbx,0x280(%rsp)
 18e6870:	48 c7 84 24 88 02 00 00 01 00 00 00 	movq   $0x1,0x288(%rsp)
 18e687c:	48 c7 84 24 a8 02 00 00 60 00 00 00 	movq   $0x60,0x2a8(%rsp)
 18e6888:	31 d2                	xor    %edx,%edx
 18e688a:	31 c0                	xor    %eax,%eax
 18e688c:	c5 f8 77             	vzeroupper
 18e688f:	e8 cc 37 eb fe       	call   79a060 <syscall@plt>
 18e6894:	48 89 84 24 b0 00 00 00 	mov    %rax,0xb0(%rsp)
 18e689c:	48 c1 e0 20          	shl    $0x20,%rax
 18e68a0:	49 81 c7 a0 08 e0 ff 	add    $0xffffffffffe008a0,%r15
 18e68a7:	48 8d b4 24 80 02 00 00 	lea    0x280(%rsp),%rsi
 18e68af:	bf 2a 01 00 00       	mov    $0x12a,%edi
 18e68b4:	41 b9 08 00 00 00    	mov    $0x8,%r9d
 18e68ba:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 18e68bf:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18e68c5:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18e68c9:	62 f1 fe 48 7f 84 24 90 02 00 00 	vmovdqu64 %zmm0,0x290(%rsp)
 18e68d4:	62 f1 fe 48 7f 84 24 d0 02 00 00 	vmovdqu64 %zmm0,0x2d0(%rsp)
 18e68df:	31 d2                	xor    %edx,%edx
 18e68e1:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18e68e6:	49 09 c6             	or     %rax,%r14
 18e68e9:	48 b8 04 00 00 00 90 00 00 00 	movabs $0x9000000004,%rax
 18e68f3:	48 89 84 24 80 02 00 00 	mov    %rax,0x280(%rsp)
 18e68fb:	4c 89 bc 24 88 02 00 00 	mov    %r15,0x288(%rsp)
 18e6903:	31 c0                	xor    %eax,%eax
 18e6905:	48 c7 84 24 a8 02 00 00 60 00 00 00 	movq   $0x60,0x2a8(%rsp)
 18e6911:	c5 f8 77             	vzeroupper
 18e6914:	e8 47 37 eb fe       	call   79a060 <syscall@plt>
 18e6919:	4c 8d ac 24 80 02 00 00 	lea    0x280(%rsp),%r13
 18e6921:	48 8d 9c 24 68 01 00 00 	lea    0x168(%rsp),%rbx
 18e6929:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 18e6931:	49 89 c7             	mov    %rax,%r15
 18e6934:	31 f6                	xor    %esi,%esi
 18e6936:	4d 89 f0             	mov    %r14,%r8
 18e6939:	45 89 f9             	mov    %r15d,%r9d
 18e693c:	4c 89 ef             	mov    %r13,%rdi
 18e693f:	48 89 da             	mov    %rbx,%rdx
 18e6942:	4c 89 e1             	mov    %r12,%rcx
 18e6945:	e8 d6 69 00 00       	call   18ed320 <tier0_benchmark_run>
 18e694a:	be 01 00 00 00       	mov    $0x1,%esi
 18e694f:	4c 89 ef             	mov    %r13,%rdi
 18e6952:	48 89 da             	mov    %rbx,%rdx
 18e6955:	4c 89 e1             	mov    %r12,%rcx
 18e6958:	4d 89 f0             	mov    %r14,%r8
 18e695b:	45 89 f9             	mov    %r15d,%r9d
 18e695e:	e8 bd 69 00 00       	call   18ed320 <tier0_benchmark_run>
 18e6963:	be 02 00 00 00       	mov    $0x2,%esi
 18e6968:	4c 89 ef             	mov    %r13,%rdi
 18e696b:	48 89 da             	mov    %rbx,%rdx
 18e696e:	4c 89 e1             	mov    %r12,%rcx
 18e6971:	4d 89 f0             	mov    %r14,%r8
 18e6974:	45 89 f9             	mov    %r15d,%r9d
 18e6977:	e8 a4 69 00 00       	call   18ed320 <tier0_benchmark_run>
 18e697c:	be 03 00 00 00       	mov    $0x3,%esi
 18e6981:	4c 89 ef             	mov    %r13,%rdi
 18e6984:	48 89 da             	mov    %rbx,%rdx
 18e6987:	4c 89 e1             	mov    %r12,%rcx
 18e698a:	4c 89 74 24 58       	mov    %r14,0x58(%rsp)
 18e698f:	4d 89 f0             	mov    %r14,%r8
 18e6992:	45 89 f9             	mov    %r15d,%r9d
 18e6995:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
 18e699a:	e8 81 69 00 00       	call   18ed320 <tier0_benchmark_run>
 18e699f:	48 8d bc 24 80 02 00 00 	lea    0x280(%rsp),%rdi
 18e69a7:	ba 80 0a 00 00       	mov    $0xa80,%edx
 18e69ac:	31 f6                	xor    %esi,%esi
 18e69ae:	e8 cd 34 eb fe       	call   799e80 <memset@plt>
 18e69b3:	48 8b 84 24 18 01 00 00 	mov    0x118(%rsp),%rax
 18e69bb:	48 85 c0             	test   %rax,%rax
 18e69be:	0f 84 1d 03 00 00    	je     18e6ce1 <run_backend_benchmark+0x9c11>
 18e69c4:	48 69 c0 40 42 0f 00 	imul   $0xf4240,%rax,%rax
 18e69cb:	4c 8b a4 24 80 00 00 00 	mov    0x80(%rsp),%r12
 18e69d3:	4c 8d ac 24 18 02 00 00 	lea    0x218(%rsp),%r13
 18e69db:	48 c7 84 24 90 00 00 00 00 00 00 00 	movq   $0x0,0x90(%rsp)
 18e69e7:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
 18e69ec:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18e69f4:	eb 1d                	jmp    18e6a13 <run_backend_benchmark+0x9943>
 18e69f6:	48 8b 94 24 90 00 00 00 	mov    0x90(%rsp),%rdx
 18e69fe:	48 ff c2             	inc    %rdx
 18e6a01:	48 89 94 24 90 00 00 00 	mov    %rdx,0x90(%rsp)
 18e6a09:	48 83 fa 15          	cmp    $0x15,%rdx
 18e6a0d:	0f 84 f0 04 00 00    	je     18e6f03 <run_backend_benchmark+0x9e33>
 18e6a13:	48 8b 5c 24 30       	mov    0x30(%rsp),%rbx
 18e6a18:	31 c9                	xor    %ecx,%ecx
 18e6a1a:	e9 99 00 00 00       	jmp    18e6ab8 <run_backend_benchmark+0x99e8>
 18e6a1f:	90                   	nop
 18e6a20:	85 d2                	test   %edx,%edx
 18e6a22:	0f 84 d7 00 00 00    	je     18e6aff <run_backend_benchmark+0x9a2f>
 18e6a28:	44 8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%r14d
 18e6a30:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 18e6a35:	48 8d 94 24 68 01 00 00 	lea    0x168(%rsp),%rdx
 18e6a3d:	48 8d 8c 24 c0 01 00 00 	lea    0x1c0(%rsp),%rcx
 18e6a45:	4c 89 ef             	mov    %r13,%rdi
 18e6a48:	41 89 d9             	mov    %ebx,%r9d
 18e6a4b:	44 89 f6             	mov    %r14d,%esi
 18e6a4e:	c5 f8 77             	vzeroupper
 18e6a51:	e8 ca 68 00 00       	call   18ed320 <tier0_benchmark_run>
 18e6a56:	62 f1 fe 28 7a 84 24 18 02 00 00 	vcvtuqq2pd 0x218(%rsp),%ymm0
 18e6a61:	44 89 f0             	mov    %r14d,%eax
 18e6a64:	48 69 c0 a0 02 00 00 	imul   $0x2a0,%rax,%rax
 18e6a6b:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 18e6a73:	48 8d 84 04 80 02 00 00 	lea    0x280(%rsp,%rax,1),%rax
 18e6a7b:	c5 f8 13 04 c8       	vmovlps %xmm0,(%rax,%rcx,8)
 18e6a80:	c5 f8 17 84 c8 a8 00 00 00 	vmovhps %xmm0,0xa8(%rax,%rcx,8)
 18e6a89:	c4 e3 7d 19 c0 01    	vextractf128 $0x1,%ymm0,%xmm0
 18e6a8f:	c5 f8 13 84 c8 50 01 00 00 	vmovlps %xmm0,0x150(%rax,%rcx,8)
 18e6a98:	c5 f8 17 84 c8 f8 01 00 00 	vmovhps %xmm0,0x1f8(%rax,%rcx,8)
 18e6aa1:	8b 4c 24 78          	mov    0x78(%rsp),%ecx
 18e6aa5:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18e6aad:	ff c1                	inc    %ecx
 18e6aaf:	83 f9 04             	cmp    $0x4,%ecx
 18e6ab2:	0f 84 3e ff ff ff    	je     18e69f6 <run_backend_benchmark+0x9926>
 18e6ab8:	89 ca                	mov    %ecx,%edx
 18e6aba:	83 f2 01             	xor    $0x1,%edx
 18e6abd:	f6 84 24 90 00 00 00 01 	testb  $0x1,0x90(%rsp)
 18e6ac5:	89 4c 24 78          	mov    %ecx,0x78(%rsp)
 18e6ac9:	0f 44 d1             	cmove  %ecx,%edx
 18e6acc:	83 f9 02             	cmp    $0x2,%ecx
 18e6acf:	0f 43 d1             	cmovae %ecx,%edx
 18e6ad2:	89 94 24 a0 00 00 00 	mov    %edx,0xa0(%rsp)
 18e6ad9:	83 f8 04             	cmp    $0x4,%eax
 18e6adc:	0f 84 3e ff ff ff    	je     18e6a20 <run_backend_benchmark+0x9950>
 18e6ae2:	39 c2                	cmp    %eax,%edx
 18e6ae4:	0f 84 36 ff ff ff    	je     18e6a20 <run_backend_benchmark+0x9950>
 18e6aea:	83 f8 03             	cmp    $0x3,%eax
 18e6aed:	75 b2                	jne    18e6aa1 <run_backend_benchmark+0x99d1>
 18e6aef:	83 bc 24 a0 00 00 00 02 	cmpl   $0x2,0xa0(%rsp)
 18e6af7:	0f 84 2b ff ff ff    	je     18e6a28 <run_backend_benchmark+0x9958>
 18e6afd:	eb a2                	jmp    18e6aa1 <run_backend_benchmark+0x99d1>
 18e6aff:	bf 04 00 00 00       	mov    $0x4,%edi
 18e6b04:	4c 89 ee             	mov    %r13,%rsi
 18e6b07:	c5 f8 77             	vzeroupper
 18e6b0a:	e8 f1 2a eb fe       	call   799600 <clock_gettime@plt>
 18e6b0f:	48 69 84 24 18 02 00 00 00 ca 9a 3b 	imul   $0x3b9aca00,0x218(%rsp),%rax
 18e6b1b:	4c 8b b4 24 20 02 00 00 	mov    0x220(%rsp),%r14
 18e6b23:	bf 04 00 00 00       	mov    $0x4,%edi
 18e6b28:	4c 89 ee             	mov    %r13,%rsi
 18e6b2b:	4c 03 74 24 70       	add    0x70(%rsp),%r14
 18e6b30:	49 01 c6             	add    %rax,%r14
 18e6b33:	e8 c8 2a eb fe       	call   799600 <clock_gettime@plt>
 18e6b38:	48 69 84 24 18 02 00 00 00 ca 9a 3b 	imul   $0x3b9aca00,0x218(%rsp),%rax
 18e6b44:	4c 89 74 24 60       	mov    %r14,0x60(%rsp)
 18e6b49:	48 03 84 24 20 02 00 00 	add    0x220(%rsp),%rax
 18e6b51:	4c 39 f0             	cmp    %r14,%rax
 18e6b54:	0f 83 ce fe ff ff    	jae    18e6a28 <run_backend_benchmark+0x9958>
 18e6b5a:	44 8b bc 24 98 01 00 00 	mov    0x198(%rsp),%r15d
 18e6b62:	4c 8b b4 24 68 01 00 00 	mov    0x168(%rsp),%r14
 18e6b6a:	eb 3d                	jmp    18e6ba9 <run_backend_benchmark+0x9ad9>
 18e6b6c:	0f 1f 40 00          	nopl   0x0(%rax)
 18e6b70:	bf 04 00 00 00       	mov    $0x4,%edi
 18e6b75:	4c 89 ee             	mov    %r13,%rsi
 18e6b78:	e8 83 2a eb fe       	call   799600 <clock_gettime@plt>
 18e6b7d:	bf 04 00 00 00       	mov    $0x4,%edi
 18e6b82:	4c 89 ee             	mov    %r13,%rsi
 18e6b85:	e8 76 2a eb fe       	call   799600 <clock_gettime@plt>
 18e6b8a:	48 69 84 24 18 02 00 00 00 ca 9a 3b 	imul   $0x3b9aca00,0x218(%rsp),%rax
 18e6b96:	48 03 84 24 20 02 00 00 	add    0x220(%rsp),%rax
 18e6b9e:	48 3b 44 24 60       	cmp    0x60(%rsp),%rax
 18e6ba3:	0f 83 7f fe ff ff    	jae    18e6a28 <run_backend_benchmark+0x9958>
 18e6ba9:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 18e6bb5:	45 85 e4             	test   %r12d,%r12d
 18e6bb8:	78 10                	js     18e6bca <run_backend_benchmark+0x9afa>
 18e6bba:	ba 08 00 00 00       	mov    $0x8,%edx
 18e6bbf:	44 89 e7             	mov    %r12d,%edi
 18e6bc2:	4c 89 ee             	mov    %r13,%rsi
 18e6bc5:	e8 f6 2d eb fe       	call   7999c0 <read@plt>
 18e6bca:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18e6bd0:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 18e6bdc:	78 15                	js     18e6bf3 <run_backend_benchmark+0x9b23>
 18e6bde:	ba 08 00 00 00       	mov    $0x8,%edx
 18e6be3:	48 8b bc 24 b0 00 00 00 	mov    0xb0(%rsp),%rdi
 18e6beb:	4c 89 ee             	mov    %r13,%rsi
 18e6bee:	e8 cd 2d eb fe       	call   7999c0 <read@plt>
 18e6bf3:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 18e6bff:	85 db                	test   %ebx,%ebx
 18e6c01:	78 0f                	js     18e6c12 <run_backend_benchmark+0x9b42>
 18e6c03:	ba 08 00 00 00       	mov    $0x8,%edx
 18e6c08:	89 df                	mov    %ebx,%edi
 18e6c0a:	4c 89 ee             	mov    %r13,%rsi
 18e6c0d:	e8 ae 2d eb fe       	call   7999c0 <read@plt>
 18e6c12:	bf 04 00 00 00       	mov    $0x4,%edi
 18e6c17:	4c 89 ee             	mov    %r13,%rsi
 18e6c1a:	e8 e1 29 eb fe       	call   799600 <clock_gettime@plt>
 18e6c1f:	4d 85 ff             	test   %r15,%r15
 18e6c22:	74 3e                	je     18e6c62 <run_backend_benchmark+0x9b92>
 18e6c24:	4c 8b a4 24 c8 01 00 00 	mov    0x1c8(%rsp),%r12
 18e6c2c:	31 db                	xor    %ebx,%ebx
 18e6c2e:	66 90                	xchg   %ax,%ax
 18e6c30:	49 8b 34 de          	mov    (%r14,%rbx,8),%rsi
 18e6c34:	48 8d 94 24 c0 01 00 00 	lea    0x1c0(%rsp),%rdx
 18e6c3c:	4c 89 ef             	mov    %r13,%rdi
 18e6c3f:	e8 0c 80 01 00       	call   18fec50 <tier0_compile_scalar>
 18e6c44:	4c 3b a4 24 c8 01 00 00 	cmp    0x1c8(%rsp),%r12
 18e6c4c:	0f 87 e7 06 00 00    	ja     18e7339 <run_backend_benchmark+0xa269>
 18e6c52:	48 ff c3             	inc    %rbx
 18e6c55:	4c 89 a4 24 c8 01 00 00 	mov    %r12,0x1c8(%rsp)
 18e6c5d:	49 39 df             	cmp    %rbx,%r15
 18e6c60:	75 ce                	jne    18e6c30 <run_backend_benchmark+0x9b60>
 18e6c62:	4c 8b a4 24 80 00 00 00 	mov    0x80(%rsp),%r12
 18e6c6a:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 18e6c76:	45 85 e4             	test   %r12d,%r12d
 18e6c79:	78 10                	js     18e6c8b <run_backend_benchmark+0x9bbb>
 18e6c7b:	ba 08 00 00 00       	mov    $0x8,%edx
 18e6c80:	44 89 e7             	mov    %r12d,%edi
 18e6c83:	4c 89 ee             	mov    %r13,%rsi
 18e6c86:	e8 35 2d eb fe       	call   7999c0 <read@plt>
 18e6c8b:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18e6c91:	48 8b 5c 24 30       	mov    0x30(%rsp),%rbx
 18e6c96:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 18e6ca2:	78 15                	js     18e6cb9 <run_backend_benchmark+0x9be9>
 18e6ca4:	ba 08 00 00 00       	mov    $0x8,%edx
 18e6ca9:	48 8b bc 24 b0 00 00 00 	mov    0xb0(%rsp),%rdi
 18e6cb1:	4c 89 ee             	mov    %r13,%rsi
 18e6cb4:	e8 07 2d eb fe       	call   7999c0 <read@plt>
 18e6cb9:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 18e6cc5:	85 db                	test   %ebx,%ebx
 18e6cc7:	0f 88 a3 fe ff ff    	js     18e6b70 <run_backend_benchmark+0x9aa0>
 18e6ccd:	ba 08 00 00 00       	mov    $0x8,%edx
 18e6cd2:	89 df                	mov    %ebx,%edi
 18e6cd4:	4c 89 ee             	mov    %r13,%rsi
 18e6cd7:	e8 e4 2c eb fe       	call   7999c0 <read@plt>
 18e6cdc:	e9 8f fe ff ff       	jmp    18e6b70 <run_backend_benchmark+0x9aa0>
 18e6ce1:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18e6ce9:	41 b5 01             	mov    $0x1,%r13b
 18e6cec:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 18e6cf4:	31 db                	xor    %ebx,%ebx
 18e6cf6:	44 8d 70 fe          	lea    -0x2(%rax),%r14d
 18e6cfa:	8d 48 fd             	lea    -0x3(%rax),%ecx
 18e6cfd:	89 4c 24 40          	mov    %ecx,0x40(%rsp)
 18e6d01:	eb 11                	jmp    18e6d14 <run_backend_benchmark+0x9c44>
 18e6d03:	48 ff c3             	inc    %rbx
 18e6d06:	41 80 f5 01          	xor    $0x1,%r13b
 18e6d0a:	48 83 fb 15          	cmp    $0x15,%rbx
 18e6d0e:	0f 84 ef 01 00 00    	je     18e6f03 <run_backend_benchmark+0x9e33>
 18e6d14:	89 de                	mov    %ebx,%esi
 18e6d16:	83 e6 01             	and    $0x1,%esi
 18e6d19:	83 f8 04             	cmp    $0x4,%eax
 18e6d1c:	74 04                	je     18e6d22 <run_backend_benchmark+0x9c52>
 18e6d1e:	39 c6                	cmp    %eax,%esi
 18e6d20:	75 71                	jne    18e6d93 <run_backend_benchmark+0x9cc3>
 18e6d22:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 18e6d27:	48 69 c6 a0 02 00 00 	imul   $0x2a0,%rsi,%rax
 18e6d2e:	48 8d bc 24 18 02 00 00 	lea    0x218(%rsp),%rdi
 18e6d36:	48 8d 94 24 68 01 00 00 	lea    0x168(%rsp),%rdx
 18e6d3e:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 18e6d43:	4c 89 e1             	mov    %r12,%rcx
 18e6d46:	4c 8d bc 04 80 02 00 00 	lea    0x280(%rsp,%rax,1),%r15
 18e6d4e:	c5 f8 77             	vzeroupper
 18e6d51:	e8 ca 65 00 00       	call   18ed320 <tier0_benchmark_run>
 18e6d56:	62 f1 fe 28 7a 84 24 18 02 00 00 	vcvtuqq2pd 0x218(%rsp),%ymm0
 18e6d61:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18e6d69:	c4 c1 78 13 04 df    	vmovlps %xmm0,(%r15,%rbx,8)
 18e6d6f:	c4 c1 78 17 84 df a8 00 00 00 	vmovhps %xmm0,0xa8(%r15,%rbx,8)
 18e6d79:	c4 e3 7d 19 c0 01    	vextractf128 $0x1,%ymm0,%xmm0
 18e6d7f:	c4 c1 78 13 84 df 50 01 00 00 	vmovlps %xmm0,0x150(%r15,%rbx,8)
 18e6d89:	c4 c1 78 17 84 df f8 01 00 00 	vmovhps %xmm0,0x1f8(%r15,%rbx,8)
 18e6d93:	89 de                	mov    %ebx,%esi
 18e6d95:	f7 d6                	not    %esi
 18e6d97:	83 e6 01             	and    $0x1,%esi
 18e6d9a:	83 f8 04             	cmp    $0x4,%eax
 18e6d9d:	74 04                	je     18e6da3 <run_backend_benchmark+0x9cd3>
 18e6d9f:	39 c6                	cmp    %eax,%esi
 18e6da1:	75 78                	jne    18e6e1b <run_backend_benchmark+0x9d4b>
 18e6da3:	41 0f b6 c5          	movzbl %r13b,%eax
 18e6da7:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 18e6dac:	48 8d bc 24 18 02 00 00 	lea    0x218(%rsp),%rdi
 18e6db4:	48 8d 94 24 68 01 00 00 	lea    0x168(%rsp),%rdx
 18e6dbc:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 18e6dc1:	4c 89 e1             	mov    %r12,%rcx
 18e6dc4:	83 e0 01             	and    $0x1,%eax
 18e6dc7:	48 69 c0 a0 02 00 00 	imul   $0x2a0,%rax,%rax
 18e6dce:	4c 8d bc 04 80 02 00 00 	lea    0x280(%rsp,%rax,1),%r15
 18e6dd6:	c5 f8 77             	vzeroupper
 18e6dd9:	e8 42 65 00 00       	call   18ed320 <tier0_benchmark_run>
 18e6dde:	62 f1 fe 28 7a 84 24 18 02 00 00 	vcvtuqq2pd 0x218(%rsp),%ymm0
 18e6de9:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18e6df1:	c4 c1 78 13 04 df    	vmovlps %xmm0,(%r15,%rbx,8)
 18e6df7:	c4 c1 78 17 84 df a8 00 00 00 	vmovhps %xmm0,0xa8(%r15,%rbx,8)
 18e6e01:	c4 e3 7d 19 c0 01    	vextractf128 $0x1,%ymm0,%xmm0
 18e6e07:	c4 c1 78 13 84 df 50 01 00 00 	vmovlps %xmm0,0x150(%r15,%rbx,8)
 18e6e11:	c4 c1 78 17 84 df f8 01 00 00 	vmovhps %xmm0,0x1f8(%r15,%rbx,8)
 18e6e1b:	41 83 fe 02          	cmp    $0x2,%r14d
 18e6e1f:	0f 87 de fe ff ff    	ja     18e6d03 <run_backend_benchmark+0x9c33>
 18e6e25:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 18e6e2a:	48 8d bc 24 18 02 00 00 	lea    0x218(%rsp),%rdi
 18e6e32:	be 02 00 00 00       	mov    $0x2,%esi
 18e6e37:	48 8d 94 24 68 01 00 00 	lea    0x168(%rsp),%rdx
 18e6e3f:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 18e6e44:	4c 89 e1             	mov    %r12,%rcx
 18e6e47:	c5 f8 77             	vzeroupper
 18e6e4a:	e8 d1 64 00 00       	call   18ed320 <tier0_benchmark_run>
 18e6e4f:	62 f1 fe 28 7a 84 24 18 02 00 00 	vcvtuqq2pd 0x218(%rsp),%ymm0
 18e6e5a:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18e6e62:	83 7c 24 40 01       	cmpl   $0x1,0x40(%rsp)
 18e6e67:	c5 f8 13 84 dc c0 07 00 00 	vmovlps %xmm0,0x7c0(%rsp,%rbx,8)
 18e6e70:	c5 f8 17 84 dc 68 08 00 00 	vmovhps %xmm0,0x868(%rsp,%rbx,8)
 18e6e79:	c4 e3 7d 19 c0 01    	vextractf128 $0x1,%ymm0,%xmm0
 18e6e7f:	c5 f8 13 84 dc 10 09 00 00 	vmovlps %xmm0,0x910(%rsp,%rbx,8)
 18e6e88:	c5 f8 17 84 dc b8 09 00 00 	vmovhps %xmm0,0x9b8(%rsp,%rbx,8)
 18e6e91:	0f 87 6c fe ff ff    	ja     18e6d03 <run_backend_benchmark+0x9c33>
 18e6e97:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 18e6e9c:	48 8d bc 24 18 02 00 00 	lea    0x218(%rsp),%rdi
 18e6ea4:	be 03 00 00 00       	mov    $0x3,%esi
 18e6ea9:	48 8d 94 24 68 01 00 00 	lea    0x168(%rsp),%rdx
 18e6eb1:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 18e6eb6:	4c 89 e1             	mov    %r12,%rcx
 18e6eb9:	c5 f8 77             	vzeroupper
 18e6ebc:	e8 5f 64 00 00       	call   18ed320 <tier0_benchmark_run>
 18e6ec1:	62 f1 fe 28 7a 84 24 18 02 00 00 	vcvtuqq2pd 0x218(%rsp),%ymm0
 18e6ecc:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18e6ed4:	c5 f8 13 84 dc 60 0a 00 00 	vmovlps %xmm0,0xa60(%rsp,%rbx,8)
 18e6edd:	c5 f8 17 84 dc 08 0b 00 00 	vmovhps %xmm0,0xb08(%rsp,%rbx,8)
 18e6ee6:	c4 e3 7d 19 c0 01    	vextractf128 $0x1,%ymm0,%xmm0
 18e6eec:	c5 f8 13 84 dc b0 0b 00 00 	vmovlps %xmm0,0xbb0(%rsp,%rbx,8)
 18e6ef5:	c5 f8 17 84 dc 58 0c 00 00 	vmovhps %xmm0,0xc58(%rsp,%rbx,8)
 18e6efe:	e9 00 fe ff ff       	jmp    18e6d03 <run_backend_benchmark+0x9c33>
 18e6f03:	62 f1 fe 08 7a 54 24 1a 	vcvtuqq2pd 0x1a0(%rsp),%xmm2
 18e6f0b:	4c 8b 8c 24 b0 01 00 00 	mov    0x1b0(%rsp),%r9
 18e6f13:	8b b4 24 98 01 00 00 	mov    0x198(%rsp),%esi
 18e6f1a:	48 8b 8c 24 a8 01 00 00 	mov    0x1a8(%rsp),%rcx
 18e6f22:	48 8b 94 24 a0 01 00 00 	mov    0x1a0(%rsp),%rdx
 18e6f2a:	4c 8b 84 24 b8 01 00 00 	mov    0x1b8(%rsp),%r8
 18e6f32:	48 89 c3             	mov    %rax,%rbx
 18e6f35:	48 8d 3d e9 08 e5 fe 	lea    -0x11af717(%rip),%rdi        # 737825 <pp_decode_file_name.meaning+0x2d7a8>
 18e6f3c:	b0 02                	mov    $0x2,%al
 18e6f3e:	c5 e9 c6 c2 01       	vshufpd $0x1,%xmm2,%xmm2,%xmm0
 18e6f43:	c5 f9 29 54 24 40    	vmovapd %xmm2,0x40(%rsp)
 18e6f49:	c5 f9 29 84 24 b0 00 00 00 	vmovapd %xmm0,0xb0(%rsp)
 18e6f52:	c5 fb 5e c2          	vdivsd %xmm2,%xmm0,%xmm0
 18e6f56:	62 d1 87 08 7b c9    	vcvtusi2sd %r9,%xmm15,%xmm1
 18e6f5c:	c5 f3 59 0d 84 f7 cc fe 	vmulsd -0x133087c(%rip),%xmm1,%xmm1        # 5b66e8 <x86_semantics_benchmark_code.registers+0xf0>
 18e6f64:	c5 f3 5e ca          	vdivsd %xmm2,%xmm1,%xmm1
 18e6f68:	c5 f8 77             	vzeroupper
 18e6f6b:	e8 90 2f eb fe       	call   799f00 <printf@plt>
 18e6f70:	48 8d 05 11 78 d7 fe 	lea    -0x12887ef(%rip),%rax        # 65e788 <fuzz_comment_end+0x14abe>
 18e6f77:	48 8d 3d 69 eb e1 fe 	lea    -0x11e1497(%rip),%rdi        # 705ae7 <pp_string_value.meaning+0x7252f>
 18e6f7e:	48 8d 35 0e 8c e3 fe 	lea    -0x11c73f2(%rip),%rsi        # 71fb93 <pp_decode_file_name.meaning+0x15b16>
 18e6f85:	48 8d 15 b5 65 dd fe 	lea    -0x1229a4b(%rip),%rdx        # 6bd541 <pp_string_value.meaning+0x29f89>
 18e6f8c:	48 8d 0d f4 81 da fe 	lea    -0x1257e0c(%rip),%rcx        # 68f187 <fuzz_comment_end+0x454bd>
 18e6f93:	4c 8d 05 07 09 e5 fe 	lea    -0x11af6f9(%rip),%r8        # 7378a1 <pp_decode_file_name.meaning+0x2d824>
 18e6f9a:	4c 8d 0d a7 89 e0 fe 	lea    -0x11f7659(%rip),%r9        # 6ef948 <pp_string_value.meaning+0x5c390>
 18e6fa1:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
 18e6fa6:	48 8d 05 02 12 d3 fe 	lea    -0x12cedfe(%rip),%rax        # 6181af <foreign_touch.flags+0xe80b>
 18e6fad:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
 18e6fb2:	48 8d 05 eb 11 d3 fe 	lea    -0x12cee15(%rip),%rax        # 6181a4 <foreign_touch.flags+0xe800>
 18e6fb9:	48 89 04 24          	mov    %rax,(%rsp)
 18e6fbd:	31 c0                	xor    %eax,%eax
 18e6fbf:	e8 3c 2f eb fe       	call   799f00 <printf@plt>
 18e6fc4:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18e6fc9:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
 18e6fd1:	83 fb 04             	cmp    $0x4,%ebx
 18e6fd4:	0f 87 8f 02 00 00    	ja     18e7269 <run_backend_benchmark+0xa199>
 18e6fda:	c5 fb 12 44 24 40    	vmovddup 0x40(%rsp),%xmm0
 18e6fe0:	48 8d 0d dd f4 c5 fe 	lea    -0x13a0b23(%rip),%rcx        # 5464c4 <branch_sizing_patterns+0x834>
 18e6fe7:	89 d8                	mov    %ebx,%eax
 18e6fe9:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
 18e6fed:	48 01 c8             	add    %rcx,%rax
 18e6ff0:	c5 f9 29 44 24 60    	vmovapd %xmm0,0x60(%rsp)
 18e6ff6:	ff e0                	jmp    *%rax
 18e6ff8:	48 8d bc 24 80 02 00 00 	lea    0x280(%rsp),%rdi
 18e7000:	e8 ab 80 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e7005:	48 8d bc 24 28 03 00 00 	lea    0x328(%rsp),%rdi
 18e700d:	c5 f9 29 44 24 30    	vmovapd %xmm0,0x30(%rsp)
 18e7013:	e8 98 80 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e7018:	48 8d bc 24 d0 03 00 00 	lea    0x3d0(%rsp),%rdi
 18e7020:	c5 f9 29 84 24 80 00 00 00 	vmovapd %xmm0,0x80(%rsp)
 18e7029:	e8 82 80 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e702e:	48 8d bc 24 78 04 00 00 	lea    0x478(%rsp),%rdi
 18e7036:	c5 f9 29 84 24 a0 00 00 00 	vmovapd %xmm0,0xa0(%rsp)
 18e703f:	e8 6c 80 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e7044:	c5 f9 28 bc 24 a0 00 00 00 	vmovapd 0xa0(%rsp),%xmm7
 18e704d:	c5 f9 28 b4 24 80 00 00 00 	vmovapd 0x80(%rsp),%xmm6
 18e7056:	c5 f9 28 54 24 30    	vmovapd 0x30(%rsp),%xmm2
 18e705c:	c5 f9 28 9c 24 b0 00 00 00 	vmovapd 0xb0(%rsp),%xmm3
 18e7065:	c5 f9 28 c8          	vmovapd %xmm0,%xmm1
 18e7069:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18e706d:	c5 e9 14 c6          	vunpcklpd %xmm6,%xmm2,%xmm0
 18e7071:	c5 c1 14 d2          	vunpcklpd %xmm2,%xmm7,%xmm2
 18e7075:	c5 f9 5e 44 24 60    	vdivpd 0x60(%rsp),%xmm0,%xmm0
 18e707b:	c5 e9 5e 54 24 40    	vdivpd 0x40(%rsp),%xmm2,%xmm2
 18e7081:	c5 cb 5e e3          	vdivsd %xmm3,%xmm6,%xmm4
 18e7085:	c5 f9 2e f5          	vucomisd %xmm5,%xmm6
 18e7089:	75 02                	jne    18e708d <run_backend_benchmark+0x9fbd>
 18e708b:	7b 04                	jnp    18e7091 <run_backend_benchmark+0x9fc1>
 18e708d:	c5 c3 5e ee          	vdivsd %xmm6,%xmm7,%xmm5
 18e7091:	c5 f3 5e f3          	vdivsd %xmm3,%xmm1,%xmm6
 18e7095:	c5 f9 c6 c8 01       	vshufpd $0x1,%xmm0,%xmm0,%xmm1
 18e709a:	c5 e9 c6 da 01       	vshufpd $0x1,%xmm2,%xmm2,%xmm3
 18e709f:	48 8d 3d 0d 11 d3 fe 	lea    -0x12ceef3(%rip),%rdi        # 6181b3 <foreign_touch.flags+0xe80f>
 18e70a6:	48 8d 35 8f 51 d3 fe 	lea    -0x12cae71(%rip),%rsi        # 61c23c <foreign_touch.flags+0x12898>
 18e70ad:	b0 07                	mov    $0x7,%al
 18e70af:	e8 4c 2e eb fe       	call   799f00 <printf@plt>
 18e70b4:	48 8b 9c 24 c8 00 00 00 	mov    0xc8(%rsp),%rbx
 18e70bc:	83 fb 04             	cmp    $0x4,%ebx
 18e70bf:	74 12                	je     18e70d3 <run_backend_benchmark+0xa003>
 18e70c1:	83 fb 02             	cmp    $0x2,%ebx
 18e70c4:	0f 84 db 00 00 00    	je     18e71a5 <run_backend_benchmark+0xa0d5>
 18e70ca:	83 fb 01             	cmp    $0x1,%ebx
 18e70cd:	0f 85 96 01 00 00    	jne    18e7269 <run_backend_benchmark+0xa199>
 18e70d3:	48 8d bc 24 20 05 00 00 	lea    0x520(%rsp),%rdi
 18e70db:	e8 d0 7f 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e70e0:	48 8d bc 24 c8 05 00 00 	lea    0x5c8(%rsp),%rdi
 18e70e8:	c5 f9 29 44 24 30    	vmovapd %xmm0,0x30(%rsp)
 18e70ee:	e8 bd 7f 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e70f3:	48 8d bc 24 70 06 00 00 	lea    0x670(%rsp),%rdi
 18e70fb:	c5 f9 29 84 24 80 00 00 00 	vmovapd %xmm0,0x80(%rsp)
 18e7104:	e8 a7 7f 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e7109:	48 8d bc 24 18 07 00 00 	lea    0x718(%rsp),%rdi
 18e7111:	c5 f9 29 84 24 a0 00 00 00 	vmovapd %xmm0,0xa0(%rsp)
 18e711a:	e8 91 7f 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e711f:	c5 f9 28 bc 24 a0 00 00 00 	vmovapd 0xa0(%rsp),%xmm7
 18e7128:	c5 f9 28 b4 24 80 00 00 00 	vmovapd 0x80(%rsp),%xmm6
 18e7131:	c5 f9 28 54 24 30    	vmovapd 0x30(%rsp),%xmm2
 18e7137:	c5 f9 28 9c 24 b0 00 00 00 	vmovapd 0xb0(%rsp),%xmm3
 18e7140:	c5 f9 28 c8          	vmovapd %xmm0,%xmm1
 18e7144:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18e7148:	c5 e9 14 c6          	vunpcklpd %xmm6,%xmm2,%xmm0
 18e714c:	c5 c1 14 d2          	vunpcklpd %xmm2,%xmm7,%xmm2
 18e7150:	c5 f9 5e 44 24 60    	vdivpd 0x60(%rsp),%xmm0,%xmm0
 18e7156:	c5 e9 5e 54 24 40    	vdivpd 0x40(%rsp),%xmm2,%xmm2
 18e715c:	c5 cb 5e e3          	vdivsd %xmm3,%xmm6,%xmm4
 18e7160:	c5 f9 2e f5          	vucomisd %xmm5,%xmm6
 18e7164:	75 02                	jne    18e7168 <run_backend_benchmark+0xa098>
 18e7166:	7b 04                	jnp    18e716c <run_backend_benchmark+0xa09c>
 18e7168:	c5 c3 5e ee          	vdivsd %xmm6,%xmm7,%xmm5
 18e716c:	c5 f3 5e f3          	vdivsd %xmm3,%xmm1,%xmm6
 18e7170:	c5 f9 c6 c8 01       	vshufpd $0x1,%xmm0,%xmm0,%xmm1
 18e7175:	c5 e9 c6 da 01       	vshufpd $0x1,%xmm2,%xmm2,%xmm3
 18e717a:	48 8d 3d 32 10 d3 fe 	lea    -0x12cefce(%rip),%rdi        # 6181b3 <foreign_touch.flags+0xe80f>
 18e7181:	48 8d 35 b8 18 d3 fe 	lea    -0x12ce748(%rip),%rsi        # 618a40 <foreign_touch.flags+0xf09c>
 18e7188:	b0 07                	mov    $0x7,%al
 18e718a:	e8 71 2d eb fe       	call   799f00 <printf@plt>
 18e718f:	48 8b 9c 24 c8 00 00 00 	mov    0xc8(%rsp),%rbx
 18e7197:	83 fb 04             	cmp    $0x4,%ebx
 18e719a:	74 09                	je     18e71a5 <run_backend_benchmark+0xa0d5>
 18e719c:	83 fb 02             	cmp    $0x2,%ebx
 18e719f:	0f 85 c4 00 00 00    	jne    18e7269 <run_backend_benchmark+0xa199>
 18e71a5:	48 8d bc 24 c0 07 00 00 	lea    0x7c0(%rsp),%rdi
 18e71ad:	e8 fe 7e 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e71b2:	48 8d bc 24 68 08 00 00 	lea    0x868(%rsp),%rdi
 18e71ba:	c5 f9 29 44 24 30    	vmovapd %xmm0,0x30(%rsp)
 18e71c0:	e8 eb 7e 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e71c5:	48 8d bc 24 10 09 00 00 	lea    0x910(%rsp),%rdi
 18e71cd:	c5 f9 29 84 24 80 00 00 00 	vmovapd %xmm0,0x80(%rsp)
 18e71d6:	e8 d5 7e 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e71db:	48 8d bc 24 b8 09 00 00 	lea    0x9b8(%rsp),%rdi
 18e71e3:	c5 f9 29 84 24 a0 00 00 00 	vmovapd %xmm0,0xa0(%rsp)
 18e71ec:	e8 bf 7e 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e71f1:	c5 f9 28 bc 24 a0 00 00 00 	vmovapd 0xa0(%rsp),%xmm7
 18e71fa:	c5 f9 28 b4 24 80 00 00 00 	vmovapd 0x80(%rsp),%xmm6
 18e7203:	c5 f9 28 54 24 30    	vmovapd 0x30(%rsp),%xmm2
 18e7209:	c5 f9 28 9c 24 b0 00 00 00 	vmovapd 0xb0(%rsp),%xmm3
 18e7212:	c5 f9 28 c8          	vmovapd %xmm0,%xmm1
 18e7216:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18e721a:	c5 e9 14 c6          	vunpcklpd %xmm6,%xmm2,%xmm0
 18e721e:	c5 c1 14 d2          	vunpcklpd %xmm2,%xmm7,%xmm2
 18e7222:	c5 f9 5e 44 24 60    	vdivpd 0x60(%rsp),%xmm0,%xmm0
 18e7228:	c5 e9 5e 54 24 40    	vdivpd 0x40(%rsp),%xmm2,%xmm2
 18e722e:	c5 cb 5e e3          	vdivsd %xmm3,%xmm6,%xmm4
 18e7232:	c5 f9 2e f5          	vucomisd %xmm5,%xmm6
 18e7236:	75 02                	jne    18e723a <run_backend_benchmark+0xa16a>
 18e7238:	7b 04                	jnp    18e723e <run_backend_benchmark+0xa16e>
 18e723a:	c5 c3 5e ee          	vdivsd %xmm6,%xmm7,%xmm5
 18e723e:	c5 f3 5e f3          	vdivsd %xmm3,%xmm1,%xmm6
 18e7242:	c5 f9 c6 c8 01       	vshufpd $0x1,%xmm0,%xmm0,%xmm1
 18e7247:	c5 e9 c6 da 01       	vshufpd $0x1,%xmm2,%xmm2,%xmm3
 18e724c:	48 8d 3d 60 0f d3 fe 	lea    -0x12cf0a0(%rip),%rdi        # 6181b3 <foreign_touch.flags+0xe80f>
 18e7253:	48 8d 35 39 75 d7 fe 	lea    -0x1288ac7(%rip),%rsi        # 65e793 <fuzz_comment_end+0x14ac9>
 18e725a:	b0 07                	mov    $0x7,%al
 18e725c:	e8 9f 2c eb fe       	call   799f00 <printf@plt>
 18e7261:	48 8b 9c 24 c8 00 00 00 	mov    0xc8(%rsp),%rbx
 18e7269:	83 c3 fd             	add    $0xfffffffd,%ebx
 18e726c:	83 fb 01             	cmp    $0x1,%ebx
 18e726f:	0f 87 b3 00 00 00    	ja     18e7328 <run_backend_benchmark+0xa258>
 18e7275:	48 8d bc 24 60 0a 00 00 	lea    0xa60(%rsp),%rdi
 18e727d:	e8 2e 7e 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e7282:	48 8d bc 24 08 0b 00 00 	lea    0xb08(%rsp),%rdi
 18e728a:	c5 f9 29 44 24 60    	vmovapd %xmm0,0x60(%rsp)
 18e7290:	e8 1b 7e 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e7295:	48 8d bc 24 b0 0b 00 00 	lea    0xbb0(%rsp),%rdi
 18e729d:	c5 fb 11 44 24 30    	vmovsd %xmm0,0x30(%rsp)
 18e72a3:	e8 08 7e 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e72a8:	48 8d bc 24 58 0c 00 00 	lea    0xc58(%rsp),%rdi
 18e72b0:	c5 f9 29 84 24 80 00 00 00 	vmovapd %xmm0,0x80(%rsp)
 18e72b9:	e8 f2 7d 00 00       	call   18ef0b0 <tier0_benchmark_median>
 18e72be:	c5 79 28 84 24 80 00 00 00 	vmovapd 0x80(%rsp),%xmm8
 18e72c7:	c5 f9 28 64 24 40    	vmovapd 0x40(%rsp),%xmm4
 18e72cd:	c5 f9 28 54 24 60    	vmovapd 0x60(%rsp),%xmm2
 18e72d3:	c5 fb 10 7c 24 30    	vmovsd 0x30(%rsp),%xmm7
 18e72d9:	c5 f9 28 b4 24 b0 00 00 00 	vmovapd 0xb0(%rsp),%xmm6
 18e72e2:	c5 f9 28 d8          	vmovapd %xmm0,%xmm3
 18e72e6:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18e72ea:	c5 eb 5e c4          	vdivsd %xmm4,%xmm2,%xmm0
 18e72ee:	c5 b9 14 d2          	vunpcklpd %xmm2,%xmm8,%xmm2
 18e72f2:	c5 c3 5e cc          	vdivsd %xmm4,%xmm7,%xmm1
 18e72f6:	c5 f9 2e fd          	vucomisd %xmm5,%xmm7
 18e72fa:	c5 e9 5e d4          	vdivpd %xmm4,%xmm2,%xmm2
 18e72fe:	c5 c3 5e e6          	vdivsd %xmm6,%xmm7,%xmm4
 18e7302:	75 02                	jne    18e7306 <run_backend_benchmark+0xa236>
 18e7304:	7b 04                	jnp    18e730a <run_backend_benchmark+0xa23a>
 18e7306:	c5 bb 5e ef          	vdivsd %xmm7,%xmm8,%xmm5
 18e730a:	c5 e3 5e f6          	vdivsd %xmm6,%xmm3,%xmm6
 18e730e:	c5 e9 c6 da 01       	vshufpd $0x1,%xmm2,%xmm2,%xmm3
 18e7313:	48 8d 3d 99 0e d3 fe 	lea    -0x12cf167(%rip),%rdi        # 6181b3 <foreign_touch.flags+0xe80f>
 18e731a:	48 8d 35 d2 64 da fe 	lea    -0x1259b2e(%rip),%rsi        # 68d7f3 <fuzz_comment_end+0x43b29>
 18e7321:	b0 07                	mov    $0x7,%al
 18e7323:	e8 d8 2b eb fe       	call   799f00 <printf@plt>
 18e7328:	45 31 e4             	xor    %r12d,%r12d
 18e732b:	4d 85 ed             	test   %r13,%r13
 18e732e:	0f 85 bc f2 ff ff    	jne    18e65f0 <run_backend_benchmark+0x9520>
 18e7334:	e9 de f2 ff ff       	jmp    18e6617 <run_backend_benchmark+0x9547>
 18e7339:	48 8d 3d 5d f0 e1 fe 	lea    -0x11e0fa3(%rip),%rdi        # 70639d <pp_string_value.meaning+0x72de5>
 18e7340:	48 8d 35 cd 69 dd fe 	lea    -0x1229633(%rip),%rsi        # 6bdd14 <pp_string_value.meaning+0x2a75c>
 18e7347:	48 8d 0d e1 69 dd fe 	lea    -0x122961f(%rip),%rcx        # 6bdd2f <pp_string_value.meaning+0x2a777>
 18e734e:	ba bf 00 00 00       	mov    $0xbf,%edx
 18e7353:	c5 f8 77             	vzeroupper
 18e7356:	e8 45 23 eb fe       	call   7996a0 <__assert_fail@plt>
 18e735b:	c5 f8 77             	vzeroupper
 18e735e:	e8 cd 22 eb fe       	call   799630 <__stack_chk_fail@plt>
