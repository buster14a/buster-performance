
/home/david/Documents/Codex/2026-11-19/profile-and-improve-buster-compilation-speed/work/neg-evidence/loops/programs/flip64-control.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <flip>:
   0:	31 c0                	xor    eax,eax
   2:	eb 2e                	jmp    32 <flip+0x32>
   4:	4c 8b c0             	mov    r8,rax
   7:	f2 42 0f 10 04 c2    	movsd  xmm0,QWORD PTR [rdx+r8*8]
   d:	49 bb 00 00 00 00 00 	movabs r11,0x8000000000000000
  14:	00 00 80
  17:	66 4d 0f 6e fb       	movq   xmm15,r11
  1c:	0f 28 c8             	movaps xmm1,xmm0
  1f:	41 0f 57 cf          	xorps  xmm1,xmm15
  23:	f2 42 0f 11 0c c7    	movsd  QWORD PTR [rdi+r8*8],xmm1
  29:	f2 42 0f 11 04 c6    	movsd  QWORD PTR [rsi+r8*8],xmm0
  2f:	83 c0 01             	add    eax,0x1
  32:	3b c1                	cmp    eax,ecx
  34:	72 ce                	jb     4 <flip+0x4>
  36:	c3                   	ret
