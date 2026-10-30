# Untimed runtime-scan diagnostic generator

This original C tool generates diagnostic clones of PR #920's lowering source.
It is input-independent and supports the same SQLite and Lua compilations as
the corresponding uninstrumented compiler. Do not use these clones for timing.

```sh
cc -std=c17 -O2 -Wall -Wextra -Werror runtime_probe_source.c -o runtime-probe-source
./runtime-probe-source base BASELINE_LOWER_C NEW_BASELINE_LOWER_C
./runtime-probe-source candidate CANDIDATE_LOWER_C NEW_CANDIDATE_LOWER_C
./runtime-probe-source candidate-mutant CANDIDATE_LOWER_C NEW_MUTANT_LOWER_C
```

The caller must pin each original input source hash. The generator requires
unique exact source anchors for the requested mode and refuses already
instrumented input, the other mode's source, or an existing output path.

Baseline mode retains the count returned by the producer already called in
production; it adds no producer pass. The original full-token runtime scan
remains unchanged. Candidate mode copies the preseeded runtime table at the
actual production caller, runs the existing helper's full-token scalar path
into that copy, runs the production path into the actual table, and aborts if
the complete tables differ.

`candidate-mutant` is a separate untimed plumbing negative control. Immediately
before that same table comparison, it flips the low bit of exactly the copied
errno slot using `SymbolId`, after asserting that the enum names a valid slot
in a nonempty table. The production table is unchanged. This mode must print
`oracle-equal=0`, emit `runtime-scan full-token oracle mismatch`, and abort on a
real valid lowering invocation. The ordinary candidate mode's generated source
is byte-identical to the version without this negative-control mode.

Each valid lower preparation prints the scalar-path and spelled flags, full
token count, compact producer count, production runtime-scan visit count,
errno index, and every resulting runtime slot as `index:identifier:symbol`.
Candidate output additionally reports `oracle-equal=1` on success. The copied
and actual tables include the preseeded errno slot. A false spelled flag has
zero production runtime-scan visits. A scalar candidate visits the full token
stream; a native vector candidate visits the compact list.

This instrumentation only establishes count and same-state table parity in
untimed diagnostic runs. Require emitted object equality with the corresponding
uninstrumented compilation before accepting a corpus receipt. Keep the original
production binaries and all their costs in the separate timing campaign.

The count comparison isolates the runtime scan visits, not all lowering work:
both production versions still pay for the existing declaration-list producer,
its list storage, the reverse initializer/local walk, identifier lookups, and
all remaining lower preparation. Time those costs with the uninstrumented
compiler, whose whole invocation and lower stage both include them.
