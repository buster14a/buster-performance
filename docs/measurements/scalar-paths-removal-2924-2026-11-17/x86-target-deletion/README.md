# The target form table's scalar twin deleted (#2924, the x86 tables' group, piece b)

Branch `claude/2924-x86-target` on main `387faaea`: tests `a6eb3dce`, deletion `7fd5296f`, docs `d9dca109`.

`x86_target_forms_scalar` (`x86_target_forms.c`) had no caller but the target tests, the Tier 0 vector test, the
terminal builtins' test and `benchmark-x86-target`; `main.c` only kept it referenced. Production builds the table with
`x86_target_forms`, the AVX-512 builder. The owner's rule 3 applies: the twin goes. The builder's exact pass over the
extended rows stays (phase D's, not this piece's).

## Gate (9700X, Release, under the lock, CPU 2)

[`gate/gate3.sh`](gate/gate3.sh) on main `68cc356a4`, `benchmark-x86-target` (the `znver5` table, 10,000 tables a sample,
21 interleaved medians), [`gate/target-1.txt`](gate/target-1.txt):

| Path | ns/table | cycles/table |
| --- | ---: | ---: |
| scalar twin | 773.18 | 4,273.18 |
| AVX-512 | 201.60 | 1,116.44 |

The vector builder is 3.8 times the twin's speed. (docs/x86-target.md's 2026-10-21 record has the one-table case after
100 ms of predefines at 431 against 441 ns, also a vector win.)

## Tests without the twin

The table's definition replaces the twin: a form is allowed (1) exactly when the full-width slot map
(`x86_target_requirement`, a different table from the compact rows the builder reads) classifies it and the target's
features, with the known marker, cover its requirement; 0 otherwise (`x86_target_test_definition`). The matrix (every
subset of every requirement mask, every raw feature bit alone, every single-feature removal per profile, reserved
bits, unaligned and overlapping outputs), the profiles' named forms, the guard-page edges and the matcher admission
check it. The Tier 0 vector test and the terminal builtins' test build their tables with `x86_target_forms`.
`benchmark-x86-target` checks the builder against the definition and times it alone; `--only` goes.

## Mutants

[`mutation/`](mutation/), on the deletion, against `test-x86-target` and `test-builtin-terminal-helpers`:
- killed: the last lane of a group dropped, the extended pass skipping its first row, the allowed byte 2, the known
  mask dropped for form 0 (`t1b`: `test-x86-target` ran into a loop and was stopped by hand after 10 minutes, counted
  as killed), and the extended pass ignoring AVX512VNNI (`t4b`);
- not built: `t1` (an unused variable under `-Werror`), replaced by `t1b`;
- equivalent: `t4` (the extended pass ignoring feature bit 0, SSE3, which no extended row requires), replaced by `t4b`.

## Checks (this session's container; not timings)

- Objects: `-c` and `-c --tier1` of buster's `main.c` and `tools/ci/build_regression.c`, `-march=znver5`, by main
  `387faaea` and the head: byte-identical.
- The correctness blocks naming `test-x86-target`, `test-builtin-terminal-helpers` or `test-tier0`
  ([`tests/target.tests`](tests/target.tests), through `parallel`): 4 of 4 pass
  ([`tests/target-blocks.log`](tests/target-blocks.log)); GCC 15 and GNU as 2.46 aren't in the container, so those two
  checks printed their skips.
- `check-call-graph` (0 cycles), `-fsyntax-only -Wall -Werror` of `main.c` with and without
  `-DBUSTER_COMPLETE_DRIVER=1`, the unity ownership check: pass.
- ASan, UBSan and MSan Release builds of both pieces' heads merged ([`sanitizers/`](sanitizers/)): clean.
- No open PR adds a call to the deleted function.
