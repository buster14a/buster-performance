.text
.globl callf_u32,calld_u32,dirty_u32,touch_u32
callf_u32:
calld_u32:
    jmp *%r8
dirty_u32:
    movl %edi,%eax
    movabsq $0xa5a55a5a00000000,%r10
    orq %r10,%rax
    ret
touch_u32:
    movabsq $0x87987665a5a5a5a5,%rdi
    movabsq $0xfedc9876f00d1234,%rsi
    movabsq $0xadda12349876fdec,%rdx
    ret
.section .note.GNU-stack,"",@progbits
