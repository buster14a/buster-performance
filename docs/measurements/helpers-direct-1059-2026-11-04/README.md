# Direct forms against their helpers — #1059, 2026-11-04

Source: [buster#1264](https://github.com/buster14a/buster/pull/1264), for
[buster#1059](https://github.com/buster14a/buster/issues/1059) (step 6 of its
plan: the paired measurements).

#1059 replaced helper calls with the machine operations they stand for:
- fences, atomic loads and stores, exchanges, `lock xadd`, compare-exchanges and
  fetch loops in the typed stream (buster#1188, #1244, #1246, #1247, #1248);
- inline asm placed in its caller as a Tier 0 row (buster#1264).

This record compares each of those direct forms against its helper, from the
same compiler. `--helper-forms=all` gives every operation that has a direct
form its helper's call, which is the code the compiler made before #1059.

## Run

- [Workflow run 41764205497](https://github.com/buster14a/buster/actions/runs/41764205497),
  job `126361937369` ("Native tests and benchmarks on Benchpress (Ryzen 7
  9700X)"), runner `buster-zen5-9700x` on `benchpress`, under the shared host
  lock, 2026-11-04 03:13:45 to 03:14:29 UTC.
- Tested commit `4ad352b777d2`: buster#1264's head `2f8c70b9` merged into main
  `2fef25b0`.
  - `2f8c70b9` ports buster#1266, the code certificate's `rax` fix, which was
    not merged on main at the time.
- Build: `./build.sh --config Release` with `BUSTER_HOST_ARCH=znver5` and
  `BUSTER_DEBUG_INFO=0`, by clang 23.1.4 (`7a941dfb2877`).
- Command, pinned to the job's first allowed CPU:

  ```sh
  taskset -c "$cpu" ./build/compiler measure-helpers --runs 11 --compiles 5 \
      --sqlite "$sqlite" --speedtest "$inputs" --directory /tmp
  ```

- Inputs (external runtime inputs, not incorporated here):
  - SQLite's amalgamation `sqlite3.c`, sha256
    `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d` (the
    9700X's frozen corpus `preprocessor-391e729af658`);
  - SQLite 3.53.2's `test/speedtest1.c` at `ccc132c5be20`, sha256
    `b5eaf4bbcbb320fd8eb3f3e6c4cd5f51a64dd0cd70efe969634d1785e3419675`.
  - The primitives' source is embedded in the harness,
    [`src/buster/compiler/helpers_measure.c`](https://github.com/buster14a/buster/blob/2f8c70b917bbb30e2ac157f763abc3e351b6355a/src/buster/compiler/helpers_measure.c)
    at `2f8c70b9`, whose header documents the method.

Files:
- `9700x/measure-helpers.log`: the step's lines of the job log, raw.
- `9700x/measure-helpers.tsv`: its `helpers-measure-compile` and
  `helpers-measure-run` lines without their timestamps (one per compile and per
  run: phase, round, position, source or program, build, wall ns, user cycles,
  instructions, status, counted).

## Method

Each program is built four ways, all with `-fno-asynchronous-unwind-tables`:
- by Tier 0, as it lowers it;
- by Tier 0 with `--helper-forms=all`;
- by `--tier1`, as it lowers it;
- by `--tier1` with `--helper-forms=all`.

Under `--tier1` an asm statement keeps its helper either way, because the IR
has no operation for a placed row.

The programs:
- **The primitives:** single-threaded kernels of 5,000,000 iterations each,
  run one per process:
  - `counts`: reference counts' increments and decrements (`lock xadd`);
  - `lock`: an uncontended spin lock (an acquire exchange, `pause`, a release
    store);
  - `sequence`: a sequence lock's writer and reader (relaxed, acquire and
    release accesses; release and acquire fences);
  - `flags`: `fetch_or`, `fetch_and` and `xor_fetch` (compare-exchange loops);
  - `maximum`: a running maximum by a weak compare-exchange;
  - `swaps`: inline asm's `bswap`, `roll` and `leaq`.
- **speedtest1:** one translation unit with `sqlite3.c`, as
  `measure-tier1-programs` builds and runs it, with a fresh database for each
  run. Its direct forms are SQLite's 38 relaxed `AtomicLoad` and `AtomicStore`s.

Every build's output matched the first's: the primitives' checksums, and
speedtest1's `--verify` hash `1248168 a7fa3957840af6d6...`.

Then the harness ran:
- 1 warm-up round and 5 measured rounds of each (source, build) pair's `-c`
  compile;
- 1 warm-up round and 11 measured rounds of each (program, build) pair's run.

Each round runs in an order that rotates by round. Each compile and run is a
whole process, measured for wall time, user cycles and user instructions. All
of them exited 0 and were counted.

## Objects

`--helper-report`'s direct forms and helper calls; the `.text` bytes;
`--tier1-report`'s spill and call stores and loads:

| Source | Build | Direct | Helper calls | Text bytes | Spill stores, loads | Call stores, loads |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| primitives | Tier 0 | 28 | 0 | 2,275 | | |
| primitives | Tier 0, helpers | 0 | 25 | 2,947 | | |
| primitives | `--tier1` | 24 | 4 (asm) | 1,875 | 5, 8 | 5, 5 |
| primitives | `--tier1`, helpers | 0 | 25 | 2,579 | 2, 2 | 27, 27 |
| speedtest1 | Tier 0 | 38 | 0 | 1,318,069 | | |
| speedtest1 | Tier 0, helpers | 0 | 38 | 1,318,756 | | |
| speedtest1 | `--tier1` | 38 | 0 | 1,415,994 | 15,546, 18,732 | 28,400, 28,400 |
| speedtest1 | `--tier1`, helpers | 0 | 38 | 1,418,340 | 15,560, 18,748 | 28,447, 28,447 |

The primitives' 28 direct forms by family, as direct/helper:

| Family | Tier 0 | Tier 0, helpers | `--tier1` | `--tier1`, helpers |
| --- | --- | --- | --- | --- |
| atomic-access | 13/0 | 0/10 | 13/0 | 0/10 |
| atomic-rmw | 9/0 | 0/9 | 9/0 | 0/9 |
| fence | 2/0 | 0/2 | 2/0 | 0/2 |
| asm | 4/0 | 0/4 | 0/4 | 0/4 |

The direct builds count 3 more accesses than the helpers builds. Each of
`flags`' fetch loops counts as two direct forms (its relaxed load of the old
value, then its compare-exchange), where its helper is one call.

## Runs

Medians of 11. The ratio is the helpers build's time over the direct build's.

| Program | Tier 0, ms | Tier 0, helpers, ms | Ratio | `--tier1`, ms | `--tier1`, helpers, ms | Ratio |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `sequence` | 9.154 | 428.119 | 46.8 | 4.241 | 430.934 | 101.6 |
| `lock` | 23.582 | 102.995 | 4.37 | 19.982 | 96.674 | 4.84 |
| `swaps` | 4.194 | 12.841 | 3.06 | 11.900 | 11.927 | 1.00 |
| `counts` | 73.281 | 82.248 | 1.12 | 72.294 | 81.312 | 1.12 |
| `maximum` | 6.470 | 6.909 | 1.07 | 4.121 | 6.790 | 1.65 |
| `flags` | 63.274 | 65.054 | 1.03 | 58.745 | 61.473 | 1.05 |
| speedtest1 | 255.325 | 255.529 | 1.00 | 203.518 | 206.860 | 1.02 |

User cycles give the same ratios as the wall times, to within 3% of the
ratio in every row. For example, speedtest1 by `--tier1` takes 1,035.8 M cycles
direct and 1,052.8 M with the helpers, and `flags` by Tier 0 takes 350.2 M and
360.2 M.

Instructions, M, direct / helpers:

| Program | Tier 0 | `--tier1` |
| --- | --- | --- |
| `sequence` | 355.1 / 620.1 | 170.1 / 625.1 |
| `lock` | 230.1 / 310.1 | 150.1 / 240.1 |
| `swaps` | 180.1 / 425.1 | 375.1 / 375.1 |
| `counts` | 315.1 / 485.1 | 200.1 / 415.1 |
| `maximum` | 246.2 / 271.3 | 155.9 / 196.3 |
| `flags` | 510.1 / 465.1 | 365.1 / 390.1 |
| speedtest1 | 5,685.6 / 5,694.0 | 3,795.7 / 3,812.2 |

Every direct form is faster than its helper, by both tiers. The ranges of 11
runs don't overlap in any row except two: speedtest1 by Tier 0 (254.406 to
256.021 ms direct, 254.857 to 256.976 with the helpers), and `swaps` by
`--tier1`, which runs the same code either way.

**Why the helpers cost so much.** A helper strengthens every order to
`seq_cst`, so the runs measure that as well as the call:
- `sequence`: a release or acquire fence is no instruction, but its helper is
  an `mfence`. A release store is a `mov`, but its helper is an `xchg`.
- `lock`: the release store is a `mov`, but its helper is an `xchg`.

**The compare-exchange loops.** `flags` gains least:
- Each of its iterations is a `lock cmpxchg` either way, whose latency bounds
  the loop.
- Tier 0's direct loop runs more instructions than the helper's tight leaf (510
  M against 465 M), because it keeps the operand and the old value in its frame.
  It is still 3% faster in cycles.
- `--tier1` runs fewer instructions, and its direct loop is 5% faster.

**The asm statements** (`swaps`) are placed only by Tier 0. Under `--tier1`
both builds call the helpers, as the 1.00 ratio confirms.

**speedtest1.** Its direct forms are 38 relaxed loads and stores, the VDBE
loop's interrupt test among them. By `--tier1` they take 1.6% off its run, in
time and in cycles, and they take 2,346 bytes off its text. They also save 47
of Tier 1's call stores and loads, and 14 spill stores and 16 spill loads. Tier
0's run is unchanged.

## Compiles

Medians of 5, ms:

| Source | Tier 0 | Tier 0, helpers | `--tier1` | `--tier1`, helpers |
| --- | ---: | ---: | ---: | ---: |
| speedtest1 | 112.4 | 113.7 | 464.7 | 464.8 |
| primitives | 2.2 | 1.6 | 2.2 | 2.2 |

**speedtest1.** The direct build's compile takes the same time as the helpers'
by Tier 1, and about 1% less by Tier 0. Its instructions are 1,261.6 M against
1,261.8 M by Tier 0, and 6,045.6 M against 6,047.1 M by `--tier1`. Every round
gives the same sign.

**The primitives.** At 2 ms the whole process is mostly startup, and the Tier
0 rows show an effect of order, not of cost:
- The rotation keeps each helpers build right after its direct build.
- In the four rounds where `tier0-helpers` follows `tier0`, it takes about 4.5
  M user cycles to `tier0`'s 5.7 M.
- In round 2, where `tier0-helpers` comes first, it takes 5.7 M, as `tier0`
  does.
- Their instructions are equal: 7.49 M direct, 7.54 M with the helpers.

## Limitations

- These are single-threaded, uncontended kernels. They measure the cost of the
  instruction sequences and the calls, not of contention between cores.
- They are one job's runs on one CPU of one host.
- speedtest1's direct forms are only its relaxed accesses. It reaches no
  fence, read/modify/write or asm statement through its direct forms.
- `--tier1` places no asm statement, so `swaps` measures placement by Tier 0
  only.
- The primitives' compile times show the rotation's order (see "Compiles").
