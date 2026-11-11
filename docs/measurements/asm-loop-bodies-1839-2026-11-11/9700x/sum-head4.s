00000000000017d0 <sum>:
    17d0:	sub    $0x38,%rsp
    17d4:	mov    %rdi,(%rsp)
    17d8:	xor    %eax,%eax
    17da:	movslq %eax,%rax
    17dd:	mov    %rax,0x8(%rsp)
    17e2:	lea    0x10(%rsp),%rax
    17e7:	lea    0x8(%rsp),%rcx
    17ec:	mov    %rcx,(%rax)
    17ef:	lea    0x10(%rsp),%rax
    17f4:	mov    (%rax),%rax
    17f7:	mov    (%rax),%rax
    17fa:	lea    0x10(%rsp),%rcx
    17ff:	add    $0x10,%rcx
    1803:	lea    (%rsp),%rdx
    1807:	mov    %rdx,(%rcx)
    180a:	lea    0x10(%rsp),%rcx
    180f:	mov    0x10(%rcx),%rcx
    1813:	mov    (%rcx),%rcx
    1816:	add    %rcx,%rax
    1819:	loop   1816 <sum+0x46>
    181b:	mov    0x10(%rsp),%rsi
    1820:	mov    %rax,(%rsi)
    1823:	mov    0x20(%rsp),%rsi
    1828:	mov    %rcx,(%rsi)
    182b:	mov    0x8(%rsp),%rax
    1830:	add    $0x38,%rsp
    1834:	ret
    1835:	int3
    1836:	int3
    1837:	int3
    1838:	int3
    1839:	int3
    183a:	int3
    183b:	int3
    183c:	int3
    183d:	int3
    183e:	int3
    183f:	int3

