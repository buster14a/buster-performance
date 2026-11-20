
cases/znver5-parent.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <to_double>:
   0:	movss  xmm0,DWORD PTR [rdi]
   4:	cvtss2sd xmm0,xmm0
   8:	ret
   9:	int3
   a:	int3
   b:	int3
   c:	int3
   d:	int3
   e:	int3
   f:	int3

0000000000000010 <to_float>:
  10:	movsd  xmm0,QWORD PTR [rdi]
  14:	cvtsd2ss xmm0,xmm0
  18:	ret
  19:	int3
  1a:	int3
  1b:	int3
  1c:	int3
  1d:	int3
  1e:	int3
  1f:	int3

0000000000000020 <to_double_index>:
  20:	movss  xmm0,DWORD PTR [rdi+rsi*4+0x8]
  26:	cvtss2sd xmm0,xmm0
  2a:	ret
  2b:	int3
  2c:	int3
  2d:	int3
  2e:	int3
  2f:	int3

0000000000000030 <to_float_index>:
  30:	movsd  xmm0,QWORD PTR [rdi+rsi*8+0x10]
  36:	cvtsd2ss xmm0,xmm0
  3a:	ret
  3b:	int3
  3c:	int3
  3d:	int3
  3e:	int3
  3f:	int3

0000000000000040 <to_double_packed>:
  40:	movss  xmm0,DWORD PTR [rdi+0x1]
  45:	cvtss2sd xmm0,xmm0
  49:	ret
  4a:	int3
  4b:	int3
  4c:	int3
  4d:	int3
  4e:	int3
  4f:	int3

0000000000000050 <to_float_packed>:
  50:	movsd  xmm0,QWORD PTR [rdi+0x1]
  55:	cvtsd2ss xmm0,xmm0
  59:	ret
  5a:	int3
  5b:	int3
  5c:	int3
  5d:	int3
  5e:	int3
  5f:	int3

0000000000000060 <to_double_stream>:
  60:	xor    eax,eax
  62:	jmp    78 <to_double_stream+0x18>
  64:	mov    rcx,rax
  67:	movss  xmm0,DWORD PTR [rsi+rcx*4]
  6c:	cvtss2sd xmm0,xmm0
  70:	movsd  QWORD PTR [rdi+rcx*8],xmm0
  75:	add    eax,0x1
  78:	cmp    eax,edx
  7a:	jb     64 <to_double_stream+0x4>
  7c:	ret
  7d:	int3
  7e:	int3
  7f:	int3

0000000000000080 <to_float_stream>:
  80:	xor    eax,eax
  82:	jmp    98 <to_float_stream+0x18>
  84:	mov    rcx,rax
  87:	movsd  xmm0,QWORD PTR [rsi+rcx*8]
  8c:	cvtsd2ss xmm0,xmm0
  90:	movss  DWORD PTR [rdi+rcx*4],xmm0
  95:	add    eax,0x1
  98:	cmp    eax,edx
  9a:	jb     84 <to_float_stream+0x4>
  9c:	ret
