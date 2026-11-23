
out/k-base-tier1.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_bits>:
   0:	mov    (%rdi),%eax
   2:	shl    $0x36,%rax
   6:	shr    $0x39,%rax
   a:	mov    (%rdi),%ecx
   c:	shl    $0x3d,%rcx
  10:	shr    $0x3d,%rcx
  14:	add    %ecx,%eax
  16:	and    $0x7f,%rax
  1a:	mov    (%rdi),%ecx
  1c:	and    $0xfffffffffffffc07,%rcx
  23:	shl    $0x3,%rax
  27:	or     %rax,%rcx
  2a:	mov    %ecx,(%rdi)
  2c:	mov    (%rdi),%eax
  2e:	shl    $0x29,%rax
  32:	shr    $0x33,%rax
  36:	mov    (%rdi),%ecx
  38:	shl    $0x20,%rcx
  3c:	shr    $0x37,%rcx
  40:	xor    %ecx,%eax
  42:	and    $0x1fff,%rax
  48:	mov    (%rdi),%ecx
  4a:	and    $0xffffffffff8003ff,%rcx
  51:	shl    $0xa,%rax
  55:	or     %rax,%rcx
  58:	mov    %ecx,(%rdi)
  5a:	mov    (%rdi),%eax
  5c:	shl    $0x3d,%rax
  60:	shr    $0x3d,%rax
  64:	mov    (%rdi),%ecx
  66:	shl    $0x36,%rcx
  6a:	shr    $0x39,%rcx
  6e:	add    %ecx,%eax
  70:	mov    (%rdi),%ecx
  72:	shl    $0x29,%rcx
  76:	shr    $0x33,%rcx
  7a:	add    %ecx,%eax
  7c:	mov    (%rdi),%ecx
  7e:	shl    $0x20,%rcx
  82:	shr    $0x37,%rcx
  86:	add    %ecx,%eax
  88:	ret
  89:	int3
  8a:	int3
  8b:	int3
  8c:	int3
  8d:	int3
  8e:	int3
  8f:	int3

0000000000000090 <k_init>:
  90:	movl   $0x0,-0x4(%rsp)
  98:	mov    %esi,%eax
  9a:	and    $0x7,%rax
  9e:	movzbl -0x4(%rsp),%ecx
  a3:	and    $0xfffffffffffffff8,%rcx
  a7:	or     %rax,%rcx
  aa:	mov    %cl,-0x4(%rsp)
  ae:	lea    0x1(%rsi),%eax
  b1:	and    $0x7f,%rax
  b5:	movzwl -0x4(%rsp),%ecx
  ba:	and    $0xfffffffffffffc07,%rcx
  c1:	shl    $0x3,%rax
  c5:	or     %rax,%rcx
  c8:	mov    %cx,-0x4(%rsp)
  cd:	lea    0x2(%rsi),%eax
  d0:	and    $0x1fff,%rax
  d6:	movzwl -0x3(%rsp),%ecx
  db:	and    $0xffffffffffff8003,%rcx
  e2:	shl    $0x2,%rax
  e6:	or     %rax,%rcx
  e9:	mov    %cx,-0x3(%rsp)
  ee:	lea    0x3(%rsi),%eax
  f1:	and    $0x1ff,%rax
  f7:	movzwl -0x2(%rsp),%ecx
  fc:	and    $0xffffffffffff007f,%rcx
 103:	shl    $0x7,%rax
 107:	or     %rax,%rcx
 10a:	mov    %cx,-0x2(%rsp)
 10f:	mov    -0x4(%rsp),%eax
 113:	mov    %eax,(%rdi)
 115:	mov    (%rdi),%eax
 117:	shl    $0x36,%rax
 11b:	shr    $0x39,%rax
 11f:	ret

0000000000000120 <k_union>:
 120:	movzwl (%rdi),%eax
 123:	movzbl 0x2(%rdi),%ecx
 127:	shl    $0x10,%rcx
 12b:	or     %rcx,%rax
 12e:	shl    $0x2f,%rax
 132:	shr    $0x2f,%rax
 136:	movzbl (%rdi),%ecx
 139:	shl    $0x3d,%rcx
 13d:	shr    $0x3d,%rcx
 141:	add    %ecx,%eax
 143:	and    $0x1ffff,%rax
 149:	movzwl (%rdi),%ecx
 14c:	movzbl 0x2(%rdi),%edx
 150:	shl    $0x10,%rdx
 154:	or     %rdx,%rcx
 157:	and    $0xfffffffffffe0000,%rcx
 15e:	or     %rax,%rcx
 161:	mov    %cx,(%rdi)
 164:	shr    $0x10,%rcx
 168:	mov    %cl,0x2(%rdi)
 16b:	mov    (%rdi),%eax
 16d:	movzbl 0x4(%rdi),%ecx
 171:	shl    $0x20,%rcx
 175:	or     %rcx,%rax
 178:	shl    $0x18,%rax
 17c:	shr    $0x18,%rax
 180:	movzwl (%rdi),%ecx
 183:	movzbl 0x2(%rdi),%edx
 187:	shl    $0x10,%rdx
 18b:	or     %rdx,%rcx
 18e:	shl    $0x2f,%rcx
 192:	shr    $0x2f,%rcx
 196:	add    %rcx,%rax
 199:	movabs $0xffffffffff,%rcx
 1a3:	and    %rcx,%rax
 1a6:	mov    (%rdi),%ecx
 1a8:	movzbl 0x4(%rdi),%edx
 1ac:	shl    $0x20,%rdx
 1b0:	or     %rdx,%rcx
 1b3:	movabs $0xffffff0000000000,%rdx
 1bd:	and    %rdx,%rcx
 1c0:	or     %rax,%rcx
 1c3:	mov    %ecx,(%rdi)
 1c5:	shr    $0x20,%rcx
 1c9:	mov    %cl,0x4(%rdi)
 1cc:	movzbl (%rdi),%eax
 1cf:	shl    $0x3d,%rax
 1d3:	shr    $0x3d,%rax
 1d7:	movzwl (%rdi),%ecx
 1da:	movzbl 0x2(%rdi),%edx
 1de:	shl    $0x10,%rdx
 1e2:	or     %rdx,%rcx
 1e5:	shl    $0x2f,%rcx
 1e9:	shr    $0x2f,%rcx
 1ed:	add    %ecx,%eax
 1ef:	ret

00000000000001f0 <k_ms>:
 1f0:	movzwl (%rdi),%eax
 1f3:	shl    $0x36,%rax
 1f7:	shr    $0x39,%rax
 1fb:	movzbl (%rdi),%ecx
 1fe:	shl    $0x3d,%rcx
 202:	shr    $0x3d,%rcx
 206:	add    %ecx,%eax
 208:	and    $0x7f,%rax
 20c:	movzwl (%rdi),%ecx
 20f:	and    $0xfffffffffffffc07,%rcx
 216:	shl    $0x3,%rax
 21a:	or     %rax,%rcx
 21d:	mov    %cx,(%rdi)
 220:	movzbl 0x4(%rdi),%eax
 224:	shl    $0x3b,%rax
 228:	shr    $0x3b,%rax
 22c:	movzbl 0x6(%rdi),%ecx
 230:	shl    $0x3c,%rcx
 234:	shr    $0x3c,%rcx
 238:	xor    %ecx,%eax
 23a:	and    $0x1f,%rax
 23e:	movzbl 0x4(%rdi),%ecx
 242:	and    $0xffffffffffffffe0,%rcx
 246:	or     %rax,%rcx
 249:	mov    %cl,0x4(%rdi)
 24c:	movzbl (%rdi),%eax
 24f:	shl    $0x3d,%rax
 253:	shr    $0x3d,%rax
 257:	movzwl (%rdi),%ecx
 25a:	shl    $0x36,%rcx
 25e:	shr    $0x39,%rcx
 262:	add    %ecx,%eax
 264:	movzbl 0x4(%rdi),%ecx
 268:	shl    $0x3b,%rcx
 26c:	shr    $0x3b,%rcx
 270:	add    %ecx,%eax
 272:	movzbl 0x6(%rdi),%ecx
 276:	shl    $0x3c,%rcx
 27a:	shr    $0x3c,%rcx
 27e:	add    %ecx,%eax
 280:	ret
 281:	int3
 282:	int3
 283:	int3
 284:	int3
 285:	int3
 286:	int3
 287:	int3
 288:	int3
 289:	int3
 28a:	int3
 28b:	int3
 28c:	int3
 28d:	int3
 28e:	int3
 28f:	int3

0000000000000290 <k_wide>:
 290:	mov    0x3(%rdi),%eax
 293:	movzbl 0x7(%rdi),%ecx
 297:	shl    $0x20,%rcx
 29b:	or     %rcx,%rax
 29e:	shl    $0x1c,%rax
 2a2:	shr    $0x22,%rax
 2a6:	mov    (%rdi),%ecx
 2a8:	shl    $0x22,%rcx
 2ac:	shr    $0x22,%rcx
 2b0:	add    %ecx,%eax
 2b2:	and    $0x3fffffff,%rax
 2b8:	mov    0x3(%rdi),%ecx
 2bb:	movzbl 0x7(%rdi),%edx
 2bf:	shl    $0x20,%rdx
 2c3:	or     %rdx,%rcx
 2c6:	movabs $0xfffffff00000003f,%rdx
 2d0:	and    %rdx,%rcx
 2d3:	shl    $0x6,%rax
 2d7:	or     %rax,%rcx
 2da:	mov    %ecx,0x3(%rdi)
 2dd:	shr    $0x20,%rcx
 2e1:	mov    %cl,0x7(%rdi)
 2e4:	mov    0x7(%rdi),%eax
 2e7:	movzbl 0xb(%rdi),%ecx
 2eb:	shl    $0x20,%rcx
 2ef:	or     %rcx,%rax
 2f2:	shl    $0x1e,%rax
 2f6:	shr    $0x22,%rax
 2fa:	mov    0x3(%rdi),%ecx
 2fd:	movzbl 0x7(%rdi),%edx
 301:	shl    $0x20,%rdx
 305:	or     %rdx,%rcx
 308:	shl    $0x1c,%rcx
 30c:	shr    $0x22,%rcx
 310:	xor    %ecx,%eax
 312:	and    $0x3fffffff,%rax
 318:	mov    0x7(%rdi),%ecx
 31b:	movzbl 0xb(%rdi),%edx
 31f:	shl    $0x20,%rdx
 323:	or     %rdx,%rcx
 326:	movabs $0xfffffffc0000000f,%rdx
 330:	and    %rdx,%rcx
 333:	shl    $0x4,%rax
 337:	or     %rax,%rcx
 33a:	mov    %ecx,0x7(%rdi)
 33d:	shr    $0x20,%rcx
 341:	mov    %cl,0xb(%rdi)
 344:	mov    (%rdi),%eax
 346:	shl    $0x22,%rax
 34a:	shr    $0x22,%rax
 34e:	mov    0x3(%rdi),%ecx
 351:	movzbl 0x7(%rdi),%edx
 355:	shl    $0x20,%rdx
 359:	or     %rdx,%rcx
 35c:	shl    $0x1c,%rcx
 360:	shr    $0x22,%rcx
 364:	add    %ecx,%eax
 366:	mov    0x7(%rdi),%ecx
 369:	movzbl 0xb(%rdi),%edx
 36d:	shl    $0x20,%rdx
 371:	or     %rdx,%rcx
 374:	shl    $0x1e,%rcx
 378:	shr    $0x22,%rcx
 37c:	add    %ecx,%eax
 37e:	ret
