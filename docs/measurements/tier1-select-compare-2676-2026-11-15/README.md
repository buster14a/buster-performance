# Tier 1: a select of an integer comparison is `cmp` and `cmovCC` (#2676), 2026-11-15

Evidence for [buster14a/buster#2676](https://github.com/buster14a/buster/issues/2676) and its pull request (linked from
the issue). By Claude in David's directed session ([the session](https://claude.ai/code/session_01NNmNQw7unnarYYEv6AsXsf)).

A select whose condition is an integer comparison only it reads was `xor; cmp; setcc; test; mov; cmovne`. The change
(`TIER1_RULE_SELECT_COMPARE`) makes it `cmp; mov; cmovCC`, the comparison's register, immediate and memory forms, with
the BURS grammar's matching production. buster's `docs/tier1-selection.md` has the rule.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| main | `1935a91fbd07b6fec0f6d651c9649bb7f9ef4d3a` | the pull request's base |
| head | `4ae8c1b5712e2bebc22621e66e6d66d1a7f4cd66` | the rule, its grammar and the selector tests |

The pull request's other commit (`256b8c9`) changes docs and the driver test alone, not the compiler.

## 1. #1382's kernels on the 9700X

**Method.** #1382's record's harness (`tier1-if-convert-1382-2026-11-13/scripts/`, its `kernels.c` and `bench.c`
unchanged; `scripts/measure.sh` with this issue's lock metadata): each kernel compiled by main's and the head's
`--tier1 --tier1-strict -c` (Release builds of each tree by `./build.sh --config Release` under the lock,
`scripts/setup.sh`), clang -O2 -fno-vectorize and clang -O0, linked with one clang -O2 driver. Every build's output was
checked equal first (`9700x/kernels/build.log`). 5 rounds, each one hold of the lock, the builds' order rotated by round,
each run after an untimed warm-up, pinned to CPU 2 under `perf stat -e cycles:u,instructions:u,branch-misses:u`
(`9700x/kernels/results.tsv`, every status 0; `identities.txt`: Linux 6.18.50, clang 23.1.1, perf 7.2.9, governor and
EPP `performance`, the compilers' sha256). `busy.txt` has the load and the busiest processes around each round: none
above 0.2% CPU (the load averages of 3.5 to 5.4 are kernel I/O workers').

Medians in Mcycles (`cycles:u`), with the five rounds' range:

| kernel | main | head | clang -O2 | clang -O0 | head / main | head / -O2 | instructions M, main / head / -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| null (`a ^ b`, the driver loop) | 310.0 (308.9–311.3) | 310.3 (309.7–310.8) | 310.1 | 302.1 | 1.001 | 1.000 | 1400 / 1400 / 1400 |
| `a > b ? a : b` | 304.8 (304.8–304.8) | 302.3 (302.2–305.1) | 300.3 | 1107.4 | 0.992 | 1.007 | 1600 / 1450 / 1450 |
| `x < 0 ? 0 : x > 255 ? 255 : x` | 343.5 (343.5–343.5) | 333.6 (333.4–333.8) | 332.7 | 1172.7 | 0.971 | 1.003 | 2050 / 1700 / 1700 |
| `a < 128 && b < 128` | 344.3 (344.3–344.3) | 344.3 (344.3–344.3) | 335.9 | 1143.7 | 1.000 | 1.025 | 1900 / 1900 / 1750 |
| `(a < b) && (b < c \|\| c == 0)` | 371.3 (371.3–371.3) | 371.3 (371.3–371.3) | 349.9 | 1390.8 | 1.000 | 1.061 | 2000 / 2000 / 1750 |
| `if (a[i] > 128) s += a[i]` | 162.1 (162.1–165.4) | 174.3 (174.3–174.3) | 93.4 | 1548.3 | 1.075 | 1.867 | 1020 / 853 / 412 |
| `s += a[i] > 128 ? a[i] : -a[i]` | 203.4 (203.4–203.5) | 189.5 (189.5–189.5) | 150.6 | 1729.0 | 0.931 | 1.258 | 1188 / 936 / 769 |
| `m = a[i] > m ? a[i] : m` | 90.4 (90.4–95.5) | 90.4 (90.4–90.5) | 71.7 | 281.0 | 1.000 | 1.262 | 517 / 517 / 412 |

- The scalar kernels' cycles include the driver loop's (the null row, 310 Mcycles). Without it the clamp's own work
  goes from 33.5 to 23.6 Mcycles, against clang -O2's 22.6. The maximum and the clamp now run clang -O2's instruction
  counts: `k_max` is `cmp %esi,%edi; mov %esi,%eax; cmovg %edi,%eax` (`9700x/kernels/k_head.s`).
- **`&&` and `&&`/`||`** don't change (the same code): their selects are #1382's i1 `select c, x, c`, which reads its
  comparison as a value too, so the comparison has two users and stays its own `setcc`.
- **The running max** stays #2674's branch (its recurrence rule): the same code.
- **The conditional sum's 7.5% is its placement, not its code** (section 2): head's loop is 10 instructions to main's
  12, and the kernels' executables put head's `k_condsum` at offset 0x20 of its 64-byte line, main's at 0x30.

## 2. The conditional sum's loop by placement (9700X)

**Method** (`scripts/diag2/`): head's `k_condsum` loop as the head emits it, the same without its copy `mov %rdx,%r9`
(the comparison reads the loaded `int` at the select, past its sign extension's copy, which can't share its register),
and main's, assembled at offsets 0x00, 0x10, 0x20 and 0x30 of a 64-byte line (`diag.s` has the linked addresses), called
by a clang -O2 driver over #1382's 2^20 bytes 80 times. All twelve gave one sum. 5 rounds, each one hold of the lock, the
variants' order rotated by round, pinned to CPU 2 under `perf stat -e cycles:u,instructions:u` (`9700x/diag2/diag.tsv`,
every status 0).

Medians in Mcycles, with the rounds' range:

| loop (instructions M) | 0x00 | 0x10 | 0x20 | 0x30 |
| --- | ---: | ---: | ---: | ---: |
| head's (853) | 143.8 (143.8–143.8) | 143.8 (143.8–143.8) | 174.3 (174.3–174.5) | 143.8 (143.7–143.8) |
| head's without its copy (769) | 147.6 (147.6–159.4) | 147.6 (147.6–148.1) | 174.3 (174.3–174.3) | 147.6 (147.6–147.6) |
| main's (1020) | 162.1 (162.1–162.1) | 162.1 (162.1–162.1) | 174.3 (174.3–174.8) | 164.8 (163.5–167.5) |
| head / main | 0.887 | 0.887 | 1.000 | 0.872 |

- At 0x20 every loop runs 174.3 Mcycles: the placement's bound, not the code's. The kernels' executables put head's
  `k_condsum` there.
- At the other three offsets head's loop is faster than main's at the same offset: 11.3% at 0x00 and 0x10, 12.8% at 0x30.
- Its copy costs nothing: the loop without it runs no faster (147.6 against 143.8 Mcycles at three offsets).
- `scripts/diag/` is the first diagnostic, offsets 0x10 and 0x20 only, 5 rounds (`9700x/diag/diag.tsv`): head 143.8 and
  174.3, without the copy 147.6 and 174.3, main 162.1 and 174.3 (medians).

## 3. Compile cost on the 9700X

**Method** (`scripts/compile.sh`, `scripts/compile-tmpfs.sh`): the frozen `sqlite3.c` (sha256 `0a409f16…e23d`, checked)
by `--tier1 -c` with speedtest1's flags, by each compiler: the object's shape (`9700x/compile/shape.txt`), then buster's
`time-runs --runs 11` of both in one hold, in its Williams order, pinned to CPU 2; then again with the object written to
tmpfs; then `benchmark-tier1-select-source` of `sqlite3.c` by each, one hold each.

| | wall (ms) | user cycles (M) | instructions (M) |
| --- | ---: | ---: | ---: |
| main, object on btrfs | 634.2 (633.7 to 635.4) | 3,409.5 | 8,368.8 |
| head, object on btrfs | 652.1 (633.3 to 654.7) | 3,406.5 (−0.09%) | 8,363.4 (−0.07%) |
| main, object on tmpfs | 634.4 | 3,409.6 | 8,368.8 |
| head, object on tmpfs | 634.4 (−0.01%) | 3,408.3 (−0.04%) | 8,363.4 (−0.07%) |

- **The compile costs the same.** The head selects one more candidate for each select and walks its comparison, and
  emits 2,912 fewer records; the instructions are 0.07% fewer.
- **The first run's wall times were the output file's** (`9700x/compile/compile-time.txt`): the head took ~653 ms in
  the six runs that followed main's, 634 ms in the five that followed its own, with the same user and system times, and
  main 634 ms throughout. Each compile writes the same `runs.o`, on btrfs, and main's object is 8 KB larger. With the
  object on tmpfs (`compile-time-tmpfs.txt`) both take 634.4 ms. A CI runner's worker had just started as that hold
  began (`tmpfs-busy.txt`, 8.1% over its 10 s).
- **Selection alone** (`select-*.txt`, cycles per IR instruction over `sqlite3.c`'s 472,817, 21 passes each):

| | vector path | scalar path | instructions per IR instruction (vector / scalar) |
| --- | ---: | ---: | ---: |
| main (4 runs) | 372.5 (372.3 to 373.4) | 410.5 (409.5 to 412.5) | 979.53 / 1184.31 |
| head (4 runs) | 375.7 (371.4 to 376.5), +0.9% | 415.1 (408.5 to 416.1), +1.1% | 980.21 / 1184.77 |

  Medians, with the runs' range, alternating head and main after the first pair (`select-*.txt`, `scripts/select-repeat.sh`).
  The select's fused candidate walks its comparison's chain and address, which the candidates' code inlines once more
  (`tier1_select_add_comparison`): +0.07% instructions. The cycles' +1% in selection, about 5% of the compile's, is
  +0.05% of it, within the compile's spread; the layout of the selector's code isn't controlled here (one placement per
  build). A CI runner's worker was busy on CPU 4 as `select-main-2`'s hold began (its first line).

## 4. Instruction counts (callgrind, cloud container)

**Host.** A cloud container, not the 9700X (`counts/identities.txt`): an Intel Xeon with AVX-512, valgrind 3.22.0,
clang 23.1.6. Main's and the head's compilers by `./build.sh` (Develop, the native host path); the programs by their
`--tier1 -fno-asynchronous-unwind-tables`, the driver's default target.

**Inputs and tools** (`scripts/buildlua.sh`, `luacount.sh`, `st.sh`, #2767's with this record's paths): Lua 5.4.8
(sha256 `4f18ddae…29ae`) and #1189's five scripts (`tier1-reciprocal-141-2026-11-01/9700x/lua/`), its string-hash seed
fixed (`-Dluai_makeseed(L)=0x2592u`); the frozen `sqlite3.c` with `speedtest1.c` at SQLite `ccc132c5` (sha256
`b5eaf4bb…9675`) as one unit, #2767's speedtest1 options.

| | main | head |
| --- | ---: | ---: |
| Lua's five scripts, whole processes | 4,747.84 M | 4,742.71 M (−0.11%) |
| `calls` | 521.36 M | 521.36 M |
| `tables` | 964.69 M | 961.24 M (−0.36%) |
| `strings` | 999.20 M | 998.88 M (−0.03%) |
| `arithmetic` | 963.92 M | 963.84 M (−0.01%) |
| `closures` | 1,298.67 M | 1,297.39 M (−0.10%) |
| speedtest1, whole process | 2,610.88 M | 2,598.44 M (−0.48%) |

Every Lua script printed clang -O0's output (`counts/lua-*/check.txt`) and speedtest1 its verification hash
`1248168 a7fa3957…` at both (`counts/st-*/verify.txt`). The executables have no local symbols, so the counts aren't
split by function.

## 5. Code shape and size

**`sqlite3.c`'s object** (`objects/sqlite3-shape.txt`, `--tier1 -c`, the container's; the 9700X's `shape.txt` has the
same sizes and counts):

| | `.text` | `cmov` | `jcc` | `setcc` | `test` | records | spill stores / loads | call-save stores / loads |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main | 1,557,640 | 1,140 | 31,736 | 1,972 | 17,100 | 383,005 | 12,487 / 13,791 | 17,924 / 22,850 |
| head | 1,549,288 (−0.54%) | 1,140 | 31,736 | 1,025 | 16,171 | 380,093 | 12,458 / 13,768 | 17,944 / 22,880 |

- 947 `setcc`s and 929 `test`s go; the `cmov`s stay one per select.
- The comparison's operands now live to the select: 20 more values saved around calls and 30 more reloads, 29 fewer spill
  stores and 23 fewer loads.

**Tier 1 function bytes against clang -O0's** (`objects/code-size.txt`, `measure-tier1-programs --sizes-only
--check-code-size=lua`):

| corpus | main | head | clang -O0 |
| --- | ---: | ---: | ---: |
| `sqlite3.c` (2,667 matched functions) | 939,697 | 934,754 (−0.53%) | 913,339 |
| Lua's 34 sources (1,103) | 207,728 | 206,857 (−0.42%) | 248,990 |
| c-testsuite's subset (380) | 61,434 | 61,362 (−0.12%) | 45,748 |

Lua's gate passes at both.

## Limits

- One host for the timings, one driver for the kernels: #1382's microbenchmarks. Program run times on the 9700X are the
  pull request's CI's (its Tier 1 programs comparison against the base); the counts here are instructions.
- The 9700X was shared; each round and run was one hold of the lock, and no other process was busy in any.
