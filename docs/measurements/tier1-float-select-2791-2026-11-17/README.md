# Tier 1: a select of a floating comparison is `ucomis` and `cmovCC` (#2791), 2026-11-17

Evidence for [buster14a/buster#2791](https://github.com/buster14a/buster/issues/2791) and its pull request (linked from
the issue). By Claude in David's directed session ([the session](https://claude.ai/code/session_01NNmNQsBBsAibKofNc9YxFC)).

A select of an integer whose condition is a floating comparison was `xor; ucomis; setcc; test; mov; cmovne`. The change
(`TIER1_RULE_FLOAT_SELECT_COMPARE`) makes a select of `<`, `<=`, `>` or `>=` `ucomis; mov; cmovCC`, with the BURS
grammar's production, and lets the truth walk and the grammar pass the `i1` copy that if-conversion's truth
simplification makes of a floating comparison's test, which every if-converted select of one (and every branch on one in
a function if-conversion changed) reads. `==` and `!=` keep their truth value (section 2). buster's
`docs/tier1-selection.md` has the rule.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| main | `d876a5e0f0252407e467e95dc602b3ad26895f9d` | the pull request's base |
| head, round 1 | `ef79b5b3b6b9df35f41d1a85541557e7813b3b96` | the rule for all six predicates, `==` and `!=` by `cmovne` and `cmovp` |
| head, round 2 | `433ba586cea44e539880ad01cadbdc0b29776651` | `==` and `!=` keep their truth value; the walk's link path as main's |

The pull request's later commits share the fused selects' move and `cmov` in one helper (`sqlite3.c`'s object
byte-identical to `433ba586`'s) and change docs alone.

## 1. Kernels on the 9700X

**Method** (`scripts/measure.sh`, `kernels.c`, `bench.c`; #2676's harness with this issue's kernels): each kernel
compiled by main's and the head's `--tier1 --tier1-strict -c` (Release builds of each tree by `./build.sh --config
Release` under the lock, `scripts/setup.sh`), clang -O2 -fno-vectorize and clang -O0, linked with one clang -O2 driver.
Every build's output was checked equal first (`build.log`). 5 rounds, each one hold of the lock, the builds' order rotated
by round, each run after an untimed warm-up, pinned to CPU 2 under `perf stat -e cycles:u,instructions:u,branch-misses:u`
(`results.tsv`, every status 0; `identities.txt`: Linux 6.18.50, clang 23.1.1, perf 7.2.9, governor and EPP
`performance`, the compilers' sha256). The call kernels run 50 M times on doubles from xorshift64 (small integers, a
sixteenth of them NaN); the loops 80 times over 2^20 such elements.

Round 2 (`9700x/round2/kernels-final/`), main against `433ba586`, medians in Mcycles with the five rounds' range:

| kernel | main | head | clang -O2 | clang -O0 | head / main | head / -O2 | instructions M, main / head / -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| null (`x ^ y`, the driver loop) | 579.5 (578.4–581.2) | 579.9 (578.3–581.3) | 579.7 | 604.9 | 1.001 | 1.000 | 2216 / 2216 / 2216 |
| `a < b ? x : y` | 592.8 (592.2–596.9) | 584.4 (584.2–584.4) | 585.4 | 1693.6 | 0.986 | 0.998 | 2416 / 2266 / 2266 |
| `a >= b ? x : y` (float) | 601.7 (599.2–602.7) | 586.1 (584.8–588.3) | 586.0 | 1753.9 | 0.974 | 1.000 | 2516 / 2366 / 2366 |
| `!(a <= b) ? x : y` | 613.4 (610.9–614.9) | 572.2 (570.3–574.3) | 570.2 | 1661.4 | 0.933 | 1.003 | 2516 / 2216 / 2216 |
| `a == b ? x : y` | 628.1 (626.5–635.0) | 625.8 (621.5–627.4) | 579.4 | 925.6 | 0.996 | 1.080 | 2466 / 2466 / 2266 |
| `a != b ? x : y` (float) | 601.1 (600.7–601.7) | 598.0 (593.5–605.5) | 573.4 | 943.6 | 0.995 | 1.043 | 2466 / 2466 / 2266 |
| `if (p[i] > t) c += 3; else c -= 1;` | 179.1 (179.0–179.5) | 178.6 (178.6–178.6) | 113.1 | 1786.6 | 0.997 | 1.579 | 1030 / 779 / 527 |
| `if (p[i] == t) c += 5; else c += 1;` | 217.0 (217.0–217.1) | 259.9 (259.9–259.9) | 113.1 | 1004.1 | 1.197 | 2.298 | 1198 / 1198 / 527 |

- The ordered selects now run clang -O2's instruction counts and its cycles: `k_lt` is `ucomisd %xmm0,%xmm1; mov
  %esi,%eax; cmova %edi,%eax` (`k_head.s`).
- **The `==` loop's +19.7% is its placement, not its code**: the head's `k_equal` is main's instructions exactly
  (`k_main.s`, `k_head.s`), at 0xb0 of its object where main's is at 0xd0, after the ordered kernels shrank (section 3).
- `==` and `!=` are main's code at the head (their truth values); the 0.4% and 0.5% are within the rounds' ranges.

Round 1 (`9700x/round1/kernels/`), main against `ef79b5b3`, whose `==` and `!=` were `ucomis; mov; cmovne; cmovp`: the
ordered rows as round 2's (0.983, 0.976, 0.936, 0.997), `a == b ? x : y` 0.919 (577.3 against 627.9 Mcycles, 2266 M
instructions, clang -O2's), `a != b` 0.954, and the `==` loop 259.9 against 217.0 Mcycles (947 M instructions against
1198 M), with `mov %rax,%r11; cmove %rdx,%rax; cmovp %r11,%rax` on its accumulator's recurrence.

## 2. The loops by placement (9700X)

**Method** (`scripts/diag/`, #2676's `diag2` method): the `==` loop as main emits it (and the final head), as round 1's
head emitted it (`cmove` and `cmovp` past a copy into the scratch register), and its two `cmov`s into a register of their
own with a move back; and the `>` loop by main and by the head; each assembled at offsets 0x00, 0x10, 0x20 and 0x30 of a
64-byte line (`loops.s` from `gen.sh`, `diag.s` has the linked addresses), called by a clang -O2 driver over the kernels'
2^20 doubles 80 times. Each loop gave its kernel's sum. 5 rounds, each one hold of the lock, the variants' order rotated
by round, pinned to CPU 2 under `perf stat -e cycles:u,instructions:u` (`9700x/diag/diag.tsv`, every status 0).

Medians in Mcycles, with the rounds' range:

| loop (instructions M) | 0x00 | 0x10 | 0x20 | 0x30 |
| --- | ---: | ---: | ---: | ---: |
| `==`, main's (1198) | 259.9 (259.9–260.0) | 343.8 (343.7–343.8) | 217.2 (217.0–217.5) | 217.2 (217.0–217.4) |
| `==`, two `cmov`s past a copy (947) | 259.9 (259.9–259.9) | 259.9 (259.8–259.9) | 259.9 (259.9–259.9) | 259.9 (259.9–260.0) |
| `==`, two `cmov`s into their own register (947) | 259.9 (259.9–259.9) | 259.9 (259.9–259.9) | 259.9 (259.9–259.9) | 259.9 (259.9–259.9) |
| `>`, main's (1030) | 179.2 (179.0–179.4) | 179.2 (179.2–179.3) | 179.0 (179.0–179.3) | 179.2 (179.1–179.3) |
| `>`, the head's (779) | 178.6 (178.6–178.7) | 178.6 (178.5–178.6) | 178.4 (178.2–178.5) | 178.6 (178.4–178.6) |

- **Two `cmov`s cost the accumulator's recurrence a cycle**: the `==` loop with both on it runs 259.9 Mcycles (3.1 cycles
  an element) at every placement, either destination; main's, whose `sete; setnp; and; test` run off the recurrence and
  whose one `cmovne` is on it, runs 217.2 (2.6 cycles) where its placement doesn't bound it, and 259.9 and 343.8 where it
  does. So `==` and `!=` keep their truth value: their two `cmov`s would shorten the comparison's path (the call kernels'
  8.1% and 4.6% in round 1) but lengthen the values', and a loop's accumulator recurs through the values.
- **The ordered `>` loop is 0.3% faster at every placement**: its one `cmova` is on the recurrence where main's `cmovne`
  was, and its comparison is off it either way.

## 3. Code shape (cloud container)

`objects/` (main's and `433ba586`'s Develop builds, the container's, `counts/identities.txt`):

| | records | `.text` | `setcc` (`seta` + `setae`) | `test` | fused selects | fused branches |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c`, main | 374,291 | 1,475,496 | 47 | 16,000 | | |
| `sqlite3.c`, head | 374,180 (−111) | 1,475,240 (−256) | 14 | 15,967 | 2 (`cmova`, `cmovbe`) | 31 (`jb`, `jbe`) |

- 10 of `sqlite3.c`'s functions shrink, by 7 to 59 bytes (`objects/sqlite3-shape.txt`): sqlite's `signFunc`, `x < 0 ? -1 :
  x > 0 ? 1 : 0`, whose inner `?:` is now `ucomisd; cmovbe` and its outer branch `ucomisd; jbe`, both through the copy.
- Lua's `ltable.c` (`mainpositionTV`, two branches) and `lvm.c` (`luaV_execute`, three of its float comparisons'
  branches, 7,382 to 7,373 instructions) change; the other 32 objects are the same code (`objects/lua.txt`). 8 of the 312 musl math, stdlib, printf,
  scanf and time sources change (`objects/musl.txt`).
- The 9700X's Release builds give `9700x/round2/compile-final/shape.txt`: `sqlite3.c`'s object 448 bytes and 186
  records smaller, `seta` 67 to 11, `jbe` 465 to 516.

## 4. Instruction counts (callgrind, cloud container)

`scripts/counts/` (#2676's `buildlua.sh`, `luacount.sh` and `st.sh` with this record's paths): Lua 5.4.8 (sha256
`4f18ddae…29ae`) and #1189's five scripts, its string-hash seed fixed; the frozen `sqlite3.c` with `speedtest1.c` at
SQLite `ccc132c5` (sha256 `b5eaf4bb…9675`) as one unit, #2767's options; by `--tier1 -fno-asynchronous-unwind-tables`.

| | main | head (`433ba586`) |
| --- | ---: | ---: |
| speedtest1 | 2,529.77 M (2,529,771,532; again 2,529,771,386) | 2,528.81 M (2,528,805,483), −0.038% |
| Lua's five scripts | 4,592.22 M | 4,592.21 M |

- Every Lua script printed clang -O0's output and speedtest1 its verification hash `1248168 a7fa3957…` at both
  (`counts/*/check.txt`, `verify.txt`).
- Lua's counts are the same within their runs' variation: `ef79b5b3`'s and `433ba586`'s Lua executables have the same
  code and their scripts' counts differ by up to 1,300 (`counts/lua-head`, `counts/lua-final`); speedtest1's repeat runs
  differ by 146 and 317 (`st-again-*.txt`), so its −966 K is the change's.

## 5. Compile cost on the 9700X

**Method** (`scripts/compile2.sh`, `9700x/round2/compile-final/`): the frozen `sqlite3.c` (sha256 `0a409f16…e23d`, checked)
by `--tier1 -c` with speedtest1's flags: buster's `time-runs --runs 11` of both in one hold, its Williams order, CPU 2,
the object on tmpfs; then `benchmark-tier1-select-source` of `sqlite3.c`, three rounds alternating, one hold each.

| | wall (ms) | user cycles (M) | instructions (M) |
| --- | ---: | ---: | ---: |
| main | 628.3 (627.4 to 630.0) | 3,375.6 | 8,339.75 |
| head | 629.3 (628.5 to 631.1), +0.15% | 3,382.1, +0.19% | 8,338.29, −0.018% |

| selection, cycles per IR instruction (3 runs each) | vector path | scalar path | instructions per IR instruction (vector / scalar) |
| --- | ---: | ---: | ---: |
| main | 373.2 (372.8 to 373.6) | 413.5 (412.6 to 414.1) | 954.94 / 1184.74 |
| head | 369.6 (368.6 to 370.0), −1.0% | 409.2 (408.3 to 409.2), −1.0% | 955.83 / 1175.23 |

- **Selection is faster and the compile runs fewer instructions; the compile's +1 ms isn't attributed.** `--time-stages`
  (`9700x/stages/`, 7 runs each alternating in one hold) puts all of it in the stage that runs Tier 1 (501.3 to 502.6 ms,
  +0.25%; every other stage within 0.13 ms), where the head runs fewer instructions. `perf record` by symbol
  (`9700x/profile/`, 3 runs each, period 200003) spreads differences of 2 to 6 Mcycles a run over functions this change
  doesn't touch, both ways, within its sampling noise. Round 1 (`ef79b5b3`, `9700x/round1/compile/`) read +0.16% wall and
  +0.022% instructions: its walk computed the copy test on every link (333 to 476 bytes); round 2's tests a copy only where
  no link matches.

## 6. Tests' mutants

`scripts/mutants/` (a copy of the tree per round, each mutant built incrementally, `test-tier1-select` and
`test-tier1-emit` run): round 1 against `ef79b5b3`'s tree, 12 of 13 killed (`mutants/round1.txt`; the survivor changed
the `==` candidate's cost, code round 2 removed); round 2 against the final tree, 9 of 10 killed (`mutants/round2.txt`).
Its survivor stops counting the copy among the pattern's folded nodes: `fold_count` orders maximal munch's candidates
alone, where the fused one outranks the plain select either way, so no output can show it; the count stays, as the
field's definition (the nodes the pattern computes itself) has it.

## Limits

- One host for the timings, one driver for the kernels, #2676's method. The programs' run times weren't measured on the
  9700X (a pull request's CI skips the hardware job, #2055): their counts here are instructions.
- The 9700X was shared with other sessions; each round and run was one hold of the lock (`busy.txt` files).
