# The crt objects' records apart in the runtime snapshot: the 9700X A/B for #490

2026-10-26. Paired measurements for
[buster14a/buster#490](https://github.com/buster14a/buster/issues/490): since
#483 put `libgcc.a`'s 298 members in the dynamic runtime, a direct link's
`bind_begin` took 3 µs more and the C driver's hello world 14 more minor faults.
This record measures the cause (the snapshot's mapping's faults within
`bind_begin`) and the branch that lays the crt objects' records out apart from
the members' (`claude/490-snapshot-crt-region`), against main and against main
before `libgcc.a`.

## Revisions

- **main**: `35f26f68226a62e3a8a5e8ebd0ab18d3a20dbc0c` with
  `main-measurement.patch`: `benchmark-link`'s count of a timed run's page
  faults in `runtime_open` and in `bind_begin` (the same code as the branch's),
  and a diagnostic switch, `BUSTER_SNAPSHOT_POPULATE`, which populates the
  snapshot's mapping (`madvise(MADV_POPULATE_READ)`) before anything reads it.
  The switch is this record's only; the branch has none.
- **pre**: main before `libgcc.a` joined the dynamic runtime,
  `ff8936bef4460465c827e8afd4221714d3d1c284`, #483's own archived build
  (`~/buster-fast-bench/libgcc-136-main`, the sha256 #483's record names). Its
  `benchmark-link` has no per-part fault counts.
- **the branch**, three heads in turn:
  - `77a46178`: format 6, the crt objects' records apart (rounds 1 to 5);
  - `ac507761`: also `Bind.symbols` written as each piece joins rather than
    cleared, and the pieces' regions aligned to their elements (rounds 6 to
    15). Rounds 11 to 15 ran a build of a tree that differed from `ac507761`
    only in `rounds-11-15-mask.patch` (the alignment checked by a mask rather
    than a modulo), which the branch then dropped: clang had compiled the
    modulo of a power-of-two select as that mask already, and the two trees
    built the same executable, byte for byte (sha256 `48ac7096…`). Their logs
    are in `logs-head-ac507761` with rounds 6 to 10's.

`manifests/` lists the sha256 of every file of `build.sh`, `src` and `tests`
of each tree; main's is the measured tree, the commit with the patch.

## Host and builds

AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, transparent huge pages `always`, the
snapshots and outputs on btrfs. clang 23.1.1 built each tree
(`BUSTER_DEBUG_INFO=0 ./build.sh`, each under its own hold of the shared
lock), GCC 16.2.1's `libgcc.a` and glibc 2.44. `build/compiler`'s sha256:

| Tree | sha256 |
| --- | --- |
| main with the patch | `057b6befc7c5cff7c10adb95a257911c819ca98d7c62cfc51c49ce9fe96895a4` |
| pre | `dd0199f7307daa8fa3af5f8d1b890bd636bf4653e1d80e583295bdfe1e04fcb3` |
| `77a46178` | `2fe2d938d8547be8017ddd5b65414f660b1515c39e289e1a4f1c0b058772bac0` |
| `ac507761` | `48ac7096c6861bf3c03d96d7efb963f450f2a39d48d1791d833f4d26a7ce9220` |

## Commands

`run490.sh` built main and the first head, then `queue490.sh 1 5` ran
`round490.sh` for rounds 1 to 5, each round under one hold of the shared
lock: pre, main and the head in an order that rotates by round, each running

- `benchmark-link --only direct` (every kind; its default programs of 1, 2,000
  and 102,400 workers; its lane on CPU 2), and main once more with
  `BUSTER_SNAPSHOT_POPULATE=1`;
- `taskset -c 2 benchmark-snapshot --only dynamic` and `--only shared`;
- `XDG_CACHE_HOME=... taskset -c 2 time-runs --runs 41 --warmups 5 --list
  hello.c -o OUT`: the C driver compiling and linking a hello world by the
  direct path, whole processes (every process's status 0).

`run490b.sh` then rebuilt the head as `ac507761` and ran rounds 6 to 10, and
`run490c.sh` rounds 11 to 15. `analyze490.py DIR` reads the logs:
`analysis-rounds-1-5.txt` (the first head) and `analysis-rounds-6-15.txt` (the
final head), each figure the median of the rounds' medians and their range.
`progress-aborted.log` is a first start whose benchmark counted the faults in
the warm-up, where the arena's first touches mixed in; it was stopped before
any round.

The faults by step (`diag/`): `patch_faults.py` wraps the C driver's link
steps (`runtime_open`, the runtime's room, `bind_begin`, `bind_end`,
`dynamic_inputs`, `executable_write`) in marks that print the process's minor
faults so far when `BUSTER_FAULTS` is set. Builds of pre, main and `ac507761`
with it (built on the laptop by clang 23.1.4, `diag/compilers.sha256`)
compiled the hello world on the 9700X through `procbench` (the harness of
#445's and #446's records): a warm-up that writes the snapshot, then five
processes each, their standard errors in `diag-work-*/out`. A first attempt
with `perf record -e page-faults -c 1` kept about 60 of a process's 570
faults: the kernel's sample-rate limit drops the rest.

## Results

Ten rounds, 6 to 15, of the final head (`analysis-rounds-6-15.txt`):

| | pre | main | main, populated | `ac507761` |
| --- | ---: | ---: | ---: | ---: |
| `bind_begin`, 1 worker, PIE | 0.7 µs | 3.8 µs, 4 faults | 0.9 µs, 0 | 0.8 µs, 0 faults |
| `bind_begin`, 2,000 workers, PIE | 2.4 µs | 5.5 µs, 4 | 2.6 µs, 0 | 2.5 µs, 0 |
| `bind_begin`, 1 worker, shared | 0.7 µs | 3.6 µs, 4 | 0.8 µs, 0 | 0.7 µs, 0 |
| `bind_begin`, 1 worker, static | 15.0 µs | 15.3 µs, 21 | 1.8 µs, 0 | 1.0 µs, 0 |
| `bind_begin`, 1 worker, static PIE | 14.8 µs | 15.1 µs, 21 | 1.7 µs, 0 | 0.9 µs, 0 |
| link, 1 worker, PIE | 19.4 µs | 24.1 µs | 51.2 µs | 21.4 µs |
| link, 1 worker, static | 379.1 µs | 377.6 µs | 442.0 µs | 367.7 µs |
| link, 2,000 workers, static | 502.9 µs | 503.2 µs | 566.8 µs | 490.7 µs |
| `runtime_open`, dynamic | 9.88 µs | 11.82 µs | | 11.79 µs |
| `runtime_open`, shared | 9.26 µs | 11.23 µs | | 11.23 µs |
| binding one worker, freshly loaded | 3.09 µs | 7.45 µs | | 4.46 µs |
| dynamic snapshot | 197,828 bytes | 3,283,511 bytes | | 3,282,344 bytes |
| shared library's snapshot | 196,047 bytes | 3,281,602 bytes | | 3,280,832 bytes |
| C driver's hello world | 2.319 ms | 2.354 ms | | 2.352 ms |
| its minor faults | 560 | 573 | | 567 |
| its peak resident set | 31,200 KB | 31,630 KB | | 31,424 KB |

- **The cause.** Main's `bind_begin` took 4 of the mapping's faults in every
  run (each run maps the snapshot afresh), and with the mapping populated
  before it, as fast as before `libgcc.a`: its 3 µs were those faults, a 64 KB
  window of the file each. The crt objects' records were the starts of 24
  columns spread over 260 KB, their atoms' bytes past the 30 KB names run.
- **Static links.** Their `bind_begin` took as long before `libgcc.a`: the
  static runtime's crt objects' records span the columns of 2,618 members. 21
  faults and 15 µs of every static link go.
- **The hello world's link**, by step (`diag/`, five processes each, medians):

  | Step | pre | main | `ac507761` |
  | --- | ---: | ---: | ---: |
  | `runtime_open` | 7 | 8 | 7 |
  | to the runtime's room | 16 | 18 | 16 |
  | the room | 0 | 0 | 1 |
  | to `bind_begin` | 1 | 1 | 1 |
  | `bind_begin` | 7 | 15 | 10 |
  | to `bind_end` | 2 | 2 | 1 |
  | `dynamic_inputs` | 0 | 1 | 1 |
  | `executable_write` | 5 | 5 | 5 |
  | the link | 38 | 50 | 42 |

  The four faults over pre come with the larger runtime: the closure's scratch
  (`bind_capacity_needed`'s arrays by member), the global names' table that
  `bind_begin` clears (3,387 entries against 2,685) and `dynamic_inputs`'
  arrays. The rest of the process varies with each build's code: before
  `runtime_open`, the same front end faulted 526 to 530 times in pre's and
  main's diagnostic builds and 532 to 534 in the head's.
- **`runtime_open`** is no slower: 11.79 µs (11.55 to 11.83 by round) against
  main's 11.82 (11.51 to 11.92). Main's own rounds moved by 0.3 µs between
  rounds 6 to 10 (11.53) and 11 to 15 (11.84), which the first reading of
  rounds 6 to 10 took for a regression of the head's.

## Limitations

- `benchmark-link`'s page faults by part come from main's patch and the
  branch; pre's benchmark counts none, so pre's figures are its times.
- The diagnostic builds are other executables than the measured ones: their
  totals differ from `time-runs`', and only the differences by step compare.
- The lock's messages ("exclusive.sh: waiting" and their title, link and pull
  request lines, which name other sessions) were removed from the logs;
  nothing else was changed.
