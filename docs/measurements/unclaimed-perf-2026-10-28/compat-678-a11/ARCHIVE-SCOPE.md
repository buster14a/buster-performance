# Archive scope: frozen a11 compatibility stage

[Frozen report](README.md), [source identity](source-identity.txt),
[binary identities](compiler-identities.txt), [byte/runtime controls](controls.log).
Source `06150c52db27a31fe0106acbe00c1e34ae8249d0` composes pinned PR678
`a11d8065104f07ce8ab3e752404bb48f07df9d4c`, main416 and qualified next-main d3
with the retained performance union. This stage is not later-PR acceptance.
Native/generic builds and the recorded correctness suites pass except the
original generic location-limit fixture's benchmark-availability expectation;
that negative full log is preserved. Test-only correction 95dd639c and focused
native/generic rechecks validate all five rows through the real command gate.
This stage remains frozen; [main321/nullable-ASM compatibility](../compat-678-current/README.md)
is qualified separately. These are compatibility and byte/runtime controls,
without a performance claim. Binaries remain local raw with COLLECTION identities.
