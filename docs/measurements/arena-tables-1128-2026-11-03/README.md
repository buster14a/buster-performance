# Arenas of tables and the units' benchmark (#1128), 2026-11-03

Evidence for buster14a/buster#1128's second pull request. The preprocessor's
fixed tables, each token buffer's columns and the parser's token, tree and
postorder columns now share one mapping per group (`arena_reserve_tables`,
`lane.c`), where each was an arena of its own. A units lane's first unit so
makes fewer reservations, each of which takes the address space's lock for
writing, and every unit discards 24 arenas rather than 68, each discard a TLB
flush sent to the other lanes. `benchmark-check-units` is new: it reports each
lane count's system time against one lane's.

## Source revisions and trees

- main: `703ae9f581b00c2cbb4061e907d0951b11ea9637` (buster14a/buster `main`).
- head: `869354b5ad3b1b49ca33ae9a85c8243b474421c8` (branch
  `claude/solve-1128-units-arenas`): two commits on main, `e4b1d68a` (the
  arenas of tables) and `869354b5` (`benchmark-check-units`).
- `0c51b8fdb99a90bc5e127886e5e322918a167f18`, one commit on head that changes
  only `benchmark-check-units`, its test and its CI step (it fails a command
  that fails every run). Its compiler ran the benchmark (`logs/benchmark-0c51b8fd`).

Each tree is `git archive` of its commit, sent to the 9700X by tar.
`trees/manifest-*.txt` are the archives' `sha256sum`s, made on the laptop, and
`logs/*/host-manifest-*.txt` the host's before building (build output
excluded). `trees/manifests-compared.txt` compares them by path: they are the
same but for the `COMMIT` file each tree gets there.

Each was built with `BUSTER_DEBUG_INFO=0 ./build.sh` (`-march=native`, which is
znver5 there) in its own hold of the host's lock (`logs/*/build-*.log`); the
`receipts.txt` files have the executables' `sha256sum`s.

## Host

The Ryzen 7 9700X (`logs/main-vs-869354b5/receipts.txt`, `logs/host-cpus.txt`):
Linux 6.18.50-2-lts, clang 23.1.1, strace 7.2, `vm.overcommit_memory` 0,
transparent huge pages `always`. CPU 2's governor and EPP are `performance`,
CPUs 0, 1 and 3 to 7 `powersave` with `balance_performance`, and CPU 10 (CPU
2's sibling) is offline. The lanes' runs use CPUs 0 to 7; `sqlite3.c` CPU 2.

## Commands

`scripts/round-head.sh main-703ae9f5 head-869354b5` built both trees, then held
the lock once for each of (with main's executable driving `time-runs`: whole
processes, the builds in a rotating order, one warm-up):

- Lua 5.4.8's 33 units but `luac.c` linked with `-std=gnu99 -DLUA_COMPAT_5_3
  -DLUA_USE_LINUX -w --lanes N -o lua *.c -lm -ldl`, N 1, 2, 4 and 8, 11 runs
  each, `taskset -c 0-7`, then `strace -f -c` of each build's link by 1 and 8
  lanes and the four executables' `sha256sum`s (`logs/main-vs-869354b5/lua.log`,
  `strace-*.txt`, `inner-lua.sh`);
- synth's 512 units of 200 functions (`test-check-units --generate`, as in the
  record of #1128's first pull request) linked by `--lanes 1` and `8`, 5 runs
  each, `taskset -c 0-7`; and the frozen corpus's `sqlite3.c` by `-c` with its
  pinned predefines and headers, 11 runs, `taskset -c 2` (`synth.log`,
  `inner-synth.sh`).

`scripts/round-bench.sh main-703ae9f5 head-0c51b8fd` built the third tree and
held the lock once for the 9700X step's command, `benchmark-check-units --lanes
1,2,4,8 --runs 5` with the frozen corpus's headers and predefines, run by
`0c51b8fd`'s compiler with `--executable` main's compiler and then its own
(`logs/benchmark-0c51b8fd/bench.log`, `inner-bench.sh`).

Every timed process of those exited 0, as did every step (`status` files). The
four Lua executables are the same bytes (`50a16925…`).

`round-head.sh`'s last step ran the benchmark as `869354b5`'s CI step had it
(`logs/main-vs-869354b5/bench.log`): every process failed at once, refusing
`--no-default-config`, an option of `benchmark-check-lanes` rather than the
driver's, and the benchmark still exited 0, since `time-runs` fails a run only
where its status differs from its first warm-up's. `0c51b8fd` drops the option
from the step and makes the benchmark fail unless every process succeeds.

## Results

Medians, milliseconds (`time-runs`' wall time; system time from its rusage):

| command | main | head | head against main | system ms, main → head |
| --- | ---: | ---: | ---: | ---: |
| Lua, 1 lane | 75.927 | 74.740 | -1.56% | 20.1 → 12.8 |
| Lua, 2 lanes | 46.695 | 46.097 | -1.28% | 24.6 → 21.4 |
| Lua, 4 lanes | 34.600 | 33.063 | -4.44% | 36.4 → 31.3 |
| Lua, 8 lanes | 33.678 | 30.449 | -9.59% | 67.0 → 55.7 |
| synth, 1 lane | 1,597.153 | 1,572.190 | -1.56% | 262.1 → 233.0 |
| synth, 8 lanes | 453.113 | 442.506 | -2.34% | 632.1 → 655.3 |
| `sqlite3.c -c`, CPU 2 | 111.208 | 110.712 | -0.45% | 16.8 → 16.7 |

Main's Lua runs on 8 lanes range from 29.4 to 64.4 ms; head's from 27.5 to
33.4. User cycles: Lua -0.7 to -1.2%, synth -0.76% (1 lane) and +0.60% (8),
`sqlite3.c` -0.78%. User instructions: Lua -0.2 to -0.3%, synth -0.1%,
`sqlite3.c` +41,198 of 1,189 million. Peak RSS (`wait4`, which includes the
parent's pre-exec memory) is within 0.5% but Lua's 8 lanes, 205,048 → 207,792
KiB (+1.3%); `sqlite3.c`'s fell 864 KiB.

System calls of the Lua link (`strace -c`, which inflates their cost):

| | main, 1 lane | head, 1 lane | main, 8 lanes | head, 8 lanes |
| --- | ---: | ---: | ---: | ---: |
| `madvise` | 2,389 | 891 | 3,272 | 1,461 |
| `mprotect` | 195 | 165 | 1,110 | 727 |
| `mmap` | 149 | 112 | 818 | 481 |
| `munmap` | 129 | 92 | 786 | 443 |
| all | 4,435 | 2,833 | 12,436 | 9,512 |

`benchmark-check-units` (64 units of 200 functions by `-c`, 5 runs; main's
compiler and head's measured one after the other, not interleaved):

| lanes | main wall | speed | main system | of 1 lane's | head wall | speed | head system | of 1 lane's |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 185.287 | 1.00x | 26.472 | 1.00x | 181.632 | 1.00x | 29.578 | 1.00x |
| 2 | 100.287 | 1.85x | 37.001 | 1.40x | 96.941 | 1.87x | 37.090 | 1.25x |
| 4 | 68.837 | 2.69x | 49.231 | 1.86x | 63.588 | 2.86x | 44.485 | 1.50x |
| 8 | 61.882 | 2.99x | 124.638 | 4.71x | 58.469 | 3.11x | 106.043 | 3.59x |

## Exploratory measurements

- `exploratory/profile-main-b70deb47/` (`scripts/prof9700.sh`, then
  `scripts/classify.awk` and `scripts/faults.awk`): `perf record -g` of main
  `b70deb47`'s Lua link by 8 lanes (three runs) and 1 lane, its samples by the
  system call or fault their kernel stack serves. On 8 lanes: huge-page faults
  12.6 to 13.5% (3.2% on 1 lane), base-page faults 9.6 to 10.2%, waits for the
  address space's lock for writing about 9.6% (`madvise`'s page advice 2.6 to
  2.7%, `mprotect` 2.4 to 2.6, `mmap` 2.1 to 2.8, `munmap` 1.9 to 2.3), and
  `MADV_DONTNEED`'s zap, TLB flushes and the flushes' interrupts on the other
  lanes about 10.5%. The 8-lane huge-page faults are mostly the units' merge
  (`check_units_merge_lane`), the checker's graph and sparse tables and the
  intern table, past this change. The perf data files aren't included.
- `exploratory/release-sites/`: on the laptop (Zen 4), a unit's releases into
  the pool by call site, from a build of `d235a79e` that printed each pooled
  release's site, size, base pages, peak and commit (a temporary `fprintf` in
  `arena_release`, not kept), for Lua's link on one lane: 68 a unit, 27 of them
  the preprocessor's tables and 15 its token columns, pushed whole, and 11 the
  parser's columns. `strace-k-*.txt` count each call by its first caller
  outside the arenas (`strace -f -k`, `scripts/stacks.awk`), before (`d235a79e`)
  and with the change (24 `MADV_DONTNEED` a unit).
- `exploratory/tables-preprocessor-only/` (`scripts/round-tables1.sh`): a first
  round with only the preprocessor's tables in arenas of tables
  (`head-tables1.diff`, on `d235a79e`) against main `b70deb47`. The trees also
  differ by main's commits between `d235a79e` and `b70deb47`, so its
  differences (Lua by 8 lanes -8.9%) aren't the change's alone.
- `exploratory/keep-pages-variant/`: a rejected variant (`keep-pages.patch`, on
  `d235a79e`): a pooled arena whose stale pages end within `BUSTER_ARENA_KEEP`
  bytes keeps them, and a commit clears what it hands out, rather than the pool
  discarding them. On the laptop (`laptop-time-runs.log`, Lua by 1 and 6 lanes,
  11 runs) 256 KB and 1 MB were within noise of 0 (main's behaviour) and 4 MB
  22 to 25% slower; without a bound a link took seconds (not logged). Tables
  that are pushed whole but touched sparsely make every pushed byte stale, which
  the clears then fault in.
- `exploratory/discard-probe/` (`discard.c`, `laptop.log`, Linux 7.3.1): 68
  `MADV_DONTNEED` calls against one `process_madvise` of the same ranges, with
  5 other threads of the process running: 240 µs against 58 µs a round, the
  batch sending one TLB flush. It wasn't used: `process_madvise` takes an
  iovec, whose total length the kernel truncates at `MAX_RW_COUNT` (about 2 GB),
  and the pooled mappings are up to 64 GB each.

## Limitations

- The lock's waiting messages, which name other sessions' runs and links, were
  removed: each log keeps only the lines its own scripts and tools print
  (`scripts/keep_own.py`), and the record was searched for other sessions'
  names and paths afterwards.
- One host, one kernel. The issue's 4-core VM wasn't measured.
- `strace -c` serializes the threads it traces; its call counts are exact, its
  times aren't.
- `benchmark-check-units`' two builds ran one after the other, so their rows
  compare less exactly than `time-runs`' interleaved ones above.
- The correctness checks ran on the laptop, not here; the pull request has them.
