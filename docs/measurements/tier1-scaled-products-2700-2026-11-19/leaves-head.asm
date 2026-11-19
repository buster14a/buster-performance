
object:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <scaled2>:
   0:	lea    (%rdi,%rsi,2),%rax
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

0000000000000010 <scaled4>:
  10:	lea    (%rdi,%rsi,4),%rax
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

0000000000000020 <scaled8>:
  20:	lea    (%rdi,%rsi,8),%rax
  24:	ret
  25:	int3
  26:	int3
  27:	int3
  28:	int3
  29:	int3
  2a:	int3
  2b:	int3
  2c:	int3
  2d:	int3
  2e:	int3
  2f:	int3

0000000000000030 <scaled32>:
  30:	lea    (%rdi,%rsi,4),%eax
  33:	ret
  34:	int3
  35:	int3
  36:	int3
  37:	int3
  38:	int3
  39:	int3
  3a:	int3
  3b:	int3
  3c:	int3
  3d:	int3
  3e:	int3
  3f:	int3

0000000000000040 <shifted>:
  40:	lea    (%rdi,%rsi,4),%rax
  44:	ret
  45:	int3
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

0000000000000050 <large>:
  50:	shl    $0x4,%rsi
  54:	lea    (%rdi,%rsi,1),%rax
  58:	ret
  59:	int3
  5a:	int3
  5b:	int3
  5c:	int3
  5d:	int3
  5e:	int3
  5f:	int3

0000000000000060 <shared>:
  60:	shl    $0x2,%rsi
  64:	mov    %rsi,(%rdx)
  67:	lea    (%rdi,%rsi,1),%rax
  6b:	ret
