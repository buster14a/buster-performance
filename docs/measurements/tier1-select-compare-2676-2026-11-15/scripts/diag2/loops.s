# #2676's condsum loops: head's as emitted, head's without its copy, main's; each at offsets 0x00, 0x10, 0x20 and
# 0x30 of a 64-byte line (the kernels' executables put head's k_condsum at 0x20, main's at 0x30).
.text
.p2align 6

.globl v_head_00
v_head_00:
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
.skip 48, 0xcc
.globl v_head_30
v_head_30:
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

.globl v_nomov_00
v_nomov_00:
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
.skip 48, 0xcc
.globl v_nomov_30
v_nomov_30:
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

.globl v_main_00
v_main_00:
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

.p2align 6
.skip 48, 0xcc
.globl v_main_30
v_main_30:
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
