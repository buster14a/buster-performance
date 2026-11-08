00000000000044b0 <peek_char>:
    44b0:	48 83 ec 08          	sub    rsp,0x8
    44b4:	48 8d 04 24          	lea    rax,[rsp]
    44b8:	48 8b c8             	mov    rcx,rax
    44bb:	e8 60 ff ff ff       	call   4420 <get_char>
    44c0:	48 83 c4 08          	add    rsp,0x8
    44c4:	c3                   	ret

