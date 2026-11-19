
/dev/shm/claude-fix3028b/abs3-head.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <f01>:
   0:	mov    $0x1000,%eax
   5:	mov    (%rax),%eax
   7:	test   %eax,%eax
   9:	je     12 <f01+0x12>
   b:	mov    $0x1,%eax
  10:	jmp    14 <f01+0x14>
  12:	xor    %eax,%eax
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

0000000000000020 <f02>:
  20:	mov    $0x1000,%eax
  25:	mov    (%rax),%eax
  27:	test   %eax,%eax
  29:	je     32 <f02+0x12>
  2b:	mov    $0x1,%eax
  30:	jmp    34 <f02+0x14>
  32:	xor    %eax,%eax
  34:	ret
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

0000000000000040 <f03>:
  40:	mov    $0x1000,%eax
  45:	mov    (%rax),%eax
  47:	test   %eax,%eax
  49:	je     56 <f03+0x16>
  4b:	test   %edi,%edi
  4d:	je     56 <f03+0x16>
  4f:	mov    $0x1,%eax
  54:	jmp    58 <f03+0x18>
  56:	xor    %eax,%eax
  58:	ret
  59:	int3
  5a:	int3
  5b:	int3
  5c:	int3
  5d:	int3
  5e:	int3
  5f:	int3

0000000000000060 <f04>:
  60:	test   %edi,%edi
  62:	je     76 <f04+0x16>
  64:	mov    $0x1000,%eax
  69:	mov    (%rax),%eax
  6b:	test   %eax,%eax
  6d:	je     76 <f04+0x16>
  6f:	mov    $0x1,%eax
  74:	jmp    78 <f04+0x18>
  76:	xor    %eax,%eax
  78:	ret
  79:	int3
  7a:	int3
  7b:	int3
  7c:	int3
  7d:	int3
  7e:	int3
  7f:	int3

0000000000000080 <f05>:
  80:	mov    $0x1000,%eax
  85:	mov    (%rax),%eax
  87:	test   %eax,%eax
  89:	jne    8f <f05+0xf>
  8b:	test   %edi,%edi
  8d:	je     96 <f05+0x16>
  8f:	mov    $0x1,%eax
  94:	jmp    98 <f05+0x18>
  96:	xor    %eax,%eax
  98:	ret
  99:	int3
  9a:	int3
  9b:	int3
  9c:	int3
  9d:	int3
  9e:	int3
  9f:	int3

00000000000000a0 <f06>:
  a0:	mov    $0x1000,%eax
  a5:	mov    (%rax),%eax
  a7:	test   %eax,%eax
  a9:	je     b2 <f06+0x12>
  ab:	mov    $0x3,%eax
  b0:	jmp    b7 <f06+0x17>
  b2:	mov    $0x4,%eax
  b7:	ret
  b8:	int3
  b9:	int3
  ba:	int3
  bb:	int3
  bc:	int3
  bd:	int3
  be:	int3
  bf:	int3

00000000000000c0 <f07>:
  c0:	mov    $0x1000,%eax
  c5:	mov    (%rax),%eax
  c7:	test   %eax,%eax
  c9:	je     da <f07+0x1a>
  cb:	mov    $0x1,%eax
  d0:	test   %eax,%eax
  d2:	setne  %al
  d5:	movzbl %al,%eax
  d8:	jmp    dc <f07+0x1c>
  da:	xor    %eax,%eax
  dc:	ret
  dd:	int3
  de:	int3
  df:	int3

00000000000000e0 <f08>:
  e0:	mov    $0x1000,%eax
  e5:	mov    (%rax),%eax
  e7:	test   %eax,%eax
  e9:	sete   %al
  ec:	movzbl %al,%eax
  ef:	ret

00000000000000f0 <f09>:
  f0:	mov    $0x1000,%eax
  f5:	mov    (%rax),%eax
  f7:	test   %eax,%eax
  f9:	je     fd <f09+0xd>
  fb:	jmp    f0 <f09>
  fd:	xor    %eax,%eax
  ff:	ret

0000000000000100 <f10>:
 100:	xor    %edx,%edx
 102:	mov    %edx,%eax
 104:	mov    %rax,%rcx
 107:	inc    %ecx
 109:	mov    %ecx,%edx
 10b:	mov    $0x1000,%eax
 110:	mov    (%rax),%eax
 112:	test   %eax,%eax
 114:	jne    102 <f10+0x2>
 116:	mov    %edx,%eax
 118:	ret
 119:	int3
 11a:	int3
 11b:	int3
 11c:	int3
 11d:	int3
 11e:	int3
 11f:	int3

0000000000000120 <f11>:
 120:	xor    %edx,%edx
 122:	mov    $0x1000,%eax
 127:	mov    (%rax),%eax
 129:	test   %eax,%eax
 12b:	je     138 <f11+0x18>
 12d:	mov    %edx,%eax
 12f:	mov    %rax,%rcx
 132:	inc    %ecx
 134:	mov    %ecx,%edx
 136:	jmp    122 <f11+0x2>
 138:	mov    %edx,%eax
 13a:	ret
 13b:	int3
 13c:	int3
 13d:	int3
 13e:	int3
 13f:	int3

0000000000000140 <f12>:
 140:	mov    $0x1000,%eax
 145:	mov    (%rax),%eax
 147:	test   %eax,%eax
 149:	setne  %al
 14c:	movzbl %al,%eax
 14f:	ret

0000000000000150 <f13>:
 150:	mov    $0x1000,%eax
 155:	mov    (%rax),%eax
 157:	test   %eax,%eax
 159:	setne  %al
 15c:	movzbl %al,%eax
 15f:	movzbl %al,%eax
 162:	ret
 163:	int3
 164:	int3
 165:	int3
 166:	int3
 167:	int3
 168:	int3
 169:	int3
 16a:	int3
 16b:	int3
 16c:	int3
 16d:	int3
 16e:	int3
 16f:	int3

0000000000000170 <f14>:
 170:	mov    $0x1000,%eax
 175:	mov    0x4(%rax),%eax
 178:	test   %eax,%eax
 17a:	je     183 <f14+0x13>
 17c:	mov    $0x1,%eax
 181:	jmp    185 <f14+0x15>
 183:	xor    %eax,%eax
 185:	ret
 186:	int3
 187:	int3
 188:	int3
 189:	int3
 18a:	int3
 18b:	int3
 18c:	int3
 18d:	int3
 18e:	int3
 18f:	int3

0000000000000190 <f15>:
 190:	mov    $0x1000,%eax
 195:	mov    0xc(%rax),%eax
 198:	test   %eax,%eax
 19a:	je     1a3 <f15+0x13>
 19c:	mov    $0x1,%eax
 1a1:	jmp    1a5 <f15+0x15>
 1a3:	xor    %eax,%eax
 1a5:	ret
 1a6:	int3
 1a7:	int3
 1a8:	int3
 1a9:	int3
 1aa:	int3
 1ab:	int3
 1ac:	int3
 1ad:	int3
 1ae:	int3
 1af:	int3

00000000000001b0 <f16>:
 1b0:	xor    %eax,%eax
 1b2:	mov    (%rax),%eax
 1b4:	test   %eax,%eax
 1b6:	je     1bf <f16+0xf>
 1b8:	mov    $0x1,%eax
 1bd:	jmp    1c1 <f16+0x11>
 1bf:	xor    %eax,%eax
 1c1:	ret
 1c2:	int3
 1c3:	int3
 1c4:	int3
 1c5:	int3
 1c6:	int3
 1c7:	int3
 1c8:	int3
 1c9:	int3
 1ca:	int3
 1cb:	int3
 1cc:	int3
 1cd:	int3
 1ce:	int3
 1cf:	int3

00000000000001d0 <f17>:
 1d0:	mov    $0x1000,%eax
 1d5:	movsbl (%rax),%eax
 1d8:	movsbl %al,%eax
 1db:	test   %eax,%eax
 1dd:	je     1e6 <f17+0x16>
 1df:	mov    $0x1,%eax
 1e4:	jmp    1e8 <f17+0x18>
 1e6:	xor    %eax,%eax
 1e8:	ret
 1e9:	int3
 1ea:	int3
 1eb:	int3
 1ec:	int3
 1ed:	int3
 1ee:	int3
 1ef:	int3

00000000000001f0 <f18>:
 1f0:	mov    $0x1000,%eax
 1f5:	mov    (%rax),%rax
 1f8:	test   %rax,%rax
 1fb:	je     204 <f18+0x14>
 1fd:	mov    $0x1,%eax
 202:	jmp    206 <f18+0x16>
 204:	xor    %eax,%eax
 206:	ret
 207:	int3
 208:	int3
 209:	int3
 20a:	int3
 20b:	int3
 20c:	int3
 20d:	int3
 20e:	int3
 20f:	int3

0000000000000210 <f19>:
 210:	mov    $0x1000,%eax
 215:	movsd  (%rax),%xmm0
 219:	xorps  %xmm1,%xmm1
 21c:	cmpneqsd %xmm1,%xmm0
 221:	movd   %xmm0,%eax
 225:	and    $0x1,%eax
 228:	test   %eax,%eax
 22a:	je     233 <f19+0x23>
 22c:	mov    $0x1,%eax
 231:	jmp    235 <f19+0x25>
 233:	xor    %eax,%eax
 235:	ret
 236:	int3
 237:	int3
 238:	int3
 239:	int3
 23a:	int3
 23b:	int3
 23c:	int3
 23d:	int3
 23e:	int3
 23f:	int3

0000000000000240 <f20>:
 240:	mov    $0x1000,%eax
 245:	mov    (%rax),%eax
 247:	test   %eax,%eax
 249:	jne    252 <f20+0x12>
 24b:	mov    $0x1,%eax
 250:	jmp    254 <f20+0x14>
 252:	xor    %eax,%eax
 254:	ret
