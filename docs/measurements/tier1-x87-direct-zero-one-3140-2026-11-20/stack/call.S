.text
.globl snapshot
.type snapshot,@function
snapshot:
  pushq %r12
  subq $16, %rsp
  movq %rcx,%r12
  movw %dx,(%rsp)
  fninit
  fldcw (%rsp)
  testl %r8d,%r8d
  jz 1f
  fldz
  fldz
  fdivp
  fstp %st(0)
1:
  testl %esi,%esi
  jz 3f
2:
  fld1
  subl $1,%esi
  jnz 2b
3:
  call *%rdi
  fxsave64 (%r12)
  fwait
  fninit
  addq $16,%rsp
  popq %r12
  ret
.size snapshot,.-snapshot

.macro leaf name, value
.globl ref_\name
.type ref_\name,@function
ref_\name:
 movl $9,marker(%rip)
 flds .L\name(%rip)
 ret
.pushsection .rodata
.balign 4
.L\name: .long \value
.popsection
.endm
leaf positive_zero,0
leaf positive_one,0x3f800000
leaf negative_zero,0x80000000
leaf negative_one,0xbf800000
.section .note.GNU-stack,"",@progbits
