# #2676's condsum loops: head's as emitted, head's without its copy, main's; each at offsets 0x10 and 0x20 of a
# 64-byte line (head's k_condsum is at 0x90 of its object, main's at 0xa0).
.text
.p2align 6
.skip 16, 0xcc
.globl v_head_10
v_head_10:
    xor %eax,%eax
    xor %ecx,%ecx
    jmp 2f
1:  mov %rcx,%rdx
    movslq (%rdi,%rdx,4),%rdx
    xor %r8d,%r8d
    mov %rdx,%r9
    cmp $0x80,%edx
    cmovg %r9,%r8
    add %r8,%rax
    add $0x1,%ecx
2:  cmp %esi,%ecx
    jl 1b
    ret

.p2align 6
.skip 32, 0xcc
.globl v_head_20
v_head_20:
    xor %eax,%eax
    xor %ecx,%ecx
    jmp 2f
1:  mov %rcx,%rdx
    movslq (%rdi,%rdx,4),%rdx
    xor %r8d,%r8d
    mov %rdx,%r9
    cmp $0x80,%edx
    cmovg %r9,%r8
    add %r8,%rax
    add $0x1,%ecx
2:  cmp %esi,%ecx
    jl 1b
    ret

.p2align 6
.skip 16, 0xcc
.globl v_nomov_10
v_nomov_10:
    xor %eax,%eax
    xor %ecx,%ecx
    jmp 2f
1:  mov %rcx,%rdx
    movslq (%rdi,%rdx,4),%rdx
    xor %r8d,%r8d
    cmp $0x80,%edx
    cmovg %rdx,%r8
    add %r8,%rax
    add $0x1,%ecx
2:  cmp %esi,%ecx
    jl 1b
    ret

.p2align 6
.skip 32, 0xcc
.globl v_nomov_20
v_nomov_20:
    xor %eax,%eax
    xor %ecx,%ecx
    jmp 2f
1:  mov %rcx,%rdx
    movslq (%rdi,%rdx,4),%rdx
    xor %r8d,%r8d
    cmp $0x80,%edx
    cmovg %rdx,%r8
    add %r8,%rax
    add $0x1,%ecx
2:  cmp %esi,%ecx
    jl 1b
    ret

.p2align 6
.skip 16, 0xcc
.globl v_main_10
v_main_10:
    xor %eax,%eax
    xor %ecx,%ecx
    jmp 2f
1:  mov %rcx,%rdx
    movslq (%rdi,%rdx,4),%rdx
    xor %r8d,%r8d
    cmp $0x80,%edx
    setg %r8b
    xor %r9d,%r9d
    test %r8d,%r8d
    cmovne %rdx,%r9
    add %r9,%rax
    add $0x1,%ecx
2:  cmp %esi,%ecx
    jl 1b
    ret

.p2align 6
.skip 32, 0xcc
.globl v_main_20
v_main_20:
    xor %eax,%eax
    xor %ecx,%ecx
    jmp 2f
1:  mov %rcx,%rdx
    movslq (%rdi,%rdx,4),%rdx
    xor %r8d,%r8d
    cmp $0x80,%edx
    setg %r8b
    xor %r9d,%r9d
    test %r8d,%r8d
    cmovne %rdx,%r9
    add %r9,%rax
    add $0x1,%ecx
2:  cmp %esi,%ecx
    jl 1b
    ret

.section .note.GNU-stack,"",@progbits
