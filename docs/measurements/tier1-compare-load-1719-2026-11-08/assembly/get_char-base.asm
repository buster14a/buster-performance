0000000000004420 <get_char>:
    4420:	48 83 ec 08          	sub    rsp,0x8
    4424:	48 8b 47 08          	mov    rax,QWORD PTR [rdi+0x8]
    4428:	48 3b f0             	cmp    rsi,rax
    442b:	73 14                	jae    4441 <get_char+0x21>
    442d:	48 8b 07             	mov    rax,QWORD PTR [rdi]
    4430:	0f b6 04 30          	movzx  eax,BYTE PTR [rax+rsi*1]
    4434:	83 f8 5c             	cmp    eax,0x5c
    4437:	b8 00 00 00 00       	mov    eax,0x0
    443c:	0f 95 c0             	setne  al
    443f:	eb 02                	jmp    4443 <get_char+0x23>
    4441:	31 c0                	xor    eax,eax
    4443:	85 c0                	test   eax,eax
    4445:	74 37                	je     447e <get_char+0x5e>
    4447:	48 8b 07             	mov    rax,QWORD PTR [rdi]
    444a:	0f b6 04 30          	movzx  eax,BYTE PTR [rax+rsi*1]
    444e:	83 f8 3f             	cmp    eax,0x3f
    4451:	75 1a                	jne    446d <get_char+0x4d>
    4453:	0f b6 47 10          	movzx  eax,BYTE PTR [rdi+0x10]
    4457:	85 c0                	test   eax,eax
    4459:	b8 00 00 00 00       	mov    eax,0x0
    445e:	0f 95 c0             	setne  al
    4461:	85 c0                	test   eax,eax
    4463:	b8 00 00 00 00       	mov    eax,0x0
    4468:	0f 94 c0             	sete   al
    446b:	eb 05                	jmp    4472 <get_char+0x52>
    446d:	b8 01 00 00 00       	mov    eax,0x1
    4472:	85 c0                	test   eax,eax
    4474:	b8 00 00 00 00       	mov    eax,0x0
    4479:	0f 95 c0             	setne  al
    447c:	eb 02                	jmp    4480 <get_char+0x60>
    447e:	31 c0                	xor    eax,eax
    4480:	85 c0                	test   eax,eax
    4482:	74 14                	je     4498 <get_char+0x78>
    4484:	48 8b 07             	mov    rax,QWORD PTR [rdi]
    4487:	0f b6 04 30          	movzx  eax,BYTE PTR [rax+rsi*1]
    448b:	48 89 31             	mov    QWORD PTR [rcx],rsi
    448e:	b9 01 00 00 00       	mov    ecx,0x1
    4493:	48 89 0a             	mov    QWORD PTR [rdx],rcx
    4496:	eb 05                	jmp    449d <get_char+0x7d>
    4498:	e8 23 fe ff ff       	call   42c0 <get_char_slow>
    449d:	48 83 c4 08          	add    rsp,0x8
    44a1:	c3                   	ret

