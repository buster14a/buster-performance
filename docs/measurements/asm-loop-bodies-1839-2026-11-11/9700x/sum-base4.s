0000000000001820 <sum>:
    1820:	sub    $0x38,%rsp
    1824:	mov    %rdi,(%rsp)
    1828:	xor    %eax,%eax
    182a:	movslq %eax,%rax
    182d:	mov    %rax,0x8(%rsp)
    1832:	lea    0x10(%rsp),%rax
    1837:	lea    0x8(%rsp),%rcx
    183c:	mov    %rcx,(%rax)
    183f:	lea    0x10(%rsp),%rax
    1844:	add    $0x8,%rax
    1848:	lea    0x10(%rsp),%rcx
    184d:	mov    (%rcx),%rcx
    1850:	mov    (%rcx),%rcx
    1853:	mov    %rcx,(%rax)
    1856:	lea    0x10(%rsp),%rax
    185b:	add    $0x10,%rax
    185f:	lea    (%rsp),%rcx
    1863:	mov    %rcx,(%rax)
    1866:	lea    0x10(%rsp),%rax
    186b:	add    $0x18,%rax
    186f:	lea    0x10(%rsp),%rcx
    1874:	mov    0x10(%rcx),%rcx
    1878:	mov    (%rcx),%rcx
    187b:	mov    %rcx,(%rax)
    187e:	lea    0x10(%rsp),%rax
    1883:	mov    %rax,%rdi
    1886:	call   1a00 <main+0x100>
    188b:	mov    0x8(%rsp),%rax
    1890:	add    $0x38,%rsp
    1894:	ret
    1895:	int3
    1896:	int3
    1897:	int3
    1898:	int3
    1899:	int3
    189a:	int3
    189b:	int3
    189c:	int3
    189d:	int3
    189e:	int3
    189f:	int3

