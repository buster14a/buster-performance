
/home/david/buster-fast-bench/codex-180-fix-20261026-caller-fixed/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000009e3fc0 <encode_one>:
  9e3fc0:	0f b7 47 0c          	movzwl 0xc(%rdi),%eax
  9e3fc4:	31 c9                	xor    %ecx,%ecx
  9e3fc6:	25 ff 7f 00 00       	and    $0x7fff,%eax
  9e3fcb:	66 3d a0 20          	cmp    $0x20a0,%ax
  9e3fcf:	0f 83 93 10 00 00    	jae    9e5068 <encode_one+0x10a8>
  9e3fd5:	55                   	push   %rbp
  9e3fd6:	41 57                	push   %r15
  9e3fd8:	41 56                	push   %r14
  9e3fda:	41 55                	push   %r13
  9e3fdc:	41 54                	push   %r12
  9e3fde:	53                   	push   %rbx
  9e3fdf:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  9e3fe3:	48 8d 15 86 d1 38 01 	lea    0x138d186(%rip),%rdx        # 1d71170 <x86_form_descriptions>
  9e3fea:	44 0f b6 7f 0a       	movzbl 0xa(%rdi),%r15d
  9e3fef:	44 0f b6 57 0b       	movzbl 0xb(%rdi),%r10d
  9e3ff4:	0f b6 6f 09          	movzbl 0x9(%rdi),%ebp
  9e3ff8:	44 0f b6 4c c2 11    	movzbl 0x11(%rdx,%rax,8),%r9d
  9e3ffe:	44 0f b7 5c c2 18    	movzwl 0x18(%rdx,%rax,8),%r11d
  9e4004:	4c 8d 04 c2          	lea    (%rdx,%rax,8),%r8
  9e4008:	44 88 7c 24 cb       	mov    %r15b,-0x35(%rsp)
  9e400d:	41 80 f9 01          	cmp    $0x1,%r9b
  9e4011:	44 88 4c 24 ca       	mov    %r9b,-0x36(%rsp)
  9e4016:	45 89 d9             	mov    %r11d,%r9d
  9e4019:	0f 94 44 24 d7       	sete   -0x29(%rsp)
  9e401e:	41 83 e1 0f          	and    $0xf,%r9d
  9e4022:	41 8d 51 fb          	lea    -0x5(%r9),%edx
  9e4026:	41 f6 c2 04          	test   $0x4,%r10b
  9e402a:	74 10                	je     9e403c <encode_one+0x7c>
  9e402c:	44 89 d0             	mov    %r10d,%eax
  9e402f:	41 80 e7 08          	and    $0x8,%r15b
  9e4033:	c0 e8 04             	shr    $0x4,%al
  9e4036:	41 c0 ef 03          	shr    $0x3,%r15b
  9e403a:	eb 0e                	jmp    9e404a <encode_one+0x8a>
  9e403c:	66 83 fa fc          	cmp    $0xfffc,%dx
  9e4040:	41 89 ef             	mov    %ebp,%r15d
  9e4043:	0f 92 c0             	setb   %al
  9e4046:	41 c0 ef 04          	shr    $0x4,%r15b
  9e404a:	41 20 c7             	and    %al,%r15b
  9e404d:	0f b6 47 08          	movzbl 0x8(%rdi),%eax
  9e4051:	44 0f b6 67 0e       	movzbl 0xe(%rdi),%r12d
  9e4056:	45 0f b6 70 10       	movzbl 0x10(%r8),%r14d
  9e405b:	41 f6 c2 04          	test   $0x4,%r10b
  9e405f:	44 89 54 24 d8       	mov    %r10d,-0x28(%rsp)
  9e4064:	0f 94 c3             	sete   %bl
  9e4067:	48 89 44 24 f0       	mov    %rax,-0x10(%rsp)
  9e406c:	31 c0                	xor    %eax,%eax
  9e406e:	45 85 f6             	test   %r14d,%r14d
  9e4071:	74 0b                	je     9e407e <encode_one+0xbe>
  9e4073:	41 80 78 1c 00       	cmpb   $0x0,0x1c(%r8)
  9e4078:	0f 84 08 01 00 00    	je     9e4186 <encode_one+0x1c6>
  9e407e:	45 31 d2             	xor    %r10d,%r10d
  9e4081:	85 c9                	test   %ecx,%ecx
  9e4083:	74 0c                	je     9e4091 <encode_one+0xd1>
  9e4085:	41 89 c5             	mov    %eax,%r13d
  9e4088:	80 c1 63             	add    $0x63,%cl
  9e408b:	ff c0                	inc    %eax
  9e408d:	42 88 0c 2e          	mov    %cl,(%rsi,%r13,1)
  9e4091:	41 80 fa 3e          	cmp    $0x3e,%r10b
  9e4095:	75 07                	jne    9e409e <encode_one+0xde>
  9e4097:	41 80 78 1b 0c       	cmpb   $0xc,0x1b(%r8)
  9e409c:	75 05                	jne    9e40a3 <encode_one+0xe3>
  9e409e:	44 89 d1             	mov    %r10d,%ecx
  9e40a1:	eb 2d                	jmp    9e40d0 <encode_one+0x110>
  9e40a3:	44 89 d1             	mov    %r10d,%ecx
  9e40a6:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
  9e40b0:	41 89 c5             	mov    %eax,%r13d
  9e40b3:	ff c0                	inc    %eax
  9e40b5:	c1 e9 08             	shr    $0x8,%ecx
  9e40b8:	41 81 e2 00 ff 00 00 	and    $0xff00,%r10d
  9e40bf:	42 c6 04 2e 3e       	movb   $0x3e,(%rsi,%r13,1)
  9e40c4:	41 81 fa 00 3e 00 00 	cmp    $0x3e00,%r10d
  9e40cb:	41 89 ca             	mov    %ecx,%r10d
  9e40ce:	74 e0                	je     9e40b0 <encode_one+0xf0>
  9e40d0:	45 85 f6             	test   %r14d,%r14d
  9e40d3:	0f 84 36 0b 00 00    	je     9e4c0f <encode_one+0xc4f>
  9e40d9:	44 8b 54 24 d8       	mov    -0x28(%rsp),%r10d
  9e40de:	41 89 ed             	mov    %ebp,%r13d
  9e40e1:	89 6c 24 dc          	mov    %ebp,-0x24(%rsp)
  9e40e5:	0f b6 6c 24 ca       	movzbl -0x36(%rsp),%ebp
  9e40ea:	41 83 e5 1f          	and    $0x1f,%r13d
  9e40ee:	44 89 6c 24 ec       	mov    %r13d,-0x14(%rsp)
  9e40f3:	41 83 e5 08          	and    $0x8,%r13d
  9e40f7:	41 c1 ed 03          	shr    $0x3,%r13d
  9e40fb:	41 83 e2 08          	and    $0x8,%r10d
  9e40ff:	40 80 e5 08          	and    $0x8,%bpl
  9e4103:	41 c1 ea 03          	shr    $0x3,%r10d
  9e4107:	40 c0 ed 03          	shr    $0x3,%bpl
  9e410b:	44 08 d3             	or     %r10b,%bl
  9e410e:	4c 8b 54 24 f0       	mov    -0x10(%rsp),%r10
  9e4113:	40 08 6c 24 d7       	or     %bpl,-0x29(%rsp)
  9e4118:	41 20 dd             	and    %bl,%r13b
  9e411b:	44 89 d5             	mov    %r10d,%ebp
  9e411e:	45 0f b6 50 1c       	movzbl 0x1c(%r8),%r10d
  9e4123:	40 80 e5 08          	and    $0x8,%bpl
  9e4127:	45 84 d2             	test   %r10b,%r10b
  9e412a:	74 79                	je     9e41a5 <encode_one+0x1e5>
  9e412c:	45 8b 48 08          	mov    0x8(%r8),%r9d
  9e4130:	42 8d 0c f5 00 00 00 00 	lea    0x0(,%r14,8),%ecx
  9e4138:	80 c1 f8             	add    $0xf8,%cl
  9e413b:	c4 c2 73 f7 c9       	shrx   %ecx,%r9d,%ecx
  9e4140:	44 89 4c 24 cc       	mov    %r9d,-0x34(%rsp)
  9e4145:	41 83 fe 02          	cmp    $0x2,%r14d
  9e4149:	0f 85 21 01 00 00    	jne    9e4270 <encode_one+0x2b0>
  9e414f:	b3 01                	mov    $0x1,%bl
  9e4151:	80 f9 0f             	cmp    $0xf,%cl
  9e4154:	0f 85 16 01 00 00    	jne    9e4270 <encode_one+0x2b0>
  9e415a:	41 8b 48 0c          	mov    0xc(%r8),%ecx
  9e415e:	83 f9 66             	cmp    $0x66,%ecx
  9e4161:	0f 84 ed 02 00 00    	je     9e4454 <encode_one+0x494>
  9e4167:	81 f9 f3 00 00 00    	cmp    $0xf3,%ecx
  9e416d:	0f 84 8f 02 00 00    	je     9e4402 <encode_one+0x442>
  9e4173:	81 f9 f2 00 00 00    	cmp    $0xf2,%ecx
  9e4179:	0f 85 dd 02 00 00    	jne    9e445c <encode_one+0x49c>
  9e417f:	b1 03                	mov    $0x3,%cl
  9e4181:	e9 d0 02 00 00       	jmp    9e4456 <encode_one+0x496>
  9e4186:	45 8b 50 0c          	mov    0xc(%r8),%r10d
  9e418a:	41 80 fa 9b          	cmp    $0x9b,%r10b
  9e418e:	0f 85 ed fe ff ff    	jne    9e4081 <encode_one+0xc1>
  9e4194:	41 c1 ea 08          	shr    $0x8,%r10d
  9e4198:	b8 01 00 00 00       	mov    $0x1,%eax
  9e419d:	c6 06 9b             	movb   $0x9b,(%rsi)
  9e41a0:	e9 dc fe ff ff       	jmp    9e4081 <encode_one+0xc1>
  9e41a5:	45 8b 50 0c          	mov    0xc(%r8),%r10d
  9e41a9:	31 d2                	xor    %edx,%edx
  9e41ab:	45 85 d2             	test   %r10d,%r10d
  9e41ae:	74 11                	je     9e41c1 <encode_one+0x201>
  9e41b0:	41 80 fa d5          	cmp    $0xd5,%r10b
  9e41b4:	41 0f 94 c3          	sete   %r11b
  9e41b8:	44 08 da             	or     %r11b,%dl
  9e41bb:	41 c1 ea 08          	shr    $0x8,%r10d
  9e41bf:	75 ef                	jne    9e41b0 <encode_one+0x1f0>
  9e41c1:	85 c9                	test   %ecx,%ecx
  9e41c3:	41 0f 94 c2          	sete   %r10b
  9e41c7:	80 f9 d5             	cmp    $0xd5,%cl
  9e41ca:	41 0f 94 c3          	sete   %r11b
  9e41ce:	45 08 d3             	or     %r10b,%r11b
  9e41d1:	75 2d                	jne    9e4200 <encode_one+0x240>
  9e41d3:	41 89 ca             	mov    %ecx,%r10d
  9e41d6:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
  9e41e0:	41 89 c3             	mov    %eax,%r11d
  9e41e3:	ff c0                	inc    %eax
  9e41e5:	41 c1 ea 08          	shr    $0x8,%r10d
  9e41e9:	42 88 0c 1e          	mov    %cl,(%rsi,%r11,1)
  9e41ed:	74 11                	je     9e4200 <encode_one+0x240>
  9e41ef:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  9e41f5:	81 f9 00 d5 00 00    	cmp    $0xd500,%ecx
  9e41fb:	44 89 d1             	mov    %r10d,%ecx
  9e41fe:	75 e0                	jne    9e41e0 <encode_one+0x220>
  9e4200:	8b 4c 24 d8          	mov    -0x28(%rsp),%ecx
  9e4204:	44 0f b6 5c 24 cb    	movzbl -0x35(%rsp),%r11d
  9e420a:	f7 d1                	not    %ecx
  9e420c:	f6 c1 14             	test   $0x14,%cl
  9e420f:	41 0f b6 48 14       	movzbl 0x14(%r8),%ecx
  9e4214:	41 0f 94 c7          	sete   %r15b
  9e4218:	41 80 e3 08          	and    $0x8,%r11b
  9e421c:	40 d0 ed             	shr    $1,%bpl
  9e421f:	41 c0 eb 03          	shr    $0x3,%r11b
  9e4223:	45 20 fb             	and    %r15b,%r11b
  9e4226:	45 00 db             	add    %r11b,%r11b
  9e4229:	c0 e1 03             	shl    $0x3,%cl
  9e422c:	40 08 cd             	or     %cl,%bpl
  9e422f:	41 08 eb             	or     %bpl,%r11b
  9e4232:	45 08 eb             	or     %r13b,%r11b
  9e4235:	44 89 d9             	mov    %r11d,%ecx
  9e4238:	80 c9 40             	or     $0x40,%cl
  9e423b:	80 7c 24 ec 10       	cmpb   $0x10,-0x14(%rsp)
  9e4240:	0f 93 44 24 cc       	setae  -0x34(%rsp)
  9e4245:	41 80 fe 02          	cmp    $0x2,%r14b
  9e4249:	76 51                	jbe    9e429c <encode_one+0x2dc>
  9e424b:	45 8b 60 08          	mov    0x8(%r8),%r12d
  9e424f:	46 8d 14 f5 00 00 00 00 	lea    0x0(,%r14,8),%r10d
  9e4257:	41 8d 6a f0          	lea    -0x10(%r10),%ebp
  9e425b:	c4 c2 53 f7 ec       	shrx   %ebp,%r12d,%ebp
  9e4260:	81 e5 fd 00 00 00    	and    $0xfd,%ebp
  9e4266:	83 fd 38             	cmp    $0x38,%ebp
  9e4269:	0f 95 44 24 d0       	setne  -0x30(%rsp)
  9e426e:	eb 3d                	jmp    9e42ad <encode_one+0x2ed>
  9e4270:	41 83 fe 02          	cmp    $0x2,%r14d
  9e4274:	0f 85 8c 01 00 00    	jne    9e4406 <encode_one+0x446>
  9e427a:	41 80 fa 02          	cmp    $0x2,%r10b
  9e427e:	0f 85 96 03 00 00    	jne    9e461a <encode_one+0x65a>
  9e4284:	41 89 c9             	mov    %ecx,%r9d
  9e4287:	41 80 e1 fc          	and    $0xfc,%r9b
  9e428b:	41 80 f9 04          	cmp    $0x4,%r9b
  9e428f:	0f 85 85 03 00 00    	jne    9e461a <encode_one+0x65a>
  9e4295:	89 cb                	mov    %ecx,%ebx
  9e4297:	e9 be fe ff ff       	jmp    9e415a <encode_one+0x19a>
  9e429c:	45 8b 60 08          	mov    0x8(%r8),%r12d
  9e42a0:	46 8d 14 f5 00 00 00 00 	lea    0x0(,%r14,8),%r10d
  9e42a8:	c6 44 24 d0 01       	movb   $0x1,-0x30(%rsp)
  9e42ad:	45 0f b7 68 16       	movzwl 0x16(%r8),%r13d
  9e42b2:	41 80 c2 f8          	add    $0xf8,%r10b
  9e42b6:	c4 42 2b f7 d4       	shrx   %r10d,%r12d,%r10d
  9e42bb:	41 80 fa 0f          	cmp    $0xf,%r10b
  9e42bf:	40 0f 94 c5          	sete   %bpl
  9e42c3:	80 f9 40             	cmp    $0x40,%cl
  9e42c6:	41 0f 95 c2          	setne  %r10b
  9e42ca:	41 83 e5 0f          	and    $0xf,%r13d
  9e42ce:	66 41 83 fd 01       	cmp    $0x1,%r13w
  9e42d3:	75 1b                	jne    9e42f0 <encode_one+0x330>
  9e42d5:	44 0f b6 57 08       	movzbl 0x8(%rdi),%r10d
  9e42da:	80 f9 40             	cmp    $0x40,%cl
  9e42dd:	41 0f 95 c5          	setne  %r13b
  9e42e1:	41 80 e2 fc          	and    $0xfc,%r10b
  9e42e5:	41 80 fa 04          	cmp    $0x4,%r10b
  9e42e9:	41 0f 94 c2          	sete   %r10b
  9e42ed:	45 08 ea             	or     %r13b,%r10b
  9e42f0:	f6 44 24 d8 04       	testb  $0x4,-0x28(%rsp)
  9e42f5:	75 1b                	jne    9e4312 <encode_one+0x352>
  9e42f7:	66 41 83 f9 01       	cmp    $0x1,%r9w
  9e42fc:	75 14                	jne    9e4312 <encode_one+0x352>
  9e42fe:	44 0f b6 4f 09       	movzbl 0x9(%rdi),%r9d
  9e4303:	41 80 e1 fc          	and    $0xfc,%r9b
  9e4307:	41 80 f9 04          	cmp    $0x4,%r9b
  9e430b:	41 0f 94 c1          	sete   %r9b
  9e430f:	45 08 ca             	or     %r9b,%r10b
  9e4312:	f6 c2 01             	test   $0x1,%dl
  9e4315:	74 57                	je     9e436e <encode_one+0x3ae>
  9e4317:	0f b6 4c 24 cb       	movzbl -0x35(%rsp),%ecx
  9e431c:	48 8b 54 24 f0       	mov    -0x10(%rsp),%rdx
  9e4321:	22 5c 24 cc          	and    -0x34(%rsp),%bl
  9e4325:	40 22 6c 24 d0       	and    -0x30(%rsp),%bpl
  9e432a:	41 80 e3 0f          	and    $0xf,%r11b
  9e432e:	8d 14 95 00 00 00 00 	lea    0x0(,%rdx,4),%edx
  9e4335:	80 e1 10             	and    $0x10,%cl
  9e4338:	c0 e3 04             	shl    $0x4,%bl
  9e433b:	c0 e9 04             	shr    $0x4,%cl
  9e433e:	41 20 cf             	and    %cl,%r15b
  9e4341:	80 e2 40             	and    $0x40,%dl
  9e4344:	89 c1                	mov    %eax,%ecx
  9e4346:	c6 04 0e d5          	movb   $0xd5,(%rsi,%rcx,1)
  9e434a:	89 e9                	mov    %ebp,%ecx
  9e434c:	40 0f b6 ed          	movzbl %bpl,%ebp
  9e4350:	41 c0 e7 05          	shl    $0x5,%r15b
  9e4354:	08 d3                	or     %dl,%bl
  9e4356:	c0 e1 07             	shl    $0x7,%cl
  9e4359:	44 08 fb             	or     %r15b,%bl
  9e435c:	41 08 db             	or     %bl,%r11b
  9e435f:	41 08 cb             	or     %cl,%r11b
  9e4362:	8d 48 01             	lea    0x1(%rax),%ecx
  9e4365:	83 c0 02             	add    $0x2,%eax
  9e4368:	44 88 1c 0e          	mov    %r11b,(%rsi,%rcx,1)
  9e436c:	eb 0f                	jmp    9e437d <encode_one+0x3bd>
  9e436e:	31 ed                	xor    %ebp,%ebp
  9e4370:	41 f6 c2 01          	test   $0x1,%r10b
  9e4374:	74 07                	je     9e437d <encode_one+0x3bd>
  9e4376:	89 c2                	mov    %eax,%edx
  9e4378:	ff c0                	inc    %eax
  9e437a:	88 0c 16             	mov    %cl,(%rsi,%rdx,1)
  9e437d:	44 89 e2             	mov    %r12d,%edx
  9e4380:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
  9e4386:	44 89 f1             	mov    %r14d,%ecx
  9e4389:	83 f1 03             	xor    $0x3,%ecx
  9e438c:	45 31 db             	xor    %r11d,%r11d
  9e438f:	81 f2 00 0f 0f 00    	xor    $0xf0f00,%edx
  9e4395:	09 ca                	or     %ecx,%edx
  9e4397:	44 89 f2             	mov    %r14d,%edx
  9e439a:	41 0f 94 c3          	sete   %r11b
  9e439e:	44 29 da             	sub    %r11d,%edx
  9e43a1:	39 d5                	cmp    %edx,%ebp
  9e43a3:	73 55                	jae    9e43fa <encode_one+0x43a>
  9e43a5:	8b 4c 24 dc          	mov    -0x24(%rsp),%ecx
  9e43a9:	41 f7 db             	neg    %r11d
  9e43ac:	47 8d 14 1e          	lea    (%r14,%r11,1),%r10d
  9e43b0:	41 89 cd             	mov    %ecx,%r13d
  9e43b3:	44 89 d1             	mov    %r10d,%ecx
  9e43b6:	29 e9                	sub    %ebp,%ecx
  9e43b8:	41 80 e5 07          	and    $0x7,%r13b
  9e43bc:	83 f9 08             	cmp    $0x8,%ecx
  9e43bf:	72 11                	jb     9e43d2 <encode_one+0x412>
  9e43c1:	89 4c 24 cc          	mov    %ecx,-0x34(%rsp)
  9e43c5:	89 e9                	mov    %ebp,%ecx
  9e43c7:	44 29 d1             	sub    %r10d,%ecx
  9e43ca:	39 c1                	cmp    %eax,%ecx
  9e43cc:	0f 83 4b 09 00 00    	jae    9e4d1d <encode_one+0xd5d>
  9e43d2:	41 89 c7             	mov    %eax,%r15d
  9e43d5:	41 89 e9             	mov    %ebp,%r9d
  9e43d8:	41 8d 49 01          	lea    0x1(%r9),%ecx
  9e43dc:	41 0f b6 c5          	movzbl %r13b,%eax
  9e43e0:	89 54 24 cc          	mov    %edx,-0x34(%rsp)
  9e43e4:	41 39 ca             	cmp    %ecx,%r10d
  9e43e7:	0f 85 8d 01 00 00    	jne    9e457a <encode_one+0x5ba>
  9e43ed:	0f b6 54 24 ca       	movzbl -0x36(%rsp),%edx
  9e43f2:	44 89 c9             	mov    %r9d,%ecx
  9e43f5:	e9 e2 01 00 00       	jmp    9e45dc <encode_one+0x61c>
  9e43fa:	41 89 c7             	mov    %eax,%r15d
  9e43fd:	e9 8b 03 00 00       	jmp    9e478d <encode_one+0x7cd>
  9e4402:	b1 02                	mov    $0x2,%cl
  9e4404:	eb 50                	jmp    9e4456 <encode_one+0x496>
  9e4406:	44 8b 4c 24 cc       	mov    -0x34(%rsp),%r9d
  9e440b:	41 83 f6 03          	xor    $0x3,%r14d
  9e440f:	44 89 c9             	mov    %r9d,%ecx
  9e4412:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
  9e4418:	81 f1 00 00 0f 00    	xor    $0xf0000,%ecx
  9e441e:	44 09 f1             	or     %r14d,%ecx
  9e4421:	0f 85 12 02 00 00    	jne    9e4639 <encode_one+0x679>
  9e4427:	44 89 c9             	mov    %r9d,%ecx
  9e442a:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  9e4430:	b3 02                	mov    $0x2,%bl
  9e4432:	81 f9 00 38 00 00    	cmp    $0x3800,%ecx
  9e4438:	0f 84 1c fd ff ff    	je     9e415a <encode_one+0x19a>
  9e443e:	45 31 c9             	xor    %r9d,%r9d
  9e4441:	81 f9 00 3a 00 00    	cmp    $0x3a00,%ecx
  9e4447:	41 0f 94 c1          	sete   %r9b
  9e444b:	43 8d 1c 49          	lea    (%r9,%r9,2),%ebx
  9e444f:	e9 06 fd ff ff       	jmp    9e415a <encode_one+0x19a>
  9e4454:	b1 01                	mov    $0x1,%cl
  9e4456:	89 4c 24 d0          	mov    %ecx,-0x30(%rsp)
  9e445a:	eb 08                	jmp    9e4464 <encode_one+0x4a4>
  9e445c:	c7 44 24 d0 00 00 00 00 	movl   $0x0,-0x30(%rsp)
  9e4464:	66 41 81 78 1e 00 10 	cmpw   $0x1000,0x1e(%r8)
  9e446b:	41 0f 95 c1          	setne  %r9b
  9e446f:	41 f6 d9             	neg    %r9b
  9e4472:	45 30 e1             	xor    %r12b,%r9b
  9e4475:	41 c0 e1 03          	shl    $0x3,%r9b
  9e4479:	41 80 e1 78          	and    $0x78,%r9b
  9e447d:	41 80 fa 01          	cmp    $0x1,%r10b
  9e4481:	75 55                	jne    9e44d8 <encode_one+0x518>
  9e4483:	80 fb 01             	cmp    $0x1,%bl
  9e4486:	75 50                	jne    9e44d8 <encode_one+0x518>
  9e4488:	41 0f b6 48 14       	movzbl 0x14(%r8),%ecx
  9e448d:	45 89 fa             	mov    %r15d,%r10d
  9e4490:	84 c9                	test   %cl,%cl
  9e4492:	0f 95 c2             	setne  %dl
  9e4495:	45 08 ea             	or     %r13b,%r10b
  9e4498:	41 08 d2             	or     %dl,%r10b
  9e449b:	41 f6 c2 01          	test   $0x1,%r10b
  9e449f:	75 42                	jne    9e44e3 <encode_one+0x523>
  9e44a1:	89 c2                	mov    %eax,%edx
  9e44a3:	c6 04 16 c5          	movb   $0xc5,(%rsi,%rdx,1)
  9e44a7:	40 84 ed             	test   %bpl,%bpl
  9e44aa:	ba 01 00 00 00       	mov    $0x1,%edx
  9e44af:	45 0f b6 70 1d       	movzbl 0x1d(%r8),%r14d
  9e44b4:	0f 94 c1             	sete   %cl
  9e44b7:	c0 e1 07             	shl    $0x7,%cl
  9e44ba:	41 c0 e6 02          	shl    $0x2,%r14b
  9e44be:	41 08 ce             	or     %cl,%r14b
  9e44c1:	44 02 74 24 d0       	add    -0x30(%rsp),%r14b
  9e44c6:	b9 02 00 00 00       	mov    $0x2,%ecx
  9e44cb:	45 08 ce             	or     %r9b,%r14b
  9e44ce:	44 8b 4c 24 cc       	mov    -0x34(%rsp),%r9d
  9e44d3:	e9 a3 02 00 00       	jmp    9e477b <encode_one+0x7bb>
  9e44d8:	41 80 fa 01          	cmp    $0x1,%r10b
  9e44dc:	75 73                	jne    9e4551 <encode_one+0x591>
  9e44de:	41 0f b6 48 14       	movzbl 0x14(%r8),%ecx
  9e44e3:	40 84 ed             	test   %bpl,%bpl
  9e44e6:	41 ba 8f 00 00 00    	mov    $0x8f,%r10d
  9e44ec:	41 bb c4 00 00 00    	mov    $0xc4,%r11d
  9e44f2:	0f 94 c2             	sete   %dl
  9e44f5:	80 fb 08             	cmp    $0x8,%bl
  9e44f8:	45 0f 43 da          	cmovae %r10d,%r11d
  9e44fc:	41 80 f5 01          	xor    $0x1,%r13b
  9e4500:	41 80 f7 01          	xor    $0x1,%r15b
  9e4504:	c0 e2 07             	shl    $0x7,%dl
  9e4507:	41 89 c2             	mov    %eax,%r10d
  9e450a:	c0 e1 07             	shl    $0x7,%cl
  9e450d:	41 c0 e5 05          	shl    $0x5,%r13b
  9e4511:	41 c0 e7 06          	shl    $0x6,%r15b
  9e4515:	46 88 1c 16          	mov    %r11b,(%rsi,%r10,1)
  9e4519:	41 08 d5             	or     %dl,%r13b
  9e451c:	8d 50 01             	lea    0x1(%rax),%edx
  9e451f:	45 08 fd             	or     %r15b,%r13b
  9e4522:	41 08 dd             	or     %bl,%r13b
  9e4525:	44 88 2c 16          	mov    %r13b,(%rsi,%rdx,1)
  9e4529:	ba 02 00 00 00       	mov    $0x2,%edx
  9e452e:	45 0f b6 70 1d       	movzbl 0x1d(%r8),%r14d
  9e4533:	41 c0 e6 02          	shl    $0x2,%r14b
  9e4537:	41 08 ce             	or     %cl,%r14b
  9e453a:	44 02 74 24 d0       	add    -0x30(%rsp),%r14b
  9e453f:	b9 03 00 00 00       	mov    $0x3,%ecx
  9e4544:	45 08 ce             	or     %r9b,%r14b
  9e4547:	44 8b 4c 24 cc       	mov    -0x34(%rsp),%r9d
  9e454c:	e9 2a 02 00 00       	jmp    9e477b <encode_one+0x7bb>
  9e4551:	44 0f b6 77 0f       	movzbl 0xf(%rdi),%r14d
  9e4556:	41 0f b7 48 20       	movzwl 0x20(%r8),%ecx
  9e455b:	89 4c 24 fc          	mov    %ecx,-0x4(%rsp)
  9e455f:	44 88 74 24 e0       	mov    %r14b,-0x20(%rsp)
  9e4564:	f6 c1 18             	test   $0x18,%cl
  9e4567:	0f 84 d3 00 00 00    	je     9e4640 <encode_one+0x680>
  9e456d:	41 c0 ee 05          	shr    $0x5,%r14b
  9e4571:	41 80 e6 03          	and    $0x3,%r14b
  9e4575:	e9 cb 00 00 00       	jmp    9e4645 <encode_one+0x685>
  9e457a:	0f b6 54 24 ca       	movzbl -0x36(%rsp),%edx
  9e457f:	47 8d 54 1e ff       	lea    -0x1(%r14,%r11,1),%r10d
  9e4584:	45 89 cb             	mov    %r9d,%r11d
  9e4587:	41 f7 d3             	not    %r11d
  9e458a:	31 db                	xor    %ebx,%ebx
  9e458c:	45 01 f3             	add    %r14d,%r11d
  9e458f:	41 c1 e3 03          	shl    $0x3,%r11d
  9e4593:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  9e45a0:	45 39 f1             	cmp    %r14d,%r9d
  9e45a3:	c4 c2 23 f7 ec       	shrx   %r11d,%r12d,%ebp
  9e45a8:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  9e45ae:	41 8d 49 01          	lea    0x1(%r9),%ecx
  9e45b2:	0f 43 eb             	cmovae %ebx,%ebp
  9e45b5:	80 fa 02             	cmp    $0x2,%dl
  9e45b8:	44 0f 44 e8          	cmove  %eax,%r13d
  9e45bc:	45 39 ca             	cmp    %r9d,%r10d
  9e45bf:	45 89 f9             	mov    %r15d,%r9d
  9e45c2:	44 0f 45 eb          	cmovne %ebx,%r13d
  9e45c6:	41 ff c7             	inc    %r15d
  9e45c9:	41 83 c3 f8          	add    $0xfffffff8,%r11d
  9e45cd:	41 09 ed             	or     %ebp,%r13d
  9e45d0:	46 88 2c 0e          	mov    %r13b,(%rsi,%r9,1)
  9e45d4:	41 89 c9             	mov    %ecx,%r9d
  9e45d7:	41 39 ca             	cmp    %ecx,%r10d
  9e45da:	75 c4                	jne    9e45a0 <encode_one+0x5e0>
  9e45dc:	41 89 c9             	mov    %ecx,%r9d
  9e45df:	41 f7 d1             	not    %r9d
  9e45e2:	45 31 d2             	xor    %r10d,%r10d
  9e45e5:	45 01 f1             	add    %r14d,%r9d
  9e45e8:	41 c1 e1 03          	shl    $0x3,%r9d
  9e45ec:	44 39 f1             	cmp    %r14d,%ecx
  9e45ef:	c4 42 33 f7 cc       	shrx   %r9d,%r12d,%r9d
  9e45f4:	45 0f 43 ca          	cmovae %r10d,%r9d
  9e45f8:	ff c1                	inc    %ecx
  9e45fa:	80 fa 02             	cmp    $0x2,%dl
  9e45fd:	41 0f 45 c2          	cmovne %r10d,%eax
  9e4601:	3b 4c 24 cc          	cmp    -0x34(%rsp),%ecx
  9e4605:	44 89 f9             	mov    %r15d,%ecx
  9e4608:	41 0f 45 c2          	cmovne %r10d,%eax
  9e460c:	41 ff c7             	inc    %r15d
  9e460f:	44 09 c8             	or     %r9d,%eax
  9e4612:	88 04 0e             	mov    %al,(%rsi,%rcx,1)
  9e4615:	e9 73 01 00 00       	jmp    9e478d <encode_one+0x7cd>
  9e461a:	44 8d 49 fb          	lea    -0x5(%rcx),%r9d
  9e461e:	45 31 f6             	xor    %r14d,%r14d
  9e4621:	0f b6 d9             	movzbl %cl,%ebx
  9e4624:	41 80 f9 06          	cmp    $0x6,%r9b
  9e4628:	41 0f 43 de          	cmovae %r14d,%ebx
  9e462c:	41 80 fa 01          	cmp    $0x1,%r10b
  9e4630:	41 0f 45 de          	cmovne %r14d,%ebx
  9e4634:	e9 21 fb ff ff       	jmp    9e415a <encode_one+0x19a>
  9e4639:	31 db                	xor    %ebx,%ebx
  9e463b:	e9 1a fb ff ff       	jmp    9e415a <encode_one+0x19a>
  9e4640:	45 0f b6 70 1d       	movzbl 0x1d(%r8),%r14d
  9e4645:	44 0f b6 54 24 cb    	movzbl -0x35(%rsp),%r10d
  9e464b:	41 0f b6 cc          	movzbl %r12b,%ecx
  9e464f:	41 f6 c3 40          	test   $0x40,%r11b
  9e4653:	41 0f 45 ca          	cmovne %r10d,%ecx
  9e4657:	44 8b 54 24 d8       	mov    -0x28(%rsp),%r10d
  9e465c:	41 f6 c2 04          	test   $0x4,%r10b
  9e4660:	74 0a                	je     9e466c <encode_one+0x6ac>
  9e4662:	41 f6 c2 08          	test   $0x8,%r10b
  9e4666:	75 0a                	jne    9e4672 <encode_one+0x6b2>
  9e4668:	31 d2                	xor    %edx,%edx
  9e466a:	eb 0f                	jmp    9e467b <encode_one+0x6bb>
  9e466c:	66 83 fa fc          	cmp    $0xfffc,%dx
  9e4670:	72 f6                	jb     9e4668 <encode_one+0x6a8>
  9e4672:	8b 54 24 dc          	mov    -0x24(%rsp),%edx
  9e4676:	d0 ea                	shr    $1,%dl
  9e4678:	80 e2 08             	and    $0x8,%dl
  9e467b:	44 0f b6 54 24 cb    	movzbl -0x35(%rsp),%r10d
  9e4681:	44 8b 64 24 d8       	mov    -0x28(%rsp),%r12d
  9e4686:	40 84 ed             	test   %bpl,%bpl
  9e4689:	40 0f 94 c5          	sete   %bpl
  9e468d:	41 f6 d2             	not    %r10b
  9e4690:	41 f7 d4             	not    %r12d
  9e4693:	41 c0 ea 02          	shr    $0x2,%r10b
  9e4697:	41 80 e2 04          	and    $0x4,%r10b
  9e469b:	41 f6 c3 40          	test   $0x40,%r11b
  9e469f:	41 bb 04 00 00 00    	mov    $0x4,%r11d
  9e46a5:	45 0f b6 d2          	movzbl %r10b,%r10d
  9e46a9:	45 0f 45 d3          	cmovne %r11d,%r10d
  9e46ad:	41 f6 c4 14          	test   $0x14,%r12b
  9e46b1:	45 0f 45 d3          	cmovne %r11d,%r10d
  9e46b5:	41 80 f5 01          	xor    $0x1,%r13b
  9e46b9:	41 89 c3             	mov    %eax,%r11d
  9e46bc:	42 c6 04 1e 62       	movb   $0x62,(%rsi,%r11,1)
  9e46c1:	4c 8b 5c 24 f0       	mov    -0x10(%rsp),%r11
  9e46c6:	40 c0 e5 07          	shl    $0x7,%bpl
  9e46ca:	41 80 e3 10          	and    $0x10,%r11b
  9e46ce:	41 80 f7 01          	xor    $0x1,%r15b
  9e46d2:	41 c0 e5 05          	shl    $0x5,%r13b
  9e46d6:	41 08 eb             	or     %bpl,%r11b
  9e46d9:	41 c0 e7 06          	shl    $0x6,%r15b
  9e46dd:	45 08 eb             	or     %r13b,%r11b
  9e46e0:	45 08 fb             	or     %r15b,%r11b
  9e46e3:	41 08 d3             	or     %dl,%r11b
  9e46e6:	8d 50 01             	lea    0x1(%rax),%edx
  9e46e9:	41 80 f3 10          	xor    $0x10,%r11b
  9e46ed:	41 08 db             	or     %bl,%r11b
  9e46f0:	44 88 1c 16          	mov    %r11b,(%rsi,%rdx,1)
  9e46f4:	44 8b 5c 24 fc       	mov    -0x4(%rsp),%r11d
  9e46f9:	41 0f b6 50 14       	movzbl 0x14(%r8),%edx
  9e46fe:	c0 e2 07             	shl    $0x7,%dl
  9e4701:	44 08 d2             	or     %r10b,%dl
  9e4704:	44 08 ca             	or     %r9b,%dl
  9e4707:	02 54 24 d0          	add    -0x30(%rsp),%dl
  9e470b:	44 8d 48 02          	lea    0x2(%rax),%r9d
  9e470f:	42 88 14 0e          	mov    %dl,(%rsi,%r9,1)
  9e4713:	45 84 db             	test   %r11b,%r11b
  9e4716:	78 2d                	js     9e4745 <encode_one+0x785>
  9e4718:	44 0f b6 54 24 e0    	movzbl -0x20(%rsp),%r10d
  9e471e:	31 d2                	xor    %edx,%edx
  9e4720:	f6 c1 10             	test   $0x10,%cl
  9e4723:	b9 05 01 00 00       	mov    $0x105,%ecx
  9e4728:	44 8b 4c 24 cc       	mov    -0x34(%rsp),%r9d
  9e472d:	0f 94 c2             	sete   %dl
  9e4730:	c4 c2 70 f7 cb       	bextr  %ecx,%r11d,%ecx
  9e4735:	c1 e2 03             	shl    $0x3,%edx
  9e4738:	8d 0c 8a             	lea    (%rdx,%rcx,4),%ecx
  9e473b:	44 89 d2             	mov    %r10d,%edx
  9e473e:	80 e2 07             	and    $0x7,%dl
  9e4741:	08 d1                	or     %dl,%cl
  9e4743:	eb 11                	jmp    9e4756 <encode_one+0x796>
  9e4745:	44 8b 4c 24 cc       	mov    -0x34(%rsp),%r9d
  9e474a:	44 0f b6 54 24 e0    	movzbl -0x20(%rsp),%r10d
  9e4750:	44 89 d9             	mov    %r11d,%ecx
  9e4753:	c1 e9 08             	shr    $0x8,%ecx
  9e4756:	41 80 e2 80          	and    $0x80,%r10b
  9e475a:	41 c0 e6 05          	shl    $0x5,%r14b
  9e475e:	41 f6 c3 5c          	test   $0x5c,%r11b
  9e4762:	0f 95 c2             	setne  %dl
  9e4765:	41 08 ce             	or     %cl,%r14b
  9e4768:	b9 04 00 00 00       	mov    $0x4,%ecx
  9e476d:	c0 e2 04             	shl    $0x4,%dl
  9e4770:	44 08 d2             	or     %r10b,%dl
  9e4773:	41 08 d6             	or     %dl,%r14b
  9e4776:	ba 03 00 00 00       	mov    $0x3,%edx
  9e477b:	01 c2                	add    %eax,%edx
  9e477d:	44 8d 7c 08 01       	lea    0x1(%rax,%rcx,1),%r15d
  9e4782:	44 88 34 16          	mov    %r14b,(%rsi,%rdx,1)
  9e4786:	8d 14 08             	lea    (%rax,%rcx,1),%edx
  9e4789:	44 88 0c 16          	mov    %r9b,(%rsi,%rdx,1)
  9e478d:	80 7c 24 d7 00       	cmpb   $0x0,-0x29(%rsp)
  9e4792:	0f 84 93 00 00 00    	je     9e482b <encode_one+0x86b>
  9e4798:	0f b6 4c 24 ca       	movzbl -0x36(%rsp),%ecx
  9e479d:	0f b6 44 24 f0       	movzbl -0x10(%rsp),%eax
  9e47a2:	8b 5c 24 d8          	mov    -0x28(%rsp),%ebx
  9e47a6:	f6 c1 08             	test   $0x8,%cl
  9e47a9:	44 0f b6 c9          	movzbl %cl,%r9d
  9e47ad:	8b 4f 04             	mov    0x4(%rdi),%ecx
  9e47b0:	44 0f 44 c8          	cmove  %eax,%r9d
  9e47b4:	f6 c3 04             	test   $0x4,%bl
  9e47b7:	74 77                	je     9e4830 <encode_one+0x870>
  9e47b9:	8b 6c 24 dc          	mov    -0x24(%rsp),%ebp
  9e47bd:	f6 c3 20             	test   $0x20,%bl
  9e47c0:	75 7d                	jne    9e483f <encode_one+0x87f>
  9e47c2:	f6 c3 08             	test   $0x8,%bl
  9e47c5:	0f 84 ea 04 00 00    	je     9e4cb5 <encode_one+0xcf5>
  9e47cb:	8b 54 24 ec          	mov    -0x14(%rsp),%edx
  9e47cf:	89 d8                	mov    %ebx,%eax
  9e47d1:	83 e0 10             	and    $0x10,%eax
  9e47d4:	41 ba 04 00 00 00    	mov    $0x4,%r10d
  9e47da:	c1 e8 04             	shr    $0x4,%eax
  9e47dd:	83 e2 07             	and    $0x7,%edx
  9e47e0:	83 fa 04             	cmp    $0x4,%edx
  9e47e3:	41 0f 94 c3          	sete   %r11b
  9e47e7:	85 c0                	test   %eax,%eax
  9e47e9:	44 0f 44 d2          	cmove  %edx,%r10d
  9e47ed:	41 08 c3             	or     %al,%r11b
  9e47f0:	85 c9                	test   %ecx,%ecx
  9e47f2:	0f 85 16 08 00 00    	jne    9e500e <encode_one+0x104e>
  9e47f8:	83 fa 05             	cmp    $0x5,%edx
  9e47fb:	0f 84 0d 08 00 00    	je     9e500e <encode_one+0x104e>
  9e4801:	41 c0 e1 03          	shl    $0x3,%r9b
  9e4805:	44 89 f8             	mov    %r15d,%eax
  9e4808:	b9 00 00 00 00       	mov    $0x0,%ecx
  9e480d:	31 d2                	xor    %edx,%edx
  9e480f:	41 80 e1 38          	and    $0x38,%r9b
  9e4813:	45 08 ca             	or     %r9b,%r10b
  9e4816:	44 88 14 06          	mov    %r10b,(%rsi,%rax,1)
  9e481a:	41 8d 47 01          	lea    0x1(%r15),%eax
  9e481e:	41 89 c2             	mov    %eax,%r10d
  9e4821:	45 84 db             	test   %r11b,%r11b
  9e4824:	74 72                	je     9e4898 <encode_one+0x8d8>
  9e4826:	e9 a6 04 00 00       	jmp    9e4cd1 <encode_one+0xd11>
  9e482b:	45 89 fa             	mov    %r15d,%r10d
  9e482e:	eb 68                	jmp    9e4898 <encode_one+0x8d8>
  9e4830:	44 8b 54 24 dc       	mov    -0x24(%rsp),%r10d
  9e4835:	b0 c0                	mov    $0xc0,%al
  9e4837:	31 d2                	xor    %edx,%edx
  9e4839:	41 80 e2 07          	and    $0x7,%r10b
  9e483d:	eb 0a                	jmp    9e4849 <encode_one+0x889>
  9e483f:	41 b2 05             	mov    $0x5,%r10b
  9e4842:	ba 04 00 00 00       	mov    $0x4,%edx
  9e4847:	31 c0                	xor    %eax,%eax
  9e4849:	41 c0 e1 03          	shl    $0x3,%r9b
  9e484d:	41 80 e1 38          	and    $0x38,%r9b
  9e4851:	45 08 d1             	or     %r10b,%r9b
  9e4854:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  9e485a:	41 08 c1             	or     %al,%r9b
  9e485d:	44 89 f8             	mov    %r15d,%eax
  9e4860:	45 01 d7             	add    %r10d,%r15d
  9e4863:	89 c0                	mov    %eax,%eax
  9e4865:	44 88 0c 06          	mov    %r9b,(%rsi,%rax,1)
  9e4869:	44 89 f8             	mov    %r15d,%eax
  9e486c:	45 89 fa             	mov    %r15d,%r10d
  9e486f:	85 d2                	test   %edx,%edx
  9e4871:	74 25                	je     9e4898 <encode_one+0x8d8>
  9e4873:	c1 e2 03             	shl    $0x3,%edx
  9e4876:	45 31 c9             	xor    %r9d,%r9d
  9e4879:	41 89 c2             	mov    %eax,%r10d
  9e487c:	0f 1f 40 00          	nopl   0x0(%rax)
  9e4880:	c4 e2 33 f7 c1       	shrx   %r9d,%ecx,%eax
  9e4885:	45 89 d3             	mov    %r10d,%r11d
  9e4888:	41 ff c2             	inc    %r10d
  9e488b:	41 83 c1 08          	add    $0x8,%r9d
  9e488f:	42 88 04 1e          	mov    %al,(%rsi,%r11,1)
  9e4893:	44 39 ca             	cmp    %r9d,%edx
  9e4896:	75 e8                	jne    9e4880 <encode_one+0x8c0>
  9e4898:	41 0f b6 40 13       	movzbl 0x13(%r8),%eax
  9e489d:	85 c0                	test   %eax,%eax
  9e489f:	0f 84 88 00 00 00    	je     9e492d <encode_one+0x96d>
  9e48a5:	48 8d 57 04          	lea    0x4(%rdi),%rdx
  9e48a9:	45 31 c9             	xor    %r9d,%r9d
  9e48ac:	3c 08                	cmp    $0x8,%al
  9e48ae:	72 30                	jb     9e48e0 <encode_one+0x920>
  9e48b0:	89 c1                	mov    %eax,%ecx
  9e48b2:	f7 d9                	neg    %ecx
  9e48b4:	41 39 ca             	cmp    %ecx,%r10d
  9e48b7:	77 27                	ja     9e48e0 <encode_one+0x920>
  9e48b9:	45 89 d3             	mov    %r10d,%r11d
  9e48bc:	4a 8d 0c 1e          	lea    (%rsi,%r11,1),%rcx
  9e48c0:	8d 58 ff             	lea    -0x1(%rax),%ebx
  9e48c3:	4c 8d 77 08          	lea    0x8(%rdi),%r14
  9e48c7:	48 8d 5c 0b 01       	lea    0x1(%rbx,%rcx,1),%rbx
  9e48cc:	48 39 da             	cmp    %rbx,%rdx
  9e48cf:	0f 92 c3             	setb   %bl
  9e48d2:	4c 39 f1             	cmp    %r14,%rcx
  9e48d5:	0f 92 c1             	setb   %cl
  9e48d8:	84 cb                	test   %cl,%bl
  9e48da:	0f 84 3e 01 00 00    	je     9e4a1e <encode_one+0xa5e>
  9e48e0:	44 89 d1             	mov    %r10d,%ecx
  9e48e3:	41 89 c2             	mov    %eax,%r10d
  9e48e6:	41 83 e2 07          	and    $0x7,%r10d
  9e48ea:	74 59                	je     9e4945 <encode_one+0x985>
  9e48ec:	46 8d 1c cd 00 00 00 00 	lea    0x0(,%r9,8),%r11d
  9e48f4:	41 f7 da             	neg    %r10d
  9e48f7:	31 db                	xor    %ebx,%ebx
  9e48f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  9e4900:	c4 e2 23 f7 2a       	shrx   %r11d,(%rdx),%ebp
  9e4905:	41 89 ce             	mov    %ecx,%r14d
  9e4908:	ff c1                	inc    %ecx
  9e490a:	ff cb                	dec    %ebx
  9e490c:	41 83 c3 08          	add    $0x8,%r11d
  9e4910:	42 88 2c 36          	mov    %bpl,(%rsi,%r14,1)
  9e4914:	41 39 da             	cmp    %ebx,%r10d
  9e4917:	75 e7                	jne    9e4900 <encode_one+0x940>
  9e4919:	45 89 ca             	mov    %r9d,%r10d
  9e491c:	41 29 da             	sub    %ebx,%r10d
  9e491f:	41 29 c1             	sub    %eax,%r9d
  9e4922:	41 83 f9 f8          	cmp    $0xfffffff8,%r9d
  9e4926:	76 2d                	jbe    9e4955 <encode_one+0x995>
  9e4928:	e9 8e 01 00 00       	jmp    9e4abb <encode_one+0xafb>
  9e492d:	44 89 d1             	mov    %r10d,%ecx
  9e4930:	41 0f b6 50 12       	movzbl 0x12(%r8),%edx
  9e4935:	48 85 d2             	test   %rdx,%rdx
  9e4938:	0f 85 8b 01 00 00    	jne    9e4ac9 <encode_one+0xb09>
  9e493e:	89 c8                	mov    %ecx,%eax
  9e4940:	e9 ca 02 00 00       	jmp    9e4c0f <encode_one+0xc4f>
  9e4945:	45 89 ca             	mov    %r9d,%r10d
  9e4948:	41 29 c1             	sub    %eax,%r9d
  9e494b:	41 83 f9 f8          	cmp    $0xfffffff8,%r9d
  9e494f:	0f 87 66 01 00 00    	ja     9e4abb <encode_one+0xafb>
  9e4955:	46 8d 0c d5 38 00 00 00 	lea    0x38(,%r10,8),%r9d
  9e495d:	44 29 d0             	sub    %r10d,%eax
  9e4960:	45 31 d2             	xor    %r10d,%r10d
  9e4963:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  9e4970:	41 8d 59 c8          	lea    -0x38(%r9),%ebx
  9e4974:	46 8d 1c 11          	lea    (%rcx,%r10,1),%r11d
  9e4978:	46 8d 74 11 01       	lea    0x1(%rcx,%r10,1),%r14d
  9e497d:	c4 e2 63 f7 1a       	shrx   %ebx,(%rdx),%ebx
  9e4982:	42 88 1c 1e          	mov    %bl,(%rsi,%r11,1)
  9e4986:	45 8d 59 d0          	lea    -0x30(%r9),%r11d
  9e498a:	42 8d 5c 11 02       	lea    0x2(%rcx,%r10,1),%ebx
  9e498f:	c4 62 23 f7 1a       	shrx   %r11d,(%rdx),%r11d
  9e4994:	46 88 1c 36          	mov    %r11b,(%rsi,%r14,1)
  9e4998:	45 8d 59 d8          	lea    -0x28(%r9),%r11d
  9e499c:	46 8d 74 11 03       	lea    0x3(%rcx,%r10,1),%r14d
  9e49a1:	c4 62 23 f7 1a       	shrx   %r11d,(%rdx),%r11d
  9e49a6:	44 88 1c 1e          	mov    %r11b,(%rsi,%rbx,1)
  9e49aa:	41 8d 59 e8          	lea    -0x18(%r9),%ebx
  9e49ae:	c4 62 33 f7 1a       	shrx   %r9d,(%rdx),%r11d
  9e49b3:	46 88 1c 36          	mov    %r11b,(%rsi,%r14,1)
  9e49b7:	46 8d 5c 11 04       	lea    0x4(%rcx,%r10,1),%r11d
  9e49bc:	c4 e2 63 f7 1a       	shrx   %ebx,(%rdx),%ebx
  9e49c1:	42 88 1c 1e          	mov    %bl,(%rsi,%r11,1)
  9e49c5:	41 8d 59 f0          	lea    -0x10(%r9),%ebx
  9e49c9:	46 8d 5c 11 05       	lea    0x5(%rcx,%r10,1),%r11d
  9e49ce:	c4 e2 63 f7 1a       	shrx   %ebx,(%rdx),%ebx
  9e49d3:	42 88 1c 1e          	mov    %bl,(%rsi,%r11,1)
  9e49d7:	41 8d 59 f8          	lea    -0x8(%r9),%ebx
  9e49db:	46 8d 5c 11 06       	lea    0x6(%rcx,%r10,1),%r11d
  9e49e0:	c4 e2 63 f7 1a       	shrx   %ebx,(%rdx),%ebx
  9e49e5:	42 88 1c 1e          	mov    %bl,(%rsi,%r11,1)
  9e49e9:	46 8d 5c 11 07       	lea    0x7(%rcx,%r10,1),%r11d
  9e49ee:	41 83 c2 08          	add    $0x8,%r10d
  9e49f2:	c4 e2 33 f7 1a       	shrx   %r9d,(%rdx),%ebx
  9e49f7:	41 83 c1 40          	add    $0x40,%r9d
  9e49fb:	42 88 1c 1e          	mov    %bl,(%rsi,%r11,1)
  9e49ff:	44 39 d0             	cmp    %r10d,%eax
  9e4a02:	0f 85 68 ff ff ff    	jne    9e4970 <encode_one+0x9b0>
  9e4a08:	44 01 d1             	add    %r10d,%ecx
  9e4a0b:	41 0f b6 50 12       	movzbl 0x12(%r8),%edx
  9e4a10:	48 85 d2             	test   %rdx,%rdx
  9e4a13:	0f 85 b0 00 00 00    	jne    9e4ac9 <encode_one+0xb09>
  9e4a19:	e9 20 ff ff ff       	jmp    9e493e <encode_one+0x97e>
  9e4a1e:	45 31 c9             	xor    %r9d,%r9d
  9e4a21:	3c 40                	cmp    $0x40,%al
  9e4a23:	72 2f                	jb     9e4a54 <encode_one+0xa94>
  9e4a25:	62 f2 7d 48 58 02    	vpbroadcastd (%rdx),%zmm0
  9e4a2b:	41 89 c1             	mov    %eax,%r9d
  9e4a2e:	41 83 e1 c0          	and    $0xffffffc0,%r9d
  9e4a32:	62 f2 7d 48 45 05 c4 bb ab ff 	vpsrlvd -0x54443c(%rip),%zmm0,%zmm0        # 4a0600 <check_builtin_atomic_rmw_test_clang.native_source+0x3100>
  9e4a3c:	43 8d 0c 0a          	lea    (%r10,%r9,1),%ecx
  9e4a40:	62 b2 7e 48 31 04 1e 	vpmovdb %zmm0,(%rsi,%r11,1)
  9e4a47:	41 39 c1             	cmp    %eax,%r9d
  9e4a4a:	74 6f                	je     9e4abb <encode_one+0xafb>
  9e4a4c:	a8 38                	test   $0x38,%al
  9e4a4e:	0f 84 8f fe ff ff    	je     9e48e3 <encode_one+0x923>
  9e4a54:	45 89 cb             	mov    %r9d,%r11d
  9e4a57:	62 d2 7d 28 7c cb    	vpbroadcastd %r11d,%ymm1
  9e4a5d:	c4 e2 7d 58 02       	vpbroadcastd (%rdx),%ymm0
  9e4a62:	c5 f5 eb 0d d6 77 b6 ff 	vpor   -0x49882a(%rip),%ymm1,%ymm1        # 54c240 <tier0_jcc_rel8+0x7a0>
  9e4a6a:	c4 e2 7d 58 15 a1 87 b9 ff 	vpbroadcastd -0x46785f(%rip),%ymm2        # 57d214 <tier0_test_int128_integers+0x18c>
  9e4a73:	41 89 c1             	mov    %eax,%r9d
  9e4a76:	41 83 e1 f8          	and    $0xfffffff8,%r9d
  9e4a7a:	43 8d 0c 0a          	lea    (%r10,%r9,1),%ecx
  9e4a7e:	45 01 da             	add    %r11d,%r10d
  9e4a81:	45 29 cb             	sub    %r9d,%r11d
  9e4a84:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  9e4a90:	c5 e5 72 f1 03       	vpslld $0x3,%ymm1,%ymm3
  9e4a95:	44 89 d3             	mov    %r10d,%ebx
  9e4a98:	41 83 c2 08          	add    $0x8,%r10d
  9e4a9c:	c5 f5 fe ca          	vpaddd %ymm2,%ymm1,%ymm1
  9e4aa0:	41 83 c3 08          	add    $0x8,%r11d
  9e4aa4:	c4 e2 7d 45 db       	vpsrlvd %ymm3,%ymm0,%ymm3
  9e4aa9:	62 f2 7e 28 31 1c 1e 	vpmovdb %ymm3,(%rsi,%rbx,1)
  9e4ab0:	75 de                	jne    9e4a90 <encode_one+0xad0>
  9e4ab2:	41 39 c1             	cmp    %eax,%r9d
  9e4ab5:	0f 85 28 fe ff ff    	jne    9e48e3 <encode_one+0x923>
  9e4abb:	41 0f b6 50 12       	movzbl 0x12(%r8),%edx
  9e4ac0:	48 85 d2             	test   %rdx,%rdx
  9e4ac3:	0f 84 75 fe ff ff    	je     9e493e <encode_one+0x97e>
  9e4ac9:	48 8b 3f             	mov    (%rdi),%rdi
  9e4acc:	80 fa 08             	cmp    $0x8,%dl
  9e4acf:	73 4c                	jae    9e4b1d <encode_one+0xb5d>
  9e4ad1:	45 31 c0             	xor    %r8d,%r8d
  9e4ad4:	89 c8                	mov    %ecx,%eax
  9e4ad6:	48 89 d1             	mov    %rdx,%rcx
  9e4ad9:	48 83 e1 07          	and    $0x7,%rcx
  9e4add:	74 6a                	je     9e4b49 <encode_one+0xb89>
  9e4adf:	46 8d 0c c5 00 00 00 00 	lea    0x0(,%r8,8),%r9d
  9e4ae7:	48 f7 d9             	neg    %rcx
  9e4aea:	45 31 d2             	xor    %r10d,%r10d
  9e4aed:	0f 1f 00             	nopl   (%rax)
  9e4af0:	c4 62 b3 f7 df       	shrx   %r9,%rdi,%r11
  9e4af5:	89 c3                	mov    %eax,%ebx
  9e4af7:	ff c0                	inc    %eax
  9e4af9:	49 ff ca             	dec    %r10
  9e4afc:	49 83 c1 08          	add    $0x8,%r9
  9e4b00:	44 88 1c 1e          	mov    %r11b,(%rsi,%rbx,1)
  9e4b04:	4c 39 d1             	cmp    %r10,%rcx
  9e4b07:	75 e7                	jne    9e4af0 <encode_one+0xb30>
  9e4b09:	4d 89 c1             	mov    %r8,%r9
  9e4b0c:	4d 29 d1             	sub    %r10,%r9
  9e4b0f:	41 29 d0             	sub    %edx,%r8d
  9e4b12:	41 83 f8 f8          	cmp    $0xfffffff8,%r8d
  9e4b16:	76 41                	jbe    9e4b59 <encode_one+0xb99>
  9e4b18:	e9 f2 00 00 00       	jmp    9e4c0f <encode_one+0xc4f>
  9e4b1d:	48 8d 42 ff          	lea    -0x1(%rdx),%rax
  9e4b21:	45 31 c0             	xor    %r8d,%r8d
  9e4b24:	41 89 c9             	mov    %ecx,%r9d
  9e4b27:	41 01 c1             	add    %eax,%r9d
  9e4b2a:	72 a8                	jb     9e4ad4 <encode_one+0xb14>
  9e4b2c:	48 c1 e8 20          	shr    $0x20,%rax
  9e4b30:	75 a2                	jne    9e4ad4 <encode_one+0xb14>
  9e4b32:	62 f2 fd 48 7c c7    	vpbroadcastq %rdi,%zmm0
  9e4b38:	80 fa 40             	cmp    $0x40,%dl
  9e4b3b:	0f 83 dc 00 00 00    	jae    9e4c1d <encode_one+0xc5d>
  9e4b41:	45 31 c0             	xor    %r8d,%r8d
  9e4b44:	e9 06 01 00 00       	jmp    9e4c4f <encode_one+0xc8f>
  9e4b49:	4d 89 c1             	mov    %r8,%r9
  9e4b4c:	41 29 d0             	sub    %edx,%r8d
  9e4b4f:	41 83 f8 f8          	cmp    $0xfffffff8,%r8d
  9e4b53:	0f 87 b6 00 00 00    	ja     9e4c0f <encode_one+0xc4f>
  9e4b59:	4a 8d 0c cd 38 00 00 00 	lea    0x38(,%r9,8),%rcx
  9e4b61:	4c 29 ca             	sub    %r9,%rdx
  9e4b64:	41 89 c1             	mov    %eax,%r9d
  9e4b67:	45 31 c0             	xor    %r8d,%r8d
  9e4b6a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  9e4b70:	44 8d 59 c8          	lea    -0x38(%rcx),%r11d
  9e4b74:	47 8d 14 01          	lea    (%r9,%r8,1),%r10d
  9e4b78:	43 8d 5c 01 01       	lea    0x1(%r9,%r8,1),%ebx
  9e4b7d:	c4 62 a3 f7 df       	shrx   %r11,%rdi,%r11
  9e4b82:	46 88 1c 16          	mov    %r11b,(%rsi,%r10,1)
  9e4b86:	44 8d 51 d0          	lea    -0x30(%rcx),%r10d
  9e4b8a:	44 8d 59 d8          	lea    -0x28(%rcx),%r11d
  9e4b8e:	c4 62 ab f7 d7       	shrx   %r10,%rdi,%r10
  9e4b93:	c4 62 a3 f7 df       	shrx   %r11,%rdi,%r11
  9e4b98:	44 88 14 1e          	mov    %r10b,(%rsi,%rbx,1)
  9e4b9c:	47 8d 54 01 02       	lea    0x2(%r9,%r8,1),%r10d
  9e4ba1:	43 8d 5c 01 07       	lea    0x7(%r9,%r8,1),%ebx
  9e4ba6:	46 88 1c 16          	mov    %r11b,(%rsi,%r10,1)
  9e4baa:	44 8d 59 e0          	lea    -0x20(%rcx),%r11d
  9e4bae:	47 8d 54 01 03       	lea    0x3(%r9,%r8,1),%r10d
  9e4bb3:	c4 62 a3 f7 df       	shrx   %r11,%rdi,%r11
  9e4bb8:	46 88 1c 16          	mov    %r11b,(%rsi,%r10,1)
  9e4bbc:	44 8d 59 e8          	lea    -0x18(%rcx),%r11d
  9e4bc0:	47 8d 54 01 04       	lea    0x4(%r9,%r8,1),%r10d
  9e4bc5:	c4 62 a3 f7 df       	shrx   %r11,%rdi,%r11
  9e4bca:	46 88 1c 16          	mov    %r11b,(%rsi,%r10,1)
  9e4bce:	44 8d 59 f0          	lea    -0x10(%rcx),%r11d
  9e4bd2:	47 8d 54 01 05       	lea    0x5(%r9,%r8,1),%r10d
  9e4bd7:	c4 62 a3 f7 df       	shrx   %r11,%rdi,%r11
  9e4bdc:	46 88 1c 16          	mov    %r11b,(%rsi,%r10,1)
  9e4be0:	44 8d 59 f8          	lea    -0x8(%rcx),%r11d
  9e4be4:	47 8d 54 01 06       	lea    0x6(%r9,%r8,1),%r10d
  9e4be9:	49 83 c0 08          	add    $0x8,%r8
  9e4bed:	c4 62 a3 f7 df       	shrx   %r11,%rdi,%r11
  9e4bf2:	46 88 1c 16          	mov    %r11b,(%rsi,%r10,1)
  9e4bf6:	c4 62 f3 f7 d7       	shrx   %rcx,%rdi,%r10
  9e4bfb:	48 83 c1 40          	add    $0x40,%rcx
  9e4bff:	44 88 14 1e          	mov    %r10b,(%rsi,%rbx,1)
  9e4c03:	4c 39 c2             	cmp    %r8,%rdx
  9e4c06:	0f 85 64 ff ff ff    	jne    9e4b70 <encode_one+0xbb0>
  9e4c0c:	44 01 c0             	add    %r8d,%eax
  9e4c0f:	5b                   	pop    %rbx
  9e4c10:	41 5c                	pop    %r12
  9e4c12:	41 5d                	pop    %r13
  9e4c14:	41 5e                	pop    %r14
  9e4c16:	41 5f                	pop    %r15
  9e4c18:	5d                   	pop    %rbp
  9e4c19:	c5 f8 77             	vzeroupper
  9e4c1c:	c3                   	ret
  9e4c1d:	62 f2 fd 48 45 0d 19 ba ab ff 	vpsrlvq -0x5445e7(%rip),%zmm0,%zmm1        # 4a0640 <check_builtin_atomic_rmw_test_clang.native_source+0x3140>
  9e4c27:	41 89 d0             	mov    %edx,%r8d
  9e4c2a:	41 83 e0 c0          	and    $0xffffffc0,%r8d
  9e4c2e:	41 89 c9             	mov    %ecx,%r9d
  9e4c31:	42 8d 04 01          	lea    (%rcx,%r8,1),%eax
  9e4c35:	62 f2 7e 48 32 c9    	vpmovqb %zmm1,%xmm1
  9e4c3b:	c4 a1 7a 7f 0c 0e    	vmovdqu %xmm1,(%rsi,%r9,1)
  9e4c41:	49 39 d0             	cmp    %rdx,%r8
  9e4c44:	74 c9                	je     9e4c0f <encode_one+0xc4f>
  9e4c46:	f6 c2 38             	test   $0x38,%dl
  9e4c49:	0f 84 87 fe ff ff    	je     9e4ad6 <encode_one+0xb16>
  9e4c4f:	4d 89 c1             	mov    %r8,%r9
  9e4c52:	62 d2 fd 48 7c c9    	vpbroadcastq %r9,%zmm1
  9e4c58:	62 f1 f5 48 eb 0d 1e ba ab ff 	vporq  -0x5445e2(%rip),%zmm1,%zmm1        # 4a0680 <check_builtin_atomic_rmw_test_clang.native_source+0x3180>
  9e4c62:	62 f2 fd 48 59 15 cc 79 b9 ff 	vpbroadcastq -0x468634(%rip),%zmm2        # 57c638 <check_mutation_families+0x500>
  9e4c6c:	41 89 d0             	mov    %edx,%r8d
  9e4c6f:	41 83 e0 f8          	and    $0xfffffff8,%r8d
  9e4c73:	4d 89 ca             	mov    %r9,%r10
  9e4c76:	41 01 c9             	add    %ecx,%r9d
  9e4c79:	42 8d 04 01          	lea    (%rcx,%r8,1),%eax
  9e4c7d:	4d 29 c2             	sub    %r8,%r10
  9e4c80:	62 f1 e5 48 73 f1 03 	vpsllq $0x3,%zmm1,%zmm3
  9e4c87:	44 89 c9             	mov    %r9d,%ecx
  9e4c8a:	41 83 c1 08          	add    $0x8,%r9d
  9e4c8e:	62 f1 f5 48 d4 ca    	vpaddq %zmm2,%zmm1,%zmm1
  9e4c94:	49 83 c2 08          	add    $0x8,%r10
  9e4c98:	62 f2 fd 48 45 db    	vpsrlvq %zmm3,%zmm0,%zmm3
  9e4c9e:	62 f2 7e 48 32 1c 0e 	vpmovqb %zmm3,(%rsi,%rcx,1)
  9e4ca5:	75 d9                	jne    9e4c80 <encode_one+0xcc0>
  9e4ca7:	41 39 d0             	cmp    %edx,%r8d
  9e4caa:	0f 85 26 fe ff ff    	jne    9e4ad6 <encode_one+0xb16>
  9e4cb0:	e9 5a ff ff ff       	jmp    9e4c0f <encode_one+0xc4f>
  9e4cb5:	41 c0 e1 03          	shl    $0x3,%r9b
  9e4cb9:	44 89 f8             	mov    %r15d,%eax
  9e4cbc:	ba 04 00 00 00       	mov    $0x4,%edx
  9e4cc1:	41 80 e1 38          	and    $0x38,%r9b
  9e4cc5:	41 80 c9 04          	or     $0x4,%r9b
  9e4cc9:	44 88 0c 06          	mov    %r9b,(%rsi,%rax,1)
  9e4ccd:	41 8d 47 01          	lea    0x1(%r15),%eax
  9e4cd1:	44 0f b6 54 24 cb    	movzbl -0x35(%rsp),%r10d
  9e4cd7:	41 89 d9             	mov    %ebx,%r9d
  9e4cda:	40 80 e5 07          	and    $0x7,%bpl
  9e4cde:	41 bb 20 00 00 00    	mov    $0x20,%r11d
  9e4ce4:	41 c0 e1 06          	shl    $0x6,%r9b
  9e4ce8:	41 c0 e2 03          	shl    $0x3,%r10b
  9e4cec:	41 80 e2 38          	and    $0x38,%r10b
  9e4cf0:	f6 c3 10             	test   $0x10,%bl
  9e4cf3:	45 0f b6 d2          	movzbl %r10b,%r10d
  9e4cf7:	45 0f 45 da          	cmovne %r10d,%r11d
  9e4cfb:	44 0f b6 d5          	movzbl %bpl,%r10d
  9e4cff:	45 08 cb             	or     %r9b,%r11b
  9e4d02:	f6 c3 08             	test   $0x8,%bl
  9e4d05:	41 b9 05 00 00 00    	mov    $0x5,%r9d
  9e4d0b:	45 0f 45 ca          	cmovne %r10d,%r9d
  9e4d0f:	41 ba 02 00 00 00    	mov    $0x2,%r10d
  9e4d15:	45 08 d9             	or     %r11b,%r9b
  9e4d18:	e9 43 fb ff ff       	jmp    9e4860 <encode_one+0x8a0>
  9e4d1d:	8b 4c 24 cc          	mov    -0x34(%rsp),%ecx
  9e4d21:	bb 00 00 00 00       	mov    $0x0,%ebx
  9e4d26:	41 89 e9             	mov    %ebp,%r9d
  9e4d29:	44 89 54 24 d0       	mov    %r10d,-0x30(%rsp)
  9e4d2e:	83 f9 40             	cmp    $0x40,%ecx
  9e4d31:	0f 82 ff 01 00 00    	jb     9e4f36 <encode_one+0xf76>
  9e4d37:	62 f2 7d 48 7c fd    	vpbroadcastd %ebp,%zmm7
  9e4d3d:	62 f1 45 48 fe 25 b9 b7 ab ff 	vpaddd -0x544847(%rip),%zmm7,%zmm4        # 4a0500 <check_builtin_atomic_rmw_test_clang.native_source+0x3000>
  9e4d47:	62 f1 45 48 fe 2d ef b7 ab ff 	vpaddd -0x544811(%rip),%zmm7,%zmm5        # 4a0540 <check_builtin_atomic_rmw_test_clang.native_source+0x3040>
  9e4d51:	62 f1 45 48 fe 35 25 b8 ab ff 	vpaddd -0x5447db(%rip),%zmm7,%zmm6        # 4a0580 <check_builtin_atomic_rmw_test_clang.native_source+0x3080>
  9e4d5b:	62 f1 45 48 fe 3d 5b b8 ab ff 	vpaddd -0x5447a5(%rip),%zmm7,%zmm7        # 4a05c0 <check_builtin_atomic_rmw_test_clang.native_source+0x30c0>
  9e4d65:	62 72 7d 48 58 0d a1 84 b9 ff 	vpbroadcastd -0x467b5f(%rip),%zmm9        # 57d210 <tier0_test_int128_integers+0x188>
  9e4d6f:	89 cb                	mov    %ecx,%ebx
  9e4d71:	83 e3 c0             	and    $0xffffffc0,%ebx
  9e4d74:	31 c9                	xor    %ecx,%ecx
  9e4d76:	80 7c 24 ca 02       	cmpb   $0x2,-0x36(%rsp)
  9e4d7b:	49 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%r10
  9e4d82:	62 d2 7d 48 7a c5    	vpbroadcastb %r13d,%zmm0
  9e4d88:	62 d2 7d 48 7c ce    	vpbroadcastd %r14d,%zmm1
  9e4d8e:	62 d2 7d 48 7c d4    	vpbroadcastd %r12d,%zmm2
  9e4d94:	62 f2 7d 48 7c da    	vpbroadcastd %edx,%zmm3
  9e4d9a:	62 53 3d 48 25 c0 ff 	vpternlogd $0xff,%zmm8,%zmm8,%zmm8
  9e4da1:	44 89 6c 24 e0       	mov    %r13d,-0x20(%rsp)
  9e4da6:	44 8d 3c 18          	lea    (%rax,%rbx,1),%r15d
  9e4daa:	44 8d 4c 1d 00       	lea    0x0(%rbp,%rbx,1),%r9d
  9e4daf:	4c 0f 45 d1          	cmovne %rcx,%r10
  9e4db3:	89 c1                	mov    %eax,%ecx
  9e4db5:	c4 c1 fb 92 c2       	kmovq  %r10,%k0
  9e4dba:	41 89 da             	mov    %ebx,%r10d
  9e4dbd:	0f 1f 00             	nopl   (%rax)
  9e4dc0:	62 71 fd 48 6f d7    	vmovdqa64 %zmm7,%zmm10
  9e4dc6:	62 73 c5 48 25 d7 0f 	vpternlogq $0xf,%zmm7,%zmm7,%zmm10
  9e4dcd:	62 71 fd 48 6f de    	vmovdqa64 %zmm6,%zmm11
  9e4dd3:	62 73 cd 48 25 de 0f 	vpternlogq $0xf,%zmm6,%zmm6,%zmm11
  9e4dda:	62 71 fd 48 6f e5    	vmovdqa64 %zmm5,%zmm12
  9e4de0:	62 73 d5 48 25 e5 0f 	vpternlogq $0xf,%zmm5,%zmm5,%zmm12
  9e4de7:	62 71 fd 48 6f ec    	vmovdqa64 %zmm4,%zmm13
  9e4ded:	62 73 dd 48 25 ec 0f 	vpternlogq $0xf,%zmm4,%zmm4,%zmm13
  9e4df4:	62 f3 45 48 1e c9 01 	vpcmpltud %zmm1,%zmm7,%k1
  9e4dfb:	62 f3 4d 48 1e d1 01 	vpcmpltud %zmm1,%zmm6,%k2
  9e4e02:	62 f3 5d 48 1e d9 01 	vpcmpltud %zmm1,%zmm4,%k3
  9e4e09:	62 51 45 48 fa f0    	vpsubd %zmm8,%zmm7,%zmm14
  9e4e0f:	41 89 cd             	mov    %ecx,%r13d
  9e4e12:	83 c1 40             	add    $0x40,%ecx
  9e4e15:	62 d1 45 48 fe f9    	vpaddd %zmm9,%zmm7,%zmm7
  9e4e1b:	41 83 c2 c0          	add    $0xffffffc0,%r10d
  9e4e1f:	62 51 75 48 fe db    	vpaddd %zmm11,%zmm1,%zmm11
  9e4e25:	62 51 75 48 fe d2    	vpaddd %zmm10,%zmm1,%zmm10
  9e4e2b:	62 51 75 48 fe ed    	vpaddd %zmm13,%zmm1,%zmm13
  9e4e31:	62 51 75 48 fe e4    	vpaddd %zmm12,%zmm1,%zmm12
  9e4e37:	c5 ec 4b c9          	kunpckwd %k1,%k2,%k1
  9e4e3b:	62 f3 55 48 1e d1 01 	vpcmpltud %zmm1,%zmm5,%k2
  9e4e42:	62 d1 2d 48 72 f2 03 	vpslld $0x3,%zmm10,%zmm10
  9e4e49:	62 d1 25 48 72 f3 03 	vpslld $0x3,%zmm11,%zmm11
  9e4e50:	62 d1 1d 48 72 f4 03 	vpslld $0x3,%zmm12,%zmm12
  9e4e57:	62 d1 15 48 72 f5 03 	vpslld $0x3,%zmm13,%zmm13
  9e4e5e:	c5 e4 4b d2          	kunpckwd %k2,%k3,%k2
  9e4e62:	62 52 6d 48 45 db    	vpsrlvd %zmm11,%zmm2,%zmm11
  9e4e68:	62 52 6d 48 45 d2    	vpsrlvd %zmm10,%zmm2,%zmm10
  9e4e6e:	62 52 6d 48 45 ed    	vpsrlvd %zmm13,%zmm2,%zmm13
  9e4e74:	62 52 6d 48 45 e4    	vpsrlvd %zmm12,%zmm2,%zmm12
  9e4e7a:	c4 e1 ec 4b c9       	kunpckdq %k1,%k2,%k1
  9e4e7f:	62 52 7e 48 31 d2    	vpmovdb %zmm10,%xmm10
  9e4e85:	62 52 7e 48 31 db    	vpmovdb %zmm11,%xmm11
  9e4e8b:	62 52 7e 48 31 ed    	vpmovdb %zmm13,%xmm13
  9e4e91:	c4 43 2d 38 d3 01    	vinserti128 $0x1,%xmm11,%ymm10,%ymm10
  9e4e97:	62 52 7e 48 31 e3    	vpmovdb %zmm12,%xmm11
  9e4e9d:	62 51 55 48 fa e0    	vpsubd %zmm8,%zmm5,%zmm12
  9e4ea3:	62 d1 55 48 fe e9    	vpaddd %zmm9,%zmm5,%zmm5
  9e4ea9:	c4 43 25 38 dd 01    	vinserti128 $0x1,%xmm13,%ymm11,%ymm11
  9e4eaf:	62 51 4d 48 fa e8    	vpsubd %zmm8,%zmm6,%zmm13
  9e4eb5:	62 d1 4d 48 fe f1    	vpaddd %zmm9,%zmm6,%zmm6
  9e4ebb:	62 53 ad 48 3a d3 01 	vinserti64x4 $0x1,%ymm11,%zmm10,%zmm10
  9e4ec2:	62 51 5d 48 fa d8    	vpsubd %zmm8,%zmm4,%zmm11
  9e4ec8:	62 f1 15 48 76 d3    	vpcmpeqd %zmm3,%zmm13,%k2
  9e4ece:	62 d1 5d 48 fe e1    	vpaddd %zmm9,%zmm4,%zmm4
  9e4ed4:	62 51 7f c9 6f d2    	vmovdqu8 %zmm10,%zmm10{%k1}{z}
  9e4eda:	62 f1 0d 48 76 cb    	vpcmpeqd %zmm3,%zmm14,%k1
  9e4ee0:	62 f1 25 48 76 db    	vpcmpeqd %zmm3,%zmm11,%k3
  9e4ee6:	62 71 ad 48 eb d8    	vporq  %zmm0,%zmm10,%zmm11
  9e4eec:	c5 ec 4b c9          	kunpckwd %k1,%k2,%k1
  9e4ef0:	62 f1 1d 48 76 d3    	vpcmpeqd %zmm3,%zmm12,%k2
  9e4ef6:	c5 e4 4b d2          	kunpckwd %k2,%k3,%k2
  9e4efa:	c4 e1 ec 4b c9       	kunpckdq %k1,%k2,%k1
  9e4eff:	c4 e1 f4 41 c8       	kandq  %k0,%k1,%k1
  9e4f04:	62 51 7f 49 6f d3    	vmovdqu8 %zmm11,%zmm10{%k1}
  9e4f0a:	62 31 fe 48 7f 14 2e 	vmovdqu64 %zmm10,(%rsi,%r13,1)
  9e4f11:	0f 85 a9 fe ff ff    	jne    9e4dc0 <encode_one+0xe00>
  9e4f17:	8b 4c 24 cc          	mov    -0x34(%rsp),%ecx
  9e4f1b:	39 d9                	cmp    %ebx,%ecx
  9e4f1d:	0f 84 6a f8 ff ff    	je     9e478d <encode_one+0x7cd>
  9e4f23:	44 8b 6c 24 e0       	mov    -0x20(%rsp),%r13d
  9e4f28:	44 8b 54 24 d0       	mov    -0x30(%rsp),%r10d
  9e4f2d:	f6 c1 38             	test   $0x38,%cl
  9e4f30:	0f 84 a2 f4 ff ff    	je     9e43d8 <encode_one+0x418>
  9e4f36:	62 d2 7d 28 7c e1    	vpbroadcastd %r9d,%ymm4
  9e4f3c:	49 89 ea             	mov    %rbp,%r10
  9e4f3f:	89 cd                	mov    %ecx,%ebp
  9e4f41:	83 e5 f8             	and    $0xfffffff8,%ebp
  9e4f44:	c5 dd fe 25 f4 72 b6 ff 	vpaddd -0x498d0c(%rip),%ymm4,%ymm4        # 54c240 <tier0_jcc_rel8+0x7a0>
  9e4f4c:	c4 e2 7d 58 35 bf 82 b9 ff 	vpbroadcastd -0x467d41(%rip),%ymm6        # 57d214 <tier0_test_int128_integers+0x18c>
  9e4f55:	b9 00 00 00 00       	mov    $0x0,%ecx
  9e4f5a:	62 d2 7d 08 7a c5    	vpbroadcastb %r13d,%xmm0
  9e4f60:	62 d2 7d 28 7c ce    	vpbroadcastd %r14d,%ymm1
  9e4f66:	62 d2 7d 28 7c d4    	vpbroadcastd %r12d,%ymm2
  9e4f6c:	62 f2 7d 28 7c da    	vpbroadcastd %edx,%ymm3
  9e4f72:	c5 d5 76 ed          	vpcmpeqd %ymm5,%ymm5,%ymm5
  9e4f76:	41 09 ea             	or     %ebp,%r10d
  9e4f79:	80 7c 24 ca 02       	cmpb   $0x2,-0x36(%rsp)
  9e4f7e:	44 8d 3c 28          	lea    (%rax,%rbp,1),%r15d
  9e4f82:	4c 89 54 24 e0       	mov    %r10,-0x20(%rsp)
  9e4f87:	41 ba ff 00 00 00    	mov    $0xff,%r10d
  9e4f8d:	41 0f 44 ca          	cmove  %r10d,%ecx
  9e4f91:	01 d8                	add    %ebx,%eax
  9e4f93:	29 eb                	sub    %ebp,%ebx
  9e4f95:	c5 fb 92 c9          	kmovd  %ecx,%k1
  9e4f99:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  9e4fa0:	c5 fd 6f fc          	vmovdqa %ymm4,%ymm7
  9e4fa4:	62 f3 dd 28 25 fc 0f 	vpternlogq $0xf,%ymm4,%ymm4,%ymm7
  9e4fab:	62 f3 5d 28 1e d1 01 	vpcmpltud %ymm1,%ymm4,%k2
  9e4fb2:	c5 5d fa c5          	vpsubd %ymm5,%ymm4,%ymm8
  9e4fb6:	41 89 c1             	mov    %eax,%r9d
  9e4fb9:	83 c0 08             	add    $0x8,%eax
  9e4fbc:	c5 dd fe e6          	vpaddd %ymm6,%ymm4,%ymm4
  9e4fc0:	83 c3 08             	add    $0x8,%ebx
  9e4fc3:	c5 f5 fe ff          	vpaddd %ymm7,%ymm1,%ymm7
  9e4fc7:	c5 c5 72 f7 03       	vpslld $0x3,%ymm7,%ymm7
  9e4fcc:	c4 e2 6d 45 ff       	vpsrlvd %ymm7,%ymm2,%ymm7
  9e4fd1:	62 f2 7e 28 31 ff    	vpmovdb %ymm7,%xmm7
  9e4fd7:	62 f1 7f 8a 6f ff    	vmovdqu8 %xmm7,%xmm7{%k2}{z}
  9e4fdd:	62 f1 3d 29 76 d3    	vpcmpeqd %ymm3,%ymm8,%k2{%k1}
  9e4fe3:	c5 41 eb c8          	vpor   %xmm0,%xmm7,%xmm9
  9e4fe7:	62 d1 7f 0a 6f f9    	vmovdqu8 %xmm9,%xmm7{%k2}
  9e4fed:	c4 a1 79 d6 3c 0e    	vmovq  %xmm7,(%rsi,%r9,1)
  9e4ff3:	75 ab                	jne    9e4fa0 <encode_one+0xfe0>
  9e4ff5:	44 8b 54 24 d0       	mov    -0x30(%rsp),%r10d
  9e4ffa:	4c 8b 4c 24 e0       	mov    -0x20(%rsp),%r9
  9e4fff:	39 6c 24 cc          	cmp    %ebp,-0x34(%rsp)
  9e5003:	0f 85 cf f3 ff ff    	jne    9e43d8 <encode_one+0x418>
  9e5009:	e9 7f f7 ff ff       	jmp    9e478d <encode_one+0x7cd>
  9e500e:	41 0f b6 58 22       	movzbl 0x22(%r8),%ebx
  9e5013:	89 c8                	mov    %ecx,%eax
  9e5015:	99                   	cltd
  9e5016:	45 31 f6             	xor    %r14d,%r14d
  9e5019:	f7 fb                	idiv   %ebx
  9e501b:	0f be d8             	movsbl %al,%ebx
  9e501e:	31 c3                	xor    %eax,%ebx
  9e5020:	09 d3                	or     %edx,%ebx
  9e5022:	bb 80 00 00 00       	mov    $0x80,%ebx
  9e5027:	41 0f 95 c6          	setne  %r14b
  9e502b:	0f 44 c8             	cmove  %eax,%ecx
  9e502e:	44 89 f8             	mov    %r15d,%eax
  9e5031:	43 8d 54 76 01       	lea    0x1(%r14,%r14,2),%edx
  9e5036:	41 be 40 00 00 00    	mov    $0x40,%r14d
  9e503c:	41 0f 44 de          	cmove  %r14d,%ebx
  9e5040:	41 c0 e1 03          	shl    $0x3,%r9b
  9e5044:	41 80 e1 38          	and    $0x38,%r9b
  9e5048:	41 08 d9             	or     %bl,%r9b
  9e504b:	8b 5c 24 d8          	mov    -0x28(%rsp),%ebx
  9e504f:	45 08 d1             	or     %r10b,%r9b
  9e5052:	44 88 0c 06          	mov    %r9b,(%rsi,%rax,1)
  9e5056:	41 8d 47 01          	lea    0x1(%r15),%eax
  9e505a:	45 84 db             	test   %r11b,%r11b
  9e505d:	0f 84 10 f8 ff ff    	je     9e4873 <encode_one+0x8b3>
  9e5063:	e9 69 fc ff ff       	jmp    9e4cd1 <encode_one+0xd11>
  9e5068:	66 3d 40 41          	cmp    $0x4140,%ax
  9e506c:	b9 c0 be ff ff       	mov    $0xffffbec0,%ecx
  9e5071:	ba 60 df ff ff       	mov    $0xffffdf60,%edx
  9e5076:	0f 43 d1             	cmovae %ecx,%edx
  9e5079:	b9 01 00 00 00       	mov    $0x1,%ecx
  9e507e:	83 d9 ff             	sbb    $0xffffffff,%ecx
  9e5081:	01 d0                	add    %edx,%eax
  9e5083:	e9 4d ef ff ff       	jmp    9e3fd5 <encode_one+0x15>
