
../campaign/native-images/head449/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000001009f20 <check_program>:
 1009f20:	push   %rbp
 1009f21:	push   %r15
 1009f23:	push   %r14
 1009f25:	push   %r13
 1009f27:	push   %r12
 1009f29:	push   %rbx
 1009f2a:	sub    $0x2c8,%rsp
 1009f31:	mov    %fs:0x28,%rax
 1009f3a:	mov    %rsi,%r14
 1009f3d:	vxorps %xmm0,%xmm0,%xmm0
 1009f41:	mov    0x328(%rsp),%rbx
 1009f49:	xor    %r12d,%r12d
 1009f4c:	mov    %rax,0x2c0(%rsp)
 1009f54:	mov    0x300(%rsp),%rax
 1009f5c:	mov    0x310(%rsp),%r11
 1009f64:	mov    0x308(%rsp),%rsi
 1009f6c:	movzwl 0x325(%rsp),%r10d
 1009f75:	mov    %rdx,(%rdi)
 1009f78:	mov    %rcx,0x8(%rdi)
 1009f7c:	mov    %r8,0x10(%rdi)
 1009f80:	mov    %r14,0x18(%rdi)
 1009f84:	mov    %r11,0x20(%rdi)
 1009f88:	mov    %rax,0x28(%rdi)
 1009f8c:	mov    %rsi,0x30(%rdi)
 1009f90:	vmovups %zmm0,0x38(%rdi)
 1009f9a:	vmovups %zmm0,0x74(%rdi)
 1009fa4:	movq   $0xffffffffffffffff,0xb4(%rdi)
 1009faf:	movl   $0x0,0xbc(%rdi)
 1009fb9:	movq   $0x0,0xc0(%rdi)
 1009fc4:	mov    %r10w,0xc8(%rdi)
 1009fcc:	movl   $0x0,0xca(%rdi)
 1009fd6:	movw   $0x0,0xce(%rdi)
 1009fdf:	mov    %rax,0x68(%rsp)
 1009fe4:	mov    %rbx,%r11
 1009fe7:	mov    0x8c(%rdx),%r10d
 1009fee:	mov    0x364(%rdx),%eax
 1009ff4:	mov    %r10,0x98(%rsp)
 1009ffc:	cmp    %rbx,%r9
 1009fff:	je     100a04a <check_program+0x12a>
 100a001:	cmp    $0x1ffffffc,%eax
 100a006:	ja     100a04a <check_program+0x12a>
 100a008:	cmp    0x30(%r14),%eax
 100a00c:	jne    100a04a <check_program+0x12a>
 100a00e:	cmpl   $0x0,0xd8(%rcx)
 100a015:	jne    100a047 <check_program+0x127>
 100a017:	mov    0x98(%rsp),%r10
 100a01f:	cmp    %r10d,0xa0(%rcx)
 100a026:	jne    100a047 <check_program+0x127>
 100a028:	cmpl   $0x0,0xa4(%rcx)
 100a02f:	jne    100a047 <check_program+0x127>
 100a031:	cmpb   $0x0,0x3c5(%rdx)
 100a038:	jne    100a047 <check_program+0x127>
 100a03a:	cmpl   $0x0,0x230(%rdx)
 100a041:	je     10104e2 <check_program+0x65c2>
 100a047:	xor    %r12d,%r12d
 100a04a:	mov    0x8(%r9),%rcx
 100a04e:	lea    0x10(,%rax,8),%ebp
 100a055:	mov    %rdx,0x20(%rsp)
 100a05a:	mov    %rdi,0x8(%rsp)
 100a05f:	mov    %r9,0x40(%rsp)
 100a064:	mov    %r14,0x38(%rsp)
 100a069:	mov    %rax,0x10(%rsp)
 100a06e:	mov    %r8,0x188(%rsp)
 100a076:	mov    %r12d,0x50(%rsp)
 100a07b:	vmovd  %ebp,%xmm0
 100a07f:	mov    %rcx,0x178(%rsp)
 100a087:	mov    0x8(%r11),%rcx
 100a08b:	mov    %rcx,0x170(%rsp)
 100a093:	lea    0x1(%rax),%ecx
 100a096:	mov    %ecx,0xcc(%rsp)
 100a09d:	mov    %ecx,0xac(%rdi)
 100a0a3:	mov    %r12d,%ecx
 100a0a6:	xor    $0x1,%cl
 100a0a9:	movzbl %cl,%ecx
 100a0ac:	mov    %ecx,0xbc(%rdi)
 100a0b2:	test   %cl,%cl
 100a0b4:	jne    100a1a3 <check_program+0x283>
 100a0ba:	mov    (%r11),%rcx
 100a0bd:	mov    0x8(%r11),%rdi
 100a0c1:	mov    %eax,%eax
 100a0c3:	lea    0x4(,%rax,4),%rsi
 100a0cb:	mov    %rax,0x90(%rsp)
 100a0d3:	lea    0x3(%rdi,%rcx,1),%rbx
 100a0d8:	lea    (%rdi,%rcx,1),%r10
 100a0dc:	and    $0xfffffffffffffffc,%rbx
 100a0e0:	cmp    %r10,%rbx
 100a0e3:	jae    100a2cb <check_program+0x3ab>
 100a0e9:	xor    %r14d,%r14d
 100a0ec:	xor    %ebx,%ebx
 100a0ee:	movq   $0x0,0xe0(%rsp)
 100a0fa:	xor    %r15d,%r15d
 100a0fd:	mov    0x98(%rsp),%rdx
 100a105:	xor    %r12d,%r12d
 100a108:	movq   $0x0,0x60(%rsp)
 100a111:	mov    %r15,%r13
 100a114:	mov    %rbx,%rax
 100a117:	mov    %r14,0x30(%rsp)
 100a11c:	lea    0x4(,%rdx,4),%r10
 100a124:	mov    0x68(%rsp),%rdx
 100a129:	xor    %ebx,%ebx
 100a12b:	movq   $0x0,0x70(%rsp)
 100a134:	mov    %rbx,0x78(%rsp)
 100a139:	test   %rdx,%rdx
 100a13c:	je     100a154 <check_program+0x234>
 100a13e:	lea    0x3(%rdi,%rcx,1),%r11
 100a143:	lea    (%rdi,%rcx,1),%rbx
 100a147:	and    $0xfffffffffffffffc,%r11
 100a14b:	cmp    %rbx,%r11
 100a14e:	jae    100aad1 <check_program+0xbb1>
 100a154:	movq   $0x0,0xe8(%rsp)
 100a160:	lea    0x3(%rdi,%rcx,1),%rbx
 100a165:	lea    (%rdi,%rcx,1),%r11
 100a169:	and    $0xfffffffffffffffc,%rbx
 100a16d:	mov    %rbx,%r14
 100a170:	sub    %rcx,%r14
 100a173:	cmp    %r11,%rbx
 100a176:	jae    100a32a <check_program+0x40a>
 100a17c:	mov    $0x0,%edx
 100a181:	movq   $0x0,0x130(%rsp)
 100a18d:	mov    %rdx,0xd8(%rsp)
 100a195:	cmp    %r11,%rbx
 100a198:	jae    100a371 <check_program+0x451>
 100a19e:	jmp    100a3da <check_program+0x4ba>
 100a1a3:	mov    0x20(%rsp),%rbp
 100a1a8:	movq   $0x0,0x108(%rsp)
 100a1b4:	xor    %edx,%edx
 100a1b6:	movq   $0x0,0x80(%rsp)
 100a1c2:	xor    %eax,%eax
 100a1c4:	xor    %r11d,%r11d
 100a1c7:	movq   $0x0,0x28(%rsp)
 100a1d0:	movq   $0x0,0x148(%rsp)
 100a1dc:	movq   $0x0,0xf8(%rsp)
 100a1e8:	movq   $0x0,0x100(%rsp)
 100a1f4:	movq   $0x0,0xc0(%rsp)
 100a200:	movq   $0x0,0x120(%rsp)
 100a20c:	movq   $0x0,0xd8(%rsp)
 100a218:	movq   $0x0,0xe8(%rsp)
 100a224:	xor    %r12d,%r12d
 100a227:	xor    %r9d,%r9d
 100a22a:	xor    %edi,%edi
 100a22c:	xor    %ebx,%ebx
 100a22e:	xor    %esi,%esi
 100a230:	xor    %r8d,%r8d
 100a233:	xor    %r10d,%r10d
 100a236:	movq   $0x0,0x70(%rsp)
 100a23f:	movq   $0x0,0x130(%rsp)
 100a24b:	movq   $0x0,0xf0(%rsp)
 100a257:	movq   $0x0,0xd0(%rsp)
 100a263:	movq   $0x0,0x138(%rsp)
 100a26f:	movq   $0x0,0x128(%rsp)
 100a27b:	movq   $0x0,0x158(%rsp)
 100a287:	movq   $0x0,0x140(%rsp)
 100a293:	movq   $0x0,0x18(%rsp)
 100a29c:	xor    %r13d,%r13d
 100a29f:	xor    %r15d,%r15d
 100a2a2:	movq   $0x0,0x168(%rsp)
 100a2ae:	movq   $0x0,0xa8(%rsp)
 100a2ba:	movq   $0x0,0x160(%rsp)
 100a2c6:	jmp    100ad26 <check_program+0xe06>
 100a2cb:	mov    0x10(%r11),%r11
 100a2cf:	mov    %rbx,%r10
 100a2d2:	sub    %rcx,%r10
 100a2d5:	movq   $0x0,0xe0(%rsp)
 100a2e1:	sub    %r10,%r11
 100a2e4:	jb     100ab2c <check_program+0xc0c>
 100a2ea:	cmp    %r11,%rsi
 100a2ed:	ja     100ab2c <check_program+0xc0c>
 100a2f3:	mov    0x328(%rsp),%r11
 100a2fb:	mov    %rbx,0xe0(%rsp)
 100a303:	add    %rsi,%rbx
 100a306:	mov    %r10,%rdi
 100a309:	add    %rsi,%rdi
 100a30c:	mov    %rbx,%r10
 100a30f:	sub    %rcx,%r10
 100a312:	mov    %rdi,0x8(%r11)
 100a316:	mov    0x10(%r11),%r11
 100a31a:	xor    %eax,%eax
 100a31c:	sub    %r10,%r11
 100a31f:	jae    100ab43 <check_program+0xc23>
 100a325:	jmp    100d497 <check_program+0x3577>
 100a32a:	mov    0x328(%rsp),%r15
 100a332:	mov    0x10(%r15),%r15
 100a336:	sub    %r14,%r15
 100a339:	jb     100a17c <check_program+0x25c>
 100a33f:	cmp    %r15,%rsi
 100a342:	ja     100a17c <check_program+0x25c>
 100a348:	mov    0x328(%rsp),%rdi
 100a350:	mov    %rbx,%r11
 100a353:	add    %rsi,%r14
 100a356:	add    %rsi,%r11
 100a359:	mov    %rbx,0x130(%rsp)
 100a361:	mov    %r11,%rbx
 100a364:	mov    %r14,0x8(%rdi)
 100a368:	mov    %r14,%rdi
 100a36b:	mov    %r11,%r14
 100a36e:	sub    %rcx,%r14
 100a371:	mov    0x328(%rsp),%r15
 100a379:	movq   $0x0,0xd8(%rsp)
 100a385:	mov    0x10(%r15),%r15
 100a389:	sub    %r14,%r15
 100a38c:	jb     100a3da <check_program+0x4ba>
 100a38e:	mov    0x20(%rsp),%rdx
 100a393:	mov    %r12,%r9
 100a396:	mov    0x338(%rdx),%r12d
 100a39d:	lea    0x4(,%r12,4),%r12
 100a3a5:	cmp    %r15,%r12
 100a3a8:	ja     100a3d7 <check_program+0x4b7>
 100a3aa:	mov    0x328(%rsp),%r11
 100a3b2:	mov    %r14,%rdi
 100a3b5:	add    %r12,%rdi
 100a3b8:	mov    %rbx,0xd8(%rsp)
 100a3c0:	lea    0x3(%rcx,%rdi,1),%rbx
 100a3c5:	and    $0xfffffffffffffffc,%rbx
 100a3c9:	mov    %rbx,%r14
 100a3cc:	sub    %rcx,%r14
 100a3cf:	mov    %rdi,0x8(%r11)
 100a3d3:	lea    (%rdi,%rcx,1),%r11
 100a3d7:	mov    %r9,%r12
 100a3da:	cmp    %r11,%rbx
 100a3dd:	jae    100a3ed <check_program+0x4cd>
 100a3df:	movq   $0x0,0xf0(%rsp)
 100a3eb:	jmp    100a43c <check_program+0x51c>
 100a3ed:	mov    0x328(%rsp),%r15
 100a3f5:	movq   $0x0,0xf0(%rsp)
 100a401:	mov    0x10(%r15),%r15
 100a405:	sub    %r14,%r15
 100a408:	jb     100a43c <check_program+0x51c>
 100a40a:	cmp    %r15,%rsi
 100a40d:	ja     100a43c <check_program+0x51c>
 100a40f:	mov    0x328(%rsp),%r11
 100a417:	mov    %r14,%rdi
 100a41a:	add    %rsi,%rdi
 100a41d:	mov    %rbx,0xf0(%rsp)
 100a425:	lea    0x3(%rcx,%rdi,1),%rbx
 100a42a:	and    $0xfffffffffffffffc,%rbx
 100a42e:	mov    %rbx,%r14
 100a431:	sub    %rcx,%r14
 100a434:	mov    %rdi,0x8(%r11)
 100a438:	lea    (%rdi,%rcx,1),%r11
 100a43c:	cmp    %r11,%rbx
 100a43f:	jae    100a44f <check_program+0x52f>
 100a441:	movq   $0x0,0x120(%rsp)
 100a44d:	jmp    100a49e <check_program+0x57e>
 100a44f:	mov    0x328(%rsp),%r15
 100a457:	movq   $0x0,0x120(%rsp)
 100a463:	mov    0x10(%r15),%r15
 100a467:	sub    %r14,%r15
 100a46a:	jb     100a49e <check_program+0x57e>
 100a46c:	cmp    %r15,%rsi
 100a46f:	ja     100a49e <check_program+0x57e>
 100a471:	mov    0x328(%rsp),%r11
 100a479:	mov    %r14,%rdi
 100a47c:	add    %rsi,%rdi
 100a47f:	mov    %rbx,0x120(%rsp)
 100a487:	lea    0x3(%rcx,%rdi,1),%rbx
 100a48c:	and    $0xfffffffffffffffc,%rbx
 100a490:	mov    %rbx,%r14
 100a493:	sub    %rcx,%r14
 100a496:	mov    %rdi,0x8(%r11)
 100a49a:	lea    (%rdi,%rcx,1),%r11
 100a49e:	cmp    %r11,%rbx
 100a4a1:	jae    100a4b1 <check_program+0x591>
 100a4a3:	movq   $0x0,0xd0(%rsp)
 100a4af:	jmp    100a500 <check_program+0x5e0>
 100a4b1:	mov    0x328(%rsp),%r15
 100a4b9:	movq   $0x0,0xd0(%rsp)
 100a4c5:	mov    0x10(%r15),%r15
 100a4c9:	sub    %r14,%r15
 100a4cc:	jb     100a500 <check_program+0x5e0>
 100a4ce:	cmp    %r15,%rsi
 100a4d1:	ja     100a500 <check_program+0x5e0>
 100a4d3:	mov    0x328(%rsp),%r11
 100a4db:	mov    %r14,%rdi
 100a4de:	add    %rsi,%rdi
 100a4e1:	mov    %rbx,0xd0(%rsp)
 100a4e9:	lea    0x3(%rcx,%rdi,1),%rbx
 100a4ee:	and    $0xfffffffffffffffc,%rbx
 100a4f2:	mov    %rbx,%r14
 100a4f5:	sub    %rcx,%r14
 100a4f8:	mov    %rdi,0x8(%r11)
 100a4fc:	lea    (%rdi,%rcx,1),%r11
 100a500:	cmp    %r11,%rbx
 100a503:	jae    100a513 <check_program+0x5f3>
 100a505:	movq   $0x0,0xc0(%rsp)
 100a511:	jmp    100a562 <check_program+0x642>
 100a513:	mov    0x328(%rsp),%r15
 100a51b:	movq   $0x0,0xc0(%rsp)
 100a527:	mov    0x10(%r15),%r15
 100a52b:	sub    %r14,%r15
 100a52e:	jb     100a562 <check_program+0x642>
 100a530:	cmp    %r15,%rsi
 100a533:	ja     100a562 <check_program+0x642>
 100a535:	mov    0x328(%rsp),%r11
 100a53d:	mov    %r14,%rdi
 100a540:	add    %rsi,%rdi
 100a543:	mov    %rbx,0xc0(%rsp)
 100a54b:	lea    0x3(%rcx,%rdi,1),%rbx
 100a550:	and    $0xfffffffffffffffc,%rbx
 100a554:	mov    %rbx,%r14
 100a557:	sub    %rcx,%r14
 100a55a:	mov    %rdi,0x8(%r11)
 100a55e:	lea    (%rdi,%rcx,1),%r11
 100a562:	cmp    %r11,%rbx
 100a565:	jae    100a575 <check_program+0x655>
 100a567:	movq   $0x0,0x138(%rsp)
 100a573:	jmp    100a5c4 <check_program+0x6a4>
 100a575:	mov    0x328(%rsp),%r15
 100a57d:	movq   $0x0,0x138(%rsp)
 100a589:	mov    0x10(%r15),%r15
 100a58d:	sub    %r14,%r15
 100a590:	jb     100a5c4 <check_program+0x6a4>
 100a592:	cmp    %r15,%rsi
 100a595:	ja     100a5c4 <check_program+0x6a4>
 100a597:	mov    0x328(%rsp),%r11
 100a59f:	mov    %r14,%rdi
 100a5a2:	add    %rsi,%rdi
 100a5a5:	mov    %rbx,0x138(%rsp)
 100a5ad:	lea    0x3(%rcx,%rdi,1),%rbx
 100a5b2:	and    $0xfffffffffffffffc,%rbx
 100a5b6:	mov    %rbx,%r14
 100a5b9:	sub    %rcx,%r14
 100a5bc:	mov    %rdi,0x8(%r11)
 100a5c0:	lea    (%rdi,%rcx,1),%r11
 100a5c4:	cmp    %r11,%rbx
 100a5c7:	jae    100a5d7 <check_program+0x6b7>
 100a5c9:	movq   $0x0,0x100(%rsp)
 100a5d5:	jmp    100a626 <check_program+0x706>
 100a5d7:	mov    0x328(%rsp),%r15
 100a5df:	movq   $0x0,0x100(%rsp)
 100a5eb:	mov    0x10(%r15),%r15
 100a5ef:	sub    %r14,%r15
 100a5f2:	jb     100a626 <check_program+0x706>
 100a5f4:	cmp    %r15,%rsi
 100a5f7:	ja     100a626 <check_program+0x706>
 100a5f9:	mov    0x328(%rsp),%r11
 100a601:	mov    %r14,%rdi
 100a604:	add    %rsi,%rdi
 100a607:	mov    %rbx,0x100(%rsp)
 100a60f:	lea    0x3(%rcx,%rdi,1),%rbx
 100a614:	and    $0xfffffffffffffffc,%rbx
 100a618:	mov    %rbx,%r14
 100a61b:	sub    %rcx,%r14
 100a61e:	mov    %rdi,0x8(%r11)
 100a622:	lea    (%rdi,%rcx,1),%r11
 100a626:	cmp    %r11,%rbx
 100a629:	jae    100a639 <check_program+0x719>
 100a62b:	movq   $0x0,0x128(%rsp)
 100a637:	jmp    100a688 <check_program+0x768>
 100a639:	mov    0x328(%rsp),%r15
 100a641:	movq   $0x0,0x128(%rsp)
 100a64d:	mov    0x10(%r15),%r15
 100a651:	sub    %r14,%r15
 100a654:	jb     100a688 <check_program+0x768>
 100a656:	cmp    %r15,%rsi
 100a659:	ja     100a688 <check_program+0x768>
 100a65b:	mov    0x328(%rsp),%r11
 100a663:	mov    %r14,%rdi
 100a666:	add    %rsi,%rdi
 100a669:	mov    %rbx,0x128(%rsp)
 100a671:	lea    0x3(%rcx,%rdi,1),%rbx
 100a676:	and    $0xfffffffffffffffc,%rbx
 100a67a:	mov    %rbx,%r14
 100a67d:	sub    %rcx,%r14
 100a680:	mov    %rdi,0x8(%r11)
 100a684:	lea    (%rdi,%rcx,1),%r11
 100a688:	cmp    %r11,%rbx
 100a68b:	jae    100a69b <check_program+0x77b>
 100a68d:	movq   $0x0,0xf8(%rsp)
 100a699:	jmp    100a6ea <check_program+0x7ca>
 100a69b:	mov    0x328(%rsp),%r15
 100a6a3:	movq   $0x0,0xf8(%rsp)
 100a6af:	mov    0x10(%r15),%r15
 100a6b3:	sub    %r14,%r15
 100a6b6:	jb     100a6ea <check_program+0x7ca>
 100a6b8:	cmp    %r15,%rsi
 100a6bb:	ja     100a6ea <check_program+0x7ca>
 100a6bd:	mov    0x328(%rsp),%r11
 100a6c5:	mov    %r14,%rdi
 100a6c8:	add    %rsi,%rdi
 100a6cb:	mov    %rbx,0xf8(%rsp)
 100a6d3:	lea    0x3(%rcx,%rdi,1),%rbx
 100a6d8:	and    $0xfffffffffffffffc,%rbx
 100a6dc:	mov    %rbx,%r14
 100a6df:	sub    %rcx,%r14
 100a6e2:	mov    %rdi,0x8(%r11)
 100a6e6:	lea    (%rdi,%rcx,1),%r11
 100a6ea:	cmp    %r11,%rbx
 100a6ed:	jae    100a6fd <check_program+0x7dd>
 100a6ef:	movq   $0x0,0x158(%rsp)
 100a6fb:	jmp    100a74c <check_program+0x82c>
 100a6fd:	mov    0x328(%rsp),%r15
 100a705:	movq   $0x0,0x158(%rsp)
 100a711:	mov    0x10(%r15),%r15
 100a715:	sub    %r14,%r15
 100a718:	jb     100a74c <check_program+0x82c>
 100a71a:	cmp    %r15,%rsi
 100a71d:	ja     100a74c <check_program+0x82c>
 100a71f:	mov    0x328(%rsp),%r11
 100a727:	mov    %r14,%rdi
 100a72a:	add    %rsi,%rdi
 100a72d:	mov    %rbx,0x158(%rsp)
 100a735:	lea    0x3(%rcx,%rdi,1),%rbx
 100a73a:	and    $0xfffffffffffffffc,%rbx
 100a73e:	mov    %rbx,%r14
 100a741:	sub    %rcx,%r14
 100a744:	mov    %rdi,0x8(%r11)
 100a748:	lea    (%rdi,%rcx,1),%r11
 100a74c:	cmp    %r11,%rbx
 100a74f:	jae    100a75f <check_program+0x83f>
 100a751:	movq   $0x0,0x148(%rsp)
 100a75d:	jmp    100a7ae <check_program+0x88e>
 100a75f:	mov    0x328(%rsp),%r15
 100a767:	movq   $0x0,0x148(%rsp)
 100a773:	mov    0x10(%r15),%r15
 100a777:	sub    %r14,%r15
 100a77a:	jb     100a7ae <check_program+0x88e>
 100a77c:	cmp    %r15,%rsi
 100a77f:	ja     100a7ae <check_program+0x88e>
 100a781:	mov    0x328(%rsp),%r11
 100a789:	mov    %r14,%rdi
 100a78c:	add    %rsi,%rdi
 100a78f:	mov    %rbx,0x148(%rsp)
 100a797:	lea    0x3(%rcx,%rdi,1),%rbx
 100a79c:	and    $0xfffffffffffffffc,%rbx
 100a7a0:	mov    %rbx,%r14
 100a7a3:	sub    %rcx,%r14
 100a7a6:	mov    %rdi,0x8(%r11)
 100a7aa:	lea    (%rdi,%rcx,1),%r11
 100a7ae:	cmp    %r11,%rbx
 100a7b1:	jae    100a7c1 <check_program+0x8a1>
 100a7b3:	movq   $0x0,0x140(%rsp)
 100a7bf:	jmp    100a810 <check_program+0x8f0>
 100a7c1:	mov    0x328(%rsp),%r15
 100a7c9:	movq   $0x0,0x140(%rsp)
 100a7d5:	mov    0x10(%r15),%r15
 100a7d9:	sub    %r14,%r15
 100a7dc:	jb     100a810 <check_program+0x8f0>
 100a7de:	cmp    %r15,%rsi
 100a7e1:	ja     100a810 <check_program+0x8f0>
 100a7e3:	mov    0x328(%rsp),%r11
 100a7eb:	mov    %r14,%rdi
 100a7ee:	add    %rsi,%rdi
 100a7f1:	mov    %rbx,0x140(%rsp)
 100a7f9:	lea    0x3(%rcx,%rdi,1),%rbx
 100a7fe:	and    $0xfffffffffffffffc,%rbx
 100a802:	mov    %rbx,%r14
 100a805:	sub    %rcx,%r14
 100a808:	mov    %rdi,0x8(%r11)
 100a80c:	lea    (%rdi,%rcx,1),%r11
 100a810:	cmp    %r11,%rbx
 100a813:	jae    100a820 <check_program+0x900>
 100a815:	movq   $0x0,0x28(%rsp)
 100a81e:	jmp    100a869 <check_program+0x949>
 100a820:	mov    0x328(%rsp),%r15
 100a828:	movq   $0x0,0x28(%rsp)
 100a831:	mov    0x10(%r15),%r15
 100a835:	sub    %r14,%r15
 100a838:	jb     100a869 <check_program+0x949>
 100a83a:	cmp    %r15,%rsi
 100a83d:	ja     100a869 <check_program+0x949>
 100a83f:	mov    0x328(%rsp),%r11
 100a847:	mov    %r14,%rdi
 100a84a:	add    %rsi,%rdi
 100a84d:	mov    %rbx,0x28(%rsp)
 100a852:	lea    0x3(%rcx,%rdi,1),%rbx
 100a857:	and    $0xfffffffffffffffc,%rbx
 100a85b:	mov    %rbx,%r14
 100a85e:	sub    %rcx,%r14
 100a861:	mov    %rdi,0x8(%r11)
 100a865:	lea    (%rdi,%rcx,1),%r11
 100a869:	cmp    %r11,%rbx
 100a86c:	jae    100a879 <check_program+0x959>
 100a86e:	movq   $0x0,0x18(%rsp)
 100a877:	jmp    100a8dc <check_program+0x9bc>
 100a879:	mov    0x328(%rsp),%r15
 100a881:	movq   $0x0,0x18(%rsp)
 100a88a:	mov    0x10(%r15),%r15
 100a88e:	sub    %r14,%r15
 100a891:	jb     100a8dc <check_program+0x9bc>
 100a893:	mov    0x20(%rsp),%rdx
 100a898:	mov    %r12,%r9
 100a89b:	mov    0x328(%rdx),%r12d
 100a8a2:	lea    0x4(,%r12,4),%r12
 100a8aa:	cmp    %r15,%r12
 100a8ad:	ja     100a8d9 <check_program+0x9b9>
 100a8af:	mov    0x328(%rsp),%r11
 100a8b7:	mov    %r14,%rdi
 100a8ba:	add    %r12,%rdi
 100a8bd:	mov    %rbx,0x18(%rsp)
 100a8c2:	lea    0x3(%rcx,%rdi,1),%rbx
 100a8c7:	and    $0xfffffffffffffffc,%rbx
 100a8cb:	mov    %rbx,%r14
 100a8ce:	sub    %rcx,%r14
 100a8d1:	mov    %rdi,0x8(%r11)
 100a8d5:	lea    (%rdi,%rcx,1),%r11
 100a8d9:	mov    %r9,%r12
 100a8dc:	mov    %ebp,%r9d
 100a8df:	cmp    %r11,%rbx
 100a8e2:	jae    100a8f7 <check_program+0x9d7>
 100a8e4:	mov    0x20(%rsp),%rbp
 100a8e9:	movq   $0x0,0x88(%rsp)
 100a8f5:	jmp    100a959 <check_program+0xa39>
 100a8f7:	mov    0x328(%rsp),%r15
 100a8ff:	mov    0x20(%rsp),%rbp
 100a904:	movq   $0x0,0x88(%rsp)
 100a910:	mov    0x10(%r15),%r15
 100a914:	sub    %r14,%r15
 100a917:	jb     100a959 <check_program+0xa39>
 100a919:	mov    %r12,%rdx
 100a91c:	lea    0x0(,%r9,4),%r12
 100a924:	cmp    %r15,%r12
 100a927:	ja     100a956 <check_program+0xa36>
 100a929:	mov    0x328(%rsp),%r11
 100a931:	mov    %r14,%rdi
 100a934:	add    %r12,%rdi
 100a937:	mov    %rbx,0x88(%rsp)
 100a93f:	lea    0x3(%rcx,%rdi,1),%rbx
 100a944:	and    $0xfffffffffffffffc,%rbx
 100a948:	mov    %rbx,%r14
 100a94b:	sub    %rcx,%r14
 100a94e:	mov    %rdi,0x8(%r11)
 100a952:	lea    (%rdi,%rcx,1),%r11
 100a956:	mov    %rdx,%r12
 100a959:	mov    %r13,0xa0(%rsp)
 100a961:	mov    %rax,0x58(%rsp)
 100a966:	cmp    %r11,%rbx
 100a969:	jae    100a970 <check_program+0xa50>
 100a96b:	xor    %r13d,%r13d
 100a96e:	jmp    100a9b1 <check_program+0xa91>
 100a970:	mov    0x328(%rsp),%r15
 100a978:	xor    %r13d,%r13d
 100a97b:	mov    0x10(%r15),%r15
 100a97f:	sub    %r14,%r15
 100a982:	jb     100a9b1 <check_program+0xa91>
 100a984:	cmp    %r15,%r10
 100a987:	ja     100a9b1 <check_program+0xa91>
 100a989:	mov    0x328(%rsp),%r11
 100a991:	mov    %r14,%rdi
 100a994:	add    %r10,%rdi
 100a997:	mov    %rbx,%r13
 100a99a:	lea    0x3(%rcx,%rdi,1),%rbx
 100a99f:	and    $0xfffffffffffffffc,%rbx
 100a9a3:	mov    %rbx,%r14
 100a9a6:	sub    %rcx,%r14
 100a9a9:	mov    %rdi,0x8(%r11)
 100a9ad:	lea    (%rdi,%rcx,1),%r11
 100a9b1:	cmp    %r11,%rbx
 100a9b4:	jae    100a9ba <check_program+0xa9a>
 100a9b6:	xor    %eax,%eax
 100a9b8:	jmp    100a9fa <check_program+0xada>
 100a9ba:	mov    0x328(%rsp),%r15
 100a9c2:	xor    %eax,%eax
 100a9c4:	mov    0x10(%r15),%r15
 100a9c8:	sub    %r14,%r15
 100a9cb:	jb     100a9fa <check_program+0xada>
 100a9cd:	cmp    %r15,%r10
 100a9d0:	ja     100a9fa <check_program+0xada>
 100a9d2:	mov    %r14,%rdi
 100a9d5:	add    %r10,%rdi
 100a9d8:	mov    0x328(%rsp),%rdx
 100a9e0:	mov    %rbx,%rax
 100a9e3:	lea    0x3(%rcx,%rdi,1),%rbx
 100a9e8:	lea    (%rdi,%rcx,1),%r11
 100a9ec:	and    $0xfffffffffffffffc,%rbx
 100a9f0:	mov    %rbx,%r14
 100a9f3:	sub    %rcx,%r14
 100a9f6:	mov    %rdi,0x8(%rdx)
 100a9fa:	cmp    %r11,%rbx
 100a9fd:	jae    100aa04 <check_program+0xae4>
 100a9ff:	xor    %r15d,%r15d
 100aa02:	jmp    100aa36 <check_program+0xb16>
 100aa04:	mov    0x328(%rsp),%r10
 100aa0c:	xor    %r15d,%r15d
 100aa0f:	mov    0x10(%r10),%r10
 100aa13:	sub    %r14,%r10
 100aa16:	jb     100aa36 <check_program+0xb16>
 100aa18:	cmp    %r10,%rsi
 100aa1b:	ja     100aa36 <check_program+0xb16>
 100aa1d:	mov    0x328(%rsp),%rdi
 100aa25:	add    %rsi,%r14
 100aa28:	mov    %rbx,%r15
 100aa2b:	lea    (%r14,%rcx,1),%r11
 100aa2f:	mov    %r14,0x8(%rdi)
 100aa33:	mov    %r14,%rdi
 100aa36:	mov    0x328(%rsp),%r8
 100aa3e:	lea    0x7(%r11),%r10
 100aa42:	and    $0xfffffffffffffff8,%r10
 100aa46:	mov    0x10(%r8),%r8
 100aa4a:	cmp    %r11,%r10
 100aa4d:	jae    100aa79 <check_program+0xb59>
 100aa4f:	mov    0x38(%rsp),%r14
 100aa54:	mov    0x90(%rsp),%rsi
 100aa5c:	movq   $0x0,0x80(%rsp)
 100aa68:	movq   $0x0,0x168(%rsp)
 100aa74:	jmp    100abcf <check_program+0xcaf>
 100aa79:	mov    0x98(%rsp),%rdx
 100aa81:	mov    0x90(%rsp),%rsi
 100aa89:	mov    %r10,%rbx
 100aa8c:	sub    %rcx,%rbx
 100aa8f:	sub    %rbx,%r8
 100aa92:	lea    0x8(,%rdx,8),%r11
 100aa9a:	jb     100ab7f <check_program+0xc5f>
 100aaa0:	cmp    %r8,%r11
 100aaa3:	ja     100ab7f <check_program+0xc5f>
 100aaa9:	mov    0x328(%rsp),%r8
 100aab1:	mov    %r10,0x80(%rsp)
 100aab9:	add    %r11,%r10
 100aabc:	mov    %rbx,%rdi
 100aabf:	add    %r11,%rdi
 100aac2:	mov    %r10,%rbx
 100aac5:	sub    %rcx,%rbx
 100aac8:	mov    %rdi,0x8(%r8)
 100aacc:	jmp    100ab93 <check_program+0xc73>
 100aad1:	mov    0x328(%rsp),%r14
 100aad9:	mov    %r11,%rbx
 100aadc:	sub    %rcx,%rbx
 100aadf:	movq   $0x0,0xe8(%rsp)
 100aaeb:	mov    0x10(%r14),%r14
 100aaef:	sub    %rbx,%r14
 100aaf2:	jb     100a160 <check_program+0x240>
 100aaf8:	mov    0x18(%rdx),%r15d
 100aafc:	lea    0x4(,%r15,4),%r15
 100ab04:	cmp    %r14,%r15
 100ab07:	ja     100a160 <check_program+0x240>
 100ab0d:	mov    0x328(%rsp),%rdi
 100ab15:	add    %r15,%rbx
 100ab18:	mov    %r11,0xe8(%rsp)
 100ab20:	mov    %rbx,0x8(%rdi)
 100ab24:	mov    %rbx,%rdi
 100ab27:	jmp    100a160 <check_program+0x240>
 100ab2c:	mov    0x328(%rsp),%r11
 100ab34:	mov    0x10(%r11),%r11
 100ab38:	xor    %eax,%eax
 100ab3a:	sub    %r10,%r11
 100ab3d:	jb     100d497 <check_program+0x3577>
 100ab43:	cmp    %r11,%rsi
 100ab46:	ja     100d497 <check_program+0x3577>
 100ab4c:	mov    0x328(%rsp),%rdi
 100ab54:	add    %rsi,%r10
 100ab57:	lea    0x3(%rcx,%r10,1),%r15
 100ab5c:	lea    (%r10,%rcx,1),%rax
 100ab60:	and    $0xfffffffffffffffc,%r15
 100ab64:	mov    %r10,0x8(%rdi)
 100ab68:	cmp    %rax,%r15
 100ab6b:	jae    100d807 <check_program+0x38e7>
 100ab71:	xor    %r14d,%r14d
 100ab74:	xor    %r15d,%r15d
 100ab77:	mov    %r10,%rdi
 100ab7a:	jmp    100a0fd <check_program+0x1dd>
 100ab7f:	mov    0x328(%rsp),%r8
 100ab87:	movq   $0x0,0x80(%rsp)
 100ab93:	mov    0x10(%r8),%r8
 100ab97:	movq   $0x0,0x168(%rsp)
 100aba3:	mov    %r8,%r14
 100aba6:	sub    %rbx,%r14
 100aba9:	jb     100abca <check_program+0xcaa>
 100abab:	cmp    %r14,%r11
 100abae:	ja     100abca <check_program+0xcaa>
 100abb0:	mov    0x328(%rsp),%rdi
 100abb8:	add    %r11,%rbx
 100abbb:	mov    %r10,0x168(%rsp)
 100abc3:	mov    %rbx,0x8(%rdi)
 100abc7:	mov    %rbx,%rdi
 100abca:	mov    0x38(%rsp),%r14
 100abcf:	mov    0xe0(%rsp),%rbx
 100abd7:	mov    %r8,%r10
 100abda:	sub    %rdi,%r10
 100abdd:	setb   %r11b
 100abe1:	cmp    %rsi,%r10
 100abe4:	setbe  %r10b
 100abe8:	or     %r11b,%r10b
 100abeb:	je     100abfa <check_program+0xcda>
 100abed:	xor    %edx,%edx
 100abef:	cmpl   $0x0,0x308(%rbp)
 100abf6:	jne    100ac1a <check_program+0xcfa>
 100abf8:	jmp    100ac30 <check_program+0xd10>
 100abfa:	mov    0x328(%rsp),%r10
 100ac02:	mov    %rdi,%rdx
 100ac05:	lea    0x1(%rsi,%rdi,1),%rdi
 100ac0a:	add    %rcx,%rdx
 100ac0d:	mov    %rdi,0x8(%r10)
 100ac11:	cmpl   $0x0,0x308(%rbp)
 100ac18:	je     100ac30 <check_program+0xd10>
 100ac1a:	mov    %r8,%r10
 100ac1d:	sub    %rdi,%r10
 100ac20:	setb   %r11b
 100ac24:	cmp    %rsi,%r10
 100ac27:	setbe  %r10b
 100ac2b:	or     %r11b,%r10b
 100ac2e:	je     100ac3e <check_program+0xd1e>
 100ac30:	movq   $0x0,0xa8(%rsp)
 100ac3c:	jmp    100ac60 <check_program+0xd40>
 100ac3e:	mov    %rsi,%r10
 100ac41:	mov    %rdi,%rsi
 100ac44:	lea    0x1(%r10,%rdi,1),%rdi
 100ac49:	mov    0x328(%rsp),%r10
 100ac51:	add    %rcx,%rsi
 100ac54:	mov    %rsi,0xa8(%rsp)
 100ac5c:	mov    %rdi,0x8(%r10)
 100ac60:	lea    0x3(%rdi,%rcx,1),%rsi
 100ac65:	add    %rcx,%rdi
 100ac68:	and    $0xfffffffffffffffc,%rsi
 100ac6c:	cmp    %rdi,%rsi
 100ac6f:	jae    100ac8b <check_program+0xd6b>
 100ac71:	movq   $0x0,0x108(%rsp)
 100ac7d:	movq   $0x0,0x160(%rsp)
 100ac89:	jmp    100ad02 <check_program+0xde2>
 100ac8b:	mov    %rsi,%rdi
 100ac8e:	sub    %rcx,%rdi
 100ac91:	mov    %r8,%r11
 100ac94:	movq   $0x0,0x108(%rsp)
 100aca0:	sub    %rdi,%r11
 100aca3:	jb     100acd1 <check_program+0xdb1>
 100aca5:	mov    %r9,%r10
 100aca8:	shl    $0x4,%r10
 100acac:	cmp    %r11,%r10
 100acaf:	ja     100acd1 <check_program+0xdb1>
 100acb1:	mov    0x328(%rsp),%r11
 100acb9:	mov    %rsi,0x108(%rsp)
 100acc1:	add    %r10,%rdi
 100acc4:	add    %r10,%rsi
 100acc7:	mov    %rdi,0x8(%r11)
 100accb:	mov    %rsi,%rdi
 100acce:	sub    %rcx,%rdi
 100acd1:	sub    %rdi,%r8
 100acd4:	movq   $0x0,0x160(%rsp)
 100ace0:	jb     100ad02 <check_program+0xde2>
 100ace2:	shl    $0x5,%r9
 100ace6:	cmp    %r8,%r9
 100ace9:	ja     100ad02 <check_program+0xde2>
 100aceb:	mov    0x328(%rsp),%rcx
 100acf3:	add    %r9,%rdi
 100acf6:	mov    %rsi,0x160(%rsp)
 100acfe:	mov    %rdi,0x8(%rcx)
 100ad02:	mov    0x58(%rsp),%rsi
 100ad07:	mov    0xa0(%rsp),%rdi
 100ad0f:	mov    0x30(%rsp),%r8
 100ad14:	mov    0x60(%rsp),%r9
 100ad19:	mov    0x78(%rsp),%r10
 100ad1e:	mov    0x88(%rsp),%r11
 100ad26:	test   %rbx,%rbx
 100ad29:	mov    %rsi,0x58(%rsp)
 100ad2e:	mov    %rdi,0xa0(%rsp)
 100ad36:	vpslldq $0xc,%xmm0,%xmm0
 100ad3b:	mov    %r15,0xb0(%rsp)
 100ad43:	mov    %r8,0x30(%rsp)
 100ad48:	mov    %r9,0x60(%rsp)
 100ad4d:	mov    %r10,0x78(%rsp)
 100ad52:	mov    %r11,0x88(%rsp)
 100ad5a:	mov    %r13,0xb8(%rsp)
 100ad62:	mov    %rax,0x90(%rsp)
 100ad6a:	mov    %rdx,0x48(%rsp)
 100ad6f:	setne  %cl
 100ad72:	test   %rsi,%rsi
 100ad75:	setne  %sil
 100ad79:	and    %cl,%sil
 100ad7c:	test   %rdi,%rdi
 100ad7f:	setne  %cl
 100ad82:	test   %r8,%r8
 100ad85:	setne  %dil
 100ad89:	and    %cl,%dil
 100ad8c:	and    %sil,%dil
 100ad8f:	test   %r9,%r9
 100ad92:	setne  %cl
 100ad95:	test   %r10,%r10
 100ad98:	setne  %sil
 100ad9c:	and    %cl,%sil
 100ad9f:	test   %r12,%r12
 100ada2:	setne  %cl
 100ada5:	and    %sil,%cl
 100ada8:	and    %dil,%cl
 100adab:	test   %r11,%r11
 100adae:	setne  %sil
 100adb2:	test   %r13,%r13
 100adb5:	setne  %dil
 100adb9:	and    %sil,%dil
 100adbc:	test   %rax,%rax
 100adbf:	setne  %sil
 100adc3:	and    %dil,%sil
 100adc6:	test   %r15,%r15
 100adc9:	setne  %dil
 100adcd:	and    %sil,%dil
 100add0:	and    %cl,%dil
 100add3:	test   %rdx,%rdx
 100add6:	setne  %cl
 100add9:	and    0x50(%rsp),%cl
 100addd:	and    %dil,%cl
 100ade0:	cmp    $0x1,%cl
 100ade3:	jne    100af89 <check_program+0x1069>
 100ade9:	cmpl   $0x0,0x308(%rbp)
 100adf0:	sete   %cl
 100adf3:	cmpq   $0x0,0xa8(%rsp)
 100adfc:	setne  %dl
 100adff:	or     %cl,%dl
 100ae01:	cmp    $0x1,%dl
 100ae04:	jne    100af89 <check_program+0x1069>
 100ae0a:	cmpq   $0x0,0x108(%rsp)
 100ae13:	je     100af89 <check_program+0x1069>
 100ae19:	cmpq   $0x0,0x160(%rsp)
 100ae22:	je     100af89 <check_program+0x1069>
 100ae28:	cmpq   $0x0,0x70(%rsp)
 100ae2e:	je     100af89 <check_program+0x1069>
 100ae34:	cmpq   $0x0,0x68(%rsp)
 100ae3a:	setne  %al
 100ae3d:	cmpq   $0x0,0xe8(%rsp)
 100ae46:	sete   %cl
 100ae49:	test   %cl,%al
 100ae4b:	jne    100af89 <check_program+0x1069>
 100ae51:	cmpq   $0x0,0x100(%rsp)
 100ae5a:	je     100af89 <check_program+0x1069>
 100ae60:	cmpq   $0x0,0x128(%rsp)
 100ae69:	je     100af89 <check_program+0x1069>
 100ae6f:	cmpq   $0x0,0xf8(%rsp)
 100ae78:	je     100af89 <check_program+0x1069>
 100ae7e:	cmpq   $0x0,0x158(%rsp)
 100ae87:	je     100af89 <check_program+0x1069>
 100ae8d:	cmpq   $0x0,0x80(%rsp)
 100ae96:	je     100af89 <check_program+0x1069>
 100ae9c:	cmpq   $0x0,0x168(%rsp)
 100aea5:	je     100af89 <check_program+0x1069>
 100aeab:	cmpq   $0x0,0x148(%rsp)
 100aeb4:	je     100af89 <check_program+0x1069>
 100aeba:	cmpq   $0x0,0x140(%rsp)
 100aec3:	je     100af89 <check_program+0x1069>
 100aec9:	cmpq   $0x0,0x28(%rsp)
 100aecf:	je     100af89 <check_program+0x1069>
 100aed5:	cmpq   $0x0,0x18(%rsp)
 100aedb:	je     100af89 <check_program+0x1069>
 100aee1:	cmpq   $0x0,0x130(%rsp)
 100aeea:	je     100af89 <check_program+0x1069>
 100aef0:	cmpq   $0x0,0xd8(%rsp)
 100aef9:	je     100af89 <check_program+0x1069>
 100aeff:	cmpq   $0x0,0x138(%rsp)
 100af08:	je     100af89 <check_program+0x1069>
 100af0a:	cmpq   $0x0,0xf0(%rsp)
 100af13:	je     100af89 <check_program+0x1069>
 100af15:	cmpq   $0x0,0x120(%rsp)
 100af1e:	je     100af89 <check_program+0x1069>
 100af20:	cmpq   $0x0,0xd0(%rsp)
 100af29:	je     100af89 <check_program+0x1069>
 100af2b:	cmpq   $0x0,0xc0(%rsp)
 100af34:	je     100af89 <check_program+0x1069>
 100af36:	mov    0x8(%rsp),%rax
 100af3b:	mov    %rbx,0xe0(%rsp)
 100af43:	mov    %r12,0x150(%rsp)
 100af4b:	vmovapd %xmm0,0x190(%rsp)
 100af54:	mov    (%rax),%rbx
 100af57:	xor    %eax,%eax
 100af59:	mov    0x364(%rbx),%r9d
 100af60:	mov    %r9,0x50(%rsp)
 100af65:	test   %r9,%r9
 100af68:	je     100d8c7 <check_program+0x39a7>
 100af6e:	mov    0x50(%r14),%rcx
 100af72:	mov    %r9d,%edx
 100af75:	and    $0x7,%edx
 100af78:	cmp    $0x8,%r9d
 100af7c:	jae    100d8cf <check_program+0x39af>
 100af82:	xor    %esi,%esi
 100af84:	jmp    100dc69 <check_program+0x3d49>
 100af89:	mov    0x8(%rsp),%rcx
 100af8e:	cmpl   $0x0,0xbc(%rcx)
 100af95:	jne    100afa1 <check_program+0x1081>
 100af97:	movl   $0x3,0xbc(%rcx)
 100afa1:	movq   $0x0,0x40(%rcx)
 100afa9:	movq   $0x0,0x50(%rcx)
 100afb1:	mov    0x90(%rsp),%r13
 100afb9:	mov    0x328(%rbp),%eax
 100afbf:	mov    %eax,0x9c(%rcx)
 100afc5:	movq   $0x0,0x78(%rcx)
 100afcd:	movq   $0x0,0x88(%rcx)
 100afd8:	movq   $0x0,0x68(%rcx)
 100afe0:	mov    0x8(%rsp),%rdx
 100afe5:	mov    0x88(%rsp),%rsi
 100afed:	movl   $0x0,0xa8(%rdx)
 100aff7:	movq   $0x0,0x70(%rdx)
 100afff:	cmpl   $0x0,0xbc(%rdx)
 100b006:	jne    100b012 <check_program+0x10f2>
 100b008:	movl   $0x3,0xbc(%rdx)
 100b012:	xor    %ecx,%ecx
 100b014:	mov    0x58(%rsp),%rax
 100b019:	mov    0xa0(%rsp),%r8
 100b021:	mov    0x30(%rsp),%rdi
 100b026:	mov    %rdx,0x1a8(%rsp)
 100b02e:	mov    %r14,0x1b0(%rsp)
 100b036:	mov    %rbx,0x1b8(%rsp)
 100b03e:	cmpl   $0x0,0x10(%rsp)
 100b043:	mov    %rax,0x1c0(%rsp)
 100b04b:	mov    %r8,0x1c8(%rsp)
 100b053:	mov    %rdi,0x1d0(%rsp)
 100b05b:	mov    0x60(%rsp),%r8
 100b060:	mov    0x78(%rsp),%rdi
 100b065:	movl   $0x0,0x78(%rsp)
 100b06d:	mov    %r8,0x1d8(%rsp)
 100b075:	mov    %rdi,0x1e0(%rsp)
 100b07d:	mov    0x70(%rsp),%r8
 100b082:	mov    0xe8(%rsp),%rdi
 100b08a:	mov    %r12,0x1e8(%rsp)
 100b092:	mov    %rdx,%r12
 100b095:	mov    %r8,0x1f0(%rsp)
 100b09d:	mov    %rdi,0x1f8(%rsp)
 100b0a5:	mov    0x130(%rsp),%r8
 100b0ad:	mov    0xd8(%rsp),%rdi
 100b0b5:	mov    %ecx,0xd8(%rsp)
 100b0bc:	mov    %r8,0x200(%rsp)
 100b0c4:	mov    %rdi,0x208(%rsp)
 100b0cc:	mov    0xf0(%rsp),%r8
 100b0d4:	mov    0x120(%rsp),%rdi
 100b0dc:	mov    %r8,0x210(%rsp)
 100b0e4:	mov    %rdi,0x218(%rsp)
 100b0ec:	mov    0xd0(%rsp),%r8
 100b0f4:	mov    0xc0(%rsp),%rdi
 100b0fc:	mov    %r8,0x220(%rsp)
 100b104:	mov    %rdi,0x228(%rsp)
 100b10c:	mov    0x138(%rsp),%r8
 100b114:	mov    0x100(%rsp),%rdi
 100b11c:	mov    %r8,0x230(%rsp)
 100b124:	mov    %rdi,0x238(%rsp)
 100b12c:	mov    0x128(%rsp),%r8
 100b134:	mov    0xf8(%rsp),%rdi
 100b13c:	mov    %r8,0x240(%rsp)
 100b144:	mov    %rdi,0x248(%rsp)
 100b14c:	mov    0x158(%rsp),%r8
 100b154:	mov    0x148(%rsp),%rdi
 100b15c:	mov    %r8,0x250(%rsp)
 100b164:	mov    %rdi,0x258(%rsp)
 100b16c:	mov    0x140(%rsp),%r8
 100b174:	mov    0x28(%rsp),%rdi
 100b179:	mov    %r8,0x260(%rsp)
 100b181:	mov    %rdi,0x268(%rsp)
 100b189:	mov    0x18(%rsp),%r8
 100b18e:	mov    0xa8(%rsp),%rdi
 100b196:	mov    %r8,0x270(%rsp)
 100b19e:	mov    %rdi,0x278(%rsp)
 100b1a6:	mov    0x108(%rsp),%r8
 100b1ae:	mov    0x160(%rsp),%rdi
 100b1b6:	mov    %r8,0x280(%rsp)
 100b1be:	mov    %rdi,0x288(%rsp)
 100b1c6:	mov    %rsi,0x290(%rsp)
 100b1ce:	sete   %sil
 100b1d2:	xor    $0x1,%cl
 100b1d5:	vmovupd %xmm0,0x298(%rsp)
 100b1de:	vxorpd %xmm0,%xmm0,%xmm0
 100b1e2:	vmovupd %xmm0,0x2a8(%rsp)
 100b1eb:	or     %sil,%cl
 100b1ee:	jne    100d445 <check_program+0x3525>
 100b1f4:	mov    0x10(%rsp),%r14d
 100b1f9:	xor    %r15d,%r15d
 100b1fc:	movl   $0x0,0x78(%rsp)
 100b204:	mov    %r14,0x70(%rsp)
 100b209:	jmp    100b22c <check_program+0x130c>
 100b20b:	xor    %ecx,%ecx
 100b20d:	add    0x78(%rsp),%ecx
 100b211:	mov    %ecx,0x78(%rsp)
 100b215:	data16 cs nopw 0x0(%rax,%rax,1)
 100b220:	inc    %r15
 100b223:	cmp    %r14,%r15
 100b226:	jae    100d445 <check_program+0x3525>
 100b22c:	cmpl   $0x0,0xbc(%r12)
 100b235:	jne    100d445 <check_program+0x3525>
 100b23b:	mov    0x2d8(%rbp),%rax
 100b242:	mov    (%rax,%r15,4),%ecx
 100b246:	mov    $0xffffffff,%eax
 100b24b:	cmp    %rax,%rcx
 100b24e:	je     100b220 <check_program+0x1300>
 100b250:	mov    0x1f0(%rbp),%rax
 100b257:	test   %rax,%rax
 100b25a:	je     100b263 <check_program+0x1343>
 100b25c:	cmpb   $0x0,(%rax,%r15,1)
 100b261:	jne    100b220 <check_program+0x1300>
 100b263:	mov    %rcx,0x50(%rsp)
 100b268:	mov    0x1a8(%rsp),%rax
 100b270:	mov    0x1b0(%rsp),%rcx
 100b278:	mov    0x298(%rsp),%edx
 100b27f:	lea    0x0(,%r15,4),%rdi
 100b287:	mov    $0xff,%esi
 100b28c:	mov    (%rax),%rbx
 100b28f:	mov    0x60(%rcx),%rax
 100b293:	mov    %rdx,0x88(%rsp)
 100b29b:	mov    (%rax,%r15,4),%r14d
 100b29f:	movq   $0x0,0x29c(%rsp)
 100b2ab:	mov    %edx,0x2a8(%rsp)
 100b2b2:	mov    %r15d,0x2ac(%rsp)
 100b2ba:	mov    %r14d,0x2b0(%rsp)
 100b2c2:	mov    %r14,%rax
 100b2c5:	sub    %r15,%rax
 100b2c8:	add    0x250(%rsp),%rdi
 100b2d0:	lea    0x4(,%rax,4),%rdx
 100b2d8:	vzeroupper
 100b2db:	call   788430 <memset@plt>
 100b2e0:	lea    0x1(%r15),%rax
 100b2e4:	mov    %rax,0xa8(%rsp)
 100b2ec:	cmp    %r14,%rax
 100b2ef:	jae    100b3bd <check_program+0x149d>
 100b2f5:	mov    %r15d,%ecx
 100b2f8:	lea    0x1(%r15),%rdx
 100b2fc:	sub    %r14d,%ecx
 100b2ff:	mov    %rdx,%rax
 100b302:	test   $0x1,%cl
 100b305:	jne    100b3ae <check_program+0x148e>
 100b30b:	mov    0x1b0(%rsp),%rax
 100b313:	mov    0x50(%rax),%rax
 100b317:	movzbl (%rax,%rdx,1),%ecx
 100b31b:	cmp    $0x53,%ecx
 100b31e:	je     100b329 <check_program+0x1409>
 100b320:	cmp    $0x21,%ecx
 100b323:	jne    100b3aa <check_program+0x148a>
 100b329:	mov    0x2a0(%rsp),%eax
 100b330:	cmp    0x2a4(%rsp),%eax
 100b337:	jae    100b351 <check_program+0x1431>
 100b339:	mov    0x290(%rsp),%rdx
 100b341:	movl   $0xffffffff,(%rdx,%rax,4)
 100b348:	incl   0x2a0(%rsp)
 100b34f:	jmp    100b377 <check_program+0x1457>
 100b351:	mov    0x1a8(%rsp),%rdx
 100b359:	cmpl   $0x0,0xbc(%rdx)
 100b360:	jne    100b377 <check_program+0x1457>
 100b362:	movl   $0x3,0xbc(%rdx)
 100b36c:	movq   $0x0,0xb4(%rdx)
 100b377:	mov    0x250(%rsp),%rdx
 100b37f:	mov    %eax,0x4(%rdx,%r15,4)
 100b384:	cmp    $0x53,%cl
 100b387:	jne    100b3aa <check_program+0x148a>
 100b389:	mov    0x248(%rsp),%rdx
 100b391:	mov    0x1a8(%rsp),%rcx
 100b399:	mov    0x4(%rdx,%r15,4),%edx
 100b39e:	mov    0x48(%rcx),%rcx
 100b3a2:	shl    $0x6,%rdx
 100b3a6:	mov    %eax,0x2c(%rcx,%rdx,1)
 100b3aa:	lea    0x2(%r15),%rax
 100b3ae:	mov    %r14d,%ecx
 100b3b1:	sub    %r15d,%ecx
 100b3b4:	cmp    $0x2,%ecx
 100b3b7:	jne    100d00c <check_program+0x30ec>
 100b3bd:	mov    0x1c0(%rsp),%rax
 100b3c5:	mov    (%rax,%r14,4),%eax
 100b3c9:	jmp    100b40f <check_program+0x14ef>
 100b3cb:	nopl   0x0(%rax,%rax,1)
 100b3d0:	mov    0x288(%rsp),%rsi
 100b3d8:	lea    0x1(%rdx),%edi
 100b3db:	shl    $0x5,%rdx
 100b3df:	vxorpd %xmm0,%xmm0,%xmm0
 100b3e3:	mov    %edi,0x29c(%rsp)
 100b3ea:	vmovupd %xmm0,(%rsi,%rdx,1)
 100b3ef:	movl   $0x0,0x10(%rsi,%rdx,1)
 100b3f7:	mov    %eax,0x14(%rsi,%rdx,1)
 100b3fb:	movq   $0xffffffffffffffff,0x18(%rsi,%rdx,1)
 100b404:	mov    0x1d0(%rsp),%rax
 100b40c:	mov    (%rax,%rcx,4),%eax
 100b40f:	cmp    $0xffffffff,%eax
 100b412:	je     100b460 <check_program+0x1540>
 100b414:	mov    %eax,%ecx
 100b416:	cmp    %rcx,%r15
 100b419:	jae    100b404 <check_program+0x14e4>
 100b41b:	mov    0x29c(%rsp),%edx
 100b422:	cmp    0x2a4(%rsp),%edx
 100b429:	jb     100b3d0 <check_program+0x14b0>
 100b42b:	mov    0x1a8(%rsp),%rdx
 100b433:	cmpl   $0x0,0xbc(%rdx)
 100b43a:	jne    100b404 <check_program+0x14e4>
 100b43c:	movl   $0x3,0xbc(%rdx)
 100b446:	mov    %eax,0xb4(%rdx)
 100b44c:	mov    %eax,0xb8(%rdx)
 100b452:	jmp    100b404 <check_program+0x14e4>
 100b454:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 100b460:	mov    0x200(%rsp),%rax
 100b468:	cmpl   $0xffffffff,(%rax,%r15,4)
 100b46d:	je     100b4e0 <check_program+0x15c0>
 100b46f:	mov    0x29c(%rsp),%eax
 100b476:	cmp    0x2a4(%rsp),%eax
 100b47d:	jae    100b4b6 <check_program+0x1596>
 100b47f:	mov    0x288(%rsp),%rcx
 100b487:	lea    0x1(%rax),%edx
 100b48a:	shl    $0x5,%rax
 100b48e:	vxorpd %xmm0,%xmm0,%xmm0
 100b492:	mov    %edx,0x29c(%rsp)
 100b499:	movl   $0x1,(%rcx,%rax,1)
 100b4a0:	vmovupd %xmm0,0x4(%rcx,%rax,1)
 100b4a6:	mov    %r15d,0x14(%rcx,%rax,1)
 100b4ab:	movq   $0x0,0x18(%rcx,%rax,1)
 100b4b4:	jmp    100b4e0 <check_program+0x15c0>
 100b4b6:	mov    0x1a8(%rsp),%rax
 100b4be:	cmpl   $0x0,0xbc(%rax)
 100b4c5:	jne    100b4e0 <check_program+0x15c0>
 100b4c7:	movl   $0x3,0xbc(%rax)
 100b4d1:	mov    %r15d,0xb4(%rax)
 100b4d8:	mov    %r15d,0xb8(%rax)
 100b4df:	nop
 100b4e0:	lea    0x1a8(%rsp),%rdi
 100b4e8:	call   1107dc0 <check_control_drain>
 100b4ed:	mov    0x29c(%rsp),%eax
 100b4f4:	cmp    0x2a4(%rsp),%eax
 100b4fb:	jae    100b53b <check_program+0x161b>
 100b4fd:	vmovdqa -0xa8ed05(%rip),%ymm1        # 57c800 <static_test_starved.starved+0xc60>
 100b505:	vmovdqa -0xa8eced(%rip),%ymm2        # 57c820 <static_test_starved.starved+0xc80>
 100b50d:	mov    0x288(%rsp),%rcx
 100b515:	lea    0x1(%rax),%edx
 100b518:	shl    $0x5,%rax
 100b51c:	mov    %edx,0x29c(%rsp)
 100b523:	vpinsrd $0x2,%r14d,%xmm1,%xmm0
 100b529:	vpblendd $0xf,%ymm0,%ymm1,%ymm0
 100b52f:	vpermd %ymm0,%ymm2,%ymm0
 100b534:	vmovdqu %ymm0,(%rcx,%rax,1)
 100b539:	jmp    100b570 <check_program+0x1650>
 100b53b:	mov    0x1a8(%rsp),%rax
 100b543:	cmpl   $0x0,0xbc(%rax)
 100b54a:	jne    100b570 <check_program+0x1650>
 100b54c:	movl   $0x3,0xbc(%rax)
 100b556:	mov    %r14d,0xb4(%rax)
 100b55d:	mov    %r14d,0xb8(%rax)
 100b564:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 100b570:	lea    0x1a8(%rsp),%rdi
 100b578:	vzeroupper
 100b57b:	call   1107dc0 <check_control_drain>
 100b580:	mov    0x298(%rsp),%ecx
 100b587:	mov    0x2a8(%rsp),%eax
 100b58e:	mov    %r15,0x60(%rsp)
 100b593:	mov    %ecx,%edx
 100b595:	sub    %eax,%edx
 100b597:	mov    %edx,0x2b4(%rsp)
 100b59e:	mov    0x268(%rsp),%rdx
 100b5a6:	mov    (%rdx,%r15,4),%edx
 100b5aa:	cmp    $0xffffffff,%edx
 100b5ad:	je     100b94f <check_program+0x1a2f>
 100b5b3:	mov    0x1a8(%rsp),%rcx
 100b5bb:	mov    %rbx,0x58(%rsp)
 100b5c0:	jmp    100b615 <check_program+0x16f5>
 100b5c2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100b5d0:	mov    0x1a8(%rsp),%rcx
 100b5d8:	mov    0x90(%rsp),%r13
 100b5e0:	mov    0x60(%rsp),%r15
 100b5e5:	cmpl   $0x0,0xbc(%rcx)
 100b5ec:	je     100b8b0 <check_program+0x1990>
 100b5f2:	mov    0x8(%rsp),%r12
 100b5f7:	mov    0x20(%rsp),%rbp
 100b5fc:	mov    0x28(%rsp),%rdx
 100b601:	mov    0x270(%rsp),%rax
 100b609:	mov    (%rax,%rdx,4),%edx
 100b60c:	cmp    $0xffffffff,%edx
 100b60f:	je     100b941 <check_program+0x1a21>
 100b615:	cmpl   $0x0,0xbc(%rcx)
 100b61c:	mov    0x2a8(%rsp),%eax
 100b623:	jne    100b948 <check_program+0x1a28>
 100b629:	mov    0x298(%rsp),%r8d
 100b631:	mov    0x50(%rcx),%rbp
 100b635:	mov    %edx,%edx
 100b637:	lea    (%rdx,%rdx,2),%rdi
 100b63b:	mov    %rdx,0x28(%rsp)
 100b640:	lea    (%rdx,%rdx,4),%rdx
 100b644:	mov    0x318(%rbx),%rsi
 100b64b:	mov    %rdx,0xa0(%rsp)
 100b653:	mov    %rdi,0x18(%rsp)
 100b658:	sub    %eax,%r8d
 100b65b:	mov    %r8d,0x0(%rbp,%rdx,4)
 100b660:	mov    0x1a8(%rsp),%rax
 100b668:	mov    0x94(%rax),%eax
 100b66e:	mov    %eax,0x8(%rbp,%rdx,4)
 100b672:	mov    0x2c0(%rbx),%rax
 100b679:	mov    0x4(%rsi,%rdi,8),%ecx
 100b67d:	mov    (%rax,%rcx,4),%r9d
 100b681:	mov    $0xffffffff,%ecx
 100b686:	mov    %r9d,0xc(%rbp,%rdx,4)
 100b68b:	mov    0x10(%rsi,%rdi,8),%eax
 100b68f:	mov    %eax,0x10(%rbp,%rdx,4)
 100b693:	mov    %eax,0x30(%rsp)
 100b697:	mov    $0xffffffff,%eax
 100b69c:	mov    0x1b0(%rsp),%r11
 100b6a4:	mov    (%rsi,%rdi,8),%edx
 100b6a7:	mov    0x364(%rbx),%r10d
 100b6ae:	mov    0x60(%r11),%r12
 100b6b2:	mov    (%r12,%rdx,4),%r8d
 100b6b6:	cmp    %r14d,%r8d
 100b6b9:	je     100b736 <check_program+0x1816>
 100b6bb:	cmp    %r10d,%r8d
 100b6be:	jae    100b736 <check_program+0x1816>
 100b6c0:	mov    0x258(%rsp),%r15
 100b6c8:	mov    0x260(%rsp),%rbx
 100b6d0:	mov    $0x1,%r13d
 100b6d6:	cs nopw 0x0(%rax,%rax,1)
 100b6e0:	mov    %r8d,%edi
 100b6e3:	cmp    %r8d,%edx
 100b6e6:	ja     100b6f3 <check_program+0x17d3>
 100b6e8:	mov    0x50(%r11),%r8
 100b6ec:	cmpb   $0x20,(%r8,%rdi,1)
 100b6f1:	jne    100b6fd <check_program+0x17dd>
 100b6f3:	cmp    $0xffffffff,%ecx
 100b6f6:	je     100b710 <check_program+0x17f0>
 100b6f8:	cmp    $0xffffffff,%eax
 100b6fb:	je     100b719 <check_program+0x17f9>
 100b6fd:	mov    (%r12,%rdi,4),%r8d
 100b701:	cmp    %r14d,%r8d
 100b704:	jne    100b725 <check_program+0x1805>
 100b706:	jmp    100b736 <check_program+0x1816>
 100b708:	nopl   0x0(%rax,%rax,1)
 100b710:	mov    (%r15,%rdi,4),%ecx
 100b714:	cmp    $0xffffffff,%eax
 100b717:	jne    100b6fd <check_program+0x17dd>
 100b719:	mov    (%rbx,%rdi,4),%eax
 100b71c:	mov    (%r12,%rdi,4),%r8d
 100b720:	cmp    %r14d,%r8d
 100b723:	je     100b736 <check_program+0x1816>
 100b725:	cmp    %r10d,%r8d
 100b728:	jae    100b736 <check_program+0x1816>
 100b72a:	lea    0x1(%r13),%edi
 100b72e:	cmp    %r13d,%r10d
 100b731:	mov    %edi,%r13d
 100b734:	jne    100b6e0 <check_program+0x17c0>
 100b736:	mov    0x18(%rsp),%rdi
 100b73b:	mov    0x58(%rsp),%rbx
 100b740:	lea    (%rsi,%rdi,8),%r12
 100b744:	mov    0x8(%r12),%esi
 100b749:	cmp    %r10d,%esi
 100b74c:	jae    100b5d0 <check_program+0x16b0>
 100b752:	mov    0x8c(%rbx),%edi
 100b758:	cmp    %edi,%r9d
 100b75b:	jae    100b5d0 <check_program+0x16b0>
 100b761:	cmp    %edi,0x30(%rsp)
 100b765:	jae    100b5d0 <check_program+0x16b0>
 100b76b:	mov    0x1c0(%rsp),%rdx
 100b773:	mov    0x90(%rsp),%r13
 100b77b:	mov    0x60(%rsp),%r15
 100b780:	mov    (%rdx,%rsi,4),%esi
 100b783:	cmp    $0xffffffff,%esi
 100b786:	jne    100b854 <check_program+0x1934>
 100b78c:	lea    0x1a8(%rsp),%rdi
 100b794:	call   1107dc0 <check_control_drain>
 100b799:	mov    0x4(%r12),%eax
 100b79e:	mov    0x29c(%rsp),%ecx
 100b7a5:	cmp    0x2a4(%rsp),%ecx
 100b7ac:	jae    100b8cb <check_program+0x19ab>
 100b7b2:	vmovdqa -0xa8efba(%rip),%ymm1        # 57c800 <static_test_starved.starved+0xc60>
 100b7ba:	vmovdqa -0xa8efa2(%rip),%ymm2        # 57c820 <static_test_starved.starved+0xc80>
 100b7c2:	mov    0x288(%rsp),%rdx
 100b7ca:	lea    0x1(%rcx),%esi
 100b7cd:	shl    $0x5,%rcx
 100b7d1:	mov    0x8(%rsp),%r12
 100b7d6:	mov    %esi,0x29c(%rsp)
 100b7dd:	vpinsrd $0x2,%eax,%xmm1,%xmm0
 100b7e3:	vpblendd $0xf,%ymm0,%ymm1,%ymm0
 100b7e9:	vpermd %ymm0,%ymm2,%ymm0
 100b7ee:	vmovdqu %ymm0,(%rdx,%rcx,1)
 100b7f3:	mov    0xa0(%rsp),%rdx
 100b7fb:	jmp    100b900 <check_program+0x19e0>
 100b800:	mov    0x288(%rsp),%r8
 100b808:	lea    0x1(%rdi),%r9d
 100b80c:	shl    $0x5,%rdi
 100b810:	vxorpd %xmm0,%xmm0,%xmm0
 100b814:	mov    %r9d,0x29c(%rsp)
 100b81c:	vmovupd %xmm0,(%r8,%rdi,1)
 100b822:	movl   $0x0,0x10(%r8,%rdi,1)
 100b82b:	mov    %esi,0x14(%r8,%rdi,1)
 100b830:	mov    %ecx,0x18(%r8,%rdi,1)
 100b835:	mov    %eax,0x1c(%r8,%rdi,1)
 100b83a:	nopw   0x0(%rax,%rax,1)
 100b840:	mov    0x1d0(%rsp),%rsi
 100b848:	mov    (%rsi,%rdx,4),%esi
 100b84b:	cmp    $0xffffffff,%esi
 100b84e:	je     100b78c <check_program+0x186c>
 100b854:	mov    %esi,%edx
 100b856:	cmp    0x14(%r12),%esi
 100b85b:	je     100b840 <check_program+0x1920>
 100b85d:	mov    0x1b0(%rsp),%rdi
 100b865:	mov    0x50(%rdi),%rdi
 100b869:	cmpb   $0x33,(%rdi,%rdx,1)
 100b86d:	je     100b840 <check_program+0x1920>
 100b86f:	mov    0x29c(%rsp),%edi
 100b876:	cmp    0x2a4(%rsp),%edi
 100b87d:	jb     100b800 <check_program+0x18e0>
 100b87f:	mov    0x1a8(%rsp),%rdi
 100b887:	cmpl   $0x0,0xbc(%rdi)
 100b88e:	jne    100b840 <check_program+0x1920>
 100b890:	movl   $0x3,0xbc(%rdi)
 100b89a:	mov    %esi,0xb4(%rdi)
 100b8a0:	mov    %esi,0xb8(%rdi)
 100b8a6:	jmp    100b840 <check_program+0x1920>
 100b8a8:	nopl   0x0(%rax,%rax,1)
 100b8b0:	movl   $0x1,0xbc(%rcx)
 100b8ba:	mov    %edx,0xb4(%rcx)
 100b8c0:	mov    %edx,0xb8(%rcx)
 100b8c6:	jmp    100b5f2 <check_program+0x16d2>
 100b8cb:	mov    0x1a8(%rsp),%rcx
 100b8d3:	mov    0x8(%rsp),%r12
 100b8d8:	mov    0xa0(%rsp),%rdx
 100b8e0:	cmpl   $0x0,0xbc(%rcx)
 100b8e7:	jne    100b900 <check_program+0x19e0>
 100b8e9:	movl   $0x3,0xbc(%rcx)
 100b8f3:	mov    %eax,0xb4(%rcx)
 100b8f9:	mov    %eax,0xb8(%rcx)
 100b8ff:	nop
 100b900:	lea    0x1a8(%rsp),%rdi
 100b908:	lea    0x0(%rbp,%rdx,4),%rbx
 100b90d:	vzeroupper
 100b910:	call   1107dc0 <check_control_drain>
 100b915:	mov    0x2a8(%rsp),%ecx
 100b91c:	mov    0x298(%rsp),%eax
 100b923:	mov    0x20(%rsp),%rbp
 100b928:	add    (%rbx),%ecx
 100b92a:	sub    %ecx,%eax
 100b92c:	mov    %eax,0x4(%rbx)
 100b92f:	mov    0x58(%rsp),%rbx
 100b934:	mov    0x1a8(%rsp),%rcx
 100b93c:	jmp    100b5fc <check_program+0x16dc>
 100b941:	mov    0x2a8(%rsp),%eax
 100b948:	mov    0x298(%rsp),%ecx
 100b94f:	cmp    %ecx,%eax
 100b951:	jae    100bb00 <check_program+0x1be0>
 100b957:	mov    0x1a8(%rsp),%rdx
 100b95f:	cmpl   $0x0,0xbc(%rdx)
 100b966:	jne    100bb00 <check_program+0x1be0>
 100b96c:	lea    0xbc(%rdx),%rsi
 100b973:	mov    %eax,%eax
 100b975:	data16 cs nopw 0x0(%rax,%rax,1)
 100b980:	mov    0x280(%rsp),%rdi
 100b988:	mov    %rax,%r8
 100b98b:	shl    $0x4,%r8
 100b98f:	lea    (%rdi,%r8,1),%rcx
 100b993:	mov    0xc(%rdi,%r8,1),%edi
 100b998:	cmp    $0xd,%edi
 100b99b:	jb     100b9d0 <check_program+0x1ab0>
 100b99d:	mov    0x8(%rcx),%edi
 100b9a0:	cmp    0x2a0(%rsp),%edi
 100b9a7:	jae    100bac0 <check_program+0x1ba0>
 100b9ad:	mov    0x290(%rsp),%r8
 100b9b5:	mov    (%r8,%rdi,4),%edi
 100b9b9:	cmp    $0xffffffff,%edi
 100b9bc:	je     100bac0 <check_program+0x1ba0>
 100b9c2:	mov    %edi,0x8(%rcx)
 100b9c5:	jmp    100bad5 <check_program+0x1bb5>
 100b9ca:	nopw   0x0(%rax,%rax,1)
 100b9d0:	cmp    $0x3,%edi
 100b9d3:	jne    100bad5 <check_program+0x1bb5>
 100b9d9:	mov    0x8(%rcx),%esi
 100b9dc:	mov    0x340(%rbx),%rdx
 100b9e3:	lea    (%rsi,%rsi,4),%rsi
 100b9e7:	shl    $0x4,%rsi
 100b9eb:	cmpl   $0x0,0x34(%rdx,%rsi,1)
 100b9f0:	je     100bad5 <check_program+0x1bb5>
 100b9f6:	add    %rsi,%rdx
 100b9f9:	mov    $0x8,%esi
 100b9fe:	xor    %edi,%edi
 100ba00:	jmp    100ba36 <check_program+0x1b16>
 100ba02:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100ba10:	mov    0x1a8(%rsp),%r9
 100ba18:	cmpl   $0x0,0xbc(%r9)
 100ba20:	je     100ba90 <check_program+0x1b70>
 100ba22:	mov    0x34(%rdx),%r8d
 100ba26:	inc    %rdi
 100ba29:	add    $0xc,%rsi
 100ba2d:	cmp    %r8,%rdi
 100ba30:	jae    100bad5 <check_program+0x1bb5>
 100ba36:	mov    0x20(%rdx),%r8
 100ba3a:	mov    (%r8,%rsi,1),%r9d
 100ba3e:	cmp    0x364(%rbx),%r9d
 100ba45:	jae    100ba10 <check_program+0x1af0>
 100ba47:	mov    0x250(%rsp),%r10
 100ba4f:	mov    (%r10,%r9,4),%r9d
 100ba53:	cmp    0x2a0(%rsp),%r9d
 100ba5b:	jae    100ba10 <check_program+0x1af0>
 100ba5d:	mov    0x290(%rsp),%r10
 100ba65:	mov    (%r10,%r9,4),%r9d
 100ba69:	cmp    $0xffffffff,%r9d
 100ba6d:	je     100ba10 <check_program+0x1af0>
 100ba6f:	mov    0x1a8(%rsp),%r8
 100ba77:	mov    0x8(%rcx),%r11d
 100ba7b:	mov    0x68(%r8),%r10
 100ba7f:	mov    0x70(%r8),%r8
 100ba83:	mov    (%r10,%r11,4),%r10d
 100ba87:	add    %edi,%r10d
 100ba8a:	mov    %r9d,(%r8,%r10,4)
 100ba8e:	jmp    100ba22 <check_program+0x1b02>
 100ba90:	mov    -0x4(%r8,%rsi,1),%r8d
 100ba95:	movl   $0x1,0xbc(%r9)
 100baa0:	mov    %r8d,0xb4(%r9)
 100baa7:	mov    %r8d,0xb8(%r9)
 100baae:	jmp    100ba22 <check_program+0x1b02>
 100bab3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100bac0:	mov    0x4(%rcx),%ecx
 100bac3:	movl   $0x1,(%rsi)
 100bac9:	mov    %ecx,0xb4(%rdx)
 100bacf:	mov    %ecx,0xb8(%rdx)
 100bad5:	mov    0x298(%rsp),%ecx
 100badc:	inc    %rax
 100badf:	cmp    %rcx,%rax
 100bae2:	jae    100bb00 <check_program+0x1be0>
 100bae4:	mov    0x1a8(%rsp),%rdx
 100baec:	cmpl   $0x0,0xbc(%rdx)
 100baf3:	lea    0xbc(%rdx),%rsi
 100bafa:	je     100b980 <check_program+0x1a60>
 100bb00:	mov    0xa8(%rsp),%rsi
 100bb08:	cmp    %r14,%rsi
 100bb0b:	jae    100bba9 <check_program+0x1c89>
 100bb11:	mov    0x1a8(%rsp),%rax
 100bb19:	jmp    100bb41 <check_program+0x1c21>
 100bb1b:	nopl   0x0(%rax,%rax,1)
 100bb20:	movl   $0x1,0xbc(%rax)
 100bb2a:	mov    %r8,%rsi
 100bb2d:	mov    %esi,0xb4(%rax)
 100bb33:	mov    %esi,0xb8(%rax)
 100bb39:	inc    %rsi
 100bb3c:	cmp    %esi,%r14d
 100bb3f:	je     100bba2 <check_program+0x1c82>
 100bb41:	cmpl   $0x0,0xbc(%rax)
 100bb48:	jne    100bba2 <check_program+0x1c82>
 100bb4a:	mov    0x1b0(%rsp),%rcx
 100bb52:	mov    0x50(%rcx),%rcx
 100bb56:	cmpb   $0x53,(%rcx,%rsi,1)
 100bb5a:	jne    100bb39 <check_program+0x1c19>
 100bb5c:	mov    0x248(%rsp),%rdx
 100bb64:	mov    0x48(%rax),%rcx
 100bb68:	mov    %rsi,%r8
 100bb6b:	mov    (%rdx,%rsi,4),%edx
 100bb6e:	shl    $0x6,%rdx
 100bb72:	mov    0x2c(%rcx,%rdx,1),%esi
 100bb76:	cmp    0x2a0(%rsp),%esi
 100bb7d:	jae    100bb20 <check_program+0x1c00>
 100bb7f:	mov    0x290(%rsp),%rdi
 100bb87:	mov    (%rdi,%rsi,4),%esi
 100bb8a:	cmp    $0xffffffff,%esi
 100bb8d:	je     100bb20 <check_program+0x1c00>
 100bb8f:	add    %rdx,%rcx
 100bb92:	mov    %esi,0x2c(%rcx)
 100bb95:	mov    %r8,%rsi
 100bb98:	mov    0x1a8(%rsp),%rax
 100bba0:	jmp    100bb39 <check_program+0x1c19>
 100bba2:	mov    0x298(%rsp),%ecx
 100bba9:	mov    0x94(%r12),%edx
 100bbb1:	mov    0x40(%r12),%rax
 100bbb6:	mov    0x50(%rsp),%r10
 100bbbb:	mov    0x88(%rsp),%r8
 100bbc3:	mov    0xb8(%rsp),%r14
 100bbcb:	lea    0x1(%rdx),%esi
 100bbce:	sub    %r8d,%ecx
 100bbd1:	mov    %esi,0x94(%r12)
 100bbd9:	lea    (%rdx,%rdx,8),%rsi
 100bbdd:	mov    0x260(%rbp),%rdx
 100bbe4:	lea    (%rax,%rsi,4),%r9
 100bbe8:	mov    (%rdx,%r10,4),%edi
 100bbec:	mov    0x2b4(%rsp),%edx
 100bbf3:	mov    %r10d,(%rax,%rsi,4)
 100bbf7:	mov    %r15d,0x4(%rax,%rsi,4)
 100bbfc:	mov    %edi,0x8(%rax,%rsi,4)
 100bc00:	mov    0x78(%rsp),%edi
 100bc04:	mov    %r8d,0xc(%rax,%rsi,4)
 100bc09:	mov    %ecx,0x10(%rax,%rsi,4)
 100bc0d:	mov    %edx,0x14(%rax,%rsi,4)
 100bc11:	lea    0x300(%rsp),%rcx
 100bc19:	mov    %edi,0x18(%rax,%rsi,4)
 100bc1d:	movq   $0x0,0x1c(%rax,%rsi,4)
 100bc26:	mov    0x10(%rcx),%rax
 100bc2a:	mov    0x38(%rsp),%rcx
 100bc2f:	test   %rax,%rax
 100bc32:	je     100bc60 <check_program+0x1d40>
 100bc34:	mov    0x18(%rcx),%rcx
 100bc38:	mov    0x10(%rax),%rsi
 100bc3c:	mov    (%rcx,%r10,4),%ecx
 100bc40:	cmpl   $0x4,0x4(%rsi,%rcx,8)
 100bc45:	jne    100bc5a <check_program+0x1d3a>
 100bc47:	mov    0x40(%rax),%rax
 100bc4b:	mov    (%rsi,%rcx,8),%ecx
 100bc4e:	cmpl   $0x6e69616d,(%rax,%rcx,1)
 100bc55:	sete   %al
 100bc58:	jmp    100bc5c <check_program+0x1d3c>
 100bc5a:	xor    %eax,%eax
 100bc5c:	mov    %al,0x20(%r9)
 100bc60:	mov    0x88(%rsp),%rsi
 100bc68:	mov    (%r12),%r15
 100bc6c:	mov    0x94(%r12),%ecx
 100bc74:	mov    %r9,0x58(%rsp)
 100bc79:	movl   $0x0,0x2bc(%rsp)
 100bc84:	shl    $0x4,%rsi
 100bc88:	add    0x108(%rsp),%rsi
 100bc90:	sub    $0x8,%rsp
 100bc94:	mov    %r12,%rdi
 100bc97:	mov    %rsi,0x90(%rsp)
 100bc9f:	mov    %ecx,0x30(%rsp)
 100bca3:	mov    %r13,%r8
 100bca6:	mov    %r14,%r9
 100bca9:	push   $0x0
 100bcab:	push   0x58(%rsp)
 100bcaf:	push   0x98(%rsp)
 100bcb6:	push   0xd0(%rsp)
 100bcbd:	lea    0x2e4(%rsp),%rax
 100bcc5:	push   %rax
 100bcc6:	call   110a930 <check_program_reference_roots>
 100bccb:	add    $0x30,%rsp
 100bccf:	mov    0x2bc(%rsp),%ebx
 100bcd6:	mov    %rax,0x30(%rsp)
 100bcdb:	test   %ebx,%ebx
 100bcdd:	je     100cf70 <check_program+0x3050>
 100bce3:	mov    0x28(%rsp),%r11d
 100bce8:	jmp    100bd07 <check_program+0x1de7>
 100bcea:	nopw   0x0(%rax,%rax,1)
 100bcf0:	mov    %ebx,0x2bc(%rsp)
 100bcf7:	mov    0xb8(%rsp),%r14
 100bcff:	test   %ebx,%ebx
 100bd01:	je     100cf70 <check_program+0x3050>
 100bd07:	dec    %ebx
 100bd09:	mov    %ebx,0x2bc(%rsp)
 100bd10:	mov    (%r14,%rbx,4),%ebp
 100bd14:	mov    (%r15),%rax
 100bd17:	mov    (%rax,%rbp,4),%r14d
 100bd1b:	test   %r14d,%r14d
 100bd1e:	je     100bd90 <check_program+0x1e70>
 100bd20:	lea    -0x20(%r14),%eax
 100bd24:	cmp    $0xfffffffd,%eax
 100bd27:	ja     100bcf7 <check_program+0x1dd7>
 100bd29:	cmp    $0x37,%r14d
 100bd2d:	jne    100bebc <check_program+0x1f9c>
 100bd33:	mov    (%r12),%rax
 100bd37:	mov    0x8(%r15),%rdx
 100bd3b:	mov    0x320(%rax),%rcx
 100bd42:	mov    (%rdx,%rbp,4),%eax
 100bd45:	mov    (%rcx,%rax,4),%ecx
 100bd48:	test   %rcx,%rcx
 100bd4b:	je     100bd5b <check_program+0x1e3b>
 100bd4d:	cmp    0x9c(%r12),%ecx
 100bd55:	jbe    100c0d3 <check_program+0x21b3>
 100bd5b:	cmpl   $0x0,0xbc(%r12)
 100bd64:	jne    100c137 <check_program+0x2217>
 100bd6a:	movl   $0x1,0xbc(%r12)
 100bd76:	mov    %eax,0xb4(%r12)
 100bd7e:	mov    %eax,0xb8(%r12)
 100bd86:	jmp    100c137 <check_program+0x2217>
 100bd8b:	nopl   0x0(%rax,%rax,1)
 100bd90:	mov    0x28(%r15),%rax
 100bd94:	lea    0x0(%rbp,%rbp,2),%rdx
 100bd99:	shl    $0x5,%rdx
 100bd9d:	mov    0x40(%rax,%rdx,1),%ecx
 100bda1:	test   %rcx,%rcx
 100bda4:	setne  %sil
 100bda8:	cmpl   $0x0,0x44(%rax,%rdx,1)
 100bdad:	sete   %dil
 100bdb1:	and    %sil,%dil
 100bdb4:	cmp    $0x1,%dil
 100bdb8:	jne    100be26 <check_program+0x1f06>
 100bdba:	mov    0xb8(%rsp),%r14
 100bdc2:	cmp    0xac(%r12),%ecx
 100bdca:	jae    100be37 <check_program+0x1f17>
 100bdcc:	mov    0x8(%rax,%rdx,1),%eax
 100bdd0:	test   %al,%al
 100bdd2:	js     100bde8 <check_program+0x1ec8>
 100bdd4:	mov    (%r12),%rax
 100bdd8:	lea    -0x1(%rcx),%edx
 100bddb:	mov    0x268(%rax),%rax
 100bde2:	cmpb   $0x0,(%rax,%rdx,1)
 100bde6:	je     100be37 <check_program+0x1f17>
 100bde8:	mov    0xb0(%rsp),%rax
 100bdf0:	cmp    %r11d,(%rax,%rcx,4)
 100bdf4:	je     100be37 <check_program+0x1f17>
 100bdf6:	mov    %r11d,(%rax,%rcx,4)
 100bdfa:	mov    0x48(%rsp),%rax
 100bdff:	mov    0x30(%rsp),%rsi
 100be04:	mov    0x80(%rsp),%rdi
 100be0c:	movb   $0x1,(%rax,%rcx,1)
 100be10:	mov    %rcx,%rax
 100be13:	mov    %esi,%edx
 100be15:	shl    $0x20,%rax
 100be19:	inc    %esi
 100be1b:	mov    %rsi,0x30(%rsp)
 100be20:	mov    %rax,(%rdi,%rdx,8)
 100be24:	jmp    100be37 <check_program+0x1f17>
 100be26:	mov    0xb8(%rsp),%r14
 100be2e:	test   %rcx,%rcx
 100be31:	je     100bcff <check_program+0x1ddf>
 100be37:	cmp    0xac(%r12),%ecx
 100be3f:	jae    100bcff <check_program+0x1ddf>
 100be45:	mov    (%r12),%rax
 100be49:	dec    %ecx
 100be4b:	mov    0x280(%rax),%rdx
 100be52:	cmpb   $0x0,(%rdx,%rcx,1)
 100be56:	je     100bcff <check_program+0x1ddf>
 100be5c:	mov    0x268(%rax),%rdx
 100be63:	cmpb   $0x0,(%rdx,%rcx,1)
 100be67:	jne    100bcff <check_program+0x1ddf>
 100be6d:	mov    0x28(%r12),%rdx
 100be72:	test   %rdx,%rdx
 100be75:	je     100be8c <check_program+0x1f6c>
 100be77:	mov    0x10(%rdx),%rsi
 100be7b:	mov    (%rsi,%rcx,4),%esi
 100be7e:	test   %rsi,%rsi
 100be81:	je     100be8c <check_program+0x1f6c>
 100be83:	cmp    0x18(%rdx),%esi
 100be86:	jbe    100cc20 <check_program+0x2d00>
 100be8c:	cmpl   $0x0,0xbc(%r12)
 100be95:	jne    100bcff <check_program+0x1ddf>
 100be9b:	movl   $0x1,0xbc(%r12)
 100bea7:	mov    %ecx,0xb4(%r12)
 100beaf:	mov    %ecx,0xb8(%r12)
 100beb7:	jmp    100bcff <check_program+0x1ddf>
 100bebc:	mov    0x18(%r15),%rcx
 100bec0:	mov    0x10(%r15),%rax
 100bec4:	mov    (%rcx,%rbp,4),%r9d
 100bec8:	mov    0x20(%r15),%rcx
 100becc:	mov    (%rax,%rbp,4),%edx
 100becf:	mov    (%rcx,%rbp,4),%r10d
 100bed3:	cmp    $0x38,%r14d
 100bed7:	je     100bffd <check_program+0x20dd>
 100bedd:	cmp    $0x22,%r14d
 100bee1:	jne    100c059 <check_program+0x2139>
 100bee7:	mov    %r12,%rax
 100beea:	mov    0x8(%rax),%rcx
 100beee:	mov    %rax,%r13
 100bef1:	mov    %edx,%r12d
 100bef4:	mov    %r9d,%ebx
 100bef7:	xor    %edx,%edx
 100bef9:	mov    0x90(%rcx),%rax
 100bf00:	mov    0xcc(%rcx),%ecx
 100bf06:	test   %ecx,%ecx
 100bf08:	je     100bf36 <check_program+0x2016>
 100bf0a:	mov    %ecx,%esi
 100bf0c:	jmp    100bf17 <check_program+0x1ff7>
 100bf0e:	xchg   %ax,%ax
 100bf10:	mov    %r8d,%esi
 100bf13:	cmp    %esi,%edx
 100bf15:	jae    100bf36 <check_program+0x2016>
 100bf17:	mov    %esi,%edi
 100bf19:	sub    %edx,%edi
 100bf1b:	shr    $1,%edi
 100bf1d:	lea    (%rdi,%rdx,1),%r8d
 100bf21:	mov    %r8,%r9
 100bf24:	shl    $0x5,%r9
 100bf28:	cmp    %ebp,(%rax,%r9,1)
 100bf2c:	jae    100bf10 <check_program+0x1ff0>
 100bf2e:	lea    0x1(%rdi,%rdx,1),%edx
 100bf32:	cmp    %esi,%edx
 100bf34:	jb     100bf17 <check_program+0x1ff7>
 100bf36:	cmp    %ecx,%edx
 100bf38:	jae    100cb60 <check_program+0x2c40>
 100bf3e:	mov    %edx,%edx
 100bf40:	shl    $0x5,%rdx
 100bf44:	mov    %ebx,%r9d
 100bf47:	cmp    %ebp,(%rax,%rdx,1)
 100bf4a:	jne    100cb63 <check_program+0x2c43>
 100bf50:	mov    0x14(%rax,%rdx,1),%ecx
 100bf54:	mov    %r13,%r12
 100bf57:	test   %rcx,%rcx
 100bf5a:	sete   %sil
 100bf5e:	cmpl   $0x0,0x4(%rax,%rdx,1)
 100bf63:	setne  %dil
 100bf67:	or     %sil,%dil
 100bf6a:	jne    100cbe4 <check_program+0x2cc4>
 100bf70:	cmp    0xac(%r12),%ecx
 100bf78:	jae    100cbe4 <check_program+0x2cc4>
 100bf7e:	add    %rdx,%rax
 100bf81:	mov    0x10(%r12),%rdx
 100bf86:	mov    0x18(%rax),%esi
 100bf89:	mov    (%rdx),%rax
 100bf8c:	shr    $0x3,%esi
 100bf8f:	movzbl (%rax,%rsi,1),%edi
 100bf93:	cmp    $0xf,%dil
 100bf97:	jne    100bfa7 <check_program+0x2087>
 100bf99:	mov    0x20(%rdx),%rdx
 100bf9d:	mov    (%rdx,%rsi,4),%edx
 100bfa0:	shr    $0x3,%edx
 100bfa3:	movzbl (%rax,%rdx,1),%edi
 100bfa7:	cmp    $0xb,%dil
 100bfab:	jne    100cbe4 <check_program+0x2cc4>
 100bfb1:	mov    0xb0(%rsp),%rax
 100bfb9:	mov    $0xffffffff,%edx
 100bfbe:	cmp    %r11d,(%rax,%rcx,4)
 100bfc2:	je     100c14e <check_program+0x222e>
 100bfc8:	mov    0x48(%rsp),%rdx
 100bfcd:	mov    %r11d,(%rax,%rcx,4)
 100bfd1:	movb   $0x1,(%rdx,%rcx,1)
 100bfd5:	mov    0x30(%rsp),%rdx
 100bfda:	shl    $0x20,%rcx
 100bfde:	mov    %edx,%eax
 100bfe0:	inc    %edx
 100bfe2:	mov    %rdx,0x30(%rsp)
 100bfe7:	mov    0x80(%rsp),%rdx
 100bfef:	mov    %rcx,(%rdx,%rax,8)
 100bff3:	mov    $0xffffffff,%edx
 100bff8:	jmp    100c14e <check_program+0x222e>
 100bffd:	mov    0x98(%r15),%rax
 100c004:	mov    0x8(%r12),%rcx
 100c009:	mov    (%rax,%rbp,4),%eax
 100c00c:	cmp    0xac(%rcx),%eax
 100c012:	jae    100cbe9 <check_program+0x2cc9>
 100c018:	mov    0x50(%rcx),%rcx
 100c01c:	lea    (%rax,%rax,4),%rax
 100c020:	cmp    %ebp,(%rcx,%rax,4)
 100c023:	jne    100cbe9 <check_program+0x2cc9>
 100c029:	lea    (%rcx,%rax,4),%rax
 100c02d:	mov    0x8(%rax),%eax
 100c030:	mov    %eax,%ecx
 100c032:	and    $0x1,%ecx
 100c035:	mov    %eax,%esi
 100c037:	cmp    $0x1,%ecx
 100c03a:	sbb    %ecx,%ecx
 100c03c:	and    $0x2,%esi
 100c03f:	or     %ecx,%edx
 100c041:	cmp    $0x1,%esi
 100c044:	sbb    %esi,%esi
 100c046:	and    $0x4,%eax
 100c049:	or     %esi,%r9d
 100c04c:	cmp    $0x1,%eax
 100c04f:	sbb    %eax,%eax
 100c051:	or     %eax,%r10d
 100c054:	jmp    100c14e <check_program+0x222e>
 100c059:	lea    -0x15(%r14),%eax
 100c05d:	movb   $0x0,0x2bb(%rsp)
 100c065:	cmp    $0x2,%eax
 100c068:	ja     100c15d <check_program+0x223d>
 100c06e:	cmpb   $0x0,0xc8(%r12)
 100c077:	jne    100c15d <check_program+0x223d>
 100c07d:	lea    0x2bb(%rsp),%rcx
 100c085:	mov    %r12,%rdi
 100c088:	mov    %ebp,%esi
 100c08a:	mov    %r9d,%r13d
 100c08d:	mov    %r10d,0x18(%rsp)
 100c092:	mov    %edx,%r12d
 100c095:	call   110a470 <check_program_runtime_truth>
 100c09a:	test   %al,%al
 100c09c:	je     100cd4a <check_program+0x2e2a>
 100c0a2:	mov    0x28(%rsp),%r11d
 100c0a7:	mov    0x18(%rsp),%r10d
 100c0ac:	mov    %r13d,%r9d
 100c0af:	cmp    $0x17,%r14d
 100c0b3:	jne    100cf24 <check_program+0x3004>
 100c0b9:	cmpb   $0x0,0x2bb(%rsp)
 100c0c1:	mov    $0xffffffff,%eax
 100c0c6:	cmove  %eax,%r9d
 100c0ca:	cmovne %eax,%r10d
 100c0ce:	jmp    100cf4f <check_program+0x302f>
 100c0d3:	mov    0x50(%r12),%rax
 100c0d8:	lea    (%rcx,%rcx,4),%rcx
 100c0dc:	mov    -0x14(%rax,%rcx,4),%esi
 100c0e0:	mov    -0x10(%rax,%rcx,4),%edx
 100c0e4:	shl    $0x4,%rsi
 100c0e8:	add    0x88(%rsp),%rsi
 100c0f0:	sub    $0x8,%rsp
 100c0f4:	mov    0xc0(%rsp),%r9
 100c0fc:	mov    %r12,%rdi
 100c0ff:	mov    %r11d,%ecx
 100c102:	mov    %r13,%r8
 100c105:	push   0x38(%rsp)
 100c109:	push   0x58(%rsp)
 100c10d:	push   0x98(%rsp)
 100c114:	push   0xd0(%rsp)
 100c11b:	lea    0x2e4(%rsp),%rax
 100c123:	push   %rax
 100c124:	call   110a930 <check_program_reference_roots>
 100c129:	mov    0x58(%rsp),%r11d
 100c12e:	add    $0x30,%rsp
 100c132:	mov    %rax,0x30(%rsp)
 100c137:	mov    0x18(%r15),%rcx
 100c13b:	mov    0x10(%r15),%rax
 100c13f:	mov    (%rcx,%rbp,4),%r9d
 100c143:	mov    0x20(%r15),%rcx
 100c147:	mov    (%rax,%rbp,4),%edx
 100c14a:	mov    (%rcx,%rbp,4),%r10d
 100c14e:	mov    0x2bc(%rsp),%ebx
 100c155:	movb   $0x0,0x2bb(%rsp)
 100c15d:	mov    %r10d,0x18(%rsp)
 100c162:	cmp    $0xffffffff,%edx
 100c165:	je     100c219 <check_program+0x22f9>
 100c16b:	mov    %r12,%rax
 100c16e:	mov    0x8(%rax),%rax
 100c172:	mov    %edx,%r12d
 100c175:	mov    %r9d,%r13d
 100c178:	mov    0xd0(%rax),%edx
 100c17e:	test   %edx,%edx
 100c180:	je     100c1bd <check_program+0x229d>
 100c182:	mov    0x98(%rax),%rsi
 100c189:	xor    %ecx,%ecx
 100c18b:	mov    %edx,%edi
 100c18d:	jmp    100c197 <check_program+0x2277>
 100c18f:	nop
 100c190:	mov    %r9d,%edi
 100c193:	cmp    %edi,%ecx
 100c195:	jae    100c1b7 <check_program+0x2297>
 100c197:	mov    %edi,%r8d
 100c19a:	sub    %ecx,%r8d
 100c19d:	shr    $1,%r8d
 100c1a0:	lea    (%r8,%rcx,1),%r9d
 100c1a4:	lea    (%r9,%r9,8),%r10
 100c1a8:	cmp    %ebp,(%rsi,%r10,4)
 100c1ac:	jae    100c190 <check_program+0x2270>
 100c1ae:	lea    0x1(%r8,%rcx,1),%ecx
 100c1b3:	cmp    %edi,%ecx
 100c1b5:	jb     100c197 <check_program+0x2277>
 100c1b7:	cmp    %edx,%ecx
 100c1b9:	jb     100c1c3 <check_program+0x22a3>
 100c1bb:	jmp    100c1e7 <check_program+0x22c7>
 100c1bd:	xor    %ecx,%ecx
 100c1bf:	cmp    %edx,%ecx
 100c1c1:	jae    100c1e7 <check_program+0x22c7>
 100c1c3:	mov    0x98(%rax),%rax
 100c1ca:	test   %rax,%rax
 100c1cd:	je     100c1e7 <check_program+0x22c7>
 100c1cf:	mov    %ecx,%ecx
 100c1d1:	lea    (%rcx,%rcx,8),%rcx
 100c1d5:	lea    (%rax,%rcx,4),%rax
 100c1d9:	cmp    %ebp,(%rax)
 100c1db:	jne    100c1e7 <check_program+0x22c7>
 100c1dd:	cmpl   $0x0,0x4(%rax)
 100c1e1:	je     100cb96 <check_program+0x2c76>
 100c1e7:	mov    0x90(%rsp),%rcx
 100c1ef:	mov    0x18(%rsp),%r10d
 100c1f4:	mov    %r12d,%eax
 100c1f7:	mov    %r13d,%r9d
 100c1fa:	cmp    %r11d,(%rcx,%rax,4)
 100c1fe:	je     100c214 <check_program+0x22f4>
 100c200:	mov    0xb8(%rsp),%rdx
 100c208:	mov    %r11d,(%rcx,%rax,4)
 100c20c:	mov    %ebx,%eax
 100c20e:	inc    %ebx
 100c210:	mov    %r12d,(%rdx,%rax,4)
 100c214:	mov    0x8(%rsp),%r12
 100c219:	cmp    $0xffffffff,%r9d
 100c21d:	je     100c290 <check_program+0x2370>
 100c21f:	mov    0x8(%r12),%rax
 100c224:	mov    0x90(%rsp),%r12
 100c22c:	mov    %r9d,%r13d
 100c22f:	mov    0xd0(%rax),%ecx
 100c235:	test   %ecx,%ecx
 100c237:	je     100c29d <check_program+0x237d>
 100c239:	mov    0x98(%rax),%rsi
 100c240:	xor    %edx,%edx
 100c242:	mov    %ecx,%edi
 100c244:	jmp    100c25a <check_program+0x233a>
 100c246:	cs nopw 0x0(%rax,%rax,1)
 100c250:	inc    %r8d
 100c253:	mov    %r8d,%edx
 100c256:	cmp    %edi,%edx
 100c258:	jae    100c28a <check_program+0x236a>
 100c25a:	mov    %edi,%r8d
 100c25d:	sub    %edx,%r8d
 100c260:	shr    $1,%r8d
 100c263:	add    %edx,%r8d
 100c266:	lea    (%r8,%r8,8),%r9
 100c26a:	mov    (%rsi,%r9,4),%r10d
 100c26e:	cmp    %ebp,%r10d
 100c271:	jb     100c250 <check_program+0x2330>
 100c273:	cmp    %ebp,%r10d
 100c276:	jne    100c283 <check_program+0x2363>
 100c278:	lea    (%rsi,%r9,4),%r9
 100c27c:	cmpl   $0x0,0x4(%r9)
 100c281:	je     100c250 <check_program+0x2330>
 100c283:	mov    %r8d,%edi
 100c286:	cmp    %edi,%edx
 100c288:	jb     100c25a <check_program+0x233a>
 100c28a:	cmp    %ecx,%edx
 100c28c:	jae    100c30a <check_program+0x23ea>
 100c28e:	jmp    100c2a3 <check_program+0x2383>
 100c290:	mov    0x90(%rsp),%r13
 100c298:	jmp    100c334 <check_program+0x2414>
 100c29d:	xor    %edx,%edx
 100c29f:	cmp    %ecx,%edx
 100c2a1:	jae    100c30a <check_program+0x23ea>
 100c2a3:	mov    0x98(%rax),%rax
 100c2aa:	test   %rax,%rax
 100c2ad:	je     100c30a <check_program+0x23ea>
 100c2af:	mov    %edx,%ecx
 100c2b1:	lea    (%rcx,%rcx,8),%rcx
 100c2b5:	lea    (%rax,%rcx,4),%rax
 100c2b9:	cmp    %ebp,(%rax)
 100c2bb:	jne    100c30a <check_program+0x23ea>
 100c2bd:	cmpl   $0x1,0x4(%rax)
 100c2c1:	jne    100c30a <check_program+0x23ea>
 100c2c3:	mov    %r12,%r13
 100c2c6:	cmpl   $0x0,0x8(%rax)
 100c2ca:	mov    0x18(%rsp),%r10d
 100c2cf:	mov    0x8(%rsp),%r12
 100c2d4:	je     100cd5c <check_program+0x2e3c>
 100c2da:	cmpl   $0x0,0xbc(%r12)
 100c2e3:	jne    100c334 <check_program+0x2414>
 100c2e5:	mov    0x8(%r15),%rax
 100c2e9:	mov    (%rax,%rbp,4),%eax
 100c2ec:	movl   $0x1,0xbc(%r12)
 100c2f8:	mov    %eax,0xb4(%r12)
 100c300:	mov    %eax,0xb8(%r12)
 100c308:	jmp    100c334 <check_program+0x2414>
 100c30a:	mov    0x18(%rsp),%r10d
 100c30f:	mov    %r13d,%eax
 100c312:	cmp    %r11d,(%r12,%rax,4)
 100c316:	je     100c32c <check_program+0x240c>
 100c318:	mov    0xb8(%rsp),%rcx
 100c320:	mov    %r11d,(%r12,%rax,4)
 100c324:	mov    %ebx,%eax
 100c326:	inc    %ebx
 100c328:	mov    %r13d,(%rcx,%rax,4)
 100c32c:	mov    %r12,%r13
 100c32f:	mov    0x8(%rsp),%r12
 100c334:	cmp    $0xffffffff,%r10d
 100c338:	je     100c421 <check_program+0x2501>
 100c33e:	mov    0x8(%r12),%rax
 100c343:	mov    0xd0(%rax),%ecx
 100c349:	test   %ecx,%ecx
 100c34b:	je     100c3a0 <check_program+0x2480>
 100c34d:	mov    0x98(%rax),%rsi
 100c354:	xor    %edx,%edx
 100c356:	mov    %ecx,%edi
 100c358:	jmp    100c36a <check_program+0x244a>
 100c35a:	nopw   0x0(%rax,%rax,1)
 100c360:	inc    %r8d
 100c363:	mov    %r8d,%edx
 100c366:	cmp    %edi,%edx
 100c368:	jae    100c39a <check_program+0x247a>
 100c36a:	mov    %edi,%r8d
 100c36d:	sub    %edx,%r8d
 100c370:	shr    $1,%r8d
 100c373:	add    %edx,%r8d
 100c376:	lea    (%r8,%r8,8),%r9
 100c37a:	mov    (%rsi,%r9,4),%r10d
 100c37e:	cmp    %ebp,%r10d
 100c381:	jb     100c360 <check_program+0x2440>
 100c383:	cmp    %ebp,%r10d
 100c386:	jne    100c393 <check_program+0x2473>
 100c388:	lea    (%rsi,%r9,4),%r9
 100c38c:	cmpl   $0x1,0x4(%r9)
 100c391:	jbe    100c360 <check_program+0x2440>
 100c393:	mov    %r8d,%edi
 100c396:	cmp    %edi,%edx
 100c398:	jb     100c36a <check_program+0x244a>
 100c39a:	cmp    %ecx,%edx
 100c39c:	jae    100c400 <check_program+0x24e0>
 100c39e:	jmp    100c3a6 <check_program+0x2486>
 100c3a0:	xor    %edx,%edx
 100c3a2:	cmp    %ecx,%edx
 100c3a4:	jae    100c400 <check_program+0x24e0>
 100c3a6:	mov    0x98(%rax),%rax
 100c3ad:	test   %rax,%rax
 100c3b0:	je     100c400 <check_program+0x24e0>
 100c3b2:	mov    %edx,%ecx
 100c3b4:	lea    (%rcx,%rcx,8),%rcx
 100c3b8:	lea    (%rax,%rcx,4),%rax
 100c3bc:	cmp    %ebp,(%rax)
 100c3be:	jne    100c400 <check_program+0x24e0>
 100c3c0:	cmpl   $0x2,0x4(%rax)
 100c3c4:	jne    100c400 <check_program+0x24e0>
 100c3c6:	cmpl   $0x0,0x8(%rax)
 100c3ca:	je     100cdf0 <check_program+0x2ed0>
 100c3d0:	cmpl   $0x0,0xbc(%r12)
 100c3d9:	jne    100c421 <check_program+0x2501>
 100c3db:	mov    0x8(%r15),%rax
 100c3df:	mov    (%rax,%rbp,4),%eax
 100c3e2:	movl   $0x1,0xbc(%r12)
 100c3ee:	mov    %eax,0xb4(%r12)
 100c3f6:	mov    %eax,0xb8(%r12)
 100c3fe:	jmp    100c421 <check_program+0x2501>
 100c400:	mov    0x18(%rsp),%edx
 100c404:	mov    %edx,%eax
 100c406:	cmp    %r11d,0x0(%r13,%rax,4)
 100c40b:	je     100c421 <check_program+0x2501>
 100c40d:	mov    0xb8(%rsp),%rcx
 100c415:	mov    %r11d,0x0(%r13,%rax,4)
 100c41a:	mov    %ebx,%eax
 100c41c:	inc    %ebx
 100c41e:	mov    %edx,(%rcx,%rax,4)
 100c421:	mov    %r14d,%eax
 100c424:	and    $0xfffffffc,%eax
 100c427:	mov    %ebx,0x2bc(%rsp)
 100c42e:	cmp    $0x3c,%eax
 100c431:	je     100c454 <check_program+0x2534>
 100c433:	lea    -0x22(%r14),%eax
 100c437:	cmp    $0x22,%eax
 100c43a:	ja     100bcf7 <check_program+0x1dd7>
 100c440:	movabs $0x700000001,%rcx
 100c44a:	bt     %rax,%rcx
 100c44e:	jae    100bcf7 <check_program+0x1dd7>
 100c454:	mov    (%r12),%rcx
 100c458:	mov    $0xffffffff,%esi
 100c45d:	mov    (%rcx),%rax
 100c460:	mov    (%rax,%rbp,4),%edx
 100c463:	lea    -0x3c(%rdx),%edi
 100c466:	cmp    $0x8,%edi
 100c469:	ja     100c511 <check_program+0x25f1>
 100c46f:	lea    -0xb71f76(%rip),%r8        # 49a500 <cbuiltin_test_generated.edges+0x6c0>
 100c476:	mov    0x8(%r12),%rax
 100c47b:	movslq (%r8,%rdi,4),%rdi
 100c47f:	add    %r8,%rdi
 100c482:	jmp    *%rdi
 100c484:	mov    0x58(%rax),%rdi
 100c488:	mov    0xb0(%rax),%r8d
 100c48f:	mov    $0x0,%r9d
 100c495:	movl   $0x0,0x18(%rsp)
 100c49d:	test   %r8d,%r8d
 100c4a0:	je     100c4dd <check_program+0x25bd>
 100c4a2:	xor    %r9d,%r9d
 100c4a5:	mov    %r8d,%r10d
 100c4a8:	jmp    100c4b8 <check_program+0x2598>
 100c4aa:	nopw   0x0(%rax,%rax,1)
 100c4b0:	mov    %eax,%r10d
 100c4b3:	cmp    %r10d,%r9d
 100c4b6:	jae    100c4dd <check_program+0x25bd>
 100c4b8:	mov    %r10d,%r11d
 100c4bb:	sub    %r9d,%r11d
 100c4be:	shr    $1,%r11d
 100c4c1:	lea    (%r11,%r9,1),%eax
 100c4c5:	lea    (%rax,%rax,2),%r12
 100c4c9:	shl    $0x6,%r12
 100c4cd:	cmp    %ebp,(%rdi,%r12,1)
 100c4d1:	jae    100c4b0 <check_program+0x2590>
 100c4d3:	lea    0x1(%r11,%r9,1),%r9d
 100c4d8:	cmp    %r10d,%r9d
 100c4db:	jb     100c4b8 <check_program+0x2598>
 100c4dd:	cmp    %r8d,%r9d
 100c4e0:	jae    100c7f9 <check_program+0x28d9>
 100c4e6:	mov    0x8(%rsp),%r12
 100c4eb:	mov    0x28(%rsp),%r11d
 100c4f0:	mov    %r9d,%eax
 100c4f3:	lea    (%rax,%rax,2),%rax
 100c4f7:	shl    $0x6,%rax
 100c4fb:	cmp    %ebp,(%rdi,%rax,1)
 100c4fe:	jne    100c803 <check_program+0x28e3>
 100c504:	mov    0x74(%rdi,%rax,1),%eax
 100c508:	mov    %eax,0x18(%rsp)
 100c50c:	jmp    100c840 <check_program+0x2920>
 100c511:	movl   $0xffffffff,0x18(%rsp)
 100c519:	cmp    $0x22,%edx
 100c51c:	jne    100c808 <check_program+0x28e8>
 100c522:	jmp    100c840 <check_program+0x2920>
 100c527:	mov    0x80(%rax),%rdi
 100c52e:	mov    0xc4(%rax),%r9d
 100c535:	xor    %r8d,%r8d
 100c538:	test   %r9d,%r9d
 100c53b:	je     100c57c <check_program+0x265c>
 100c53d:	mov    %r9d,%eax
 100c540:	jmp    100c558 <check_program+0x2638>
 100c542:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100c550:	mov    %r11d,%eax
 100c553:	cmp    %eax,%r8d
 100c556:	jae    100c57c <check_program+0x265c>
 100c558:	mov    %eax,%r10d
 100c55b:	sub    %r8d,%r10d
 100c55e:	shr    $1,%r10d
 100c561:	lea    (%r10,%r8,1),%r11d
 100c565:	imul   $0x150,%r11,%r12
 100c56c:	cmp    %ebp,(%rdi,%r12,1)
 100c570:	jae    100c550 <check_program+0x2630>
 100c572:	lea    0x1(%r10,%r8,1),%r8d
 100c577:	cmp    %eax,%r8d
 100c57a:	jb     100c558 <check_program+0x2638>
 100c57c:	mov    0x8(%rsp),%r12
 100c581:	mov    0x28(%rsp),%r11d
 100c586:	movl   $0xffffffff,0x18(%rsp)
 100c58e:	cmp    %r9d,%r8d
 100c591:	jae    100c803 <check_program+0x28e3>
 100c597:	mov    %r8d,%eax
 100c59a:	imul   $0x150,%rax,%rax
 100c5a1:	movl   $0xffffffff,0x18(%rsp)
 100c5a9:	cmp    %ebp,(%rdi,%rax,1)
 100c5ac:	mov    $0xffffffff,%eax
 100c5b1:	cmovne %eax,%r8d
 100c5b5:	mov    %r8d,%esi
 100c5b8:	cmp    $0x22,%edx
 100c5bb:	jne    100c808 <check_program+0x28e8>
 100c5c1:	jmp    100c840 <check_program+0x2920>
 100c5c6:	mov    0x60(%rax),%rdi
 100c5ca:	mov    0xb4(%rax),%r8d
 100c5d1:	mov    $0x0,%r9d
 100c5d7:	movl   $0x0,0x18(%rsp)
 100c5df:	test   %r8d,%r8d
 100c5e2:	je     100c61c <check_program+0x26fc>
 100c5e4:	xor    %r9d,%r9d
 100c5e7:	mov    %r8d,%r10d
 100c5ea:	jmp    100c5f8 <check_program+0x26d8>
 100c5ec:	nopl   0x0(%rax)
 100c5f0:	mov    %eax,%r10d
 100c5f3:	cmp    %r10d,%r9d
 100c5f6:	jae    100c61c <check_program+0x26fc>
 100c5f8:	mov    %r10d,%r11d
 100c5fb:	sub    %r9d,%r11d
 100c5fe:	shr    $1,%r11d
 100c601:	lea    (%r11,%r9,1),%eax
 100c605:	mov    %rax,%r12
 100c608:	shl    $0x8,%r12
 100c60c:	cmp    %ebp,(%rdi,%r12,1)
 100c610:	jae    100c5f0 <check_program+0x26d0>
 100c612:	lea    0x1(%r11,%r9,1),%r9d
 100c617:	cmp    %r10d,%r9d
 100c61a:	jb     100c5f8 <check_program+0x26d8>
 100c61c:	cmp    %r8d,%r9d
 100c61f:	jae    100c7f9 <check_program+0x28d9>
 100c625:	mov    0x8(%rsp),%r12
 100c62a:	mov    0x28(%rsp),%r11d
 100c62f:	mov    %r9d,%r8d
 100c632:	shl    $0x8,%r8
 100c636:	cmp    %ebp,(%rdi,%r8,1)
 100c63a:	jne    100c803 <check_program+0x28e3>
 100c640:	mov    0xdc(%rdi,%r8,1),%eax
 100c648:	mov    %eax,0x18(%rsp)
 100c64c:	jmp    100c840 <check_program+0x2920>
 100c651:	mov    0x88(%rax),%rdi
 100c658:	mov    0xc8(%rax),%r8d
 100c65f:	mov    $0x0,%r9d
 100c665:	movl   $0x0,0x18(%rsp)
 100c66d:	test   %r8d,%r8d
 100c670:	je     100c6ac <check_program+0x278c>
 100c672:	xor    %r9d,%r9d
 100c675:	mov    %r8d,%r10d
 100c678:	jmp    100c688 <check_program+0x2768>
 100c67a:	nopw   0x0(%rax,%rax,1)
 100c680:	mov    %eax,%r10d
 100c683:	cmp    %r10d,%r9d
 100c686:	jae    100c6ac <check_program+0x278c>
 100c688:	mov    %r10d,%r11d
 100c68b:	sub    %r9d,%r11d
 100c68e:	shr    $1,%r11d
 100c691:	lea    (%r11,%r9,1),%eax
 100c695:	mov    %rax,%r12
 100c698:	shl    $0x6,%r12
 100c69c:	cmp    %ebp,(%rdi,%r12,1)
 100c6a0:	jae    100c680 <check_program+0x2760>
 100c6a2:	lea    0x1(%r11,%r9,1),%r9d
 100c6a7:	cmp    %r10d,%r9d
 100c6aa:	jb     100c688 <check_program+0x2768>
 100c6ac:	cmp    %r8d,%r9d
 100c6af:	jae    100c7f9 <check_program+0x28d9>
 100c6b5:	mov    0x8(%rsp),%r12
 100c6ba:	mov    0x28(%rsp),%r11d
 100c6bf:	mov    %r9d,%r8d
 100c6c2:	shl    $0x6,%r8
 100c6c6:	cmp    %ebp,(%rdi,%r8,1)
 100c6ca:	jne    100c803 <check_program+0x28e3>
 100c6d0:	mov    0x18(%rdi,%r8,1),%eax
 100c6d5:	mov    %eax,0x18(%rsp)
 100c6d9:	jmp    100c840 <check_program+0x2920>
 100c6de:	mov    0x68(%rax),%rdi
 100c6e2:	mov    0xb8(%rax),%r8d
 100c6e9:	mov    $0x0,%r9d
 100c6ef:	movl   $0x0,0x18(%rsp)
 100c6f7:	test   %r8d,%r8d
 100c6fa:	je     100c73c <check_program+0x281c>
 100c6fc:	xor    %r9d,%r9d
 100c6ff:	mov    %r8d,%r10d
 100c702:	jmp    100c718 <check_program+0x27f8>
 100c704:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 100c710:	mov    %eax,%r10d
 100c713:	cmp    %r10d,%r9d
 100c716:	jae    100c73c <check_program+0x281c>
 100c718:	mov    %r10d,%r11d
 100c71b:	sub    %r9d,%r11d
 100c71e:	shr    $1,%r11d
 100c721:	lea    (%r11,%r9,1),%eax
 100c725:	imul   $0xb0,%rax,%r12
 100c72c:	cmp    %ebp,(%rdi,%r12,1)
 100c730:	jae    100c710 <check_program+0x27f0>
 100c732:	lea    0x1(%r11,%r9,1),%r9d
 100c737:	cmp    %r10d,%r9d
 100c73a:	jb     100c718 <check_program+0x27f8>
 100c73c:	cmp    %r8d,%r9d
 100c73f:	jae    100c7f9 <check_program+0x28d9>
 100c745:	mov    0x8(%rsp),%r12
 100c74a:	mov    0x28(%rsp),%r11d
 100c74f:	mov    %r9d,%eax
 100c752:	imul   $0xb0,%rax,%rax
 100c759:	cmp    %ebp,(%rdi,%rax,1)
 100c75c:	jne    100c803 <check_program+0x28e3>
 100c762:	mov    0x70(%rdi,%rax,1),%eax
 100c766:	mov    %eax,0x18(%rsp)
 100c76a:	jmp    100c840 <check_program+0x2920>
 100c76f:	mov    0x70(%rax),%rdi
 100c773:	mov    0xbc(%rax),%r8d
 100c77a:	mov    $0x0,%r9d
 100c780:	movl   $0x0,0x18(%rsp)
 100c788:	test   %r8d,%r8d
 100c78b:	je     100c7cd <check_program+0x28ad>
 100c78d:	xor    %r9d,%r9d
 100c790:	mov    %r8d,%r10d
 100c793:	jmp    100c7a8 <check_program+0x2888>
 100c795:	data16 cs nopw 0x0(%rax,%rax,1)
 100c7a0:	mov    %eax,%r10d
 100c7a3:	cmp    %r10d,%r9d
 100c7a6:	jae    100c7cd <check_program+0x28ad>
 100c7a8:	mov    %r10d,%r11d
 100c7ab:	sub    %r9d,%r11d
 100c7ae:	shr    $1,%r11d
 100c7b1:	lea    (%r11,%r9,1),%eax
 100c7b5:	lea    (%rax,%rax,8),%r12
 100c7b9:	shl    $0x5,%r12
 100c7bd:	cmp    %ebp,(%rdi,%r12,1)
 100c7c1:	jae    100c7a0 <check_program+0x2880>
 100c7c3:	lea    0x1(%r11,%r9,1),%r9d
 100c7c8:	cmp    %r10d,%r9d
 100c7cb:	jb     100c7a8 <check_program+0x2888>
 100c7cd:	cmp    %r8d,%r9d
 100c7d0:	jae    100c7f9 <check_program+0x28d9>
 100c7d2:	mov    0x8(%rsp),%r12
 100c7d7:	mov    0x28(%rsp),%r11d
 100c7dc:	mov    %r9d,%eax
 100c7df:	lea    (%rax,%rax,8),%rax
 100c7e3:	shl    $0x5,%rax
 100c7e7:	cmp    %ebp,(%rdi,%rax,1)
 100c7ea:	jne    100c803 <check_program+0x28e3>
 100c7ec:	mov    0xf0(%rdi,%rax,1),%eax
 100c7f3:	mov    %eax,0x18(%rsp)
 100c7f7:	jmp    100c840 <check_program+0x2920>
 100c7f9:	mov    0x8(%rsp),%r12
 100c7fe:	mov    0x28(%rsp),%r11d
 100c803:	cmp    $0x22,%edx
 100c806:	je     100c840 <check_program+0x2920>
 100c808:	cmp    $0xffffffff,%esi
 100c80b:	jne    100c840 <check_program+0x2920>
 100c80d:	cmpl   $0x0,0xbc(%r12)
 100c816:	jne    100c840 <check_program+0x2920>
 100c818:	mov    0x8(%rcx),%rax
 100c81c:	mov    (%rax,%rbp,4),%eax
 100c81f:	movl   $0x1,0xbc(%r12)
 100c82b:	mov    %eax,0xb4(%r12)
 100c833:	mov    %eax,0xb8(%r12)
 100c83b:	nopl   0x0(%rax,%rax,1)
 100c840:	mov    0xa0(%r15),%rax
 100c847:	cmpl   $0x0,(%rax,%rbp,4)
 100c84b:	je     100bcf0 <check_program+0x1dd0>
 100c851:	xor    %ecx,%ecx
 100c853:	jmp    100c872 <check_program+0x2952>
 100c855:	data16 cs nopw 0x0(%rax,%rax,1)
 100c860:	mov    0xa0(%r15),%rax
 100c867:	inc    %ecx
 100c869:	cmp    (%rax,%rbp,4),%ecx
 100c86c:	jae    100bcf0 <check_program+0x1dd0>
 100c872:	mov    0x98(%r15),%rax
 100c879:	mov    0xa8(%r15),%rdx
 100c880:	mov    (%rax,%rbp,4),%eax
 100c883:	add    %ecx,%eax
 100c885:	mov    (%rdx,%rax,4),%edx
 100c888:	cmp    $0x22,%r14d
 100c88c:	je     100c8b0 <check_program+0x2990>
 100c88e:	cmp    $0x43,%r14d
 100c892:	je     100c8b0 <check_program+0x2990>
 100c894:	cmp    $0x1f,%ecx
 100c897:	ja     100c860 <check_program+0x2940>
 100c899:	mov    0x18(%rsp),%eax
 100c89d:	bt     %ecx,%eax
 100c8a0:	jae    100c860 <check_program+0x2940>
 100c8a2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100c8b0:	mov    0x8(%r12),%rdi
 100c8b5:	lea    0x3(%rcx),%esi
 100c8b8:	mov    0xd0(%rdi),%r8d
 100c8bf:	test   %r8d,%r8d
 100c8c2:	je     100c930 <check_program+0x2a10>
 100c8c4:	mov    0x98(%rdi),%r10
 100c8cb:	xor    %r9d,%r9d
 100c8ce:	mov    %r8d,%r11d
 100c8d1:	jmp    100c8eb <check_program+0x29cb>
 100c8d3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100c8e0:	inc    %r13d
 100c8e3:	mov    %r13d,%r9d
 100c8e6:	cmp    %r11d,%r9d
 100c8e9:	jae    100c91b <check_program+0x29fb>
 100c8eb:	mov    %r11d,%r13d
 100c8ee:	sub    %r9d,%r13d
 100c8f1:	shr    $1,%r13d
 100c8f4:	add    %r9d,%r13d
 100c8f7:	lea    0x0(%r13,%r13,8),%rax
 100c8fc:	mov    (%r10,%rax,4),%r12d
 100c900:	cmp    %ebp,%r12d
 100c903:	jb     100c8e0 <check_program+0x29c0>
 100c905:	cmp    %ebp,%r12d
 100c908:	jne    100c913 <check_program+0x29f3>
 100c90a:	lea    (%r10,%rax,4),%rax
 100c90e:	cmp    %esi,0x4(%rax)
 100c911:	jb     100c8e0 <check_program+0x29c0>
 100c913:	mov    %r13d,%r11d
 100c916:	cmp    %r11d,%r9d
 100c919:	jb     100c8eb <check_program+0x29cb>
 100c91b:	cmp    %r8d,%r9d
 100c91e:	jae    100c9b0 <check_program+0x2a90>
 100c924:	jmp    100c938 <check_program+0x2a18>
 100c926:	cs nopw 0x0(%rax,%rax,1)
 100c930:	xor    %r9d,%r9d
 100c933:	cmp    %r8d,%r9d
 100c936:	jae    100c9b0 <check_program+0x2a90>
 100c938:	mov    0x98(%rdi),%rax
 100c93f:	test   %rax,%rax
 100c942:	je     100c9b0 <check_program+0x2a90>
 100c944:	mov    %r9d,%edi
 100c947:	lea    (%rdi,%rdi,8),%rdi
 100c94b:	lea    (%rax,%rdi,4),%rdi
 100c94f:	cmp    %ebp,(%rdi)
 100c951:	jne    100c9b0 <check_program+0x2a90>
 100c953:	cmp    %esi,0x4(%rdi)
 100c956:	jne    100c9b0 <check_program+0x2a90>
 100c958:	cmpl   $0x0,0x8(%rdi)
 100c95c:	mov    0x8(%rsp),%r12
 100c961:	mov    0x90(%rsp),%r13
 100c969:	mov    0x28(%rsp),%r11d
 100c96e:	je     100c9e6 <check_program+0x2ac6>
 100c970:	cmpl   $0x0,0xbc(%r12)
 100c979:	jne    100c860 <check_program+0x2940>
 100c97f:	mov    0x8(%r15),%rax
 100c983:	mov    (%rax,%rbp,4),%eax
 100c986:	movl   $0x1,0xbc(%r12)
 100c992:	mov    %eax,0xb4(%r12)
 100c99a:	mov    %eax,0xb8(%r12)
 100c9a2:	jmp    100c860 <check_program+0x2940>
 100c9a7:	nopw   0x0(%rax,%rax,1)
 100c9b0:	mov    0x90(%rsp),%r13
 100c9b8:	mov    0x28(%rsp),%r11d
 100c9bd:	mov    0x8(%rsp),%r12
 100c9c2:	cmp    %r11d,0x0(%r13,%rdx,4)
 100c9c7:	je     100c860 <check_program+0x2940>
 100c9cd:	mov    0xb8(%rsp),%rsi
 100c9d5:	mov    %ebx,%eax
 100c9d7:	inc    %ebx
 100c9d9:	mov    %r11d,0x0(%r13,%rdx,4)
 100c9de:	mov    %edx,(%rsi,%rax,4)
 100c9e1:	jmp    100c860 <check_program+0x2940>
 100c9e6:	mov    0x18(%rdi),%edx
 100c9e9:	test   %rdx,%rdx
 100c9ec:	je     100c970 <check_program+0x2a50>
 100c9ee:	cmp    0xac(%r12),%edx
 100c9f6:	jae    100c970 <check_program+0x2a50>
 100c9fc:	mov    0x10(%r12),%r8
 100ca01:	mov    0x1c(%rdi),%r9d
 100ca05:	mov    (%r8),%rsi
 100ca08:	shr    $0x3,%r9d
 100ca0c:	movzbl (%rsi,%r9,1),%eax
 100ca11:	cmp    $0xf,%al
 100ca13:	jne    100ca24 <check_program+0x2b04>
 100ca15:	mov    0x20(%r8),%rax
 100ca19:	mov    (%rax,%r9,4),%eax
 100ca1d:	shr    $0x3,%eax
 100ca20:	movzbl (%rsi,%rax,1),%eax
 100ca24:	cmp    $0xb,%al
 100ca26:	jne    100c970 <check_program+0x2a50>
 100ca2c:	mov    0xb0(%rsp),%rax
 100ca34:	cmp    %r11d,(%rax,%rdx,4)
 100ca38:	je     100c860 <check_program+0x2940>
 100ca3e:	mov    %r11d,(%rax,%rdx,4)
 100ca42:	mov    0x48(%rsp),%rdx
 100ca47:	mov    0x30(%rsp),%rsi
 100ca4c:	mov    0x18(%rdi),%eax
 100ca4f:	movb   $0x1,(%rdx,%rax,1)
 100ca53:	mov    %esi,%edx
 100ca55:	inc    %esi
 100ca57:	mov    0x18(%rdi),%eax
 100ca5a:	mov    %rsi,0x30(%rsp)
 100ca5f:	mov    0x80(%rsp),%rsi
 100ca67:	shl    $0x20,%rax
 100ca6b:	mov    %rax,(%rsi,%rdx,8)
 100ca6f:	jmp    100c860 <check_program+0x2940>
 100ca74:	mov    0x78(%rax),%r8
 100ca78:	mov    0xc0(%rax),%r9d
 100ca7f:	mov    $0x0,%edi
 100ca84:	xor    %eax,%eax
 100ca86:	test   %r9d,%r9d
 100ca89:	je     100caca <check_program+0x2baa>
 100ca8b:	xor    %edi,%edi
 100ca8d:	mov    %r9d,%esi
 100ca90:	jmp    100caa7 <check_program+0x2b87>
 100ca92:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100caa0:	mov    %r11d,%esi
 100caa3:	cmp    %esi,%edi
 100caa5:	jae    100caca <check_program+0x2baa>
 100caa7:	mov    %esi,%r10d
 100caaa:	sub    %edi,%r10d
 100caad:	shr    $1,%r10d
 100cab0:	lea    (%r10,%rdi,1),%r11d
 100cab4:	imul   $0x160,%r11,%r12
 100cabb:	cmp    %ebp,(%r8,%r12,1)
 100cabf:	jae    100caa0 <check_program+0x2b80>
 100cac1:	lea    0x1(%r10,%rdi,1),%edi
 100cac6:	cmp    %esi,%edi
 100cac8:	jb     100caa7 <check_program+0x2b87>
 100caca:	mov    $0xffffffff,%esi
 100cacf:	cmp    %r9d,%edi
 100cad2:	jae    100cb6e <check_program+0x2c4e>
 100cad8:	mov    0x8(%rsp),%r12
 100cadd:	mov    0x28(%rsp),%r11d
 100cae2:	mov    %edi,%r9d
 100cae5:	imul   $0x160,%r9,%r9
 100caec:	cmp    %ebp,(%r8,%r9,1)
 100caf0:	jne    100cb78 <check_program+0x2c58>
 100caf6:	mov    0x13c(%r8,%r9,1),%eax
 100cafe:	cmp    $0x3,%eax
 100cb01:	ja     100cb12 <check_program+0x2bf2>
 100cb03:	mov    0xa0(%rcx),%r8
 100cb0a:	mov    %edi,%esi
 100cb0c:	cmp    (%r8,%rbp,4),%eax
 100cb10:	jbe    100cb78 <check_program+0x2c58>
 100cb12:	cmpl   $0x0,0xbc(%r12)
 100cb1b:	jne    100cb40 <check_program+0x2c20>
 100cb1d:	mov    0x8(%rcx),%rcx
 100cb21:	mov    (%rcx,%rbp,4),%ecx
 100cb24:	movl   $0x1,0xbc(%r12)
 100cb30:	mov    %ecx,0xb4(%r12)
 100cb38:	mov    %ecx,0xb8(%r12)
 100cb40:	mov    $0xffffffff,%ecx
 100cb45:	cmp    $0x4,%eax
 100cb48:	shlx   %eax,%ecx,%ecx
 100cb4d:	mov    $0x0,%eax
 100cb52:	not    %ecx
 100cb54:	cmovae %eax,%ecx
 100cb57:	mov    %ecx,0x18(%rsp)
 100cb5b:	jmp    100c840 <check_program+0x2920>
 100cb60:	mov    %ebx,%r9d
 100cb63:	mov    %r12d,%edx
 100cb66:	mov    %r13,%r12
 100cb69:	jmp    100c14e <check_program+0x222e>
 100cb6e:	mov    0x8(%rsp),%r12
 100cb73:	mov    0x28(%rsp),%r11d
 100cb78:	mov    $0xffffffff,%edi
 100cb7d:	shlx   %eax,%edi,%eax
 100cb82:	not    %eax
 100cb84:	mov    %eax,0x18(%rsp)
 100cb88:	cmp    $0x22,%edx
 100cb8b:	jne    100c808 <check_program+0x28e8>
 100cb91:	jmp    100c840 <check_program+0x2920>
 100cb96:	cmpl   $0x0,0x8(%rax)
 100cb9a:	mov    0x18(%rsp),%r10d
 100cb9f:	mov    0x8(%rsp),%r12
 100cba4:	mov    %r13d,%r9d
 100cba7:	je     100ce90 <check_program+0x2f70>
 100cbad:	cmpl   $0x0,0xbc(%r12)
 100cbb6:	jne    100c219 <check_program+0x22f9>
 100cbbc:	mov    0x8(%r15),%rax
 100cbc0:	mov    (%rax,%rbp,4),%eax
 100cbc3:	movl   $0x1,0xbc(%r12)
 100cbcf:	mov    %eax,0xb4(%r12)
 100cbd7:	mov    %eax,0xb8(%r12)
 100cbdf:	jmp    100c219 <check_program+0x22f9>
 100cbe4:	mov    $0xffffffff,%edx
 100cbe9:	cmpl   $0x0,0xbc(%r12)
 100cbf2:	jne    100c14e <check_program+0x222e>
 100cbf8:	mov    0x8(%r15),%rax
 100cbfc:	mov    (%rax,%rbp,4),%eax
 100cbff:	movl   $0x1,0xbc(%r12)
 100cc0b:	mov    %eax,0xb4(%r12)
 100cc13:	mov    %eax,0xb8(%r12)
 100cc1b:	jmp    100c14e <check_program+0x222e>
 100cc20:	mov    (%rdx),%rcx
 100cc23:	lea    (%rsi,%rsi,2),%rdx
 100cc27:	shl    $0x4,%rdx
 100cc2b:	cmpl   $0x0,-0x18(%rcx,%rdx,1)
 100cc30:	je     100bcff <check_program+0x1ddf>
 100cc36:	add    %rdx,%rcx
 100cc39:	xor    %edx,%edx
 100cc3b:	xor    %esi,%esi
 100cc3d:	jmp    100cc66 <check_program+0x2d46>
 100cc3f:	cmpl   $0x0,0xbc(%r12)
 100cc48:	je     100cd25 <check_program+0x2e05>
 100cc4e:	xchg   %ax,%ax
 100cc50:	mov    -0x18(%rcx),%edi
 100cc53:	inc    %rsi
 100cc56:	add    $0xb0,%rdx
 100cc5d:	cmp    %rdi,%rsi
 100cc60:	jae    100ce84 <check_program+0x2f64>
 100cc66:	mov    -0x20(%rcx),%rdi
 100cc6a:	cmpl   $0x0,(%rdi,%rdx,1)
 100cc6e:	jne    100cc50 <check_program+0x2d30>
 100cc70:	mov    0x8(%rdi,%rdx,1),%r8d
 100cc75:	cmp    0x8c(%rax),%r8d
 100cc7c:	jae    100cc50 <check_program+0x2d30>
 100cc7e:	mov    0x8(%r12),%r9
 100cc83:	lea    (%r8,%r8,2),%r10
 100cc87:	shl    $0x5,%r10
 100cc8b:	mov    0x8(%r9),%r9
 100cc8f:	cmpl   $0x0,0x44(%r9,%r10,1)
 100cc95:	je     100cd08 <check_program+0x2de8>
 100cc97:	cmpl   $0x0,0x84(%rdi,%rdx,1)
 100cc9f:	jne    100cc3f <check_program+0x2d1f>
 100cca1:	cmpl   $0x3,0x4c(%rdi,%rdx,1)
 100cca6:	jne    100cc3f <check_program+0x2d1f>
 100cca8:	mov    0x80(%rdi,%rdx,1),%r8d
 100ccb0:	test   %r8d,%r8d
 100ccb3:	je     100cc3f <check_program+0x2d1f>
 100ccb5:	cmp    0xac(%r12),%r8d
 100ccbd:	jae    100cc3f <check_program+0x2d1f>
 100ccc3:	mov    0xb0(%rsp),%rdi
 100cccb:	cmp    %r11d,(%rdi,%r8,4)
 100cccf:	je     100cc50 <check_program+0x2d30>
 100ccd5:	mov    0x48(%rsp),%r9
 100ccda:	mov    %r11d,(%rdi,%r8,4)
 100ccde:	mov    0x80(%rsp),%r10
 100cce6:	movb   $0x1,(%r9,%r8,1)
 100cceb:	mov    0x30(%rsp),%r9
 100ccf0:	shl    $0x20,%r8
 100ccf4:	mov    %r9d,%edi
 100ccf7:	inc    %r9d
 100ccfa:	mov    %r8,(%r10,%rdi,8)
 100ccfe:	mov    %r9,0x30(%rsp)
 100cd03:	jmp    100cc50 <check_program+0x2d30>
 100cd08:	cmp    %r11d,0x0(%r13,%r8,4)
 100cd0d:	je     100cc50 <check_program+0x2d30>
 100cd13:	mov    %ebx,%edi
 100cd15:	inc    %ebx
 100cd17:	mov    %r11d,0x0(%r13,%r8,4)
 100cd1c:	mov    %r8d,(%r14,%rdi,4)
 100cd20:	jmp    100cc50 <check_program+0x2d30>
 100cd25:	mov    0xc(%rdi,%rdx,1),%edi
 100cd29:	movl   $0x1,0xbc(%r12)
 100cd35:	mov    %edi,0xb4(%r12)
 100cd3d:	mov    %edi,0xb8(%r12)
 100cd45:	jmp    100cc50 <check_program+0x2d30>
 100cd4a:	mov    0x28(%rsp),%r11d
 100cd4f:	mov    0x18(%rsp),%r10d
 100cd54:	mov    %r13d,%r9d
 100cd57:	jmp    100cf4f <check_program+0x302f>
 100cd5c:	mov    0x18(%rax),%ecx
 100cd5f:	test   %rcx,%rcx
 100cd62:	je     100c2da <check_program+0x23ba>
 100cd68:	cmp    0xac(%r12),%ecx
 100cd70:	jae    100c2da <check_program+0x23ba>
 100cd76:	mov    0x10(%r12),%rsi
 100cd7b:	mov    0x1c(%rax),%edi
 100cd7e:	mov    (%rsi),%rdx
 100cd81:	shr    $0x3,%edi
 100cd84:	movzbl (%rdx,%rdi,1),%r8d
 100cd89:	cmp    $0xf,%r8b
 100cd8d:	jne    100cd9e <check_program+0x2e7e>
 100cd8f:	mov    0x20(%rsi),%rsi
 100cd93:	mov    (%rsi,%rdi,4),%esi
 100cd96:	shr    $0x3,%esi
 100cd99:	movzbl (%rdx,%rsi,1),%r8d
 100cd9e:	cmp    $0xb,%r8b
 100cda2:	jne    100c2da <check_program+0x23ba>
 100cda8:	mov    0xb0(%rsp),%rdx
 100cdb0:	cmp    %r11d,(%rdx,%rcx,4)
 100cdb4:	je     100c334 <check_program+0x2414>
 100cdba:	mov    %r11d,(%rdx,%rcx,4)
 100cdbe:	mov    0x48(%rsp),%rdx
 100cdc3:	mov    0x80(%rsp),%rsi
 100cdcb:	mov    0x18(%rax),%ecx
 100cdce:	movb   $0x1,(%rdx,%rcx,1)
 100cdd2:	mov    0x30(%rsp),%rdx
 100cdd7:	mov    0x18(%rax),%eax
 100cdda:	mov    %edx,%ecx
 100cddc:	inc    %edx
 100cdde:	shl    $0x20,%rax
 100cde2:	mov    %rdx,0x30(%rsp)
 100cde7:	mov    %rax,(%rsi,%rcx,8)
 100cdeb:	jmp    100c334 <check_program+0x2414>
 100cdf0:	mov    0x18(%rax),%ecx
 100cdf3:	test   %rcx,%rcx
 100cdf6:	je     100c3d0 <check_program+0x24b0>
 100cdfc:	cmp    0xac(%r12),%ecx
 100ce04:	jae    100c3d0 <check_program+0x24b0>
 100ce0a:	mov    0x10(%r12),%rsi
 100ce0f:	mov    0x1c(%rax),%edi
 100ce12:	mov    (%rsi),%rdx
 100ce15:	shr    $0x3,%edi
 100ce18:	movzbl (%rdx,%rdi,1),%r8d
 100ce1d:	cmp    $0xf,%r8b
 100ce21:	jne    100ce32 <check_program+0x2f12>
 100ce23:	mov    0x20(%rsi),%rsi
 100ce27:	mov    (%rsi,%rdi,4),%esi
 100ce2a:	shr    $0x3,%esi
 100ce2d:	movzbl (%rdx,%rsi,1),%r8d
 100ce32:	cmp    $0xb,%r8b
 100ce36:	jne    100c3d0 <check_program+0x24b0>
 100ce3c:	mov    0xb0(%rsp),%rdx
 100ce44:	cmp    %r11d,(%rdx,%rcx,4)
 100ce48:	je     100c421 <check_program+0x2501>
 100ce4e:	mov    %r11d,(%rdx,%rcx,4)
 100ce52:	mov    0x48(%rsp),%rdx
 100ce57:	mov    0x80(%rsp),%rsi
 100ce5f:	mov    0x18(%rax),%ecx
 100ce62:	movb   $0x1,(%rdx,%rcx,1)
 100ce66:	mov    0x30(%rsp),%rdx
 100ce6b:	mov    0x18(%rax),%eax
 100ce6e:	mov    %edx,%ecx
 100ce70:	inc    %edx
 100ce72:	shl    $0x20,%rax
 100ce76:	mov    %rdx,0x30(%rsp)
 100ce7b:	mov    %rax,(%rsi,%rcx,8)
 100ce7f:	jmp    100c421 <check_program+0x2501>
 100ce84:	mov    %ebx,0x2bc(%rsp)
 100ce8b:	jmp    100bcff <check_program+0x1ddf>
 100ce90:	mov    0x18(%rax),%ecx
 100ce93:	test   %rcx,%rcx
 100ce96:	je     100cbad <check_program+0x2c8d>
 100ce9c:	cmp    0xac(%r12),%ecx
 100cea4:	jae    100cbad <check_program+0x2c8d>
 100ceaa:	mov    0x10(%r12),%rsi
 100ceaf:	mov    0x1c(%rax),%edi
 100ceb2:	mov    (%rsi),%rdx
 100ceb5:	shr    $0x3,%edi
 100ceb8:	movzbl (%rdx,%rdi,1),%r8d
 100cebd:	cmp    $0xf,%r8b
 100cec1:	jne    100ced2 <check_program+0x2fb2>
 100cec3:	mov    0x20(%rsi),%rsi
 100cec7:	mov    (%rsi,%rdi,4),%esi
 100ceca:	shr    $0x3,%esi
 100cecd:	movzbl (%rdx,%rsi,1),%r8d
 100ced2:	cmp    $0xb,%r8b
 100ced6:	jne    100cbad <check_program+0x2c8d>
 100cedc:	mov    0xb0(%rsp),%rdx
 100cee4:	cmp    %r11d,(%rdx,%rcx,4)
 100cee8:	je     100c219 <check_program+0x22f9>
 100ceee:	mov    %r11d,(%rdx,%rcx,4)
 100cef2:	mov    0x48(%rsp),%rdx
 100cef7:	mov    0x80(%rsp),%rsi
 100ceff:	mov    0x18(%rax),%ecx
 100cf02:	movb   $0x1,(%rdx,%rcx,1)
 100cf06:	mov    0x30(%rsp),%rdx
 100cf0b:	mov    0x18(%rax),%eax
 100cf0e:	mov    %edx,%ecx
 100cf10:	inc    %edx
 100cf12:	shl    $0x20,%rax
 100cf16:	mov    %rdx,0x30(%rsp)
 100cf1b:	mov    %rax,(%rsi,%rcx,8)
 100cf1f:	jmp    100c219 <check_program+0x22f9>
 100cf24:	movzbl 0x2bb(%rsp),%eax
 100cf2c:	and    $0x1,%al
 100cf2e:	mov    %eax,%ecx
 100cf30:	neg    %cl
 100cf32:	sbb    %ecx,%ecx
 100cf34:	or     %r9d,%ecx
 100cf37:	cmp    $0x16,%r14d
 100cf3b:	cmovne %r9d,%ecx
 100cf3f:	cmp    $0x1,%al
 100cf41:	sbb    %r9d,%r9d
 100cf44:	or     %ecx,%r9d
 100cf47:	cmp    $0x15,%r14d
 100cf4b:	cmovne %ecx,%r9d
 100cf4f:	mov    %r12d,%edx
 100cf52:	mov    0x8(%rsp),%r12
 100cf57:	mov    %r10d,0x18(%rsp)
 100cf5c:	cmp    $0xffffffff,%edx
 100cf5f:	jne    100c16b <check_program+0x224b>
 100cf65:	jmp    100c219 <check_program+0x22f9>
 100cf6a:	nopw   0x0(%rax,%rax,1)
 100cf70:	mov    0x30(%rsp),%rcx
 100cf75:	mov    0x78(%rsp),%edx
 100cf79:	mov    0x58(%rsp),%rax
 100cf7e:	add    %ecx,%edx
 100cf80:	mov    %ecx,0x1c(%rax)
 100cf83:	jae    100cfc4 <check_program+0x30a4>
 100cf85:	cmpl   $0x0,0xbc(%r12)
 100cf8e:	mov    0x20(%rsp),%rbp
 100cf93:	mov    0x70(%rsp),%r14
 100cf98:	mov    0x60(%rsp),%r15
 100cf9d:	jne    100b220 <check_program+0x1300>
 100cfa3:	movl   $0x3,0xbc(%r12)
 100cfaf:	mov    %r15d,0xb4(%r12)
 100cfb7:	mov    %r15d,0xb8(%r12)
 100cfbf:	jmp    100b220 <check_program+0x1300>
 100cfc4:	mov    0x20(%rsp),%rbp
 100cfc9:	mov    0x80(%rsp),%rdi
 100cfd1:	mov    0x70(%rsp),%r14
 100cfd6:	mov    0x60(%rsp),%r15
 100cfdb:	mov    $0x0,%r8d
 100cfe1:	xor    %ebx,%ebx
 100cfe3:	cmp    $0x2,%ecx
 100cfe6:	jb     100d316 <check_program+0x33f6>
 100cfec:	mov    0x30(%rsp),%rdx
 100cff1:	mov    (%rdi),%rax
 100cff4:	mov    %edx,%ecx
 100cff6:	cmp    $0x9,%edx
 100cff9:	jae    100d1b4 <check_program+0x3294>
 100cfff:	mov    $0x1,%edx
 100d004:	xor    %r8d,%r8d
 100d007:	jmp    100d300 <check_program+0x33e0>
 100d00c:	lea    0x0(,%rax,4),%rdx
 100d014:	mov    %r14d,%ecx
 100d017:	sub    %eax,%ecx
 100d019:	xor    %esi,%esi
 100d01b:	jmp    100d02c <check_program+0x310c>
 100d01d:	nopl   (%rax)
 100d020:	add    $0x2,%rsi
 100d024:	cmp    %esi,%ecx
 100d026:	je     100b3bd <check_program+0x149d>
 100d02c:	mov    0x1b0(%rsp),%rdi
 100d034:	mov    0x50(%rdi),%rdi
 100d038:	add    %rax,%rdi
 100d03b:	movzbl (%rsi,%rdi,1),%r8d
 100d040:	cmp    $0x53,%r8d
 100d044:	je     100d050 <check_program+0x3130>
 100d046:	cmp    $0x21,%r8d
 100d04a:	jne    100d0e9 <check_program+0x31c9>
 100d050:	mov    0x2a0(%rsp),%edi
 100d057:	cmp    0x2a4(%rsp),%edi
 100d05e:	jae    100d080 <check_program+0x3160>
 100d060:	mov    0x290(%rsp),%r9
 100d068:	movl   $0xffffffff,(%r9,%rdi,4)
 100d070:	incl   0x2a0(%rsp)
 100d077:	jmp    100d0b0 <check_program+0x3190>
 100d079:	nopl   0x0(%rax)
 100d080:	mov    0x1a8(%rsp),%r9
 100d088:	cmpl   $0x0,0xbc(%r9)
 100d090:	jne    100d0b0 <check_program+0x3190>
 100d092:	movl   $0x3,0xbc(%r9)
 100d09d:	movq   $0x0,0xb4(%r9)
 100d0a8:	nopl   0x0(%rax,%rax,1)
 100d0b0:	mov    0x250(%rsp),%r9
 100d0b8:	add    %rdx,%r9
 100d0bb:	mov    %edi,(%r9,%rsi,4)
 100d0bf:	cmp    $0x53,%r8b
 100d0c3:	jne    100d0e9 <check_program+0x31c9>
 100d0c5:	mov    0x248(%rsp),%r9
 100d0cd:	mov    0x1a8(%rsp),%r8
 100d0d5:	add    %rdx,%r9
 100d0d8:	mov    0x48(%r8),%r8
 100d0dc:	mov    (%r9,%rsi,4),%r9d
 100d0e0:	shl    $0x6,%r9
 100d0e4:	mov    %edi,0x2c(%r8,%r9,1)
 100d0e9:	mov    0x1b0(%rsp),%rdi
 100d0f1:	mov    0x50(%rdi),%rdi
 100d0f5:	add    %rax,%rdi
 100d0f8:	movzbl 0x1(%rsi,%rdi,1),%r8d
 100d0fe:	cmp    $0x53,%r8d
 100d102:	je     100d10e <check_program+0x31ee>
 100d104:	cmp    $0x21,%r8d
 100d108:	jne    100d020 <check_program+0x3100>
 100d10e:	mov    0x2a0(%rsp),%edi
 100d115:	cmp    0x2a4(%rsp),%edi
 100d11c:	jae    100d140 <check_program+0x3220>
 100d11e:	mov    0x290(%rsp),%r9
 100d126:	movl   $0xffffffff,(%r9,%rdi,4)
 100d12e:	incl   0x2a0(%rsp)
 100d135:	jmp    100d170 <check_program+0x3250>
 100d137:	nopw   0x0(%rax,%rax,1)
 100d140:	mov    0x1a8(%rsp),%r9
 100d148:	cmpl   $0x0,0xbc(%r9)
 100d150:	jne    100d170 <check_program+0x3250>
 100d152:	movl   $0x3,0xbc(%r9)
 100d15d:	movq   $0x0,0xb4(%r9)
 100d168:	nopl   0x0(%rax,%rax,1)
 100d170:	mov    0x250(%rsp),%r9
 100d178:	add    %rdx,%r9
 100d17b:	mov    %edi,0x4(%r9,%rsi,4)
 100d180:	cmp    $0x53,%r8b
 100d184:	jne    100d020 <check_program+0x3100>
 100d18a:	mov    0x248(%rsp),%r9
 100d192:	mov    0x1a8(%rsp),%r8
 100d19a:	add    %rdx,%r9
 100d19d:	mov    0x48(%r8),%r8
 100d1a1:	mov    0x4(%r9,%rsi,4),%r9d
 100d1a6:	shl    $0x6,%r9
 100d1aa:	mov    %edi,0x2c(%r8,%r9,1)
 100d1af:	jmp    100d020 <check_program+0x3100>
 100d1b4:	lea    -0x1(%rcx),%rsi
 100d1b8:	vpbroadcastq %rax,%zmm0
 100d1be:	cmp    $0x21,%edx
 100d1c1:	jae    100d1ce <check_program+0x32ae>
 100d1c3:	xor    %r10d,%r10d
 100d1c6:	xor    %r8d,%r8d
 100d1c9:	jmp    100d2a0 <check_program+0x3380>
 100d1ce:	mov    %rsi,%r10
 100d1d1:	and    $0xffffffffffffffe0,%r10
 100d1d5:	vpxor  %xmm1,%xmm1,%xmm1
 100d1d9:	xor    %r8d,%r8d
 100d1dc:	vpxor  %xmm2,%xmm2,%xmm2
 100d1e0:	vpxor  %xmm4,%xmm4,%xmm4
 100d1e4:	vpxor  %xmm3,%xmm3,%xmm3
 100d1e8:	lea    0x1(%r10),%rdx
 100d1ec:	nopl   0x0(%rax)
 100d1f0:	vpxorq 0x48(%rdi,%r8,8),%zmm0,%zmm6
 100d1fb:	vpxorq 0x8(%rdi,%r8,8),%zmm0,%zmm5
 100d206:	vpxorq 0x88(%rdi,%r8,8),%zmm0,%zmm7
 100d211:	vpxorq 0xc8(%rdi,%r8,8),%zmm0,%zmm8
 100d21c:	add    $0x20,%r8
 100d220:	vpsrlq $0x20,%zmm6,%zmm6
 100d227:	vpsrlq $0x20,%zmm5,%zmm5
 100d22e:	vpsrlq $0x20,%zmm7,%zmm7
 100d235:	vpsrlq $0x20,%zmm8,%zmm8
 100d23c:	vpmovqd %zmm6,%ymm6
 100d242:	vpmovqd %zmm5,%ymm5
 100d248:	vpmovqd %zmm7,%ymm7
 100d24e:	vpor   %ymm6,%ymm4,%ymm4
 100d252:	vpmovqd %zmm8,%ymm6
 100d258:	vpor   %ymm5,%ymm2,%ymm2
 100d25c:	vpor   %ymm7,%ymm3,%ymm3
 100d260:	vpor   %ymm6,%ymm1,%ymm1
 100d264:	cmp    %r8,%r10
 100d267:	jne    100d1f0 <check_program+0x32d0>
 100d269:	vpor   %ymm2,%ymm4,%ymm2
 100d26d:	vpternlogd $0xfe,%ymm2,%ymm3,%ymm1
 100d274:	vextracti128 $0x1,%ymm1,%xmm2
 100d27a:	vpor   %xmm2,%xmm1,%xmm1
 100d27e:	vpshufd $0xee,%xmm1,%xmm2
 100d283:	vpor   %xmm2,%xmm1,%xmm1
 100d287:	vpshufd $0x55,%xmm1,%xmm2
 100d28c:	vpor   %xmm2,%xmm1,%xmm1
 100d290:	vmovd  %xmm1,%r8d
 100d295:	cmp    %r10,%rsi
 100d298:	je     100d316 <check_program+0x33f6>
 100d29a:	test   $0x18,%sil
 100d29e:	je     100d300 <check_program+0x33e0>
 100d2a0:	mov    %rsi,%r9
 100d2a3:	and    $0xfffffffffffffff8,%r9
 100d2a7:	vmovd  %r8d,%xmm1
 100d2ac:	lea    0x1(%r9),%rdx
 100d2b0:	vpxorq 0x8(%rdi,%r10,8),%zmm0,%zmm2
 100d2bb:	add    $0x8,%r10
 100d2bf:	vpsrlq $0x20,%zmm2,%zmm2
 100d2c6:	vpmovqd %zmm2,%ymm2
 100d2cc:	vpor   %ymm2,%ymm1,%ymm1
 100d2d0:	cmp    %r10,%r9
 100d2d3:	jne    100d2b0 <check_program+0x3390>
 100d2d5:	vextracti128 $0x1,%ymm1,%xmm0
 100d2db:	vpor   %xmm0,%xmm1,%xmm0
 100d2df:	vpshufd $0xee,%xmm0,%xmm1
 100d2e4:	vpor   %xmm1,%xmm0,%xmm0
 100d2e8:	vpshufd $0x55,%xmm0,%xmm1
 100d2ed:	vpor   %xmm1,%xmm0,%xmm0
 100d2f1:	vmovd  %xmm0,%r8d
 100d2f6:	cmp    %r9,%rsi
 100d2f9:	je     100d316 <check_program+0x33f6>
 100d2fb:	nopl   0x0(%rax,%rax,1)
 100d300:	mov    (%rdi,%rdx,8),%rsi
 100d304:	inc    %rdx
 100d307:	xor    %rax,%rsi
 100d30a:	shr    $0x20,%rsi
 100d30e:	or     %esi,%r8d
 100d311:	cmp    %rdx,%rcx
 100d314:	jne    100d300 <check_program+0x33e0>
 100d316:	lea    0x300(%rsp),%rax
 100d31e:	mov    0x168(%rsp),%rsi
 100d326:	mov    0x30(%rsp),%rdx
 100d32b:	movzbl 0x24(%rax),%ecx
 100d32f:	xor    $0x1,%ecx
 100d332:	vzeroupper
 100d335:	call   106c800 <c_bindings_sort>
 100d33a:	mov    0x58(%rsp),%rcx
 100d33f:	mov    0x1c(%rcx),%ecx
 100d342:	test   %rcx,%rcx
 100d345:	je     100d378 <check_program+0x3458>
 100d347:	mov    0x40(%rsp),%r8
 100d34c:	mov    (%r8),%rdx
 100d34f:	mov    0x8(%r8),%rdi
 100d353:	lea    0x3(%rdi,%rdx,1),%rsi
 100d358:	add    %rdx,%rdi
 100d35b:	and    $0xfffffffffffffffc,%rsi
 100d35f:	cmp    %rdi,%rsi
 100d362:	jae    100d3b7 <check_program+0x3497>
 100d364:	mov    0x58(%rsp),%r10
 100d369:	xor    %edx,%edx
 100d36b:	test   %ecx,%ecx
 100d36d:	jne    100d3f3 <check_program+0x34d3>
 100d373:	jmp    100d432 <check_program+0x3512>
 100d378:	xor    %edx,%edx
 100d37a:	cmpq   $0x0,0x58(%r12)
 100d380:	jne    100d38f <check_program+0x346f>
 100d382:	mov    0x58(%rsp),%rcx
 100d387:	mov    %rdx,0x58(%r12)
 100d38c:	mov    0x1c(%rcx),%ebx
 100d38f:	test   %ebx,%ebx
 100d391:	je     100b20b <check_program+0x12eb>
 100d397:	mov    0x58(%rsp),%rdi
 100d39c:	xor    %esi,%esi
 100d39e:	xchg   %ax,%ax
 100d3a0:	mov    0x4(%rax,%rsi,8),%ecx
 100d3a4:	mov    %ecx,(%rdx,%rsi,4)
 100d3a7:	inc    %rsi
 100d3aa:	mov    0x1c(%rdi),%ecx
 100d3ad:	cmp    %rcx,%rsi
 100d3b0:	jb     100d3a0 <check_program+0x3480>
 100d3b2:	jmp    100b20d <check_program+0x12ed>
 100d3b7:	mov    0x10(%r8),%r9
 100d3bb:	mov    0x58(%rsp),%r10
 100d3c0:	mov    %rsi,%rdi
 100d3c3:	sub    %rdx,%rdi
 100d3c6:	sub    %rdi,%r9
 100d3c9:	jb     100d42c <check_program+0x350c>
 100d3cb:	mov    %rcx,%r8
 100d3ce:	shl    $0x2,%r8
 100d3d2:	mov    $0x0,%edx
 100d3d7:	cmp    %r9,%r8
 100d3da:	ja     100d3ef <check_program+0x34cf>
 100d3dc:	mov    0x40(%rsp),%rcx
 100d3e1:	add    %r8,%rdi
 100d3e4:	mov    %rsi,%rdx
 100d3e7:	mov    %rdi,0x8(%rcx)
 100d3eb:	mov    0x1c(%r10),%ecx
 100d3ef:	test   %ecx,%ecx
 100d3f1:	je     100d432 <check_program+0x3512>
 100d3f3:	test   %rdx,%rdx
 100d3f6:	jne    100d432 <check_program+0x3512>
 100d3f8:	cmpl   $0x0,0xbc(%r12)
 100d401:	jne    100b20d <check_program+0x12ed>
 100d407:	movl   $0x3,0xbc(%r12)
 100d413:	mov    %r15d,0xb4(%r12)
 100d41b:	mov    %r15d,0xb8(%r12)
 100d423:	mov    0x1c(%r10),%ecx
 100d427:	jmp    100b20d <check_program+0x12ed>
 100d42c:	xor    %edx,%edx
 100d42e:	test   %ecx,%ecx
 100d430:	jne    100d3f3 <check_program+0x34d3>
 100d432:	mov    %ecx,%ebx
 100d434:	cmpq   $0x0,0x58(%r12)
 100d43a:	jne    100d38f <check_program+0x346f>
 100d440:	jmp    100d382 <check_program+0x3462>
 100d445:	cmpb   $0x0,0xd8(%rsp)
 100d44d:	lea    0xc0(%r12),%r14
 100d455:	je     100d650 <check_program+0x3730>
 100d45b:	mov    0xbc(%r12),%eax
 100d463:	test   %eax,%eax
 100d465:	sete   %cl
 100d468:	cmpl   $0x0,0x98(%rsp)
 100d470:	setne  %dl
 100d473:	and    %cl,%dl
 100d475:	cmp    $0x1,%dl
 100d478:	jne    100d648 <check_program+0x3728>
 100d47e:	mov    0x98(%rsp),%rsi
 100d486:	mov    %esi,%ecx
 100d488:	and    $0x3,%ecx
 100d48b:	cmp    $0x4,%esi
 100d48e:	jae    100d4a5 <check_program+0x3585>
 100d490:	xor    %edx,%edx
 100d492:	jmp    100d5f0 <check_program+0x36d0>
 100d497:	mov    %rdi,%r11
 100d49a:	mov    %rbx,%r15
 100d49d:	mov    %r10,%rdi
 100d4a0:	jmp    100d813 <check_program+0x38f3>
 100d4a5:	and    $0xfffffffc,%esi
 100d4a8:	mov    $0x6783,%edi
 100d4ad:	xor    %edx,%edx
 100d4af:	jmp    100d4d8 <check_program+0x35b8>
 100d4b1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100d4c0:	xor    %r8d,%r8d
 100d4c3:	add    %r8d,0xa4(%r12)
 100d4cb:	add    $0x4,%rdx
 100d4cf:	cmp    %rdx,%rsi
 100d4d2:	je     100d5eb <check_program+0x36cb>
 100d4d8:	cmpl   $0x0,0x0(%r13,%rdx,4)
 100d4de:	mov    $0x0,%r8d
 100d4e4:	je     100d515 <check_program+0x35f5>
 100d4e6:	mov    0x0(%rbp),%r8
 100d4ea:	mov    (%r8,%rdx,4),%r9d
 100d4ee:	lea    -0x35(%r9),%r8d
 100d4f2:	cmp    $0xf,%r8d
 100d4f6:	shrx   %r8d,%edi,%r11d
 100d4fb:	mov    $0x1,%r8d
 100d501:	setb   %r10b
 100d505:	test   %r11b,%r10b
 100d508:	jne    100d515 <check_program+0x35f5>
 100d50a:	xor    %r8d,%r8d
 100d50d:	cmp    $0x44,%r9d
 100d511:	sete   %r8b
 100d515:	add    %r8d,0xa4(%r12)
 100d51d:	xor    %r8d,%r8d
 100d520:	mov    $0x0,%r9d
 100d526:	cmpl   $0x0,0x4(%r13,%rdx,4)
 100d52c:	je     100d55e <check_program+0x363e>
 100d52e:	mov    0x0(%rbp),%r9
 100d532:	mov    0x4(%r9,%rdx,4),%r10d
 100d537:	lea    -0x35(%r10),%r9d
 100d53b:	cmp    $0xf,%r9d
 100d53f:	shrx   %r9d,%edi,%ebx
 100d544:	mov    $0x1,%r9d
 100d54a:	setb   %r11b
 100d54e:	test   %bl,%r11b
 100d551:	jne    100d55e <check_program+0x363e>
 100d553:	xor    %r9d,%r9d
 100d556:	cmp    $0x44,%r10d
 100d55a:	sete   %r9b
 100d55e:	add    %r9d,0xa4(%r12)
 100d566:	cmpl   $0x0,0x8(%r13,%rdx,4)
 100d56c:	je     100d59e <check_program+0x367e>
 100d56e:	mov    0x0(%rbp),%r8
 100d572:	mov    0x8(%r8,%rdx,4),%r9d
 100d577:	lea    -0x35(%r9),%r8d
 100d57b:	cmp    $0xf,%r8d
 100d57f:	shrx   %r8d,%edi,%r11d
 100d584:	mov    $0x1,%r8d
 100d58a:	setb   %r10b
 100d58e:	test   %r11b,%r10b
 100d591:	jne    100d59e <check_program+0x367e>
 100d593:	xor    %r8d,%r8d
 100d596:	cmp    $0x44,%r9d
 100d59a:	sete   %r8b
 100d59e:	add    %r8d,0xa4(%r12)
 100d5a6:	cmpl   $0x0,0xc(%r13,%rdx,4)
 100d5ac:	je     100d4c0 <check_program+0x35a0>
 100d5b2:	mov    0x0(%rbp),%r8
 100d5b6:	mov    0xc(%r8,%rdx,4),%r9d
 100d5bb:	lea    -0x35(%r9),%r8d
 100d5bf:	cmp    $0xf,%r8d
 100d5c3:	shrx   %r8d,%edi,%r11d
 100d5c8:	mov    $0x1,%r8d
 100d5ce:	setb   %r10b
 100d5d2:	test   %r11b,%r10b
 100d5d5:	jne    100d4c3 <check_program+0x35a3>
 100d5db:	xor    %r8d,%r8d
 100d5de:	cmp    $0x44,%r9d
 100d5e2:	sete   %r8b
 100d5e6:	jmp    100d4c3 <check_program+0x35a3>
 100d5eb:	test   %rcx,%rcx
 100d5ee:	je     100d648 <check_program+0x3728>
 100d5f0:	mov    $0x6783,%esi
 100d5f5:	jmp    100d612 <check_program+0x36f2>
 100d5f7:	nopw   0x0(%rax,%rax,1)
 100d600:	xor    %edi,%edi
 100d602:	add    %edi,0xa4(%r12)
 100d60a:	inc    %rdx
 100d60d:	dec    %rcx
 100d610:	je     100d648 <check_program+0x3728>
 100d612:	cmpl   $0x0,0x0(%r13,%rdx,4)
 100d618:	je     100d600 <check_program+0x36e0>
 100d61a:	mov    0x0(%rbp),%rdi
 100d61e:	mov    (%rdi,%rdx,4),%r8d
 100d622:	lea    -0x35(%r8),%edi
 100d626:	cmp    $0xf,%edi
 100d629:	shrx   %edi,%esi,%r10d
 100d62e:	mov    $0x1,%edi
 100d633:	setb   %r9b
 100d637:	test   %r10b,%r9b
 100d63a:	jne    100d602 <check_program+0x36e2>
 100d63c:	xor    %edi,%edi
 100d63e:	cmp    $0x44,%r8d
 100d642:	sete   %dil
 100d646:	jmp    100d602 <check_program+0x36e2>
 100d648:	test   %eax,%eax
 100d64a:	je     100d7a6 <check_program+0x3886>
 100d650:	movq   $0x0,0x60(%r12)
 100d659:	movq   $0x0,0x38(%r12)
 100d662:	mov    0xbc(%r12),%edx
 100d66a:	mov    0xb4(%r12),%ecx
 100d672:	mov    $0x3,%eax
 100d677:	test   %edx,%edx
 100d679:	cmovne %edx,%eax
 100d67c:	cmp    $0x1,%eax
 100d67f:	jne    100d6f6 <check_program+0x37d6>
 100d681:	mov    0x38(%rsp),%rdx
 100d686:	cmp    0x30(%rdx),%ecx
 100d689:	jae    100d6f6 <check_program+0x37d6>
 100d68b:	mov    0x50(%rdx),%rdi
 100d68f:	movzbl (%rdi,%rcx,1),%esi
 100d693:	cmp    $0x53,%esi
 100d696:	je     100d69d <check_program+0x377d>
 100d698:	cmp    $0x49,%esi
 100d69b:	jne    100d6f6 <check_program+0x37d6>
 100d69d:	test   %ecx,%ecx
 100d69f:	je     100d85d <check_program+0x393d>
 100d6a5:	mov    0x38(%rsp),%rdx
 100d6aa:	mov    0x60(%rdx),%rdx
 100d6ae:	cmp    $0x49,%esi
 100d6b1:	je     100e3c9 <check_program+0x44a9>
 100d6b7:	cmp    $0x53,%esi
 100d6ba:	jne    100d6f6 <check_program+0x37d6>
 100d6bc:	xor    %r8d,%r8d
 100d6bf:	nop
 100d6c0:	mov    %ecx,%esi
 100d6c2:	cmp    %ecx,(%rdx,%r8,4)
 100d6c6:	jne    100d6e8 <check_program+0x37c8>
 100d6c8:	cmpb   $0x3a,(%rdi,%r8,1)
 100d6cd:	mov    %ecx,%esi
 100d6cf:	jne    100d6e8 <check_program+0x37c8>
 100d6d1:	mov    0x38(%rsp),%rsi
 100d6d6:	mov    0x10(%rsi),%r9
 100d6da:	xor    %esi,%esi
 100d6dc:	cmpb   $0x4b,(%r9,%r8,1)
 100d6e1:	setne  %sil
 100d6e5:	add    %r8d,%esi
 100d6e8:	inc    %r8
 100d6eb:	cmp    %rcx,%r8
 100d6ee:	jae    100d6f8 <check_program+0x37d8>
 100d6f0:	cmp    %ecx,%esi
 100d6f2:	je     100d6c0 <check_program+0x37a0>
 100d6f4:	jmp    100d6f8 <check_program+0x37d8>
 100d6f6:	mov    %ecx,%esi
 100d6f8:	mov    0x40(%rsp),%rdx
 100d6fd:	mov    0x178(%rsp),%rdi
 100d705:	cmp    0x8(%rdx),%rdi
 100d709:	ja     100fb4b <check_program+0x5c2b>
 100d70f:	mov    0xb8(%r12),%ecx
 100d717:	mov    %rdi,0x8(%rdx)
 100d71b:	vxorpd %xmm0,%xmm0,%xmm0
 100d71f:	vmovupd %zmm0,0x74(%r12)
 100d72a:	vmovupd %zmm0,0x40(%r12)
 100d732:	vmovupd %zmm0,(%r12)
 100d739:	mov    %esi,0xb4(%r12)
 100d741:	vxorpd %xmm0,%xmm0,%xmm0
 100d745:	mov    %ecx,0xb8(%r12)
 100d74d:	mov    %eax,0xbc(%r12)
 100d755:	vmovupd %xmm0,(%r14)
 100d75a:	xor    %eax,%eax
 100d75c:	mov    0x328(%rsp),%rcx
 100d764:	mov    0x170(%rsp),%rdx
 100d76c:	cmp    0x8(%rcx),%rdx
 100d770:	ja     100fb4b <check_program+0x5c2b>
 100d776:	mov    %rdx,0x8(%rcx)
 100d77a:	mov    %fs:0x28,%rcx
 100d783:	cmp    0x2c0(%rsp),%rcx
 100d78b:	jne    101053b <check_program+0x661b>
 100d791:	add    $0x2c8,%rsp
 100d798:	pop    %rbx
 100d799:	pop    %r12
 100d79b:	pop    %r13
 100d79d:	pop    %r14
 100d79f:	pop    %r15
 100d7a1:	pop    %rbp
 100d7a2:	vzeroupper
 100d7a5:	ret
 100d7a6:	mov    0xa4(%r12),%ecx
 100d7ae:	test   %rcx,%rcx
 100d7b1:	je     100d7fe <check_program+0x38de>
 100d7b3:	mov    0x40(%rsp),%r8
 100d7b8:	mov    (%r8),%rsi
 100d7bb:	mov    0x8(%r8),%rdx
 100d7bf:	lea    0x3(%rdx,%rsi,1),%rax
 100d7c4:	add    %rsi,%rdx
 100d7c7:	and    $0xfffffffffffffffc,%rax
 100d7cb:	cmp    %rdx,%rax
 100d7ce:	jb     100d7f5 <check_program+0x38d5>
 100d7d0:	mov    %rax,%rdx
 100d7d3:	sub    %rsi,%rdx
 100d7d6:	mov    0x10(%r8),%rsi
 100d7da:	shl    $0x2,%rcx
 100d7de:	sub    %rdx,%rsi
 100d7e1:	setb   %dil
 100d7e5:	cmp    %rsi,%rcx
 100d7e8:	seta   %sil
 100d7ec:	or     %dil,%sil
 100d7ef:	je     100e3fe <check_program+0x44de>
 100d7f5:	xor    %ecx,%ecx
 100d7f7:	xor    %eax,%eax
 100d7f9:	jmp    100e411 <check_program+0x44f1>
 100d7fe:	xor    %eax,%eax
 100d800:	mov    $0x1,%cl
 100d802:	jmp    100e411 <check_program+0x44f1>
 100d807:	mov    %r15,%rdi
 100d80a:	sub    %rcx,%rdi
 100d80d:	mov    %rbx,%rax
 100d810:	mov    %r10,%r11
 100d813:	mov    0x328(%rsp),%r10
 100d81b:	xor    %r13d,%r13d
 100d81e:	mov    0x10(%r10),%r10
 100d822:	sub    %rdi,%r10
 100d825:	jb     100d858 <check_program+0x3938>
 100d827:	cmp    %r10,%rsi
 100d82a:	ja     100d858 <check_program+0x3938>
 100d82c:	mov    0x328(%rsp),%r10
 100d834:	add    %rsi,%rdi
 100d837:	lea    0x3(%rcx,%rdi,1),%r14
 100d83c:	lea    (%rdi,%rcx,1),%rdx
 100d840:	and    $0xfffffffffffffffc,%r14
 100d844:	mov    %rdi,0x8(%r10)
 100d848:	cmp    %rdx,%r14
 100d84b:	jae    100d864 <check_program+0x3944>
 100d84d:	xor    %r14d,%r14d
 100d850:	mov    %rax,%rbx
 100d853:	jmp    100a0fd <check_program+0x1dd>
 100d858:	mov    %r15,%r14
 100d85b:	jmp    100d870 <check_program+0x3950>
 100d85d:	xor    %esi,%esi
 100d85f:	jmp    100d6f8 <check_program+0x37d8>
 100d864:	mov    %rdi,%r11
 100d867:	mov    %r14,%rdi
 100d86a:	sub    %rcx,%rdi
 100d86d:	mov    %r15,%r13
 100d870:	mov    0x328(%rsp),%r10
 100d878:	movq   $0x0,0x30(%rsp)
 100d881:	mov    0x10(%r10),%r10
 100d885:	sub    %rdi,%r10
 100d888:	jb     100d8bf <check_program+0x399f>
 100d88a:	cmp    %r10,%rsi
 100d88d:	ja     100d8bf <check_program+0x399f>
 100d88f:	mov    0x328(%rsp),%r10
 100d897:	add    %rsi,%rdi
 100d89a:	lea    0x3(%rcx,%rdi,1),%r9
 100d89f:	lea    (%rdi,%rcx,1),%rdx
 100d8a3:	and    $0xfffffffffffffffc,%r9
 100d8a7:	mov    %rdi,0x8(%r10)
 100d8ab:	cmp    %rdx,%r9
 100d8ae:	jae    100e34d <check_program+0x442d>
 100d8b4:	mov    %rax,%rbx
 100d8b7:	mov    %r13,%r15
 100d8ba:	jmp    100a0fd <check_program+0x1dd>
 100d8bf:	mov    %r14,%r9
 100d8c2:	jmp    100e35b <check_program+0x443b>
 100d8c7:	xor    %r15d,%r15d
 100d8ca:	jmp    100dc84 <check_program+0x3d64>
 100d8cf:	mov    %r9d,%edi
 100d8d2:	and    $0xfffffff8,%edi
 100d8d5:	xor    %esi,%esi
 100d8d7:	xor    %eax,%eax
 100d8d9:	jmp    100d922 <check_program+0x3a02>
 100d8db:	nopl   0x0(%rax,%rax,1)
 100d8e0:	xor    %ebp,%ebp
 100d8e2:	cmpb   $0x0,0x7(%rdi,%rsi,1)
 100d8e7:	sete   %bpl
 100d8eb:	mov    %r12,%rdi
 100d8ee:	mov    0x150(%rsp),%r12
 100d8f6:	add    %eax,%r8d
 100d8f9:	add    $0x8,%rsi
 100d8fd:	add    %r8d,%r10d
 100d900:	add    %r10d,%r9d
 100d903:	add    %r9d,%r14d
 100d906:	add    %r14d,%r11d
 100d909:	add    %r11d,%r13d
 100d90c:	add    %r13d,%r15d
 100d90f:	mov    %r15d,%eax
 100d912:	add    %ebp,%eax
 100d914:	mov    0x20(%rsp),%rbp
 100d919:	cmp    %rsi,%rdi
 100d91c:	je     100dbd1 <check_program+0x3cb1>
 100d922:	cmpb   $0x53,(%rcx,%rsi,1)
 100d926:	mov    $0x0,%r8d
 100d92c:	jne    100da30 <check_program+0x3b10>
 100d932:	mov    0x1f0(%rbx),%r9
 100d939:	test   %r9,%r9
 100d93c:	je     100db1a <check_program+0x3bfa>
 100d942:	xor    %r8d,%r8d
 100d945:	cmpb   $0x0,(%r9,%rsi,1)
 100d94a:	sete   %r8b
 100d94e:	xor    %r9d,%r9d
 100d951:	cmpb   $0x53,0x1(%rcx,%rsi,1)
 100d956:	mov    $0x0,%r10d
 100d95c:	je     100da44 <check_program+0x3b24>
 100d962:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100d970:	cmpb   $0x53,0x2(%rcx,%rsi,1)
 100d975:	jne    100da70 <check_program+0x3b50>
 100d97b:	mov    0x1f0(%rbx),%r11
 100d982:	test   %r11,%r11
 100d985:	je     100db39 <check_program+0x3c19>
 100d98b:	xor    %r9d,%r9d
 100d98e:	cmpb   $0x0,0x2(%r11,%rsi,1)
 100d994:	sete   %r9b
 100d998:	xor    %r11d,%r11d
 100d99b:	cmpb   $0x53,0x3(%rcx,%rsi,1)
 100d9a0:	mov    $0x0,%r14d
 100d9a6:	je     100da84 <check_program+0x3b64>
 100d9ac:	nopl   0x0(%rax)
 100d9b0:	cmpb   $0x53,0x4(%rcx,%rsi,1)
 100d9b5:	jne    100dab0 <check_program+0x3b90>
 100d9bb:	mov    0x1f0(%rbx),%r15
 100d9c2:	test   %r15,%r15
 100d9c5:	je     100db58 <check_program+0x3c38>
 100d9cb:	xor    %r11d,%r11d
 100d9ce:	cmpb   $0x0,0x4(%r15,%rsi,1)
 100d9d4:	sete   %r11b
 100d9d8:	xor    %r15d,%r15d
 100d9db:	cmpb   $0x53,0x5(%rcx,%rsi,1)
 100d9e0:	mov    $0x0,%r13d
 100d9e6:	je     100dac4 <check_program+0x3ba4>
 100d9ec:	nopl   0x0(%rax)
 100d9f0:	cmpb   $0x53,0x6(%rcx,%rsi,1)
 100d9f5:	jne    100daf0 <check_program+0x3bd0>
 100d9fb:	mov    0x1f0(%rbx),%rbp
 100da02:	test   %rbp,%rbp
 100da05:	je     100db77 <check_program+0x3c57>
 100da0b:	xor    %r15d,%r15d
 100da0e:	cmpb   $0x0,0x6(%rbp,%rsi,1)
 100da13:	sete   %r15b
 100da17:	xor    %ebp,%ebp
 100da19:	cmpb   $0x53,0x7(%rcx,%rsi,1)
 100da1e:	jne    100d8f6 <check_program+0x39d6>
 100da24:	jmp    100dafd <check_program+0x3bdd>
 100da29:	nopl   0x0(%rax)
 100da30:	xor    %r9d,%r9d
 100da33:	cmpb   $0x53,0x1(%rcx,%rsi,1)
 100da38:	mov    $0x0,%r10d
 100da3e:	jne    100d970 <check_program+0x3a50>
 100da44:	mov    0x1f0(%rbx),%r11
 100da4b:	test   %r11,%r11
 100da4e:	je     100db8f <check_program+0x3c6f>
 100da54:	xor    %r10d,%r10d
 100da57:	cmpb   $0x0,0x1(%r11,%rsi,1)
 100da5d:	sete   %r10b
 100da61:	cmpb   $0x53,0x2(%rcx,%rsi,1)
 100da66:	je     100d97b <check_program+0x3a5b>
 100da6c:	nopl   0x0(%rax)
 100da70:	xor    %r11d,%r11d
 100da73:	cmpb   $0x53,0x3(%rcx,%rsi,1)
 100da78:	mov    $0x0,%r14d
 100da7e:	jne    100d9b0 <check_program+0x3a90>
 100da84:	mov    0x1f0(%rbx),%r15
 100da8b:	test   %r15,%r15
 100da8e:	je     100dba5 <check_program+0x3c85>
 100da94:	xor    %r14d,%r14d
 100da97:	cmpb   $0x0,0x3(%r15,%rsi,1)
 100da9d:	sete   %r14b
 100daa1:	cmpb   $0x53,0x4(%rcx,%rsi,1)
 100daa6:	je     100d9bb <check_program+0x3a9b>
 100daac:	nopl   0x0(%rax)
 100dab0:	xor    %r15d,%r15d
 100dab3:	cmpb   $0x53,0x5(%rcx,%rsi,1)
 100dab8:	mov    $0x0,%r13d
 100dabe:	jne    100d9f0 <check_program+0x3ad0>
 100dac4:	mov    0x1f0(%rbx),%rbp
 100dacb:	test   %rbp,%rbp
 100dace:	je     100dbbb <check_program+0x3c9b>
 100dad4:	xor    %r13d,%r13d
 100dad7:	cmpb   $0x0,0x5(%rbp,%rsi,1)
 100dadc:	sete   %r13b
 100dae0:	cmpb   $0x53,0x6(%rcx,%rsi,1)
 100dae5:	je     100d9fb <check_program+0x3adb>
 100daeb:	nopl   0x0(%rax,%rax,1)
 100daf0:	xor    %ebp,%ebp
 100daf2:	cmpb   $0x53,0x7(%rcx,%rsi,1)
 100daf7:	jne    100d8f6 <check_program+0x39d6>
 100dafd:	mov    %rdi,%r12
 100db00:	mov    0x1f0(%rbx),%rdi
 100db07:	test   %rdi,%rdi
 100db0a:	jne    100d8e0 <check_program+0x39c0>
 100db10:	mov    $0x1,%ebp
 100db15:	jmp    100d8eb <check_program+0x39cb>
 100db1a:	mov    $0x1,%r8d
 100db20:	xor    %r9d,%r9d
 100db23:	cmpb   $0x53,0x1(%rcx,%rsi,1)
 100db28:	mov    $0x0,%r10d
 100db2e:	jne    100d970 <check_program+0x3a50>
 100db34:	jmp    100da44 <check_program+0x3b24>
 100db39:	mov    $0x1,%r9d
 100db3f:	xor    %r11d,%r11d
 100db42:	cmpb   $0x53,0x3(%rcx,%rsi,1)
 100db47:	mov    $0x0,%r14d
 100db4d:	jne    100d9b0 <check_program+0x3a90>
 100db53:	jmp    100da84 <check_program+0x3b64>
 100db58:	mov    $0x1,%r11d
 100db5e:	xor    %r15d,%r15d
 100db61:	cmpb   $0x53,0x5(%rcx,%rsi,1)
 100db66:	mov    $0x0,%r13d
 100db6c:	jne    100d9f0 <check_program+0x3ad0>
 100db72:	jmp    100dac4 <check_program+0x3ba4>
 100db77:	mov    $0x1,%r15d
 100db7d:	xor    %ebp,%ebp
 100db7f:	cmpb   $0x53,0x7(%rcx,%rsi,1)
 100db84:	jne    100d8f6 <check_program+0x39d6>
 100db8a:	jmp    100dafd <check_program+0x3bdd>
 100db8f:	mov    $0x1,%r10d
 100db95:	cmpb   $0x53,0x2(%rcx,%rsi,1)
 100db9a:	jne    100da70 <check_program+0x3b50>
 100dba0:	jmp    100d97b <check_program+0x3a5b>
 100dba5:	mov    $0x1,%r14d
 100dbab:	cmpb   $0x53,0x4(%rcx,%rsi,1)
 100dbb0:	jne    100dab0 <check_program+0x3b90>
 100dbb6:	jmp    100d9bb <check_program+0x3a9b>
 100dbbb:	mov    $0x1,%r13d
 100dbc1:	cmpb   $0x53,0x6(%rcx,%rsi,1)
 100dbc6:	jne    100daf0 <check_program+0x3bd0>
 100dbcc:	jmp    100d9fb <check_program+0x3adb>
 100dbd1:	mov    0x50(%rsp),%r9
 100dbd6:	test   %rdx,%rdx
 100dbd9:	jne    100dc69 <check_program+0x3d49>
 100dbdf:	mov    %r9,%r15
 100dbe2:	test   %eax,%eax
 100dbe4:	je     100dc84 <check_program+0x3d64>
 100dbea:	mov    0x40(%rsp),%rcx
 100dbef:	mov    (%rcx),%rsi
 100dbf2:	mov    0x8(%rcx),%rdx
 100dbf6:	lea    0xf(%rdx,%rsi,1),%rcx
 100dbfb:	add    %rsi,%rdx
 100dbfe:	and    $0xfffffffffffffff0,%rcx
 100dc02:	cmp    %rdx,%rcx
 100dc05:	jae    100e763 <check_program+0x4843>
 100dc0b:	mov    0x8(%rsp),%rax
 100dc10:	movq   $0x0,0x48(%rax)
 100dc18:	mov    0x8(%rsp),%rax
 100dc1d:	mov    %r9,%r15
 100dc20:	cmpl   $0x0,0xbc(%rax)
 100dc27:	jne    100dc91 <check_program+0x3d71>
 100dc29:	mov    0x8(%rsp),%rax
 100dc2e:	mov    %r9,%r15
 100dc31:	movl   $0x3,0xbc(%rax)
 100dc3b:	movq   $0x0,0xb4(%rax)
 100dc46:	jmp    100dc91 <check_program+0x3d71>
 100dc48:	nopl   0x0(%rax,%rax,1)
 100dc50:	xor    %edi,%edi
 100dc52:	cmpb   $0x0,(%r8,%rsi,1)
 100dc57:	sete   %dil
 100dc5b:	add    %edi,%eax
 100dc5d:	inc    %rsi
 100dc60:	dec    %rdx
 100dc63:	je     100dbdf <check_program+0x3cbf>
 100dc69:	xor    %edi,%edi
 100dc6b:	cmpb   $0x53,(%rcx,%rsi,1)
 100dc6f:	jne    100dc5b <check_program+0x3d3b>
 100dc71:	mov    0x1f0(%rbx),%r8
 100dc78:	test   %r8,%r8
 100dc7b:	jne    100dc50 <check_program+0x3d30>
 100dc7d:	mov    $0x1,%edi
 100dc82:	jmp    100dc5b <check_program+0x3d3b>
 100dc84:	mov    0x8(%rsp),%rax
 100dc89:	movq   $0x0,0x48(%rax)
 100dc91:	mov    0x100(%rsp),%rdi
 100dc99:	lea    0x4(,%r15,4),%r13
 100dca1:	mov    $0xff,%esi
 100dca6:	mov    %r13,%rdx
 100dca9:	vzeroupper
 100dcac:	call   788430 <memset@plt>
 100dcb1:	mov    0xf8(%rsp),%rdi
 100dcb9:	mov    $0xff,%esi
 100dcbe:	mov    %r13,%rdx
 100dcc1:	call   788430 <memset@plt>
 100dcc6:	mov    0x50(%rsp),%r9
 100dccb:	test   %r9,%r9
 100dcce:	je     100e11a <check_program+0x41fa>
 100dcd4:	lea    -0xb6506b(%rip),%r11        # 4a8c70 <type_integer_info>
 100dcdb:	xor    %r14d,%r14d
 100dcde:	vxorpd %xmm0,%xmm0,%xmm0
 100dce2:	jmp    100dd1c <check_program+0x3dfc>
 100dce4:	mov    0x8(%rsp),%rax
 100dce9:	movl   $0x1,0xbc(%rax)
 100dcf3:	mov    %r13d,0xb4(%rax)
 100dcfa:	mov    %r13d,0xb8(%rax)
 100dd01:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100dd10:	inc    %r14
 100dd13:	cmp    %r14,%r15
 100dd16:	je     100e11a <check_program+0x41fa>
 100dd1c:	mov    0x8(%rsp),%rax
 100dd21:	mov    0xbc(%rax),%eax
 100dd27:	cmp    $0x3,%eax
 100dd2a:	je     100e144 <check_program+0x4224>
 100dd30:	mov    0x1f0(%rbx),%rcx
 100dd37:	test   %rcx,%rcx
 100dd3a:	je     100dd43 <check_program+0x3e23>
 100dd3c:	cmpb   $0x0,(%rcx,%r14,1)
 100dd41:	jne    100dd10 <check_program+0x3df0>
 100dd43:	mov    0x38(%rsp),%rsi
 100dd48:	mov    0x10(%rsi),%rdx
 100dd4c:	mov    0x50(%rsi),%rcx
 100dd50:	cmpb   $0x49,(%rdx,%r14,1)
 100dd55:	jne    100de80 <check_program+0x3f60>
 100dd5b:	mov    0x60(%rsi),%rdx
 100dd5f:	mov    (%rdx,%r14,4),%edx
 100dd63:	cmp    %r9d,%edx
 100dd66:	jae    100de80 <check_program+0x3f60>
 100dd6c:	cmpb   $0x49,(%rcx,%rdx,1)
 100dd70:	jne    100de80 <check_program+0x3f60>
 100dd76:	mov    0x8(%rsp),%r8
 100dd7b:	mov    0x2c0(%rbx),%rsi
 100dd82:	mov    (%rsi,%rdx,4),%edi
 100dd85:	mov    0x8(%r8),%r8
 100dd89:	cmp    0xa0(%r8),%edi
 100dd90:	jae    100de2f <check_program+0x3f0f>
 100dd96:	mov    0x8(%rsp),%rsi
 100dd9b:	mov    0x8(%r8),%r8
 100dd9f:	lea    (%rdi,%rdi,2),%rdi
 100dda3:	shl    $0x5,%rdi
 100dda7:	mov    0x10(%rsi),%rsi
 100ddab:	mov    (%r8,%rdi,1),%edi
 100ddaf:	mov    (%rsi),%r8
 100ddb2:	mov    %edi,%r9d
 100ddb5:	shr    $0x3,%r9d
 100ddb9:	movzbl (%r8,%r9,1),%r10d
 100ddbe:	cmp    $0xf,%r10b
 100ddc2:	jne    100ddd8 <check_program+0x3eb8>
 100ddc4:	mov    0x20(%rsi),%rdi
 100ddc8:	mov    (%rdi,%r9,4),%edi
 100ddcc:	mov    %edi,%r9d
 100ddcf:	shr    $0x3,%r9d
 100ddd3:	movzbl (%r8,%r9,1),%r10d
 100ddd8:	cmp    $0x12,%r10b
 100dddc:	jne    100ddf1 <check_program+0x3ed1>
 100ddde:	mov    0x10(%rsi),%r10
 100dde2:	testb  $0x4,(%r10,%r9,1)
 100dde7:	je     100ddf1 <check_program+0x3ed1>
 100dde9:	mov    0x20(%rsi),%rdi
 100dded:	mov    (%rdi,%r9,4),%edi
 100ddf1:	shr    $0x3,%edi
 100ddf4:	movzbl (%r8,%rdi,1),%r8d
 100ddf9:	cmp    $0x2,%r8d
 100ddfd:	je     100de14 <check_program+0x3ef4>
 100ddff:	mov    0x50(%rsp),%r9
 100de04:	cmp    $0x5,%r8d
 100de08:	jne    100de2f <check_program+0x3f0f>
 100de0a:	mov    0x30(%rsi),%rsi
 100de0e:	mov    (%rsi,%rdi,8),%rsi
 100de12:	jmp    100de23 <check_program+0x3f03>
 100de14:	lea    (%rdi,%rdi,2),%rsi
 100de18:	mov    0x50(%rsp),%r9
 100de1d:	movzbl 0x2(%r11,%rsi,2),%esi
 100de23:	dec    %rsi
 100de26:	cmp    $0x80,%rsi
 100de2d:	jb     100de80 <check_program+0x3f60>
 100de2f:	test   %eax,%eax
 100de31:	je     100de4a <check_program+0x3f2a>
 100de33:	cmp    $0x1,%eax
 100de36:	jne    100de80 <check_program+0x3f60>
 100de38:	mov    0x8(%rsp),%rsi
 100de3d:	mov    $0x1,%eax
 100de42:	cmp    0xb8(%rsi),%edx
 100de48:	ja     100de80 <check_program+0x3f60>
 100de4a:	mov    0x8(%rsp),%rax
 100de4f:	movl   $0x1,0xbc(%rax)
 100de59:	mov    %edx,0xb4(%rax)
 100de5f:	mov    %edx,0xb8(%rax)
 100de65:	mov    0x38(%rsp),%rax
 100de6a:	mov    0x50(%rax),%rcx
 100de6e:	mov    $0x1,%eax
 100de73:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100de80:	cmpb   $0x53,(%rcx,%r14,1)
 100de85:	jne    100dd10 <check_program+0x3df0>
 100de8b:	mov    0x2f8(%rbx),%rcx
 100de92:	mov    (%rcx,%r14,4),%r13d
 100de96:	cmp    %r9d,%r13d
 100de99:	jae    100defb <check_program+0x3fdb>
 100de9b:	mov    0x2c0(%rbx),%rsi
 100dea2:	mov    0x8(%rsp),%rcx
 100dea7:	mov    (%rsi,%r13,4),%edx
 100deab:	mov    0x8(%rcx),%rdi
 100deaf:	cmp    0xa0(%rdi),%edx
 100deb5:	jae    100defe <check_program+0x3fde>
 100deb7:	mov    0x8(%rdi),%rdi
 100debb:	mov    0x10(%rcx),%rcx
 100debf:	lea    (%rdx,%rdx,2),%rdx
 100dec3:	shl    $0x5,%rdx
 100dec7:	mov    (%rdi,%rdx,1),%edx
 100deca:	mov    (%rcx),%rdi
 100decd:	mov    %edx,%r9d
 100ded0:	shr    $0x3,%r9d
 100ded4:	movzbl (%rdi,%r9,1),%r10d
 100ded9:	cmp    $0xf,%r10b
 100dedd:	jne    100df26 <check_program+0x4006>
 100dedf:	mov    0x20(%rcx),%r8
 100dee3:	mov    (%r8,%r9,4),%r8d
 100dee7:	mov    %r8d,%r9d
 100deea:	shr    $0x3,%r9d
 100deee:	movzbl (%rdi,%r9,1),%r10d
 100def3:	cmp    $0x12,%r10b
 100def7:	je     100df2f <check_program+0x400f>
 100def9:	jmp    100df42 <check_program+0x4022>
 100defb:	mov    %r14d,%r13d
 100defe:	test   %eax,%eax
 100df00:	je     100dce4 <check_program+0x3dc4>
 100df06:	cmp    $0x1,%eax
 100df09:	jne    100dd10 <check_program+0x3df0>
 100df0f:	mov    0x8(%rsp),%rax
 100df14:	cmp    0xb8(%rax),%r13d
 100df1b:	jbe    100dce4 <check_program+0x3dc4>
 100df21:	jmp    100dd10 <check_program+0x3df0>
 100df26:	mov    %edx,%r8d
 100df29:	cmp    $0x12,%r10b
 100df2d:	jne    100df42 <check_program+0x4022>
 100df2f:	mov    0x10(%rcx),%r10
 100df33:	testb  $0x4,(%r10,%r9,1)
 100df38:	je     100df42 <check_program+0x4022>
 100df3a:	mov    0x20(%rcx),%r8
 100df3e:	mov    (%r8,%r9,4),%r8d
 100df42:	shr    $0x3,%r8d
 100df46:	mov    (%rsi,%r14,4),%esi
 100df4a:	movzbl (%rdi,%r8,1),%edi
 100df4f:	cmp    $0x2,%edi
 100df52:	je     100df68 <check_program+0x4048>
 100df54:	mov    0x50(%rsp),%r9
 100df59:	cmp    $0x5,%edi
 100df5c:	jne    100defe <check_program+0x3fde>
 100df5e:	mov    0x30(%rcx),%rcx
 100df62:	mov    (%rcx,%r8,8),%rcx
 100df66:	jmp    100df77 <check_program+0x4057>
 100df68:	lea    (%r8,%r8,2),%rcx
 100df6c:	mov    0x50(%rsp),%r9
 100df71:	movzbl 0x2(%r11,%rcx,2),%ecx
 100df77:	dec    %rcx
 100df7a:	cmp    $0x80,%rcx
 100df81:	jae    100defe <check_program+0x3fde>
 100df87:	mov    0x8(%rsp),%rdi
 100df8c:	mov    0x310(%rbx),%rax
 100df93:	mov    %r15,0x68(%rsp)
 100df98:	mov    0x98(%rdi),%r15d
 100df9f:	mov    0x48(%rdi),%rbp
 100dfa3:	mov    (%rax,%r14,4),%eax
 100dfa7:	mov    %r15,0x118(%rsp)
 100dfaf:	shl    $0x6,%r15
 100dfb3:	cmp    $0xffffffff,%esi
 100dfb6:	sete   0x30(%rbp,%r15,1)
 100dfbc:	cmp    $0xffffffff,%eax
 100dfbf:	vmovupd %ymm0,0x0(%rbp,%r15,1)
 100dfc6:	mov    %edx,0x20(%rbp,%r15,1)
 100dfcb:	mov    %r14d,0x24(%rbp,%r15,1)
 100dfd0:	mov    %r13d,0x28(%rbp,%r15,1)
 100dfd5:	movl   $0xffffffff,0x2c(%rbp,%r15,1)
 100dfde:	setne  0x31(%rbp,%r15,1)
 100dfe4:	movq   $0x0,0x32(%rbp,%r15,1)
 100dfed:	movq   $0x0,0x38(%rbp,%r15,1)
 100dff6:	mov    0x310(%rbx),%rax
 100dffd:	mov    (%rax,%r14,4),%eax
 100e001:	cmp    $0xffffffff,%eax
 100e004:	cmove  %esi,%eax
 100e007:	cmp    $0xffffffff,%esi
 100e00a:	je     100e083 <check_program+0x4163>
 100e00c:	mov    0x8(%rsp),%rdi
 100e011:	lea    0x0(%rbp,%r15,1),%rcx
 100e016:	mov    %eax,0x110(%rsp)
 100e01d:	mov    %rcx,0x180(%rsp)
 100e025:	vzeroupper
 100e028:	call   1105970 <check_program_case_value>
 100e02d:	mov    0x8(%rsp),%rdi
 100e032:	mov    0x50(%rsp),%r9
 100e037:	mov    0x110(%rsp),%esi
 100e03e:	lea    -0xb653d5(%rip),%r11        # 4a8c70 <type_integer_info>
 100e045:	vxorpd %xmm0,%xmm0,%xmm0
 100e049:	test   %al,%al
 100e04b:	je     100e0c7 <check_program+0x41a7>
 100e04d:	mov    0x180(%rsp),%rax
 100e055:	mov    0x8(%rsp),%rdi
 100e05a:	lea    0x10(%rbp,%r15,1),%rcx
 100e05f:	mov    0x20(%rax),%edx
 100e062:	vzeroupper
 100e065:	call   1105970 <check_program_case_value>
 100e06a:	mov    0x8(%rsp),%rdi
 100e06f:	mov    0x50(%rsp),%r9
 100e074:	lea    -0xb6540b(%rip),%r11        # 4a8c70 <type_integer_info>
 100e07b:	vxorpd %xmm0,%xmm0,%xmm0
 100e07f:	test   %al,%al
 100e081:	je     100e0c7 <check_program+0x41a7>
 100e083:	mov    0xf8(%rsp),%rax
 100e08b:	mov    0x118(%rsp),%rsi
 100e093:	mov    0x100(%rsp),%rcx
 100e09b:	incl   0x98(%rdi)
 100e0a1:	mov    0x128(%rsp),%rdx
 100e0a9:	mov    0x20(%rsp),%rbp
 100e0ae:	mov    0x68(%rsp),%r15
 100e0b3:	mov    %esi,(%rax,%r14,4)
 100e0b7:	mov    (%rcx,%r13,4),%eax
 100e0bb:	mov    %eax,(%rdx,%rsi,4)
 100e0be:	mov    %esi,(%rcx,%r13,4)
 100e0c2:	jmp    100dd10 <check_program+0x3df0>
 100e0c7:	mov    0xbc(%rdi),%eax
 100e0cd:	mov    0x20(%rsp),%rbp
 100e0d2:	mov    0x68(%rsp),%r15
 100e0d7:	test   %eax,%eax
 100e0d9:	je     100e0f8 <check_program+0x41d8>
 100e0db:	cmp    $0x1,%eax
 100e0de:	jne    100dd10 <check_program+0x3df0>
 100e0e4:	mov    0x8(%rsp),%rax
 100e0e9:	mov    0xb8(%rax),%eax
 100e0ef:	cmp    %rax,%r14
 100e0f2:	ja     100dd10 <check_program+0x3df0>
 100e0f8:	mov    0x8(%rsp),%rax
 100e0fd:	movl   $0x1,0xbc(%rax)
 100e107:	mov    %r14d,0xb4(%rax)
 100e10e:	mov    %r14d,0xb8(%rax)
 100e115:	jmp    100dd10 <check_program+0x3df0>
 100e11a:	mov    0x8(%rsp),%rax
 100e11f:	cmpl   $0x3,0xbc(%rax)
 100e126:	je     100e144 <check_program+0x4224>
 100e128:	mov    0x8(%rsp),%rdi
 100e12d:	mov    0x38(%rsp),%rsi
 100e132:	mov    0x328(%rsp),%rcx
 100e13a:	xor    %edx,%edx
 100e13c:	vzeroupper
 100e13f:	call   1105ba0 <check_program_case_conflicts>
 100e144:	mov    0x10(%rsp),%eax
 100e148:	mov    0xe0(%rsp),%rdi
 100e150:	mov    $0xff,%esi
 100e155:	lea    0x4(,%rax,4),%r14
 100e15d:	lea    0x1(%rax),%rcx
 100e161:	mov    %rax,0x118(%rsp)
 100e169:	mov    %rcx,0x50(%rsp)
 100e16e:	mov    %r14,%rdx
 100e171:	vzeroupper
 100e174:	call   788430 <memset@plt>
 100e179:	mov    0x58(%rsp),%rdi
 100e17e:	mov    $0xff,%esi
 100e183:	mov    %r14,%rdx
 100e186:	call   788430 <memset@plt>
 100e18b:	mov    0xa0(%rsp),%rdi
 100e193:	mov    $0xff,%esi
 100e198:	mov    %r14,%rdx
 100e19b:	call   788430 <memset@plt>
 100e1a0:	mov    0x30(%rsp),%rdi
 100e1a5:	mov    $0xff,%esi
 100e1aa:	mov    %r14,%rdx
 100e1ad:	call   788430 <memset@plt>
 100e1b2:	mov    0x60(%rsp),%rdi
 100e1b7:	mov    $0xff,%esi
 100e1bc:	mov    %r14,%rdx
 100e1bf:	call   788430 <memset@plt>
 100e1c4:	mov    0x98(%rsp),%rax
 100e1cc:	mov    $0xff,%esi
 100e1d1:	mov    %r12,%rdi
 100e1d4:	lea    0x4(,%rax,4),%r13
 100e1dc:	mov    %r13,%rdx
 100e1df:	call   788430 <memset@plt>
 100e1e4:	mov    0x70(%rsp),%rdi
 100e1e9:	mov    $0xff,%esi
 100e1ee:	mov    %r14,%rdx
 100e1f1:	call   788430 <memset@plt>
 100e1f6:	mov    0x130(%rsp),%rdi
 100e1fe:	mov    $0xff,%esi
 100e203:	mov    %r14,%rdx
 100e206:	call   788430 <memset@plt>
 100e20b:	mov    0xf0(%rsp),%rdi
 100e213:	mov    $0xff,%esi
 100e218:	mov    %r14,%rdx
 100e21b:	call   788430 <memset@plt>
 100e220:	mov    0xd0(%rsp),%rdi
 100e228:	xor    %esi,%esi
 100e22a:	mov    %r14,%rdx
 100e22d:	call   788430 <memset@plt>
 100e232:	mov    0xc0(%rsp),%rdi
 100e23a:	xor    %esi,%esi
 100e23c:	mov    %r14,%rdx
 100e23f:	call   788430 <memset@plt>
 100e244:	mov    0x138(%rsp),%rbx
 100e24c:	mov    $0xff,%esi
 100e251:	mov    %r14,0x110(%rsp)
 100e259:	mov    %r14,%rdx
 100e25c:	mov    %rbx,%rdi
 100e25f:	call   788430 <memset@plt>
 100e264:	mov    0x348(%rbp),%eax
 100e26a:	mov    0x90(%rsp),%r15
 100e272:	mov    0xa8(%rsp),%r14
 100e27a:	test   %eax,%eax
 100e27c:	je     100e2c0 <check_program+0x43a0>
 100e27e:	mov    $0x44,%ecx
 100e283:	xor    %edx,%edx
 100e285:	jmp    100e29e <check_program+0x437e>
 100e287:	nopw   0x0(%rax,%rax,1)
 100e290:	inc    %rdx
 100e293:	add    $0x50,%rcx
 100e297:	mov    %eax,%esi
 100e299:	cmp    %rsi,%rdx
 100e29c:	jae    100e2c0 <check_program+0x43a0>
 100e29e:	mov    0x340(%rbp),%rsi
 100e2a5:	cmpl   $0xffffffff,(%rsi,%rcx,1)
 100e2a9:	je     100e290 <check_program+0x4370>
 100e2ab:	mov    -0x4(%rsi,%rcx,1),%esi
 100e2af:	cmp    0x10(%rsp),%esi
 100e2b3:	jae    100e290 <check_program+0x4370>
 100e2b5:	mov    %edx,(%rbx,%rsi,4)
 100e2b8:	mov    0x348(%rbp),%eax
 100e2be:	jmp    100e290 <check_program+0x4370>
 100e2c0:	mov    0x48(%rsp),%rdi
 100e2c5:	mov    0x50(%rsp),%rdx
 100e2ca:	xor    %esi,%esi
 100e2cc:	xor    %ebp,%ebp
 100e2ce:	call   788430 <memset@plt>
 100e2d3:	lea    0x300(%rsp),%rax
 100e2db:	test   %r14,%r14
 100e2de:	je     100eb1e <check_program+0x4bfe>
 100e2e4:	mov    0x20(%rsp),%rcx
 100e2e9:	mov    0xa8(%rsp),%rdi
 100e2f1:	mov    0x364(%rcx),%ebx
 100e2f7:	cmp    $0x40,%rbx
 100e2fb:	lea    0x1(%rbx),%rdx
 100e2ff:	setb   %r14b
 100e303:	or     0x24(%rax),%r14b
 100e307:	xor    %esi,%esi
 100e309:	call   788430 <memset@plt>
 100e30e:	mov    0x38(%rsp),%r10
 100e313:	test   %r14b,%r14b
 100e316:	mov    0xa8(%rsp),%r14
 100e31e:	jne    100eabc <check_program+0x4b9c>
 100e324:	lea    -0x40(%rbx),%ecx
 100e327:	xor    %esi,%esi
 100e329:	mov    %ecx,%edx
 100e32b:	shr    $0x6,%edx
 100e32e:	inc    %edx
 100e330:	mov    %edx,%eax
 100e332:	and    $0x3,%eax
 100e335:	cmp    $0xc0,%ecx
 100e33b:	jae    100e852 <check_program+0x4932>
 100e341:	mov    0x20(%rsp),%r11
 100e346:	xor    %ecx,%ecx
 100e348:	jmp    100ea36 <check_program+0x4b16>
 100e34d:	mov    %rdi,%r11
 100e350:	mov    %r9,%rdi
 100e353:	sub    %rcx,%rdi
 100e356:	mov    %r14,0x30(%rsp)
 100e35b:	mov    0x328(%rsp),%r10
 100e363:	mov    0x98(%rsp),%rdx
 100e36b:	mov    0x10(%r10),%r10
 100e36f:	sub    %rdi,%r10
 100e372:	jb     100e3b3 <check_program+0x4493>
 100e374:	cmp    %r10,%rsi
 100e377:	ja     100e3b3 <check_program+0x4493>
 100e379:	mov    0x328(%rsp),%r10
 100e381:	add    %rsi,%rdi
 100e384:	lea    0x3(%rcx,%rdi,1),%rbx
 100e389:	lea    (%rdi,%rcx,1),%r11
 100e38d:	and    $0xfffffffffffffffc,%rbx
 100e391:	mov    %rdi,0x8(%r10)
 100e395:	lea    0x4(,%rdx,4),%r10
 100e39d:	cmp    %r11,%rbx
 100e3a0:	jae    100e6f6 <check_program+0x47d6>
 100e3a6:	xor    %r12d,%r12d
 100e3a9:	mov    %r9,0x60(%rsp)
 100e3ae:	jmp    100a124 <check_program+0x204>
 100e3b3:	lea    0x4(,%rdx,4),%r10
 100e3bb:	movq   $0x0,0x60(%rsp)
 100e3c4:	jmp    100e707 <check_program+0x47e7>
 100e3c9:	xor    %edi,%edi
 100e3cb:	nopl   0x0(%rax,%rax,1)
 100e3d0:	mov    %ecx,%esi
 100e3d2:	cmp    %ecx,(%rdx,%rdi,4)
 100e3d5:	jne    100e3e9 <check_program+0x44c9>
 100e3d7:	mov    0x38(%rsp),%rsi
 100e3dc:	mov    0x10(%rsi),%rsi
 100e3e0:	cmpb   $0x49,(%rsi,%rdi,1)
 100e3e4:	mov    %ecx,%esi
 100e3e6:	cmove  %edi,%esi
 100e3e9:	inc    %rdi
 100e3ec:	cmp    %rcx,%rdi
 100e3ef:	jae    100d6f8 <check_program+0x37d8>
 100e3f5:	cmp    %ecx,%esi
 100e3f7:	je     100e3d0 <check_program+0x44b0>
 100e3f9:	jmp    100d6f8 <check_program+0x37d8>
 100e3fe:	add    %rcx,%rdx
 100e401:	mov    %rdx,0x8(%r8)
 100e405:	cmpl   $0x0,0xa4(%r12)
 100e40e:	sete   %cl
 100e411:	mov    0x98(%rsp),%r11
 100e419:	mov    %rax,0x60(%r12)
 100e41e:	test   %r11d,%r11d
 100e421:	setne  %dl
 100e424:	test   %rax,%rax
 100e427:	setne  %al
 100e42a:	or     %cl,%al
 100e42c:	and    %al,%dl
 100e42e:	cmp    $0x1,%dl
 100e431:	jne    100e5d5 <check_program+0x46b5>
 100e437:	mov    %r11d,%ecx
 100e43a:	and    $0x3,%ecx
 100e43d:	cmp    $0x4,%r11d
 100e441:	jae    100e44c <check_program+0x452c>
 100e443:	xor    %edx,%edx
 100e445:	xor    %esi,%esi
 100e447:	jmp    100e582 <check_program+0x4662>
 100e44c:	and    $0xfffffffc,%r11d
 100e450:	mov    $0xe003,%edi
 100e455:	xor    %edx,%edx
 100e457:	xor    %esi,%esi
 100e459:	jmp    100e47f <check_program+0x455f>
 100e45b:	nopl   0x0(%rax,%rax,1)
 100e460:	mov    0x60(%r12),%r8
 100e465:	mov    %esi,%r9d
 100e468:	inc    %esi
 100e46a:	lea    0x3(%rdx),%r10d
 100e46e:	mov    %r10d,(%r8,%r9,4)
 100e472:	add    $0x4,%rdx
 100e476:	cmp    %rdx,%r11
 100e479:	je     100e57d <check_program+0x465d>
 100e47f:	cmpl   $0x0,0x0(%r13,%rdx,4)
 100e485:	je     100e4ba <check_program+0x459a>
 100e487:	mov    0x0(%rbp),%r8
 100e48b:	mov    (%r8,%rdx,4),%r8d
 100e48f:	mov    %r8d,%r9d
 100e492:	and    $0xfffffffc,%r9d
 100e496:	cmp    $0x3c,%r9d
 100e49a:	je     100e4ac <check_program+0x458c>
 100e49c:	add    $0xffffffcb,%r8d
 100e4a0:	cmp    $0xf,%r8d
 100e4a4:	ja     100e4ba <check_program+0x459a>
 100e4a6:	bt     %r8d,%edi
 100e4aa:	jae    100e4ba <check_program+0x459a>
 100e4ac:	mov    0x60(%r12),%r8
 100e4b1:	mov    %esi,%r9d
 100e4b4:	inc    %esi
 100e4b6:	mov    %edx,(%r8,%r9,4)
 100e4ba:	cmpl   $0x0,0x4(%r13,%rdx,4)
 100e4c0:	je     100e4fa <check_program+0x45da>
 100e4c2:	mov    0x0(%rbp),%r8
 100e4c6:	mov    0x4(%r8,%rdx,4),%r8d
 100e4cb:	mov    %r8d,%r9d
 100e4ce:	and    $0xfffffffc,%r9d
 100e4d2:	cmp    $0x3c,%r9d
 100e4d6:	je     100e4e8 <check_program+0x45c8>
 100e4d8:	add    $0xffffffcb,%r8d
 100e4dc:	cmp    $0xf,%r8d
 100e4e0:	ja     100e4fa <check_program+0x45da>
 100e4e2:	bt     %r8d,%edi
 100e4e6:	jae    100e4fa <check_program+0x45da>
 100e4e8:	mov    0x60(%r12),%r8
 100e4ed:	mov    %esi,%r9d
 100e4f0:	inc    %esi
 100e4f2:	lea    0x1(%rdx),%r10d
 100e4f6:	mov    %r10d,(%r8,%r9,4)
 100e4fa:	cmpl   $0x0,0x8(%r13,%rdx,4)
 100e500:	je     100e53a <check_program+0x461a>
 100e502:	mov    0x0(%rbp),%r8
 100e506:	mov    0x8(%r8,%rdx,4),%r8d
 100e50b:	mov    %r8d,%r9d
 100e50e:	and    $0xfffffffc,%r9d
 100e512:	cmp    $0x3c,%r9d
 100e516:	je     100e528 <check_program+0x4608>
 100e518:	add    $0xffffffcb,%r8d
 100e51c:	cmp    $0xf,%r8d
 100e520:	ja     100e53a <check_program+0x461a>
 100e522:	bt     %r8d,%edi
 100e526:	jae    100e53a <check_program+0x461a>
 100e528:	mov    0x60(%r12),%r8
 100e52d:	mov    %esi,%r9d
 100e530:	inc    %esi
 100e532:	lea    0x2(%rdx),%r10d
 100e536:	mov    %r10d,(%r8,%r9,4)
 100e53a:	cmpl   $0x0,0xc(%r13,%rdx,4)
 100e540:	je     100e472 <check_program+0x4552>
 100e546:	mov    0x0(%rbp),%r8
 100e54a:	mov    0xc(%r8,%rdx,4),%r8d
 100e54f:	mov    %r8d,%r9d
 100e552:	and    $0xfffffffc,%r9d
 100e556:	cmp    $0x3c,%r9d
 100e55a:	je     100e460 <check_program+0x4540>
 100e560:	add    $0xffffffcb,%r8d
 100e564:	cmp    $0xf,%r8d
 100e568:	ja     100e472 <check_program+0x4552>
 100e56e:	bt     %r8d,%edi
 100e572:	jb     100e460 <check_program+0x4540>
 100e578:	jmp    100e472 <check_program+0x4552>
 100e57d:	test   %rcx,%rcx
 100e580:	je     100e5d5 <check_program+0x46b5>
 100e582:	mov    $0xe003,%edi
 100e587:	jmp    100e5a6 <check_program+0x4686>
 100e589:	nopl   0x0(%rax)
 100e590:	mov    0x60(%r12),%r8
 100e595:	mov    %esi,%r9d
 100e598:	inc    %esi
 100e59a:	mov    %edx,(%r8,%r9,4)
 100e59e:	inc    %rdx
 100e5a1:	dec    %rcx
 100e5a4:	je     100e5d5 <check_program+0x46b5>
 100e5a6:	cmpl   $0x0,0x0(%r13,%rdx,4)
 100e5ac:	je     100e59e <check_program+0x467e>
 100e5ae:	mov    0x0(%rbp),%r8
 100e5b2:	mov    (%r8,%rdx,4),%r8d
 100e5b6:	mov    %r8d,%r9d
 100e5b9:	and    $0xfffffffc,%r9d
 100e5bd:	cmp    $0x3c,%r9d
 100e5c1:	je     100e590 <check_program+0x4670>
 100e5c3:	add    $0xffffffcb,%r8d
 100e5c7:	cmp    $0xf,%r8d
 100e5cb:	ja     100e59e <check_program+0x467e>
 100e5cd:	bt     %r8d,%edi
 100e5d1:	jb     100e590 <check_program+0x4670>
 100e5d3:	jmp    100e59e <check_program+0x467e>
 100e5d5:	mov    0x298(%rsp),%edx
 100e5dc:	lea    0x38(%r12),%rcx
 100e5e1:	test   %rdx,%rdx
 100e5e4:	setne  %sil
 100e5e8:	test   %sil,%al
 100e5eb:	je     100e60e <check_program+0x46ee>
 100e5ed:	mov    0x40(%rsp),%rsi
 100e5f2:	mov    (%rsi),%r8
 100e5f5:	mov    0x8(%rsi),%rsi
 100e5f9:	lea    0x3(%rsi,%r8,1),%rdi
 100e5fe:	add    %r8,%rsi
 100e601:	and    $0xfffffffffffffffc,%rdi
 100e605:	cmp    %rsi,%rdi
 100e608:	jae    100e6b2 <check_program+0x4792>
 100e60e:	movq   $0x0,(%rcx)
 100e615:	test   $0x1,%al
 100e617:	je     100d662 <check_program+0x3742>
 100e61d:	xor    %edi,%edi
 100e61f:	test   %edx,%edx
 100e621:	je     100e62c <check_program+0x470c>
 100e623:	test   %rdi,%rdi
 100e626:	je     100d662 <check_program+0x3742>
 100e62c:	mov    0x78(%rsp),%eax
 100e630:	mov    %edx,0x90(%r12)
 100e638:	mov    %eax,0xa0(%r12)
 100e640:	test   %edx,%edx
 100e642:	je     100e658 <check_program+0x4738>
 100e644:	mov    0x108(%rsp),%rsi
 100e64c:	shl    $0x4,%rdx
 100e650:	vzeroupper
 100e653:	call   788550 <memcpy@plt>
 100e658:	mov    0x10(%rsp),%r13
 100e65d:	mov    0x78(%r12),%rdi
 100e662:	xor    %esi,%esi
 100e664:	mov    %r13d,%r15d
 100e667:	lea    0x4(,%r15,4),%rbx
 100e66f:	mov    %rbx,%rdx
 100e672:	vzeroupper
 100e675:	call   788430 <memset@plt>
 100e67a:	mov    0x88(%r12),%rdi
 100e682:	mov    $0xff,%esi
 100e687:	mov    %rbx,%rdx
 100e68a:	call   788430 <memset@plt>
 100e68f:	lea    0x300(%rsp),%rsi
 100e697:	test   %r13d,%r13d
 100e69a:	je     100f375 <check_program+0x5455>
 100e6a0:	cmpl   $0x1,0x10(%rsp)
 100e6a5:	jne    100f1fb <check_program+0x52db>
 100e6ab:	xor    %eax,%eax
 100e6ad:	jmp    100f30e <check_program+0x53ee>
 100e6b2:	mov    0x40(%rsp),%r9
 100e6b7:	mov    %rdi,%rsi
 100e6ba:	sub    %r8,%rsi
 100e6bd:	mov    0x10(%r9),%r9
 100e6c1:	sub    %rsi,%r9
 100e6c4:	jb     100e60e <check_program+0x46ee>
 100e6ca:	mov    %rdx,%r8
 100e6cd:	shl    $0x4,%r8
 100e6d1:	cmp    %r9,%r8
 100e6d4:	ja     100e60e <check_program+0x46ee>
 100e6da:	mov    0x40(%rsp),%r9
 100e6df:	add    %r8,%rsi
 100e6e2:	mov    %rsi,0x8(%r9)
 100e6e6:	mov    %rdi,(%rcx)
 100e6e9:	test   $0x1,%al
 100e6eb:	je     100d662 <check_program+0x3742>
 100e6f1:	jmp    100e61f <check_program+0x46ff>
 100e6f6:	mov    %rdi,%r11
 100e6f9:	mov    %rbx,%rdi
 100e6fc:	mov    %r9,0x60(%rsp)
 100e701:	sub    %rcx,%rdi
 100e704:	mov    %rbx,%r9
 100e707:	mov    0x328(%rsp),%rbx
 100e70f:	mov    0x10(%rbx),%r14
 100e713:	xor    %ebx,%ebx
 100e715:	sub    %rdi,%r14
 100e718:	jb     100e759 <check_program+0x4839>
 100e71a:	cmp    %r14,%r10
 100e71d:	ja     100e759 <check_program+0x4839>
 100e71f:	mov    0x328(%rsp),%r11
 100e727:	add    %r10,%rdi
 100e72a:	lea    0x3(%rcx,%rdi,1),%r12
 100e72f:	lea    (%rdi,%rcx,1),%rdx
 100e733:	and    $0xfffffffffffffffc,%r12
 100e737:	mov    %rdi,0x8(%r11)
 100e73b:	cmp    %rdx,%r12
 100e73e:	mov    0x68(%rsp),%rdx
 100e743:	jae    100e7b0 <check_program+0x4890>
 100e745:	xor    %r12d,%r12d
 100e748:	movq   $0x0,0x70(%rsp)
 100e751:	mov    %r9,%rbx
 100e754:	jmp    100a134 <check_program+0x214>
 100e759:	mov    0x68(%rsp),%rdx
 100e75e:	mov    %r9,%r12
 100e761:	jmp    100e7bc <check_program+0x489c>
 100e763:	mov    %rcx,%rdx
 100e766:	sub    %rsi,%rdx
 100e769:	mov    0x40(%rsp),%rsi
 100e76e:	mov    0x10(%rsi),%rsi
 100e772:	sub    %rdx,%rsi
 100e775:	jb     100dc0b <check_program+0x3ceb>
 100e77b:	mov    %eax,%eax
 100e77d:	shl    $0x6,%rax
 100e781:	cmp    %rsi,%rax
 100e784:	ja     100dc0b <check_program+0x3ceb>
 100e78a:	mov    0x40(%rsp),%rsi
 100e78f:	add    %rax,%rdx
 100e792:	mov    %r9,%r15
 100e795:	mov    %rdx,0x8(%rsi)
 100e799:	mov    0x8(%rsp),%rdx
 100e79e:	mov    %rcx,0x48(%rdx)
 100e7a2:	test   %rcx,%rcx
 100e7a5:	jne    100dc91 <check_program+0x3d71>
 100e7ab:	jmp    100dc18 <check_program+0x3cf8>
 100e7b0:	mov    %rdi,%r11
 100e7b3:	mov    %r12,%rdi
 100e7b6:	sub    %rcx,%rdi
 100e7b9:	mov    %r9,%rbx
 100e7bc:	mov    0x328(%rsp),%r14
 100e7c4:	xor    %r15d,%r15d
 100e7c7:	mov    0x10(%r14),%r14
 100e7cb:	sub    %rdi,%r14
 100e7ce:	jb     100e808 <check_program+0x48e8>
 100e7d0:	cmp    %r14,%r10
 100e7d3:	ja     100e808 <check_program+0x48e8>
 100e7d5:	mov    0x328(%rsp),%r11
 100e7dd:	add    %r10,%rdi
 100e7e0:	lea    0x3(%rcx,%rdi,1),%r14
 100e7e5:	lea    (%rdi,%rcx,1),%r8
 100e7e9:	and    $0xfffffffffffffffc,%r14
 100e7ed:	mov    %rdi,0x8(%r11)
 100e7f1:	cmp    %r8,%r14
 100e7f4:	jb     100a12b <check_program+0x20b>
 100e7fa:	mov    %rdi,%r11
 100e7fd:	mov    %r14,%rdi
 100e800:	sub    %rcx,%rdi
 100e803:	mov    %r12,%r15
 100e806:	jmp    100e80b <check_program+0x48eb>
 100e808:	mov    %r12,%r14
 100e80b:	mov    0x328(%rsp),%r12
 100e813:	movq   $0x0,0x70(%rsp)
 100e81c:	mov    0x10(%r12),%r12
 100e821:	sub    %rdi,%r12
 100e824:	jb     100e847 <check_program+0x4927>
 100e826:	cmp    %r12,%rsi
 100e829:	ja     100e847 <check_program+0x4927>
 100e82b:	mov    0x328(%rsp),%r11
 100e833:	add    %rsi,%rdi
 100e836:	mov    %r15,%r12
 100e839:	mov    %r14,0x70(%rsp)
 100e83e:	mov    %rdi,0x8(%r11)
 100e842:	jmp    100a134 <check_program+0x214>
 100e847:	mov    %r15,%r12
 100e84a:	mov    %r11,%rdi
 100e84d:	jmp    100a134 <check_program+0x214>
 100e852:	vbroadcasti32x4 -0xa7fddc(%rip),%zmm0        # 58ea80 <abi_test_hex.digits+0xf0>
 100e85c:	vbroadcasti32x4 -0xa7fdd6(%rip),%zmm1        # 58ea90 <abi_test_hex.digits+0x100>
 100e866:	mov    0x20(%rsp),%r11
 100e86b:	and    $0xfffffffc,%edx
 100e86e:	xor    %ecx,%ecx
 100e870:	jmp    100e892 <check_program+0x4972>
 100e872:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100e880:	add    $0x100,%rcx
 100e887:	add    $0x4,%esi
 100e88a:	cmp    %edx,%esi
 100e88c:	je     100ea2e <check_program+0x4b0e>
 100e892:	mov    0x10(%r10),%rdi
 100e896:	mov    0x50(%r10),%r8
 100e89a:	vpcmpeqb (%rdi,%rcx,1),%zmm0,%k0
 100e8a1:	vpcmpeqb (%r8,%rcx,1),%zmm1,%k1
 100e8a8:	ktestq %k1,%k0
 100e8ad:	je     100e8f0 <check_program+0x49d0>
 100e8af:	kandq  %k1,%k0,%k0
 100e8b4:	kmovq  %k0,%rdi
 100e8b9:	jmp    100e8c7 <check_program+0x49a7>
 100e8bb:	nopl   0x0(%rax,%rax,1)
 100e8c0:	blsr   %rdi,%rdi
 100e8c5:	je     100e8f0 <check_program+0x49d0>
 100e8c7:	xor    %r8d,%r8d
 100e8ca:	tzcnt  %rdi,%r8
 100e8cf:	shl    $0x2,%r8
 100e8d3:	add    0x300(%r11),%r8
 100e8da:	mov    (%r8,%rcx,4),%r8d
 100e8de:	cmp    %ebx,%r8d
 100e8e1:	jae    100e8c0 <check_program+0x49a0>
 100e8e3:	movb   $0x1,(%r14,%r8,1)
 100e8e8:	jmp    100e8c0 <check_program+0x49a0>
 100e8ea:	nopw   0x0(%rax,%rax,1)
 100e8f0:	mov    0x10(%r10),%rdi
 100e8f4:	mov    0x50(%r10),%r8
 100e8f8:	vpcmpeqb 0x40(%rdi,%rcx,1),%zmm0,%k0
 100e900:	vpcmpeqb 0x40(%r8,%rcx,1),%zmm1,%k1
 100e908:	ktestq %k1,%k0
 100e90d:	je     100e950 <check_program+0x4a30>
 100e90f:	kandq  %k1,%k0,%k0
 100e914:	lea    0x40(%rcx),%rdi
 100e918:	kmovq  %k0,%r8
 100e91d:	jmp    100e927 <check_program+0x4a07>
 100e91f:	nop
 100e920:	blsr   %r8,%r8
 100e925:	je     100e950 <check_program+0x4a30>
 100e927:	xor    %r9d,%r9d
 100e92a:	tzcnt  %r8,%r9
 100e92f:	shl    $0x2,%r9
 100e933:	add    0x300(%r11),%r9
 100e93a:	mov    (%r9,%rdi,4),%r9d
 100e93e:	cmp    %ebx,%r9d
 100e941:	jae    100e920 <check_program+0x4a00>
 100e943:	movb   $0x1,(%r14,%r9,1)
 100e948:	jmp    100e920 <check_program+0x4a00>
 100e94a:	nopw   0x0(%rax,%rax,1)
 100e950:	mov    0x10(%r10),%rdi
 100e954:	mov    0x50(%r10),%r8
 100e958:	vpcmpeqb 0x80(%rdi,%rcx,1),%zmm0,%k0
 100e960:	vpcmpeqb 0x80(%r8,%rcx,1),%zmm1,%k1
 100e968:	ktestq %k1,%k0
 100e96d:	je     100e9c0 <check_program+0x4aa0>
 100e96f:	kandq  %k1,%k0,%k0
 100e974:	lea    0x80(%rcx),%rdi
 100e97b:	kmovq  %k0,%r8
 100e980:	jmp    100e997 <check_program+0x4a77>
 100e982:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100e990:	blsr   %r8,%r8
 100e995:	je     100e9c0 <check_program+0x4aa0>
 100e997:	xor    %r9d,%r9d
 100e99a:	tzcnt  %r8,%r9
 100e99f:	shl    $0x2,%r9
 100e9a3:	add    0x300(%r11),%r9
 100e9aa:	mov    (%r9,%rdi,4),%r9d
 100e9ae:	cmp    %ebx,%r9d
 100e9b1:	jae    100e990 <check_program+0x4a70>
 100e9b3:	movb   $0x1,(%r14,%r9,1)
 100e9b8:	jmp    100e990 <check_program+0x4a70>
 100e9ba:	nopw   0x0(%rax,%rax,1)
 100e9c0:	mov    0x10(%r10),%rdi
 100e9c4:	mov    0x50(%r10),%r8
 100e9c8:	vpcmpeqb 0xc0(%rdi,%rcx,1),%zmm0,%k0
 100e9d0:	vpcmpeqb 0xc0(%r8,%rcx,1),%zmm1,%k1
 100e9d8:	ktestq %k1,%k0
 100e9dd:	je     100e880 <check_program+0x4960>
 100e9e3:	kandq  %k1,%k0,%k0
 100e9e8:	lea    0xc0(%rcx),%rdi
 100e9ef:	kmovq  %k0,%r8
 100e9f4:	jmp    100ea0b <check_program+0x4aeb>
 100e9f6:	cs nopw 0x0(%rax,%rax,1)
 100ea00:	blsr   %r8,%r8
 100ea05:	je     100e880 <check_program+0x4960>
 100ea0b:	xor    %r9d,%r9d
 100ea0e:	tzcnt  %r8,%r9
 100ea13:	shl    $0x2,%r9
 100ea17:	add    0x300(%r11),%r9
 100ea1e:	mov    (%r9,%rdi,4),%r9d
 100ea22:	cmp    %ebx,%r9d
 100ea25:	jae    100ea00 <check_program+0x4ae0>
 100ea27:	movb   $0x1,(%r14,%r9,1)
 100ea2c:	jmp    100ea00 <check_program+0x4ae0>
 100ea2e:	test   %eax,%eax
 100ea30:	je     100eab7 <check_program+0x4b97>
 100ea36:	vbroadcasti32x4 -0xa7ffc0(%rip),%zmm0        # 58ea80 <abi_test_hex.digits+0xf0>
 100ea40:	vbroadcasti32x4 -0xa7ffba(%rip),%zmm1        # 58ea90 <abi_test_hex.digits+0x100>
 100ea4a:	xor    %edx,%edx
 100ea4c:	jmp    100ea5a <check_program+0x4b3a>
 100ea4e:	xchg   %ax,%ax
 100ea50:	add    $0x40,%rcx
 100ea54:	inc    %edx
 100ea56:	cmp    %eax,%edx
 100ea58:	je     100eab7 <check_program+0x4b97>
 100ea5a:	mov    0x10(%r10),%rsi
 100ea5e:	mov    0x50(%r10),%rdi
 100ea62:	vpcmpeqb (%rsi,%rcx,1),%zmm0,%k0
 100ea69:	vpcmpeqb (%rdi,%rcx,1),%zmm1,%k1
 100ea70:	ktestq %k1,%k0
 100ea75:	je     100ea50 <check_program+0x4b30>
 100ea77:	kandq  %k1,%k0,%k0
 100ea7c:	kmovq  %k0,%rsi
 100ea81:	jmp    100ea97 <check_program+0x4b77>
 100ea83:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100ea90:	blsr   %rsi,%rsi
 100ea95:	je     100ea50 <check_program+0x4b30>
 100ea97:	xor    %edi,%edi
 100ea99:	tzcnt  %rsi,%rdi
 100ea9e:	shl    $0x2,%rdi
 100eaa2:	add    0x300(%r11),%rdi
 100eaa9:	mov    (%rdi,%rcx,4),%edi
 100eaac:	cmp    %ebx,%edi
 100eaae:	jae    100ea90 <check_program+0x4b70>
 100eab0:	movb   $0x1,(%r14,%rdi,1)
 100eab5:	jmp    100ea90 <check_program+0x4b70>
 100eab7:	mov    %ebx,%ebp
 100eab9:	and    $0xffffffc0,%ebp
 100eabc:	cmp    %ebx,%ebp
 100eabe:	jae    100eb1e <check_program+0x4bfe>
 100eac0:	mov    0x20(%rsp),%rdi
 100eac5:	mov    %rbx,%rdx
 100eac8:	and    $0x3,%rdx
 100eacc:	mov    %ebp,%ecx
 100eace:	mov    %rcx,%rax
 100ead1:	je     100eb11 <check_program+0x4bf1>
 100ead3:	mov    %rcx,%rax
 100ead6:	jmp    100eae8 <check_program+0x4bc8>
 100ead8:	nopl   0x0(%rax,%rax,1)
 100eae0:	inc    %rax
 100eae3:	dec    %rdx
 100eae6:	je     100eb11 <check_program+0x4bf1>
 100eae8:	mov    0x10(%r10),%rsi
 100eaec:	cmpb   $0xf,(%rsi,%rax,1)
 100eaf0:	jne    100eae0 <check_program+0x4bc0>
 100eaf2:	mov    0x50(%r10),%rsi
 100eaf6:	cmpb   $0x9,(%rsi,%rax,1)
 100eafa:	jne    100eae0 <check_program+0x4bc0>
 100eafc:	mov    0x300(%rdi),%rsi
 100eb03:	mov    (%rsi,%rax,4),%esi
 100eb06:	cmp    %ebx,%esi
 100eb08:	jae    100eae0 <check_program+0x4bc0>
 100eb0a:	movb   $0x1,(%r14,%rsi,1)
 100eb0f:	jmp    100eae0 <check_program+0x4bc0>
 100eb11:	sub    %rbx,%rcx
 100eb14:	cmp    $0xfffffffffffffffc,%rcx
 100eb18:	jbe    100f115 <check_program+0x51f5>
 100eb1e:	mov    0x118(%rsp),%rax
 100eb26:	mov    0xb0(%rsp),%rdi
 100eb2e:	movl   $0x0,0x50(%rsp)
 100eb36:	xor    %esi,%esi
 100eb38:	lea    0x4(,%rax,4),%rbx
 100eb40:	mov    %rbx,%rdx
 100eb43:	vzeroupper
 100eb46:	call   788430 <memset@plt>
 100eb4b:	mov    %r15,%rdi
 100eb4e:	xor    %esi,%esi
 100eb50:	mov    %r13,%rdx
 100eb53:	call   788430 <memset@plt>
 100eb58:	mov    0x148(%rsp),%rdi
 100eb60:	mov    $0xff,%esi
 100eb65:	mov    %rbx,%rdx
 100eb68:	call   788430 <memset@plt>
 100eb6d:	mov    0x140(%rsp),%rdi
 100eb75:	mov    $0xff,%esi
 100eb7a:	mov    %rbx,%rdx
 100eb7d:	call   788430 <memset@plt>
 100eb82:	mov    0x28(%rsp),%rdi
 100eb87:	mov    $0xff,%esi
 100eb8c:	mov    %rbx,%rdx
 100eb8f:	call   788430 <memset@plt>
 100eb94:	mov    0x20(%rsp),%rbp
 100eb99:	vmovapd 0x190(%rsp),%xmm0
 100eba2:	mov    0x328(%rbp),%ecx
 100eba8:	test   %rcx,%rcx
 100ebab:	je     100ec36 <check_program+0x4d16>
 100ebb1:	mov    %ecx,%edx
 100ebb3:	and    $0x3,%edx
 100ebb6:	mov    %rcx,%rax
 100ebb9:	je     100ec31 <check_program+0x4d11>
 100ebbb:	mov    0x28(%rsp),%r10
 100ebc0:	mov    0x18(%rsp),%r11
 100ebc5:	mov    %rcx,%rax
 100ebc8:	jmp    100ebe6 <check_program+0x4cc6>
 100ebca:	nopw   0x0(%rax,%rax,1)
 100ebd0:	mov    (%r10,%r8,4),%r9d
 100ebd4:	lea    -0x1(%rax),%edi
 100ebd7:	mov    %r9d,(%r11,%rsi,4)
 100ebdb:	mov    %edi,(%r10,%r8,4)
 100ebdf:	dec    %rax
 100ebe2:	dec    %edx
 100ebe4:	je     100ec31 <check_program+0x4d11>
 100ebe6:	mov    0x318(%rbp),%rdi
 100ebed:	lea    -0x1(%rax),%esi
 100ebf0:	lea    (%rsi,%rsi,2),%r9
 100ebf4:	mov    0xc(%rdi,%r9,8),%r8d
 100ebf9:	cmp    0x10(%rsp),%r8d
 100ebfe:	jb     100ebd0 <check_program+0x4cb0>
 100ec00:	mov    0x8(%rsp),%rsi
 100ec05:	cmpl   $0x0,0xbc(%rsi)
 100ec0c:	jne    100ebdf <check_program+0x4cbf>
 100ec0e:	lea    (%rdi,%r9,8),%rsi
 100ec12:	mov    0x8(%rsp),%rdi
 100ec17:	mov    (%rsi),%esi
 100ec19:	movl   $0x1,0xbc(%rdi)
 100ec23:	mov    %esi,0xb4(%rdi)
 100ec29:	mov    %esi,0xb8(%rdi)
 100ec2f:	jmp    100ebdf <check_program+0x4cbf>
 100ec31:	cmp    $0x4,%ecx
 100ec34:	jae    100ec82 <check_program+0x4d62>
 100ec36:	cmpl   $0x0,0x10(%rsp)
 100ec3b:	mov    0x38(%rsp),%r10
 100ec40:	mov    0x98(%rsp),%r11
 100ec48:	mov    0xe0(%rsp),%rbx
 100ec50:	mov    0x58(%rsp),%r14
 100ec55:	mov    0xa0(%rsp),%r15
 100ec5d:	mov    0x30(%rsp),%r13
 100ec62:	je     100f66c <check_program+0x574c>
 100ec68:	cmpl   $0x1,0x10(%rsp)
 100ec6d:	jne    100eef8 <check_program+0x4fd8>
 100ec73:	xor    %eax,%eax
 100ec75:	movl   $0x0,0x50(%rsp)
 100ec7d:	jmp    100f0e4 <check_program+0x51c4>
 100ec82:	mov    $0xfffffffc,%ecx
 100ec87:	mov    $0xfffffffffffffffc,%r8
 100ec8e:	mov    $0xfffffffffffffffd,%r9
 100ec95:	mov    $0xfffffffffffffffe,%r10
 100ec9c:	mov    $0xffffffffffffffff,%r11
 100eca3:	xor    %r14d,%r14d
 100eca6:	lea    0x1(%rcx),%rdx
 100ecaa:	lea    0x2(%rcx),%rsi
 100ecae:	lea    0x3(%rcx),%rdi
 100ecb2:	mov    %rdx,0x68(%rsp)
 100ecb7:	jmp    100ed16 <check_program+0x4df6>
 100ecb9:	nopl   0x0(%rax)
 100ecc0:	mov    0x28(%rsp),%r12
 100ecc5:	mov    0x18(%rsp),%rdx
 100ecca:	lea    (%rax,%rcx,1),%rbx
 100ecce:	mov    (%r12,%rbp,4),%r15d
 100ecd2:	mov    %r15d,(%rdx,%r13,4)
 100ecd6:	mov    %ebx,(%r12,%rbp,4)
 100ecda:	mov    0x150(%rsp),%r12
 100ece2:	addq   $0xfffffffffffffffc,0x68(%rsp)
 100ece8:	mov    0x20(%rsp),%rbp
 100eced:	add    $0xfffffffffffffffc,%r8
 100ecf1:	add    $0x4,%r14
 100ecf5:	add    $0xfffffffffffffffc,%rcx
 100ecf9:	add    $0xfffffffffffffffc,%r9
 100ecfd:	add    $0xfffffffffffffffc,%r10
 100ed01:	add    $0xfffffffffffffffc,%rsi
 100ed05:	add    $0xfffffffffffffffc,%r11
 100ed09:	add    $0xfffffffffffffffc,%rdi
 100ed0d:	cmp    %r14d,%eax
 100ed10:	je     100ec36 <check_program+0x4d16>
 100ed16:	mov    0x318(%rbp),%rbp
 100ed1d:	lea    (%rax,%r11,1),%r13d
 100ed21:	lea    0x0(%r13,%r13,2),%rbx
 100ed26:	mov    0xc(%rbp,%rbx,8),%r15d
 100ed2b:	cmp    0x10(%rsp),%r15d
 100ed30:	jae    100ed50 <check_program+0x4e30>
 100ed32:	mov    0x28(%rsp),%r12
 100ed37:	mov    0x18(%rsp),%rdx
 100ed3c:	lea    (%rax,%rdi,1),%ebx
 100ed3f:	mov    (%r12,%r15,4),%ebp
 100ed43:	mov    %ebp,(%rdx,%r13,4)
 100ed47:	mov    %ebx,(%r12,%r15,4)
 100ed4b:	jmp    100ed90 <check_program+0x4e70>
 100ed4d:	nopl   (%rax)
 100ed50:	mov    0x8(%rsp),%r15
 100ed55:	cmpl   $0x0,0xbc(%r15)
 100ed5d:	jne    100ed90 <check_program+0x4e70>
 100ed5f:	lea    0x0(%rbp,%rbx,8),%rbx
 100ed64:	mov    0x8(%rsp),%r15
 100ed69:	mov    (%rbx),%ebx
 100ed6b:	movl   $0x1,0xbc(%r15)
 100ed76:	mov    %ebx,0xb4(%r15)
 100ed7d:	mov    %ebx,0xb8(%r15)
 100ed84:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 100ed90:	mov    0x20(%rsp),%rbx
 100ed95:	lea    (%rax,%r10,1),%r13d
 100ed99:	mov    0x318(%rbx),%r15
 100eda0:	lea    0x0(%r13,%r13,2),%rbx
 100eda5:	mov    0xc(%r15,%rbx,8),%ebp
 100edaa:	cmp    0x10(%rsp),%ebp
 100edae:	jae    100edd0 <check_program+0x4eb0>
 100edb0:	mov    0x28(%rsp),%r12
 100edb5:	mov    0x18(%rsp),%rdx
 100edba:	lea    (%rax,%rsi,1),%ebx
 100edbd:	mov    (%r12,%rbp,4),%r15d
 100edc1:	mov    %r15d,(%rdx,%r13,4)
 100edc5:	mov    %ebx,(%r12,%rbp,4)
 100edc9:	jmp    100ee10 <check_program+0x4ef0>
 100edcb:	nopl   0x0(%rax,%rax,1)
 100edd0:	mov    0x8(%rsp),%r13
 100edd5:	cmpl   $0x0,0xbc(%r13)
 100eddd:	jne    100ee10 <check_program+0x4ef0>
 100eddf:	lea    (%r15,%rbx,8),%rbx
 100ede3:	mov    0x8(%rsp),%r15
 100ede8:	mov    (%rbx),%ebx
 100edea:	movl   $0x1,0xbc(%r15)
 100edf5:	mov    %ebx,0xb4(%r15)
 100edfc:	mov    %ebx,0xb8(%r15)
 100ee03:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100ee10:	mov    0x20(%rsp),%rbx
 100ee15:	lea    (%rax,%r9,1),%r13d
 100ee19:	mov    0x318(%rbx),%r15
 100ee20:	lea    0x0(%r13,%r13,2),%rbx
 100ee25:	mov    0xc(%r15,%rbx,8),%ebp
 100ee2a:	cmp    0x10(%rsp),%ebp
 100ee2e:	jae    100ee50 <check_program+0x4f30>
 100ee30:	mov    0x68(%rsp),%rdx
 100ee35:	mov    0x28(%rsp),%r12
 100ee3a:	lea    (%rax,%rdx,1),%ebx
 100ee3d:	mov    (%r12,%rbp,4),%r15d
 100ee41:	mov    0x18(%rsp),%rdx
 100ee46:	mov    %r15d,(%rdx,%r13,4)
 100ee4a:	mov    %ebx,(%r12,%rbp,4)
 100ee4e:	jmp    100ee90 <check_program+0x4f70>
 100ee50:	mov    0x8(%rsp),%r13
 100ee55:	cmpl   $0x0,0xbc(%r13)
 100ee5d:	jne    100ee90 <check_program+0x4f70>
 100ee5f:	lea    (%r15,%rbx,8),%rbx
 100ee63:	mov    0x8(%rsp),%r15
 100ee68:	mov    (%rbx),%ebx
 100ee6a:	movl   $0x1,0xbc(%r15)
 100ee75:	mov    %ebx,0xb4(%r15)
 100ee7c:	mov    %ebx,0xb8(%r15)
 100ee83:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100ee90:	mov    0x20(%rsp),%rbx
 100ee95:	lea    (%rax,%r8,1),%r13d
 100ee99:	mov    0x318(%rbx),%r15
 100eea0:	lea    0x0(%r13,%r13,2),%rbx
 100eea5:	mov    0xc(%r15,%rbx,8),%ebp
 100eeaa:	cmp    0x10(%rsp),%ebp
 100eeae:	jb     100ecc0 <check_program+0x4da0>
 100eeb4:	mov    0x8(%rsp),%r13
 100eeb9:	mov    0x150(%rsp),%r12
 100eec1:	cmpl   $0x0,0xbc(%r13)
 100eec9:	jne    100ece2 <check_program+0x4dc2>
 100eecf:	lea    (%r15,%rbx,8),%rbx
 100eed3:	mov    0x8(%rsp),%r15
 100eed8:	mov    (%rbx),%ebx
 100eeda:	movl   $0x1,0xbc(%r15)
 100eee5:	mov    %ebx,0xb4(%r15)
 100eeec:	mov    %ebx,0xb8(%r15)
 100eef3:	jmp    100ece2 <check_program+0x4dc2>
 100eef8:	mov    0x118(%rsp),%rcx
 100ef00:	and    $0xfffffffe,%ecx
 100ef03:	mov    $0xffffffff,%edx
 100ef08:	xor    %eax,%eax
 100ef0a:	movl   $0x0,0x50(%rsp)
 100ef12:	jmp    100ef45 <check_program+0x5025>
 100ef14:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 100ef20:	lea    0x1(%rax),%r9d
 100ef24:	mov    %r9d,(%r12,%r8,4)
 100ef28:	mov    0x50(%rsp),%r8d
 100ef2d:	add    $0x2,%rax
 100ef31:	add    %esi,%r8d
 100ef34:	add    %edi,%r8d
 100ef37:	mov    %r8d,0x50(%rsp)
 100ef3c:	cmp    %rax,%rcx
 100ef3f:	je     100f0d6 <check_program+0x51b6>
 100ef45:	mov    0x60(%r10),%rsi
 100ef49:	mov    (%rsi,%rax,4),%esi
 100ef4c:	cmp    0x10(%rsp),%esi
 100ef50:	jae    100ef6d <check_program+0x504d>
 100ef52:	mov    (%r14,%rsi,4),%edi
 100ef56:	mov    %edi,0x0(%r13,%rax,4)
 100ef5b:	cmp    %rdx,%rdi
 100ef5e:	je     100ef66 <check_program+0x5046>
 100ef60:	mov    %eax,(%r15,%rdi,4)
 100ef64:	jmp    100ef69 <check_program+0x5049>
 100ef66:	mov    %eax,(%rbx,%rsi,4)
 100ef69:	mov    %eax,(%r14,%rsi,4)
 100ef6d:	mov    0x2d8(%rbp),%rsi
 100ef74:	cmpl   $0xffffffff,(%rsi,%rax,4)
 100ef78:	je     100f050 <check_program+0x5130>
 100ef7e:	mov    0x1f0(%rbp),%rdi
 100ef85:	test   %rdi,%rdi
 100ef88:	je     100f070 <check_program+0x5150>
 100ef8e:	xor    %esi,%esi
 100ef90:	cmpb   $0x0,(%rdi,%rax,1)
 100ef94:	sete   %sil
 100ef98:	mov    0x2a8(%rbp),%rdi
 100ef9f:	mov    (%rdi,%rax,4),%edi
 100efa2:	cmp    %r11d,%edi
 100efa5:	jae    100efab <check_program+0x508b>
 100efa7:	mov    %eax,(%r12,%rdi,4)
 100efab:	mov    0x60(%r10),%rdi
 100efaf:	mov    0x4(%rdi,%rax,4),%edi
 100efb3:	cmp    0x10(%rsp),%edi
 100efb7:	jae    100f010 <check_program+0x50f0>
 100efb9:	mov    (%r14,%rdi,4),%r9d
 100efbd:	mov    %r9d,0x4(%r13,%rax,4)
 100efc2:	cmp    %rdx,%r9
 100efc5:	je     100f0af <check_program+0x518f>
 100efcb:	lea    0x1(%rax),%r8d
 100efcf:	mov    %r8d,(%r15,%r9,4)
 100efd3:	mov    %r8d,(%r14,%rdi,4)
 100efd7:	mov    0x2d8(%rbp),%rdi
 100efde:	cmpl   $0xffffffff,0x4(%rdi,%rax,4)
 100efe3:	jne    100f01e <check_program+0x50fe>
 100efe5:	xor    %edi,%edi
 100efe7:	mov    0x2a8(%rbp),%r8
 100efee:	mov    0x4(%r8,%rax,4),%r8d
 100eff3:	cmp    %r11d,%r8d
 100eff6:	jae    100ef28 <check_program+0x5008>
 100effc:	jmp    100ef20 <check_program+0x5000>
 100f001:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100f010:	mov    0x2d8(%rbp),%rdi
 100f017:	cmpl   $0xffffffff,0x4(%rdi,%rax,4)
 100f01c:	je     100efe5 <check_program+0x50c5>
 100f01e:	mov    0x1f0(%rbp),%r8
 100f025:	test   %r8,%r8
 100f028:	je     100f090 <check_program+0x5170>
 100f02a:	xor    %edi,%edi
 100f02c:	cmpb   $0x0,0x1(%r8,%rax,1)
 100f032:	sete   %dil
 100f036:	mov    0x2a8(%rbp),%r8
 100f03d:	mov    0x4(%r8,%rax,4),%r8d
 100f042:	cmp    %r11d,%r8d
 100f045:	jae    100ef28 <check_program+0x5008>
 100f04b:	jmp    100ef20 <check_program+0x5000>
 100f050:	xor    %esi,%esi
 100f052:	mov    0x2a8(%rbp),%rdi
 100f059:	mov    (%rdi,%rax,4),%edi
 100f05c:	cmp    %r11d,%edi
 100f05f:	jae    100efab <check_program+0x508b>
 100f065:	jmp    100efa7 <check_program+0x5087>
 100f06a:	nopw   0x0(%rax,%rax,1)
 100f070:	mov    $0x1,%esi
 100f075:	mov    0x2a8(%rbp),%rdi
 100f07c:	mov    (%rdi,%rax,4),%edi
 100f07f:	cmp    %r11d,%edi
 100f082:	jb     100efa7 <check_program+0x5087>
 100f088:	jmp    100efab <check_program+0x508b>
 100f08d:	nopl   (%rax)
 100f090:	mov    $0x1,%edi
 100f095:	mov    0x2a8(%rbp),%r8
 100f09c:	mov    0x4(%r8,%rax,4),%r8d
 100f0a1:	cmp    %r11d,%r8d
 100f0a4:	jb     100ef20 <check_program+0x5000>
 100f0aa:	jmp    100ef28 <check_program+0x5008>
 100f0af:	lea    0x1(%rax),%r8
 100f0b3:	lea    0x1(%rax),%r9d
 100f0b7:	mov    %r9d,(%rbx,%rdi,4)
 100f0bb:	mov    %r8d,(%r14,%rdi,4)
 100f0bf:	mov    0x2d8(%rbp),%rdi
 100f0c6:	cmpl   $0xffffffff,0x4(%rdi,%rax,4)
 100f0cb:	jne    100f01e <check_program+0x50fe>
 100f0d1:	jmp    100efe5 <check_program+0x50c5>
 100f0d6:	testb  $0x1,0x118(%rsp)
 100f0de:	je     100f66c <check_program+0x574c>
 100f0e4:	mov    0x60(%r10),%rcx
 100f0e8:	mov    (%rcx,%rax,4),%ecx
 100f0eb:	cmp    0x10(%rsp),%ecx
 100f0ef:	jae    100f628 <check_program+0x5708>
 100f0f5:	mov    (%r14,%rcx,4),%edx
 100f0f9:	mov    $0xffffffff,%esi
 100f0fe:	mov    %edx,0x0(%r13,%rax,4)
 100f103:	cmp    %rsi,%rdx
 100f106:	je     100f621 <check_program+0x5701>
 100f10c:	mov    %eax,(%r15,%rdx,4)
 100f110:	jmp    100f624 <check_program+0x5704>
 100f115:	mov    0x20(%rsp),%rdx
 100f11a:	jmp    100f12d <check_program+0x520d>
 100f11c:	nopl   0x0(%rax)
 100f120:	add    $0x4,%rax
 100f124:	cmp    %rax,%rbx
 100f127:	je     100eb1e <check_program+0x4bfe>
 100f12d:	mov    0x10(%r10),%rcx
 100f131:	cmpb   $0xf,(%rcx,%rax,1)
 100f135:	jne    100f160 <check_program+0x5240>
 100f137:	mov    0x50(%r10),%rcx
 100f13b:	cmpb   $0x9,(%rcx,%rax,1)
 100f13f:	jne    100f160 <check_program+0x5240>
 100f141:	mov    0x300(%rdx),%rcx
 100f148:	mov    (%rcx,%rax,4),%ecx
 100f14b:	cmp    %ebx,%ecx
 100f14d:	jae    100f160 <check_program+0x5240>
 100f14f:	movb   $0x1,(%r14,%rcx,1)
 100f154:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 100f160:	mov    0x10(%r10),%rcx
 100f164:	cmpb   $0xf,0x1(%rcx,%rax,1)
 100f169:	jne    100f190 <check_program+0x5270>
 100f16b:	mov    0x50(%r10),%rcx
 100f16f:	cmpb   $0x9,0x1(%rcx,%rax,1)
 100f174:	jne    100f190 <check_program+0x5270>
 100f176:	mov    0x300(%rdx),%rcx
 100f17d:	mov    0x4(%rcx,%rax,4),%ecx
 100f181:	cmp    %ebx,%ecx
 100f183:	jae    100f190 <check_program+0x5270>
 100f185:	movb   $0x1,(%r14,%rcx,1)
 100f18a:	nopw   0x0(%rax,%rax,1)
 100f190:	mov    0x10(%r10),%rcx
 100f194:	cmpb   $0xf,0x2(%rcx,%rax,1)
 100f199:	jne    100f1c0 <check_program+0x52a0>
 100f19b:	mov    0x50(%r10),%rcx
 100f19f:	cmpb   $0x9,0x2(%rcx,%rax,1)
 100f1a4:	jne    100f1c0 <check_program+0x52a0>
 100f1a6:	mov    0x300(%rdx),%rcx
 100f1ad:	mov    0x8(%rcx,%rax,4),%ecx
 100f1b1:	cmp    %ebx,%ecx
 100f1b3:	jae    100f1c0 <check_program+0x52a0>
 100f1b5:	movb   $0x1,(%r14,%rcx,1)
 100f1ba:	nopw   0x0(%rax,%rax,1)
 100f1c0:	mov    0x10(%r10),%rcx
 100f1c4:	cmpb   $0xf,0x3(%rcx,%rax,1)
 100f1c9:	jne    100f120 <check_program+0x5200>
 100f1cf:	mov    0x50(%r10),%rcx
 100f1d3:	cmpb   $0x9,0x3(%rcx,%rax,1)
 100f1d8:	jne    100f120 <check_program+0x5200>
 100f1de:	mov    0x300(%rdx),%rcx
 100f1e5:	mov    0xc(%rcx,%rax,4),%ecx
 100f1e9:	cmp    %ebx,%ecx
 100f1eb:	jae    100f120 <check_program+0x5200>
 100f1f1:	movb   $0x1,(%r14,%rcx,1)
 100f1f6:	jmp    100f120 <check_program+0x5200>
 100f1fb:	mov    %r15d,%ecx
 100f1fe:	and    $0xfffffffe,%ecx
 100f201:	xor    %edx,%edx
 100f203:	jmp    100f21a <check_program+0x52fa>
 100f205:	mov    0x48(%rsp),%r8
 100f20a:	or     %dil,(%r8,%rsi,1)
 100f20e:	inc    %rdx
 100f211:	cmp    %rcx,%rdx
 100f214:	je     100f2fc <check_program+0x53dc>
 100f21a:	mov    0x238(%rbp),%rsi
 100f221:	mov    %rdx,%rax
 100f224:	mov    (%rsi,%rax,4),%edx
 100f227:	cmp    %rdx,%rax
 100f22a:	jne    100f27f <check_program+0x535f>
 100f22c:	mov    0x268(%rbp),%rdx
 100f233:	cmpb   $0x0,(%rdx,%rax,1)
 100f237:	je     100f27f <check_program+0x535f>
 100f239:	mov    0x260(%rbp),%rdx
 100f240:	mov    (%rdx,%rax,4),%edx
 100f243:	lea    -0x1(%rdx),%esi
 100f246:	cmp    0x10(%rsp),%esi
 100f24a:	jae    100f27f <check_program+0x535f>
 100f24c:	mov    0x88(%r12),%rsi
 100f254:	mov    %eax,(%rsi,%rdx,4)
 100f257:	mov    $0x1,%sil
 100f25a:	mov    0x298(%rbp),%rdi
 100f261:	cmpb   $0x0,(%rdi,%rax,1)
 100f265:	jne    100f276 <check_program+0x5356>
 100f267:	mov    0x2a0(%rbp),%rsi
 100f26e:	cmpb   $0x0,(%rsi,%rax,1)
 100f272:	setne  %sil
 100f276:	mov    0x48(%rsp),%rdi
 100f27b:	or     %sil,(%rdi,%rdx,1)
 100f27f:	mov    0x238(%rbp),%rdx
 100f286:	mov    0x4(%rdx,%rax,4),%esi
 100f28a:	lea    0x1(%rax),%rdx
 100f28e:	cmp    %rsi,%rdx
 100f291:	jne    100f20e <check_program+0x52ee>
 100f297:	mov    0x268(%rbp),%rsi
 100f29e:	cmpb   $0x0,0x1(%rsi,%rax,1)
 100f2a3:	je     100f20e <check_program+0x52ee>
 100f2a9:	mov    0x260(%rbp),%rsi
 100f2b0:	mov    0x4(%rsi,%rax,4),%esi
 100f2b4:	lea    -0x1(%rsi),%edi
 100f2b7:	cmp    0x10(%rsp),%edi
 100f2bb:	jae    100f20e <check_program+0x52ee>
 100f2c1:	mov    0x88(%r12),%rdi
 100f2c9:	lea    0x1(%rax),%r8d
 100f2cd:	mov    %r8d,(%rdi,%rsi,4)
 100f2d1:	mov    $0x1,%dil
 100f2d4:	mov    0x298(%rbp),%r8
 100f2db:	cmpb   $0x0,0x1(%r8,%rax,1)
 100f2e1:	jne    100f205 <check_program+0x52e5>
 100f2e7:	mov    0x2a0(%rbp),%rdi
 100f2ee:	cmpb   $0x0,0x1(%rdi,%rax,1)
 100f2f3:	setne  %dil
 100f2f7:	jmp    100f205 <check_program+0x52e5>
 100f2fc:	lea    0x300(%rsp),%rsi
 100f304:	test   $0x1,%r15b
 100f308:	je     100f375 <check_program+0x5455>
 100f30a:	add    $0x2,%rax
 100f30e:	mov    0x238(%rbp),%rcx
 100f315:	mov    (%rcx,%rax,4),%ecx
 100f318:	cmp    %rcx,%rax
 100f31b:	jne    100f375 <check_program+0x5455>
 100f31d:	mov    0x268(%rbp),%rcx
 100f324:	cmpb   $0x0,(%rcx,%rax,1)
 100f328:	je     100f375 <check_program+0x5455>
 100f32a:	mov    0x260(%rbp),%rcx
 100f331:	mov    (%rcx,%rax,4),%ecx
 100f334:	lea    -0x1(%rcx),%edx
 100f337:	cmp    0x10(%rsp),%edx
 100f33b:	jae    100f375 <check_program+0x5455>
 100f33d:	mov    0x88(%r12),%rdx
 100f345:	mov    %eax,(%rdx,%rcx,4)
 100f348:	mov    $0x1,%dl
 100f34a:	mov    0x298(%rbp),%rsi
 100f351:	cmpb   $0x0,(%rsi,%rax,1)
 100f355:	jne    100f365 <check_program+0x5445>
 100f357:	mov    0x2a0(%rbp),%rdx
 100f35e:	cmpb   $0x0,(%rdx,%rax,1)
 100f362:	setne  %dl
 100f365:	mov    0x48(%rsp),%rax
 100f36a:	lea    0x300(%rsp),%rsi
 100f372:	or     %dl,(%rax,%rcx,1)
 100f375:	mov    0x20(%rsi),%eax
 100f378:	test   %eax,%eax
 100f37a:	je     100f3e8 <check_program+0x54c8>
 100f37c:	xor    %ecx,%ecx
 100f37e:	jmp    100f399 <check_program+0x5479>
 100f380:	mov    0x48(%rsp),%rax
 100f385:	mov    %rdi,%rsi
 100f388:	movb   $0x1,(%rax,%rdx,1)
 100f38c:	mov    0x20(%rdi),%eax
 100f38f:	inc    %rcx
 100f392:	mov    %eax,%edx
 100f394:	cmp    %rdx,%rcx
 100f397:	jae    100f3e8 <check_program+0x54c8>
 100f399:	mov    0x18(%rsi),%rdx
 100f39d:	mov    %rsi,%rdi
 100f3a0:	mov    (%rdx,%rcx,4),%edx
 100f3a3:	lea    -0x1(%rdx),%esi
 100f3a6:	cmp    0x10(%rsp),%esi
 100f3aa:	jb     100f380 <check_program+0x5460>
 100f3ac:	test   %rdx,%rdx
 100f3af:	je     100f3de <check_program+0x54be>
 100f3b1:	cmpl   $0x0,0xbc(%r12)
 100f3ba:	lea    0x300(%rsp),%rsi
 100f3c2:	jne    100f38f <check_program+0x546f>
 100f3c4:	movl   $0x1,0xbc(%r12)
 100f3d0:	movq   $0x0,0xb4(%r12)
 100f3dc:	jmp    100f38f <check_program+0x546f>
 100f3de:	lea    0x300(%rsp),%rsi
 100f3e6:	jmp    100f38f <check_program+0x546f>
 100f3e8:	cmpl   $0x0,0x10(%rsp)
 100f3ed:	je     100f5c0 <check_program+0x56a0>
 100f3f3:	mov    0xcc(%rsp),%eax
 100f3fa:	mov    $0x2,%esi
 100f3ff:	mov    $0x1,%ecx
 100f404:	cmp    $0x3,%eax
 100f407:	cmovae %eax,%esi
 100f40a:	lea    -0x1(%rsi),%rdx
 100f40e:	add    $0xfffffffe,%esi
 100f411:	mov    %edx,%eax
 100f413:	and    $0x7,%eax
 100f416:	cmp    $0x7,%esi
 100f419:	jb     100f586 <check_program+0x5666>
 100f41f:	and    $0xfffffffffffffff8,%rdx
 100f423:	xor    %ecx,%ecx
 100f425:	jmp    100f43d <check_program+0x551d>
 100f427:	nopw   0x0(%rax,%rax,1)
 100f430:	add    $0x8,%rcx
 100f434:	cmp    %rcx,%rdx
 100f437:	je     100f57e <check_program+0x565e>
 100f43d:	mov    0x48(%rsp),%rsi
 100f442:	cmpb   $0x0,0x1(%rsi,%rcx,1)
 100f447:	je     100f464 <check_program+0x5544>
 100f449:	mov    0xb0(%r12),%esi
 100f451:	inc    %esi
 100f453:	mov    %esi,0xb0(%r12)
 100f45b:	mov    0x78(%r12),%rdi
 100f460:	mov    %esi,0x4(%rdi,%rcx,4)
 100f464:	mov    0x48(%rsp),%rsi
 100f469:	cmpb   $0x0,0x2(%rsi,%rcx,1)
 100f46e:	je     100f48b <check_program+0x556b>
 100f470:	mov    0xb0(%r12),%esi
 100f478:	inc    %esi
 100f47a:	mov    %esi,0xb0(%r12)
 100f482:	mov    0x78(%r12),%rdi
 100f487:	mov    %esi,0x8(%rdi,%rcx,4)
 100f48b:	mov    0x48(%rsp),%rsi
 100f490:	cmpb   $0x0,0x3(%rsi,%rcx,1)
 100f495:	je     100f4b2 <check_program+0x5592>
 100f497:	mov    0xb0(%r12),%esi
 100f49f:	inc    %esi
 100f4a1:	mov    %esi,0xb0(%r12)
 100f4a9:	mov    0x78(%r12),%rdi
 100f4ae:	mov    %esi,0xc(%rdi,%rcx,4)
 100f4b2:	mov    0x48(%rsp),%rsi
 100f4b7:	cmpb   $0x0,0x4(%rsi,%rcx,1)
 100f4bc:	je     100f4d9 <check_program+0x55b9>
 100f4be:	mov    0xb0(%r12),%esi
 100f4c6:	inc    %esi
 100f4c8:	mov    %esi,0xb0(%r12)
 100f4d0:	mov    0x78(%r12),%rdi
 100f4d5:	mov    %esi,0x10(%rdi,%rcx,4)
 100f4d9:	mov    0x48(%rsp),%rsi
 100f4de:	cmpb   $0x0,0x5(%rsi,%rcx,1)
 100f4e3:	je     100f500 <check_program+0x55e0>
 100f4e5:	mov    0xb0(%r12),%esi
 100f4ed:	inc    %esi
 100f4ef:	mov    %esi,0xb0(%r12)
 100f4f7:	mov    0x78(%r12),%rdi
 100f4fc:	mov    %esi,0x14(%rdi,%rcx,4)
 100f500:	mov    0x48(%rsp),%rsi
 100f505:	cmpb   $0x0,0x6(%rsi,%rcx,1)
 100f50a:	je     100f527 <check_program+0x5607>
 100f50c:	mov    0xb0(%r12),%esi
 100f514:	inc    %esi
 100f516:	mov    %esi,0xb0(%r12)
 100f51e:	mov    0x78(%r12),%rdi
 100f523:	mov    %esi,0x18(%rdi,%rcx,4)
 100f527:	mov    0x48(%rsp),%rsi
 100f52c:	cmpb   $0x0,0x7(%rsi,%rcx,1)
 100f531:	je     100f54e <check_program+0x562e>
 100f533:	mov    0xb0(%r12),%esi
 100f53b:	inc    %esi
 100f53d:	mov    %esi,0xb0(%r12)
 100f545:	mov    0x78(%r12),%rdi
 100f54a:	mov    %esi,0x1c(%rdi,%rcx,4)
 100f54e:	mov    0x48(%rsp),%rsi
 100f553:	cmpb   $0x0,0x8(%rsi,%rcx,1)
 100f558:	je     100f430 <check_program+0x5510>
 100f55e:	mov    0xb0(%r12),%esi
 100f566:	inc    %esi
 100f568:	mov    %esi,0xb0(%r12)
 100f570:	mov    0x78(%r12),%rdi
 100f575:	mov    %esi,0x20(%rdi,%rcx,4)
 100f579:	jmp    100f430 <check_program+0x5510>
 100f57e:	test   %rax,%rax
 100f581:	je     100f5c0 <check_program+0x56a0>
 100f583:	inc    %rcx
 100f586:	shl    $0x2,%eax
 100f589:	jmp    100f599 <check_program+0x5679>
 100f58b:	nopl   0x0(%rax,%rax,1)
 100f590:	inc    %rcx
 100f593:	add    $0xfffffffffffffffc,%rax
 100f597:	je     100f5c0 <check_program+0x56a0>
 100f599:	mov    0x48(%rsp),%rdx
 100f59e:	cmpb   $0x0,(%rdx,%rcx,1)
 100f5a2:	je     100f590 <check_program+0x5670>
 100f5a4:	mov    0xb0(%r12),%edx
 100f5ac:	inc    %edx
 100f5ae:	mov    %edx,0xb0(%r12)
 100f5b6:	mov    0x78(%r12),%rsi
 100f5bb:	mov    %edx,(%rsi,%rcx,4)
 100f5be:	jmp    100f590 <check_program+0x5670>
 100f5c0:	mov    0xb0(%r12),%ecx
 100f5c8:	test   %rcx,%rcx
 100f5cb:	je     100f618 <check_program+0x56f8>
 100f5cd:	mov    0x40(%rsp),%r8
 100f5d2:	mov    (%r8),%rsi
 100f5d5:	mov    0x8(%r8),%rdx
 100f5d9:	lea    0x3(%rdx,%rsi,1),%rax
 100f5de:	add    %rsi,%rdx
 100f5e1:	and    $0xfffffffffffffffc,%rax
 100f5e5:	cmp    %rdx,%rax
 100f5e8:	jb     100f60f <check_program+0x56ef>
 100f5ea:	mov    %rax,%rdx
 100f5ed:	sub    %rsi,%rdx
 100f5f0:	mov    0x10(%r8),%rsi
 100f5f4:	shl    $0x2,%rcx
 100f5f8:	sub    %rdx,%rsi
 100f5fb:	setb   %dil
 100f5ff:	cmp    %rsi,%rcx
 100f602:	seta   %sil
 100f606:	or     %dil,%sil
 100f609:	je     100f94b <check_program+0x5a2b>
 100f60f:	xor    %ecx,%ecx
 100f611:	xor    %eax,%eax
 100f613:	jmp    100f95e <check_program+0x5a3e>
 100f618:	xor    %eax,%eax
 100f61a:	mov    $0x1,%cl
 100f61c:	jmp    100f95e <check_program+0x5a3e>
 100f621:	mov    %eax,(%rbx,%rcx,4)
 100f624:	mov    %eax,(%r14,%rcx,4)
 100f628:	mov    0x2d8(%rbp),%rcx
 100f62f:	cmpl   $0xffffffff,(%rcx,%rax,4)
 100f633:	je     100f64c <check_program+0x572c>
 100f635:	mov    0x1f0(%rbp),%rdx
 100f63c:	test   %rdx,%rdx
 100f63f:	je     100f650 <check_program+0x5730>
 100f641:	xor    %ecx,%ecx
 100f643:	cmpb   $0x0,(%rdx,%rax,1)
 100f647:	sete   %cl
 100f64a:	jmp    100f655 <check_program+0x5735>
 100f64c:	xor    %ecx,%ecx
 100f64e:	jmp    100f655 <check_program+0x5735>
 100f650:	mov    $0x1,%ecx
 100f655:	mov    0x2a8(%rbp),%rdx
 100f65c:	add    %ecx,0x50(%rsp)
 100f660:	mov    (%rdx,%rax,4),%ecx
 100f663:	cmp    %r11d,%ecx
 100f666:	jae    100f66c <check_program+0x574c>
 100f668:	mov    %eax,(%r12,%rcx,4)
 100f66c:	test   %r11,%r11
 100f66f:	je     100f856 <check_program+0x5936>
 100f675:	mov    0x98(%rsp),%r8
 100f67d:	mov    %r8d,%ecx
 100f680:	and    $0x7,%ecx
 100f683:	mov    %r8,%rax
 100f686:	je     100f6c7 <check_program+0x57a7>
 100f688:	mov    0x60(%rsp),%r12
 100f68d:	mov    0x78(%rsp),%r9
 100f692:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100f6a0:	mov    0x8(%rbp),%rdx
 100f6a4:	dec    %rax
 100f6a7:	dec    %ecx
 100f6a9:	mov    %eax,%esi
 100f6ab:	mov    (%rdx,%rsi,4),%edx
 100f6ae:	mov    (%r12,%rdx,4),%edi
 100f6b2:	mov    %edi,(%r9,%rsi,4)
 100f6b6:	mov    %eax,(%r12,%rdx,4)
 100f6ba:	jne    100f6a0 <check_program+0x5780>
 100f6bc:	cmp    $0x8,%r8d
 100f6c0:	jae    100f6db <check_program+0x57bb>
 100f6c2:	jmp    100f856 <check_program+0x5936>
 100f6c7:	mov    0x60(%rsp),%r12
 100f6cc:	mov    0x78(%rsp),%r9
 100f6d1:	cmp    $0x8,%r8d
 100f6d5:	jb     100f856 <check_program+0x5936>
 100f6db:	mov    $0xfffffffc,%ecx
 100f6e0:	mov    %r9,%rdx
 100f6e3:	xor    %r14d,%r14d
 100f6e6:	xor    %r13d,%r13d
 100f6e9:	lea    -0x4(%rcx),%r15
 100f6ed:	lea    -0x3(%rcx),%rsi
 100f6f1:	lea    -0x2(%rcx),%rdi
 100f6f5:	lea    -0x1(%rcx),%r8
 100f6f9:	lea    0x1(%rcx),%r9
 100f6fd:	lea    0x2(%rcx),%r10
 100f701:	lea    0x3(%rcx),%r11
 100f705:	data16 cs nopw 0x0(%rax,%rax,1)
 100f710:	mov    0x8(%rbp),%rbx
 100f714:	mov    %r15,0x68(%rsp)
 100f719:	lea    -0x1(%rax,%r13,1),%r15d
 100f71e:	add    $0x8,%r14
 100f722:	mov    (%rbx,%r15,4),%ebx
 100f726:	mov    (%r12,%rbx,4),%ebp
 100f72a:	mov    %ebp,(%rdx,%r15,4)
 100f72e:	lea    (%rax,%r11,1),%ebp
 100f732:	lea    -0x2(%rax,%r13,1),%r15d
 100f737:	add    $0xfffffffffffffff8,%r11
 100f73b:	mov    %ebp,(%r12,%rbx,4)
 100f73f:	mov    0x20(%rsp),%rbx
 100f744:	mov    0x8(%rbx),%rbx
 100f748:	mov    (%rbx,%r15,4),%ebx
 100f74c:	mov    (%r12,%rbx,4),%ebp
 100f750:	mov    %ebp,(%rdx,%r15,4)
 100f754:	mov    0x20(%rsp),%r15
 100f759:	lea    (%r10,%rax,1),%ebp
 100f75d:	add    $0xfffffffffffffff8,%r10
 100f761:	mov    %ebp,(%r12,%rbx,4)
 100f765:	lea    -0x3(%rax,%r13,1),%ebx
 100f76a:	mov    0x8(%r15),%r15
 100f76e:	mov    (%r15,%rbx,4),%r15d
 100f772:	mov    (%r12,%r15,4),%ebp
 100f776:	mov    %ebp,(%rdx,%rbx,4)
 100f779:	lea    (%r9,%rax,1),%ebx
 100f77d:	add    $0xfffffffffffffff8,%r9
 100f781:	mov    %ebx,(%r12,%r15,4)
 100f785:	mov    0x20(%rsp),%rbx
 100f78a:	lea    -0x4(%rax,%r13,1),%r15d
 100f78f:	mov    0x8(%rbx),%rbx
 100f793:	mov    (%rbx,%r15,4),%ebx
 100f797:	mov    (%r12,%rbx,4),%ebp
 100f79b:	mov    %ebp,(%rdx,%r15,4)
 100f79f:	lea    (%rcx,%rax,1),%ebp
 100f7a2:	lea    -0x5(%rax,%r13,1),%r15d
 100f7a7:	add    $0xfffffffffffffff8,%rcx
 100f7ab:	mov    %ebp,(%r12,%rbx,4)
 100f7af:	mov    0x20(%rsp),%rbx
 100f7b4:	mov    0x8(%rbx),%rbx
 100f7b8:	mov    (%rbx,%r15,4),%ebx
 100f7bc:	mov    (%r12,%rbx,4),%ebp
 100f7c0:	mov    %ebp,(%rdx,%r15,4)
 100f7c4:	mov    0x20(%rsp),%r15
 100f7c9:	lea    (%r8,%rax,1),%ebp
 100f7cd:	add    $0xfffffffffffffff8,%r8
 100f7d1:	mov    %ebp,(%r12,%rbx,4)
 100f7d5:	lea    -0x6(%rax,%r13,1),%ebx
 100f7da:	mov    0x8(%r15),%r15
 100f7de:	mov    (%r15,%rbx,4),%r15d
 100f7e2:	mov    (%r12,%r15,4),%ebp
 100f7e6:	mov    %ebp,(%rdx,%rbx,4)
 100f7e9:	lea    (%rdi,%rax,1),%ebp
 100f7ec:	add    $0xfffffffffffffff8,%rdi
 100f7f0:	mov    %ebp,(%r12,%r15,4)
 100f7f4:	mov    0x20(%rsp),%r15
 100f7f9:	mov    0x8(%r15),%rbx
 100f7fd:	lea    -0x7(%rax,%r13,1),%r15d
 100f802:	mov    (%rbx,%r15,4),%ebx
 100f806:	mov    (%r12,%rbx,4),%ebp
 100f80a:	mov    %ebp,(%rdx,%r15,4)
 100f80e:	lea    (%rsi,%rax,1),%ebp
 100f811:	lea    -0x8(%rax,%r13,1),%r15d
 100f816:	add    $0xfffffffffffffff8,%r13
 100f81a:	add    $0xfffffffffffffff8,%rsi
 100f81e:	mov    %ebp,(%r12,%rbx,4)
 100f822:	mov    0x20(%rsp),%rbx
 100f827:	mov    0x8(%rbx),%rbx
 100f82b:	mov    (%rbx,%r15,4),%ebx
 100f82f:	mov    (%r12,%rbx,4),%ebp
 100f833:	mov    %ebp,(%rdx,%r15,4)
 100f837:	mov    0x68(%rsp),%r15
 100f83c:	lea    (%r15,%rax,1),%ebp
 100f840:	add    $0xfffffffffffffff8,%r15
 100f844:	mov    %ebp,(%r12,%rbx,4)
 100f848:	mov    0x20(%rsp),%rbp
 100f84d:	cmp    %r14d,%eax
 100f850:	jne    100f710 <check_program+0x57f0>
 100f856:	lea    0x300(%rsp),%rsi
 100f85e:	mov    0x38(%rsp),%r14
 100f863:	mov    0x188(%rsp),%r15
 100f86b:	mov    0xe8(%rsp),%r12
 100f873:	mov    (%rsi),%rax
 100f876:	test   %rax,%rax
 100f879:	je     100fbd6 <check_program+0x5cb6>
 100f87f:	mov    0x18(%rax),%edx
 100f882:	test   %rdx,%rdx
 100f885:	je     100fbd6 <check_program+0x5cb6>
 100f88b:	cmpl   $0x0,0x10(%rsp)
 100f890:	mov    %rdx,%rcx
 100f893:	setne  %al
 100f896:	test   $0x1,%dl
 100f899:	je     100fbd1 <check_program+0x5cb1>
 100f89f:	mov    (%rsi),%rsi
 100f8a2:	lea    -0x1(%rdx),%rcx
 100f8a6:	mov    0x8(%rsi),%rsi
 100f8aa:	mov    -0x4(%rsi,%rdx,4),%esi
 100f8ae:	cmp    0x10(%rsp),%esi
 100f8b2:	jae    100fba5 <check_program+0x5c85>
 100f8b8:	mov    0x2b0(%rbp),%r8
 100f8bf:	mov    0x280(%rbp),%rdi
 100f8c6:	mov    0x10(%rsp),%r10
 100f8cb:	mov    (%r8,%rsi,4),%r8d
 100f8cf:	movzbl (%rdi,%rsi,1),%edi
 100f8d3:	dec    %r8d
 100f8d6:	cmp    %r10d,%r8d
 100f8d9:	setb   %r9b
 100f8dd:	test   %dil,%dil
 100f8e0:	jne    100fb6d <check_program+0x5c4d>
 100f8e6:	cmp    %r10d,%r8d
 100f8e9:	jae    100fb6d <check_program+0x5c4d>
 100f8ef:	mov    0x50(%r14),%r11
 100f8f3:	mov    %r8d,%r10d
 100f8f6:	mov    $0x1,%r9b
 100f8f9:	mov    %eax,%ebp
 100f8fb:	cmpb   $0x1e,(%r11,%r10,1)
 100f900:	je     100fb6f <check_program+0x5c4f>
 100f906:	mov    0x60(%r14),%r8
 100f90a:	mov    0x10(%rsp),%rbx
 100f90f:	mov    $0x1,%r14d
 100f915:	mov    (%r8,%r10,4),%r10d
 100f919:	cmp    %ebx,%r14d
 100f91c:	setb   %bpl
 100f920:	cmp    %ebx,%r10d
 100f923:	setb   %r9b
 100f927:	jae    100f93e <check_program+0x5a1e>
 100f929:	cmp    %ebx,%r14d
 100f92c:	jae    100f93e <check_program+0x5a1e>
 100f92e:	inc    %r14d
 100f931:	cmpb   $0x1e,(%r11,%r10,1)
 100f936:	jne    100f915 <check_program+0x59f5>
 100f938:	mov    $0x1,%r9b
 100f93b:	mov    $0x1,%bpl
 100f93e:	mov    %r10d,%r8d
 100f941:	mov    0x38(%rsp),%r14
 100f946:	jmp    100fb6f <check_program+0x5c4f>
 100f94b:	add    %rcx,%rdx
 100f94e:	mov    %rdx,0x8(%r8)
 100f952:	cmpl   $0x0,0xb0(%r12)
 100f95b:	sete   %cl
 100f95e:	cmpl   $0x0,0x10(%rsp)
 100f963:	mov    %rax,0x80(%r12)
 100f96b:	sete   %dl
 100f96e:	test   %rax,%rax
 100f971:	setne  %al
 100f974:	or     %cl,%al
 100f976:	mov    %eax,%ecx
 100f978:	not    %cl
 100f97a:	or     %dl,%cl
 100f97c:	test   $0x1,%cl
 100f97f:	jne    100fb04 <check_program+0x5be4>
 100f985:	mov    0xcc(%rsp),%ecx
 100f98c:	mov    $0x2,%edi
 100f991:	mov    $0x1,%edx
 100f996:	cmp    $0x3,%ecx
 100f999:	cmovae %ecx,%edi
 100f99c:	lea    -0x1(%rdi),%rsi
 100f9a0:	add    $0xfffffffe,%edi
 100f9a3:	mov    %esi,%ecx
 100f9a5:	and    $0x7,%ecx
 100f9a8:	cmp    $0x7,%edi
 100f9ab:	jb     100fad6 <check_program+0x5bb6>
 100f9b1:	and    $0xfffffffffffffff8,%rsi
 100f9b5:	xor    %edx,%edx
 100f9b7:	jmp    100f9cd <check_program+0x5aad>
 100f9b9:	nopl   0x0(%rax)
 100f9c0:	add    $0x8,%rdx
 100f9c4:	cmp    %rdx,%rsi
 100f9c7:	je     100face <check_program+0x5bae>
 100f9cd:	mov    0x78(%r12),%rdi
 100f9d2:	mov    0x4(%rdi,%rdx,4),%edi
 100f9d6:	test   %edi,%edi
 100f9d8:	je     100f9ec <check_program+0x5acc>
 100f9da:	mov    0x80(%r12),%r8
 100f9e2:	dec    %edi
 100f9e4:	lea    0x1(%rdx),%r9d
 100f9e8:	mov    %r9d,(%r8,%rdi,4)
 100f9ec:	mov    0x78(%r12),%rdi
 100f9f1:	mov    0x8(%rdi,%rdx,4),%edi
 100f9f5:	test   %edi,%edi
 100f9f7:	je     100fa0b <check_program+0x5aeb>
 100f9f9:	mov    0x80(%r12),%r8
 100fa01:	dec    %edi
 100fa03:	lea    0x2(%rdx),%r9d
 100fa07:	mov    %r9d,(%r8,%rdi,4)
 100fa0b:	mov    0x78(%r12),%rdi
 100fa10:	mov    0xc(%rdi,%rdx,4),%edi
 100fa14:	test   %edi,%edi
 100fa16:	je     100fa2a <check_program+0x5b0a>
 100fa18:	mov    0x80(%r12),%r8
 100fa20:	dec    %edi
 100fa22:	lea    0x3(%rdx),%r9d
 100fa26:	mov    %r9d,(%r8,%rdi,4)
 100fa2a:	mov    0x78(%r12),%rdi
 100fa2f:	mov    0x10(%rdi,%rdx,4),%edi
 100fa33:	test   %edi,%edi
 100fa35:	je     100fa49 <check_program+0x5b29>
 100fa37:	mov    0x80(%r12),%r8
 100fa3f:	dec    %edi
 100fa41:	lea    0x4(%rdx),%r9d
 100fa45:	mov    %r9d,(%r8,%rdi,4)
 100fa49:	mov    0x78(%r12),%rdi
 100fa4e:	mov    0x14(%rdi,%rdx,4),%edi
 100fa52:	test   %edi,%edi
 100fa54:	je     100fa68 <check_program+0x5b48>
 100fa56:	mov    0x80(%r12),%r8
 100fa5e:	dec    %edi
 100fa60:	lea    0x5(%rdx),%r9d
 100fa64:	mov    %r9d,(%r8,%rdi,4)
 100fa68:	mov    0x78(%r12),%rdi
 100fa6d:	mov    0x18(%rdi,%rdx,4),%edi
 100fa71:	test   %edi,%edi
 100fa73:	je     100fa87 <check_program+0x5b67>
 100fa75:	mov    0x80(%r12),%r8
 100fa7d:	dec    %edi
 100fa7f:	lea    0x6(%rdx),%r9d
 100fa83:	mov    %r9d,(%r8,%rdi,4)
 100fa87:	mov    0x78(%r12),%rdi
 100fa8c:	mov    0x1c(%rdi,%rdx,4),%edi
 100fa90:	test   %edi,%edi
 100fa92:	je     100faa6 <check_program+0x5b86>
 100fa94:	mov    0x80(%r12),%r8
 100fa9c:	dec    %edi
 100fa9e:	lea    0x7(%rdx),%r9d
 100faa2:	mov    %r9d,(%r8,%rdi,4)
 100faa6:	mov    0x78(%r12),%rdi
 100faab:	mov    0x20(%rdi,%rdx,4),%edi
 100faaf:	test   %edi,%edi
 100fab1:	je     100f9c0 <check_program+0x5aa0>
 100fab7:	mov    0x80(%r12),%r8
 100fabf:	dec    %edi
 100fac1:	lea    0x8(%rdx),%r9d
 100fac5:	mov    %r9d,(%r8,%rdi,4)
 100fac9:	jmp    100f9c0 <check_program+0x5aa0>
 100face:	test   %rcx,%rcx
 100fad1:	je     100fb04 <check_program+0x5be4>
 100fad3:	inc    %rdx
 100fad6:	shl    $0x2,%ecx
 100fad9:	jmp    100fae9 <check_program+0x5bc9>
 100fadb:	nopl   0x0(%rax,%rax,1)
 100fae0:	inc    %rdx
 100fae3:	add    $0xfffffffffffffffc,%rcx
 100fae7:	je     100fb04 <check_program+0x5be4>
 100fae9:	mov    0x78(%r12),%rsi
 100faee:	mov    (%rsi,%rdx,4),%esi
 100faf1:	test   %esi,%esi
 100faf3:	je     100fae0 <check_program+0x5bc0>
 100faf5:	mov    0x80(%r12),%rdi
 100fafd:	dec    %esi
 100faff:	mov    %edx,(%rdi,%rsi,4)
 100fb02:	jmp    100fae0 <check_program+0x5bc0>
 100fb04:	test   $0x1,%al
 100fb06:	je     100d662 <check_program+0x3742>
 100fb0c:	cmpl   $0x0,0xbc(%r12)
 100fb15:	jne    100d662 <check_program+0x3742>
 100fb1b:	mov    0x40(%rsp),%rax
 100fb20:	mov    0x8(%rax),%rax
 100fb24:	sub    0x178(%rsp),%rax
 100fb2c:	mov    %rax,(%r14)
 100fb2f:	mov    $0x1,%al
 100fb31:	mov    0x328(%rsp),%rcx
 100fb39:	mov    0x170(%rsp),%rdx
 100fb41:	cmp    0x8(%rcx),%rdx
 100fb45:	jbe    100d776 <check_program+0x3856>
 100fb4b:	lea    -0x917844(%rip),%rdi        # 6f830e <pp_string_value.meaning+0x6fb0d>
 100fb52:	lea    -0x95e592(%rip),%rsi        # 6b15c7 <pp_string_value.meaning+0x28dc6>
 100fb59:	lea    -0x95e57e(%rip),%rcx        # 6b15e2 <pp_string_value.meaning+0x28de1>
 100fb60:	mov    $0xbd,%edx
 100fb65:	vzeroupper
 100fb68:	call   787c60 <__assert_fail@plt>
 100fb6d:	mov    %eax,%ebp
 100fb6f:	test   %dil,%dil
 100fb72:	je     100fb84 <check_program+0x5c64>
 100fb74:	mov    0x20(%rsp),%rbp
 100fb79:	movl   $0xffffffff,-0x4(%r12,%rdx,4)
 100fb82:	jmp    100fbc9 <check_program+0x5ca9>
 100fb84:	test   %bpl,%r9b
 100fb87:	mov    0x20(%rsp),%rbp
 100fb8c:	je     100fba5 <check_program+0x5c85>
 100fb8e:	mov    0x70(%rsp),%r9
 100fb93:	mov    %r8d,%esi
 100fb96:	mov    (%r9,%rsi,4),%edi
 100fb9a:	mov    %edi,-0x4(%r12,%rdx,4)
 100fb9f:	mov    %ecx,(%r9,%rsi,4)
 100fba3:	jmp    100fbc9 <check_program+0x5ca9>
 100fba5:	mov    0x8(%rsp),%rdi
 100fbaa:	cmpl   $0x0,0xbc(%rdi)
 100fbb1:	jne    100fbc9 <check_program+0x5ca9>
 100fbb3:	movl   $0x1,0xbc(%rdi)
 100fbbd:	mov    %esi,0xb4(%rdi)
 100fbc3:	mov    %esi,0xb8(%rdi)
 100fbc9:	lea    0x300(%rsp),%rsi
 100fbd1:	cmp    $0x1,%edx
 100fbd4:	jne    100fc19 <check_program+0x5cf9>
 100fbd6:	cmpl   $0x0,0x10(%rsp)
 100fbdb:	mov    0x118(%rsp),%r11
 100fbe3:	je     1010009 <check_program+0x60e9>
 100fbe9:	mov    0x10(%rsp),%rax
 100fbee:	neg    %eax
 100fbf0:	jmp    100fe99 <check_program+0x5f79>
 100fbf5:	mov    %eax,%ebp
 100fbf7:	test   %dil,%dil
 100fbfa:	je     100fe0c <check_program+0x5eec>
 100fc00:	mov    0x20(%rsp),%rbp
 100fc05:	movl   $0xffffffff,(%r12,%rdx,4)
 100fc0d:	lea    0x300(%rsp),%rsi
 100fc15:	test   %ecx,%ecx
 100fc17:	je     100fbd6 <check_program+0x5cb6>
 100fc19:	mov    (%rsi),%rsi
 100fc1c:	lea    -0x1(%rcx),%rdx
 100fc20:	mov    0x8(%rsi),%rdi
 100fc24:	mov    %edx,%esi
 100fc26:	mov    (%rdi,%rsi,4),%edi
 100fc29:	cmp    0x10(%rsp),%edi
 100fc2d:	jae    100fd00 <check_program+0x5de0>
 100fc33:	mov    0x2b0(%rbp),%r9
 100fc3a:	mov    0x280(%rbp),%r8
 100fc41:	mov    0x10(%rsp),%r11
 100fc46:	mov    (%r9,%rdi,4),%r9d
 100fc4a:	movzbl (%r8,%rdi,1),%r8d
 100fc4f:	dec    %r9d
 100fc52:	cmp    %r11d,%r9d
 100fc55:	setb   %r10b
 100fc59:	test   %r8b,%r8b
 100fc5c:	jne    100fd2b <check_program+0x5e0b>
 100fc62:	cmp    %r11d,%r9d
 100fc65:	jae    100fcd0 <check_program+0x5db0>
 100fc67:	mov    0x50(%r14),%r14
 100fc6b:	mov    %r9d,%r11d
 100fc6e:	mov    $0x1,%r10b
 100fc71:	mov    %eax,%ebp
 100fc73:	cmpb   $0x1e,(%r14,%r11,1)
 100fc78:	je     100fd2d <check_program+0x5e0d>
 100fc7e:	mov    0x38(%rsp),%r9
 100fc83:	mov    $0x1,%r13d
 100fc89:	mov    0x60(%r9),%r9
 100fc8d:	nopl   (%rax)
 100fc90:	mov    0x10(%rsp),%rbx
 100fc95:	mov    (%r9,%r11,4),%r11d
 100fc99:	cmp    %ebx,%r13d
 100fc9c:	setb   %bpl
 100fca0:	cmp    %ebx,%r11d
 100fca3:	setb   %r10b
 100fca7:	jae    100fe62 <check_program+0x5f42>
 100fcad:	cmp    %ebx,%r13d
 100fcb0:	jae    100fe62 <check_program+0x5f42>
 100fcb6:	inc    %r13d
 100fcb9:	cmpb   $0x1e,(%r14,%r11,1)
 100fcbe:	jne    100fc90 <check_program+0x5d70>
 100fcc0:	mov    $0x1,%r10b
 100fcc3:	mov    %r11d,%r9d
 100fcc6:	mov    $0x1,%bpl
 100fcc9:	test   %r8b,%r8b
 100fccc:	jne    100fd32 <check_program+0x5e12>
 100fcce:	jmp    100fcd7 <check_program+0x5db7>
 100fcd0:	mov    %eax,%ebp
 100fcd2:	test   %r8b,%r8b
 100fcd5:	jne    100fd32 <check_program+0x5e12>
 100fcd7:	and    %bpl,%r10b
 100fcda:	mov    0x38(%rsp),%r14
 100fcdf:	mov    0x20(%rsp),%rbp
 100fce4:	cmp    $0x1,%r10b
 100fce8:	jne    100fd00 <check_program+0x5de0>
 100fcea:	mov    0x70(%rsp),%r10
 100fcef:	mov    %r9d,%edi
 100fcf2:	mov    (%r10,%rdi,4),%r8d
 100fcf6:	mov    %r8d,(%r12,%rsi,4)
 100fcfa:	mov    %edx,(%r10,%rdi,4)
 100fcfe:	jmp    100fd44 <check_program+0x5e24>
 100fd00:	mov    0x8(%rsp),%rdx
 100fd05:	cmpl   $0x0,0xbc(%rdx)
 100fd0c:	jne    100fd44 <check_program+0x5e24>
 100fd0e:	mov    0x8(%rsp),%rdx
 100fd13:	movl   $0x1,0xbc(%rdx)
 100fd1d:	mov    %edi,0xb4(%rdx)
 100fd23:	mov    %edi,0xb8(%rdx)
 100fd29:	jmp    100fd44 <check_program+0x5e24>
 100fd2b:	mov    %eax,%ebp
 100fd2d:	test   %r8b,%r8b
 100fd30:	je     100fcd7 <check_program+0x5db7>
 100fd32:	mov    0x38(%rsp),%r14
 100fd37:	mov    0x20(%rsp),%rbp
 100fd3c:	movl   $0xffffffff,(%r12,%rsi,4)
 100fd44:	lea    0x300(%rsp),%rdx
 100fd4c:	add    $0xfffffffffffffffe,%rcx
 100fd50:	mov    (%rdx),%rdx
 100fd53:	mov    0x8(%rdx),%rsi
 100fd57:	mov    %ecx,%edx
 100fd59:	mov    (%rsi,%rdx,4),%esi
 100fd5c:	cmp    0x10(%rsp),%esi
 100fd60:	jae    100fe30 <check_program+0x5f10>
 100fd66:	mov    0x2b0(%rbp),%r8
 100fd6d:	mov    0x280(%rbp),%rdi
 100fd74:	mov    0x10(%rsp),%r10
 100fd79:	mov    (%r8,%rsi,4),%r8d
 100fd7d:	movzbl (%rdi,%rsi,1),%edi
 100fd81:	dec    %r8d
 100fd84:	cmp    %r10d,%r8d
 100fd87:	setb   %r9b
 100fd8b:	test   %dil,%dil
 100fd8e:	jne    100fe01 <check_program+0x5ee1>
 100fd90:	cmp    %r10d,%r8d
 100fd93:	jae    100fbf5 <check_program+0x5cd5>
 100fd99:	mov    0x50(%r14),%r11
 100fd9d:	mov    %r8d,%r10d
 100fda0:	mov    $0x1,%r9b
 100fda3:	mov    %eax,%ebp
 100fda5:	cmpb   $0x1e,(%r11,%r10,1)
 100fdaa:	je     100fe03 <check_program+0x5ee3>
 100fdac:	mov    0x60(%r14),%r8
 100fdb0:	mov    $0x1,%r14d
 100fdb6:	cs nopw 0x0(%rax,%rax,1)
 100fdc0:	mov    0x10(%rsp),%rbx
 100fdc5:	mov    (%r8,%r10,4),%r10d
 100fdc9:	cmp    %ebx,%r14d
 100fdcc:	setb   %bpl
 100fdd0:	cmp    %ebx,%r10d
 100fdd3:	setb   %r9b
 100fdd7:	jae    100fdee <check_program+0x5ece>
 100fdd9:	cmp    %ebx,%r14d
 100fddc:	jae    100fdee <check_program+0x5ece>
 100fdde:	inc    %r14d
 100fde1:	cmpb   $0x1e,(%r11,%r10,1)
 100fde6:	jne    100fdc0 <check_program+0x5ea0>
 100fde8:	mov    $0x1,%r9b
 100fdeb:	mov    $0x1,%bpl
 100fdee:	mov    %r10d,%r8d
 100fdf1:	mov    0x38(%rsp),%r14
 100fdf6:	test   %dil,%dil
 100fdf9:	jne    100fc00 <check_program+0x5ce0>
 100fdff:	jmp    100fe0c <check_program+0x5eec>
 100fe01:	mov    %eax,%ebp
 100fe03:	test   %dil,%dil
 100fe06:	jne    100fc00 <check_program+0x5ce0>
 100fe0c:	test   %bpl,%r9b
 100fe0f:	mov    0x20(%rsp),%rbp
 100fe14:	je     100fe30 <check_program+0x5f10>
 100fe16:	mov    0x70(%rsp),%r9
 100fe1b:	mov    %r8d,%esi
 100fe1e:	mov    (%r9,%rsi,4),%edi
 100fe22:	mov    %edi,(%r12,%rdx,4)
 100fe26:	mov    %ecx,(%r9,%rsi,4)
 100fe2a:	jmp    100fc0d <check_program+0x5ced>
 100fe2f:	nop
 100fe30:	mov    0x8(%rsp),%rdx
 100fe35:	cmpl   $0x0,0xbc(%rdx)
 100fe3c:	jne    100fc0d <check_program+0x5ced>
 100fe42:	mov    0x8(%rsp),%rdx
 100fe47:	movl   $0x1,0xbc(%rdx)
 100fe51:	mov    %esi,0xb4(%rdx)
 100fe57:	mov    %esi,0xb8(%rdx)
 100fe5d:	jmp    100fc0d <check_program+0x5ced>
 100fe62:	mov    %r11d,%r9d
 100fe65:	test   %r8b,%r8b
 100fe68:	jne    100fd32 <check_program+0x5e12>
 100fe6e:	jmp    100fcd7 <check_program+0x5db7>
 100fe73:	mov    0x8(%rsp),%rcx
 100fe78:	cmpl   $0x0,0xbc(%rcx)
 100fe7f:	je     100ffe7 <check_program+0x60c7>
 100fe85:	data16 cs nopw 0x0(%rax,%rax,1)
 100fe90:	test   %r11d,%r11d
 100fe93:	je     1010009 <check_program+0x60e9>
 100fe99:	mov    0x238(%rbp),%rsi
 100fea0:	mov    %r11,%rcx
 100fea3:	dec    %r11
 100fea6:	mov    %r11d,%edx
 100fea9:	cmp    %r11d,(%rsi,%rdx,4)
 100fead:	jne    100fe90 <check_program+0x5f70>
 100feaf:	mov    0x2e0(%rbp),%rsi
 100feb6:	mov    0x10(%rsp),%rdi
 100febb:	cmp    %edi,(%rsi,%rdx,4)
 100febe:	jae    100fe90 <check_program+0x5f70>
 100fec0:	mov    0x248(%rbp),%rsi
 100fec7:	cmpb   $0x1,(%rsi,%rdx,1)
 100fecb:	jne    100fe90 <check_program+0x5f70>
 100fecd:	mov    0x268(%rbp),%rsi
 100fed4:	cmpb   $0x0,(%rsi,%rdx,1)
 100fed8:	jne    100fe90 <check_program+0x5f70>
 100feda:	mov    0x240(%rbp),%rsi
 100fee1:	mov    (%rsi,%rdx,4),%edi
 100fee4:	mov    (%r15),%rsi
 100fee7:	mov    %edi,%r8d
 100feea:	shr    $0x3,%r8d
 100feee:	cmpb   $0xf,(%rsi,%r8,1)
 100fef3:	jne    100ff06 <check_program+0x5fe6>
 100fef5:	mov    0x20(%r15),%rdi
 100fef9:	mov    (%rdi,%r8,4),%edi
 100fefd:	jmp    100ff06 <check_program+0x5fe6>
 100feff:	nop
 100ff00:	cmp    $0xa,%r8b
 100ff04:	je     100ff38 <check_program+0x6018>
 100ff06:	shr    $0x3,%edi
 100ff09:	movzbl (%rsi,%rdi,1),%r8d
 100ff0e:	lea    -0x8(%r8),%r9d
 100ff12:	cmp    $0x2,%r9b
 100ff16:	ja     100fe90 <check_program+0x5f70>
 100ff1c:	mov    0x20(%r15),%r9
 100ff20:	mov    (%r9,%rdi,4),%edi
 100ff24:	mov    %edi,%r10d
 100ff27:	shr    $0x3,%r10d
 100ff2b:	cmpb   $0xf,(%rsi,%r10,1)
 100ff30:	jne    100ff00 <check_program+0x5fe0>
 100ff32:	mov    (%r9,%r10,4),%edi
 100ff36:	jmp    100ff00 <check_program+0x5fe0>
 100ff38:	cmp    %r11d,0x10(%rsp)
 100ff3d:	jbe    100fe73 <check_program+0x5f53>
 100ff43:	mov    0x50(%r14),%r8
 100ff47:	mov    $0x1,%edi
 100ff4c:	mov    %r11d,%esi
 100ff4f:	nop
 100ff50:	mov    %esi,%r9d
 100ff53:	cmpb   $0x1e,(%r8,%r9,1)
 100ff58:	je     100ff83 <check_program+0x6063>
 100ff5a:	mov    0x60(%r14),%rsi
 100ff5e:	mov    (%rsi,%r9,4),%esi
 100ff62:	cmp    0x10(%rsp),%esi
 100ff66:	jae    100fe73 <check_program+0x5f53>
 100ff6c:	mov    %edi,%r9d
 100ff6f:	lea    0x1(%rax,%r9,1),%r9d
 100ff74:	inc    %edi
 100ff76:	cmp    $0x1,%r9d
 100ff7a:	jne    100ff50 <check_program+0x6030>
 100ff7c:	mov    0xcc(%rsp),%edi
 100ff83:	cmp    0x10(%rsp),%edi
 100ff87:	jae    100fe73 <check_program+0x5f53>
 100ff8d:	mov    0x60(%r14),%rdi
 100ff91:	mov    0x10(%rsp),%r8
 100ff96:	mov    %esi,%esi
 100ff98:	cmp    %r8d,(%rdi,%rsi,4)
 100ff9c:	jae    100fe73 <check_program+0x5f53>
 100ffa2:	mov    0xf0(%rsp),%r8
 100ffaa:	mov    0x120(%rsp),%r9
 100ffb2:	mov    (%r8,%rsi,4),%edi
 100ffb6:	mov    %edi,(%r9,%rdx,4)
 100ffba:	mov    %r11d,(%r8,%rsi,4)
 100ffbe:	mov    0xd0(%rsp),%rdi
 100ffc6:	mov    0x60(%r14),%rdx
 100ffca:	mov    (%rdx,%rsi,4),%edx
 100ffcd:	mov    %ecx,(%rdi,%rdx,4)
 100ffd0:	mov    0xc0(%rsp),%rdi
 100ffd8:	mov    0x60(%r14),%rdx
 100ffdc:	mov    (%rdx,%rsi,4),%edx
 100ffdf:	mov    %ecx,(%rdi,%rdx,4)
 100ffe2:	jmp    100fe90 <check_program+0x5f70>
 100ffe7:	mov    0x8(%rsp),%rcx
 100ffec:	movl   $0x1,0xbc(%rcx)
 100fff6:	mov    %r11d,0xb4(%rcx)
 100fffd:	mov    %r11d,0xb8(%rcx)
 1010004:	jmp    100fe90 <check_program+0x5f70>
 1010009:	mov    0x338(%rbp),%eax
 101000f:	mov    0x90(%rsp),%r13
 1010017:	mov    0xe0(%rsp),%rbx
 101001f:	mov    0x150(%rsp),%r12
 1010027:	mov    0x50(%rsp),%r11d
 101002c:	test   %rax,%rax
 101002f:	jne    1010118 <check_program+0x61f8>
 1010035:	test   %r11d,%r11d
 1010038:	je     101005b <check_program+0x613b>
 101003a:	mov    0x40(%rsp),%rsi
 101003f:	mov    (%rsi),%rcx
 1010042:	mov    0x8(%rsi),%rdx
 1010046:	lea    0x3(%rdx,%rcx,1),%rax
 101004b:	add    %rcx,%rdx
 101004e:	and    $0xfffffffffffffffc,%rax
 1010052:	cmp    %rdx,%rax
 1010055:	jae    1010425 <check_program+0x6505>
 101005b:	xor    %ecx,%ecx
 101005d:	mov    0x8(%rsp),%rax
 1010062:	mov    %rcx,0x40(%rax)
 1010066:	mov    0x328(%rbp),%ecx
 101006c:	test   %rcx,%rcx
 101006f:	je     10100b7 <check_program+0x6197>
 1010071:	mov    0x40(%rsp),%r8
 1010076:	mov    (%r8),%rsi
 1010079:	mov    0x8(%r8),%rdx
 101007d:	lea    0x3(%rdx,%rsi,1),%rax
 1010082:	add    %rsi,%rdx
 1010085:	and    $0xfffffffffffffffc,%rax
 1010089:	cmp    %rdx,%rax
 101008c:	jb     10100b7 <check_program+0x6197>
 101008e:	mov    %rax,%rdx
 1010091:	sub    %rsi,%rdx
 1010094:	mov    0x10(%r8),%rsi
 1010098:	shl    $0x2,%rcx
 101009c:	lea    (%rcx,%rcx,4),%rcx
 10100a0:	sub    %rdx,%rsi
 10100a3:	setb   %dil
 10100a7:	cmp    %rsi,%rcx
 10100aa:	seta   %sil
 10100ae:	or     %dil,%sil
 10100b1:	je     101049c <check_program+0x657c>
 10100b7:	xor    %eax,%eax
 10100b9:	mov    0x8(%rsp),%rcx
 10100be:	mov    0x40(%rsp),%rsi
 10100c3:	mov    0x110(%rsp),%rdi
 10100cb:	mov    %rax,0x50(%rcx)
 10100cf:	mov    0x328(%rbp),%eax
 10100d5:	mov    %eax,0x9c(%rcx)
 10100db:	mov    (%rsi),%rcx
 10100de:	mov    0x8(%rsi),%rdx
 10100e2:	lea    0x3(%rdx,%rcx,1),%rax
 10100e7:	add    %rcx,%rdx
 10100ea:	and    $0xfffffffffffffffc,%rax
 10100ee:	cmp    %rdx,%rax
 10100f1:	jae    1010254 <check_program+0x6334>
 10100f7:	xor    %ecx,%ecx
 10100f9:	jmp    1010279 <check_program+0x6359>
 10100fe:	xchg   %ax,%ax
 1010100:	mov    0x8(%rsp),%rdx
 1010105:	cmpl   $0x0,0xbc(%rdx)
 101010c:	je     101017b <check_program+0x625b>
 101010e:	xchg   %ax,%ax
 1010110:	test   %eax,%eax
 1010112:	je     1010035 <check_program+0x6115>
 1010118:	mov    0x330(%rbp),%rcx
 101011f:	dec    %rax
 1010122:	mov    %eax,%edx
 1010124:	lea    (%rdx,%rdx,8),%rsi
 1010128:	cmpb   $0x1,0x20(%rcx,%rsi,4)
 101012d:	jne    1010110 <check_program+0x61f0>
 101012f:	lea    (%rcx,%rsi,4),%rcx
 1010133:	mov    (%rcx),%esi
 1010135:	cmp    $0xffffffff,%esi
 1010138:	je     1010110 <check_program+0x61f0>
 101013a:	mov    0x14(%rcx),%r8d
 101013e:	cmp    %r8d,0x18(%rcx)
 1010142:	cmove  %r8d,%esi
 1010146:	cmp    0x10(%rsp),%esi
 101014a:	jae    1010100 <check_program+0x61e0>
 101014c:	xor    %edi,%edi
 101014e:	xchg   %ax,%ax
 1010150:	cmp    %r8d,%esi
 1010153:	je     101019e <check_program+0x627e>
 1010155:	cmp    %edi,0x10(%rsp)
 1010159:	je     10101ac <check_program+0x628c>
 101015b:	mov    0x50(%r14),%r10
 101015f:	mov    %esi,%r9d
 1010162:	cmpb   $0x1e,(%r10,%r9,1)
 1010167:	je     10101bf <check_program+0x629f>
 1010169:	mov    0x60(%r14),%rsi
 101016d:	inc    %edi
 101016f:	mov    (%rsi,%r9,4),%esi
 1010173:	cmp    0x10(%rsp),%esi
 1010177:	jb     1010150 <check_program+0x6230>
 1010179:	jmp    1010100 <check_program+0x61e0>
 101017b:	mov    0x8(%rcx),%ecx
 101017e:	mov    0x8(%rsp),%rdx
 1010183:	movl   $0x1,0xbc(%rdx)
 101018d:	mov    %ecx,0xb4(%rdx)
 1010193:	mov    %ecx,0xb8(%rdx)
 1010199:	jmp    1010110 <check_program+0x61f0>
 101019e:	mov    %r8d,%esi
 10101a1:	cmp    0x10(%rsp),%edi
 10101a5:	jb     10101cb <check_program+0x62ab>
 10101a7:	jmp    1010100 <check_program+0x61e0>
 10101ac:	mov    0xcc(%rsp),%edi
 10101b3:	cmp    0x10(%rsp),%edi
 10101b7:	jae    1010100 <check_program+0x61e0>
 10101bd:	jmp    10101cb <check_program+0x62ab>
 10101bf:	inc    %edi
 10101c1:	cmp    0x10(%rsp),%edi
 10101c5:	jae    1010100 <check_program+0x61e0>
 10101cb:	mov    0x10(%rcx),%edi
 10101ce:	cmp    0x98(%rsp),%edi
 10101d5:	jae    1010100 <check_program+0x61e0>
 10101db:	mov    0x0(%rbp),%r8
 10101df:	cmpl   $0x39,(%r8,%rdi,4)
 10101e4:	jne    1010100 <check_program+0x61e0>
 10101ea:	mov    0x130(%rsp),%r8
 10101f2:	mov    %esi,%esi
 10101f4:	mov    0xd8(%rsp),%r9
 10101fc:	mov    (%r8,%rsi,4),%edi
 1010200:	mov    %edi,(%r9,%rdx,4)
 1010204:	mov    %eax,(%r8,%rsi,4)
 1010208:	mov    0x60(%r14),%rdx
 101020c:	mov    (%rdx,%rsi,4),%edx
 101020f:	cmp    0x10(%rsp),%edx
 1010213:	jae    1010110 <check_program+0x61f0>
 1010219:	mov    (%rcx),%esi
 101021b:	mov    0xd0(%rsp),%rdi
 1010223:	inc    %esi
 1010225:	cmp    %esi,(%rdi,%rdx,4)
 1010228:	jne    1010110 <check_program+0x61f0>
 101022e:	mov    0xc(%rcx),%ecx
 1010231:	mov    0xc0(%rsp),%rsi
 1010239:	cmp    (%rsi,%rdx,4),%ecx
 101023c:	jb     1010110 <check_program+0x61f0>
 1010242:	mov    0xc0(%rsp),%rsi
 101024a:	inc    %ecx
 101024c:	mov    %ecx,(%rsi,%rdx,4)
 101024f:	jmp    1010110 <check_program+0x61f0>
 1010254:	mov    0x10(%rsi),%rsi
 1010258:	mov    %rax,%rdx
 101025b:	sub    %rcx,%rdx
 101025e:	xor    %ecx,%ecx
 1010260:	sub    %rdx,%rsi
 1010263:	jb     1010279 <check_program+0x6359>
 1010265:	cmp    %rsi,%rdi
 1010268:	ja     1010279 <check_program+0x6359>
 101026a:	mov    0x40(%rsp),%rcx
 101026f:	add    %rdi,%rdx
 1010272:	mov    %rdx,0x8(%rcx)
 1010276:	mov    %rax,%rcx
 1010279:	mov    0x8(%rsp),%rax
 101027e:	mov    0x40(%rsp),%rsi
 1010283:	mov    %rcx,0x78(%rax)
 1010287:	mov    (%rsi),%rcx
 101028a:	mov    0x8(%rsi),%rdx
 101028e:	lea    0x3(%rdx,%rcx,1),%rax
 1010293:	add    %rcx,%rdx
 1010296:	and    $0xfffffffffffffffc,%rax
 101029a:	cmp    %rdx,%rax
 101029d:	jae    10102a3 <check_program+0x6383>
 101029f:	xor    %ecx,%ecx
 10102a1:	jmp    10102c8 <check_program+0x63a8>
 10102a3:	mov    0x10(%rsi),%rsi
 10102a7:	mov    %rax,%rdx
 10102aa:	sub    %rcx,%rdx
 10102ad:	xor    %ecx,%ecx
 10102af:	sub    %rdx,%rsi
 10102b2:	jb     10102c8 <check_program+0x63a8>
 10102b4:	cmp    %rsi,%rdi
 10102b7:	ja     10102c8 <check_program+0x63a8>
 10102b9:	mov    0x40(%rsp),%rcx
 10102be:	add    %rdi,%rdx
 10102c1:	mov    %rdx,0x8(%rcx)
 10102c5:	mov    %rax,%rcx
 10102c8:	mov    0x8(%rsp),%rax
 10102cd:	mov    %rcx,0x88(%rax)
 10102d4:	mov    0x348(%rbp),%edx
 10102da:	test   %rdx,%rdx
 10102dd:	je     1010300 <check_program+0x63e0>
 10102df:	mov    0x40(%rsp),%rdi
 10102e4:	mov    (%rdi),%rcx
 10102e7:	mov    0x8(%rdi),%rsi
 10102eb:	lea    0x3(%rsi,%rcx,1),%rax
 10102f0:	add    %rcx,%rsi
 10102f3:	and    $0xfffffffffffffffc,%rax
 10102f7:	cmp    %rsi,%rax
 10102fa:	jae    1010462 <check_program+0x6542>
 1010300:	xor    %ecx,%ecx
 1010302:	mov    0x8(%rsp),%rax
 1010307:	mov    %rcx,0x68(%rax)
 101030b:	xor    %eax,%eax
 101030d:	mov    0x348(%rbp),%ecx
 1010313:	test   %rcx,%rcx
 1010316:	je     101036a <check_program+0x644a>
 1010318:	xor    %edx,%edx
 101031a:	xor    %esi,%esi
 101031c:	nopl   0x0(%rax)
 1010320:	mov    0x8(%rsp),%rcx
 1010325:	mov    0x68(%rcx),%rcx
 1010329:	test   %rcx,%rcx
 101032c:	je     100afe0 <check_program+0x10c0>
 1010332:	mov    %rax,%rdi
 1010335:	shr    $0x20,%rdi
 1010339:	jne    100afe0 <check_program+0x10c0>
 101033f:	mov    %eax,(%rcx,%rsi,4)
 1010342:	inc    %rsi
 1010345:	mov    0x340(%rbp),%rcx
 101034c:	mov    0x34(%rcx,%rdx,1),%ecx
 1010350:	add    $0x50,%rdx
 1010354:	add    %rcx,%rax
 1010357:	mov    0x348(%rbp),%ecx
 101035d:	cmp    %rcx,%rsi
 1010360:	jb     1010320 <check_program+0x6400>
 1010362:	test   %rcx,%rcx
 1010365:	sete   %dl
 1010368:	jmp    101036c <check_program+0x644c>
 101036a:	mov    $0x1,%dl
 101036c:	mov    %rax,%rsi
 101036f:	shr    $0x20,%rsi
 1010373:	jne    100afe0 <check_program+0x10c0>
 1010379:	test   %dl,%dl
 101037b:	jne    1010389 <check_program+0x6469>
 101037d:	mov    0x8(%rsp),%rdx
 1010382:	mov    0x68(%rdx),%rdx
 1010386:	mov    %eax,(%rdx,%rcx,4)
 1010389:	mov    0x8(%rsp),%rcx
 101038e:	mov    %eax,0xa8(%rcx)
 1010394:	test   %rax,%rax
 1010397:	je     10103ba <check_program+0x649a>
 1010399:	mov    0x40(%rsp),%rdi
 101039e:	mov    (%rdi),%rcx
 10103a1:	mov    0x8(%rdi),%rsi
 10103a5:	lea    0x3(%rsi,%rcx,1),%rdx
 10103aa:	add    %rcx,%rsi
 10103ad:	and    $0xfffffffffffffffc,%rdx
 10103b1:	cmp    %rsi,%rdx
 10103b4:	jae    10104a8 <check_program+0x6588>
 10103ba:	xor    %ecx,%ecx
 10103bc:	mov    0x8(%rsp),%rdx
 10103c1:	mov    0x88(%rsp),%rsi
 10103c9:	mov    %rcx,0x70(%rdx)
 10103cd:	test   %r11d,%r11d
 10103d0:	je     10103dd <check_program+0x64bd>
 10103d2:	cmpq   $0x0,0x40(%rdx)
 10103d7:	je     100afff <check_program+0x10df>
 10103dd:	cmpl   $0x0,0x328(%rbp)
 10103e4:	je     10103f1 <check_program+0x64d1>
 10103e6:	cmpq   $0x0,0x50(%rdx)
 10103eb:	je     100afff <check_program+0x10df>
 10103f1:	cmpq   $0x0,0x78(%rdx)
 10103f6:	je     100afff <check_program+0x10df>
 10103fc:	test   %rax,%rax
 10103ff:	sete   %al
 1010402:	test   %rcx,%rcx
 1010405:	setne  %cl
 1010408:	cmpq   $0x0,0x88(%rdx)
 1010410:	je     100afff <check_program+0x10df>
 1010416:	or     %cl,%al
 1010418:	mov    $0x1,%cl
 101041a:	jne    100b014 <check_program+0x10f4>
 1010420:	jmp    100afff <check_program+0x10df>
 1010425:	mov    0x10(%rsi),%rsi
 1010429:	mov    %rax,%rdx
 101042c:	sub    %rcx,%rdx
 101042f:	xor    %ecx,%ecx
 1010431:	sub    %rdx,%rsi
 1010434:	jb     101005d <check_program+0x613d>
 101043a:	mov    %r11d,%edi
 101043d:	shl    $0x2,%rdi
 1010441:	lea    (%rdi,%rdi,8),%rdi
 1010445:	cmp    %rsi,%rdi
 1010448:	ja     101005d <check_program+0x613d>
 101044e:	mov    0x40(%rsp),%rcx
 1010453:	add    %rdi,%rdx
 1010456:	mov    %rdx,0x8(%rcx)
 101045a:	mov    %rax,%rcx
 101045d:	jmp    101005d <check_program+0x613d>
 1010462:	mov    0x10(%rdi),%rdi
 1010466:	mov    %rax,%rsi
 1010469:	sub    %rcx,%rsi
 101046c:	xor    %ecx,%ecx
 101046e:	sub    %rsi,%rdi
 1010471:	jb     1010302 <check_program+0x63e2>
 1010477:	lea    0x4(,%rdx,4),%rdx
 101047f:	cmp    %rdi,%rdx
 1010482:	ja     1010302 <check_program+0x63e2>
 1010488:	mov    0x40(%rsp),%rcx
 101048d:	add    %rdx,%rsi
 1010490:	mov    %rsi,0x8(%rcx)
 1010494:	mov    %rax,%rcx
 1010497:	jmp    1010302 <check_program+0x63e2>
 101049c:	add    %rcx,%rdx
 101049f:	mov    %rdx,0x8(%r8)
 10104a3:	jmp    10100b9 <check_program+0x6199>
 10104a8:	mov    0x10(%rdi),%r8
 10104ac:	mov    %rdx,%rsi
 10104af:	sub    %rcx,%rsi
 10104b2:	xor    %ecx,%ecx
 10104b4:	sub    %rsi,%r8
 10104b7:	jb     10103bc <check_program+0x649c>
 10104bd:	lea    0x0(,%rax,4),%rdi
 10104c5:	cmp    %r8,%rdi
 10104c8:	ja     10103bc <check_program+0x649c>
 10104ce:	mov    0x40(%rsp),%rcx
 10104d3:	add    %rdi,%rsi
 10104d6:	mov    %rsi,0x8(%rcx)
 10104da:	mov    %rdx,%rcx
 10104dd:	jmp    10103bc <check_program+0x649c>
 10104e2:	mov    0x68(%rsp),%rcx
 10104e7:	test   %rcx,%rcx
 10104ea:	je     10104ff <check_program+0x65df>
 10104ec:	cmpl   $0x0,0x2c(%rcx)
 10104f0:	jne    100a047 <check_program+0x127>
 10104f6:	cmp    %eax,0x1c(%rcx)
 10104f9:	jne    100a047 <check_program+0x127>
 10104ff:	cmpl   $0x0,0x348(%rdx)
 1010506:	je     101051b <check_program+0x65fb>
 1010508:	test   %rsi,%rsi
 101050b:	je     100a047 <check_program+0x127>
 1010511:	cmpl   $0x0,0x10(%rsi)
 1010515:	jne    100a047 <check_program+0x127>
 101051b:	lea    0x300(%rsp),%rsi
 1010523:	cmpl   $0x0,0x20(%rsi)
 1010527:	sete   %cl
 101052a:	cmpq   $0x0,0x18(%rsi)
 101052f:	setne  %r12b
 1010533:	or     %cl,%r12b
 1010536:	jmp    100a04a <check_program+0x12a>
 101053b:	vzeroupper
 101053e:	call   787bf0 <__stack_chk_fail@plt>
