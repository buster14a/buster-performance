# Archive scope: full private compatibility union on main321

[Authoritative report](README.md), [native/generic byte and qemu64 controls](controls.log).
Frozen source is `d74d87366e2f7458bc7997b2314d94b0f5cdf96b`, including pure main
`321f5976d5af2b4c54fa45a639895739f2b8a8c9`, next-main d3, qualified nullable ASM
`dc15a18ed3ad273888ae1cb87e903969e876acfa` and pinned PR678
`a11d8065104f07ce8ab3e752404bb48f07df9d4c`. Rejected #653 is absent.
Both 41-unit builds and all 26 corrected native/generic suite commands pass.
True qemu64 compile/link/runtime, printer and byte controls pass. Initial
removed-table syntax attempts and mistaken lane --count invocations are
preserved and excluded from correctness coverage; final logs contain corrections.
The earlier worker-budget qemu64 18/0 lifecycle result is prior unchanged-module
evidence, not a new-head run. The [earlier a11 stage](../compat-678-a11/README.md)
and [older pristine negatives](../pr-678-controls/README.md) remain separate.
This is a qualified full private union, not main or a throughput measurement.
The separate minimal companion folder/branch remains provisional and is not
included or accepted by this collection. No new target work was performed.
