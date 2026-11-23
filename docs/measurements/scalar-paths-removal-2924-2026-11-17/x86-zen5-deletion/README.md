# The Zen 5 cost lookup's scalar twin deleted (#2924, the x86 tables' group, piece a)

Branch `claude/2924-x86-zen5` on main `387faaea`: tests `cdf4f163`, deletion `54de9793`.

`x86_zen5_lookup_scalar` (`x86_zen5.c`) had no caller but `test-x86-zen5`, `test-tier1-select`'s cost manifest and
`benchmark-x86-zen5`; `main.c` only kept it referenced. Production (`tier1_schedule.c`) calls `x86_zen5_lookup`, the
AVX-512 lookup, alone. The owner's rule 3 (parity or a win) applies: the twin goes.

## Gate (9700X, Release, under the lock, CPU 2)

[`gate/gate2.sh`](gate/gate2.sh) on main `68cc356a4` (with the semantics batch knob, which this module doesn't read),
`benchmark-x86-zen5` (65,536 IDs, 21 interleaved medians), [`gate/zen5-1.txt`](gate/zen5-1.txt):

| Path | ns/ID | cycles/ID |
| --- | ---: | ---: |
| scalar twin | 0.1494 | 0.8178 |
| AVX-512 | 0.0247 | 0.1359 |

The vector lookup is 6.0 times the twin's speed.

## Tests without the twin

- `test-x86-zen5`'s lookup test checks each output against the column's entry for its ID (synthetic distinct entries
  in all 256 slots), and every slot past the count against its sentinel, for every column and count through 256, and
  the guard-page tails against the entries too.
- `test-tier1-select`'s manifest reads the columns through `x86_zen5_lookup`.
- `benchmark-x86-zen5` checks the lookup against the column before timing; `--after-scalar MS` now runs an FNV-1a
  hash of the IDs (as `benchmark-dataflow`'s does) and `--only` goes, with the 9700X job's `--only vector` runs.

## Mutants

[`mutation/`](mutation/) (`run.py`, `zen5.json`, `zen5.out`), on the deletion, against `test-x86-zen5`: 5 of 5 killed
(a swapped bank pair, bit 6's test on bit 5, a tail one ID long, a tail one ID short, full groups of 64).

## Checks (this session's container, Xeon with AVX-512; not timings)

- Objects: `-c` and `-c --tier1` of buster's `main.c` and `tools/ci/build_regression.c`, `-march=znver5`, by main
  `387faaea` and the head: byte-identical.
- The correctness blocks naming `test-x86-zen5` or `test-tier1-select` ([`tests/zen5.tests`](tests/zen5.tests),
  through `parallel`): pass ([`tests/zen5-blocks.log`](tests/zen5-blocks.log)).
- `check-call-graph` (0 cycles), `-fsyntax-only -Wall -Werror` of `main.c` with and without
  `-DBUSTER_COMPLETE_DRIVER=1`, the unity ownership check: pass.
- ASan, UBSan and MSan Release builds of both pieces' heads merged ([`sanitizers/`](sanitizers/)): `test-x86-zen5`,
  `test-tier1-select`, `test-x86-target`, `test-builtin-terminal-helpers` all clean.
- No open PR adds a call to the deleted function.
