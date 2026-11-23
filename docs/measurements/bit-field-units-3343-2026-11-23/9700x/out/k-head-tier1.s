
out/k-head-tier1.o:     file format elf64-x86-64


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
  9e:	mov    -0x4(%rsp),%ecx
  a2:	and    $0xfffffffffffffff8,%rcx
  a6:	or     %rax,%rcx
  a9:	mov    %ecx,-0x4(%rsp)
  ad:	lea    0x1(%rsi),%eax
  b0:	and    $0x7f,%rax
  b4:	mov    -0x4(%rsp),%ecx
  b8:	and    $0xfffffffffffffc07,%rcx
  bf:	shl    $0x3,%rax
  c3:	or     %rax,%rcx
  c6:	mov    %ecx,-0x4(%rsp)
  ca:	lea    0x2(%rsi),%eax
  cd:	and    $0x1fff,%rax
  d3:	mov    -0x4(%rsp),%ecx
  d7:	and    $0xffffffffff8003ff,%rcx
  de:	shl    $0xa,%rax
  e2:	or     %rax,%rcx
  e5:	mov    %ecx,-0x4(%rsp)
  e9:	lea    0x3(%rsi),%eax
  ec:	and    $0x1ff,%rax
  f2:	mov    -0x4(%rsp),%ecx
  f6:	movabs $0xffffffff007fffff,%rdx
 100:	and    %rdx,%rcx
 103:	shl    $0x17,%rax
 107:	or     %rax,%rcx
 10a:	mov    %ecx,-0x4(%rsp)
 10e:	mov    -0x4(%rsp),%eax
 112:	mov    %eax,(%rdi)
 114:	mov    (%rdi),%eax
 116:	shl    $0x36,%rax
 11a:	shr    $0x39,%rax
 11e:	ret
 11f:	int3

0000000000000120 <k_union>:
 120:	mov    (%rdi),%eax
 122:	shl    $0x2f,%rax
 126:	shr    $0x2f,%rax
 12a:	movzbl (%rdi),%ecx
 12d:	shl    $0x3d,%rcx
 131:	shr    $0x3d,%rcx
 135:	add    %ecx,%eax
 137:	and    $0x1ffff,%rax
 13d:	mov    (%rdi),%ecx
 13f:	and    $0xfffffffffffe0000,%rcx
 146:	or     %rax,%rcx
 149:	mov    %ecx,(%rdi)
 14b:	mov    (%rdi),%rax
 14e:	shl    $0x18,%rax
 152:	shr    $0x18,%rax
 156:	mov    (%rdi),%ecx
 158:	shl    $0x2f,%rcx
 15c:	shr    $0x2f,%rcx
 160:	add    %rcx,%rax
 163:	movabs $0xffffffffff,%rcx
 16d:	and    %rcx,%rax
 170:	movabs $0xffffff0000000000,%rcx
 17a:	and    (%rdi),%rcx
 17d:	or     %rax,%rcx
 180:	mov    %rcx,(%rdi)
 183:	movzbl (%rdi),%eax
 186:	shl    $0x3d,%rax
 18a:	shr    $0x3d,%rax
 18e:	mov    (%rdi),%ecx
 190:	shl    $0x2f,%rcx
 194:	shr    $0x2f,%rcx
 198:	add    %ecx,%eax
 19a:	ret
 19b:	int3
 19c:	int3
 19d:	int3
 19e:	int3
 19f:	int3

00000000000001a0 <k_ms>:
 1a0:	mov    (%rdi),%eax
 1a2:	shl    $0x36,%rax
 1a6:	shr    $0x39,%rax
 1aa:	mov    (%rdi),%ecx
 1ac:	shl    $0x3d,%rcx
 1b0:	shr    $0x3d,%rcx
 1b4:	add    %ecx,%eax
 1b6:	and    $0x7f,%rax
 1ba:	mov    (%rdi),%ecx
 1bc:	and    $0xfffffffffffffc07,%rcx
 1c3:	shl    $0x3,%rax
 1c7:	or     %rax,%rcx
 1ca:	mov    %ecx,(%rdi)
 1cc:	movzwl 0x4(%rdi),%eax
 1d0:	shl    $0x3b,%rax
 1d4:	shr    $0x3b,%rax
 1d8:	movzbl 0x6(%rdi),%ecx
 1dc:	shl    $0x3c,%rcx
 1e0:	shr    $0x3c,%rcx
 1e4:	xor    %ecx,%eax
 1e6:	and    $0x1f,%rax
 1ea:	movzwl 0x4(%rdi),%ecx
 1ee:	and    $0xffffffffffffffe0,%rcx
 1f2:	or     %rax,%rcx
 1f5:	mov    %cx,0x4(%rdi)
 1f9:	mov    (%rdi),%eax
 1fb:	shl    $0x3d,%rax
 1ff:	shr    $0x3d,%rax
 203:	mov    (%rdi),%ecx
 205:	shl    $0x36,%rcx
 209:	shr    $0x39,%rcx
 20d:	add    %ecx,%eax
 20f:	movzwl 0x4(%rdi),%ecx
 213:	shl    $0x3b,%rcx
 217:	shr    $0x3b,%rcx
 21b:	add    %ecx,%eax
 21d:	movzbl 0x6(%rdi),%ecx
 221:	shl    $0x3c,%rcx
 225:	shr    $0x3c,%rcx
 229:	add    %ecx,%eax
 22b:	ret
 22c:	int3
 22d:	int3
 22e:	int3
 22f:	int3

0000000000000230 <k_wide>:
 230:	mov    (%rdi),%rax
 233:	shl    $0x4,%rax
 237:	shr    $0x22,%rax
 23b:	mov    (%rdi),%rcx
 23e:	shl    $0x22,%rcx
 242:	shr    $0x22,%rcx
 246:	add    %ecx,%eax
 248:	and    $0x3fffffff,%rax
 24e:	movabs $0xf00000003fffffff,%rcx
 258:	and    (%rdi),%rcx
 25b:	shl    $0x1e,%rax
 25f:	or     %rax,%rcx
 262:	mov    %rcx,(%rdi)
 265:	mov    (%rdi),%rax
 268:	shr    $0x3c,%rax
 26c:	mov    0x8(%rdi),%ecx
 26f:	shl    $0x4,%rcx
 273:	or     %rcx,%rax
 276:	shl    $0x22,%rax
 27a:	shr    $0x22,%rax
 27e:	mov    (%rdi),%rcx
 281:	shl    $0x4,%rcx
 285:	shr    $0x22,%rcx
 289:	xor    %ecx,%eax
 28b:	and    $0x3fffffff,%rax
 291:	movabs $0xfffffffffffffff,%rcx
 29b:	and    (%rdi),%rcx
 29e:	mov    %rax,%rdx
 2a1:	shl    $0x3c,%rdx
 2a5:	or     %rdx,%rcx
 2a8:	mov    %rcx,(%rdi)
 2ab:	mov    0x8(%rdi),%ecx
 2ae:	and    $0xfffffffffc000000,%rcx
 2b5:	shr    $0x4,%rax
 2b9:	or     %rax,%rcx
 2bc:	mov    %ecx,0x8(%rdi)
 2bf:	mov    (%rdi),%rax
 2c2:	shl    $0x22,%rax
 2c6:	shr    $0x22,%rax
 2ca:	mov    (%rdi),%rcx
 2cd:	shl    $0x4,%rcx
 2d1:	shr    $0x22,%rcx
 2d5:	add    %ecx,%eax
 2d7:	mov    (%rdi),%rcx
 2da:	shr    $0x3c,%rcx
 2de:	mov    0x8(%rdi),%edx
 2e1:	shl    $0x4,%rdx
 2e5:	or     %rdx,%rcx
 2e8:	shl    $0x22,%rcx
 2ec:	shr    $0x22,%rcx
 2f0:	add    %ecx,%eax
 2f2:	ret
