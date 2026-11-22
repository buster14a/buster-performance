0000000000001790 <A>:
    1790:	movabs $0x3ff0000000000000,%rax
    179a:	movq   %rax,%xmm0
    179f:	mov    %edi,%eax
    17a1:	add    %esi,%eax
    17a3:	mov    %edi,%ecx
    17a5:	add    %esi,%ecx
    17a7:	inc    %ecx
    17a9:	imul   %ecx,%eax
    17ac:	mov    %rax,%rcx
    17af:	sar    $0x1f,%ecx
    17b2:	and    $0x1,%ecx
    17b5:	add    %ecx,%eax
    17b7:	sar    $1,%eax
    17b9:	add    %edi,%eax
    17bb:	inc    %eax
    17bd:	cvtsi2sd %eax,%xmm1
    17c1:	divsd  %xmm1,%xmm0
    17c5:	ret
