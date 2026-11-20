:
push   %rbp
push   %r15
push   %r14
push   %r13
push   %r12
push   %rbx
push   %rax
mov    %rdi,%rbx
xor    %r14d,%r14d
mov    $0x940,%edx
xor    %esi,%esi
call   
vmovaps -0x1a2d685(%rip),%ymm0        # 
vmovups %ymm0,0x1(%rbx)
vbroadcastsd -0x1a1e0eb(%rip),%ymm0        # 
vmovups %ymm0,0x201(%rbx)
vbroadcastsd -0x1a1e0f4(%rip),%ymm1        # 
vmovups %ymm1,0x401(%rbx)
vmovaps -0x1a252a4(%rip),%xmm2        # 
vmovups %xmm2,0x21(%rbx)
vmovups %xmm0,0x221(%rbx)
vmovups %xmm1,0x421(%rbx)
movl   $0x34333231,0x31(%rbx)
movabs $0x8080808080808080,%rax
mov    %rax,0x231(%rbx)
movabs $0x101010101010101,%rcx
mov    %rcx,0x431(%rbx)
movabs $0x3c3b3a3938373635,%rcx
mov    %rcx,0x35(%rbx)
movl   $0x80808080,0x239(%rbx)
movl   $0x1010101,0x439(%rbx)
movb   $0x3d,0x3d(%rbx)
movw   $0x8080,0x23d(%rbx)
movw   $0x101,0x43d(%rbx)
movw   $0x3f3e,0x3e(%rbx)
movb   $0x80,0x23f(%rbx)
movb   $0x1,0x43f(%rbx)
vmovaps -0x1a2d726(%rip),%ymm0        # 
vmovups %ymm0,0x540(%rbx)
vmovaps -0x1a2d716(%rip),%ymm0        # 
vmovups %ymm0,0x560(%rbx)
vmovaps -0x1a2d706(%rip),%ymm0        # 
vmovups %ymm0,0x900(%rbx)
vmovaps -0x1a2d6f6(%rip),%ymm0        # 
vmovups %ymm0,0x920(%rbx)
movb   $0x1,0x481(%rbx)
movw   $0x402,0x484(%rbx)
movb   $0x22,0x493(%rbx)
movl   $0x7f1c201e,0x48d(%rbx)
movw   $0x7f7f,0x491(%rbx)
movb   $0x7f,0x495(%rbx)
lea    -0x191d4b6(%rip),%rcx        # 
lea    -0x191d635(%rip),%rdx        # 
lea    -0x191d580(%rip),%rsi        # 
jmp    
mov    $0x1b,%dil
mov    %dil,0x780(%rbx,%r14,1)
xor    %edi,%edi
xor    %r8d,%r8d
cmp    $0x2b,%r14
sete   %r8b
lea    0x57(%rdi),%r9d
mov    %r9b,0x800(%rbx,%r14,1)
add    %edi,%r8d
add    $0x5b,%r8b
mov    %r8b,0x880(%rbx,%r14,1)
inc    %r14
cmp    $0x45,%r14
je     
xor    %edi,%edi
lea    -0x5(%r14),%r8d
cmp    $0x2e,%r8d
ja     
movslq (%rdx,%r8,4),%r8
add    %rdx,%r8
jmp    *%r8
mov    $0xb,%dil
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
jbe    
jmp    
mov    $0xf,%dil
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
jbe    
jmp    
mov    $0x13,%dil
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
jbe    
jmp    
mov    $0xd,%dil
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
jbe    
jmp    
mov    $0x10,%dil
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
jbe    
jmp    
mov    $0xc,%dil
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
jbe    
jmp    
mov    $0x12,%dil
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
jbe    
jmp    
mov    $0x11,%dil
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
jbe    
jmp    
mov    $0x14,%dil
nopl   0x0(%rax,%rax,1)
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
ja     
movslq (%rcx,%rdi,4),%rdi
add    %rcx,%rdi
jmp    *%rdi
mov    $0xb,%dil
jmp    
mov    $0xe,%dil
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
jbe    
jmp    
mov    $0x16,%dil
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
jbe    
jmp    
mov    $0x18,%dil
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
jbe    
jmp    
mov    $0x19,%dil
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
jbe    
jmp    
mov    $0x17,%dil
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
jbe    
jmp    
mov    $0x1a,%dil
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
jbe    
jmp    
mov    $0x1b,%dil
mov    %dil,0x4c0(%rbx,%r14,1)
lea    -0x5(%r14),%edi
cmp    $0x2e,%edi
ja     
nopw   0x0(%rax,%rax,1)
movslq (%rsi,%rdi,4),%rdi
add    %rsi,%rdi
jmp    *%rdi
mov    $0xc,%dil
jmp    
mov    $0x10,%dil
jmp    
mov    $0xe,%dil
jmp    
mov    $0x12,%dil
jmp    
mov    $0x11,%dil
jmp    
mov    $0xf,%dil
jmp    
mov    $0x13,%dil
jmp    
mov    $0xd,%dil
jmp    
mov    $0x14,%dil
jmp    
mov    $0x18,%dil
jmp    
xor    %edi,%edi
mov    %dil,0x780(%rbx,%r14,1)
lea    -0x26(%r14),%r8d
xor    %edi,%edi
cmp    $0x4,%r8d
setb   %dil
add    %edi,%edi
mov    $0x1,%r8d
cmp    $0x27,%r14d
je     
cmp    $0x29,%r14d
je     
jmp    
mov    $0x17,%dil
jmp    
mov    $0x16,%dil
jmp    
mov    $0x19,%dil
jmp    
mov    $0x1a,%dil
jmp    
movw   $0x101,0x40(%rbx)
movb   $0x8,0x240(%rbx)
movb   $0x1,0x440(%rbx)
movl   $0x8080808,0x241(%rbx)
movb   $0x9,0xc1(%rbx)
movb   $0x80,0x2c1(%rbx)
movl   $0x3020102,0x441(%rbx)
movb   $0x3,0x42(%rbx)
movw   $0x303,0x43(%rbx)
movw   $0x109,0xc3(%rbx)
movw   $0x780,0x2c3(%rbx)
movw   $0x1515,0x144(%rbx)
movw   $0x808,0x344(%rbx)
movb   $0x3,0x45(%rbx)
movb   $0x8,0x245(%rbx)
movb   $0x1,0xc5(%rbx)
movb   $0x7,0x2c5(%rbx)
movb   $0x9,0x1c5(%rbx)
movb   $0x80,0x3c5(%rbx)
movb   $0x4,0x445(%rbx)
movl   $0x5050505,0x46(%rbx)
movl   $0x8080808,0x246(%rbx)
movl   $0x4030201,0x446(%rbx)
movb   $0x9,0xc7(%rbx)
movb   $0x80,0x2c7(%rbx)
movw   $0x101,0xc8(%rbx)
movw   $0x707,0x2c8(%rbx)
movw   $0x1515,0x148(%rbx)
movw   $0x808,0x348(%rbx)
movb   $0x9,0x1c9(%rbx)
movb   $0x80,0x3c9(%rbx)
movb   $0xa,0x14b(%rbx)
movb   $0x80,0x34b(%rbx)
movl   $0x16171515,0xca(%rbx)
movl   $0x5050808,0x2ca(%rbx)
movb   $0x1,0xce(%rbx)
movb   $0x5,0x2ce(%rbx)
movw   $0x1617,0x14e(%rbx)
movw   $0x505,0x34e(%rbx)
movb   $0x1,0xcf(%rbx)
movb   $0x5,0x2cf(%rbx)
movabs $0x715090901010101,%rcx
mov    %rcx,0x4a(%rbx)
movabs $0x708050582820808,%rcx
mov    %rcx,0x24a(%rbx)
movabs $0x201030302020302,%rcx
mov    %rcx,0x44a(%rbx)
movw   $0x1709,0x153(%rbx)
movw   $0x502,0x353(%rbx)
movl   $0x1170a15,0xd1(%rbx)
movl   $0x5058008,0x2d1(%rbx)
movb   $0x9,0x1d4(%rbx)
movb   $0x2,0x3d4(%rbx)
movl   $0x9090115,0x52(%rbx)
movl   $0x81058008,0x252(%rbx)
movl   $0x1040302,0x452(%rbx)
movb   $0x1,0x56(%rbx)
movb   $0x81,0x256(%rbx)
addb   $0x2,0x45b(%rbx)
movb   $0x9,0x158(%rbx)
movb   $0x80,0x358(%rbx)
movb   $0x7,0xdc(%rbx)
movb   $0x7,0x2dc(%rbx)
addb   $0x3,0x45c(%rbx)
movb   $0x1,0x59(%rbx)
movb   $0x82,0x259(%rbx)
movzbl 0x45d(%rbx),%ecx
lea    0x1(%rcx),%edx
movzbl 0x459(%rbx),%esi
mov    %dl,0x45d(%rbx)
vmovw  0x457(%rbx),%xmm0
vpslld $0x8,%xmm0,%xmm0
vpinsrb $0x3,%esi,%xmm0,%xmm0
vpaddb -0x1a25877(%rip),%xmm0,%xmm0        # 
vmovd  %xmm0,0x456(%rbx)
add    $0x3,%cl
mov    %cl,0x45d(%rbx)
movb   $0x1,0x5a(%rbx)
movb   $0x82,0x25a(%rbx)
movzbl 0x45a(%rbx),%ecx
incb   0x45e(%rbx)
movl   $0x40404040,0xd7(%rbx)
movl   $0x82828282,0x2d7(%rbx)
movl   $0x15151509,0x15a(%rbx)
movl   $0x8080880,0x35a(%rbx)
movb   $0x7,0xde(%rbx)
movb   $0x7,0x2de(%rbx)
movb   $0x15,0x15e(%rbx)
movb   $0x8,0x35e(%rbx)
add    $0x4,%cl
mov    %cl,0x45a(%rbx)
movabs $0x4141414141414141,%rcx
mov    %rcx,0x1d7(%rbx)
mov    %rax,0x3d7(%rbx)
movl   $0x2020101,0x5d(%rbx)
movl   $0x80800707,0x25d(%rbx)
movb   $0x6,0xe0(%rbx)
movb   $0x80,0x2e0(%rbx)
movb   $0x4,0x61(%rbx)
movb   $0x80,0x261(%rbx)
movb   $0x4,0x62(%rbx)
movb   $0x80,0x262(%rbx)
movb   $0x6,0xe2(%rbx)
movb   $0x80,0x2e2(%rbx)
movb   $0x9,0x1e3(%rbx)
movb   $0x82,0x3e3(%rbx)
movw   $0x606,0x64(%rbx)
movw   $0xa0a,0xe4(%rbx)
movb   $0x8,0x264(%rbx)
movb   $0x80,0x2e4(%rbx)
movb   $0x8,0x265(%rbx)
movb   $0x80,0x2e5(%rbx)
movb   $0x9,0x1e5(%rbx)
movb   $0x82,0x3e5(%rbx)
vmovq  0x45e(%rbx),%xmm0
vpaddb -0x1a2598f(%rip),%xmm0,%xmm0        # 
vmovq  %xmm0,0x45e(%rbx)
vbroadcastss -0x1a207e0(%rip),%ymm0        # 
vmovaps %ymm0,0x760(%rbx)
vmovaps %ymm0,0x740(%rbx)
vmovaps %ymm0,0x720(%rbx)
vmovaps %ymm0,0x700(%rbx)
vmovaps %ymm0,0x6e0(%rbx)
vmovaps %ymm0,0x6c0(%rbx)
vmovaps %ymm0,0x6a0(%rbx)
vmovaps %ymm0,0x680(%rbx)
vmovaps %ymm0,0x660(%rbx)
vmovaps %ymm0,0x640(%rbx)
vmovaps %ymm0,0x620(%rbx)
vmovaps %ymm0,0x600(%rbx)
vmovaps %ymm0,0x5e0(%rbx)
vmovaps %ymm0,0x5c0(%rbx)
vmovaps %ymm0,0x5a0(%rbx)
vmovaps %ymm0,0x580(%rbx)
movw   $0x202,0x6b(%rbx)
movw   $0x202,0xeb(%rbx)
movb   $0x9,0x1ec(%rbx)
movb   $0x82,0x3ec(%rbx)
movw   $0x1e1e,0x6d(%rbx)
movw   $0x202,0xed(%rbx)
movw   $0x202,0x16d(%rbx)
movb   $0x80,0x36d(%rbx)
movl   $0x80800808,0x26b(%rbx)
movl   $0x8088080,0x2eb(%rbx)
movb   $0x80,0x36e(%rbx)
movb   $0x9,0x1ee(%rbx)
movb   $0x82,0x3ee(%rbx)
vmovd  0x46b(%rbx),%xmm0
vpaddb -0x1a25a85(%rip),%xmm0,%xmm0        # 
vmovd  %xmm0,0x46b(%rbx)
movb   $0xa,0x6f(%rbx)
movb   $0x80,0x26f(%rbx)
addb   $0x4,0x46f(%rbx)
movb   $0x1e,0xef(%rbx)
movb   $0x80,0x2ef(%rbx)
movb   $0x2,0x16f(%rbx)
movb   $0x8,0x36f(%rbx)
movb   $0x2,0x1ef(%rbx)
movb   $0x80,0x3ef(%rbx)
lea    0x266(%rbx),%rax
lea    0x200(%rbx),%rcx
xor    %edi,%edi
lea    -0x1a05bc8(%rip),%r8        # 
lea    -0x1a05bdb(%rip),%r9        # 
xor    %r10d,%r10d
jmp    
nopl   0x0(%rax)
inc    %r10
inc    %rax
cmp    $0x5,%r10
je     
movzbl (%r8,%r10,2),%r11d
movzbl 0x1(%r8,%r10,2),%r14d
lea    0x66(%r10),%r15
test   %r10,%r10
je     
cmp    $0x1,%r14d
mov    %r14d,%edx
adc    $0x0,%edx
and    $0x3,%edx
lea    (%rcx,%r11,1),%rsi
shl    $0x7,%edx
xor    %r12d,%r12d
nopl   0x0(%rax,%rax,1)
movzbl -0x200(%rsi,%r12,1),%ebp
movzbl (%rsi,%r12,1),%r13d
mov    %bpl,-0x200(%rax,%r12,1)
mov    %r13b,(%rax,%r12,1)
incb   0x400(%rbx,%r15,1)
sub    $0xffffffffffffff80,%r12
cmp    %r12,%rdx
jne    
mov    %r14d,%edx
shl    $0x7,%edx
add    %rbx,%rdx
mov    $0x3,%esi
sub    %r14,%rsi
cmovb  %rdi,%rsi
inc    %rsi
xor    %r12d,%r12d
cs nopw 0x0(%rax,%rax,1)
movzbl (%r9,%r12,2),%ebp
movzbl 0x1(%r9,%r12,2),%r13d
mov    %bpl,0x66(%rdx,%r10,1)
mov    %r13b,0x266(%rdx,%r10,1)
incb   0x466(%rbx,%r10,1)
inc    %r12
sub    $0xffffffffffffff80,%rdx
cmp    %r12,%rsi
jne    
mov    %r14d,%edx
shr    $1,%edx
cmp    $0x2,%edx
je     
mov    $0x2,%r13d
sub    %edx,%r13d
add    %r14b,%r14b
mov    %r13d,%r12d
and    $0x7,%r12d
cmp    $0x8,%r13d
jae    
xor    %ebp,%ebp
jmp    
nopw   0x0(%rax,%rax,1)
mov    %rcx,%r8
and    $0xfffffff8,%r13d
lea    0xa00(%rbx),%rcx
lea    (%rcx,%r11,1),%rdx
movzbl %r14b,%esi
xor    %ebp,%ebp
nopl   0x0(%rax,%rax,1)
mov    %r15b,-0x480(%rdx)
mov    %r15b,-0x400(%rdx)
mov    %r15b,-0x380(%rdx)
mov    %r15b,-0x300(%rdx)
mov    %r15b,-0x280(%rdx)
mov    %r15b,-0x200(%rdx)
mov    %r15b,-0x180(%rdx)
lea    (%rsi,%rbp,1),%ecx
lea    0x71(%rcx),%edi
mov    %dil,-0x80(%rdx)
mov    %r15b,-0x100(%rdx)
add    $0x72,%cl
mov    %cl,(%rdx)
add    $0x8,%rbp
add    $0x400,%rdx
cmp    %rbp,%r13
jne    
test   %r12,%r12
mov    %r8,%rcx
mov    $0x0,%edi
lea    -0x1a05d51(%rip),%r8        # 
je     
mov    %rbp,%rdx
shl    $0x7,%rdx
lea    0x680(%rbx),%rsi
add    %rsi,%r11
add    %rdx,%r11
add    %bpl,%r14b
add    $0x6b,%r14b
shl    $0x7,%r12d
xor    %edx,%edx
mov    %r15b,-0x100(%r11,%rdx,1)
mov    %r14b,(%r11,%rdx,1)
sub    $0xffffffffffffff80,%rdx
inc    %r14b
cmp    %rdx,%r12
jne    
jmp    
add    $0x8,%rsp
pop    %rbx
pop    %r12
pop    %r13
pop    %r14
pop    %r15
pop    %rbp
vzeroupper
ret
int3

:
add    $0x3f,%esi
shr    $0x6,%esi
je     
push   %rbp
push   %r15
push   %r14
push   %r13
push   %r12
push   %rbx
mov    (%rdi),%rax
mov    0x2c0(%rdi),%rcx
mov    %rcx,-0x8(%rsp)
mov    0xc60(%rdi),%r10
mov    0xc68(%rdi),%r8
shl    $0x6,%esi
xor    %r9d,%r9d
vpbroadcastd -0x1a630e3(%rip),%zmm0        # 
vpbroadcastd -0x1a630e9(%rip),%zmm1        # 
vpbroadcastd -0x1a630ef(%rip),%zmm2        # 
vpbroadcastd -0x1a630f5(%rip),%zmm3        # 
vpbroadcastd -0x1a630fb(%rip),%zmm4        # 
vmovdqa64 -0x1a582a5(%rip),%zmm5        # 
xor    %ebx,%ebx
xor    %r14d,%r14d
xor    %r11d,%r11d
nopl   (%rax)
mov    0xbd0(%rdi),%rcx
mov    (%rcx,%rbx,1),%r12
mov    0xba0(%rdi),%r15
mov    0xba8(%rdi),%rcx
vmovdqu64 (%rcx,%rbx,1),%zmm6
mov    0xbc8(%rdi),%rcx
mov    0xc08(%rdi),%r13
vmovdqu64 (%rcx,%rbx,4),%zmm7
vmovdqu64 0x40(%rcx,%rbx,4),%zmm8
vmovdqu64 0x80(%rcx,%rbx,4),%zmm9
vmovdqu64 0xc0(%rcx,%rbx,4),%zmm10
vpcmpneqd 0x0(%r13,%rbx,4),%zmm7,%k1
vptestmd %zmm7,%zmm7,%k1{%k1}
vpcmpeqd %zmm0,%zmm7,%k0
vpcmpneqd 0x40(%r13,%rbx,4),%zmm8,%k2
vptestmd %zmm8,%zmm8,%k2{%k2}
vpcmpneqd 0x80(%r13,%rbx,4),%zmm9,%k3
vpcmpeqd %zmm0,%zmm8,%k4
vptestmd %zmm9,%zmm9,%k3{%k3}
vpcmpneqd 0xc0(%r13,%rbx,4),%zmm10,%k5
vptestmd %zmm10,%zmm10,%k5{%k5}
kmovd  %k2,%ecx
kmovd  %k1,%ebp
vmovd  %ebp,%xmm7
vpinsrw $0x1,%ecx,%xmm7,%xmm7
kmovd  %k3,%ecx
vpinsrw $0x2,%ecx,%xmm7,%xmm7
kmovd  %k5,%ecx
vpinsrw $0x3,%ecx,%xmm7,%xmm7
vpcmpeqd %zmm0,%zmm9,%k1
vmovq  %xmm7,%rcx
vpcmpeqd %zmm0,%zmm10,%k2
kmovd  %k4,%ebp
kmovd  %k0,%r13d
vmovd  %r13d,%xmm7
vpinsrw $0x1,%ebp,%xmm7,%xmm7
kmovd  %k1,%ebp
vpinsrw $0x2,%ebp,%xmm7,%xmm7
kmovd  %k2,%ebp
vpinsrw $0x3,%ebp,%xmm7,%xmm7
vmovq  %xmm7,%r13
vpcmpeqb %zmm1,%zmm6,%k1
vpandq %zmm2,%zmm6,%zmm6
vpcmpeqb %zmm3,%zmm6,%k0
vptestmb (%r15,%rbx,1),%zmm4,%k1{%k1}
korq   %k1,%k0,%k0
kmovq  %k0,%r15
and    %r12,%r15
and    %r12,%rcx
andn   %rcx,%r13,%r12
mov    0xc50(%rdi),%r13
mov    %rcx,0x0(%r13,%r14,1)
mov    0xc50(%rdi),%rcx
mov    %r12,0x8(%rcx,%r14,1)
vpbroadcastd %ebx,%zmm6
vpord  %zmm5,%zmm6,%zmm6
kmovd  %r12d,%k1
vpcompressd %zmm6,%zmm7{%k1}{z}
mov    %r9d,%ecx
vmovdqu64 %zmm7,(%r10,%rcx,4)
mov    %r11d,%ecx
kmovd  %r15d,%k1
vpcompressd %zmm6,%zmm6{%k1}{z}
vmovdqu64 %zmm6,(%r8,%rcx,4)
movzwl %r12w,%ecx
popcnt %ecx,%r13d
add    %r9d,%r13d
movzwl %r15w,%ecx
popcnt %ecx,%ebp
add    %r11d,%ebp
lea    0x10(%rbx),%ecx
vpbroadcastd %ecx,%zmm6
vpord  %zmm5,%zmm6,%zmm6
mov    %r12,%rcx
shr    $0x10,%rcx
mov    %r15,%r9
shr    $0x10,%r9
movzwl %cx,%r11d
kmovd  %ecx,%k1
vpcompressd %zmm6,%zmm7{%k1}{z}
vmovdqu64 %zmm7,(%r10,%r13,4)
movzwl %r9w,%ecx
kmovd  %r9d,%k1
vpcompressd %zmm6,%zmm6{%k1}{z}
vmovdqu64 %zmm6,(%r8,%rbp,4)
popcnt %r11d,%r11d
add    %r13d,%r11d
popcnt %ecx,%r9d
add    %ebp,%r9d
lea    0x20(%rbx),%ecx
vpbroadcastd %ecx,%zmm6
vpord  %zmm5,%zmm6,%zmm6
mov    %r12,%rcx
shr    $0x20,%rcx
mov    %r15,%r13
movzwl %cx,%ebp
kmovd  %ecx,%k1
vpcompressd %zmm6,%zmm7{%k1}{z}
vmovdqu64 %zmm7,(%r10,%r11,4)
shr    $0x20,%r13
movzwl %r13w,%ecx
kmovd  %r13d,%k1
vpcompressd %zmm6,%zmm6{%k1}{z}
vmovdqu64 %zmm6,(%r8,%r9,4)
popcnt %ebp,%r13d
add    %r11d,%r13d
popcnt %ecx,%ebp
add    %r9d,%ebp
lea    0x30(%rbx),%ecx
vpbroadcastd %ecx,%zmm6
vpord  %zmm5,%zmm6,%zmm6
shr    $0x30,%r12
shr    $0x30,%r15
popcnt %r12d,%r9d
kmovd  %r12d,%k1
vpcompressd %zmm6,%zmm7{%k1}{z}
vmovdqu64 %zmm7,(%r10,%r13,4)
kmovd  %r15d,%k1
vpcompressd %zmm6,%zmm6{%k1}{z}
vmovdqu64 %zmm6,(%r8,%rbp,4)
popcnt %r15d,%r11d
add    %r13d,%r9d
add    %ebp,%r11d
add    $0x10,%r14
add    $0x40,%rbx
cmp    %rbx,%rsi
jne    
test   %r9d,%r9d
je     
cmp    $0x1,%r9d
jne    
xor    %esi,%esi
jmp    
xor    %r9d,%r9d
xor    %esi,%esi
jmp    
xor    %r9d,%r9d
jmp    
mov    %rdx,%r13
mov    %r9d,%r15d
mov    %r15d,%r14d
and    $0xfffffffe,%r14d
xor    %esi,%esi
jmp    
data16 data16 cs nopw 0x0(%rax,%rax,1)
mov    0xc28(%rdi),%rcx
mov    %bl,(%rcx,%rbp,1)
mov    0xc30(%rdi),%rcx
mov    %bh,(%rcx,%rbp,1)
add    $0x2,%rsi
cmp    %rsi,%r14
je     
mov    (%r10,%rsi,4),%ebp
mov    0xbc8(%rdi),%rcx
mov    (%rcx,%rbp,4),%r12d
shr    $0x3,%r12d
mov    $0xff,%ebx
mov    $0xff,%ecx
cmp    0x28(%rax),%r12d
jae    
mov    0x18(%rax),%rcx
mov    (%rcx,%r12,4),%ecx
mov    0xc28(%rdi),%r12
mov    %cl,(%r12,%rbp,1)
mov    0xc30(%rdi),%rdx
mov    %ch,(%rdx,%rbp,1)
mov    0x4(%r10,%rsi,4),%ebp
mov    0xbc8(%rdi),%rcx
mov    (%rcx,%rbp,4),%ecx
shr    $0x3,%ecx
cmp    0x28(%rax),%ecx
jae    
mov    0x18(%rax),%rdx
mov    (%rdx,%rcx,4),%ebx
jmp    
test   $0x1,%r15b
mov    %r13,%rdx
je     
mov    (%r10,%rsi,4),%esi
mov    0xbc8(%rdi),%rcx
mov    (%rcx,%rsi,4),%ecx
shr    $0x3,%ecx
mov    $0xff,%ebx
cmp    0x28(%rax),%ecx
jae    
mov    0x18(%rax),%r10
mov    (%r10,%rcx,4),%ebx
mov    0xc28(%rdi),%rcx
mov    %bl,(%rcx,%rsi,1)
mov    0xc30(%rdi),%rcx
mov    %bh,(%rcx,%rsi,1)
test   %r11d,%r11d
je     
mov    %rdx,%r12
mov    %r11d,%esi
xor    %r10d,%r10d
cmp    $0x1,%r11d
jne    
xor    %r11d,%r11d
mov    -0x8(%rsp),%r13
jmp    
xor    %esi,%esi
jmp    
mov    %esi,%ebx
and    $0xfffffffe,%ebx
xor    %r11d,%r11d
mov    -0x8(%rsp),%r13
jmp    
data16 data16 cs nopw 0x0(%rax,%rax,1)
mov    0xc38(%rdi),%rcx
mov    %bpl,(%rcx,%r14,1)
add    $0x2,%r11
cmp    %r11,%rbx
je     
mov    (%r8,%r11,4),%r14d
mov    %r14,%rcx
shl    $0x6,%rcx
mov    0xc(%r13,%rcx,1),%edx
mov    0x3a8(%rax),%r15
cmp    0x3b8(%rax),%edx
cmovae %r10d,%edx
cmpl   $0x0,(%r15,%rdx,4)
sete   %dl
cmpq   $0x0,0x30(%r13,%rcx,1)
setne  %bpl
add    %dl,%dl
or     %bpl,%dl
mov    0xc48(%rdi),%r15
mov    %dl,(%r15,%r14,1)
mov    0x20(%r13,%rcx,1),%ecx
shr    $0x3,%ecx
mov    $0xff,%bpl
mov    $0xff,%r15b
cmp    0x28(%rax),%ecx
jae    
mov    0x18(%rax),%rdx
movzbl (%rdx,%rcx,4),%r15d
mov    0xc38(%rdi),%rcx
mov    %r15b,(%rcx,%r14,1)
mov    0x4(%r8,%r11,4),%r14d
mov    %r14,%rcx
shl    $0x6,%rcx
mov    0xc(%r13,%rcx,1),%edx
mov    0x3a8(%rax),%r15
cmp    0x3b8(%rax),%edx
cmovae %r10d,%edx
cmpl   $0x0,(%r15,%rdx,4)
sete   %dl
cmpq   $0x0,0x30(%r13,%rcx,1)
setne  %r15b
add    %dl,%dl
or     %r15b,%dl
mov    0xc48(%rdi),%r15
mov    %dl,(%r15,%r14,1)
mov    0x20(%r13,%rcx,1),%ecx
shr    $0x3,%ecx
cmp    0x28(%rax),%ecx
jae    
mov    0x18(%rax),%rdx
movzbl (%rdx,%rcx,4),%ebp
jmp    
test   $0x1,%sil
je     
mov    (%r8,%r11,4),%r8d
mov    %r8,%rcx
shl    $0x6,%rcx
mov    0xc(%r13,%rcx,1),%edx
mov    0x3a8(%rax),%r11
cmp    0x3b8(%rax),%edx
cmovb  %edx,%r10d
cmpl   $0x0,(%r11,%r10,4)
sete   %dl
cmpq   $0x0,0x30(%r13,%rcx,1)
setne  %r10b
add    %dl,%dl
or     %r10b,%dl
mov    0xc48(%rdi),%r10
mov    %dl,(%r10,%r8,1)
mov    0x20(%r13,%rcx,1),%ecx
shr    $0x3,%ecx
mov    $0xff,%dl
cmp    0x28(%rax),%ecx
jae    
mov    0x18(%rax),%rax
movzbl (%rax,%rcx,4),%edx
mov    0xc38(%rdi),%rax
mov    %dl,(%rax,%r8,1)
mov    %r12,%rdx
pop    %rbx
pop    %r12
pop    %r13
pop    %r14
pop    %r15
pop    %rbp
vmovd  %r9d,%xmm0
vmovd  %esi,%xmm1
vpunpcklqdq %xmm1,%xmm0,%xmm0
vpaddq (%rdx),%xmm0,%xmm0
vmovdqu %xmm0,(%rdx)
vzeroupper
ret
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3

:
add    $0x3f,%edx
shr    $0x6,%edx
je     
mov    0xc00(%rdi),%rax
shl    $0x4,%edx
xor    %ecx,%ecx
vpbroadcastd -0x1a6367e(%rip),%zmm0        # 
vpbroadcastd -0x1a63684(%rip),%zmm1        # 
vpbroadcastd -0x1a6368a(%rip),%zmm2        # 
vpbroadcastd -0x1a63690(%rip),%zmm4        # 
vpbroadcastd -0x1a63696(%rip),%zmm6        # 
vpbroadcastd -0x1a6369c(%rip),%zmm9        # 
vpternlogd $0xff,%zmm10,%zmm10,%zmm10
vpbroadcastd -0x1a636a9(%rip),%zmm11        # 
vpbroadcastd -0x1a636af(%rip),%zmm12        # 
vpbroadcastd -0x1a636b5(%rip),%zmm13        # 
vpbroadcastq -0x1a6181b(%rip),%zmm15        # 
vpbroadcastd -0x1a636c5(%rip),%zmm14        # 
vpbroadcastd -0x1a636cb(%rip),%zmm17        # 
vpbroadcastd -0x1a636d1(%rip),%zmm18        # 
vpbroadcastd -0x1a636d7(%rip),%zmm19        # 
vpbroadcastd -0x1a636dd(%rip),%zmm20        # 
vpbroadcastd -0x1a636e3(%rip),%zmm21        # 
vpbroadcastd -0x1a636e9(%rip),%zmm22        # 
vpbroadcastd -0x1a636ef(%rip),%zmm23        # 
vpbroadcastd -0x1a636f5(%rip),%zmm24        # 
vpbroadcastd -0x1a636fb(%rip),%zmm25        # 
vpbroadcastd -0x1a63701(%rip),%zmm26        # 
data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
mov    0xbd0(%rdi),%r8
kmovq  (%r8,%rcx,4),%k1
mov    0xc50(%rdi),%r9
kmovq  (%r9,%rcx,1),%k0
kmovq  0x8(%r9,%rcx,1),%k2
mov    0xba8(%rdi),%r9
vmovdqu64 (%r9,%rcx,4),%zmm29
mov    0xbb0(%rdi),%r9
mov    0xb80(%rdi),%r10
mov    0xb88(%rdi),%r11
vmovdqu64 (%r10,%rcx,4),%zmm27
mov    0xb98(%rdi),%r10
vmovdqu64 (%r10,%rcx,4),%zmm3
mov    0xba0(%rdi),%r10
vmovdqu64 0x2c(%rsi,%rcx,4),%zmm31
vpandq (%r11,%rcx,4),%zmm6,%zmm28
vpternlogq $0xf8,(%r9,%rcx,4),%zmm0,%zmm28
vptestnmb %zmm28,%zmm28,%k4
vptestmb (%r10,%rcx,4),%zmm6,%k3
mov    0xc48(%rdi),%r9
vmovdqu64 (%r9,%rcx,4),%zmm5
mov    0xc38(%rdi),%r9
vpaddb (%r9,%rcx,4),%zmm10,%zmm7
vpermb 0x480(%rax),%zmm29,%zmm28
vptestnmb %zmm12,%zmm5,%k5
vpbroadcastd -0x1a637c6(%rip),%zmm8        # 
vpblendmb -0x1a58644(%rip),%zmm8,%zmm30{%k5}        # 
vgf2p8affineqb $0x0,%zmm15,%zmm3,%zmm8
vpandq %zmm12,%zmm8,%zmm8
vmovdqa64 %zmm14,%zmm16
vpaddb %zmm8,%zmm30,%zmm16{%k3}
vpaddb %zmm10,%zmm27,%zmm30
vpcmpltub %zmm11,%zmm30,%k3
vptestnmb %zmm9,%zmm3,%k3{%k3}
vporq  %zmm0,%zmm16,%zmm8
vmovdqu8 %zmm8,%zmm16{%k3}
vpcmpeqb %zmm0,%zmm29,%k5
vpandd -0x1a63814(%rip){1to16},%zmm3,%zmm3        # 
vpcmpeqb %zmm4,%zmm3,%k6{%k5}
vpcmpeqb %zmm13,%zmm28,%k3
vmovdqu8 %zmm16,%zmm28{%k6}
vpaddb %zmm17,%zmm29,%zmm8
vpcmpltub %zmm12,%zmm8,%k6
vmovdqu8 %zmm2,%zmm8{%k4}{z}
vmovdqu8 %zmm8,%zmm28{%k6}
vpcmpeqb %zmm1,%zmm29,%k6
vpsllw $0x7,%zmm5,%zmm5
vpblendmb -0x1a5858e(%rip),%zmm18,%zmm8{%k4}        # 
vpxord %xmm16,%xmm16,%xmm16
vpcmpgtb %zmm5,%zmm16,%k6{%k6}
vmovdqu8 %zmm8,%zmm28{%k6}
vpcmpltub %zmm6,%zmm7,%k6
vpblendmb -0x1a58531(%rip),%zmm19,%zmm5{%k6}        # 
vpandq %zmm13,%zmm31,%zmm7
vpcmpeqb %zmm9,%zmm7,%k6
vporq  %zmm0,%zmm5,%zmm8
vmovdqu8 %zmm8,%zmm5{%k6}
vpcmpeqb %zmm2,%zmm29,%k6
vmovdqu8 %zmm5,%zmm28{%k6}
vpcmpeqb -0x1a5899f(%rip),%zmm29,%k6        # 
vmovdqa64 0x400(%rax),%zmm5
vmovdqa64 0x4c0(%rax),%zmm8
vpermt2b 0x500(%rax),%zmm31,%zmm8
vmovdqa64 0x440(%rax),%zmm16
vmovdqu8 %zmm8,%zmm28{%k6}
vpcmpeqb %zmm20,%zmm7,%k6
vpblendmb -0x1a584d1(%rip),%zmm21,%zmm8{%k6}        # 
vpcmpeqb %zmm22,%zmm7,%k4{%k4}
vmovdqu8 -0x1a58461(%rip),%zmm8{%k4}        # 
vpcmpeqb %zmm4,%zmm29,%k4
vmovdqu8 %zmm8,%zmm28{%k4}
vpcmpeqb %zmm12,%zmm7,%k4
vpblendmb %zmm11,%zmm1,%zmm7{%k4}
vpcmpeqb -0x1a58983(%rip),%zmm29,%k4        # 
vmovdqu8 %zmm7,%zmm28{%k4}
mov    0xc28(%rdi),%r9
vmovdqu8 (%r9,%rcx,4),%zmm7{%k2}{z}
mov    0xc30(%rdi),%r9
vmovdqu8 (%r9,%rcx,4),%zmm8{%k2}{z}
vpcmpeqb %zmm6,%zmm3,%k2{%k5}
vpaddb %zmm10,%zmm7,%zmm3
vpcmpgtb %zmm10,%zmm8,%k2{%k2}
kandq  %k2,%k0,%k2
vpcmpltub %zmm1,%zmm3,%k4
kandq  %k4,%k2,%k4
vpaddb %zmm23,%zmm7,%zmm3
vpcmpltub %zmm12,%zmm3,%k5
vmovdqu8 -0x1a5845f(%rip),%zmm28{%k4}        # 
kandq  %k5,%k2,%k2
kxorq  %k0,%k4,%k4
vptestnmb %zmm7,%zmm7,%k5
vpblendmb -0x1a583f9(%rip),%zmm24,%zmm3{%k5}        # 
vpcmpneqb %zmm7,%zmm27,%k5{%k4}
vmovdqu8 %zmm3,%zmm3{%k5}{z}
vpcmpltub %zmm6,%zmm30,%k5
vpblendmb -0x1a58397(%rip),%zmm25,%zmm29{%k5}        # 
vpmaxub %zmm7,%zmm27,%zmm7
vmovdqu8 %zmm28,%zmm27{%k1}{z}
vpcmpnleub %zmm2,%zmm7,%k0
kandq  %k0,%k4,%k0
vptestmb %zmm26,%zmm8,%k1{%k4}
vmovdqa64 %zmm5,%zmm7
vpermt2b %zmm16,%zmm27,%zmm7
vmovdqu8 %zmm29,%zmm3{%k1}
vpermt2b %zmm16,%zmm3,%zmm5
vpaddb %zmm7,%zmm5,%zmm5
mov    0xc10(%rdi),%r9
vmovdqu64 %zmm27,(%r9,%rcx,4)
mov    0xc18(%rdi),%r9
vmovdqu64 %zmm3,(%r9,%rcx,4)
mov    0xc20(%rdi),%r9
vmovdqu64 %zmm5,(%r9,%rcx,4)
korq   %k3,%k2,%k1
korq   %k0,%k1,%k1
kmovq  %k1,0x28(%r8,%rcx,4)
kmovq  %k0,0x30(%r8,%rcx,4)
kmovq  %k2,0x38(%r8,%rcx,4)
add    $0x10,%rcx
cmp    %rcx,%rdx
jne    
vzeroupper
ret
int3
int3
int3

:
push   %rbp
push   %r15
push   %r14
push   %r13
push   %r12
push   %rbx
mov    %rsi,-0x28(%rsp)
add    $0x3f,%edx
xor    %r8d,%r8d
shr    $0x6,%edx
je     
mov    0xc00(%rdi),%rsi
mov    0xc70(%rdi),%rax
vmovdqa64 0x900(%rsi),%zmm0
cmp    $0x1,%edx
jne    
xor    %edx,%edx
jmp    
mov    %edx,%ebx
mov    %ebx,%r9d
and    $0xfffffffe,%r9d
xor    %edx,%edx
vpbroadcastd -0x1a63a88(%rip),%zmm1        # 
xor    %r8d,%r8d
nopw   0x0(%rax,%rax,1)
mov    %rdx,%r10
shl    $0x6,%r10
mov    0xba8(%rdi),%rsi
mov    0xbd0(%rdi),%r11
kmovq  (%r11,%r10,1),%k1
vpcmpeqb (%rsi,%r10,1),%zmm1,%k1{%k1}
vpcompressb %zmm0,%zmm2{%k1}{z}
kmovq  %k1,%rsi
popcnt %rsi,%rsi
add    %r8d,%esi
vpbroadcastd %r10d,%zmm3
nopl   0x0(%rax,%rax,1)
mov    %r8d,%r11d
vpmovzxbd %xmm2,%zmm4
vpaddd %zmm4,%zmm3,%zmm4
vmovdqu64 %zmm4,(%rax,%r11,4)
vshufi64x2 $0x39,%zmm2,%zmm2,%zmm2
add    $0x10,%r8d
cmp    %esi,%r8d
jb     
mov    0xba8(%rdi),%r8
mov    0xbd0(%rdi),%r11
kmovq  0x40(%r11,%r10,1),%k1
vpcmpeqb 0x40(%r8,%r10,1),%zmm1,%k1{%k1}
add    $0x40,%r10
vpcompressb %zmm0,%zmm2{%k1}{z}
kmovq  %k1,%r8
popcnt %r8,%r8
add    %esi,%r8d
vpbroadcastd %r10d,%zmm3
mov    %esi,%r10d
vpmovzxbd %xmm2,%zmm4
vpaddd %zmm4,%zmm3,%zmm4
vmovdqu64 %zmm4,(%rax,%r10,4)
vshufi64x2 $0x39,%zmm2,%zmm2,%zmm2
add    $0x10,%esi
cmp    %r8d,%esi
jb     
add    $0x2,%rdx
cmp    %r9,%rdx
jne    
test   $0x1,%bl
je     
shl    $0x6,%rdx
mov    0xba8(%rdi),%r9
mov    0xbd0(%rdi),%rsi
kmovq  (%rsi,%rdx,1),%k1
vmovdqu64 (%r9,%rdx,1),%zmm1
vpcmpeqb -0x1a58510(%rip),%zmm1,%k1{%k1}        # 
mov    %r8d,%r9d
vpcompressb %zmm0,%zmm0{%k1}{z}
kmovq  %k1,%rsi
popcnt %rsi,%r8
add    %r9d,%r8d
vpbroadcastd %edx,%zmm1
nopl   0x0(%rax)
mov    %r9d,%edx
vpmovzxbd %xmm0,%zmm2
vpaddd %zmm2,%zmm1,%zmm2
vmovdqu64 %zmm2,(%rax,%rdx,4)
vshufi64x2 $0x39,%zmm0,%zmm0,%zmm0
add    $0x10,%r9d
cmp    %r8d,%r9d
jb     
test   %r8d,%r8d
je     
mov    %rcx,-0x30(%rsp)
mov    %r8d,%r8d
xor    %ecx,%ecx
jmp    
xchg   %ax,%ax
mov    %r10b,-0x31(%rsp)
mov    0xc00(%rdi),%r13
mov    %r13,-0x20(%rsp)
mov    %r14d,%esi
shr    $0x4,%esi
and    $0x1,%esi
xor    %edx,%edx
cmp    %cl,%r10b
setne  %dl
movzbl 0x800(%r13,%r12,1),%ebx
mov    $0x0,%ecx
mov    $0x63,%r10d
cmovne %r10d,%ecx
add    %edx,%ebx
test   $0x8,%r14b
movzbl 0x880(%r13,%r12,1),%r14d
cmove  %ebx,%r14d
mov    0xbd0(%rdi),%r10
mov    %r10,-0x18(%rsp)
mov    0xc10(%rdi),%rbx
mov    %r14b,(%rbx,%r11,1)
mov    0xc20(%rdi),%r10
movzbl 0x400(%r13,%r14,1),%r14d
mov    %r11d,%ebx
and    $0xffffffc0,%ebx
add    %r14b,(%r10,%r11,1)
shr    $0x2,%r15d
and    $0x2,%r15d
lea    0x2(%r15),%r10d
testb  $0x7f,-0x32(%rsp)
movzbl %r10b,%r10d
mov    $0x0,%r12d
cmovne %r12d,%r10d
lea    0x64(%rdx),%r14d
cmp    $0x28,%bpl
sete   %r13b
cmove  %r12d,%r14d
or     %r13b,%r10b
add    $0x1c,%r10b
mov    0xc48(%rdi),%r13
mov    %r10b,0x0(%r13,%r11,1)
mov    0xc38(%rdi),%r10
movzbl -0x31(%rsp),%r13d
mov    %r13b,(%r10,%r11,1)
shlx   %r11,%rsi,%rsi
mov    -0x18(%rsp),%r10
or     %rsi,0x28(%r10,%rbx,1)
shl    $0x7,%edx
mov    -0x20(%rsp),%rbx
add    %rbx,%rdx
cmp    $0x28,%bpl
mov    0xc10(%rdi),%rsi
movzbl (%rsi,%r9,1),%r10d
movzbl 0x580(%r10,%rdx,1),%r11d
cmovne %r10d,%r11d
movzbl 0x680(%r10,%rdx,1),%edx
cmovne %r12d,%edx
movzbl %dl,%edx
or     %r14d,%edx
mov    -0x10(%rsp),%r10
lea    0x5f(%r15,%r10,1),%r10d
testb  $0x7f,-0x32(%rsp)
cmovne %r12d,%r10d
cmove  %r12d,%r11d
movzbl %r11b,%r11d
cmovne %r12d,%ecx
cmove  %r12d,%edx
or     %r10d,%r11d
or     %ecx,%edx
mov    0xbd0(%rdi),%rcx
mov    %r11b,(%rsi,%r9,1)
mov    0xc18(%rdi),%rsi
mov    %dl,(%rsi,%r9,1)
movzbl 0x400(%rbx,%rdx,1),%edx
add    0x400(%rbx,%r11,1),%dl
mov    0xc20(%rdi),%rsi
mov    %dl,(%rsi,%r9,1)
mov    0xc38(%rdi),%rdx
mov    %r13b,(%rdx,%r9,1)
mov    %r9d,%edx
and    $0xffffffc0,%edx
xor    %esi,%esi
cmp    $0x7f,%r11
sete   %sil
shlx   %r9,%rsi,%rsi
or     %rsi,0x28(%rcx,%rdx,1)
mov    -0x8(%rsp),%rcx
inc    %rcx
cmp    %rcx,%r8
je     
mov    %rcx,-0x8(%rsp)
mov    (%rax,%rcx,4),%r11d
mov    -0x28(%rsp),%rdx
movzbl 0x2c(%rdx,%r11,1),%ebp
mov    %ebp,%r12d
and    $0x7f,%r12d
movzwl 0x6b554(%rdx,%r11,2),%ecx
mov    %r11d,%r9d
sub    %ecx,%r9d
and    $0x7e,%bpl
xor    %ecx,%ecx
cmp    $0x28,%bpl
sete   %cl
mov    %rcx,-0x10(%rsp)
movzbl 0x2c(%rdx,%r9,1),%ecx
mov    %cl,-0x32(%rsp)
mov    0xba0(%rdi),%rcx
movzbl (%rcx,%r9,1),%r15d
mov    0xb80(%rdi),%rcx
movzbl (%rcx,%r11,1),%ecx
mov    0xb88(%rdi),%rdx
movzbl (%rdx,%r11,1),%r14d
mov    (%rdi),%rdx
mov    0x2c0(%rdi),%rsi
mov    %r11,%rbx
shl    $0x6,%rbx
mov    0x20(%rsi,%rbx,1),%esi
shr    $0x3,%esi
mov    $0xff,%r10b
cmp    0x28(%rdx),%esi
jae    
mov    0x18(%rdx),%rdx
movzbl (%rdx,%rsi,4),%r10d
jmp    
mov    -0x30(%rsp),%rcx
jmp    
xor    %r8d,%r8d
add    %r8,0x10(%rcx)
pop    %rbx
pop    %r12
pop    %r13
pop    %r14
pop    %r15
pop    %rbp
vzeroupper
ret
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3

:
add    $0x3f,%edx
shr    $0x6,%edx
je     
mov    0xc00(%rdi),%rcx
vmovdqa64 0x540(%rcx),%zmm0
shl    $0x5,%edx
xor    %eax,%eax
vpbroadcastd -0x1a63ea9(%rip),%zmm1        # 
vpbroadcastd -0x1a63eaf(%rip),%zmm2        # 
vpbroadcastd -0x1a63eb5(%rip),%zmm3        # 
vpbroadcastd -0x1a63ebb(%rip),%zmm4        # 
vpbroadcastd -0x1a63ec1(%rip),%zmm5        # 
vpbroadcastq -0x1a6206b(%rip),%zmm6        # 
xor    %r8d,%r8d
xchg   %ax,%ax
mov    0xc20(%rdi),%r9
vmovdqu64 (%r9,%r8,2),%zmm7
vpmullq %zmm6,%zmm7,%zmm7
mov    0xc10(%rdi),%r9
vpermb (%r9,%r8,2),%zmm0,%zmm10
mov    0xc18(%rdi),%r9
vpermb (%r9,%r8,2),%zmm0,%zmm20
mov    0xb80(%rdi),%r9
vpermb (%r9,%r8,2),%zmm0,%zmm13
mov    0xc28(%rdi),%r11
mov    0xc38(%rdi),%r10
vmovdqa64 0x780(%rcx),%zmm18
mov    0xc48(%rdi),%r9
vmovdqa64 (%rcx),%zmm8
vmovdqa64 0x40(%rcx),%zmm11
vmovdqa64 %zmm8,%zmm12
vpermt2b %zmm11,%zmm10,%zmm12
vmovdqa64 0x80(%rcx),%zmm9
vpermt2b %zmm11,%zmm20,%zmm8
vmovdqa64 0x200(%rcx),%zmm11
vmovdqa64 0x240(%rcx),%zmm15
vmovdqa64 %zmm11,%zmm14
vpermt2b %zmm15,%zmm10,%zmm14
vpermt2b %zmm15,%zmm20,%zmm11
vmovdqa64 0xc0(%rcx),%zmm15
vpcmpeqb %zmm1,%zmm14,%k1
vmovdqu8 %zmm13,%zmm14{%k1}
vmovdqa64 %zmm9,%zmm17
vpermt2b %zmm15,%zmm10,%zmm17
vpcmpeqb %zmm1,%zmm11,%k1
vpermt2b %zmm15,%zmm20,%zmm9
vmovdqa64 0x280(%rcx),%zmm15
vmovdqa64 0x2c0(%rcx),%zmm19
vmovdqa64 %zmm15,%zmm16
vpermt2b %zmm19,%zmm10,%zmm16
vpermt2b %zmm19,%zmm20,%zmm15
vmovdqu8 %zmm13,%zmm11{%k1}
vpcmpeqb %zmm1,%zmm16,%k1
vmovdqu8 %zmm13,%zmm16{%k1}
vpcmpeqb %zmm1,%zmm15,%k1
vmovdqa64 0x100(%rcx),%zmm22
vmovdqa64 0x140(%rcx),%zmm19
vmovdqa64 %zmm22,%zmm23
vpermt2b %zmm19,%zmm10,%zmm23
vpermt2b %zmm19,%zmm20,%zmm22
vmovdqu8 %zmm13,%zmm15{%k1}
vmovdqa64 0x300(%rcx),%zmm19
vmovdqa64 0x340(%rcx),%zmm24
vmovdqa64 %zmm19,%zmm21
vpermt2b %zmm24,%zmm10,%zmm21
vpermt2b %zmm24,%zmm20,%zmm19
vpcmpeqb %zmm1,%zmm21,%k1
vmovdqa64 0x180(%rcx),%zmm25
vmovdqa64 0x1c0(%rcx),%zmm24
vmovdqa64 %zmm25,%zmm26
vpermt2b %zmm24,%zmm10,%zmm26
vpermt2b %zmm24,%zmm20,%zmm25
vmovdqu8 %zmm13,%zmm21{%k1}
vmovdqa64 0x380(%rcx),%zmm24
vmovdqa64 0x3c0(%rcx),%zmm27
vpermi2b %zmm27,%zmm24,%zmm10
vpcmpeqb %zmm1,%zmm19,%k1
vmovdqu8 %zmm13,%zmm19{%k1}
vpermt2b %zmm27,%zmm20,%zmm24
vpcmpeqb %zmm1,%zmm10,%k1
vmovdqu8 %zmm13,%zmm10{%k1}
vpcmpeqb %zmm1,%zmm24,%k1
vpermb (%r11,%r8,2),%zmm0,%zmm20
vpermb 0x2c(%rsi,%r8,2),%zmm0,%zmm27
vpermi2b 0x7c0(%rcx),%zmm18,%zmm27
vpermb (%r10,%r8,2),%zmm0,%zmm18
vmovdqu8 %zmm13,%zmm24{%k1}
vpcmpeqb %zmm2,%zmm14,%k1
vpcmpeqb %zmm3,%zmm14,%k2
vmovdqu8 %zmm20,%zmm14{%k1}
vmovdqu8 %zmm18,%zmm14{%k2}
vpcmpeqb %zmm3,%zmm16,%k1
vmovdqu8 %zmm18,%zmm16{%k1}
vpcmpeqb %zmm2,%zmm11,%k1
vmovdqu8 %zmm20,%zmm11{%k1}
vpcmpeqb %zmm3,%zmm24,%k1
vmovdqu8 %zmm18,%zmm24{%k1}
vpcmpeqb %zmm4,%zmm17,%k1
vmovdqu8 %zmm27,%zmm17{%k1}
vpcmpeqb %zmm5,%zmm26,%k1
vpermb (%r9,%r8,2),%zmm0,%zmm26{%k1}
vpunpcklbw %zmm17,%zmm12,%zmm13
vpunpckhbw %zmm17,%zmm12,%zmm18
vpunpcklbw %zmm26,%zmm23,%zmm12
vpunpckhbw %zmm26,%zmm23,%zmm20
vpunpcklbw %zmm9,%zmm8,%zmm23
vpunpckhbw %zmm9,%zmm8,%zmm9
vpunpcklbw %zmm25,%zmm22,%zmm26
vpunpckhbw %zmm25,%zmm22,%zmm22
vpunpcklwd %zmm12,%zmm13,%zmm25
vpunpckhwd %zmm12,%zmm13,%zmm17
vpunpcklwd %zmm20,%zmm18,%zmm12
vpunpckhwd %zmm20,%zmm18,%zmm8
vpunpcklwd %zmm26,%zmm23,%zmm20
vpunpckhwd %zmm26,%zmm23,%zmm18
vpunpcklwd %zmm22,%zmm9,%zmm13
vpunpckhwd %zmm22,%zmm9,%zmm9
vpunpcklbw %zmm16,%zmm14,%zmm22
vpunpckhbw %zmm16,%zmm14,%zmm23
vpunpcklbw %zmm10,%zmm21,%zmm14
vpunpckhbw %zmm10,%zmm21,%zmm10
vpunpcklbw %zmm15,%zmm11,%zmm21
vpunpckhbw %zmm15,%zmm11,%zmm11
vpunpcklbw %zmm24,%zmm19,%zmm15
vpunpckhbw %zmm24,%zmm19,%zmm24
vpunpcklwd %zmm14,%zmm22,%zmm26
vpunpckhwd %zmm14,%zmm22,%zmm16
vpunpcklwd %zmm10,%zmm23,%zmm14
vpunpckhwd %zmm10,%zmm23,%zmm10
vpunpcklwd %zmm15,%zmm21,%zmm22
vpunpckhwd %zmm15,%zmm21,%zmm19
vpunpcklwd %zmm24,%zmm11,%zmm15
vpunpckldq %zmm20,%zmm25,%zmm21
vptestmb %zmm21,%zmm21,%k1
vpcompressb %zmm21,%zmm21{%k1}{z}
vpunpckldq %zmm22,%zmm26,%zmm23
vpcompressb %zmm23,%zmm23{%k1}{z}
vpunpckhwd %zmm24,%zmm11,%zmm11
kmovq  %k1,%r9
mov    0xc78(%rdi),%r10
mov    %eax,%r11d
vmovdqu64 %zmm21,(%r10,%r11,1)
mov    0xc80(%rdi),%r10
vmovdqu64 %zmm23,(%r10,%r11,1)
mov    0xc58(%rdi),%r10
mov    %eax,(%r10,%r8,1)
popcnt %r9,%r9
add    %eax,%r9d
vpunpckhdq %zmm20,%zmm25,%zmm20
vptestmb %zmm20,%zmm20,%k1
vpcompressb %zmm20,%zmm20{%k1}{z}
vpunpckhdq %zmm22,%zmm26,%zmm21
vpcompressb %zmm21,%zmm21{%k1}{z}
kmovq  %k1,%rax
mov    0xc78(%rdi),%r10
vmovdqu64 %zmm20,(%r10,%r9,1)
mov    0xc80(%rdi),%r10
vmovdqu64 %zmm21,(%r10,%r9,1)
mov    0xc58(%rdi),%r10
mov    %r9d,0x4(%r10,%r8,1)
popcnt %rax,%rax
add    %r9d,%eax
vpunpckldq %zmm18,%zmm17,%zmm20
vptestmb %zmm20,%zmm20,%k1
vpcompressb %zmm20,%zmm20{%k1}{z}
vpunpckldq %zmm19,%zmm16,%zmm21
vpcompressb %zmm21,%zmm21{%k1}{z}
kmovq  %k1,%r9
mov    0xc78(%rdi),%r10
vmovdqu64 %zmm20,(%r10,%rax,1)
mov    0xc80(%rdi),%r10
vmovdqu64 %zmm21,(%r10,%rax,1)
mov    0xc58(%rdi),%r10
mov    %eax,0x8(%r10,%r8,1)
popcnt %r9,%r9
add    %eax,%r9d
vpunpckhdq %zmm18,%zmm17,%zmm17
vptestmb %zmm17,%zmm17,%k1
vpcompressb %zmm17,%zmm17{%k1}{z}
vpunpckhdq %zmm19,%zmm16,%zmm16
vpcompressb %zmm16,%zmm16{%k1}{z}
kmovq  %k1,%rax
mov    0xc78(%rdi),%r10
vmovdqu64 %zmm17,(%r10,%r9,1)
mov    0xc80(%rdi),%r10
vmovdqu64 %zmm16,(%r10,%r9,1)
mov    0xc58(%rdi),%r10
mov    %r9d,0xc(%r10,%r8,1)
popcnt %rax,%rax
add    %r9d,%eax
vpunpckldq %zmm13,%zmm12,%zmm16
vptestmb %zmm16,%zmm16,%k1
vpcompressb %zmm16,%zmm16{%k1}{z}
vpunpckldq %zmm15,%zmm14,%zmm17
vpcompressb %zmm17,%zmm17{%k1}{z}
kmovq  %k1,%r9
mov    0xc78(%rdi),%r10
vmovdqu64 %zmm16,(%r10,%rax,1)
mov    0xc80(%rdi),%r10
vmovdqu64 %zmm17,(%r10,%rax,1)
mov    0xc58(%rdi),%r10
mov    %eax,0x10(%r10,%r8,1)
popcnt %r9,%r9
add    %eax,%r9d
vpunpckhdq %zmm13,%zmm12,%zmm12
vptestmb %zmm12,%zmm12,%k1
vpcompressb %zmm12,%zmm12{%k1}{z}
vpunpckhdq %zmm15,%zmm14,%zmm13
vpcompressb %zmm13,%zmm13{%k1}{z}
kmovq  %k1,%rax
mov    0xc78(%rdi),%r10
vmovdqu64 %zmm12,(%r10,%r9,1)
mov    0xc80(%rdi),%r10
vmovdqu64 %zmm13,(%r10,%r9,1)
mov    0xc58(%rdi),%r10
mov    %r9d,0x14(%r10,%r8,1)
popcnt %rax,%rax
add    %r9d,%eax
vpunpckldq %zmm9,%zmm8,%zmm12
vptestmb %zmm12,%zmm12,%k1
vpcompressb %zmm12,%zmm12{%k1}{z}
vpunpckldq %zmm11,%zmm10,%zmm13
vpcompressb %zmm13,%zmm13{%k1}{z}
kmovq  %k1,%r9
mov    0xc78(%rdi),%r10
vmovdqu64 %zmm12,(%r10,%rax,1)
mov    0xc80(%rdi),%r10
vmovdqu64 %zmm13,(%r10,%rax,1)
mov    0xc58(%rdi),%r10
mov    %eax,0x18(%r10,%r8,1)
popcnt %r9,%r9
add    %eax,%r9d
vpunpckhdq %zmm9,%zmm8,%zmm8
vptestmb %zmm8,%zmm8,%k1
vpcompressb %zmm8,%zmm8{%k1}{z}
vpunpckhdq %zmm11,%zmm10,%zmm9
vpcompressb %zmm9,%zmm9{%k1}{z}
kmovq  %k1,%rax
mov    0xc78(%rdi),%r10
vmovdqu64 %zmm8,(%r10,%r9,1)
mov    0xc80(%rdi),%r10
vmovdqu64 %zmm9,(%r10,%r9,1)
mov    0xc58(%rdi),%r10
mov    %r9d,0x1c(%r10,%r8,1)
popcnt %rax,%rax
add    %r9d,%eax
mov    0xc40(%rdi),%r9
vmovdqu64 %zmm7,(%r9,%r8,2)
add    $0x20,%r8
cmp    %r8,%rdx
jne    
vzeroupper
ret
xor    %eax,%eax
ret
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3

:
cmpl   $0x0,0xa88(%rdi)
je     
push   %r14
push   %rbx
xor    %eax,%eax
mov    $0xffffffffffffffff,%rdx
jmp    
nopl   0x0(%rax,%rax,1)
xor    %ecx,%ecx
mov    0xc88(%rdi),%r8
mov    %cl,(%r8,%rax,1)
inc    %rax
mov    0xa88(%rdi),%ecx
cmp    %rcx,%rax
jae    
mov    0xb78(%rdi),%rcx
cmpb   $0x2,(%rcx,%rax,1)
jne    
mov    0xa68(%rdi),%rcx
mov    0xbd0(%rdi),%r8
mov    (%rcx,%rax,4),%ecx
mov    0x651b8(%rsi,%rcx,4),%r11d
lea    0x1(%rcx),%r10d
mov    %r10d,%ecx
sub    %r11d,%ecx
mov    %ecx,%ebx
and    $0xffffffc0,%ebx
mov    0x28(%r8,%rbx,1),%r9
mov    0x68(%r8,%rbx,1),%rbx
cmp    $0x40,%r11d
mov    $0x40,%r14d
cmovb  %r11d,%r14d
shlx   %r14,%rdx,%r14
not    %r14
cmovae %rdx,%r14
shrd   %cl,%rbx,%r9
and    %r14,%r9
cmp    $0x41,%r11d
jae    
cmp    $0x1,%r9
mov    $0x0,%ecx
adc    $0x1,%cl
jmp    
add    $0x40,%ecx
cmp    %r10d,%ecx
jae    
mov    %ecx,%r11d
and    $0x3f,%r11d
mov    $0x40,%ebx
sub    %r11d,%ebx
mov    %r10d,%r14d
sub    %ecx,%r14d
cmp    %ebx,%r14d
cmovae %ebx,%r14d
cmp    $0x40,%r14d
shlx   %r14,%rdx,%rbx
not    %rbx
shlx   %r11,%rbx,%r11
cmove  %rdx,%r11
add    %ecx,%r14d
and    $0xffffffc0,%ecx
and    0x28(%r8,%rcx,1),%r11
or     %r11,%r9
mov    %r14d,%ecx
cmp    %r10d,%r14d
jb     
jmp    
pop    %rbx
pop    %r14
ret
int3
int3
int3
int3
int3

:
push   %rbp
mov    %rsp,%rbp
and    $0xffffffffffffffc0,%rsp
sub    $0xc00,%rsp
lea    0x80(%rsp),%rdi
call   
movl   $0x0,0x28(%rsp)
movl   $0x0,0x70(%rsp)
movl   $0x0,0x30(%rsp)
cmpl   $0x80,0x30(%rsp)
jb     
movl   $0x2,0x40(%rsp)
jmp    
movb   $0x0,0x39(%rsp)
movl   $0x0,0x6c(%rsp)
mov    0x6c(%rsp),%eax
cmp    $0xc,%rax
jb     
movl   $0x5,0x40(%rsp)
jmp    
mov    $0x1,%al
testb  $0x1,0x39(%rsp)
jne    
mov    0x6c(%rsp),%eax
lea    -0x1dd2bfc(%rip),%rcx        # 
movzbl (%rcx,%rax,1),%eax
cmp    0x30(%rsp),%eax
sete   %al
and    $0x1,%al
mov    %al,0x39(%rsp)
mov    0x6c(%rsp),%eax
add    $0x1,%eax
mov    %eax,0x6c(%rsp)
jmp    
xor    %eax,%eax
cmpl   $0x57,0x30(%rsp)
jb     
cmpl   $0x70,0x30(%rsp)
setb   %al
and    $0x1,%al
mov    %al,0x53(%rsp)
xor    %eax,%eax
cmpl   $0x57,0x30(%rsp)
jb     
cmpl   $0x5f,0x30(%rsp)
setb   %al
and    $0x1,%al
mov    %al,0x38(%rsp)
movl   $0x0,0x58(%rsp)
movb   $0x0,0x37(%rsp)
movl   $0x0,0x3c(%rsp)
cmpl   $0x4,0x3c(%rsp)
jb     
movl   $0x8,0x40(%rsp)
jmp    
lea    0x80(%rsp),%rax
mov    0x3c(%rsp),%ecx
shl    $0x7,%rcx
add    %rcx,%rax
mov    0x30(%rsp),%ecx
mov    (%rax,%rcx,1),%al
mov    %al,0x35(%rsp)
lea    0x80(%rsp),%rax
add    $0x200,%rax
mov    0x3c(%rsp),%ecx
shl    $0x7,%rcx
add    %rcx,%rax
mov    0x30(%rsp),%ecx
mov    (%rax,%rcx,1),%al
mov    %al,0x2f(%rsp)
movzbl 0x35(%rsp),%eax
cmp    $0x0,%eax
setne  %al
and    $0x1,%al
mov    %al,0x34(%rsp)
movzbl 0x35(%rsp),%ecx
xor    %eax,%eax
cmp    $0x40,%ecx
jne    
xor    %eax,%eax
cmpl   $0x1,0x3c(%rsp)
jne    
xor    %eax,%eax
testb  $0x1,0x38(%rsp)
je     
cmpl   $0x5b,0x30(%rsp)
setb   %al
and    $0x1,%al
mov    %al,0x52(%rsp)
movzbl 0x35(%rsp),%ecx
xor    %eax,%eax
cmp    $0x41,%ecx
jne    
xor    %eax,%eax
cmpl   $0x3,0x3c(%rsp)
jne    
mov    0x38(%rsp),%al
and    $0x1,%al
mov    %al,0x51(%rsp)
movzbl 0x2f(%rsp),%ecx
mov    $0x1,%al
cmp    $0x10,%ecx
jl     
movzbl 0x2f(%rsp),%ecx
mov    $0x1,%al
cmp    $0x80,%ecx
je     
movzbl 0x2f(%rsp),%eax
cmp    $0x81,%eax
jne    
mov    $0x1,%al
cmpl   $0x0,0x3c(%rsp)
je     
movzbl 0x2f(%rsp),%ecx
xor    %eax,%eax
cmp    $0x82,%ecx
jne    
testb  $0x1,0x39(%rsp)
je     
cmpl   $0x3,0x3c(%rsp)
sete   %al
and    $0x1,%al
movzbl %al,%eax
jmp    
cmpl   $0x1,0x3c(%rsp)
setbe  %al
and    $0x1,%al
movzbl %al,%eax
cmp    $0x0,%eax
setne  %al
and    $0x1,%al
mov    %al,0x50(%rsp)
xor    %eax,%eax
testb  $0x1,0x34(%rsp)
je     
xor    %eax,%eax
testb  $0x1,0x37(%rsp)
je     
mov    0x53(%rsp),%al
xor    $0xff,%al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
movzbl 0x35(%rsp),%ecx
xor    %eax,%eax
cmp    $0x40,%ecx
jb     
xor    %eax,%eax
testb  $0x1,0x52(%rsp)
jne    
mov    0x51(%rsp),%al
xor    $0xff,%al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
xor    %eax,%eax
testb  $0x1,0x34(%rsp)
jne    
movzbl 0x2f(%rsp),%eax
cmp    $0x0,%eax
setne  %al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
mov    0x50(%rsp),%al
xor    $0xff,%al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
mov    0x34(%rsp),%al
and    $0x1,%al
movzbl %al,%eax
add    0x58(%rsp),%eax
mov    %eax,0x58(%rsp)
mov    $0x1,%al
testb  $0x1,0x37(%rsp)
jne    
mov    0x34(%rsp),%al
xor    $0xff,%al
and    $0x1,%al
mov    %al,0x37(%rsp)
mov    0x3c(%rsp),%eax
add    $0x1,%eax
mov    %eax,0x3c(%rsp)
jmp    
mov    0x30(%rsp),%eax
movzbl 0x480(%rsp,%rax,1),%eax
cmp    0x58(%rsp),%eax
setne  %al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
xor    %eax,%eax
testb  $0x1,0x38(%rsp)
je     
mov    0x30(%rsp),%eax
movzbl 0x200(%rsp,%rax,1),%ecx
mov    $0x1,%al
cmp    $0x41,%ecx
jne    
mov    0x30(%rsp),%eax
movzbl 0x100(%rsp,%rax,1),%eax
cmp    $0x40,%eax
sete   %al
and    $0x1,%al
movzbl %al,%eax
cmpl   $0x5b,0x30(%rsp)
setb   %cl
and    $0x1,%cl
movzbl %cl,%ecx
cmp    %ecx,%eax
setne  %al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
xor    %eax,%eax
cmpl   $0x70,0x30(%rsp)
jb     
cmpl   $0x0,0x58(%rsp)
setne  %al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
xor    %eax,%eax
cmpl   $0x0,0x30(%rsp)
je     
xor    %eax,%eax
cmpl   $0x40,0x30(%rsp)
jae    
mov    $0x1,%al
cmpl   $0x1,0x58(%rsp)
jne    
mov    0x30(%rsp),%eax
movzbl 0x80(%rsp,%rax,1),%ecx
mov    $0x1,%al
cmp    0x30(%rsp),%ecx
jne    
mov    0x30(%rsp),%eax
movzbl 0x280(%rsp,%rax,1),%eax
cmp    $0x80,%eax
setne  %al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
xor    %eax,%eax
cmpl   $0x40,0x30(%rsp)
jb     
cmpl   $0x0,0x58(%rsp)
setne  %al
and    $0x1,%al
movzbl %al,%eax
add    0x70(%rsp),%eax
mov    %eax,0x70(%rsp)
mov    0x30(%rsp),%eax
add    $0x1,%eax
mov    %eax,0x30(%rsp)
jmp    
movl   $0x0,0x74(%rsp)
movl   $0x0,0x44(%rsp)
cmpl   $0x80,0x44(%rsp)
jb     
movl   $0xb,0x40(%rsp)
jmp    
movl   $0x0,0x54(%rsp)
cmpl   $0x2,0x54(%rsp)
jb     
movl   $0xe,0x40(%rsp)
jmp    
lea    0x80(%rsp),%rax
add    $0x580,%rax
mov    0x54(%rsp),%ecx
shl    $0x7,%rcx
add    %rcx,%rax
mov    0x44(%rsp),%ecx
mov    (%rax,%rcx,1),%al
mov    %al,0x2d(%rsp)
lea    0x80(%rsp),%rax
add    $0x680,%rax
mov    0x54(%rsp),%ecx
shl    $0x7,%rcx
add    %rcx,%rax
mov    0x44(%rsp),%ecx
mov    (%rax,%rcx,1),%al
mov    %al,0x2e(%rsp)
movzbl 0x2d(%rsp),%eax
cmp    $0x7f,%eax
setne  %al
and    $0x1,%al
mov    %al,0x3b(%rsp)
mov    0x3b(%rsp),%al
and    $0x1,%al
movzbl %al,%eax
movzbl 0x2e(%rsp),%ecx
cmp    $0x7f,%ecx
setne  %cl
and    $0x1,%cl
movzbl %cl,%ecx
cmp    %ecx,%eax
setne  %al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
testb  $0x1,0x3b(%rsp)
je     
movzbl 0x2e(%rsp),%eax
cmp    $0x7f,%eax
je     
movzbl 0x2d(%rsp),%ecx
mov    $0x1,%al
cmp    $0x66,%ecx
jb     
movzbl 0x2d(%rsp),%ecx
mov    $0x1,%al
cmp    $0x6b,%ecx
jae    
movzbl 0x2e(%rsp),%ecx
mov    $0x1,%al
cmp    $0x6b,%ecx
jb     
movzbl 0x2e(%rsp),%eax
cmp    $0x70,%eax
setae  %al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
movzbl 0x2d(%rsp),%eax
and    $0x7f,%eax
mov    %eax,%eax
movzbl 0x480(%rsp,%rax,1),%ecx
mov    $0x1,%al
cmp    $0x4,%ecx
jne    
movzbl 0x2d(%rsp),%eax
and    $0x7f,%eax
mov    %eax,%eax
movzbl 0x480(%rsp,%rax,1),%eax
movzbl 0x2e(%rsp),%ecx
and    $0x7f,%ecx
mov    %ecx,%ecx
movzbl 0x480(%rsp,%rcx,1),%ecx
add    %ecx,%eax
mov    0x44(%rsp),%ecx
movzbl 0x480(%rsp,%rcx,1),%ecx
add    $0x6,%ecx
add    0x54(%rsp),%ecx
cmp    %ecx,%eax
setne  %al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
movl   $0x0,0x48(%rsp)
mov    0x48(%rsp),%ecx
mov    0x44(%rsp),%eax
movzbl 0x480(%rsp,%rax,1),%edx
xor    %eax,%eax
cmp    %edx,%ecx
jae    
cmpl   $0x4,0x48(%rsp)
setb   %al
test   $0x1,%al
jne    
movl   $0x11,0x40(%rsp)
jmp    
lea    0x80(%rsp),%rax
mov    0x48(%rsp),%ecx
shl    $0x7,%rcx
add    %rcx,%rax
movzbl 0x2d(%rsp),%ecx
and    $0x7f,%ecx
mov    %ecx,%ecx
movzbl (%rax,%rcx,1),%ecx
lea    0x80(%rsp),%rax
mov    0x48(%rsp),%edx
shl    $0x7,%rdx
add    %rdx,%rax
mov    0x44(%rsp),%edx
movzbl (%rax,%rdx,1),%edx
mov    $0x1,%al
cmp    %edx,%ecx
jne    
lea    0x80(%rsp),%rax
add    $0x200,%rax
mov    0x48(%rsp),%ecx
shl    $0x7,%rcx
add    %rcx,%rax
movzbl 0x2d(%rsp),%ecx
and    $0x7f,%ecx
mov    %ecx,%ecx
movzbl (%rax,%rcx,1),%eax
lea    0x80(%rsp),%rcx
add    $0x200,%rcx
mov    0x48(%rsp),%edx
shl    $0x7,%rdx
add    %rdx,%rcx
mov    0x44(%rsp),%edx
movzbl (%rcx,%rdx,1),%ecx
cmp    %ecx,%eax
setne  %al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
mov    0x48(%rsp),%eax
add    $0x1,%eax
mov    %eax,0x48(%rsp)
jmp    
mov    0x74(%rsp),%eax
add    $0x1,%eax
mov    %eax,0x74(%rsp)
mov    0x54(%rsp),%eax
add    $0x1,%eax
mov    %eax,0x54(%rsp)
jmp    
jmp    
mov    0x44(%rsp),%eax
add    $0x1,%eax
mov    %eax,0x44(%rsp)
jmp    
cmpl   $0x9,0x74(%rsp)
setne  %al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
movq   $0x0,0x78(%rsp)
movl   $0x0,0x68(%rsp)
cmpl   $0x40,0x68(%rsp)
jb     
movl   $0x14,0x40(%rsp)
jmp    
mov    0x68(%rsp),%eax
movzbl 0x5c0(%rsp,%rax,1),%eax
cmp    $0x40,%eax
setge  %al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
mov    0x68(%rsp),%eax
movzbl 0x5c0(%rsp,%rax,1),%eax
and    $0x3f,%eax
mov    %eax,%ecx
mov    $0x1,%eax
shl    %cl,%rax
or     0x78(%rsp),%rax
mov    %rax,0x78(%rsp)
mov    0x68(%rsp),%eax
add    $0x1,%eax
mov    %eax,0x68(%rsp)
jmp    
cmpq   $0xffffffffffffffff,0x78(%rsp)
setne  %al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
movl   $0x0,0x64(%rsp)
cmpl   $0x40,0x64(%rsp)
jb     
movl   $0x17,0x40(%rsp)
jmp    
mov    0x64(%rsp),%eax
movzbl 0x980(%rsp,%rax,1),%eax
cmp    0x64(%rsp),%eax
setne  %al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
mov    0x64(%rsp),%eax
add    $0x1,%eax
mov    %eax,0x64(%rsp)
jmp    
movl   $0x0,0x60(%rsp)
cmpl   $0x40,0x60(%rsp)
jb     
movl   $0x1a,0x40(%rsp)
jmp    
movb   $0x0,0x36(%rsp)
movl   $0x0,0x5c(%rsp)
mov    0x5c(%rsp),%eax
cmp    $0xb,%rax
jb     
movl   $0x1d,0x40(%rsp)
jmp    
mov    0x5c(%rsp),%eax
lea    -0x1dd32f3(%rip),%rcx        # 
movzbl (%rcx,%rax,2),%eax
cmp    0x60(%rsp),%eax
jne    
mov    0x5c(%rsp),%eax
lea    -0x1dd3308(%rip),%rcx        # 
movzbl 0x1(%rcx,%rax,2),%eax
jmp    
movzbl 0x36(%rsp),%eax
mov    %al,0x36(%rsp)
mov    0x5c(%rsp),%eax
add    $0x1,%eax
mov    %eax,0x5c(%rsp)
jmp    
mov    0x60(%rsp),%eax
movzbl 0x500(%rsp,%rax,1),%eax
movzbl 0x36(%rsp),%ecx
cmp    %ecx,%eax
setne  %al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
mov    0x60(%rsp),%eax
add    $0x1,%eax
mov    %eax,0x60(%rsp)
jmp    
lea    0x9d0(%rsp),%rdi
xor    %esi,%esi
mov    $0x220,%edx
call   
lea    0x9d0(%rsp),%rdi
call   
and    $0x1,%al
mov    %al,0x4f(%rsp)
mov    $0x1,%al
testb  $0x1,0x4f(%rsp)
je     
lea    0x9d0(%rsp),%rdi
mov    $0x8,%esi
call   
movzbl %al,%ecx
mov    $0x1,%al
cmp    $0x0,%ecx
jne    
lea    0x9d0(%rsp),%rdi
mov    $0x8,%esi
call   
movzbl %al,%eax
cmp    $0x0,%eax
setne  %al
and    $0x1,%al
movzbl %al,%eax
add    0x28(%rsp),%eax
mov    %eax,0x28(%rsp)
lea    0x9d0(%rsp),%rdi
call   
xor    %eax,%eax
cmpl   $0x0,0x28(%rsp)
jne    
cmpl   $0x30,0x70(%rsp)
sete   %al
and    $0x1,%al
mov    %al,0x3a(%rsp)
testb  $0x1,0x3a(%rsp)
jne    
lea    0x215918a(%rip),%rax        # 
mov    (%rax),%rdi
mov    0x70(%rsp),%edx
mov    0x28(%rsp),%r8d
lea    -0x1b678db(%rip),%rsi        # 
mov    $0x30,%ecx
mov    $0x0,%al
call   
mov    0x3a(%rsp),%al
movl   $0x1,0x40(%rsp)
and    $0x1,%al
mov    %rbp,%rsp
pop    %rbp
ret

:
push   %rbp
push   %r15
push   %r14
push   %r13
push   %r12
push   %rbx
sub    $0x423b8,%rsp
mov    %rdi,0x178(%rsp)
mov    %rsi,0xf8(%rsp)
mov    %rdx,0x128(%rsp)
mov    %rcx,0x120(%rsp)
movl   $0x1,0xec(%rsp)
mov    %r8,0xe0(%rsp)
lea    0x180(%rsp),%rdi
mov    0x178(%rsp),%rcx
mov    0xf8(%rsp),%r8
lea    -0x1cd8d90(%rip),%rdx        # 
mov    $0x200,%esi
mov    $0x0,%al
call   
lea    0x180(%rsp),%rbx
mov    0x128(%rsp),%r14
mov    0x128(%rsp),%rdi
call   
mov    %rbx,%rdi
mov    %r14,%rsi
mov    %rax,%rdx
call   
and    $0x1,%al
mov    %al,0xd7(%rsp)
lea    0x1ca8(%rsp),%rdi
xor    %esi,%esi
mov    $0x20388,%edx
call   
movb   $0x1,0x1cb9(%rsp)
movl   $0x1,0x1cbc(%rsp)
movl   $0x1,0x1cc0(%rsp)
movb   $0x95,0x22a0(%rsp)
movw   $0x2e7,0x28ac(%rsp)
lea    0x388(%rsp),%rdi
xor    %esi,%esi
mov    $0xc90,%edx
call   
lea    0x1ca8(%rsp),%rax
mov    %rax,0x1010(%rsp)
lea    0x215904e(%rip),%rax        # 
mov    (%rax),%rdi
call   
xor    %ecx,%ecx
testb  $0x1,0xd7(%rsp)
je     
lea    0x180(%rsp),%rsi
mov    0x120(%rsp),%rdx
mov    0xec(%rsp),%ecx
lea    0x388(%rsp),%rdi
call   
xor    %ecx,%ecx
test   $0x1,%al
jne    
jmp    
xor    %ecx,%ecx
cmpq   $0x1,0x398(%rsp)
jne    
cmpq   $0x0,0x3a0(%rsp)
sete   %cl
and    $0x1,%cl
mov    %cl,0xd7(%rsp)
lea    0x1ca8(%rsp),%rax
add    $0x11b0,%rax
mov    %rax,0xd8(%rsp)
mov    0xd8(%rsp),%rax
mov    0x2e8(%rax),%rax
mov    0xd8(%rsp),%rcx
add    0x2f0(%rcx),%rax
mov    0xd8(%rsp),%rcx
add    0x2f8(%rcx),%rax
mov    0xd8(%rsp),%rcx
add    0x300(%rcx),%rax
mov    %rax,0x170(%rsp)
mov    0xd8(%rsp),%rax
mov    0x2c0(%rax),%rcx
mov    0xe0(%rsp),%rax
mov    (%rax),%edx
xor    %eax,%eax
cmp    %rdx,%rcx
jne    
mov    0xd8(%rsp),%rax
mov    0x2d0(%rax),%rcx
mov    0xe0(%rsp),%rax
mov    0x4(%rax),%edx
xor    %eax,%eax
cmp    %rdx,%rcx
jne    
mov    0xd8(%rsp),%rax
mov    0x2e0(%rax),%rcx
mov    0xe0(%rsp),%rax
mov    0x8(%rax),%edx
xor    %eax,%eax
cmp    %rdx,%rcx
jne    
mov    0xd8(%rsp),%rax
mov    0x2e8(%rax),%rcx
mov    0xe0(%rsp),%rax
mov    0xc(%rax),%edx
xor    %eax,%eax
cmp    %rdx,%rcx
jne    
mov    0xd8(%rsp),%rax
mov    0x2f0(%rax),%rcx
mov    0xe0(%rsp),%rax
mov    0x10(%rax),%edx
xor    %eax,%eax
cmp    %rdx,%rcx
jne    
mov    0xd8(%rsp),%rax
mov    0x2f8(%rax),%rcx
mov    0xe0(%rsp),%rax
mov    0x14(%rax),%edx
xor    %eax,%eax
cmp    %rdx,%rcx
jne    
mov    0xd8(%rsp),%rax
mov    0x300(%rax),%rcx
mov    0xe0(%rsp),%rax
mov    0x18(%rax),%edx
xor    %eax,%eax
cmp    %rdx,%rcx
jne    
mov    0xd8(%rsp),%rax
mov    0x320(%rax),%rcx
mov    0xe0(%rsp),%rax
mov    0x1c(%rax),%edx
xor    %eax,%eax
cmp    %rdx,%rcx
jne    
mov    0xd8(%rsp),%rax
mov    0x330(%rax),%rcx
mov    0xe0(%rsp),%rax
mov    0x20(%rax),%edx
xor    %eax,%eax
cmp    %rdx,%rcx
jne    
mov    0xd8(%rsp),%rax
mov    0x338(%rax),%rcx
mov    0xe0(%rsp),%rax
mov    0x24(%rax),%edx
xor    %eax,%eax
cmp    %rdx,%rcx
jne    
mov    0xd8(%rsp),%rax
mov    0x340(%rax),%rcx
mov    0xe0(%rsp),%rax
mov    0x28(%rax),%edx
xor    %eax,%eax
cmp    %rdx,%rcx
jne    
mov    0xd8(%rsp),%rcx
xor    %eax,%eax
cmpq   $0x0,0x308(%rcx)
jne    
mov    0xd8(%rsp),%rcx
xor    %eax,%eax
cmpq   $0x0,0x310(%rcx)
jne    
mov    0xd8(%rsp),%rcx
xor    %eax,%eax
cmpq   $0x0,0x328(%rcx)
jne    
mov    0xd8(%rsp),%rax
mov    0x2d0(%rax),%rcx
add    0x170(%rsp),%rcx
mov    0xd8(%rsp),%rdx
xor    %eax,%eax
cmp    0x2c0(%rdx),%rcx
jne    
mov    0xd8(%rsp),%rax
mov    0x2c0(%rax),%rcx
mov    0xd8(%rsp),%rax
mov    0x218(%rax),%rdx
mov    0xd8(%rsp),%rax
sub    0x228(%rax),%rdx
xor    %eax,%eax
cmp    %rdx,%rcx
jne    
mov    0xd8(%rsp),%rcx
xor    %eax,%eax
cmpq   $0x0,0x230(%rcx)
jne    
mov    0xd8(%rsp),%rcx
xor    %eax,%eax
cmpq   $0x0,0x150(%rcx)
jne    
mov    0xd8(%rsp),%rcx
xor    %eax,%eax
cmpq   $0x0,0x1b0(%rcx)
jne    
cmpq   $0x0,0x2e20(%rsp)
sete   %al
and    $0x1,%al
mov    %al,0xeb(%rsp)
testb  $0x1,0xd7(%rsp)
je     
testb  $0x1,0xeb(%rsp)
jne    
lea    0x2158cdd(%rip),%rax        # 
mov    (%rax),%rdi
mov    0xf8(%rsp),%rdx
mov    0xd7(%rsp),%al
lea    -0x1b686cc(%rip),%rcx        # 
lea    -0x1bd8fcb(%rip),%rsi        # 
test   $0x1,%al
cmovne %rsi,%rcx
mov    0xd8(%rsp),%rax
mov    0x2c0(%rax),%r8
mov    0xe0(%rsp),%rax
mov    (%rax),%r9d
mov    0xd8(%rsp),%rax
mov    0x218(%rax),%rax
mov    0xd8(%rsp),%rsi
sub    0x228(%rsi),%rax
mov    0xd8(%rsp),%rsi
mov    0x2d0(%rsi),%rsi
mov    %rsi,0x168(%rsp)
mov    0xe0(%rsp),%rsi
mov    0x4(%rsi),%esi
mov    %esi,0x11c(%rsp)
mov    0xd8(%rsp),%rsi
mov    0x2e0(%rsi),%rsi
mov    %rsi,0x160(%rsp)
mov    0xe0(%rsp),%rsi
mov    0x8(%rsi),%esi
mov    %esi,0x118(%rsp)
mov    0xd8(%rsp),%rsi
mov    0x2e8(%rsi),%rsi
mov    %rsi,0x158(%rsp)
mov    0xe0(%rsp),%rsi
mov    0xc(%rsi),%esi
mov    %esi,0x114(%rsp)
mov    0xd8(%rsp),%rsi
mov    0x2f0(%rsi),%rsi
mov    %rsi,0x150(%rsp)
mov    0xe0(%rsp),%rsi
mov    0x10(%rsi),%esi
mov    %esi,0x110(%rsp)
mov    0xd8(%rsp),%rsi
mov    0x2f8(%rsi),%rsi
mov    %rsi,0x148(%rsp)
mov    0xe0(%rsp),%rsi
mov    0x14(%rsi),%esi
mov    %esi,0x10c(%rsp)
mov    0xd8(%rsp),%rsi
mov    0x300(%rsi),%rsi
mov    %rsi,0x140(%rsp)
mov    0xe0(%rsp),%rsi
mov    0x18(%rsi),%esi
mov    %esi,0x108(%rsp)
mov    0xd8(%rsp),%rsi
mov    0x320(%rsi),%rsi
mov    %rsi,0x138(%rsp)
mov    0xe0(%rsp),%rsi
mov    0x1c(%rsi),%esi
mov    %esi,0x104(%rsp)
mov    0xd8(%rsp),%rsi
mov    0x330(%rsi),%rsi
mov    %rsi,0x130(%rsp)
mov    0xe0(%rsp),%rsi
mov    0x20(%rsi),%esi
mov    %esi,0x100(%rsp)
mov    0xd8(%rsp),%rsi
mov    0x338(%rsi),%r13
mov    0xe0(%rsp),%rsi
mov    0x24(%rsi),%r12d
mov    0xd8(%rsp),%rsi
mov    0x340(%rsi),%r15
mov    0xe0(%rsp),%rsi
mov    0x28(%rsi),%ebp
mov    0xd8(%rsp),%rsi
mov    0x308(%rsi),%r14
mov    0xd8(%rsp),%rsi
mov    0x310(%rsi),%rbx
mov    0xd8(%rsp),%rsi
mov    0x328(%rsi),%r11
mov    0x2e20(%rsp),%r10
lea    -0x1b67f0b(%rip),%rsi        # 
mov    %rax,(%rsp)
mov    0x168(%rsp),%rax
mov    %rax,0x8(%rsp)
mov    0x11c(%rsp),%eax
mov    %eax,0x10(%rsp)
mov    0x160(%rsp),%rax
mov    %rax,0x18(%rsp)
mov    0x118(%rsp),%eax
mov    %eax,0x20(%rsp)
mov    0x158(%rsp),%rax
mov    %rax,0x28(%rsp)
mov    0x114(%rsp),%eax
mov    %eax,0x30(%rsp)
mov    0x150(%rsp),%rax
mov    %rax,0x38(%rsp)
mov    0x110(%rsp),%eax
mov    %eax,0x40(%rsp)
mov    0x148(%rsp),%rax
mov    %rax,0x48(%rsp)
mov    0x10c(%rsp),%eax
mov    %eax,0x50(%rsp)
mov    0x140(%rsp),%rax
mov    %rax,0x58(%rsp)
mov    0x108(%rsp),%eax
mov    %eax,0x60(%rsp)
mov    0x138(%rsp),%rax
mov    %rax,0x68(%rsp)
mov    0x104(%rsp),%eax
mov    %eax,0x70(%rsp)
mov    0x130(%rsp),%rax
mov    %rax,0x78(%rsp)
mov    0x100(%rsp),%eax
mov    %eax,0x80(%rsp)
mov    %r13,0x88(%rsp)
mov    %r12d,0x90(%rsp)
mov    %r15,0x98(%rsp)
mov    %ebp,0xa0(%rsp)
mov    %r14,0xa8(%rsp)
mov    %rbx,0xb0(%rsp)
mov    %r11,0xb8(%rsp)
mov    %r10,0xc0(%rsp)
mov    $0x0,%al
call   
lea    0x22030(%rsp),%rdi
xor    %esi,%esi
mov    $0x20388,%edx
call   
movb   $0x1,0x22041(%rsp)
movl   $0x1,0x22044(%rsp)
movl   $0x1,0x22048(%rsp)
movb   $0x95,0x22628(%rsp)
movw   $0x6e7,0x22c34(%rsp)
lea    0x1018(%rsp),%rdi
xor    %esi,%esi
mov    $0xc90,%edx
call   
lea    0x22030(%rsp),%rax
mov    %rax,0x1ca0(%rsp)
xor    %ecx,%ecx
testb  $0x1,0xd7(%rsp)
je     
lea    0x180(%rsp),%rsi
mov    0x120(%rsp),%rdx
mov    0xec(%rsp),%ecx
lea    0x1018(%rsp),%rdi
call   
xor    %ecx,%ecx
test   $0x1,%al
jne    
jmp    
cmpq   $0x1,0x1028(%rsp)
sete   %cl
and    $0x1,%cl
mov    %cl,0xea(%rsp)
lea    0x22030(%rsp),%rax
add    $0x11b0,%rax
mov    %rax,0xf0(%rsp)
xor    %eax,%eax
testb  $0x1,0xea(%rsp)
je     
mov    0xf0(%rsp),%rax
mov    0x2d0(%rax),%rcx
mov    0xe0(%rsp),%rax
mov    0x4(%rax),%edx
xor    %eax,%eax
cmp    %rdx,%rcx
jne    
mov    0xf0(%rsp),%rax
mov    0x308(%rax),%rcx
mov    0xe0(%rsp),%rax
mov    0x4(%rax),%edx
xor    %eax,%eax
cmp    %rdx,%rcx
jne    
mov    0xe0(%rsp),%rax
cmpl   $0x3,0x4(%rax)
setae  %al
and    $0x1,%al
mov    %al,0xe9(%rsp)
testb  $0x1,0xe9(%rsp)
jne    
lea    0x2158876(%rip),%rax        # 
mov    (%rax),%rdi
mov    0xf8(%rsp),%rdx
mov    0xea(%rsp),%al
lea    -0x1b68b33(%rip),%rcx        # 
lea    -0x1bd9432(%rip),%rsi        # 
test   $0x1,%al
cmovne %rsi,%rcx
mov    0xf0(%rsp),%rax
mov    0x308(%rax),%r8
mov    0xf0(%rsp),%rax
mov    0x2d0(%rax),%r9
mov    0xe0(%rsp),%rax
mov    0x4(%rax),%eax
lea    -0x1b67f23(%rip),%rsi        # 
mov    %eax,(%rsp)
mov    $0x0,%al
call   
lea    0x180(%rsp),%rdi
call   
xor    %eax,%eax
testb  $0x1,0xd7(%rsp)
je     
xor    %eax,%eax
testb  $0x1,0xeb(%rsp)
je     
mov    0xe9(%rsp),%al
and    $0x1,%al
add    $0x423b8,%rsp
pop    %rbx
pop    %r12
pop    %r13
pop    %r14
pop    %r15
pop    %rbp
ret
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3
int3

