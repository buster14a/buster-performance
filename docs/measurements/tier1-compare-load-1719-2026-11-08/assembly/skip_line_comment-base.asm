0000000000005a60 <skip_line_comment>:
    5a60:	53                   	push   rbx
    5a61:	55                   	push   rbp
    5a62:	48 83 ec 18          	sub    rsp,0x18
    5a66:	48 8d 5c 24 08       	lea    rbx,[rsp+0x8]
    5a6b:	48 8b ee             	mov    rbp,rsi
    5a6e:	48 8b c3             	mov    rax,rbx
    5a71:	48 89 3c 24          	mov    QWORD PTR [rsp],rdi
    5a75:	48 8b f5             	mov    rsi,rbp
    5a78:	48 8b d0             	mov    rdx,rax
    5a7b:	e8 30 ea ff ff       	call   44b0 <peek_char>
    5a80:	48 8b 3c 24          	mov    rdi,QWORD PTR [rsp]
    5a84:	83 f8 ff             	cmp    eax,0xffffffff
    5a87:	74 0a                	je     5a93 <skip_line_comment+0x33>
    5a89:	33 c9                	xor    ecx,ecx
    5a8b:	83 f8 0a             	cmp    eax,0xa
    5a8e:	0f 94 c1             	sete   cl
    5a91:	eb 05                	jmp    5a98 <skip_line_comment+0x38>
    5a93:	b9 01 00 00 00       	mov    ecx,0x1
    5a98:	85 c9                	test   ecx,ecx
    5a9a:	75 0d                	jne    5aa9 <skip_line_comment+0x49>
    5a9c:	83 f8 0d             	cmp    eax,0xd
    5a9f:	b8 00 00 00 00       	mov    eax,0x0
    5aa4:	0f 94 c0             	sete   al
    5aa7:	eb 05                	jmp    5aae <skip_line_comment+0x4e>
    5aa9:	b8 01 00 00 00       	mov    eax,0x1
    5aae:	85 c0                	test   eax,eax
    5ab0:	74 0a                	je     5abc <skip_line_comment+0x5c>
    5ab2:	48 8b c5             	mov    rax,rbp
    5ab5:	48 83 c4 18          	add    rsp,0x18
    5ab9:	5d                   	pop    rbp
    5aba:	5b                   	pop    rbx
    5abb:	c3                   	ret
    5abc:	48 8b 03             	mov    rax,QWORD PTR [rbx]
    5abf:	48 8d 44 05 00       	lea    rax,[rbp+rax*1+0x0]
    5ac4:	48 8b e8             	mov    rbp,rax
    5ac7:	eb a5                	jmp    5a6e <skip_line_comment+0xe>

