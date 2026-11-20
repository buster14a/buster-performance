
base-leaves.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <fma_a_f32>:
   0:	movss  xmm2,DWORD PTR [rdi]
   4:	vfmadd132ss xmm0,xmm1,xmm2
   9:	ret
   a:	int3
   b:	int3
   c:	int3
   d:	int3
   e:	int3
   f:	int3

0000000000000010 <fma_c_f32>:
  10:	movss  xmm2,DWORD PTR [rdi]
  14:	vfmadd231ss xmm0,xmm1,xmm2
  19:	ret
  1a:	int3
  1b:	int3
  1c:	int3
  1d:	int3
  1e:	int3
  1f:	int3

0000000000000020 <fma_fresh_f32>:
  20:	movss  xmm2,DWORD PTR [rdi]
  24:	vfmadd213ss xmm2,xmm0,xmm1
  29:	movss  DWORD PTR [rsi],xmm2
  2d:	movss  DWORD PTR [rsi+0x4],xmm0
  32:	movss  DWORD PTR [rsi+0x8],xmm1
  37:	ret
  38:	int3
  39:	int3
  3a:	int3
  3b:	int3
  3c:	int3
  3d:	int3
  3e:	int3
  3f:	int3

0000000000000040 <fma_scaled_f32>:
  40:	movss  xmm2,DWORD PTR [rdi+rsi*4+0x4]
  46:	vfmadd132ss xmm0,xmm1,xmm2
  4b:	ret
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
  80:	movsd  xmm2,QWORD PTR [rdi]
  84:	vfmadd132sd xmm0,xmm1,xmm2
  89:	ret
  8a:	int3
  8b:	int3
  8c:	int3
  8d:	int3
  8e:	int3
  8f:	int3

0000000000000090 <fma_c_f64>:
  90:	movsd  xmm2,QWORD PTR [rdi]
  94:	vfmadd231sd xmm0,xmm1,xmm2
  99:	ret
  9a:	int3
  9b:	int3
  9c:	int3
  9d:	int3
  9e:	int3
  9f:	int3

00000000000000a0 <fma_fresh_f64>:
  a0:	movsd  xmm2,QWORD PTR [rdi]
  a4:	vfmadd213sd xmm2,xmm0,xmm1
  a9:	movsd  QWORD PTR [rsi],xmm2
  ad:	movsd  QWORD PTR [rsi+0x8],xmm0
  b2:	movsd  QWORD PTR [rsi+0x10],xmm1
  b7:	ret
  b8:	int3
  b9:	int3
  ba:	int3
  bb:	int3
  bc:	int3
  bd:	int3
  be:	int3
  bf:	int3

00000000000000c0 <fma_scaled_f64>:
  c0:	movsd  xmm2,QWORD PTR [rdi+rsi*8+0x8]
  c6:	vfmadd132sd xmm0,xmm1,xmm2
  cb:	ret
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
