# Simple invocations from templates (#117), 2026-10-25

The 9700X's measurements behind Buster's PR [#444](https://github.com/buster14a/buster/pull/444), the first step of
#117's leaner expansion engine. In a vectorized run that records no history, as `-E`, `parse` and the checker's driver
run a unit, a simple macro whose body has at most 16 tokens gets a template when it is compiled (`PPTemplate`). An
expansion of at most 16 tokens is then built in registers from it and stored at once (`pp_template_write`), into the
output or into the expansions for a rescan. The template keeps which of its names are painted or go straight in
(`pp_template_names`), and gives the expansion's size (`pp_template_size`). Cited by `docs/c-preprocessor.md` ("The
main loop against #117's budget").

## Sources and inputs

| Tree | Buster commit | Files | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `main-205ef0c` | `205ef0c87bfbdfa37853086f20d889f9d514eae7` (main under the PR) | 613 | `9f779b8691053334821d06fecb4f7dad391f641a1b3c4a45f20c9e450f1eba97` |
| `cand-721e107` | `721e107d32690b76786912ffd2156f570264937e` (the PR's head, with main merged) | 613 | `dec70b8d568249410c8e011b5e7a8ca882262833df2ece0a8f90cea25505751f` |
| `cand-3c98454` | `3c98454ef7bac1cc4b34f56306b8923875c6630a` (the PR before its last commit) | 613 | `fc7c5413aea1bc25787d1257d15aba406155d778aac89d2d4086c6745ce39c11` |

Each `source-*.sha256` lists the SHA-256 of every file of `git archive` of the commit. The trees were sent to the host
by `git archive`, and the host's files, apart from `build/`, match the manifests. Buster's `./build.sh` built each one
there (`logs/build19-main-205ef0c.txt`, `logs/build20-cand-721e107.txt` and
`logs/before-base-pages/build19-cand-3c98454.txt`). The `build/compiler` SHA-256s:

- `main-205ef0c`: `faa0a0764b8906a4b9cc05ac824cc2c6051e357be9d539c25cbb6dd2db9f24b6`;
- `cand-721e107`: `d2e663578d0130010dde883f7668828e45723c26f3df174a14a3dbfce3698516`;
- `cand-3c98454`: `184963e2ed8e2effe636896e57e54733edda20019bd0a2b0d28d7edf1377bbdc`.

The inputs are the 2026-10-23 acceptance's:

- the frozen `sqlite3.c` 3.53.2, from the bundle `preprocessor-corpora-astra-01a158dd`
  (`sqlite3.c`: `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`), compiled with the bundle's pinned
  headers: `-target x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc` and its three `-isystem` directories;
- `main.c` of the frozen tree `635434f2`, with the system's headers, as the 9700X job's smoke command preprocesses it.

Both are in `scripts/args.sh`. `SOURCE_DATE_EPOCH=1792454400`; `CPATH`, `C_INCLUDE_PATH` and `CPLUS_INCLUDE_PATH` are
unset.

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, with the `performance` governor and energy preference.
Every run took the shared lock on its own, through `~/buster-fast-bench/exclusive.sh` with `EXCLUSIVE_OWNER=claude-117`
(`scripts/locked.sh`), pinned to CPU 2. The lock's waiting messages, which name other sessions' runs, are removed from
the logs; nothing else in them is changed.

`scripts/queue20.sh` measured the PR's head; its header comment names `3c98454`, the commit `scripts/queue19.sh` had
measured, by mistake, but every command in it names `cand-721e107`. Each queue ran, in order:

- `benchmark-preprocessor --history-cost --only scalar` on the two trees by turns, four rounds on `sqlite3.c` and three
  on `main.c`: the vectorized kernels with the history deferred, as compiles run a unit, which takes the templates;
- `benchmark-preprocessor --only vectorized`, three rounds on `sqlite3.c`: the history recorded, as the benchmark's
  default records it, which takes the old paths;
- `time-runs` under `ab` (Buster's `docs/profiling.md`, "Whole drivers"): three rounds with the trees' order rotating by
  round, and in each round 21 processes of `-E`, `parse -fsyntax-only` and `-fsyntax-only` of `sqlite3.c` after a
  warm-up, each timed from `fork` to `wait4`.

Each benchmark run reports medians of 21 passes after a warm-up; a range below is the rounds' medians.

## The main loop

`sqlite3.c`, history deferred (`logs/ab20-deferred-sqlite-*.txt`):

| `sqlite3.c` | Whole run | Directive tables | Main loop/setup | Cycles/input token | Instructions/input token |
| --- | ---: | ---: | ---: | ---: | ---: |
| `main-205ef0c` | 9.332-9.477 ms | 0.338-0.345 ms | 4.551-4.685 ms | 33.85-34.44 | 109.51 |
| `cand-721e107` | 9.206-9.254 ms | 0.339-0.341 ms | **4.422-4.476 ms** | 33.28-33.53 | 106.38 |

Directive tables plus main loop: 4.889-5.025 ms on main, 4.761-4.817 ms on the PR's head.

`main.c` (frozen at `635434f2`), history deferred (`logs/ab20-deferred-main-*.txt`):

| `main.c` | Whole run | Directive tables | Main loop/setup | Instructions/input token |
| --- | ---: | ---: | ---: | ---: |
| `main-205ef0c` | 30.194-30.957 ms | 0.307-0.309 ms | 21.344-22.172 ms | 283.51 |
| `cand-721e107` | 29.861-30.138 ms | 0.309-0.313 ms | 21.035-21.289 ms | 282.83 |

`sqlite3.c`, history recorded (`logs/ab20-recorded-sqlite-*.txt`):

| `sqlite3.c` | Whole run | Directive tables | Main loop/setup | Instructions/input token |
| --- | ---: | ---: | ---: | ---: |
| `main-205ef0c` | 10.216-10.266 ms | 0.347-0.352 ms | 5.394-5.441 ms | 118.02 |
| `cand-721e107` | 10.202-10.253 ms | 0.349-0.358 ms | 5.374-5.413 ms | 118.15 |

The runs that record the history take the old paths, with 0.11% more instructions here; their times overlap.

The benchmark's `-E -P` printing step after each pass took 4.428-4.466 ms on main and 4.492-4.540 ms on the PR's head
with the history deferred, and 4.482-4.497 ms against 4.557-4.562 ms recorded. The PR doesn't change the printer:
`pp_print`, the same 13,041 bytes in both binaries, starts 48 bytes into a 64-byte line on main and 16 bytes into one on
the PR's head (`nm -S`).

## Whole drivers

`logs/drivers20-sqlite.txt`. A range is the rounds' medians, and the spread is the fastest and slowest single process
over all rounds.

| `sqlite3.c` | Tree | Wall time | Spread | Peak resident set | Minor faults |
| --- | --- | ---: | ---: | ---: | ---: |
| `-E -o /dev/null` | `main-205ef0c` | 19.497-19.661 ms | 19.180-20.169 ms | 59,384-59,392 KB | 798 |
| | `cand-721e107` | 19.393-19.689 ms | 19.107-19.938 ms | 59,384-59,412 KB | 812 |
| `parse -fsyntax-only` | `main-205ef0c` | 18.303-18.341 ms | 18.040-18.924 ms | 141,896-141,900 KB | 915 |
| | `cand-721e107` | **17.997-18.147 ms** | 17.779-18.920 ms | 141,896-141,912 KB | 930 |
| `-fsyntax-only` | `main-205ef0c` | 147.213-147.602 ms | 146.475-149.167 ms | 592,968-592,976 KB | 1,419 |
| | `cand-721e107` | **146.501-147.114 ms** | 145.762-148.529 ms | 592,864-592,880 KB | 1,433 |

The 14 or 15 more minor faults are about the templates' 66 KB of base pages (below).

## Before the templates' base pages

`scripts/queue19.sh` measured `cand-3c98454`, the PR before its last commit, the same way (`logs/before-base-pages/`).
`sqlite3.c` makes 254 templates of 260 bytes, about 66 KB, just past the 64 KB of base pages that `pp_array` gives an
array before its huge pages, so every run touched a huge page for its last few templates, which the kernel cleared
whole. With the history deferred, `sqlite3.c`'s instructions per input token went from 109.51 to 106.38 and its cycles
from 34.00-34.40 to 33.67-33.75, but its main loop took 4.575-4.624 ms on main and 4.559-4.586 ms there, and the whole
run 9.346-9.436 ms against 9.379-9.401 ms: the benchmark counts user-space cycles, and the clearing is the kernel's. `-E` peaked at
59,892-59,972 KB against main's 57,840-57,872 KB. The last commit gives the templates `pp_array_small`'s 1 MB of base
pages.

The first start of `scripts/queue19.sh` built `main-205ef0c` and was stopped before it measured anything, while the
PR's head changed; the restarted queue built only `cand-3c98454`. An earlier queue, of the PR's second commit against
main at `54703dc`, was stopped after two rounds for the same reason; its runs are not used.

## Limitations

The data are medians of rounds from one machine, taken by turns while CI jobs and other sessions shared the machine
between runs. Different builds of the same code differ by up to about 1% from code placement alone (Buster's
`docs/profiling.md`, "Builds in turn"), as the printing step shows. Only `sqlite3.c` was timed as whole processes and
with the history recorded. The same binary's peak resident set differs between the queues: `-E` on main peaked at
57,840-57,872 KB in `scripts/queue19.sh`'s rounds and 59,384-59,392 KB in `scripts/queue20.sh`'s. Locally, such a
difference was in the compiler's own mapped text, which depends on how its file sits in the page cache.
