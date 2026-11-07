	.text
	.globl	add_one
	.type	add_one, @function
add_one:
	leal	1(%rdi), %eax
	ret
	.size	add_one, .-add_one
	.section	.note.GNU-stack,"",@progbits
