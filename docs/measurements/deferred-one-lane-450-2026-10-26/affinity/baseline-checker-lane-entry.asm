
work/campaign/native-images/base450-final/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

0000000001105e90 <lane_run>:
 1105e90:	55                   	push   %rbp
 1105e91:	48 89 e5             	mov    %rsp,%rbp
 1105e94:	41 57                	push   %r15
 1105e96:	41 56                	push   %r14
 1105e98:	41 55                	push   %r13
 1105e9a:	41 54                	push   %r12
 1105e9c:	53                   	push   %rbx
 1105e9d:	48 83 e4 80          	and    $0xffffffffffffff80,%rsp
 1105ea1:	48 81 ec 80 23 00 00 	sub    $0x2380,%rsp
 1105ea8:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
 1105ead:	49 c7 c5 60 f5 ff ff 	mov    $0xfffffffffffff560,%r13
 1105eb4:	49 89 f7             	mov    %rsi,%r15
 1105eb7:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
 1105ebe:	00 00 
 1105ec0:	48 89 84 24 40 23 00 	mov    %rax,0x2340(%rsp)
 1105ec7:	00 
 1105ec8:	48 89 7c 24 50       	mov    %rdi,0x50(%rsp)
 1105ecd:	48                   	rex.W
 1105ece:	89                   	.byte 0x89
 1105ecf:	54                   	push   %rsp
