# Tier 1: a select of a floating `==` or `!=` is `ucomis` and two `cmov`s where its values don't recur (#2922), 2026-11-17

Evidence for [buster14a/buster#2922](https://github.com/buster14a/buster/issues/2922) and its pull request (linked from
the issue). By Claude in David's directed session ([the session](https://claude.ai/code/session_01NNmNQuBCAvjWB33uSZyP8B)).
It follows [#2791's record](../tier1-float-select-2791-2026-11-17/README.md), whose harness this one reuses.

#2791 made a select of a floating `<`, `<=`, `>` or `>=` `ucomis; mov; cmovCC`, and left `==` and `!=` testing their truth
value (`xor; ucomis; sete; setnp; and; test; mov; cmovne`): two `cmov`s, `cmovne` and `cmovp`, put both on the path from
the select's values to its result, which a loop's accumulator recurs through. #2922's change makes them `ucomis; mov;
cmovne; cmovp` unless the select's values recur through it by an operation (`tier1_select_recurrent`, buster's
`docs/tier1-selection.md`).

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| base | `42a80669d9de4bd81dbc5291d4cb7fef2349ce43` | #2921's head (#2791), the branch's base |
| head | `4d2e5846b3f2794bf4f47cf6b5f5d0780ca5976b` | first version: any recurrence through the values keeps the truth value |
| always | `4d2e5846` + `scripts/always.patch` | every `==` and `!=` select fuses (the walk finds none), as #2791's `ef79b5b` |
| final | `f7bf49f9be6fff3397b919a9a3fc85cb6ea35323` | a recurrence counts only through an operation (a row neither a phi nor a copy) |

The pull request's later commits change tests and docs alone.

## 1. Kernels on the 9700X

**Method** (`scripts/measure.sh`, `kernels.c`, `bench.c`: #2791's harness with this issue's kernels): each kernel compiled
by each tree's `--tier1 --tier1-strict -c` (Release builds, `./build.sh --config Release` under the lock,
`scripts/setup.sh`, logs in `9700x/trees/`) and by clang -O2 -fno-vectorize, linked with one clang -O2 driver; every build's output checked equal
first (`build.log`). 5 rounds, each one hold of the lock, the builds' order rotated by round, each run after an untimed
one, pinned to CPU 2 under `perf stat -e cycles:u,instructions:u,branch-misses:u` (`results.tsv`, every status 0;
`identities.txt`: Linux 6.18.50, clang 23.1.1, perf 7.2.9, governor and EPP `performance`, the compilers' sha256). The
call kernels run 50 M times on doubles from xorshift64 (small integers, a sixteenth of them NaN); the loops 80 times over
2^20 such elements, `t` from -2 to 2. `kernels.c` puts the loops whose selects recur first, so that their code and
placement are the same in the trees that compile them alike (`symbols.txt`).

Round 2 (`9700x/kernels2/`), base against final, medians in Mcycles with the five rounds' range:

| kernel | base | final | always | clang -O2 | final / base | instructions M, base / final / -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| null (`x ^ y`, the driver loop) | 569.6 (568.4–572.9) | 569.2 (567.5–570.9) | 569.9 | 570.6 | 0.999 | 2016 / 2016 / 2016 |
| `a < b ? x : y` | 576.8 (571.3–579.9) | 576.9 (575.7–578.1) | 578.1 | 575.0 | 1.000 | 2066 / 2066 / 2066 |
| `a == b ? x : y` | 589.0 (585.6–591.6) | 574.4 (571.5–576.3) | 573.2 | 573.6 | 0.975 | 2266 / 2066 / 2066 |
| `a != b ? x : y` (float) | 601.7 (601.5–608.1) | 576.9 (576.1–578.1) | 577.2 | 579.6 | 0.959 | 2416 / 2216 / 2216 |
| `b = p[i] == t ? i : b` | 181.1 (181.0–181.2) | 176.0 (176.0–176.0) | 176.0 | 176.0 | 0.972 | 1030 / 779 / 422 |
| `if (p[i] == t) c += 5; else c += 1;` | 217.1 (217.1–217.5) | 217.1 (217.1–217.6) | 260.0 | 113.2 | 1.000 | 1198 / 1198 / 527 |
| `s += p[i] == t ? x : y` | 194.9 (194.9–195.2) | 127.2 (127.2–146.2) | 176.1 | 112.7 | 0.653 | 1198 / 863 / 506 |

- The call kernels by `==` and `!=` run clang -O2's instructions and cycles: `k_eq` is `ucomisd %xmm1,%xmm0; mov
  %edi,%eax; cmovne %esi,%eax; cmovp %esi,%eax` (`k_final.s`).
- The conditional count keeps its truth value (the base's code exactly); by two `cmov`s (always) it runs 19.8% more
  cycles here. `always`'s `s +=` loop is the final's instructions at another address (0x70 against 0x80): 176.1, within
  the range section 2's placements give that code (126.9 to 176.1).

Round 1 (`9700x/kernels/`), base against the first head: the same rows but `b = p[i] == t ? i : b`, which the first head
kept as its truth value (181.1, the base's code) while always fused it (176.0, at every placement: section 2). That
made the final walk count a recurrence only through an operation.

## 2. The loops by placement (9700X)

**Method** (`scripts/diag/`, #2791's `diag2` method): each loop as the trees emit it (`gen.sh` copies their
`k_*.s`), by its truth value and by two `cmov`s, assembled at offsets 0x00, 0x10, 0x20 and 0x30 of a 64-byte line
(`loops.s`, `diag.s` has the linked addresses) and called by a clang -O2 driver over the kernels' 2^20 doubles 80 times;
every variant gave its loop's sum. 5 rounds, each one hold of the lock, the variants' order rotated by round, pinned to
CPU 2 under `perf stat -e cycles:u,instructions:u` (`9700x/diag/diag.tsv`, every status 0).

Medians in Mcycles, with the rounds' range:

| loop (instructions M) | 0x00 | 0x10 | 0x20 | 0x30 |
| --- | ---: | ---: | ---: | ---: |
| `b = p[i] == t ? i : b`, truth value (1030) | 181.1 (181.0–181.1) | 181.3 (181.0–181.4) | 181.1 (181.0–181.3) | 181.1 (181.1–181.2) |
| `b = p[i] == t ? i : b`, two `cmov`s (779) | 176.0 (176.0–176.1) | 176.1 (176.0–176.1) | 176.1 (176.0–176.1) | 176.1 (176.0–176.1) |
| `c += 5 or 1`, truth value (1198) | 260.0 (259.9–260.0) | 343.8 (343.8–343.9) | 217.3 (217.1–217.5) | 217.1 (217.1–217.5) |
| `c += 5 or 1`, two `cmov`s (947) | 260.0 (259.9–260.0) | 259.9 (259.9–260.0) | 260.0 (259.9–260.0) | 260.0 (260.0–260.0) |
| `s += p[i] == t ? x : y`, truth value (1198) | 260.0 (259.9–260.0) | 195.0 (194.9–195.3) | 195.3 (195.0–195.3) | 195.0 (194.9–195.0) |
| `s += p[i] == t ? x : y`, two `cmov`s (863) | 126.9 (126.9–127.2) | 127.1 (126.9–127.1) | 176.1 (176.0–176.1) | 132.4 (126.9–137.8) |

- **A running choice fuses**: `b`'s chain through the select is the select alone, two `cmov`s by the fused form, which
  the loop runs at 2.10 cycles an element at every placement, clang -O2's 176.0; the truth value's one `cmovne` runs
  at 2.16, its loop three instructions longer.
- **An accumulator with an operation on its chain keeps the truth value**: the addition and two `cmov`s run 3.1 cycles
  an element at every placement; the truth value's addition and one `cmov` 2.6 where its placement doesn't bound it
  (0x20, 0x30), as #2791's record found, and 3.1 and 4.1 where it does.
- **A select off the chain fuses**: `s +=` runs 32% to 51% fewer cycles by two `cmov`s at each placement but 0x20, and
  10% fewer there. The same offset in a line isn't the same placement: the kernels' `always` build has that loop at
  0x70 of its object, offset 0x30 as here, and ran it at 176.1 (section 1).

## 3. `sqlite3.c`'s compile (9700X)

**Method** (`scripts/compile.sh`, #2791's `compile2.sh`): the frozen `sqlite3.c` by `--tier1 -c`, the object on tmpfs;
`time-runs --runs 11` of both compilers in one hold, CPU 2; then `benchmark-tier1-select-source`, three rounds of each,
one hold each.

| | base | first head (`9700x/compile/`) | final (`9700x/compile2/`) |
| --- | ---: | ---: | ---: |
| instructions | 8,338.30 M | 8,341.70 M (+0.04%) | 8,341.70 M (+0.04%) |
| user cycles, against base in the same hold | | −0.21% | −0.36% |
| wall, against base in the same hold | | −0.15% | −0.43% (627.5 ms against 630.2) |
| selection, cycles / IR instruction, vector | 372.5 to 373.4 | 369.4 to 370.0 | 369.4 to 369.9 |
| selection, instructions / IR instruction, vector / scalar | 955.83 / 1175.23 | 959.13 / 1178.40 | 959.13 / 1178.40 |

The selection runs 3.3 more instructions an IR instruction (+0.35%) and fewer cycles; the walk itself runs for the
selects of `==` and `!=` alone. The compile's instructions are within 0.04% of the base's and its cycles 0.2% to 0.4%
fewer, both within what one such hold shows.

## 4. Code (9700X's Release builds)

`scripts/corpus.sh`: `sqlite3.c`, Lua 5.4.8's 34 sources (`-march=znver5 -std=gnu99 -DLUA_COMPAT_5_3
-DLUA_USE_LINUX`) and #2791's 312 musl math, stdlib, printf, scanf and time sources (the frozen corpus's flags) by base's
and final's `--tier1 -c`, every compile in one hold; then each object's disassembly compared (`corpus2/shape.txt`,
`changed.txt`). `sqlite3.c`'s object fuses 2 selects, both in `sqlite3_str_vappendf` (`cmove; cmovp`, a running choice
through the scratch register): 8 fewer records, 2 `sete`, 2 `setnp` and 2 `test` fewer, 16 bytes less `.text`. No Lua
or musl object changes. The first head's `corpus/` is the same.

## 5. Tests

Local runs (cloud container, Develop and Release builds of the branch): `test-tier1-select`, `test-tier1-emit`,
`test-tier1-pipeline --cross-check`, `test-tier1-liveness`, `test-tier1-cfg`, `test-tier1-masks`, `test-tier1-wide`,
`test-tier1-allocation`, `test-ir-parse` and the driver's pattern test pass; the base's compiler fails the pattern test's
three fused shapes (`patterns_float_equal`, `_unequal`, `_equal_sum`).

Mutants (`scripts/mutants/`, each in a copy of the tree, rebuilt, then `test-tier1-select`, `test-tier1-emit` and the
pattern test): round 1 on the first head, 12 of 13 killed (`mutants-round1.log`); the survivor made the fused
candidate's cost 3 where its pattern's is 4, which the grammar's twin fixtures now check for every candidate.
Round 2 on the final walk (`scripts/mutants/mutants.py`): `mutants-round2.log`, running as this record is first pushed.
