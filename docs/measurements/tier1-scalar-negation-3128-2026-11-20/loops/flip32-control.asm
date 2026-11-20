
/home/david/Documents/Codex/2026-11-19/profile-and-improve-buster-compilation-speed/work/neg-evidence/loops/programs/flip32-control.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <flip>:
   0:	31 c0                	xor    eax,eax
   2:	eb 2a                	jmp    2e <flip+0x2e>
   4:	4c 8b c0             	mov    r8,rax
   7:	f3 42 0f 10 04 82    	movss  xmm0,DWORD PTR [rdx+r8*4]
   d:	41 bb 00 00 00 80    	mov    r11d,0x80000000
  13:	66 45 0f 6e fb       	movd   xmm15,r11d
  18:	0f 28 c8             	movaps xmm1,xmm0
  1b:	41 0f 57 cf          	xorps  xmm1,xmm15
  1f:	f3 42 0f 11 0c 87    	movss  DWORD PTR [rdi+r8*4],xmm1
  25:	f3 42 0f 11 04 86    	movss  DWORD PTR [rsi+r8*4],xmm0
  2b:	83 c0 01             	add    eax,0x1
  2e:	3b c1                	cmp    eax,ecx
  30:	72 d2                	jb     4 <flip+0x4>
  32:	c3                   	ret
