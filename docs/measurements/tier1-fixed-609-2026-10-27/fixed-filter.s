
measure:     file format elf64-x86-64


Disassembly of section .init:

Disassembly of section .plt:

Disassembly of section .text:

0000000000003cd0 <tier1_allocation_filter_fixed>:
    3cd0:	55                   	push   %rbp
    3cd1:	41 57                	push   %r15
    3cd3:	41 56                	push   %r14
    3cd5:	41 55                	push   %r13
    3cd7:	41 54                	push   %r12
    3cd9:	53                   	push   %rbx
    3cda:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
    3ce1:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
    3ce8:	00 00 
    3cea:	48 89 84 24 10 01 00 	mov    %rax,0x110(%rsp)
    3cf1:	00 
    3cf2:	b0 01                	mov    $0x1,%al
    3cf4:	44 8b 97 90 00 00 00 	mov    0x90(%rdi),%r10d
    3cfb:	4d 85 d2             	test   %r10,%r10
    3cfe:	0f 84 2a 02 00 00    	je     3f2e <tier1_allocation_filter_fixed+0x25e>
    3d04:	44 8b 5f 5c          	mov    0x5c(%rdi),%r11d
    3d08:	4d 85 db             	test   %r11,%r11
    3d0b:	0f 84 1d 02 00 00    	je     3f2e <tier1_allocation_filter_fixed+0x25e>
    3d11:	44 8b 7f 64          	mov    0x64(%rdi),%r15d
    3d15:	4c 89 db             	mov    %r11,%rbx
    3d18:	47 8d 34 13          	lea    (%r11,%r10,1),%r14d
    3d1c:	49 0f af da          	imul   %r10,%rbx
    3d20:	49 c1 e6 04          	shl    $0x4,%r14
    3d24:	4d 01 f7             	add    %r14,%r15
    3d27:	4c 39 fb             	cmp    %r15,%rbx
    3d2a:	0f 86 fe 00 00 00    	jbe    3e2e <tier1_allocation_filter_fixed+0x15e>
    3d30:	4c 8b 1e             	mov    (%rsi),%r11
    3d33:	48 8b 46 08          	mov    0x8(%rsi),%rax
    3d37:	4a 8d 5c 18 03       	lea    0x3(%rax,%r11,1),%rbx
    3d3c:	4c 01 d8             	add    %r11,%rax
    3d3f:	48 83 e3 fc          	and    $0xfffffffffffffffc,%rbx
    3d43:	48 39 c3             	cmp    %rax,%rbx
    3d46:	0f 82 e0 01 00 00    	jb     3f2c <tier1_allocation_filter_fixed+0x25c>
    3d4c:	48 89 d8             	mov    %rbx,%rax
    3d4f:	4c 29 d8             	sub    %r11,%rax
    3d52:	4c 8b 5e 10          	mov    0x10(%rsi),%r11
    3d56:	49 c1 e2 02          	shl    $0x2,%r10
    3d5a:	49 29 c3             	sub    %rax,%r11
    3d5d:	40 0f 92 c5          	setb   %bpl
    3d61:	4d 39 da             	cmp    %r11,%r10
    3d64:	41 0f 97 c3          	seta   %r11b
    3d68:	41 08 eb             	or     %bpl,%r11b
    3d6b:	0f 85 bb 01 00 00    	jne    3f2c <tier1_allocation_filter_fixed+0x25c>
    3d71:	4c 01 d0             	add    %r10,%rax
    3d74:	48 89 46 08          	mov    %rax,0x8(%rsi)
    3d78:	48 85 db             	test   %rbx,%rbx
    3d7b:	0f 84 ab 01 00 00    	je     3f2c <tier1_allocation_filter_fixed+0x25c>
    3d81:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
    3d85:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0xd0(%rsp)
    3d8c:	d0 00 00 00 
    3d90:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x90(%rsp)
    3d97:	90 00 00 00 
    3d9b:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x50(%rsp)
    3da2:	50 00 00 00 
    3da6:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x10(%rsp)
    3dad:	10 00 00 00 
    3db1:	49 89 d6             	mov    %rdx,%r14
    3db4:	89 cd                	mov    %ecx,%ebp
    3db6:	4d 89 cf             	mov    %r9,%r15
    3db9:	49 89 fc             	mov    %rdi,%r12
    3dbc:	31 f6                	xor    %esi,%esi
    3dbe:	4d 89 c5             	mov    %r8,%r13
    3dc1:	8b 47 64             	mov    0x64(%rdi),%eax
    3dc4:	4c 89 c7             	mov    %r8,%rdi
    3dc7:	48 8d 14 85 08 00 00 	lea    0x8(,%rax,4),%rdx
    3dce:	00 
    3dcf:	c5 f8 77             	vzeroupper
    3dd2:	e8 b9 d2 ff ff       	call   1090 <memset@plt>
    3dd7:	41 83 bc 24 90 00 00 	cmpl   $0x0,0x90(%r12)
    3dde:	00 00 
    3de0:	4c 89 e9             	mov    %r13,%rcx
    3de3:	4c 89 e2             	mov    %r12,%rdx
    3de6:	74 26                	je     3e0e <tier1_allocation_filter_fixed+0x13e>
    3de8:	31 c0                	xor    %eax,%eax
    3dea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3df0:	48 8b 72 70          	mov    0x70(%rdx),%rsi
    3df4:	8b 34 86             	mov    (%rsi,%rax,4),%esi
    3df7:	8b 3c b1             	mov    (%rcx,%rsi,4),%edi
    3dfa:	89 3c 83             	mov    %edi,(%rbx,%rax,4)
    3dfd:	48 ff c0             	inc    %rax
    3e00:	89 04 b1             	mov    %eax,(%rcx,%rsi,4)
    3e03:	8b b2 90 00 00 00    	mov    0x90(%rdx),%esi
    3e09:	48 39 f0             	cmp    %rsi,%rax
    3e0c:	72 e2                	jb     3df0 <tier1_allocation_filter_fixed+0x120>
    3e0e:	b0 01                	mov    $0x1,%al
    3e10:	85 ed                	test   %ebp,%ebp
    3e12:	0f 84 16 01 00 00    	je     3f2e <tier1_allocation_filter_fixed+0x25e>
    3e18:	4c 89 f7             	mov    %r14,%rdi
    3e1b:	41 89 e8             	mov    %ebp,%r8d
    3e1e:	45 31 f6             	xor    %r14d,%r14d
    3e21:	45 31 c9             	xor    %r9d,%r9d
    3e24:	4c 89 7c 24 08       	mov    %r15,0x8(%rsp)
    3e29:	e9 77 01 00 00       	jmp    3fa5 <tier1_allocation_filter_fixed+0x2d5>
    3e2e:	ba 10 00 00 00       	mov    $0x10,%edx
    3e33:	be ff ff ff ff       	mov    $0xffffffff,%esi
    3e38:	31 c9                	xor    %ecx,%ecx
    3e3a:	eb 16                	jmp    3e52 <tier1_allocation_filter_fixed+0x182>
    3e3c:	0f 1f 40 00          	nopl   0x0(%rax)
    3e40:	48 ff c1             	inc    %rcx
    3e43:	44 89 d3             	mov    %r10d,%ebx
    3e46:	45 89 c3             	mov    %r8d,%r11d
    3e49:	48 39 d9             	cmp    %rbx,%rcx
    3e4c:	0f 83 dc 00 00 00    	jae    3f2e <tier1_allocation_filter_fixed+0x25e>
    3e52:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    3e58:	45 85 db             	test   %r11d,%r11d
    3e5b:	74 e3                	je     3e40 <tier1_allocation_filter_fixed+0x170>
    3e5d:	45 31 c0             	xor    %r8d,%r8d
    3e60:	45 31 d2             	xor    %r10d,%r10d
    3e63:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    3e6a:	84 00 00 00 00 00 
    3e70:	45 01 c3             	add    %r8d,%r11d
    3e73:	4c 8b 77 08          	mov    0x8(%rdi),%r14
    3e77:	44 89 d3             	mov    %r10d,%ebx
    3e7a:	4c 8b 27             	mov    (%rdi),%r12
    3e7d:	4c 8b 7f 20          	mov    0x20(%rdi),%r15
    3e81:	41 83 fb 10          	cmp    $0x10,%r11d
    3e85:	44 0f 43 da          	cmovae %edx,%r11d
    3e89:	41 83 c2 10          	add    $0x10,%r10d
    3e8d:	41 83 c0 f0          	add    $0xfffffff0,%r8d
    3e91:	c4 62 21 f7 de       	shlx   %r11d,%esi,%r11d
    3e96:	41 f7 d3             	not    %r11d
    3e99:	c4 c1 7b 92 cb       	kmovd  %r11d,%k1
    3e9e:	4c 8b 5f 78          	mov    0x78(%rdi),%r11
    3ea2:	62 d1 7e c9 6f 0c 9e 	vmovdqu32 (%r14,%rbx,4),%zmm1{%k1}{z}
    3ea9:	4c 8b b7 88 00 00 00 	mov    0x88(%rdi),%r14
    3eb0:	62 d1 7f 89 6f 14 1f 	vmovdqu8 (%r15,%rbx,1),%xmm2{%k1}{z}
    3eb7:	62 d1 7e c9 6f 04 9c 	vmovdqu32 (%r12,%rbx,4),%zmm0{%k1}{z}
    3ebe:	4c 8b 7f 70          	mov    0x70(%rdi),%r15
    3ec2:	c4 c2 79 78 1c 0e    	vpbroadcastb (%r14,%rcx,1),%xmm3
    3ec8:	4c 8b b7 80 00 00 00 	mov    0x80(%rdi),%r14
    3ecf:	62 f1 6d 08 74 d3    	vpcmpeqb %xmm3,%xmm2,%k2
    3ed5:	62 d3 7d 5a 1e 14 8b 	vpcmpltud (%r11,%rcx,4){1to16},%zmm0,%k2{%k2}
    3edc:	01 
    3edd:	62 d1 7e c9 6f 04 99 	vmovdqu32 (%r9,%rbx,4),%zmm0{%k1}{z}
    3ee4:	62 d3 75 5a 1e 04 8f 	vpcmpnleud (%r15,%rcx,4){1to16},%zmm1,%k0{%k2}
    3eeb:	06 
    3eec:	c4 c1 79 6e 0c 8e    	vmovd  (%r14,%rcx,4),%xmm1
    3ef2:	62 f3 f5 08 25 c9 0f 	vpternlogq $0xf,%xmm1,%xmm1,%xmm1
    3ef9:	c5 fc 41 c9          	kandw  %k1,%k0,%k1
    3efd:	62 f2 7d 48 58 c9    	vpbroadcastd %xmm1,%zmm1
    3f03:	62 f1 75 48 db c0    	vpandd %zmm0,%zmm1,%zmm0
    3f09:	62 d1 7e 49 7f 04 99 	vmovdqu32 %zmm0,(%r9,%rbx,4){%k1}
    3f10:	44 8b 5f 5c          	mov    0x5c(%rdi),%r11d
    3f14:	45 39 da             	cmp    %r11d,%r10d
    3f17:	0f 82 53 ff ff ff    	jb     3e70 <tier1_allocation_filter_fixed+0x1a0>
    3f1d:	44 8b 97 90 00 00 00 	mov    0x90(%rdi),%r10d
    3f24:	45 89 d8             	mov    %r11d,%r8d
    3f27:	e9 14 ff ff ff       	jmp    3e40 <tier1_allocation_filter_fixed+0x170>
    3f2c:	31 c0                	xor    %eax,%eax
    3f2e:	64 48 8b 0c 25 28 00 	mov    %fs:0x28,%rcx
    3f35:	00 00 
    3f37:	48 3b 8c 24 10 01 00 	cmp    0x110(%rsp),%rcx
    3f3e:	00 
    3f3f:	0f 85 36 02 00 00    	jne    417b <tier1_allocation_filter_fixed+0x4ab>
    3f45:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
    3f4c:	5b                   	pop    %rbx
    3f4d:	41 5c                	pop    %r12
    3f4f:	41 5d                	pop    %r13
    3f51:	41 5e                	pop    %r14
    3f53:	41 5f                	pop    %r15
    3f55:	5d                   	pop    %rbp
    3f56:	c5 f8 77             	vzeroupper
    3f59:	c3                   	ret
    3f5a:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
    3f5f:	45 89 de             	mov    %r11d,%r14d
    3f62:	4c 8b 5a 20          	mov    0x20(%rdx),%r11
    3f66:	48 8b 32             	mov    (%rdx),%rsi
    3f69:	47 0f b6 1c 13       	movzbl (%r11,%r10,1),%r11d
    3f6e:	62 b2 7d 48 58 04 96 	vpbroadcastd (%rsi,%r10,4),%zmm0
    3f75:	41 c1 e3 07          	shl    $0x7,%r11d
    3f79:	62 b3 7d 48 1e 84 1c 	vpcmpnltud 0x10(%rsp,%r11,1),%zmm0,%k0
    3f80:	10 00 00 00 05 
    3f85:	62 b3 7d 48 1e 8c 1c 	vpcmpnltud 0x50(%rsp,%r11,1),%zmm0,%k1
    3f8c:	50 00 00 00 05 
    3f91:	c5 f4 4b c0          	kunpckwd %k0,%k1,%k0
    3f95:	c5 fb 93 f0          	kmovd  %k0,%esi
    3f99:	43 21 34 97          	and    %esi,(%r15,%r10,4)
    3f9d:	49 ff c1             	inc    %r9
    3fa0:	4d 39 c1             	cmp    %r8,%r9
    3fa3:	74 89                	je     3f2e <tier1_allocation_filter_fixed+0x25e>
    3fa5:	46 8b 14 8f          	mov    (%rdi,%r9,4),%r10d
    3fa9:	41 f7 c2 01 00 00 80 	test   $0x80000001,%r10d
    3fb0:	75 eb                	jne    3f9d <tier1_allocation_filter_fixed+0x2cd>
    3fb2:	4c 8b 5a 08          	mov    0x8(%rdx),%r11
    3fb6:	41 d1 ea             	shr    $1,%r10d
    3fb9:	47 8b 1c 93          	mov    (%r11,%r10,4),%r11d
    3fbd:	45 39 de             	cmp    %r11d,%r14d
    3fc0:	73 a0                	jae    3f62 <tier1_allocation_filter_fixed+0x292>
    3fc2:	44 89 dd             	mov    %r11d,%ebp
    3fc5:	44 29 f5             	sub    %r14d,%ebp
    3fc8:	45 89 f7             	mov    %r14d,%r15d
    3fcb:	4d 89 fe             	mov    %r15,%r14
    3fce:	40 f6 c5 01          	test   $0x1,%bpl
    3fd2:	0f 84 82 00 00 00    	je     405a <tier1_allocation_filter_fixed+0x38a>
    3fd8:	46 8b 34 b9          	mov    (%rcx,%r15,4),%r14d
    3fdc:	45 85 f6             	test   %r14d,%r14d
    3fdf:	74 75                	je     4056 <tier1_allocation_filter_fixed+0x386>
    3fe1:	4c 8b a2 88 00 00 00 	mov    0x88(%rdx),%r12
    3fe8:	4c 8b 6a 78          	mov    0x78(%rdx),%r13
    3fec:	48 8b aa 80 00 00 00 	mov    0x80(%rdx),%rbp
    3ff3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    3ffa:	84 00 00 00 00 00 
    4000:	41 ff ce             	dec    %r14d
    4003:	43 0f b6 34 34       	movzbl (%r12,%r14,1),%esi
    4008:	62 92 7d 48 58 44 b5 	vpbroadcastd 0x0(%r13,%r14,4),%zmm0
    400f:	00 
    4010:	c4 a1 78 90 4c b5 00 	kmovw  0x0(%rbp,%r14,4),%k1
    4017:	c4 a1 78 90 54 b5 02 	kmovw  0x2(%rbp,%r14,4),%k2
    401e:	c1 e6 07             	shl    $0x7,%esi
    4021:	62 f2 7d 48 3f 8c 34 	vpmaxud 0x10(%rsp,%rsi,1),%zmm0,%zmm1
    4028:	10 00 00 00 
    402c:	62 f1 7e 49 7f 8c 34 	vmovdqu32 %zmm1,0x10(%rsp,%rsi,1){%k1}
    4033:	10 00 00 00 
    4037:	62 f2 7d 48 3f 84 34 	vpmaxud 0x50(%rsp,%rsi,1),%zmm0,%zmm0
    403e:	50 00 00 00 
    4042:	62 f1 7e 4a 7f 84 34 	vmovdqu32 %zmm0,0x50(%rsp,%rsi,1){%k2}
    4049:	50 00 00 00 
    404d:	46 8b 34 b3          	mov    (%rbx,%r14,4),%r14d
    4051:	45 85 f6             	test   %r14d,%r14d
    4054:	75 aa                	jne    4000 <tier1_allocation_filter_fixed+0x330>
    4056:	4d 8d 77 01          	lea    0x1(%r15),%r14
    405a:	49 8d 73 ff          	lea    -0x1(%r11),%rsi
    405e:	4c 39 fe             	cmp    %r15,%rsi
    4061:	75 1a                	jne    407d <tier1_allocation_filter_fixed+0x3ad>
    4063:	e9 f2 fe ff ff       	jmp    3f5a <tier1_allocation_filter_fixed+0x28a>
    4068:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    406f:	00 
    4070:	49 83 c6 02          	add    $0x2,%r14
    4074:	4d 39 de             	cmp    %r11,%r14
    4077:	0f 84 dd fe ff ff    	je     3f5a <tier1_allocation_filter_fixed+0x28a>
    407d:	46 8b 3c b1          	mov    (%rcx,%r14,4),%r15d
    4081:	45 85 ff             	test   %r15d,%r15d
    4084:	74 70                	je     40f6 <tier1_allocation_filter_fixed+0x426>
    4086:	4c 8b a2 88 00 00 00 	mov    0x88(%rdx),%r12
    408d:	4c 8b 6a 78          	mov    0x78(%rdx),%r13
    4091:	48 8b aa 80 00 00 00 	mov    0x80(%rdx),%rbp
    4098:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    409f:	00 
    40a0:	41 ff cf             	dec    %r15d
    40a3:	43 0f b6 34 3c       	movzbl (%r12,%r15,1),%esi
    40a8:	62 92 7d 48 58 44 bd 	vpbroadcastd 0x0(%r13,%r15,4),%zmm0
    40af:	00 
    40b0:	c4 a1 78 90 4c bd 00 	kmovw  0x0(%rbp,%r15,4),%k1
    40b7:	c4 a1 78 90 54 bd 02 	kmovw  0x2(%rbp,%r15,4),%k2
    40be:	c1 e6 07             	shl    $0x7,%esi
    40c1:	62 f2 7d 48 3f 8c 34 	vpmaxud 0x10(%rsp,%rsi,1),%zmm0,%zmm1
    40c8:	10 00 00 00 
    40cc:	62 f1 7e 49 7f 8c 34 	vmovdqu32 %zmm1,0x10(%rsp,%rsi,1){%k1}
    40d3:	10 00 00 00 
    40d7:	62 f2 7d 48 3f 84 34 	vpmaxud 0x50(%rsp,%rsi,1),%zmm0,%zmm0
    40de:	50 00 00 00 
    40e2:	62 f1 7e 4a 7f 84 34 	vmovdqu32 %zmm0,0x50(%rsp,%rsi,1){%k2}
    40e9:	50 00 00 00 
    40ed:	46 8b 3c bb          	mov    (%rbx,%r15,4),%r15d
    40f1:	45 85 ff             	test   %r15d,%r15d
    40f4:	75 aa                	jne    40a0 <tier1_allocation_filter_fixed+0x3d0>
    40f6:	46 8b 7c b1 04       	mov    0x4(%rcx,%r14,4),%r15d
    40fb:	45 85 ff             	test   %r15d,%r15d
    40fe:	0f 84 6c ff ff ff    	je     4070 <tier1_allocation_filter_fixed+0x3a0>
    4104:	4c 8b a2 88 00 00 00 	mov    0x88(%rdx),%r12
    410b:	4c 8b 6a 78          	mov    0x78(%rdx),%r13
    410f:	48 8b aa 80 00 00 00 	mov    0x80(%rdx),%rbp
    4116:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    411d:	00 00 00 
    4120:	41 ff cf             	dec    %r15d
    4123:	43 0f b6 34 3c       	movzbl (%r12,%r15,1),%esi
    4128:	62 92 7d 48 58 44 bd 	vpbroadcastd 0x0(%r13,%r15,4),%zmm0
    412f:	00 
    4130:	c4 a1 78 90 4c bd 00 	kmovw  0x0(%rbp,%r15,4),%k1
    4137:	c4 a1 78 90 54 bd 02 	kmovw  0x2(%rbp,%r15,4),%k2
    413e:	c1 e6 07             	shl    $0x7,%esi
    4141:	62 f2 7d 48 3f 8c 34 	vpmaxud 0x10(%rsp,%rsi,1),%zmm0,%zmm1
    4148:	10 00 00 00 
    414c:	62 f1 7e 49 7f 8c 34 	vmovdqu32 %zmm1,0x10(%rsp,%rsi,1){%k1}
    4153:	10 00 00 00 
    4157:	62 f2 7d 48 3f 84 34 	vpmaxud 0x50(%rsp,%rsi,1),%zmm0,%zmm0
    415e:	50 00 00 00 
    4162:	62 f1 7e 4a 7f 84 34 	vmovdqu32 %zmm0,0x50(%rsp,%rsi,1){%k2}
    4169:	50 00 00 00 
    416d:	46 8b 3c bb          	mov    (%rbx,%r15,4),%r15d
    4171:	45 85 ff             	test   %r15d,%r15d
    4174:	75 aa                	jne    4120 <tier1_allocation_filter_fixed+0x450>
    4176:	e9 f5 fe ff ff       	jmp    4070 <tier1_allocation_filter_fixed+0x3a0>
    417b:	c5 f8 77             	vzeroupper
    417e:	e8 cd ce ff ff       	call   1050 <__stack_chk_fail@plt>

Disassembly of section .fini:
