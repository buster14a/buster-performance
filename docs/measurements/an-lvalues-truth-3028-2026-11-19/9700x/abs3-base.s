
/dev/shm/claude-fix3028b/abs3-base.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <f01>:
   0:	mov    $0x1,%eax
   5:	jmp    9 <f01+0x9>
   7:	xor    %eax,%eax
   9:	ret
   a:	int3
   b:	int3
   c:	int3
   d:	int3
   e:	int3
   f:	int3

0000000000000010 <f02>:
  10:	mov    $0x1,%eax
  15:	jmp    19 <f02+0x9>
  17:	xor    %eax,%eax
  19:	ret
  1a:	int3
  1b:	int3
  1c:	int3
  1d:	int3
  1e:	int3
  1f:	int3

0000000000000020 <f03>:
  20:	test   %edi,%edi
  22:	je     2b <f03+0xb>
  24:	mov    $0x1,%eax
  29:	jmp    2d <f03+0xd>
  2b:	xor    %eax,%eax
  2d:	ret
  2e:	int3
  2f:	int3

0000000000000030 <f04>:
  30:	test   %edi,%edi
  32:	je     46 <f04+0x16>
  34:	mov    $0x1000,%eax
  39:	mov    (%rax),%eax
  3b:	test   %eax,%eax
  3d:	je     46 <f04+0x16>
  3f:	mov    $0x1,%eax
  44:	jmp    48 <f04+0x18>
  46:	xor    %eax,%eax
  48:	ret
  49:	int3
  4a:	int3
  4b:	int3
  4c:	int3
  4d:	int3
  4e:	int3
  4f:	int3

0000000000000050 <f05>:
  50:	mov    $0x1,%eax
  55:	test   %eax,%eax
  57:	je     60 <f05+0x10>
  59:	mov    $0x1,%eax
  5e:	jmp    62 <f05+0x12>
  60:	xor    %eax,%eax
  62:	ret
  63:	int3
  64:	int3
  65:	int3
  66:	int3
  67:	int3
  68:	int3
  69:	int3
  6a:	int3
  6b:	int3
  6c:	int3
  6d:	int3
  6e:	int3
  6f:	int3

0000000000000070 <f06>:
  70:	mov    $0x3,%eax
  75:	ret
  76:	int3
  77:	int3
  78:	int3
  79:	int3
  7a:	int3
  7b:	int3
  7c:	int3
  7d:	int3
  7e:	int3
  7f:	int3

0000000000000080 <f07>:
  80:	mov    $0x1,%eax
  85:	test   %eax,%eax
  87:	setne  %al
  8a:	movzbl %al,%eax
  8d:	ret
  8e:	int3
  8f:	int3

0000000000000090 <f08>:
  90:	mov    $0x1000,%eax
  95:	mov    (%rax),%eax
  97:	test   %eax,%eax
  99:	sete   %al
  9c:	movzbl %al,%eax
  9f:	ret

00000000000000a0 <f09>:
  a0:	mov    $0x1000,%eax
  a5:	mov    (%rax),%eax
  a7:	test   %eax,%eax
  a9:	je     ad <f09+0xd>
  ab:	jmp    a0 <f09>
  ad:	xor    %eax,%eax
  af:	ret

00000000000000b0 <f10>:
  b0:	xor    %edx,%edx
  b2:	mov    %edx,%eax
  b4:	mov    %rax,%rcx
  b7:	inc    %ecx
  b9:	mov    %ecx,%edx
  bb:	mov    $0x1000,%eax
  c0:	mov    (%rax),%eax
  c2:	test   %eax,%eax
  c4:	jne    b2 <f10+0x2>
  c6:	mov    %edx,%eax
  c8:	ret
  c9:	int3
  ca:	int3
  cb:	int3
  cc:	int3
  cd:	int3
  ce:	int3
  cf:	int3

00000000000000d0 <f11>:
  d0:	xor    %edx,%edx
  d2:	mov    $0x1000,%eax
  d7:	mov    (%rax),%eax
  d9:	test   %eax,%eax
  db:	je     e8 <f11+0x18>
  dd:	mov    %edx,%eax
  df:	mov    %rax,%rcx
  e2:	inc    %ecx
  e4:	mov    %ecx,%edx
  e6:	jmp    d2 <f11+0x2>
  e8:	mov    %edx,%eax
  ea:	ret
  eb:	int3
  ec:	int3
  ed:	int3
  ee:	int3
  ef:	int3

00000000000000f0 <f12>:
  f0:	mov    $0x1000,%eax
  f5:	mov    (%rax),%eax
  f7:	test   %eax,%eax
  f9:	setne  %al
  fc:	movzbl %al,%eax
  ff:	ret

0000000000000100 <f13>:
 100:	mov    $0x1000,%eax
 105:	mov    (%rax),%eax
 107:	test   %eax,%eax
 109:	setne  %al
 10c:	movzbl %al,%eax
 10f:	movzbl %al,%eax
 112:	ret
 113:	int3
 114:	int3
 115:	int3
 116:	int3
 117:	int3
 118:	int3
 119:	int3
 11a:	int3
 11b:	int3
 11c:	int3
 11d:	int3
 11e:	int3
 11f:	int3

0000000000000120 <f14>:
 120:	mov    $0x1,%eax
 125:	ret
 126:	int3
 127:	int3
 128:	int3
 129:	int3
 12a:	int3
 12b:	int3
 12c:	int3
 12d:	int3
 12e:	int3
 12f:	int3

0000000000000130 <f15>:
 130:	mov    $0x1,%eax
 135:	ret
 136:	int3
 137:	int3
 138:	int3
 139:	int3
 13a:	int3
 13b:	int3
 13c:	int3
 13d:	int3
 13e:	int3
 13f:	int3

0000000000000140 <f16>:
 140:	xor    %eax,%eax
 142:	ret
 143:	int3
 144:	int3
 145:	int3
 146:	int3
 147:	int3
 148:	int3
 149:	int3
 14a:	int3
 14b:	int3
 14c:	int3
 14d:	int3
 14e:	int3
 14f:	int3

0000000000000150 <f17>:
 150:	mov    $0x1,%eax
 155:	ret
 156:	int3
 157:	int3
 158:	int3
 159:	int3
 15a:	int3
 15b:	int3
 15c:	int3
 15d:	int3
 15e:	int3
 15f:	int3

0000000000000160 <f18>:
 160:	mov    $0x1,%eax
 165:	ret
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

0000000000000170 <f19>:
 170:	mov    $0x1,%eax
 175:	ret
 176:	int3
 177:	int3
 178:	int3
 179:	int3
 17a:	int3
 17b:	int3
 17c:	int3
 17d:	int3
 17e:	int3
 17f:	int3

0000000000000180 <f20>:
 180:	mov    $0x1000,%eax
 185:	mov    (%rax),%eax
 187:	test   %eax,%eax
 189:	jne    192 <f20+0x12>
 18b:	mov    $0x1,%eax
 190:	jmp    194 <f20+0x14>
 192:	xor    %eax,%eax
 194:	ret
