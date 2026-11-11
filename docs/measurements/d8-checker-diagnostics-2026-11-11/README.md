# D8 checker diagnostics PRs, base against heads, 2026-11-11

Base-against-head timings on the 9700X for package D8's checker diagnostics PRs in buster14a/buster:

| PR | Issue | What it adds |
| --- | --- | --- |
| [#2364](https://github.com/buster14a/buster/pull/2364) | #2291 | `[[clang::likely]]` and `[[clang::unlikely]]` |
| [#2365](https://github.com/buster14a/buster/pull/2365) | #2321 | casts to variably modified types |
| [#2366](https://github.com/buster14a/buster/pull/2366) | #2264 | static assertions among members |
| [#2391](https://github.com/buster14a/buster/pull/2391) | #2190 | `-Wstring-plus-int` |
| [#2393](https://github.com/buster14a/buster/pull/2393) | #2264 | `-Wunused-label` |
| [#2394](https://github.com/buster14a/buster/pull/2394) | #2264 | `-Wshift-op-parentheses` |

## Host and method

- **Host:** Ryzen 7 9700X (`benchpress`), CPU 2 (`taskset -c 2`), clang 23.1.1.
- **Builds:** each tree was built with `BUSTER_DEBUG_INFO=0 ./build.sh` (Release, native host) under its own `exclusive.sh` hold (`setup.sh`).
- **Timing:** each `measure.sh` call is a single `exclusive.sh` hold around one `time-runs`, which interleaves the builds. It times four command lists:
  1. `-fsyntax-only` on the pinned corpus's `sqlite3.c`;
  2. `-c` on `sqlite3.c`;
  3. `-fsyntax-only` on `src/buster/compiler/main.c`;
  4. `-c` on `main.c`.
- **Stage times:** `stages.sh` gives `--time-stages` for `main.c`, nine runs per tree, in one hold.

## Trees

| Name | Revision |
| --- | --- |
| `base` | main `e43dfc1027368452a3e6b6c3f32e54faffae587a` |
| `base51` | main `51e7ed47c63fb1e2d0554d5e2520e6d440e563ee` |
| `base_baf` | main `baf12cf652e007673bdb98c68bc492bce0cb31d4` |
| `h2364` | `ca91e14733337958ed06c93edccfca55406623dc` |
| `h2366` | `1128b0481be32086b42fc61987b04094c8eacf54` |
| `h2190` | `7548c34d849105c89a659c0cf9c77dfcb60e7fb2`, #2391's code before its later main merges and ID renumbering |
| `h2393` | `cdc858014d59a1a2013599dbcae4a25050df84d9` |
| `h2394` | `19b577015a04d4c869427b7f4104fc7bc49f3044` |
| `h2365` in runs 1–3 | the branch tip at the time; the exact SHAs were not recorded (see below) |
| `h2365` in run 4 | `a4082e2b712577db82e82f003536e93f1df44a18` |

`h2365` changed between runs:
- Runs 1 and 2 measured its first version, with the cast code inline in the reader.
- Run 3 measured it after the code moved into cold `noinline` helpers.
- Run 4 measured the final head.

Later heads of these PRs differ from the measured ones only by main merges and renumbered warning IDs.

## Results (median user cycles against base)

| Run | Runs | Build | sqlite `-fsyntax-only` | sqlite `-c` | main.c `-fsyntax-only` | main.c `-c` |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 11 | h2364 | -0.42% | -0.44% | +0.22% | -0.35% |
| 1 | 11 | h2365 (first) | -0.40% | -0.38% | +0.81% | +0.66% |
| 1 | 11 | h2366 | -0.66% | -0.61% | +0.45% | +0.25% |
| 2 | 31 | h2365 (first) | -0.64% | -0.50% | +0.78% | +0.82% |
| 3 | 31 | h2365 (cold helpers) | -0.44% | -0.34% | -0.34% | +0.14% |
| 3 | 31 | h2190 | -0.65% | -0.57% | -0.30% | -0.16% |
| 4 | 21 | h2365 (final, against base51) | +0.03% | +0.07% | -0.29% | -0.21% |
| 5 | 21 | h2393 (against base_baf) | +0.22% | +0.17% | +0.44% | +0.36% |
| 5 | 21 | h2394 (against base_baf) | +0.07% | -0.34% | +0.67% | +0.44% |

Retired instructions per process stay within 0.04% of base in every run. All runs ended with 0 failed processes.

#2365's first version cost main.c about 0.8% of cycles at unchanged instructions, which is code layout. With the cold helpers it measures flat in runs 3 and 4.

#2393 and #2394 measure between +0.07% and +0.67% of cycles, with wall times between -0.0% and +0.5%. Their extra instructions are under 0.04% (#2394's check visits each shift operator). That is within the spread seen between unchanged trees in these runs.

Raw files:
- `run1.txt` through `run5.txt`;
- `stages1.txt` (#2365's first version against `base`);
- the scripts.

Session: https://claude.ai/code/session_01EgbxndzEpWbBb3xjo3m4ge
