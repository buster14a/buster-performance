# Tier 1 loop unrolling: the 9700X record (buster#2755, 2026-11-15)

The evidence for [buster#2755](https://github.com/buster14a/buster/issues/2755)'s
loop unroller, `--tier1-passes=+unroll`, in
[buster#2810](https://github.com/buster14a/buster/pull/2810) (design:
`docs/tier1-loop-unrolling.md` there). By Claude Code in David's directed session
([private session](https://claude.ai/code/session_01NNmNQwH9fHUf9qpWbsR9zx), model
Anthropic / claude-opus-5-5), from the claim in
[comment 6885281330](https://github.com/buster14a/buster/issues/2755#issuecomment-6885281330).

It reuses [buster#2743's record](../tier1-array-loops-2743-2026-11-14)'s kernels,
harness and method: `src/kernels.c` and `src/harness.c` there, unchanged
(sha256 `deb5e9ce…` and `0fd0840e…`), `scripts/9700x/run-one.sh` (copied here,
with its counters taken at every placement) and `scripts/loops.py`.

## Revisions and toolchains

| Role | Value |
| --- | --- |
| base | buster main `1935a91fbd07b6fec0f6d651c9649bb7f9ef4d3a`, the PR's merge base |
| head | buster#2810's `7ad1353eddc479a412fafb5d812647883a1fcce7` (the pass's code; the PR's later commits change documentation alone) |
| 9700X | Ryzen 7 9700X, `9700x/env.txt` |
| compilers | `./build.sh --config Release` of each tree on the 9700X, under the lock (`9700x/build-*.log`) |

## What is measured

- **Kernels** (`scripts/9700x/build-unroll.sh`, `measure.sh`, `run-pair.sh`, `run-one.sh`): the 25 loops built
  by Tier 1 at the base (`tier1-base`), Tier 1 at the head with `+unroll`
  (`tier1-unroll`), and clang -O2 with neither its vectorizer nor its unroller
  (`clang-O2-novec-nounroll`), without its vectorizer (`clang-O2-novec`) and
  whole (`clang-O2`). The head's default Tier 1 build is compiled too, and its
  object compared with the base's byte for byte: the pass is off by default.
  At `-march=x86-64`, Tier 1 at the base and with `+unroll` and clang without its
  vectorizer at four placements (0, 16, 32 and 48 bytes of padding before the
  kernels), the other two clang builds at placement 0; at `-march=znver5`, all
  at placement 0. One lock hold per pair of builds at a placement
  (`run-pair.sh`: the two alternate kernel by kernel, so a pair's runs see one
  machine state) or per single build (`run-one.sh`), every run on CPU 2, and
  `perf stat`'s user cycles and instructions per element at every placement
  (#2743's `run-one.sh` took them at placement 0 alone; the copy here takes them
  at each, with the placement at the end of the perf line).
  `scripts/unroll-tables.py` makes `tables.md` from `results.txt`.
- **How it ran.** The lock's queue was some 20 to 30 sessions deep, so the
  runs were grouped into fewer holds than first planned. `pipeline.sh` built
  the head and ran `measure.sh`'s first version (`measure-first.sh` on the
  host: x86-64, then znver5), which was stopped once x86-64 was done; then
  `pipeline2.sh` ran the compile cost first, then the current `measure.sh`
  for znver5, then `programs.sh`. `9700x/holds.txt` has every hold.
- **Compile cost and code growth** (`scripts/9700x/compile.sh`): the head
  compiler's `--tier1 -c` of the frozen `sqlite3.c` (the 9700X job's flags) and
  of its own `main.c` (`-march=znver5`, the repository's smoke flags), by the
  default pipeline and with `+unroll`, one lane, on CPU 2: a drive check
  (statuses, `--tier1-report`, object sizes, and the base's default objects of
  both inputs against the head's), then `measure-compile --runs 11 --variant
  --tier1-passes=+unroll` of each.
- **Local, deterministic** (`local/`): callgrind's instruction counts of
  speedtest1 and Lua's five scripts as `measure-tier1-programs` builds them
  (`--variant --tier1-passes=+unroll --keep`), with Lua's hash seed fixed
  (`#define luai_makeseed(L) 0x2755u` in a copy of `lstate.c`), on a cloud
  container; and `--tier1-report`'s loops and the objects' text sizes.

## Results: kernels at -march=x86-64

`9700x/x86-64/results.txt` holds 350 timing lines and 350 perf lines, every one
with status 0; `tables.md` beside it is `unroll-tables.py`'s output: every
kernel's ns per element at each placement, cycles and instructions per element
at each, and the geometric means. Every build gives every kernel the same
digest. The head's default `--tier1` object is the base's byte for byte
(`build.log`): the pass is off by default.

| Ratio (larger is slower) | 19 vectorized, placement 0 | 19 vectorized, best placement of each | 6 controls, placement 0 | 6 controls, best placement of each |
| --- | ---: | ---: | ---: | ---: |
| tier1-base / tier1-unroll | 1.41 | 1.36 | 1.05 | 1.05 |
| clang-O2-novec-nounroll / clang-O2-novec | 1.41 | 1.45 | 1.05 | 1.05 |
| tier1-unroll / clang-O2-novec | 1.12 | 1.15 | 1.03 | 1.03 |
| tier1-base / clang-O2-novec-nounroll | 1.12 | 1.08 | 1.03 | 1.03 |
| tier1-unroll / clang-O2 | 2.45 | 2.41 | 1.03 | 1.03 |

- **By placement.** tier1-base / tier1-unroll is 1.41, 1.41, 1.40 and 1.39 over the 19
  loops at placements 0, 16, 32 and 48, and 1.05 at each over the controls; in
  cycles per element 1.42, 1.41, 1.41 and 1.39.
- **No kernel slower.** The least ratio over every kernel and placement is
  0.999 (`find_u8`, which isn't unrolled); every unrolled kernel gains at least
  1.6% (`i32_to_f32`), and the most `sum_i32` (2.02).
- **Placements.** The base's outliers are gone with `+unroll`: `matmul_f32`
  0.731 ns at placement 0 (0.372 to 0.385 elsewhere), `saxpy_f32` 0.364 at 16,
  `clamp_i32` 0.725 at 32 and 48 and `blend_u8` 0.542 at 32; unrolled, each
  varies by at most 6% over the four placements.
- **Size.** The kernels' text grows from 1,935 to 7,497 bytes; clang without its
  vectorizer grows from 1,957 to 4,461 with its unroller (`sizes.txt`).
  `tier1-report-unroll.txt`: 27 loops, 24 unrolled (matmul's two outer loops and
  `find_u8`'s early exit are refused), 180 copies, 7 split reductions.

## Results: local and deterministic

`local/callgrind-totals.txt` (instructions, default `--tier1` against `+unroll`,
head `7ad1353e`): speedtest1 −0.171%; Lua's arithmetic −0.000%, calls +0.731%,
closures +0.669%, strings −0.064%, tables +0.056%. `local/callgrind-functions.txt`
has the functions that changed most: speedtest1's `balance_nonroot` −4.66 M of
42.9 M; Lua's costs are short-trip loops that pay the guard on every entry
(`luaD_precall` +3.81 M of 125.9 M in calls.lua, `luaH_resize`, `luaD_poscall`).
`local/measure-tier1-programs.txt`: every build's speedtest1 verification hash
and Lua outputs agree. `local/reports.txt`: `--tier1-report` and text sizes of
`sqlite3.c` (2,748 loops, 53 unrolled, text +0.77%), the compiler's `main.c`
(2,448, 297, +3.20%) and the kernels.

## Results: compile cost and code growth

`9700x/compile/` (`compile.sh`, the head `7ad1353e`, one lane, CPU 2, a hold per
step: `holds.txt`). `drive.txt`: every compile's status is 0, and both inputs'
default objects are the base's byte for byte. `measure-*.txt`: `measure-compile
--runs 11 --variant --tier1-passes=+unroll`, medians of 11 alternating runs.

| Input | Default | `+unroll` | Wall | Cycles | Instructions | Peak RSS | Text |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 636.2 ms | 650.2 ms | +2.20% | +2.20% | +1.95% | +1.4% | 1,722,876 → 1,736,148 (+0.77%) |
| the compiler's `main.c` | 1,270.1 ms | 1,327.9 ms | +4.54% | +4.79% | +4.55% | +0.5% | 2,596,186 → 2,679,138 (+3.20%) |

The ranges don't meet: `sqlite3.c` 635.4–637.4 ms against 648.8–651.1 ms,
`main.c` 1,268.5–1,276.2 against 1,323.9–1,332.7. `report-*-unroll.txt`'s
`tier1-unroll` lines: `sqlite3.c` 2,748 loops, 53 unrolled (308 copies, 4 split
reductions, 12,744 instructions added); `main.c` 2,448 loops, 297 unrolled (1,786
copies, 47 reductions, 63,422 added).

**Where it goes** (`local/callgrind-compile.txt`: callgrind of a baseline-host
build of `--tier1 -c sqlite3.c` on a cloud container, at the head merged with
main `20cd8e5`; the 9700X's instructions are for its AVX-512 paths, these for the
scalar twins): Tier 1 executes 237.5 M more instructions with `+unroll` (+2.3% of
its 10,507 M). The pass itself is 109.3 M of them: the dominators of the 1,018
functions with a phi 37.9 M, its own scan and rewrite about 25 M, their CFGs
13 M, and zeroing its arrays; the sink and the optimizer that follow take 69.3 M
more and the back end 44.4 M more, for the bigger functions. Skipping the CFG and
dominators of functions with no branch backward in block order (a filter with
twins) took 3–4 M off: 729 of the 1,018 have a loop and carry the analysis'
cost. It wasn't kept.

## Results: znver5 and the programs

PENDING
