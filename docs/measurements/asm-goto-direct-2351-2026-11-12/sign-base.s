0000000000001810 <sign>:
    1810:	push   %rbx
    1811:	sub    $0x10,%rsp
    1815:	mov    %edi,(%rsp)
    1818:	mov    (%rsp),%eax
    181b:	test   %eax,%eax
    181d:	je     1828 <sign+0x18>
    181f:	js     182f <sign+0x1f>
    1821:	mov    $0x0,%eax
    1826:	jmp    1834 <sign+0x24>
    1828:	mov    $0x1,%eax
    182d:	jmp    1834 <sign+0x24>
    182f:	mov    $0x2,%eax
    1834:	mov    %eax,%eax
    1836:	mov    %eax,%ebx
    1838:	cmp    $0x1,%ebx
    183b:	je     1849 <sign+0x39>
    183d:	cmp    $0x2,%ebx
    1840:	je     184d <sign+0x3d>
    1842:	mov    $0x1,%eax
    1847:	jmp    1852 <sign+0x42>
    1849:	xor    %eax,%eax
    184b:	jmp    1852 <sign+0x42>
    184d:	mov    $0xffffffff,%eax
    1852:	add    $0x10,%rsp
    1856:	pop    %rbx
    1857:	ret
    1858:	int3
    1859:	int3
    185a:	int3
    185b:	int3
    185c:	int3
    185d:	int3
    185e:	int3
    185f:	int3

