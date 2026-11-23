# Bit-field units for unions, ms_struct, wide runs and initializers (#1372, PR #3343), 2026-11-23

The evidence for [buster#3343](https://github.com/buster14a/buster/pull/3343), part of
[buster#1372](https://github.com/buster14a/buster/issues/1372). By Claude, in a session David directed
([the session](https://claude.ai/code/session_01NNmNQwPVuXHtmf7wX4vmiZ)), which took the PR over from
[its first session](https://claude.ai/code/session_01EgbxnhFp2T8LR3cM36jQJj).

#2682 (`bit-field-units-1372-2026-11-13`) made ordinary struct bit-fields load and store clang's access unit.
#3343 does the same for the paths it left narrow:

- a union's bit-fields;
- `ms_struct` records' discrete units;
- packed runs of 9 to 16 bytes;
- a local's initializer.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| base | `1b9821afe448258d08f47f6110922478aa0e4121` | buster's main, the PR's merge parent |
| head | `261a2220c34a9a15661b32a493036b58c5537c41` | the PR's head: main merged in and a test fixture added |

Each was fetched at its commit and built on the 9700X by `./build.sh --config Release`, with the 9700X's staged Clang
23.1.4 (`9700x/out/build-*.log`, `scripts/setup.sh`). Each build had its own hold of the lock.

## Kernels

The kernels are `scripts/m/kernels.c`, with their records in `scripts/m/kernels.h`. The first session wrote them, and
this record reuses them unchanged.

| # | Kernel | What it does |
| --- | --- | --- |
| 0 | `k_bits` | The issue's kernel, on `struct B { unsigned x:3, y:7, z:13, w:9; }`. #2682 already gave it clang's units, so it is the control. |
| 1 | `k_init` | A local `struct B` from an initializer, then a copy of it through a pointer. |
| 2 | `k_union` | `union { unsigned x:3; unsigned y:17; unsigned long long z:40; }`. |
| 3 | `k_ms` | An `ms_struct` record: `unsigned x:3, y:7; unsigned short z:5; unsigned char w:4`. |
| 4 | `k_wide` | A packed `{ unsigned a:30, b:30, c:30; }`, whose unit is 12 bytes (an `i96`). |

`scripts/m/driver.c` makes N calls of one kernel. Before each call it stores to one of the record's fields. clang -O2
compiles the driver the same way for every variant.

There are eight variants: base's and head's Tier 0 (`-c`), Tier 1 (`--tier1`) and Tier 1 with value numbering over
memory (`--tier1 --tier1-passes=+memory`, #2718), then clang -O0 and clang -O2. clang here is the host's 23.1.1
(`9700x/out/clang.txt`).

Every variant gives the same result for each kernel (`9700x/run.log`; `scripts/make.sh` checks it).

## Method

- `scripts/run.sh` runs `make.sh`, then three rounds (`round.sh`), then two compile-time runs (`compile.sh`). Each run
  is its own hold of the lock.
- In each round, every kernel's eight variants run under `perf stat -r 5` on CPU 2, in user mode, with 50,000,000 calls.
  The order of the variants rotates from round to round.
- The events are:
  - `cycles:u`;
  - `instructions:u`;
  - `ls_bad_status2.stli_other:u`, the store-to-load forwarding conflicts;
  - `ls_stlf:u`, the forwards.
- Below, each figure is the median of the three rounds' 5-run means.
- `9700x/out/busy-*.txt` has the load and the busiest processes before and after each hold.

## Results: cycles (millions, for 50 M calls)

| Kernel | base T0 | head T0 | base T1 | head T1 | base T1+mem | head T1+mem | clang -O0 | clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 issue | 776.9 | 776.9 | 771.5 | 772.6 | 796.4 | 796.4 | 720.5 | 354.4 |
| 1 init | 3,600.7 | 550.5 | 3,250.7 | 327.1 | 3,251.0 | 324.2 | 434.0 | 217.1 |
| 2 union | 2,658.8 | 1,700.6 | 2,600.6 | 1,650.5 | 2,600.6 | 1,650.5 | 1,394.3 | 1,500.5 |
| 3 ms_struct | 1,503.5 | 774.3 | 1,451.3 | 623.4 | 1,450.7 | 600.5 | 513.1 | 500.5 |
| 4 wide (i96) | 2,713.2 | 865.8 | 2,650.6 | 869.8 | 2,650.9 | 866.7 | 663.7 | 400.5 |

## Store-to-load forwarding conflicts (millions, for 50 M calls)

| Kernel | base T0 | head T0 | base T1 | head T1 | base T1+mem | head T1+mem | clang -O0 | clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 issue | 0.001 | 0.001 | 0.001 | 0.001 | 0.001 | 0.001 | 0.002 | 0.001 |
| 1 init | 220.0 | 0.002 | 350.2 | 0.001 | 350.0 | 0.001 | 0.002 | 0.001 |
| 2 union | 211.7 | 100.0 | 200.0 | 100.0 | 150.0 | 50.0 | 144.4 | 50.0 |
| 3 ms_struct | 100.0 | 0.001 | 100.0 | 0.001 | 100.0 | 0.001 | 0.96 | 0.001 |
| 4 wide (i96) | 301.8 | 0.47 | 250.0 | 0.001 | 200.0 | 0.001 | 0.002 | 0.001 |

Instructions are in `9700x/out/perf-*.csv`. Head runs fewer instructions than base for the union and the wide run, at
every tier. The other kernels change by at most 8%. The largest rise is the initializer at Tier 1: 2,100 M against
2,050 M.

## Reading

- **Initializers, `ms_struct` records and wide runs.** At both tiers, head removes nearly all of base's forwarding
  conflicts, which were two to seven per call. That cuts these kernels' cycles by 1.9× to 9.9×.
  - With the conflicts gone, head's Tier 1 is faster than clang -O0 for the initializer: 327 M against 434 M cycles.
  - It is still slower for the `ms_struct` record (623 M against 513 M) and the wide run (870 M against 664 M).
- **Unions.** Conflicts halve, from 4 to 2 per call, and cycles fall 35% to 37%.
  - Some conflicts remain, as in clang's own code: clang -O0 has 2.9 per call, and clang -O2 has 1.
  - The fields' units differ in width (1, 4 and 8 bytes at 0), as clang's do. A store of one field followed by a
    wider read of another can't be forwarded.
- **Control.** The issue's kernel is unchanged, as expected.

## Compile time

`time-runs` measured `-c` and `--tier1 -c` of the frozen corpus's `sqlite3.c`
(`buster-fast-bench/2543-claude/corpus`, checksums in `9700x/out/corpus.sha256`). Each had 21 runs after 2 warm-ups,
on CPU 2, with base and head interleaved (`9700x/out/time-sqlite-*.txt`).

| Command | base median | head median | head vs base |
| --- | ---: | ---: | ---: |
| `-c`, wall | 112.770 ms | 113.162 ms | +0.35% |
| `-c`, user cycles | 548.2 M | 550.2 M | +0.37% |
| `-c`, instructions | 1,248.37 M | 1,249.24 M | +0.07% |
| `--tier1 -c`, wall | 601.125 ms | 601.616 ms | +0.08% |
| `--tier1 -c`, user cycles | 3,233.9 M | 3,235.6 M | +0.05% |
| `--tier1 -c`, instructions | 7,985.24 M | 7,986.12 M | +0.01% |

The wall-time differences are within the runs' spread: 112.07 to 113.63 ms for base and 112.20 to 124.22 ms for head
at Tier 0. The extra instructions, 0.9 M per compile, are the initializer walk and the union and `ms_struct` cases in
the unit column.

## Files

- `scripts/`: what ran on the 9700X, and the kernels and driver (`m/`).
- `9700x/run.log`, `9700x/setup.log`: the runs' output, the lock's waits among it.
- `9700x/out/perf-K-VARIANT-ROUND.csv`, `result-*.txt`: perf stat's output and each executable's result.
- `9700x/out/k-*.s`: each variant's kernels, disassembled.
- `9700x/out/identities.sha256`: the two compilers and the kernel objects. `base.sha` and `head.sha` give the
  commits.
- `9700x/out/build-*.log`: the two builds.
