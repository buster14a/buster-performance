
/home/david/buster-fast-bench/issue624/placements-hot/compiler-0:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008cc720 <check_lower_instruction_batch>:
  8cc720:	8b 8f 3c 01 00 00    	mov    0x13c(%rdi),%ecx
  8cc726:	ba 03 00 00 00       	mov    $0x3,%edx
  8cc72b:	41 b8 fe ff ff ff    	mov    $0xfffffffe,%r8d
  8cc731:	8b 87 40 01 00 00    	mov    0x140(%rdi),%eax
  8cc737:	83 f9 03             	cmp    $0x3,%ecx
  8cc73a:	0f 42 d1             	cmovb  %ecx,%edx
  8cc73d:	48 c1 e1 04          	shl    $0x4,%rcx
  8cc741:	48 03 4f 18          	add    0x18(%rdi),%rcx
  8cc745:	62 f2 fd 48 7c c2    	vpbroadcastq %rdx,%zmm0
  8cc74b:	8d 34 12             	lea    (%rdx,%rdx,1),%esi
  8cc74e:	c4 42 69 f7 c0       	shlx   %edx,%r8d,%r8d
  8cc753:	c1 e2 04             	shl    $0x4,%edx
  8cc756:	62 f1 fd 48 d4 d0    	vpaddq %zmm0,%zmm0,%zmm2
  8cc75c:	62 f1 ed 48 d4 05 da 	vpaddq -0x425126(%rip),%zmm2,%zmm0        # 4a7640 <cbuiltin_test_generated.edges+0xafb0>
  8cc763:	ae bd ff 
  8cc766:	48 29 d1             	sub    %rdx,%rcx
  8cc769:	ba fc ff ff ff       	mov    $0xfffffffc,%edx
  8cc76e:	c4 e2 49 f7 d2       	shlx   %esi,%edx,%edx
  8cc773:	be 00 00 00 01       	mov    $0x1000000,%esi
  8cc778:	f6 d2                	not    %dl
  8cc77a:	c5 fb 92 ca          	kmovd  %edx,%k1
  8cc77e:	62 f1 fe c9 6f 09    	vmovdqu64 (%rcx),%zmm1{%k1}{z}
  8cc784:	62 f2 fd 48 36 c1    	vpermq %zmm1,%zmm0,%zmm0
  8cc78a:	62 f1 fd 58 db 1d 2c 	vpandq -0x310ad4(%rip){1to8},%zmm0,%zmm3        # 5bbcc0 <link_program_emit_worker.forms+0x9a8>
  8cc791:	f5 ce ff 
  8cc794:	62 f2 e5 58 29 05 12 	vpcmpeqq -0x310aee(%rip){1to8},%zmm3,%k0        # 5bbcb0 <link_program_emit_worker.forms+0x998>
  8cc79b:	f5 ce ff 
  8cc79e:	c5 f9 93 c8          	kmovb  %k0,%ecx
  8cc7a2:	f7 d1                	not    %ecx
  8cc7a4:	44 09 c1             	or     %r8d,%ecx
  8cc7a7:	f3 0f bc c9          	tzcnt  %ecx,%ecx
  8cc7ab:	3d 00 00 00 01       	cmp    $0x1000000,%eax
  8cc7b0:	0f 42 f0             	cmovb  %eax,%esi
  8cc7b3:	83 f9 03             	cmp    $0x3,%ecx
  8cc7b6:	72 29                	jb     8cc7e1 <check_lower_instruction_batch+0xc1>
  8cc7b8:	62 f2 7d 48 00 1d 3e 	vpshufb -0x4250c2(%rip),%zmm0,%zmm3        # 4a7700 <cbuiltin_test_generated.edges+0xb070>
  8cc7bf:	af bd ff 
  8cc7c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8cc7c7:	62 f3 e5 58 1f 05 e6 	vpcmpltq -0x310b1a(%rip){1to8},%zmm3,%k0        # 5bbcb8 <link_program_emit_worker.forms+0x9a0>
  8cc7ce:	f4 ce ff 01 
  8cc7d2:	c4 e2 71 f7 d0       	shlx   %ecx,%eax,%edx
  8cc7d7:	c5 fb 93 c0          	kmovd  %k0,%eax
  8cc7db:	08 d0                	or     %dl,%al
  8cc7dd:	3c ff                	cmp    $0xff,%al
  8cc7df:	74 06                	je     8cc7e7 <check_lower_instruction_batch+0xc7>
  8cc7e1:	31 c0                	xor    %eax,%eax
  8cc7e3:	c5 f8 77             	vzeroupper
  8cc7e6:	c3                   	ret
  8cc7e7:	44 8b 87 38 01 00 00 	mov    0x138(%rdi),%r8d
  8cc7ee:	31 c0                	xor    %eax,%eax
  8cc7f0:	44 29 c6             	sub    %r8d,%esi
  8cc7f3:	72 6f                	jb     8cc864 <check_lower_instruction_batch+0x144>
  8cc7f5:	39 f1                	cmp    %esi,%ecx
  8cc7f7:	77 6b                	ja     8cc864 <check_lower_instruction_batch+0x144>
  8cc7f9:	48 8b 47 20          	mov    0x20(%rdi),%rax
  8cc7fd:	62 f2 7e 48 32 c0    	vpmovqb %zmm0,%xmm0
  8cc803:	f6 d2                	not    %dl
  8cc805:	62 f1 ed 48 d4 15 71 	vpaddq -0x42518f(%rip),%zmm2,%zmm2        # 4a7680 <cbuiltin_test_generated.edges+0xaff0>
  8cc80c:	ae bd ff 
  8cc80f:	c5 fb 92 ca          	kmovd  %edx,%k1
  8cc813:	c5 f9 90 d1          	kmovb  %k1,%k2
  8cc817:	62 b1 7f 0a 7f 04 00 	vmovdqu8 %xmm0,(%rax,%r8,1){%k2}
  8cc81e:	62 f2 7e 48 32 d8    	vpmovqb %zmm3,%xmm0
  8cc824:	48 8b 47 28          	mov    0x28(%rdi),%rax
  8cc828:	8b 97 38 01 00 00    	mov    0x138(%rdi),%edx
  8cc82e:	62 f2 ed 48 36 c9    	vpermq %zmm1,%zmm2,%zmm1
  8cc834:	62 f1 7f 0a 7f 04 10 	vmovdqu8 %xmm0,(%rax,%rdx,1){%k2}
  8cc83b:	48 8b 47 30          	mov    0x30(%rdi),%rax
  8cc83f:	8b 97 38 01 00 00    	mov    0x138(%rdi),%edx
  8cc845:	62 f1 fe 49 7f 0c d0 	vmovdqu64 %zmm1,(%rax,%rdx,8){%k1}
  8cc84c:	01 8f 38 01 00 00    	add    %ecx,0x138(%rdi)
  8cc852:	8b 87 3c 01 00 00    	mov    0x13c(%rdi),%eax
  8cc858:	29 c8                	sub    %ecx,%eax
  8cc85a:	ff c0                	inc    %eax
  8cc85c:	89 87 3c 01 00 00    	mov    %eax,0x13c(%rdi)
  8cc862:	b0 01                	mov    $0x1,%al
  8cc864:	c5 f8 77             	vzeroupper
  8cc867:	c3                   	ret
