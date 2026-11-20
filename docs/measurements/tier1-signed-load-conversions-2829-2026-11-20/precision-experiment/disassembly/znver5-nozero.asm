
cases/znver5-nozero.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <to_double>:
   0:	cvtss2sd xmm0,DWORD PTR [rdi]
   4:	ret
   5:	int3
   6:	int3
   7:	int3
   8:	int3
   9:	int3
   a:	int3
   b:	int3
   c:	int3
   d:	int3
   e:	int3
   f:	int3

0000000000000010 <to_float>:
  10:	cvtsd2ss xmm0,QWORD PTR [rdi]
  14:	ret
  15:	int3
  16:	int3
  17:	int3
  18:	int3
  19:	int3
  1a:	int3
  1b:	int3
  1c:	int3
  1d:	int3
  1e:	int3
  1f:	int3

0000000000000020 <to_double_index>:
  20:	cvtss2sd xmm0,DWORD PTR [rdi+rsi*4+0x8]
  26:	ret
  27:	int3
  28:	int3
  29:	int3
  2a:	int3
  2b:	int3
  2c:	int3
  2d:	int3
  2e:	int3
  2f:	int3

0000000000000030 <to_float_index>:
  30:	cvtsd2ss xmm0,QWORD PTR [rdi+rsi*8+0x10]
  36:	ret
  37:	int3
  38:	int3
  39:	int3
  3a:	int3
  3b:	int3
  3c:	int3
  3d:	int3
  3e:	int3
  3f:	int3

0000000000000040 <to_double_packed>:
  40:	cvtss2sd xmm0,DWORD PTR [rdi+0x1]
  45:	ret
  46:	int3
  47:	int3
  48:	int3
  49:	int3
  4a:	int3
  4b:	int3
  4c:	int3
  4d:	int3
  4e:	int3
  4f:	int3

0000000000000050 <to_float_packed>:
  50:	cvtsd2ss xmm0,QWORD PTR [rdi+0x1]
  55:	ret
  56:	int3
  57:	int3
  58:	int3
  59:	int3
  5a:	int3
  5b:	int3
  5c:	int3
  5d:	int3
  5e:	int3
  5f:	int3

0000000000000060 <to_double_stream>:
  60:	xor    eax,eax
  62:	jmp    74 <to_double_stream+0x14>
  64:	mov    rcx,rax
  67:	cvtss2sd xmm0,DWORD PTR [rsi+rcx*4]
  6c:	movsd  QWORD PTR [rdi+rcx*8],xmm0
  71:	add    eax,0x1
  74:	cmp    eax,edx
  76:	jb     64 <to_double_stream+0x4>
  78:	ret
  79:	int3
  7a:	int3
  7b:	int3
  7c:	int3
  7d:	int3
  7e:	int3
  7f:	int3

0000000000000080 <to_float_stream>:
  80:	xor    eax,eax
  82:	jmp    94 <to_float_stream+0x14>
  84:	mov    rcx,rax
  87:	cvtsd2ss xmm0,QWORD PTR [rsi+rcx*8]
  8c:	movss  DWORD PTR [rdi+rcx*4],xmm0
  91:	add    eax,0x1
  94:	cmp    eax,edx
  96:	jb     84 <to_float_stream+0x4>
  98:	ret
