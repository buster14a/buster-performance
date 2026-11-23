
out/k-head-tier1mem.o:     file format elf64-x86-64


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
  90:	xor    %eax,%eax
  92:	movl   $0x0,-0x4(%rsp)
  9a:	mov    %esi,%ecx
  9c:	and    $0x7,%rcx
  a0:	and    $0xfffffffffffffff8,%rax
  a4:	or     %rcx,%rax
  a7:	mov    %eax,-0x4(%rsp)
  ab:	lea    0x1(%rsi),%ecx
  ae:	and    $0x7f,%rcx
  b2:	and    $0xfffffffffffffc07,%rax
  b8:	shl    $0x3,%rcx
  bc:	or     %rcx,%rax
  bf:	mov    %eax,-0x4(%rsp)
  c3:	lea    0x2(%rsi),%ecx
  c6:	and    $0x1fff,%rcx
  cd:	and    $0xffffffffff8003ff,%rax
  d3:	shl    $0xa,%rcx
  d7:	or     %rcx,%rax
  da:	mov    %eax,-0x4(%rsp)
  de:	lea    0x3(%rsi),%ecx
  e1:	and    $0x1ff,%rcx
  e8:	movabs $0xffffffff007fffff,%rdx
  f2:	and    %rdx,%rax
  f5:	shl    $0x17,%rcx
  f9:	or     %rcx,%rax
  fc:	mov    %eax,-0x4(%rsp)
 100:	mov    %eax,(%rdi)
 102:	shl    $0x36,%rax
 106:	shr    $0x39,%rax
 10a:	ret
 10b:	int3
 10c:	int3
 10d:	int3
 10e:	int3
 10f:	int3

0000000000000110 <k_union>:
 110:	mov    (%rdi),%eax
 112:	mov    %rax,%rcx
 115:	shl    $0x2f,%rcx
 119:	shr    $0x2f,%rcx
 11d:	movzbl (%rdi),%edx
 120:	shl    $0x3d,%rdx
 124:	shr    $0x3d,%rdx
 128:	add    %edx,%ecx
 12a:	and    $0x1ffff,%rcx
 131:	and    $0xfffffffffffe0000,%rax
 137:	or     %rcx,%rax
 13a:	mov    %eax,(%rdi)
 13c:	mov    (%rdi),%rcx
 13f:	mov    %rcx,%rdx
 142:	shl    $0x18,%rdx
 146:	shr    $0x18,%rdx
 14a:	shl    $0x2f,%rax
 14e:	shr    $0x2f,%rax
 152:	add    %rdx,%rax
 155:	movabs $0xffffffffff,%rdx
 15f:	and    %rdx,%rax
 162:	movabs $0xffffff0000000000,%rdx
 16c:	and    %rdx,%rcx
 16f:	or     %rax,%rcx
 172:	mov    %rcx,(%rdi)
 175:	movzbl (%rdi),%eax
 178:	shl    $0x3d,%rax
 17c:	shr    $0x3d,%rax
 180:	mov    (%rdi),%ecx
 182:	shl    $0x2f,%rcx
 186:	shr    $0x2f,%rcx
 18a:	add    %ecx,%eax
 18c:	ret
 18d:	int3
 18e:	int3
 18f:	int3

0000000000000190 <k_ms>:
 190:	mov    (%rdi),%eax
 192:	mov    %rax,%rcx
 195:	shl    $0x36,%rcx
 199:	shr    $0x39,%rcx
 19d:	mov    %rax,%rdx
 1a0:	shl    $0x3d,%rdx
 1a4:	shr    $0x3d,%rdx
 1a8:	add    %edx,%ecx
 1aa:	and    $0x7f,%rcx
 1ae:	and    $0xfffffffffffffc07,%rax
 1b4:	shl    $0x3,%rcx
 1b8:	or     %rcx,%rax
 1bb:	mov    %eax,(%rdi)
 1bd:	movzwl 0x4(%rdi),%ecx
 1c1:	mov    %rcx,%rdx
 1c4:	shl    $0x3b,%rdx
 1c8:	shr    $0x3b,%rdx
 1cc:	movzbl 0x6(%rdi),%esi
 1d0:	mov    %rsi,%r8
 1d3:	shl    $0x3c,%r8
 1d7:	shr    $0x3c,%r8
 1db:	xor    %r8d,%edx
 1de:	and    $0x1f,%rdx
 1e2:	and    $0xffffffffffffffe0,%rcx
 1e6:	or     %rdx,%rcx
 1e9:	mov    %cx,0x4(%rdi)
 1ed:	mov    %rax,%rdx
 1f0:	shl    $0x3d,%rdx
 1f4:	shr    $0x3d,%rdx
 1f8:	shl    $0x36,%rax
 1fc:	shr    $0x39,%rax
 200:	add    %edx,%eax
 202:	shl    $0x3b,%rcx
 206:	shr    $0x3b,%rcx
 20a:	add    %ecx,%eax
 20c:	shl    $0x3c,%rsi
 210:	shr    $0x3c,%rsi
 214:	add    %esi,%eax
 216:	ret
 217:	int3
 218:	int3
 219:	int3
 21a:	int3
 21b:	int3
 21c:	int3
 21d:	int3
 21e:	int3
 21f:	int3

0000000000000220 <k_wide>:
 220:	mov    (%rdi),%rax
 223:	mov    %rax,%rcx
 226:	shl    $0x4,%rcx
 22a:	shr    $0x22,%rcx
 22e:	mov    %rax,%rdx
 231:	shl    $0x22,%rdx
 235:	shr    $0x22,%rdx
 239:	add    %edx,%ecx
 23b:	and    $0x3fffffff,%rcx
 242:	movabs $0xf00000003fffffff,%rdx
 24c:	and    %rdx,%rax
 24f:	shl    $0x1e,%rcx
 253:	or     %rcx,%rax
 256:	mov    %rax,(%rdi)
 259:	mov    %rax,%rcx
 25c:	shr    $0x3c,%rcx
 260:	mov    0x8(%rdi),%edx
 263:	mov    %rdx,%rsi
 266:	shl    $0x4,%rsi
 26a:	or     %rsi,%rcx
 26d:	shl    $0x22,%rcx
 271:	shr    $0x22,%rcx
 275:	mov    %rax,%rsi
 278:	shl    $0x4,%rsi
 27c:	shr    $0x22,%rsi
 280:	xor    %esi,%ecx
 282:	and    $0x3fffffff,%rcx
 289:	movabs $0xfffffffffffffff,%rsi
 293:	and    %rsi,%rax
 296:	mov    %rcx,%rsi
 299:	shl    $0x3c,%rsi
 29d:	or     %rsi,%rax
 2a0:	mov    %rax,(%rdi)
 2a3:	and    $0xfffffffffc000000,%rdx
 2aa:	shr    $0x4,%rcx
 2ae:	or     %rcx,%rdx
 2b1:	mov    %edx,0x8(%rdi)
 2b4:	mov    %rax,%rcx
 2b7:	shl    $0x22,%rcx
 2bb:	shr    $0x22,%rcx
 2bf:	mov    %rax,%rsi
 2c2:	shl    $0x4,%rsi
 2c6:	shr    $0x22,%rsi
 2ca:	add    %esi,%ecx
 2cc:	shr    $0x3c,%rax
 2d0:	shl    $0x4,%rdx
 2d4:	or     %rdx,%rax
 2d7:	shl    $0x22,%rax
 2db:	shr    $0x22,%rax
 2df:	add    %ecx,%eax
 2e1:	ret
