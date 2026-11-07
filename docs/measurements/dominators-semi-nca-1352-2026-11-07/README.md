# SEMI-NCA dominators and the frontier walk's early stop, Buster #1352

Compiler issue: [#1352](https://github.com/buster14a/buster/issues/1352). Compiler branch:
`claude/problem-1352-bb8bab`, commits `01848fd7` (SEMI-NCA for the scalar solver, and `DOMINATOR_AUTO` by it) and
`0be4045e` (the frontier walk stops where an earlier walk passed), on main `829eb71a`.

## Sources and builds

Three executables, each `BUSTER_HOST_ARCH=znver5 ./build.sh` under its own lock hold (SHA-256 in `host.txt`):

- **base**: main `829eb71a7caf3d7191ef34c91f321fc11814e046`.
- **semi**: base with `01848fd7`'s code (SEMI-NCA, AUTO by it, SSA's analysis by AUTO), built before a comment in
  `dominators_scalar` was reworded; code otherwise identical.
- **new**: base with both commits' code, built before the final documentation edits.

The Ryzen 7 9700X (`benchpress`), CPU 2, governor `performance`, THP `always`, clang 23.1.1, CMake 4.4.4, Ninja
1.13.2 (`host.txt`). Every build, test, benchmark, profile and measurement point went through
`~/buster-fast-bench/exclusive.sh` once (`run.sh`); no hold covers a series. Other sessions' lock-wait messages are
removed from the logs.

## End-to-end scaling (`sweep.sh`, `scale.sh`, `gen.sh`; `scale.tsv`)

The issue's three single-function inputs (`gen.sh`; SHA-256 in `inputs.sha256`), `-c` with and without `--tier1`,
`--time-stages`, best of 3 whole processes per point, one lock hold per point (90 holds, all exit 0,
`scale-locks.log`). `--tier1` wall ms, base → semi → new:

| N | gotos | nested ifs | ternary chain |
| ---: | ---: | ---: | ---: |
| 1,000 | 8.2 → 6.7 → 6.7 | 7.4 → 6.7 → 6.0 | 8.3 → 6.8 → 6.1 |
| 2,000 | 19.4 → 13.4 → 13.0 | 16.9 → 15.0 → 13.0 | 18.9 → 14.0 → 12.1 |
| 4,000 | 52.8 → 21.9 → 21.9 | 45.0 → 36.4 → 28.1 | 83.5 → 58.8 → 32.2 |
| 8,000 | 232.3 → 58.4 → 58.4 | 152.2 → 117.6 → 83.5 | 236.4 → 107.0 → 106.7 |
| 16,000 | 855.4 → 160.1 → 160.9 | 643.0 → 295.2 → 295.0 | 1,091.6 → 392.6 → 392.5 |

Default tiers are unchanged within 0.4 ms at every point. The early stop matters where SSA's vector path builds
frontiers, which its 16 MiB budget admits up to about 8,190 blocks; past that it changes nothing.
`scale-round1.tsv` is an earlier per-point sweep of base against semi (60 holds), which agrees.

## Profiles (`prof.sh`, `visit.sh`; `prof-*.txt`, `visit-*.log`, `stages-ternary-16000.txt`)

`perf record -e cycles:u` of one `--tier1` compile with **new**: `dominators_analyze` is 2.4% of the ternary
chain at 4,000 and 1.2% or less on the other inputs (62–77% at base, as #1352 reports). The rest of the growth is elsewhere:

- gotos 16,000: `tier1_cfg_allocate_impl` 34.6%, `dataflow_liveness_vector_rows` 24.4%, `memset` 8.9%: #1384's
  phi-operand liveness rows; every label of the ladder joins `a`.
- nested ifs 8,000 / 16,000: `ir_optimize_visit` 58.6% / 65.5%; ternary 4,000 / 16,000: 54.6% / 66.3%. With
  **semi**, `visit-*.log` shows `dominators_analyze` still at 27–53% at the mid sizes (the frontier walk, fixed in
  `0be4045e`) and `ir_optimize_visit`'s hot lines, `ir_optimize.c:669`–`:671` and `:781`–`:788`: the phi case
  of SCCP's transfer, which meets every incoming value on each visit
  ([#1729](https://github.com/buster14a/buster/issues/1729)).

## Dominator kernels (`benchmark-dominators`)

`export.log`: `test-ir-source --dominators-cfg` exported sqlite3.c's 2,602 functions as 7,806 qualified CFGs
(lowered, vector-promoted, scalar-promoted), every form checked against the definition oracle. `inputs.sha256`
has the export's hash; it isn't archived (regenerate it with `export.sh`'s command).

`cfg-final.log` (**new**, `--outputs tree`): the bit matrix took 1.28–1.39× SEMI-NCA's time for 2–16 blocks,
1.43–1.78× for 16–128, 2.10–2.76× for 128–1,024 and 3.24–3.26× above (`sqlite3VdbeExec`, 1,759 blocks); 1.517×
over all of them (38.48 against 25.36 ns/block). AUTO now matches SEMI-NCA (1.008×). `cfg-base.log` (**base**):
Cooper–Harvey–Kennedy took 27.27 ns/block over all, and the matrix 1.25–3.10× its time; base's AUTO chose the
matrix for all 7,806. `cfg-new.log` is **semi**'s first build, before AUTO followed SEMI-NCA (its AUTO column is
the matrix).

`cfg-all.log` / `cfg-all-semi.log` (`--outputs all`, frontiers and loops): AUTO, which still takes the vector
loop path when it fits, is 1.057× the scalar path overall and 1.12–1.19× from 128 blocks up. That loop-path
policy is not changed here.

`bd-final.log` (**new**, synthetic shapes, analysis phase, tree): the matrix took 1.57× (16-block diamonds),
4.58× (256-block nested loops), 6.86× (513-block irreducible), 2.74× (2,049-block dispatch), and 30.7×, 56.4×
and 86.9× on the 8,192-block `ladder`, `nested-ifs` and `fan-in`. `bd.log` is **semi**'s first build without
`fan-in`.

## Correctness runs

`tests.out`, `tests3.out` (**semi**) and `round2.out`, `final.out` (**new**): `test-dominators` (seeds 174, 9,
10; up to 21.2 M checks), `test-ir-source --dominators` on the fixture, c-testsuite's subset (1,290 forms) and
sqlite3.c (7,806 forms, 45.5 M checks), `test-ssa`, `test-ssa-ir`, `test-ssa-source --tier1` (subset 220/220,
`--generate 24`), `test-c-testsuite --tier1` and `--cross-check` (220/220), `test-ir`, `test-ir-optimize`,
`-gvn`, `-licm`, the Tier 1 module tests and `check-call-graph` (0 cycles): all 0 failures. `tests2.out` holds
two commands whose file list broke on newlines and a `check-call-graph` that named the default tree; they were
rerun in `tests3.out`, `final.out` and `round2.out`.

## Limitations

- One build of each tree at one code placement; best of 3 per point. The 16,000 points' differences are far
  past placement effects; the 1,000 points' are not.
- The profiles are single runs.
- An earlier sweep that held the lock once per build and shape was discarded and isn't included.
