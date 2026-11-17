0000000000000280 <wrapped_validate_branches>:
     280:	xor    %eax,%eax
     282:	cmp    $0x11111112,%rsi
     289:	setae  %r10b
     28d:	lea    0xc(%rdi),%r9
     291:	test   %rdi,%rdi
     294:	cmove  %rdi,%r9
     298:	test   %r8,%r8
     29b:	sete   %dil
     29f:	or     %r10b,%dil
     2a2:	je     2aa <wrapped_validate_branches+0x2a>
     2a4:	mov    %r10b,%al
     2a7:	xor    %edx,%edx
     2a9:	ret
