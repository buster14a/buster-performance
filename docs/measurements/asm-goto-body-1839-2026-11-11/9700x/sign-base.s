0000000000001860 <sign>:
    1860:	push   %rbx
    1861:	sub    $0x10,%rsp
    1865:	mov    %edi,(%rsp)
    1868:	lea    0x8(%rsp),%rax
    186d:	mov    (%rsp),%ecx
    1870:	mov    %ecx,(%rax)
    1872:	lea    0x8(%rsp),%rax
    1877:	mov    %rax,%rdi
    187a:	call   1a70 <main+0x140>
    187f:	mov    %eax,%ebx
    1881:	cmp    $0x1,%ebx
    1884:	je     1892 <sign+0x32>
    1886:	cmp    $0x2,%ebx
    1889:	je     1896 <sign+0x36>
    188b:	mov    $0x1,%eax
    1890:	jmp    189b <sign+0x3b>
    1892:	xor    %eax,%eax
    1894:	jmp    189b <sign+0x3b>
    1896:	mov    $0xffffffff,%eax
    189b:	add    $0x10,%rsp
    189f:	pop    %rbx
    18a0:	ret
    18a1:	int3
    18a2:	int3
    18a3:	int3
    18a4:	int3
    18a5:	int3
    18a6:	int3
    18a7:	int3
    18a8:	int3
    18a9:	int3
    18aa:	int3
    18ab:	int3
    18ac:	int3
    18ad:	int3
    18ae:	int3
    18af:	int3

