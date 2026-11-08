00000000000059f0 <skip_line_comment>:
    59f0:	53                   	push   rbx
    59f1:	55                   	push   rbp
    59f2:	48 83 ec 18          	sub    rsp,0x18
    59f6:	48 8d 5c 24 08       	lea    rbx,[rsp+0x8]
    59fb:	48 8b ee             	mov    rbp,rsi
    59fe:	48 8b c3             	mov    rax,rbx
    5a01:	48 89 3c 24          	mov    QWORD PTR [rsp],rdi
    5a05:	48 8b f5             	mov    rsi,rbp
    5a08:	48 8b d0             	mov    rdx,rax
    5a0b:	e8 70 ea ff ff       	call   4480 <peek_char>
    5a10:	48 8b 3c 24          	mov    rdi,QWORD PTR [rsp]
    5a14:	83 f8 ff             	cmp    eax,0xffffffff
    5a17:	74 0a                	je     5a23 <skip_line_comment+0x33>
    5a19:	33 c9                	xor    ecx,ecx
    5a1b:	83 f8 0a             	cmp    eax,0xa
    5a1e:	0f 94 c1             	sete   cl
    5a21:	eb 05                	jmp    5a28 <skip_line_comment+0x38>
    5a23:	b9 01 00 00 00       	mov    ecx,0x1
    5a28:	85 c9                	test   ecx,ecx
    5a2a:	75 0d                	jne    5a39 <skip_line_comment+0x49>
    5a2c:	83 f8 0d             	cmp    eax,0xd
    5a2f:	b8 00 00 00 00       	mov    eax,0x0
    5a34:	0f 94 c0             	sete   al
    5a37:	eb 05                	jmp    5a3e <skip_line_comment+0x4e>
    5a39:	b8 01 00 00 00       	mov    eax,0x1
    5a3e:	85 c0                	test   eax,eax
    5a40:	74 0a                	je     5a4c <skip_line_comment+0x5c>
    5a42:	48 8b c5             	mov    rax,rbp
    5a45:	48 83 c4 18          	add    rsp,0x18
    5a49:	5d                   	pop    rbp
    5a4a:	5b                   	pop    rbx
    5a4b:	c3                   	ret
    5a4c:	48 8b 03             	mov    rax,QWORD PTR [rbx]
    5a4f:	48 8d 44 05 00       	lea    rax,[rbp+rax*1+0x0]
    5a54:	48 8b e8             	mov    rbp,rax
    5a57:	eb a5                	jmp    59fe <skip_line_comment+0xe>

