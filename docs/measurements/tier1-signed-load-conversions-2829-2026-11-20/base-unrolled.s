
base-znver5-unroll.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000cc0 <k_i32_to_f32>:
     cc0:	31 c0                	xor    %eax,%eax
     cc2:	48 3b c2             	cmp    %rdx,%rax
     cc5:	0f 83 ed 00 00 00    	jae    db8 <k_i32_to_f32+0xf8>
     ccb:	48 8b ca             	mov    %rdx,%rcx
     cce:	48 83 e9 07          	sub    $0x7,%rcx
     cd2:	48 83 fa 07          	cmp    $0x7,%rdx
     cd6:	0f 86 c3 00 00 00    	jbe    d9f <k_i32_to_f32+0xdf>
     cdc:	44 8b 04 86          	mov    (%rsi,%rax,4),%r8d
     ce0:	0f 57 c9             	xorps  %xmm1,%xmm1
     ce3:	f3 41 0f 2a c8       	cvtsi2ss %r8d,%xmm1
     ce8:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     cec:	f3 0f 11 0c 87       	movss  %xmm1,(%rdi,%rax,4)
     cf1:	44 8b 44 86 04       	mov    0x4(%rsi,%rax,4),%r8d
     cf6:	0f 57 c9             	xorps  %xmm1,%xmm1
     cf9:	f3 41 0f 2a c8       	cvtsi2ss %r8d,%xmm1
     cfe:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     d02:	f3 0f 11 4c 87 04    	movss  %xmm1,0x4(%rdi,%rax,4)
     d08:	44 8b 44 86 08       	mov    0x8(%rsi,%rax,4),%r8d
     d0d:	0f 57 c9             	xorps  %xmm1,%xmm1
     d10:	f3 41 0f 2a c8       	cvtsi2ss %r8d,%xmm1
     d15:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     d19:	f3 0f 11 4c 87 08    	movss  %xmm1,0x8(%rdi,%rax,4)
     d1f:	44 8b 44 86 0c       	mov    0xc(%rsi,%rax,4),%r8d
     d24:	0f 57 c9             	xorps  %xmm1,%xmm1
     d27:	f3 41 0f 2a c8       	cvtsi2ss %r8d,%xmm1
     d2c:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     d30:	f3 0f 11 4c 87 0c    	movss  %xmm1,0xc(%rdi,%rax,4)
     d36:	44 8b 44 86 10       	mov    0x10(%rsi,%rax,4),%r8d
     d3b:	0f 57 c9             	xorps  %xmm1,%xmm1
     d3e:	f3 41 0f 2a c8       	cvtsi2ss %r8d,%xmm1
     d43:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     d47:	f3 0f 11 4c 87 10    	movss  %xmm1,0x10(%rdi,%rax,4)
     d4d:	44 8b 44 86 14       	mov    0x14(%rsi,%rax,4),%r8d
     d52:	0f 57 c9             	xorps  %xmm1,%xmm1
     d55:	f3 41 0f 2a c8       	cvtsi2ss %r8d,%xmm1
     d5a:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     d5e:	f3 0f 11 4c 87 14    	movss  %xmm1,0x14(%rdi,%rax,4)
     d64:	44 8b 44 86 18       	mov    0x18(%rsi,%rax,4),%r8d
     d69:	0f 57 c9             	xorps  %xmm1,%xmm1
     d6c:	f3 41 0f 2a c8       	cvtsi2ss %r8d,%xmm1
     d71:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     d75:	f3 0f 11 4c 87 18    	movss  %xmm1,0x18(%rdi,%rax,4)
     d7b:	44 8b 44 86 1c       	mov    0x1c(%rsi,%rax,4),%r8d
     d80:	0f 57 c9             	xorps  %xmm1,%xmm1
     d83:	f3 41 0f 2a c8       	cvtsi2ss %r8d,%xmm1
     d88:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     d8c:	f3 0f 11 4c 87 1c    	movss  %xmm1,0x1c(%rdi,%rax,4)
     d92:	48 83 c0 08          	add    $0x8,%rax
     d96:	48 3b c1             	cmp    %rcx,%rax
     d99:	0f 82 3d ff ff ff    	jb     cdc <k_i32_to_f32+0x1c>
     d9f:	eb 17                	jmp    db8 <k_i32_to_f32+0xf8>
     da1:	8b 0c 86             	mov    (%rsi,%rax,4),%ecx
     da4:	0f 57 c9             	xorps  %xmm1,%xmm1
     da7:	f3 0f 2a c9          	cvtsi2ss %ecx,%xmm1
     dab:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     daf:	f3 0f 11 0c 87       	movss  %xmm1,(%rdi,%rax,4)
     db4:	48 83 c0 01          	add    $0x1,%rax
     db8:	48 3b c2             	cmp    %rdx,%rax
     dbb:	72 e4                	jb     da1 <k_i32_to_f32+0xe1>
     dbd:	c3                   	ret
