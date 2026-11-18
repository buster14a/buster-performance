# C9e: the inliner's twins deleted (#2924)

Base `afae388c6` is the tests commit, with the twins present; it sits on C9d's head before C9d's rebase (`b7949c8fb`).
Head `30cf59b55` is the deletion. [`run.sh`](run.sh) ran on the 9700X: Release, every run under the lock, timings on
CPU 2. The gate is [`../c-ir-gate-again/`](../c-ir-gate-again/), "The inliner's own twins": with bit 12, which turns
over these twins alone, the twin took 1.06 to 1.14 times as long under the default passes and 1.02 to 1.03 under
`--tier1-passes=+all`, in every size bin and every round.

What C9e deletes: the cost sweeps' twins, the caller's runs' node-at-a-time copy, the flag that sent every callee to
the node-at-a-time splice, and the driver's scan for the candidates whose address code takes. The node-at-a-time splice
stays as the fallback for a callee whose parameters don't begin it or number more than 16.

## Objects

`--tier1` and `--tier1 --tier1-passes=+all` of sqlite3.c, Lua 5.4.8, musl's units and buster's `main.c`: 1,372 of 1,372
objects byte-identical in each mode ([`logs/status.txt`](logs/status.txt)).

## Whole compiles

`ab`, three rounds, around `time-runs` of base, head and base again; `-c --lanes 1`
([`logs/time.log`](logs/time.log)). The figures are user cycles against base.

| Compile | Head | Base again | Instructions, head against base |
| --- | --- | --- | --- |
| sqlite3.c, `--tier1` | +0.17%, +0.08%, +0.13% | +0.06%, +0.03%, −0.03% | 0.385 M more (+0.005%) |
| Lua's units, `--tier1` | +0.20%, +0.17%, +0.09% | +0.10%, +0.03%, +0.00% | 0.095 M more (+0.004%) |
| sqlite3.c, `--tier1 --tier1-passes=+all` | +0.03%, −0.09%, −0.13% | +0.08%, +0.00%, −0.06% | 0.557 M more (+0.003%) |

Against base again, head reads 0.05 to 0.16 points more cycles under the default passes and 0.05 to 0.09 fewer under
`+all`. Every compile already ran the vector paths in base, so the deletion takes out only the flag's tests and the
twins' code.

The two executables were compared function by function (`nm -S`):
- `.text.buster_start` is the same size in both.
- Every inliner function on the compile's path is smaller in head: `ir_optimize_inline` by 1,508 bytes,
  `ir_inline_rewrite` by 1,382, `check_tier1_inline_expand` by 1,256, `check_tier1_inline_stage` by 523 and
  `check_tier1_inline_table` by 293.
- The only other differences are in which unchanged functions get a `.buster_split` alias, which the build gives a
  local function that another part of a split unit calls. In head, `check_complex_integer_fold`,
  `check_complex_quad_fold` and `check_quad_arithmetic` gain one, and `check_control_fold_known`,
  `check_control_fold_prefix` and `foreign_link_lanes_proceed` lose theirs. The checker's folds run in every compile.

So head retires a few hundred thousand more instructions though its inliner code is smaller. This run doesn't show
where they go.

## Tests

On head, all 58 lines of [`logs/status.txt`](logs/status.txt) pass:
- the IR, SSA and Tier 1 tests. `test-ir-inline` gives the frozen digest in Release
  ([`logs/t17.log`](logs/t17.log)).
- the source tests on c-testsuite's 220-program subset. `test-ir-source --passes` compares the inliner's two forms of
  the caller's runs on 55 units, 30 of them expanded, 148 calls in all ([`logs/t31.log`](logs/t31.log)).
- `test-call-graph`, `check-call-graph` and the unity ownership check;
- the complete driver's checks of `main.c`.

## Mutants

[`mutation/`](mutation/) holds the runner, the mutants and their logs. Each mutant is checked against `test-ir-inline`,
`test-tier0-inline` and [`unit_check.sh`](mutation/unit_check.sh). That script runs `test-checker-driver`'s
unit-inlining fixture ([`unit.c`](mutation/unit.c)): built by `--tier1`, it must run as clang -O0's build does
([`expected.txt`](mutation/expected.txt)), expand at least 12 calls, define the kept functions and leave out the four
dead ones.

**First round** ([`mutation/first/`](mutation/first/)), on the deletion before the new fixtures (`edc213f1d`, on
`cb471df1a`):
- 11 of 13 mutants of the sweeps, the caller's runs, the vector splice and the addressed scan were killed. The two
  addressed-scan mutants survived: one that marks nothing and one that drops a full batch's last lane. The
  fixture can't show them, since the last pass releases a held candidate that something still references.
- Five mutants of the fallback and the splice choice ([`fallback.results`](mutation/first/fallback.results)):
  - the fallback's `cbr` block bases were killed;
  - its `br` block base and a choice that let the vector splice take 17 parameters survived. The twin comparison had
    been what ran the fallback on most callee shapes.
  - a dropped prefix test didn't compile (a tautology), and is rewritten below.

**The fixes**, all in the tests commit:
- #2541's generated units also run each callee with a constant ahead of its parameters (`ir_inline_cfg_shift`), which
  sends every shape to the fallback.
- A diamond of 16 parameters and one of 17 run from a caller of their own.
- The addressed scan is a function of one body's columns (`check_tier1_inline_addressed_entries`), which
  `test-tier0-inline` checks against its definition at every count to 200.

**Final round** ([`final.results`](mutation/final.results)): on head, all 18 mutants are killed.
- **The cost sweeps:** the threshold's and the limits' equality, the limits' last lane.
- **The caller's runs:** optional operands, a block at an expanded site's own block, the gathers' block table, a site's
  own value, and the last lane.
- **The vector splice:** a parameter's bound, a slot's base, and the last lane.
- **The addressed scan:** its marks, and a full batch's last lane.
- **The fallback:** its `br` and `cbr` block bases.
- **The splice choice:** its 16-parameter bound and its prefix test.
