0000000000001800 <A>:
    1800:	movabs $0x3ff0000000000000,%rax
    180a:	movq   %rax,%xmm0
    180f:	mov    %edi,%eax
    1811:	add    %esi,%eax
    1813:	mov    %edi,%ecx
    1815:	add    %esi,%ecx
    1817:	inc    %ecx
    1819:	imul   %ecx,%eax
    181c:	mov    %rax,%rcx
    181f:	sar    $0x1f,%ecx
    1822:	and    $0x1,%ecx
    1825:	add    %ecx,%eax
    1827:	sar    $1,%eax
    1829:	add    %edi,%eax
    182b:	inc    %eax
    182d:	xorps  %xmm1,%xmm1
    1830:	cvtsi2sd %eax,%xmm1
    1834:	divsd  %xmm1,%xmm0
    1838:	ret
