0000000000004400 <get_char>:
    4400:	48 83 ec 08          	sub    rsp,0x8
    4404:	48 3b 77 08          	cmp    rsi,QWORD PTR [rdi+0x8]
    4408:	73 11                	jae    441b <get_char+0x1b>
    440a:	48 8b 07             	mov    rax,QWORD PTR [rdi]
    440d:	80 3c 30 5c          	cmp    BYTE PTR [rax+rsi*1],0x5c
    4411:	b8 00 00 00 00       	mov    eax,0x0
    4416:	0f 95 c0             	setne  al
    4419:	eb 02                	jmp    441d <get_char+0x1d>
    441b:	31 c0                	xor    eax,eax
    441d:	85 c0                	test   eax,eax
    441f:	74 2f                	je     4450 <get_char+0x50>
    4421:	48 8b 07             	mov    rax,QWORD PTR [rdi]
    4424:	80 3c 30 3f          	cmp    BYTE PTR [rax+rsi*1],0x3f
    4428:	75 15                	jne    443f <get_char+0x3f>
    442a:	33 c0                	xor    eax,eax
    442c:	80 7f 10 00          	cmp    BYTE PTR [rdi+0x10],0x0
    4430:	0f 95 c0             	setne  al
    4433:	85 c0                	test   eax,eax
    4435:	b8 00 00 00 00       	mov    eax,0x0
    443a:	0f 94 c0             	sete   al
    443d:	eb 05                	jmp    4444 <get_char+0x44>
    443f:	b8 01 00 00 00       	mov    eax,0x1
    4444:	85 c0                	test   eax,eax
    4446:	b8 00 00 00 00       	mov    eax,0x0
    444b:	0f 95 c0             	setne  al
    444e:	eb 02                	jmp    4452 <get_char+0x52>
    4450:	31 c0                	xor    eax,eax
    4452:	85 c0                	test   eax,eax
    4454:	74 14                	je     446a <get_char+0x6a>
    4456:	48 8b 07             	mov    rax,QWORD PTR [rdi]
    4459:	0f b6 04 30          	movzx  eax,BYTE PTR [rax+rsi*1]
    445d:	48 89 31             	mov    QWORD PTR [rcx],rsi
    4460:	b9 01 00 00 00       	mov    ecx,0x1
    4465:	48 89 0a             	mov    QWORD PTR [rdx],rcx
    4468:	eb 05                	jmp    446f <get_char+0x6f>
    446a:	e8 41 fe ff ff       	call   42b0 <get_char_slow>
    446f:	48 83 c4 08          	add    rsp,0x8
    4473:	c3                   	ret

