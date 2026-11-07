# Search directories' listings, #653 / buster14a/buster#1564

Raw 9700X (`benchpress`, Arch Linux, Btrfs) measurements behind
[buster14a/buster#1564](https://github.com/buster14a/buster/pull/1564), which merged the include search's directory
listings for [#653](https://github.com/buster14a/buster/issues/653). The PR's description and `docs/c-files.md`
("Search directories' listings") summarize them. Collected by Claude Code session
`session_01NNmNQskowXM2m3SgKha3JE` from `~/buster-fast-bench/653-claude/`, 2026-11-06 19:33 to 2026-11-07 00:32 UTC.
Every run took the 9700X's lock alone (`~/buster-fast-bench/exclusive.sh`, owner `claude-653`), pinned to CPU 2
(`taskset -c 2`) except `benchmark-files`, which pins its own lanes.

## Host

AMD Ryzen 7 9700X (`benchpress`), Linux 6.18.50-2-lts, the `performance` governor on CPU 2, clang 23.1.1 (which built
both executables), strace 7.2. The search directories were clang's resource directory (263 names),
`/usr/local/include` (2) and `/usr/include` (440), on Btrfs.

## Builds

- Base: `ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b` (main before #1564), `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
  ./build.sh --jobs 8`, `base/build/compiler` sha256 `51fa8ef2c145ba232daf21fbe69257a10feaacb5e87e7be7aeae0bdd2dd92c59`.
- PR: the base with the PR's `src/` diff applied (`update.sh`), built the same way. The tree was rebuilt for each
  version below; `653.patch` (sha256 `3b59d0e13ca8454eca935ecdf578d86a33fab1fcf599d5da7676d075538a0f8e`) is the last,
  `ee23efa5`'s, whose executable was sha256 `bdafb557f6c925769e5062390a151002e6a715403ac0afe593910de3eb5db627`.
  `de7d7dce`, the merged head, changed only the files walk's cache entries, which none of these commands but
  `benchmark-files` exercises.

## Inputs

- zlib 1.3.1, `zlib-1.3.1.tar.gz` sha256 `9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23`:
  `deflate.c` `3b956337…`, `uncompr.c` `04dca5e3…` (`out-16/inputs.sha256` has the full hashes).
- SQLite 3.53.4's amalgamation `sqlite3.c`, sha256 `b1dd5d74ec7f29055a6684fa06fb3c2f6821c87dd38f9a458dfd2e8a1db28189`.
- `tiny.c` (no include) and `one.c` (`#include <stdio.h>` alone), written by `measure.sh`.
- The many `-I` case (`measure.sh`'s `make_many`): D empty directories before one with H guarded headers, and a unit
  that includes them all, for D, H = 10, 2,000; 100, 2,000; 200, 4,000.

## Scripts and what each version's run left

| Version (commit) | Policy | Logs | Outputs |
| --- | --- | --- | --- |
| `695b6eae` | every directory read whole at its 16th failed probe | `measure.log`, `measure-first.log` (stopped), `measure2.log`, `pp-thresholds.log` | `out-16/` |
| `62169a35` | first look at 16, a large directory whole at 128 | `measure3-128.log` | `out-128/` |
| `c5b164a2` | first look of one `getdents64` at 16, whole at 256 | `measure3-16b.log`, `measure3.log`, `pp-thresholds-final.log` (thresholds 32, 16, 0) | `out-16b/` |
| `1f6e120e` | first look at 32, whole at 256 | `measure4-32.log` | `out-32/` |
| `ee23efa5` | as `1f6e120e`, lookups find a directory only after a failed probe or a listing | `measure4.log`, `pp-thresholds-head.log` (thresholds 32, 0) | `out/` |

- `setup.sh`, `update.sh`: the trees and builds. `measure.sh`, `measure2.sh`, `measure3.sh`, `measure4.sh`: the
  campaigns (later ones batch the strace counts and the preprocessor benchmark into one lock hold each).
  `strace-batch.sh`, `pp-batch.sh`, `pp-thresholds.sh`: the batches. A run stopped for a newer version left its
  partial log, kept as is.
- `out*/strace-{base,pr}-*.txt`: `strace -f -c` of each `-c` compile (and `-fsyntax-only` many `-I` unit), for the
  failed `openat` counts. Every object was byte-identical between base and PR (`cmp`, in the logs).
- `out*/time-small-*.txt`, `out/time-many.txt`: `time-runs --runs 15 --copies 2` (7 for the many `-I` case), base and
  PR interleaved, every process's wall time, rusage, user cycles and instructions, and the builds compared.
- `out/files-{base,pr}.txt`: `benchmark-files` of the PR tree's `main.c` with each executable.
- `pp-thresholds*.log`: `benchmark-preprocessor --only vectorized --listing-misses …` in one executable, the include
  searches' inclusive median (`includes … ms`) per threshold.
- `bench/listing_cost.c`: a failed probe against a whole listing, alone (medians of 2,001); its output is the end of
  `measure2.log`. `bench/syscall_cost.c` and `bench/syscall_cost.log`: each system call of a directory's first look.

## Notes

- The 9700X was shared through its lock with CI and other sessions throughout; the timings are each one hold's.
- Repetitions: `time-runs` 15 runs × 2 copies per build and list in each of 3 holds (7 × 2 in one hold for the many
  `-I` case); `benchmark-preprocessor` 21 passes after a warm-up, the variants in turns; `benchmark-files` 21 runs per
  lane count.
- Whole-process times of the small units don't resolve the change: `tiny.c`, with no include, ran 2% fewer user
  cycles and 16–22% less wall time in the PR's executable than in the base's (code placement, #502). The include
  searches' timer in one executable (`pp-thresholds*.log`) is the comparison that does.
