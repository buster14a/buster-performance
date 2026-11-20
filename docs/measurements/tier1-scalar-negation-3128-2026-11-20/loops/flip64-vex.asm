
/home/david/Documents/Codex/2026-11-19/profile-and-improve-buster-compilation-speed/work/neg-evidence/loops/programs/flip64-vex.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <flip>:
   0:	31 c0                	xor    eax,eax
   2:	eb 2b                	jmp    2f <flip+0x2f>
   4:	4c 8b c0             	mov    r8,rax
   7:	f2 42 0f 10 04 c2    	movsd  xmm0,QWORD PTR [rdx+r8*8]
   d:	49 bb 00 00 00 00 00 	movabs r11,0x8000000000000000
  14:	00 00 80
  17:	c4 c1 f9 6e cb       	vmovq  xmm1,r11
  1c:	c5 f0 57 c8          	vxorps xmm1,xmm1,xmm0
  20:	f2 42 0f 11 0c c7    	movsd  QWORD PTR [rdi+r8*8],xmm1
  26:	f2 42 0f 11 04 c6    	movsd  QWORD PTR [rsi+r8*8],xmm0
  2c:	83 c0 01             	add    eax,0x1
  2f:	3b c1                	cmp    eax,ecx
  31:	72 d1                	jb     4 <flip+0x4>
  33:	c3                   	ret
