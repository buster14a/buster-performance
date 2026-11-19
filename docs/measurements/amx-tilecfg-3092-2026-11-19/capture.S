/* SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception */
/* Arguments: six SysV GPR values, synthetic entry RSP, observation, prefix. */
.text
.globl capture
.type capture,@function
capture:
    push %rbp
    push %rbx
    push %r12
    push %r13
    push %r14
    mov %rsp,%r12
    mov %rdx,%r13
    mov %rcx,%r14
    mov %rdi,%rbx
    mov %rsi,%rsp
    mov 0(%rbx),%rdi
    mov 8(%rbx),%rsi
    mov 16(%rbx),%rdx
    mov 24(%rbx),%rcx
    mov 32(%rbx),%r8
    mov 40(%rbx),%r9
    movabs $0xfedcba9876543210,%rbp
    movabs $0xdededededededede,%rax
    movabs $0x8989898989898989,%r11
    vmovdqu64 poison(%rip),%zmm0
    jmp *%r14
.globl captured
captured:
    mov %rsp,0(%r13)
    mov %rbp,8(%r13)
    mov %rdi,16(%r13)
    mov %rsi,24(%r13)
    mov %rdx,32(%r13)
    mov %rcx,40(%r13)
    mov %r8,48(%r13)
    mov %r9,56(%r13)
    mov %r11,64(%r13)
    mov %r12,%rsp
    pop %r14
    pop %r13
    pop %r12
    pop %rbx
    pop %rbp
    vzeroupper
    ret
.size capture,.-capture
.section .rodata
poison: .fill 64,1,0xc3
.section .note.GNU-stack,"",@progbits
