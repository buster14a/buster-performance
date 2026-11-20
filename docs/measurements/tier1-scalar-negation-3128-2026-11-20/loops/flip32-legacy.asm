
/home/david/Documents/Codex/2026-11-19/profile-and-improve-buster-compilation-speed/work/neg-evidence/loops/programs/flip32-legacy.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <flip>:
   0:	31 c0                	xor    eax,eax
   2:	eb 26                	jmp    2a <flip+0x2a>
   4:	4c 8b c0             	mov    r8,rax
   7:	f3 42 0f 10 04 82    	movss  xmm0,DWORD PTR [rdx+r8*4]
   d:	41 bb 00 00 00 80    	mov    r11d,0x80000000
  13:	66 41 0f 6e cb       	movd   xmm1,r11d
  18:	0f 57 c8             	xorps  xmm1,xmm0
  1b:	f3 42 0f 11 0c 87    	movss  DWORD PTR [rdi+r8*4],xmm1
  21:	f3 42 0f 11 04 86    	movss  DWORD PTR [rsi+r8*4],xmm0
  27:	83 c0 01             	add    eax,0x1
  2a:	3b c1                	cmp    eax,ecx
  2c:	72 d6                	jb     4 <flip+0x4>
  2e:	c3                   	ret
