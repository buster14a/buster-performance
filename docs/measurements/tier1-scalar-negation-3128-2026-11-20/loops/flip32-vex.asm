
/home/david/Documents/Codex/2026-11-19/profile-and-improve-buster-compilation-speed/work/neg-evidence/loops/programs/flip32-vex.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <flip>:
   0:	31 c0                	xor    eax,eax
   2:	eb 27                	jmp    2b <flip+0x2b>
   4:	4c 8b c0             	mov    r8,rax
   7:	f3 42 0f 10 04 82    	movss  xmm0,DWORD PTR [rdx+r8*4]
   d:	41 bb 00 00 00 80    	mov    r11d,0x80000000
  13:	c4 c1 79 6e cb       	vmovd  xmm1,r11d
  18:	c5 f0 57 c8          	vxorps xmm1,xmm1,xmm0
  1c:	f3 42 0f 11 0c 87    	movss  DWORD PTR [rdi+r8*4],xmm1
  22:	f3 42 0f 11 04 86    	movss  DWORD PTR [rsi+r8*4],xmm0
  28:	83 c0 01             	add    eax,0x1
  2b:	3b c1                	cmp    eax,ecx
  2d:	72 d5                	jb     4 <flip+0x4>
  2f:	c3                   	ret
