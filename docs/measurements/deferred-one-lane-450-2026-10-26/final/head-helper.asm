
work/campaign/native-images/head450-final/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000001105f70 <check_deferred_one_lane>:
 1105f70:	41 56                	push   %r14
 1105f72:	53                   	push   %rbx
 1105f73:	48 83 ec 18          	sub    $0x18,%rsp
 1105f77:	48 c7 c3 60 f5 ff ff 	mov    $0xfffffffffffff560,%rbx
 1105f7e:	48 b8 00 00 00 00 01 	movabs $0x100000000,%rax
 1105f85:	00 00 00 
 1105f88:	64 c5 f8 10 03       	vmovups %fs:(%rbx),%xmm0
 1105f8d:	64 48 89 03          	mov    %rax,%fs:(%rbx)
 1105f91:	64 48 c7 43 08 00 00 	movq   $0x0,%fs:0x8(%rbx)
 1105f98:	00 00 
 1105f9a:	64 4c 8b 73 68       	mov    %fs:0x68(%rbx),%r14
 1105f9f:	64 48 c7 43 68 00 00 	movq   $0x0,%fs:0x68(%rbx)
 1105fa6:	00 00 
 1105fa8:	c5 f8 29 04 24       	vmovaps %xmm0,(%rsp)
 1105fad:	e8 8e 07 00 00       	call   1106740 <check_deferred_lane>
 1105fb2:	c5 f8 28 04 24       	vmovaps (%rsp),%xmm0
 1105fb7:	64 4c 89 73 68       	mov    %r14,%fs:0x68(%rbx)
 1105fbc:	64 c5 f8 11 03       	vmovups %xmm0,%fs:(%rbx)
 1105fc1:	48 83 c4 18          	add    $0x18,%rsp
 1105fc5:	5b                   	pop    %rbx
 1105fc6:	41 5e                	pop    %r14
 1105fc8:	c3                   	ret
