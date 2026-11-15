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

## Summary

- **Kernels.** #2743's 19 vectorizable loops run 1.41 times as fast with
  `+unroll` at `-march=x86-64` (1.39 to 1.41 at four placements), clang's whole
  unrolling component, and 1.40 times at znver5, where clang's is 1.65. The six
  controls gain 1.05. Every digest matches, and no kernel is slower at x86-64.
- **Two kernels and Tier 1's back end.** At znver5, `i32_to_f32` gains 1.02 and
  `saxpy_f32` is 1.0 to 5.7% slower, both bounded by loads Tier 1 doesn't fold
  into floating-point code (buster#2829). Its legacy SSE forms run 5.6 times
  slower after a dirty upper state, which Tier 1 leaves (buster#2830).
- **Programs.** Over four code placements and six link orders, speedtest1 runs
  0.5% more cycles (0.17% fewer instructions) and Lua's five scripts 0.5% fewer
  (0.28% more instructions): within the placements' spread.
- **Compile cost.** `sqlite3.c` compiles 2.20% slower and the compiler's
  `main.c` 4.54% slower with `+unroll`; their text grows 0.77% and 3.20%. The
  default objects are the base's byte for byte.

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
- **Programs** (`scripts/9700x/programs.sh`, `layout.sh`): speedtest1 and Lua's
  five scripts by `measure-tier1-programs --variant`, then at four code
  placements and six link orders (below).
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

## Results: kernels at -march=znver5

`9700x/znver5/` (`measure.sh znver5`: placement 0, a pair per hold; `tables.md`
from `results.txt`). Every build gives every kernel the same digest, and the
head's default `--tier1` object is the base's byte for byte (`build.log`).

| Ratio (larger is slower) | 19 vectorized | 6 controls |
| --- | ---: | ---: |
| tier1-base / tier1-unroll | 1.40 | 1.05 |
| clang-O2-novec-nounroll / clang-O2-novec | 1.65 | 1.05 |
| tier1-unroll / clang-O2-novec | 1.29 | 1.03 |
| tier1-base / clang-O2-novec-nounroll | 1.09 | 1.03 |
| tier1-unroll / clang-O2 | 11.96 | 1.04 |

Cycles per element give 1.39 and 1.05 for the first row. At znver5 clang's
unroller is worth 1.65, and the unroller recovers 1.40 of it: clang's unrolled
loops also fold loads into their arithmetic, which Tier 1's don't (below). The
kernels' text grows from 1,807 to 6,969 bytes (clang without its vectorizer:
1,853 to 6,661); 24 of 27 loops unroll, with 184 copies and 7 split reductions.

Two kernels gain little or lose, and two small programs (`src/convert.c`,
`src/saxpy.c`, run by `scripts/9700x/convert.sh` and `saxpy.sh`, one hold each,
CPU 2, `9700x/forms/`) find why:

- **`i32_to_f32`** gains 1.02 (0.185 to 0.182 ns; 1.009 cycles per element),
  where clang's unrolled loop runs 0.582. Tier 1 converts from a register
  (`mov; xorps; cvtsi2ss r32`), clang from memory (`vcvtsi2ssl m32`).
  `convert.txt`: on the 9700X, `cvtsi2ss` from a register runs one per cycle
  (1.000 cycles per conversion, legacy or VEX) and from memory two (0.500). The
  register form caps the loop at one element per cycle, unrolled or not.
- **`saxpy_f32`** is 0.99 at placement 0. `9700x/forms/saxpy-repeat.txt`
  (`repeat-kernel.sh`, five rounds at each placement): `+unroll` runs 0.1944 ns
  everywhere, the base 0.1909 to 0.1927 at placements 0 and 16 and 0.1840 at 32
  and 48, so `+unroll` is 1.0 to 5.7% slower, with 38% fewer instructions.
  `saxpy-forms.txt` (eight-copy loop bodies, cycles per element): Tier 1's body
  1.070, the same with VEX moves 1.071 or the `x` load first 1.070, Tier 1's
  rolled loop 1.056; with the `x` load folded into `vfmadd231ss` 1.008, as
  clang's body (1.009). Folding the load, not the unrolling, decides it: Tier 1
  folds no load into floating-point arithmetic.
- **Dirty upper state.** Without `vzeroupper` after `main`'s AVX-512 code, the
  first run of `saxpy.c` (`saxpy-forms-first.txt`, `src/saxpy-first.c`) ran the
  bodies with legacy SSE moves at 6.0 cycles per element; mode 6 of the second
  run measures it on purpose: 6.002 after a `vpternlogd` on zmm9 against 1.070
  after `vzeroupper`. Tier 1 writes `movss`, `movd`, `xorps` and `cvtsi2ss` in
  their legacy forms beside VEX FMAs at znver5, and returns from 512-bit code
  without `vzeroupper`.

## Results: the programs

`9700x/programs/programs.txt` (`programs.sh`: `measure-tier1-programs --runs 5
--variant --tier1-passes=+unroll`, the head, one hold): speedtest1's verification
hash and every Lua script's output match clang -O0's. Medians of five runs,
`+unroll` against `--tier1`:

| Program | User cycles | Instructions |
| --- | ---: | ---: |
| speedtest1 | +1.40% (741.2–744.7 M against 752.4–755.7 M) | −0.17% |
| Lua arithmetic | −1.07% | −0.00% |
| Lua calls | +0.07% | +0.73% |
| Lua closures | +2.02% (282.1–287.8 M against 287.9–291.6 M) | +0.71% |
| Lua strings | −0.44% | −0.07% |
| Lua tables | +0.16% | +0.05% |
| Lua's five scripts | +0.35% | +0.28% |

speedtest1's wall time varies by 20% from run to run (its database's I/O), so
its cycles are the measure.

**Placement** (`9700x/layout/`, `scripts/9700x/layout.sh` run by
`layout-pipeline.sh`, `scripts/layout-tables.py` making `tables.md`). speedtest1
is one translation unit and Lua's objects link in one order, so a change that
grows some functions moves every one after them; this test separates the
placement's cycles from the pass's, as #2602's record did for speedtest1:

- The head's `--tier1` objects by the default passes and with `+unroll`, the
  options `measure-tier1-programs` gives them: speedtest1's unity object, cc-linked
  after 0, 528, 1,568 or 2,608 bytes of `.text` (`pad-0.s` is the empty one), and
  Lua's 33 objects cc-linked in six orders (`order-*.txt`: the canonical one, then
  `shuf` with seeds 1 to 5).
- `build.txt`: all eight speedtest1 executables give the verification hash
  `1248168 a7fa3957…`, and all 60 Lua runs print what the first build's
  canonical order prints; `executables.sha256`.
- `runs.txt`: a warm-up round and seven rounds, one hold each, every executable
  once per round (speedtest1 in a fresh `/tmp`, a tmpfs), the builds' order
  alternating by round, CPU 2; round 0 is left out of the tables.

| Program | Cycles, `+unroll` / default: mean (range) over the placements | Instructions |
| --- | ---: | ---: |
| speedtest1, four pads | 1.0051 (0.9988 to 1.0126) | 0.9983 |
| Lua's five scripts, six orders | 0.9952 (0.9766 to 1.0095) | 1.0028 |
| Lua arithmetic | 1.0032 (0.9866 to 1.0204) | 1.0000 |
| Lua calls | 1.0053 (0.9971 to 1.0237) | 1.0073 |
| Lua closures | 0.9826 (0.9319 to 1.0251) | about 1.006 |
| Lua strings | 0.9973 (0.9864 to 1.0172) | 0.9993 |
| Lua tables | 1.0002 (0.9894 to 1.0176) | 1.0005 |

speedtest1's +1.40% at its one driver-linked placement is +1.0% and +1.3% at
pads 0 and 528 and −0.1% and −0.05% at 1,568 and 2,608: +0.5% on average, with
0.17% fewer instructions. closures' +2.0% was its placement: over six orders
`+unroll` averages 1.7% fewer cycles. Lua's five scripts are within their
placements' spread; calls' +0.5% follows its +0.73% instructions, the guard its
short loops pay on every entry.
