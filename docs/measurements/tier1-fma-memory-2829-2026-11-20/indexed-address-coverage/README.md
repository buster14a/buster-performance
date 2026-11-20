# Indexed source addresses in the conversion test

The fixture on `269f35954a8da56378f5b56899b2dcc458be53a6` exercises the real selector, address builder and record expander. It covers base-only operands and every SIB scale, a negative displacement, both integer source widths and floating result widths, and ordinary and volatile source accesses. The [compiler test totals](compiler-checks.tsv) come from this head. Rebuilding the eight kernel objects and 32 placed executables with pinned Clang 23.1.4 reproduced every SHA-256 from `f7c6d11ee66b326395bab8b7a3f780ed8ed49862`. The [artifact ledger](results.tsv) contains both digests for every comparison.

The measured program instructions are identical across the test update. Direct measurements already in the parent directory refer to those executable identities. Separate scheduling-model calibration for indexed operands still requires the shared Ryzen 7 9700X.
