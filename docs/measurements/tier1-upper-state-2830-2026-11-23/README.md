# Tier 1's upper vector state: vzeroupper and VEX twins (buster#2830, PR #3347)

The 9700X's record for [buster#3347](https://github.com/buster14a/buster/pull/3347), which is part of
[buster#2830](https://github.com/buster14a/buster/issues/2830). It is measured on the Ryzen 7 9700X (`benchpress`), on CPU 2,
with each step in a lock hold of its own (`~/buster-fast-bench/exclusive.sh`). It covers item 4 of the issue and the
Zen 5 rows that the PR adds.

## What was measured

- **base:** `main` at `9ba3d792` (`9700x/commit-base.txt`).
- **head:** the PR applied to base (`head.patch`, in the work directory). Its last commit is `a909526e`
  (`9700x/head-commit.txt`), which has the same `git patch-id --stable` as the PR's head `1c0e6d81` against the
  same base.
- Both builds are Release, `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` (`scripts/build.sh`). The binaries'
  hashes are in `9700x/env2.txt`.

`scripts/run.sh` was the first pass. `scripts/run2.sh` ran the second pass at the final head. The previous
session, [session_01Egbxnczhq2SwEdMv6XeKZw](https://claude.ai/code/session_01Egbxnczhq2SwEdMv6XeKZw), wrote and
ran both passes. Session [session_01NNmNQtMosPGphvu4PwCqUT](https://claude.ai/code/session_01NNmNQtMosPGphvu4PwCqUT)
took the PR over and copied the text outputs here from `/tmp/buster-2830-claude` on the 9700X. Binaries and objects
were left out.

- `9700x/`: the second pass at the final head, plus the Zen 5 table, which the first pass measured.
- `9700x/first-pass/`: the first pass's head, before the commit that predicts the upper state. Its corpus fetch
  ran before the tree existed, so its SQLite compiles and its programs failed. Use the second pass.

## Zen 5 rows

`scripts/zen5.sh` ran `measure-x86-zen5 --missing --table` and filled in the 63 new rows: `vzeroupper` and the VEX
twins (`9700x/zen5/table.txt`, exit 0). buster's commit "Zen 5 model: vzeroupper's row and the VEX twins',
measured on the 9700X" took them from this table.

## Forms and mixed programs (`scripts/forms.sh`, `9700x/forms/results.txt`)

- `saxpy-forms.c` is #2755's hand-written loop bodies, built by clang -O2 -march=znver5. It reports cycles per
  element over 204.8 M elements, with three runs each:
  - Tier 1's legacy-move body after `vzeroupper`: **1.070** (219.2 M cycles).
  - The same body after a dirty `vpternlogd` with no `vzeroupper`: **6.002** (1229.3 M cycles).
  This repeats #2755's 5.6× hazard.
- `mix.c` is built entirely by `--tier1 -O2 -march=znver5`. Each round runs 512-bit intrinsics and returns, then
  runs scalar float and double loops. Medians of five runs:
  - base: **2413.95 M** cycles;
  - head: **1084.26 M** cycles, **2.23× faster**.
  The checksums are the same. The instruction counts are the same to within 0.004%: 2874.65 M against 2874.75 M,
  because of the added `vzeroupper`.
- `caller.c` is built by clang. It calls a Tier 1 scalar `saxpy` (`kernel.c`) with the upper state either clean
  (mode 0) or dirty (mode 1). Medians of five runs, in M cycles:
  - base: 529.5 (mode 0) and 493.0 (mode 1);
  - head: 507.7 (mode 0) and 518.6 (mode 1).
  Each mode spreads from 444 to 536 between runs. The 9700X shows no difference at this scale, either between
  modes or between base and head. The other mode-1 effect, the head's VEX twins taking away the legacy merge, is
  covered by `mix.c`.

## #2743's kernels at -march=znver5 (`scripts/kernels.sh`, `9700x/kernels/results.txt`)

All 25 kernels run with the same digests. Head over base in ns per element:
- 0.9947 to 1.0010;
- histogram_u8 0.9947, popcount_u64 0.9986, and every other kernel within ±0.1%.

The legacy forms that #2830 reported in `saxpy_f32` and `i32_to_f32` sit outside these kernels' vector bodies, so
the bodies' time is unchanged.

## Compile time (`scripts/compile.sh`, `9700x/compile/results.txt`)

Each case is `-c --tier1`, with nine rounds alternating base and head. Medians of user cycles, in M:

| Input | Target | base | head | head / base |
| --- | --- | ---: | ---: | ---: |
| sqlite3.c | x86-64 | 3244.2 | 3249.7 | 1.0017 |
| sqlite3.c | znver5 | 3244.3 | 3258.3 | 1.0043 |
| main.c | x86-64 | 5922.1 | 5911.4 | 0.9982 |
| main.c | znver5 | 6632.7 | 6648.1 | 1.0023 |

- At the default target, base and head produce the same SQLite object (`9700x/compile/objects.txt`).
- In the first pass, every function that named ymm0 to zmm15 was emitted twice. That cost main.c at znver5 5.7%
  (`first-pass/compile/results.txt`).
- The second pass predicts the upper state from the values' types and emits again only when the prediction was
  wrong. That leaves +0.2% for main.c and +0.4% for SQLite at znver5, which is the cost of the VEX rewrite and the
  scan.

## speedtest1 and Lua (`scripts/programs.sh`, `9700x/programs/{base,head}.txt`)

`measure-tier1-programs --runs 5 --variant -march=znver5` was run once with each binary. Each line is the ratio of
`--tier1 -march=znver5` to `--tier1`:

- speedtest1, ms: base 0.9966, head 0.9960.
- speedtest1, user cycles: base 0.9948, head 0.9969.
- Lua's five scripts, ms: base 1.0074, head 0.9964.
- Lua's five scripts, user cycles: base 1.0075, head 0.9961.

The znver5 instruction counts are the same as `--tier1`'s to within 0.12%. This is unchanged or faster, as the
issue asks.

## Sources

- `src/kernels.c`, `src/kernels.h` and `src/harness.c` are byte-identical copies of
  [tier1-array-loops-2743-2026-11-14/src](../tier1-array-loops-2743-2026-11-14/src) (the same git blobs).
- `src/saxpy-forms.c` is a byte-identical copy of #2755's `src/saxpy.c` from
  [tier1-unroll-2755-2026-11-15](../tier1-unroll-2755-2026-11-15).
- `mix.c`, `caller.c`, `kernel.c` and the scripts were written for this record.
- The clang is the benchpress clang under `~/.cache/buster/benchpress-clang/`.
- The corpus is CI's, from `tools/ci/fetch-corpus.sh`.
