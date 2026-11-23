
out/k-base-tier1mem.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_bits>:
   0:	mov    (%rdi),%eax
   2:	mov    %rax,%rcx
   5:	shl    $0x36,%rcx
   9:	shr    $0x39,%rcx
   d:	mov    %rax,%rdx
  10:	shl    $0x3d,%rdx
  14:	shr    $0x3d,%rdx
  18:	add    %edx,%ecx
  1a:	and    $0x7f,%rcx
  1e:	and    $0xfffffffffffffc07,%rax
  24:	shl    $0x3,%rcx
  28:	or     %rcx,%rax
  2b:	mov    %eax,(%rdi)
  2d:	mov    %rax,%rcx
  30:	shl    $0x29,%rcx
  34:	shr    $0x33,%rcx
  38:	mov    %rax,%rdx
  3b:	shl    $0x20,%rdx
  3f:	shr    $0x37,%rdx
  43:	xor    %edx,%ecx
  45:	and    $0x1fff,%rcx
  4c:	and    $0xffffffffff8003ff,%rax
  52:	shl    $0xa,%rcx
  56:	or     %rcx,%rax
  59:	mov    %eax,(%rdi)
  5b:	mov    %rax,%rcx
  5e:	shl    $0x3d,%rcx
  62:	shr    $0x3d,%rcx
  66:	mov    %rax,%rdx
  69:	shl    $0x36,%rdx
  6d:	shr    $0x39,%rdx
  71:	add    %edx,%ecx
  73:	mov    %rax,%rdx
  76:	shl    $0x29,%rdx
  7a:	shr    $0x33,%rdx
  7e:	add    %edx,%ecx
  80:	shl    $0x20,%rax
  84:	shr    $0x37,%rax
  88:	add    %ecx,%eax
  8a:	ret
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
 115:	shl    $0x36,%rax
 119:	shr    $0x39,%rax
 11d:	ret
 11e:	int3
 11f:	int3

0000000000000120 <k_union>:
 120:	movzwl (%rdi),%eax
 123:	movzbl 0x2(%rdi),%ecx
 127:	mov    %rcx,%rdx
 12a:	shl    $0x10,%rdx
 12e:	or     %rax,%rdx
 131:	shl    $0x2f,%rdx
 135:	shr    $0x2f,%rdx
 139:	movzbl (%rdi),%esi
 13c:	shl    $0x3d,%rsi
 140:	shr    $0x3d,%rsi
 144:	add    %esi,%edx
 146:	and    $0x1ffff,%rdx
 14d:	shl    $0x10,%rcx
 151:	or     %rcx,%rax
 154:	and    $0xfffffffffffe0000,%rax
 15a:	or     %rdx,%rax
 15d:	mov    %ax,(%rdi)
 160:	shr    $0x10,%rax
 164:	mov    %al,0x2(%rdi)
 167:	mov    (%rdi),%ecx
 169:	movzbl 0x4(%rdi),%edx
 16d:	mov    %rdx,%rsi
 170:	shl    $0x20,%rsi
 174:	or     %rcx,%rsi
 177:	shl    $0x18,%rsi
 17b:	shr    $0x18,%rsi
 17f:	movzwl (%rdi),%r8d
 183:	shl    $0x10,%rax
 187:	or     %rax,%r8
 18a:	shl    $0x2f,%r8
 18e:	shr    $0x2f,%r8
 192:	lea    (%rsi,%r8,1),%rax
 196:	movabs $0xffffffffff,%rsi
 1a0:	and    %rsi,%rax
 1a3:	shl    $0x20,%rdx
 1a7:	or     %rdx,%rcx
 1aa:	movabs $0xffffff0000000000,%rdx
 1b4:	and    %rdx,%rcx
 1b7:	or     %rax,%rcx
 1ba:	mov    %ecx,(%rdi)
 1bc:	shr    $0x20,%rcx
 1c0:	mov    %cl,0x4(%rdi)
 1c3:	movzbl (%rdi),%eax
 1c6:	shl    $0x3d,%rax
 1ca:	shr    $0x3d,%rax
 1ce:	movzwl (%rdi),%ecx
 1d1:	movzbl 0x2(%rdi),%edx
 1d5:	shl    $0x10,%rdx
 1d9:	or     %rdx,%rcx
 1dc:	shl    $0x2f,%rcx
 1e0:	shr    $0x2f,%rcx
 1e4:	add    %ecx,%eax
 1e6:	ret
 1e7:	int3
 1e8:	int3
 1e9:	int3
 1ea:	int3
 1eb:	int3
 1ec:	int3
 1ed:	int3
 1ee:	int3
 1ef:	int3

00000000000001f0 <k_ms>:
 1f0:	movzwl (%rdi),%eax
 1f3:	mov    %rax,%rcx
 1f6:	shl    $0x36,%rcx
 1fa:	shr    $0x39,%rcx
 1fe:	movzbl (%rdi),%edx
 201:	shl    $0x3d,%rdx
 205:	shr    $0x3d,%rdx
 209:	add    %edx,%ecx
 20b:	and    $0x7f,%rcx
 20f:	and    $0xfffffffffffffc07,%rax
 215:	shl    $0x3,%rcx
 219:	or     %rcx,%rax
 21c:	mov    %ax,(%rdi)
 21f:	movzbl 0x4(%rdi),%eax
 223:	mov    %rax,%rcx
 226:	shl    $0x3b,%rcx
 22a:	shr    $0x3b,%rcx
 22e:	movzbl 0x6(%rdi),%edx
 232:	mov    %rdx,%rsi
 235:	shl    $0x3c,%rsi
 239:	shr    $0x3c,%rsi
 23d:	xor    %esi,%ecx
 23f:	and    $0x1f,%rcx
 243:	and    $0xffffffffffffffe0,%rax
 247:	or     %rcx,%rax
 24a:	mov    %al,0x4(%rdi)
 24d:	movzbl (%rdi),%ecx
 250:	shl    $0x3d,%rcx
 254:	shr    $0x3d,%rcx
 258:	movzwl (%rdi),%esi
 25b:	shl    $0x36,%rsi
 25f:	shr    $0x39,%rsi
 263:	add    %esi,%ecx
 265:	shl    $0x3b,%rax
 269:	shr    $0x3b,%rax
 26d:	add    %ecx,%eax
 26f:	shl    $0x3c,%rdx
 273:	shr    $0x3c,%rdx
 277:	add    %edx,%eax
 279:	ret
 27a:	int3
 27b:	int3
 27c:	int3
 27d:	int3
 27e:	int3
 27f:	int3

0000000000000280 <k_wide>:
 280:	mov    0x3(%rdi),%eax
 283:	movzbl 0x7(%rdi),%ecx
 287:	mov    %rcx,%rdx
 28a:	shl    $0x20,%rdx
 28e:	or     %rax,%rdx
 291:	shl    $0x1c,%rdx
 295:	shr    $0x22,%rdx
 299:	mov    (%rdi),%esi
 29b:	shl    $0x22,%rsi
 29f:	shr    $0x22,%rsi
 2a3:	add    %esi,%edx
 2a5:	and    $0x3fffffff,%rdx
 2ac:	shl    $0x20,%rcx
 2b0:	or     %rcx,%rax
 2b3:	movabs $0xfffffff00000003f,%rcx
 2bd:	and    %rcx,%rax
 2c0:	shl    $0x6,%rdx
 2c4:	or     %rdx,%rax
 2c7:	mov    %eax,0x3(%rdi)
 2ca:	shr    $0x20,%rax
 2ce:	mov    %al,0x7(%rdi)
 2d1:	mov    0x7(%rdi),%ecx
 2d4:	movzbl 0xb(%rdi),%edx
 2d8:	mov    %rdx,%rsi
 2db:	shl    $0x20,%rsi
 2df:	or     %rcx,%rsi
 2e2:	shl    $0x1e,%rsi
 2e6:	shr    $0x22,%rsi
 2ea:	mov    0x3(%rdi),%r8d
 2ee:	shl    $0x20,%rax
 2f2:	or     %rax,%r8
 2f5:	shl    $0x1c,%r8
 2f9:	shr    $0x22,%r8
 2fd:	xor    %r8d,%esi
 300:	and    $0x3fffffff,%rsi
 307:	shl    $0x20,%rdx
 30b:	or     %rdx,%rcx
 30e:	movabs $0xfffffffc0000000f,%rax
 318:	and    %rax,%rcx
 31b:	shl    $0x4,%rsi
 31f:	or     %rsi,%rcx
 322:	mov    %ecx,0x7(%rdi)
 325:	shr    $0x20,%rcx
 329:	mov    %cl,0xb(%rdi)
 32c:	mov    (%rdi),%eax
 32e:	shl    $0x22,%rax
 332:	shr    $0x22,%rax
 336:	mov    0x3(%rdi),%edx
 339:	movzbl 0x7(%rdi),%esi
 33d:	shl    $0x20,%rsi
 341:	or     %rsi,%rdx
 344:	shl    $0x1c,%rdx
 348:	shr    $0x22,%rdx
 34c:	add    %edx,%eax
 34e:	mov    0x7(%rdi),%edx
 351:	shl    $0x20,%rcx
 355:	or     %rcx,%rdx
 358:	shl    $0x1e,%rdx
 35c:	shr    $0x22,%rdx
 360:	add    %edx,%eax
 362:	ret
