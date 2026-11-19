
head/TILEZERO.o:	file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <tested>:
       0: 55                           	push	rbp
       1: 48 89 e5                     	mov	rbp, rsp
       4: 48 81 ec 00 08 00 00         	sub	rsp, 0x800
       b: 48 81 e4 00 fc ff ff         	and	rsp, -0x400
      12: 48 89 7c 24 08               	mov	qword ptr [rsp + 0x8], rdi
      17: 66 44 89 44 24 10            	mov	word ptr [rsp + 0x10], r8w
      1d: 66 44 89 4c 24 18            	mov	word ptr [rsp + 0x18], r9w
      23: 48 8b 44 24 08               	mov	rax, qword ptr [rsp + 0x8]
      28: 0f b7 4c 24 10               	movzx	ecx, word ptr [rsp + 0x10]
      2d: 0f b7 54 24 18               	movzx	edx, word ptr [rsp + 0x18]
      32: 48 8d b4 24 00 04 00 00      	lea	rsi, [rsp + 0x400]
      3a: 48 89 04 24                  	mov	qword ptr [rsp], rax
      3e: 48 8b f9                     	mov	rdi, rcx
      41: 48 87 f2                     	xchg	rsi, rdx
      44: e8 00 00 00 00               	call	0x49 <tested+0x49>
      49: 48 8b 04 24                  	mov	rax, qword ptr [rsp]
      4d: 48 8d 8c 24 00 04 00 00      	lea	rcx, [rsp + 0x400]
      55: ba 00 04 00 00               	mov	edx, 0x400
      5a: 48 8b f1                     	mov	rsi, rcx
      5d: 48 8b f8                     	mov	rdi, rax
      60: e8 00 00 00 00               	call	0x65 <tested+0x65>
      65: 48 89 ec                     	mov	rsp, rbp
      68: 5d                           	pop	rbp
      69: c3                           	ret
      6a: cc                           	int3
      6b: cc                           	int3
      6c: cc                           	int3
      6d: cc                           	int3
      6e: cc                           	int3
      6f: cc                           	int3

0000000000000070 <.Lbuster_builtin_0_0>:
      70: 55                           	push	rbp
      71: 48 89 e5                     	mov	rbp, rsp
      74: 48 83 ec 40                  	sub	rsp, 0x40
      78: 48 83 e4 c0                  	and	rsp, -0x40
      7c: 0f 57 c0                     	xorps	xmm0, xmm0
      7f: 0f 11 04 24                  	movups	xmmword ptr [rsp], xmm0
      83: 0f 11 44 24 10               	movups	xmmword ptr [rsp + 0x10], xmm0
      88: 0f 11 44 24 20               	movups	xmmword ptr [rsp + 0x20], xmm0
      8d: 0f 11 44 24 30               	movups	xmmword ptr [rsp + 0x30], xmm0
      92: c6 04 24 01                  	mov	byte ptr [rsp], 0x1
      96: 66 89 74 24 10               	mov	word ptr [rsp + 0x10], si
      9b: 40 88 7c 24 30               	mov	byte ptr [rsp + 0x30], dil
      a0: c4 e2 78 49 04 24            	ldtilecfg	[rsp]
      a6: c4 e2 7b 49 c0               	tilezero	tmm0
      ab: 48 8b fa                     	mov	rdi, rdx
      ae: b9 80 00 00 00               	mov	ecx, 0x80
      b3: 31 c0                        	xor	eax, eax
      b5: f3 48 ab                     	rep		stosq	qword ptr es:[rdi], rax
      b8: c4 e2 7a 4b 04 32            	tilestored	[rdx + rsi], tmm0
      be: c4 e2 78 49 c0               	tilerelease
      c3: 48 89 ec                     	mov	rsp, rbp
      c6: 5d                           	pop	rbp
      c7: c3                           	ret
