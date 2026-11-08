0000000000004480 <peek_char>:
    4480:	48 83 ec 08          	sub    rsp,0x8
    4484:	48 8d 04 24          	lea    rax,[rsp]
    4488:	48 8b c8             	mov    rcx,rax
    448b:	e8 70 ff ff ff       	call   4400 <get_char>
    4490:	48 83 c4 08          	add    rsp,0x8
    4494:	c3                   	ret

