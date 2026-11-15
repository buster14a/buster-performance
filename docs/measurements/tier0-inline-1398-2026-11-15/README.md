# Tier 0's inlining of always_inline functions on the 9700X (#1398), 2026-11-15

Measurement record for [buster14a/buster#1398](https://github.com/buster14a/buster/issues/1398) and
[PR #2793](https://github.com/buster14a/buster/pull/2793) (plan step 3: callees spliced at every call left out, and the
spliced callees' runtime symbols). It is also the 9700X record that #1770's first measurements, taken on a cloud host,
left to take: the issue's four kernels, `main.c`'s object and compile, and the compiler self-built at Tier 0.

## Trees, host and builds

- Base: main `2ebfe68a856613e300231520af5e7ec5627708b6`. Head: PR #2793's `5c26a3b35890fc0ca248df95573afe5330cf82c8`.
- Host: `benchpress`, AMD Ryzen 7 9700X, Linux 6.18.50-2-lts; the kernels' clang is the host's 23.1.1
  (`raw/environment.txt`). Each tree is `./build.sh --config Release` with `BUSTER_HOST_ARCH=znver5
  BUSTER_DEBUG_INFO=0` (the build's official Clang 23.1.4).
- The lock (`~/buster-fast-bench/exclusive.sh`) was taken per timed run, pinned to CPU 2; the kernels' six objects and
  links took one hold together, and each self-host's 43 unit compiles and its link one hold (about 18 s), as about 30
  sessions were queued for the lock. No run's log has `exclusive.sh`'s note of other busy processes as its hold began.
  `raw/busy.txt`'s snapshots were taken before each wait for the lock, so they show the holder of the moment, not the
  runs. The lock's wait notices, which name other sessions' and CI jobs' runs, are left out of `raw/`.
- Harness: `run-1398c.sh` (this directory), with `kernels.c` and `driver.c`. A first attempt (`run-1398.sh`, one hold
  per small compile) was stopped while it waited for the lock; it measured nothing.

## The issue's kernels

`kernels.c` by each compiler at `-march=znver5`, called by `driver.c` (clang -O2): 4,096 elements, 100,000 calls a pass,
5 passes a kernel, each pass's time; each build ran three times (`raw/kernels/run-*.txt`). The table gives the median
pass of each run, median over the three runs, in ms. Every build printed the same checksums.

| kernel | Tier 0 (head) | `--tier0-no-inline` | `--tier1` | clang -O0 | clang -O2 | Tier 0 / clang -O0 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `s = _mm256_add_ps(s, _mm256_loadu_ps(p + i))` | 315.1 | 873.4 | 17.1 | 188.0 | 17.6 | 1.68 |
| `_mm256_storeu_si256(d, _mm256_adds_epu8(loadu(a), loadu(b)))` | 13.5 | 124.7 | 2.6 | 17.6 | 2.3 | 0.77 |
| `c += popcount(_mm512_cmpeq_epi32_mask(loadu(p + i), k))` | 20.2 | 79.7 | 9.3 | 18.9 | 6.3 | 1.07 |
| `s = _mm256_fmadd_ps(loadu(a), loadu(b), s)` | 336.8 | 905.6 | 33.9 | 198.7 | 33.7 | 1.70 |

- Inlining makes Tier 0's kernels 2.7 to 9.2 times faster than its calls. The issue's main `ef25f566` took 913.6,
  515.9, 319.5 and 1,110.1 ms at Tier 0: 2.9, 38, 16 and 3.3 times these.
- Tier 0 is now within 1.1 times clang -O0 or faster on the store and count kernels. The sum and multiply-add carry
  their accumulator through its variable's frame slot and Tier 0's per-depth vector slot each iteration, which only
  keeping vector values in registers (#780) removes: 1.7 times clang -O0.
- The head's kernels are main's code: step 3 changes no caller (`raw/kernels/k-tier0.kernels.s` and
  `k-base-tier0.kernels.s` differ only in their addresses, main's object having the wrappers before them;
  `raw/kernels/same.txt`'s "head != base" compares the addresses too).

## main.c's object

`main.c -DBUSTER_COMPLETE_DRIVER=1` (CI's `--symbols` unit) with the build's flags (`raw/flags.txt`) and `--lanes 1`
(`raw/objects/`):

| object | bytes | local functions | `.text` |
| --- | ---: | ---: | ---: |
| main | 9,823,424 | 1,411 | 1,898,462 |
| head | 9,673,112 | 1,248 | 1,764,414 |
| head, `-g` | 11,372,464 | 1,411 | 1,995,278 |
| clang -O0 | 8,441,176 | 1,237 | 1,599,551 |

The head leaves out 163 callees (7.1% of `.text`); `-g` keeps every one, as Tier 1's dead functions are kept under
`-g`. The local functions the head defines and clang's doesn't are our own helpers (`.Lbuster_*`) and the vector
lexer's `scan_lines`, `write_chunk` and `tokenize_chunks`, step 5's shapes (`raw/objects/main-*.local`).

## Compile time

`time-runs` under `ab` (3 rounds; base, head and base-again, each from fresh copies), `-c --lanes 1`, CPU 2
(`raw/compile/`): each round's median user cycles against base's, and the instructions (every process alike within
0.004%).

| unit | head vs base, rounds 1-3 | base-again vs base | instructions, base to head |
| --- | --- | --- | --- |
| `sqlite3.c` (frozen corpus, 590 Mcycles) | -0.17%, +0.09%, -0.23% | +0.07%, -0.11%, -0.22% | 1,350.08 M to 1,351.44 M (+0.10%) |
| `main.c` (complete driver, 7.9 Gcycles) | +0.01%, -0.02%, -0.20% | -0.09%, -0.09%, -0.09% | 21,280.4 M to 21,277.5 M (-0.01%) |

Both are within main against itself. `sqlite3.c`'s 1.4 M more instructions are most likely the runtime symbols'
renumbering, which now reads every part's references in a unit with an inline callee (its one always_inline function);
`main.c` makes no code for 163 dead callees and pays the table's columns and that pass.

## The self-built compiler

The compiler self-built by the head (`tools/ci/selfhost.c`'s bootstrap: every unit of `build.sh print-sources` by
`--lanes 1` with the build's flags less `-O3`, `-Wall`, `-Werror` and `-g`, linked by `clang -no-pie`), at Tier 0 with
inlining and with `--tier0-no-inline`, against the head's clang Release build, each on CPU 2 (`raw/selfhost/`):
`benchmark-lexer src` and `benchmark-refinement --only refine_tokens_fused src` (21 interleaved passes, medians), and
`benchmark-files --lanes 1` of `main.c` (7 runs, median).

| benchmark | clang Release | Tier 0, inlined | Tier 0, `--tier0-no-inline` | inlined vs not |
| --- | ---: | ---: | ---: | ---: |
| `c_tokenize` (the vector lexer) | 8.87 ms, 0.85 cycles/B | 546.4 ms, 52.4 cycles/B | 1,349.8 ms, 129.5 cycles/B | 2.47x |
| `c_tokenize_scalar` (no intrinsics: the control) | 93.1 ms | 286.1 ms | 301.8 ms | 1.05x |
| `refine_tokens_fused` | 16.7 ms, 11.8 cycles/token | 567.9 ms, 400.9 cycles/token | 1,628.3 ms, 1,149.6 cycles/token | 2.87x |
| `benchmark-files` on `main.c`, 1 lane | 33.1 ms | 1,124.3 ms | 2,573.9 ms | 2.29x |

- The self-built compiler's intrinsic kernels run 2.3 to 2.9 times faster with inlining; the scalar lexer, which calls
  no wrapper, 5% (other always_inline helpers). The issue asked for these as the measure of its cost.
- Tier 0's vector lexer is still 62 times clang -O3's: Tier 0's code, its vector values in frame slots (#780), not the
  calls.
- The 43 units compile in 18.24 s with inlining and 17.23 s without (`raw/selfhost/*-unit-times.txt`, each unit timed
  inside the hold), every unit with status 0.
