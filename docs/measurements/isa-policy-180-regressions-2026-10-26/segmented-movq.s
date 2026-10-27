.text
movq %fs:(%r8),%xmm0
movq %gs:(%r8),%xmm0
movq %fs:(%rax),%xmm8
movq %gs:(%rax),%xmm8
movq %xmm0,%fs:(%r8)
movq %xmm0,%gs:(%r8)
movq %xmm8,%fs:(%rax)
movq %xmm8,%gs:(%rax)
