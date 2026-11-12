0000000000001800 <sign>:
    1800:	sub    $0x18,%rsp
    1804:	mov    %edi,(%rsp)
    1807:	mov    (%rsp),%eax
    180a:	test   %eax,%eax
    180c:	je     1817 <sign+0x17>
    180e:	js     181b <sign+0x1b>
    1810:	mov    $0x1,%eax
    1815:	jmp    1820 <sign+0x20>
    1817:	xor    %eax,%eax
    1819:	jmp    1820 <sign+0x20>
    181b:	mov    $0xffffffff,%eax
    1820:	add    $0x18,%rsp
    1824:	ret
    1825:	int3
    1826:	int3
    1827:	int3
    1828:	int3
    1829:	int3
    182a:	int3
    182b:	int3
    182c:	int3
    182d:	int3
    182e:	int3
    182f:	int3

