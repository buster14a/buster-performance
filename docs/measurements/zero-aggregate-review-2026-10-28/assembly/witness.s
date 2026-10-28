
build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008f7f10 <check_data_initializer_witness>:
  8f7f10:	mov    ecx,DWORD PTR [rsi+0x18]
  8f7f13:	test   rcx,rcx
  8f7f16:	je     8f81c3 <check_data_initializer_witness+0x2b3>
  8f7f1c:	push   rbp
  8f7f1d:	push   r15
  8f7f1f:	push   r14
  8f7f21:	push   r13
  8f7f23:	push   r12
  8f7f25:	push   rbx
  8f7f26:	mov    rsi,QWORD PTR [rsi+0x10]
  8f7f2a:	imul   rax,rcx,0xb0
  8f7f31:	shl    rdx,0x3
  8f7f35:	lea    r9,[rcx+0x1]
  8f7f39:	mov    r12,rcx
  8f7f3c:	lea    r8,[rax+rsi*1+0x30]
  8f7f41:	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  8f7f50:	lea    r14,[r12-0x1]
  8f7f55:	mov    eax,r14d
  8f7f58:	imul   r15,rax,0xb0
  8f7f5f:	cmp    DWORD PTR [rsi+r15*1],0x0
  8f7f64:	jne    8f8190 <check_data_initializer_witness+0x280>
  8f7f6a:	add    r15,rsi
  8f7f6d:	cmp    DWORD PTR [r15+0x20],0x0
  8f7f72:	jne    8f8190 <check_data_initializer_witness+0x280>
  8f7f78:	cmp    DWORD PTR [r15+0x4c],0x1
  8f7f7d:	jne    8f8190 <check_data_initializer_witness+0x280>
  8f7f83:	mov    rax,QWORD PTR [r15+0x50]
  8f7f87:	or     rax,QWORD PTR [r15+0x58]
  8f7f8b:	je     8f8190 <check_data_initializer_witness+0x280>
  8f7f91:	mov    eax,DWORD PTR [r15+0x4]
  8f7f95:	mov    r11,QWORD PTR [rdi]
  8f7f98:	mov    r10d,eax
  8f7f9b:	shr    r10d,0x3
  8f7f9f:	movzx  ebx,BYTE PTR [r11+r10*1]
  8f7fa4:	mov    r13,r10
  8f7fa7:	mov    ebp,ebx
  8f7fa9:	cmp    bl,0xf
  8f7fac:	jne    8f7fc2 <check_data_initializer_witness+0xb2>
  8f7fae:	mov    rax,QWORD PTR [rdi+0x20]
  8f7fb2:	mov    eax,DWORD PTR [rax+r10*4]
  8f7fb6:	mov    r13d,eax
  8f7fb9:	shr    r13d,0x3
  8f7fbd:	movzx  ebp,BYTE PTR [r11+r13*1]
  8f7fc2:	cmp    bpl,0x12
  8f7fc6:	jne    8f7fdc <check_data_initializer_witness+0xcc>
  8f7fc8:	mov    rbp,QWORD PTR [rdi+0x10]
  8f7fcc:	test   BYTE PTR [rbp+r13*1+0x0],0x4
  8f7fd2:	je     8f7fdc <check_data_initializer_witness+0xcc>
  8f7fd4:	mov    rax,QWORD PTR [rdi+0x20]
  8f7fd8:	mov    eax,DWORD PTR [rax+r13*4]
  8f7fdc:	shr    eax,0x3
  8f7fdf:	movzx  r11d,BYTE PTR [r11+rax*1]
  8f7fe4:	cmp    r11d,0x2
  8f7fe8:	je     8f8008 <check_data_initializer_witness+0xf8>
  8f7fea:	cmp    r11d,0x5
  8f7fee:	jne    8f8190 <check_data_initializer_witness+0x280>
  8f7ff4:	mov    r11,QWORD PTR [rdi+0x30]
  8f7ff8:	mov    r11,QWORD PTR [r11+rax*8]
  8f7ffc:	xor    eax,eax
  8f7ffe:	test   r10d,r10d
  8f8001:	jne    8f8024 <check_data_initializer_witness+0x114>
  8f8003:	jmp    8f8192 <check_data_initializer_witness+0x282>
  8f8008:	lea    rax,[rax+rax*2]
  8f800c:	lea    r11,[rip+0xffffffffffbb7c9d]        # 4afcb0 <type_integer_info>
  8f8013:	movzx  r11d,BYTE PTR [r11+rax*2+0x2]
  8f8019:	xor    eax,eax
  8f801b:	test   r10d,r10d
  8f801e:	je     8f8192 <check_data_initializer_witness+0x282>
  8f8024:	add    r11,0xffffffffffffff7f
  8f802b:	cmp    r11,0xffffffffffffff80
  8f802f:	jb     8f8192 <check_data_initializer_witness+0x282>
  8f8035:	xor    eax,eax
  8f8037:	test   bl,bl
  8f8039:	je     8f8192 <check_data_initializer_witness+0x282>
  8f803f:	cmp    r10d,DWORD PTR [rdi+0x48]
  8f8043:	jae    8f8192 <check_data_initializer_witness+0x282>
  8f8049:	cmp    bl,0xf
  8f804c:	jne    8f805a <check_data_initializer_witness+0x14a>
  8f804e:	mov    rax,QWORD PTR [rdi+0x20]
  8f8052:	mov    r10d,DWORD PTR [rax+r10*4]
  8f8056:	shr    r10d,0x3
  8f805a:	mov    rax,QWORD PTR [rdi+0x38]
  8f805e:	mov    r13,QWORD PTR [rax+r10*8]
  8f8062:	movabs rax,0x2000000000000000
  8f806c:	mov    r10,r13
  8f806f:	shr    r10,0x3d
  8f8073:	cmp    r13,rax
  8f8076:	cmovae r13,rax
  8f807a:	xor    eax,eax
  8f807c:	test   r10,r10
  8f807f:	jne    8f8192 <check_data_initializer_witness+0x282>
  8f8085:	mov    r11,QWORD PTR [r15+0x18]
  8f8089:	shl    r13,0x3
  8f808d:	mov    r10,r13
  8f8090:	neg    r10
  8f8093:	cmp    r11,r10
  8f8096:	jae    8f8192 <check_data_initializer_witness+0x282>
  8f809c:	mov    r10,rdx
  8f809f:	sub    r10,r11
  8f80a2:	jb     8f8192 <check_data_initializer_witness+0x282>
  8f80a8:	cmp    r13,r10
  8f80ab:	setbe  al
  8f80ae:	seta   r10b
  8f80b2:	cmp    r12,rcx
  8f80b5:	setae  r11b
  8f80b9:	or     r11b,r10b
  8f80bc:	jne    8f8192 <check_data_initializer_witness+0x282>
  8f80c2:	mov    rbp,r9
  8f80c5:	mov    r12,r8
  8f80c8:	mov    eax,DWORD PTR [r12-0x2c]
  8f80cd:	shr    eax,0x3
  8f80d0:	je     8f8190 <check_data_initializer_witness+0x280>
  8f80d6:	cmp    eax,DWORD PTR [rdi+0x48]
  8f80d9:	jae    8f8190 <check_data_initializer_witness+0x280>
  8f80df:	mov    r10,QWORD PTR [rdi]
  8f80e2:	movzx  r11d,BYTE PTR [r10+rax*1]
  8f80e7:	test   r11b,r11b
  8f80ea:	je     8f8190 <check_data_initializer_witness+0x280>
  8f80f0:	mov    ebx,DWORD PTR [r12-0x30]
  8f80f5:	cmp    ebx,0x2
  8f80f8:	ja     8f8190 <check_data_initializer_witness+0x280>
  8f80fe:	mov    r10,r12
  8f8101:	test   ebx,ebx
  8f8103:	je     8f811b <check_data_initializer_witness+0x20b>
  8f8105:	mov    eax,DWORD PTR [r12-0x10]
  8f810a:	test   rax,rax
  8f810d:	je     8f813e <check_data_initializer_witness+0x22e>
  8f810f:	mov    r10,QWORD PTR [r12-0x18]
  8f8114:	add    rax,r10
  8f8117:	jae    8f815e <check_data_initializer_witness+0x24e>
  8f8119:	jmp    8f8190 <check_data_initializer_witness+0x280>
  8f811b:	cmp    r11b,0xf
  8f811f:	jne    8f812c <check_data_initializer_witness+0x21c>
  8f8121:	mov    r10,QWORD PTR [rdi+0x20]
  8f8125:	mov    eax,DWORD PTR [r10+rax*4]
  8f8129:	shr    eax,0x3
  8f812c:	mov    r10,QWORD PTR [rdi+0x38]
  8f8130:	lea    r10,[r10+rax*8]
  8f8134:	mov    eax,DWORD PTR [r12-0x10]
  8f8139:	test   rax,rax
  8f813c:	jne    8f810f <check_data_initializer_witness+0x1ff>
  8f813e:	mov    rax,QWORD PTR [r10]
  8f8141:	movabs r10,0x1fffffffffffffff
  8f814b:	cmp    rax,r10
  8f814e:	ja     8f8190 <check_data_initializer_witness+0x280>
  8f8150:	shl    rax,0x3
  8f8154:	mov    r10,QWORD PTR [r12-0x18]
  8f8159:	add    rax,r10
  8f815c:	jb     8f8190 <check_data_initializer_witness+0x280>
  8f815e:	mov    r11,QWORD PTR [r15+0x18]
  8f8162:	lea    rbx,[r11+r13*1]
  8f8166:	cmp    r10,rbx
  8f8169:	setae  r10b
  8f816d:	cmp    rax,r11
  8f8170:	setbe  al
  8f8173:	or     al,r10b
  8f8176:	cmp    al,0x1
  8f8178:	jne    8f8192 <check_data_initializer_witness+0x282>
  8f817a:	add    r12,0xb0
  8f8181:	cmp    rbp,rcx
  8f8184:	lea    rbp,[rbp+0x1]
  8f8188:	jb     8f80c8 <check_data_initializer_witness+0x1b8>
  8f818e:	jmp    8f8192 <check_data_initializer_witness+0x282>
  8f8190:	xor    eax,eax
  8f8192:	test   r14d,r14d
  8f8195:	je     8f81b8 <check_data_initializer_witness+0x2a8>
  8f8197:	test   al,al
  8f8199:	jne    8f81b8 <check_data_initializer_witness+0x2a8>
  8f819b:	mov    r10d,ecx
  8f819e:	sub    r10d,r14d
  8f81a1:	add    r8,0xffffffffffffff50
  8f81a8:	dec    r9
  8f81ab:	mov    r12,r14
  8f81ae:	cmp    r10d,0x8
  8f81b2:	jb     8f7f50 <check_data_initializer_witness+0x40>
  8f81b8:	pop    rbx
  8f81b9:	pop    r12
  8f81bb:	pop    r13
  8f81bd:	pop    r14
  8f81bf:	pop    r15
  8f81c1:	pop    rbp
  8f81c2:	ret
  8f81c3:	xor    eax,eax
  8f81c5:	ret
