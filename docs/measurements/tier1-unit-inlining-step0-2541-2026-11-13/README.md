# #2541 step 0: always_inline callees with control flow, on the 9700X (2026-11-13)

The 9700X measurement of step 0 of
[#2541's design](https://github.com/buster14a/buster/blob/main/docs/tier1-unit-inlining.md): the inliner's general
splice (`IrInlineOptions.control_flow`), offered by `--tier1` to the unit's always_inline functions of internal
linkage, in [buster14a/buster#2613](https://github.com/buster14a/buster/pull/2613).

- **main:** `df85213e8f52e71f9b24a402891bdd37b1df500b` (`9700x/main.commit`).
- **head:** `081ee91e18464b4f9fe47ff1f5551cd8008e59e2` (`9700x/head.commit`), the PR's first commit; the PR's later
  commits change documentation and tests only.
- **Host:** AMD Ryzen 7 9700X, Linux 6.18.50, CPU 2 (governor and EPP `performance`), clang 23.1.1, perf 7.2.9
  (`9700x/host.txt`, with the inputs' and the Release compilers' SHA-256). Every build and run held the machine's
  lock, one hold per command (`scripts/lock.sh`, `scripts/queue.sh`, `9700x/q*.txt` and their logs).

The scripts are #138's record's (`tier1-quality-138-2026-11-12/9700x`'s `selfhost-*.sh`, `programs.sh`,
`exp-programs.sh`, `exp-runs.sh`), adapted to two trees; the inputs are that record's (speedtest1.c and Lua 5.4.8 by
their SHA-256 there) and the host's frozen `sqlite3.c`. The two Release compilers were built on the host from clean
clones (`scripts/clone.sh`, `scripts/build.sh`, `9700x/results/build-*.log`).

## The compiler built by `--tier1`

As #138's record: the compiler's 43 units at the scalar host (`BUSTER_HOST_ARCH=x86-64`, `results/selfhost/*-flags.txt`)
compiled by each tree's `--tier1` (and by head's `--tier1 --tier1-no-inline` and clang -O2), linked by clang
(`scripts/selfhost-build.sh`). The self-built compilers then compile the frozen `sqlite3.c` with the 9700X job's options,
one lane, pinned to CPU 2.

**Objects** (`results/selfhost/runs-checks.txt`): the default tier's object is the same bytes by all four builds; the
`--tier1` workload's is the same by head's three builds (clang -O2's, `--tier1`'s and `--tier1-no-inline`'s), so head's
self-built compilers reproduce clang's build. Main's `--tier1` object differs from head's by design (below,
`allocateSpace`); `runs-checks-first.txt` is the first attempt, whose check wrongly required that too, so it timed nothing.

**Counters** (`results/selfhost/perf-*-stat.csv`, three runs each, the default tier's compile):

| The compiler built by | user cycles, M | instructions, M | returns (`ex_ret_near_ret`), M | branches, M |
| --- | ---: | ---: | ---: | ---: |
| main's `--tier1` | 8,272.9 | 29,343.8 | 345.0 | 4,443.8 |
| head's `--tier1` | 8,170.0 | 30,206.6 | **283.8** | 4,306.7 |
| head's `--tier1 --tier1-no-inline` | 8,556.0 | 31,410.2 | 521.7 | 4,803.3 |
| clang -O2 | 3,054.5 | 10,740.5 | 21.7 | 1,686.8 |

**Timing** (`results/selfhost/runs.tsv`, one warm-up and five rounds, the builds' order rotated, medians;
`scripts/summarize.py`):

| Workload | main's `--tier1` | head's `--tier1` | head's `--tier1-no-inline` | clang -O2 |
| --- | ---: | ---: | ---: | ---: |
| `-c sqlite3.c`, user cycles, M | 8,254.4 | 8,166.8 (-1.1%) | 8,521.8 | 3,053.8 |
| `--tier1 -c sqlite3.c`, user cycles, M | 11,957.3 | 11,916.1 (-0.3%) | 12,232.4 | 4,993.9 |

**The build** (`results/selfhost/*-report.txt`, `*-units.tsv`): head's `--tier1` expands 4,097 calls in the
compiler's units where main's expands 795, with no internal or resource failure and the same 17 fallbacks; its records
grow 6.6% (6,412,985 to 6,834,649) and its units' user time 3.0% (25.30 s to 26.05 s, 8 at a time).

**Where the returns are** (`results/selfhost/callers-*`, `perf record -j any_call,u`, and `perf-*-symbols.txt`):
`host_aesenc` and `intern_lane_rounds`, which took 26% of main's build's cycles as calls, are expanded into
`intern_hash_bytes_scalar`. What stays is mostly calls through one PLT entry into libc (`0x18f404` in `libc.so.6`):
42.5% of head's sampled call records are `intern_hash_bytes_scalar`'s calls of it, `host_aesenc`'s 16-byte `memcpy`s of
its by-value `__m128i`s (#1373: a small constant `memcpy` is a call). libc's share of the cycles grows from 3.8% to
14.7%: at this target (no AVX-512) the inliner copies a by-value vector by two 8-byte integer stores, which a 16-byte
load in `memcpy` cannot forward from (#1344's pattern), where main's callee received it in a register and stored it
whole. So the 215 M returns of the design's gate are not reached by the splice alone; the rest is #1373's.

## speedtest1 and Lua

`results/objects.txt` (`scripts/objects.sh`): every Lua 5.4.8 unit and `speedtest1.c` compile by `--tier1` to the same
bytes by main and head. `sqlite3.c` differs: it has one always_inline function, `allocateSpace` (`SQLITE_INLINE`), with
control flow, whose two calls head expands (`results/place/*-speedtest1-report.txt`: `inlined=0` by main, `inlined=2`
by head) and main keeps. (The script's own `inlined=` column reads `?`: the host has no `bc`.)

`results/programs-*/measure-tier1-programs.log`: `measure-tier1-programs --runs 5` by each tree, every program's output
checked: Lua's five scripts are within 0.2% (the same objects); speedtest1 by `--tier1` reads 880.0 M and 889.0 M user
cycles, one code placement each. Over eight placements (`scripts/place-build.sh`, `place-runs.sh`: one speedtest1 object,
linked after 0 to 3,696 bytes of padding; every executable's verification hash checked; one warm-up and five rounds):

| Placement | main, M cycles | head, M cycles | 100 ln(head/main) |
| ---: | ---: | ---: | ---: |
| 0 | 882.0 | 886.4 | +0.50 |
| 528 | 886.2 | 891.1 | +0.55 |
| 1,056 | 890.2 | 885.6 | -0.52 |
| 1,584 | 884.5 | 880.4 | -0.46 |
| 2,112 | 881.5 | 881.1 | -0.05 |
| 2,640 | 885.9 | 887.8 | +0.21 |
| 3,168 | 882.1 | 880.3 | -0.21 |
| 3,696 | 884.5 | 894.9 | +1.17 |

Mean +0.15, 95% interval -0.33 to +0.63; head faster at 4 of 8; instructions 2,960.2 M and 2,958.8 M; `.text` 1,024,469
and 1,025,781 bytes. No change measurable.

## Limitations

- One build of each tree; the self-built compilers' timing is one code layout each (the default workload's -1.1% is
  over five rounds of one layout).
- The callers' split is from sampled branch records, not exact counts.
- Lock messages naming other holders were removed from the two build logs (their `exclusive.sh: waiting` blocks); no
  other file had any.
