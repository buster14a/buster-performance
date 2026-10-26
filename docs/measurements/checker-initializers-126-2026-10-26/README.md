# What two initializer fixes cost checking, 2026-10-26

buster14a/buster's branch `claude/checker-main-c-initializers`, stacked on #480 (`claude/checker-main-c`), fixes two
initializer bugs that this compiler's own `main.c` hit (#126, #133, #129): the size of an array of unknown size whose
elements are structs from subscripts and members (`check_init_root_type`), and compound literals in a block-scope
static's initializer (`check_init_compound`). Both are on the initializer's path, which every unit's initializers take.
This measures them on the frozen `sqlite3.c`. Median of five rounds, and of three rounds of `perf stat -r 11`:

| Measure | base (#480's `c3c11120`) | head (`eb0470e2`) | change |
| --- | --- | --- | --- |
| whole `-fsyntax-only` driver, wall | 146.288 ms | 146.466 ms | +0.12% |
| whole driver, user instructions | 1,690,897,488 | 1,690,954,724 | +0.003% |
| whole driver, user cycles | 674.3 M | 675.0 M | +0.10% |
| whole driver, task clock | 146.33 ms | 146.29 ms | -0.03% |
| whole driver, peak resident set | 598,488 to 598,536 KB | 598,416 to 598,468 KB | within 0.1 MB |
| typed checking of the bodies, scalar path | 49.815 ns/node (274.9 cycles) | 50.305 ns/node (277.6 cycles) | +0.98% |
| typed checking of the bodies, vector path | 53.602 ns/node (296.4 cycles) | 54.708 ns/node (302.4 cycles) | +2.06% |

The driver does the same work: 57,000 more instructions of 1.69 billion, and the same time within its rounds. The bodies'
typed checking, which these fixes don't reach, is slower by 1% and 2% in the benchmark's process, but that process
runs the same instructions too: three runs per tree of `perf stat -e instructions:u,cycles:u` of the whole
`benchmark-checker-source` (`perfsrc4.sh`, `perfsrc4.log`) count 63,071.76 million instructions in the base and
63,071.88 million in the head (+0.0002%), while their cycles go from 17,478 to 18,528 million among the base's own
runs. That is where the code landed in this build, not work: the first run of the same change (`first/`, #480's
`77bd4aa8` against `a01929be`) measured the bodies' checking at -0.01% (scalar) and -0.16% (vector), with the driver at
+0.09% and +0.003% instructions.

## Trees

| Name | Commit | What it is |
| --- | --- | --- |
| `base` | [`c3c11120`](https://github.com/buster14a/buster/tree/c3c11120) | #480's head, this branch's base |
| `head` | [`eb0470e2`](https://github.com/buster14a/buster/tree/eb0470e2) | the branch: its fixes (`a01929be`) with #480's head merged |
| first run's base | [`77bd4aa8`](https://github.com/buster14a/buster/tree/77bd4aa8) | #480's head then |
| first run's head | [`a01929be`](https://github.com/buster14a/buster/tree/a01929be) | the branch's first commit |

Each tree was `git archive` of its commit, sent by tar into an empty directory; `source-base.sha256` and
`source-head.sha256` hold the SHA-256 of each of its files. Each was built with `BUSTER_DEBUG_INFO=0 LC_NUMERIC=C
./build.sh` (`build_base.log`, `build_head.log`); `inputs.sha256` has the executables' and the inputs' digests.

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2 at the performance governor. Each build and each
run took the shared lock on its own (`EXCLUSIVE_OWNER=claude-126`); the lock's waiting messages, which name other
sessions' runs, are removed from the logs.

## Method

As [the builtins' record](../checker-builtins-126-2026-10-26/README.md), whose `abC.sh` ran this A/B too (`abc4`):
each tree's `-fsyntax-only` once (status 0 on both), `ab --rounds 5` of `benchmark-checker-source`
(`ab_source.log`) and of `time-runs --runs 21` of the driver (`ab_driver.log`), and three rounds of `perf stat -r 11`
of the driver (`perf.log`); then `perfsrc4.sh`, a run per lock hold. The first run is `first/` (`abB.sh`).

## Limits

One input. It measures what the fixes cost the rest of the checker, not how fast the initializers they fix check.
