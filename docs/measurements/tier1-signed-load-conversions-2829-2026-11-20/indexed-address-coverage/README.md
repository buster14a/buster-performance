# Indexed source addresses in the conversion test

The fixture on `cfaff628dca5f82e7bd35a8b855f4f7795e8b840` exercises the real selector, address builder and record expander. It covers base-only operands and every SIB scale, a negative displacement, both integer source widths and floating result widths, and ordinary and volatile source accesses. The [compiler test totals](compiler-checks.tsv) come from this head. Rebuilding the eight kernel objects and 32 placed executables with pinned Clang 23.1.4 reproduced every SHA-256 from `450efe4c01f19148e691a82ffce7197c3b6c362e`. The [artifact ledger](results.tsv) contains both digests for every comparison.

The measured program instructions are identical across the test update. Direct measurements already in the parent directory refer to those executable identities. Separate scheduling-model calibration for indexed operands still requires the shared Ryzen 7 9700X.

On the prior head the [third hosted frozen-musl run](https://github.com/buster14a/buster/actions/runs/44647443274/job/136037849115) finished in 46.7 seconds with 569 symbols compared and zero unexplained differences, following a 600-second timeout on the first attempt. A later [artifact aggregation](https://github.com/buster14a/buster/actions/runs/44647443274/job/136044999479) returned HTTP 404. These refer to the older commit.
