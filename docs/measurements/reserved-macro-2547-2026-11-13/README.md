# -Wreserved-macro-identifier's cost when it is off (2026-11-13)

[buster#2547](https://github.com/buster14a/buster/issues/2547): #2530's `pp_reserved_macro_name` compared every reserved
`#define` name with 29 feature-test macros by `strlen` and `memcmp`, then called `pp_diagnose_group`. That function
formatted the message and the flag and read the command line's warning options, all before it learned that the
warning, off by default, was ignored. [buster#2638](https://github.com/buster14a/buster/pull/2638) tests one bit
first. This record measures main, the PR's head, and main without the check's two calls ("nocheck", the directives'
cost before #2530).

- **Source:** buster `26f0bb0e1ab0ae8fc0a7c119064796dfd4b0d5fa` (main on 13 November), three worktrees of one clone on
  the host (`scripts/prepare.sh`):
  - `main` as it is;
  - `head`: main with `scripts/head.patch` (SHA-256 `117a0036…`, the same bytes as `git diff 26f0bb0e a88b7c3c`, the
    PR's commit `a88b7c3cf2ca23815c78018f01f436d63bfbc389`);
  - `nocheck`: main with `scripts/nocheck.patch`, which deletes the two `pp_reserved_macro_name` calls and marks the
    function unused.
- **Builds:** each tree's `./build.sh` (Release, `-O3 -march=native`, debug information), one hold of the lock each
  (`scripts/build.sh`, `results/build/`, executables' SHA-256 in `results/build/sha256.txt`).
- **Host:** the Ryzen 7 9700X (`benchpress`), Linux 6.18.50, clang 23.1.1, perf 7.2.9; CPU 2 at governor and EPP
  `performance`, its SMT sibling (CPU 10) offline; outputs on tmpfs. `env.txt` has these and every script's, tool's
  and input's hash.
- **Runs:** `scripts/run.sh 11`, one hold of the lock. procbench (the whole-build record's
  [`procbench.c`](../whole-build-672-2026-11-12/scripts/tools/procbench.c), copied unchanged) on `lists/ab.list`, 11
  rounds. Each round rotates the line order, and every line has one discarded warm-up before its run. Everything is
  pinned to CPU 2 with the harness. The counters are user and kernel cycles and instructions from each process's exec.
  Figures are medians of 11 (`results/ab/medians.tsv`), and every run is in `results/ab/runs.tsv`.
- **Workloads**, the whole-build record's lines:
  - `m-c`: musl 1.2.5's 1,336 units (the first source of each base name) as one command, `-c --lanes 1`, with the
    corpus README's options and no `-W` option;
  - `s-c`: `-c sqlite3.c` with the 9700X job's `compile_time` options.

## Results

musl's 1,336 units, `-c --lanes 1`, CPU 2:

| | main | head | nocheck | head − main | head − nocheck |
| --- | ---: | ---: | ---: | ---: | ---: |
| wall, ms (least–greatest) | 826.9 (824.9–828.3) | 755.0 (753.4–758.5) | 756.1 (754.6–757.5) | −71.9, −8.7% | −1.1 |
| user cycles, M | 3,552.4 | 3,154.3 | 3,158.0 | −398.1, −11.2% | −3.7 |
| user instructions, M | 9,064.4 | 7,820.1 | 7,814.5 | −1,244.4, −13.7% | +5.6, +0.07% |
| kernel cycles, M | 1,014.4 | 1,014.9 | 1,015.6 | | |
| page faults | 331,172 | 331,173 | 331,173 | | |

`-c sqlite3.c`, CPU 2:

| | main | head | nocheck |
| --- | ---: | ---: | ---: |
| wall, ms (least–greatest) | 124.13 (123.72–124.31) | 123.91 (123.38–124.68) | 123.82 (123.52–124.52) |
| user cycles, M | 600.8 | 600.3 | 600.2 |
| user instructions, M | 1,351.5 | 1,348.2 | 1,348.2 |

- **The check cost main 1,250 M instructions on musl's command** (main − nocheck), 16.0% of what the units take
  without it. The head gives back all but 5.6 M of them: about 4,200 instructions a unit, the bit's test at each of a
  unit's `#define`s and `#undef`s, its headers' included, plus one cold call a unit. That is the "one test a directive"
  the issue asks for. The user instructions of each tree's 11 runs differ by at most 12 thousand
  (`results/ab/runs.tsv`), so the +5.6 M is no noise.
- **Wall time follows:** −71.9 ms (−8.7%). The head's range overlaps nocheck's, and neither overlaps main's.
- **`sqlite3.c` moves by 3.3 M instructions** (0.24%), the head equal to nocheck, its wall inside run-to-run
  spread.
- The issue's figures (12,766 M instructions at `4c8c3c9c`) are another revision's and aren't comparable with these
  absolutely; this record compares three trees of one revision.

## Where the instructions went

`scripts/profile.sh 5`, one hold of the lock: musl's command five times for each tree under one `instructions:u`
profile, by symbol (`results/profile/`), in millions of user instructions a command. The period, 1,000,003, keeps the
sampling below the kernel's limit (`perf_event_max_sample_rate`, 63,300 here). The samples' periods sum to 9,064.2,
7,820.2 and 7,814.2 M a command (`sum.txt`), the instructions procbench counted. A first profile at a period of 100,003
was throttled (its samples summed to 61% of the count) and isn't kept.

| function | main | head | nocheck | main − nocheck |
| --- | ---: | ---: | ---: | ---: |
| `__strlen_evex512`, `strlen` | 551.2 | 13.4 | 16.4 | 534.8 |
| `__printf_buffer` and the other `printf` functions | 569.2 | 324.0 | 294.8 | 274.4 |
| `pp_prepared_directive` (with `pp_define` and the check inlined in it) | 836.0 | 661.6 | 651.8 | 184.2 |
| `__strchrnul_evex512` | 126.4 | 44.4 | 38.0 | 88.4 |
| `__memcmp_evex_movbe`, `memcmp` | 127.2 | 39.4 | 45.6 | 81.6 |
| `pp_warning_*`, `pp_diagnose_group*`, `pp_reserved_*` | 26.0 | 0.0 | 0.0 | 26.0 |
| every other function | 6,828.2 | 6,737.4 | 6,767.6 | 60.6 |
| total | 9,064.2 | 7,820.2 | 7,814.2 | 1,250.0 |

The family the issue's profile named holds 1,189 M of the check's 1,250 M. In the head, no sample falls in the warning's
own functions (`pp_reserved_macro_check`, `pp_warning_possible`, `pp_warning_command_read`) at this period. A
function's figure moves between head and nocheck by up to 30 M (`printf`, `memcmp`) where the totals differ by 6 M,
which is the sampling's attribution, not work. About 300 M of `printf` work remains in all three trees. It comes from
outside this check (nocheck has it too) and this record doesn't trace it.

## Limits

- One host state: every run here is in the same page state (331,172 or 331,173 faults on musl's command), and
  instructions don't depend on it.
- As the run's hold of the lock began, `exclusive.sh` listed an orphaned `llvm-symbolizer` (parent 1, CPU 8, just
  started), which none of this record's steps starts (`results/queue.log`). It was gone by the run's end
  (`results/ab/others.txt`). CPU 8 doesn't share CPU 2's core. The rounds rotate the trees, so any effect falls on
  all three alike, and it can't touch the instruction counts.
- `results/queue.log` keeps only the lines the record's own scripts and `exclusive.sh`'s busy list print. The lock's
  waiting messages, which name other sessions' runs, are left out.
