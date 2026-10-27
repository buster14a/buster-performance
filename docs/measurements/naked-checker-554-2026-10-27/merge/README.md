# Main-merge qualification for Buster #560

Compiler head: `a519c3f95d5e2aab787c7fc3eafd9013b6916106`. Its parent,
`b12ccd2a6220287b926807c580d555ebd949a427`, merges main
`c48136680b172278c1ecf22e589dfe25b298ee28` into the reviewed
`1193571fd09b3a2c35a74b07371070e37068721b` implementation.

The documentation conflict preserves both the semantic diagnostic description
and main's new naked-function lowering and asm-symbol documentation. The
reviewed naked-checking implementation is unchanged.

Main introduced two lowering-boundary fixtures whose invalid statements and
parameter operands now fail semantic checking first. The final head replaces
them with an uninitialized named-register VLA and a constant with a register
constraint. Both pass Clang 23.1.4's syntax checks locally, while retaining the
original named lowering refusals. Their original probes are included here.
The scalar and vector program-boundary tests retain their exact refusal,
reference/initializer counts, rollback and scratch-restoration assertions.

## Qualification

Both optimized builds use `BUSTER_DEBUG_INFO=0 ./build.sh`, with warnings as
errors. Local multicore builds used the physical-core queue with four cores.
Every target build and qualification run held the shared 9700X lock separately,
with owner `codex-554`, a descriptive title and link to Buster PR #560.

`qualification.list` contains all seven target commands. They run through
`./build/compiler parallel --jobs 8 --timeout 180 ../merge-qualification.list`
from the candidate archive, under `~/buster-fast-bench/exclusive.sh`.
`source-sha256.txt` covers all 642 tracked files; `source-verify.log` records
verification against that archive before tests. `binary-sha256.txt` identifies
the target executable. Clang 23.1.1 is the target oracle.

All seven target commands pass in 33.3 seconds (`qualification.log`):

| Check | Result |
|---|---|
| `test-checker-asm` | 992 checks, 632 fixtures, zero failures |
| `test-checker-deferred` | 69 fixtures, 1,096 checks, 6,456 bodies read apart, zero failures |
| `test-checker --seed 133` | 259,613 checks, zero failures |
| `test-call-graph` | 37 cases, zero failures |
| Frozen SQLite Clang/deferred comparison | Both accept; 2,608 deferred bodies, zero differences or resource failures |
| `test-checker-driver --executable ./build/compiler` | 21,591 checks, zero failures, including naked-function emission |
| Compiler source call graph | 41 translation units, 23,846 functions, 142,689 calls, zero cycles and split variables; three allowed cycles |

The local assembly comparison passes all 992 checks and 632 fixtures
(`asm-local.log`). `driver-summary.log` and `driver-output/` retain all 18
original issue checks: syntax-only, object and direct modes, scalar and vector
paths. Each exits exactly 1, with empty stdout, no output artifact and the exact
requested error at columns 39, 62 and 38 respectively. The source inputs are
the parent record's `naked-local.c`, `naked-parameter.c` and `naked-return.c`.

## Earlier merged-head run

`before-fixture-update/` retains the build, hashes and qualification of
`b12ccd2a`. Six commands passed; the full checker reported four failed
assertions because each obsolete lowering fixture expected semantic input to
succeed on both paths. Its full checker reported 259,593 checks. The final
fixture update addresses these four assertions without changing compiler
behavior.

No timing screen was run for this merged head. The review record's cost screen
qualifies `1193571f` against `b7f444eb` only; it is not a performance result for
the newer main composition. All new probes and run glue are original material.
