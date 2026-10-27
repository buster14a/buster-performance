# Review follow-up for Buster #560

Compiler head: `1193571fd09b3a2c35a74b07371070e37068721b`, following
`fa7cae05018ebd6281a6a7fbcfd64c138b3fd3e9`. The baseline remains
`b7f444eb52bb53495da751f188b6bba883bbf891`.

The follow-up addresses the two inline review threads:

- Type-form `sizeof`/`alignof` now select their retained inline VLA bound expressions through the existing type and VLA metadata. Constant dimensions, pointer types and typeof wrappers do not supply spurious parameter references. A bounded scratch worklist preserves rightmost-first diagnostics for nested and mixed dimensions.
- The named-register declaration exception checks declarators belonging to the current statement and function body. Inline members, tags, enumerators and prototype parameters are excluded. Real declarators without a register label or with an initializer still reject.

The literal `sizeof(int[n])` and `__alignof__(int[n])` review examples already
diagnosed at the earlier head; both are now explicit exact-diagnostic fixtures.
The new tests also cover the actual false rejections in constant bounds,
pointers to VLAs, mixed dimensions and inline struct/union/enum register
declarations. Twenty original asm fixtures and three deferred fixtures were
added. `sizeof(__typeof__(n))` remains accepted.

## Qualification

`review-build.log`, `review-qualification.log` and `review-source-verify.log`
record the final build, five-command qualification and matching changed-file
hashes. The exact commands, host and build flags are those in the parent
record; every target-host run held the shared 9700X lock separately, using
`EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/560` and a descriptive
review title. Clang 23.1.1 served as the target-host oracle.

| Check | Result |
|---|---|
| `test-checker-asm` | 992 checks, 632 fixtures, zero failures; scalar/vector equivalence and exact Clang naked messages/columns |
| `test-checker-deferred` | 69 fixtures, 1,096 checks, 6,456 bodies read apart, zero failures |
| `test-checker --seed 133` | 255,763 checks, zero failures |
| `test-call-graph` | 37 fixtures, zero failures |
| Frozen SQLite Clang/deferred comparison | Accepted by both; 2,608 deferred bodies, zero differences or resource failures |

The five commands passed in 22.1 seconds. The local Clang 23.1.4 asm comparison
also passes all 992 checks (`asm-local.log`). The local deferred and compiler
source call-graph commands are retained in `local.list` and `local.log`.

## Ordinary-path cost screen

`review-measurement.log` uses the unchanged parent `measure.sh`: CPU 2, frozen
SQLite, successful preflights, three executable copies and nine timed runs per
copy. All timed processes returned 0.

| Metric | Baseline | Review head | Observed change |
|---|---:|---:|---:|
| Median wall time | 142.912 ms | 143.350 ms | +0.31% |
| Median user cycles | 653.832 M | 656.200 M | +0.36% |

The wall comparison across copies spans -0.13% to +0.57%. This is a
single-placement cost screen, with the same interpretation limits as the
initial record. It does not establish a performance improvement or separate
code-placement effects from implementation cost. SQLite does not exercise
naked-body VLA worklist allocation; the positive global-bound fixture checks
successful completion of that path.

The implementation and new fixtures are original project material. Clang/LLVM
`llvmorg-23.1.1`'s `Expr.cpp` type-trait child rules were consulted as behavior
references alongside the previously recorded Sema files. No LLVM code or
fixtures were copied, and no CI harness pin changes.
