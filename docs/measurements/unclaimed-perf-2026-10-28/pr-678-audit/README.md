# Exact PR 678 compatibility audit

Read-only inventory compared exact draft head
`8af0904bfa103398af64f292d560cfbdc6fdc22d` with retained performance changes
on main416 integration `b8cd163ce33bb8042e42fd9fea7c675ae13fa487`.
The independent inventory covered 56 operations in added source lines.

Six genuinely unsupported new operations were reproduced with Clang 23
`-O3 -march=x86-64`, using the draft's unchanged scalar headers:

- Printer offsets: `_mm512_mask_add_epi16`, `_mm256_extract_epi16`.
- Literal payloads: `_mm512_mask_cvtepi64_storeu_epi8`, `_epi16`, `_epi32`.
- Warning counts: `_mm_popcnt_u64`.

The initial C probes and actual expected compile diagnostics are retained as
`prefix.c`, `narrow.c`, `popcnt.c`, and `*-baseline.log`. Printer regression
fixtures call the offset helper directly, so ordinary scalar printer selection
cannot remove its compile dependency.

Root authorized minimal original shims and meaningful boundary tests in only
`host_scalar.h`, `host_scalar_vectors.h`, and `tests/host-fallback/edge_cases.c`.
The signed local fix is `b71c9cfa627c2fb6f0af3b9beda9f18403c45d85`, parent
`490df4fb`, on private compatibility branch; no PR branch was modified or pushed.
`shim-followup.patch` retains these three-file edits.

Focused validation used separate `cores -n 2` grants:

- Baseline O2 edge-case build and run pass.
- Baseline O1 UBSan, no recovery, build and run pass.
- Actual printer prefix helper extracted from production builds and runs with
  both baseline and native flags.
- Narrowing-store and popcount baseline compile probes pass with the shims.
- No whitespace errors. An independent source review found no concrete defect.

Tests include every 16-bit extraction lane with high bits set, 67 mask patterns
and modulo additions preserving inactive source lanes, 131 independent
popcount cases, every 8-bit mask for each truncating 64-to-8/16/32-bit store,
unaligned output, surrounding canaries, inaccessible tail pages, zero-mask
NULL addresses and signed/unsigned low-bit boundaries. Native paths retain
the existing header/feature guards. No external implementation was imported.

The native helper probe initially lacked its own stdint/stdbool includes,
which baseline scalar headers had supplied indirectly; the corrected standalone
probe includes both explicitly. This was a probe issue, not a compiler-source
failure. The actual compiler already includes those headers.

Diagnostic buffering introduces no new SIMD operation. Both the diagnostic
implementation/tests and printer span were identical to their qualified
versions on the pre-678 current-main audit. #682's optimize-off regions wrap
checker tests, not production printing/diagnostics or benchmark timed code.
Full compiler native/scalar/runtime compatibility qualification belongs to the
parent/post641 campaign; the focused results above do not replace it.
