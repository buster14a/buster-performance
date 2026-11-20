
head-leaves.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <fma_a_f32>:
   0:	vfmadd132ss xmm0,xmm1,DWORD PTR [rdi]
   5:	ret
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

0000000000000010 <fma_c_f32>:
  10:	vfmadd231ss xmm0,xmm1,DWORD PTR [rdi]
  15:	ret
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

0000000000000020 <fma_fresh_f32>:
  20:	movaps xmm2,xmm1
  23:	vfmadd231ss xmm2,xmm0,DWORD PTR [rdi]
  28:	movss  DWORD PTR [rsi],xmm2
  2c:	movss  DWORD PTR [rsi+0x4],xmm0
  31:	movss  DWORD PTR [rsi+0x8],xmm1
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

0000000000000040 <fma_scaled_f32>:
  40:	vfmadd132ss xmm0,xmm1,DWORD PTR [rdi+rsi*4+0x4]
  47:	ret
  48:	int3
  49:	int3
  4a:	int3
  4b:	int3
  4c:	int3
  4d:	int3
  4e:	int3
  4f:	int3

0000000000000050 <fma_first_f32>:
  50:	movss  xmm2,DWORD PTR [rdi]
  54:	vfmadd213ss xmm0,xmm2,xmm1
  59:	ret
  5a:	int3
  5b:	int3
  5c:	int3
  5d:	int3
  5e:	int3
  5f:	int3

0000000000000060 <fma_addend_f32>:
  60:	movss  xmm2,DWORD PTR [rdi]
  64:	vfmadd132ss xmm0,xmm2,xmm1
  69:	ret
  6a:	int3
  6b:	int3
  6c:	int3
  6d:	int3
  6e:	int3
  6f:	int3

0000000000000070 <fma_store_f32>:
  70:	movss  xmm2,DWORD PTR [rdi]
  74:	movss  DWORD PTR [rdi],xmm1
  78:	vfmadd132ss xmm0,xmm1,xmm2
  7d:	ret
  7e:	int3
  7f:	int3

0000000000000080 <fma_a_f64>:
  80:	vfmadd132sd xmm0,xmm1,QWORD PTR [rdi]
  85:	ret
  86:	int3
  87:	int3
  88:	int3
  89:	int3
  8a:	int3
  8b:	int3
  8c:	int3
  8d:	int3
  8e:	int3
  8f:	int3

0000000000000090 <fma_c_f64>:
  90:	vfmadd231sd xmm0,xmm1,QWORD PTR [rdi]
  95:	ret
  96:	int3
  97:	int3
  98:	int3
  99:	int3
  9a:	int3
  9b:	int3
  9c:	int3
  9d:	int3
  9e:	int3
  9f:	int3

00000000000000a0 <fma_fresh_f64>:
  a0:	movaps xmm2,xmm1
  a3:	vfmadd231sd xmm2,xmm0,QWORD PTR [rdi]
  a8:	movsd  QWORD PTR [rsi],xmm2
  ac:	movsd  QWORD PTR [rsi+0x8],xmm0
  b1:	movsd  QWORD PTR [rsi+0x10],xmm1
  b6:	ret
  b7:	int3
  b8:	int3
  b9:	int3
  ba:	int3
  bb:	int3
  bc:	int3
  bd:	int3
  be:	int3
  bf:	int3

00000000000000c0 <fma_scaled_f64>:
  c0:	vfmadd132sd xmm0,xmm1,QWORD PTR [rdi+rsi*8+0x8]
  c7:	ret
  c8:	int3
  c9:	int3
  ca:	int3
  cb:	int3
  cc:	int3
  cd:	int3
  ce:	int3
  cf:	int3

00000000000000d0 <fma_first_f64>:
  d0:	movsd  xmm2,QWORD PTR [rdi]
  d4:	vfmadd213sd xmm0,xmm2,xmm1
  d9:	ret
  da:	int3
  db:	int3
  dc:	int3
  dd:	int3
  de:	int3
  df:	int3

00000000000000e0 <fma_addend_f64>:
  e0:	movsd  xmm2,QWORD PTR [rdi]
  e4:	vfmadd132sd xmm0,xmm2,xmm1
  e9:	ret
  ea:	int3
  eb:	int3
  ec:	int3
  ed:	int3
  ee:	int3
  ef:	int3

00000000000000f0 <fma_store_f64>:
  f0:	movsd  xmm2,QWORD PTR [rdi]
  f4:	movsd  QWORD PTR [rdi],xmm1
  f8:	vfmadd132sd xmm0,xmm1,xmm2
  fd:	ret
