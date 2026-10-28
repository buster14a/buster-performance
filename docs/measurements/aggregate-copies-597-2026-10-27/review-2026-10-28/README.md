# PR #635 volatile-copy correction, October 28, 2026

Correctness evidence for `27093296181fa69ae62b2941bf7202d1ddf4fa59`, based on
PR head `3afeb6bd2b2ab0bd9b709080782e3e778bc30adf`. This does not extend the
parent record's historical timing claims at implementation `03d79f50`.

Follow-up coverage found that an unqualified 513-byte record containing a
volatile member selected ordinary memmove, including for self-assignment.
The runtime-symbol shape assertion failed on both scalar/vector paths;
destination-qualified assignments passed. Clang 23.1.4 emits volatile memcpy
for that member-containing assignment/self-assignment (`member-volatile.c/.ll`).
The discovery is [review 5679998788](https://github.com/buster14a/buster/pull/635#pullrequestreview-5679998788).
Additional cases exposed initializer part types omitting the declared
destination qualifier and CHECK_OP_CONVERT erasing a returned source's
qualifier. Clang IR in `initialization-volatile.ll` independently marks all
three source/destination initialization/return copies volatile.

The correction retains initializer destination qualifiers and forwards
aggregate conversion provenance. Contained volatility is computed once in
the shared type-facts byte with memoized nonrecursive traversal of by-value
records, arrays and aligned/atomic wrappers. Pointer/function pointees stop
the walk. A bounded scalar/vector member scan skips graph scratch when no
member is volatile; each copy then has a constant-time lookup.

Ryzen 9 7940HS local host, Clang 23.1.4, O1 with ASan+UBSan: **811 focused
checks, zero failures**. `full-probe-complete.log` is the original successful
transcript; `focused-build.sha256` identifies executable/harness and
`toolchain.txt` the compiler. These are local correctness results, not 9700X
performance or complete integrated compiler qualification.

Coverage retains original threshold/large-copy/native Clang comparisons and
adds destination-only volatility, direct/nested volatile members, nested
volatile scalar arrays, pointers-to-volatile negative controls, initializer/
return forwarding, guarded member tails through 80 and transactional graph
allocation failure. Native cases exercise nested arrays/self-copy/return and
volatile destination initialization. Code-shape checks forbid a library call
for volatile copies, so final-byte equality cannot hide skipped self-accesses.

`full-probe.c` adapts Buster's original main TU includes into a focused entry
point, with module entry points static. It includes the corrected compiler
and invokes its committed tests; original source notices remain. No external
implementation is imported. The source include path is the pinned checkout:

    clang -O1 -g -fsanitize=address,undefined -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -Wno-unused-function -Wno-unused-variable -Wno-undefined-internal /path/to/full-probe.c -o /path/to/full-probe -lpthread -ldl -lm
    /path/to/full-probe

Run the compile through `cores -n 1 --` where the owner's allocator is
available. The coordinator integrates with packed lowering separately and
records final target CI; this receipt does not infer those results.
