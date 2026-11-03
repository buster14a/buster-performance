# Tier 1's last refusals in selection and emission (buster#141), 2026-11-03

Evidence for [buster#1245](https://github.com/buster14a/buster/pull/1245). It makes Tier 1 take three things its own
selection and emission still refused after buster#1204:

- thread-locals' addresses (local-exec and initial-exec, as Tier 0's);
- calls of two or more 64-byte vector arguments, whose parts now wait in zmm16 and on;
- addresses whose constant index doesn't fit a disp32.

It covers:

- #142's campaign at buster#1245's tree, by both of Tier 1's paths (`container/`);
- the tree against its main on the 9700X: `--tier1 -c` of the frozen `sqlite3.c` by `perf stat` and `ab`, whether
  the two trees write the same `sqlite3.o`, and `--tier1` of the compiler's own `main.c` (`9700x/`).

The test-suite results are in buster#1245's description, not here.

## Revisions

| Tree | Revision | What it is |
| --- | --- | --- |
| `main-94d253b4` | `94d253b4` | main at buster#1245's merge of main (buster#1199's merge) |
| `head-f3de5433` | `f3de5433` | buster#1245's head: its four commits (`f5a6545b`, `11c58586`, `2c78f5ca`, `16fef10c`) with main `94d253b4` merged |

Both trees are `git archive`s of those commits. buster#1245's commits were also rebased onto `94d253b4` once (`ef936ec3`,
never pushed). Its tree is byte-identical to `f3de5433`'s, and the cloud container's builds below are of it.

## #142's campaign at the head (`container/`)

Run in the cloud container, not on the 9700X, since the campaign checks correctness, not time:

- **CPU:** an Intel Xeon with AVX-512 (Granite Rapids' features), 4 CPUs.
- **Toolchain:** Ubuntu clang 23.1.5. The 9700X's campaigns used its clang 23.1.1.
- **Generators:** Csmith `0cdc710` and YARPGen `1adb290`, built in the container from those commits (CMake, Release).
- **The compiler:** buster's `./build.sh` (Release, `-march=native`) of `ef936ec3`'s tree, `f3de5433`'s.
- **Method:** the same as the 9700X record of buster#1204
  ([`tier1-remaining-refusals-141-2026-11-03`](https://github.com/buster14a/buster-performance/pull/235)). Seeds 3400
  to 3439 of both generators, two seeds a chunk, 80 programs, by Tier 0 and `--tier1`, and again with `--tier1
  --scalar`, against clang -O0 and -O2, 30 s a run.
- **Files:** `run.sh` runs a pass and `tally.py` writes its `campaign.tsv`, one line per program: status, failure
  signature, then each step's status and exit code. `campaign-vector/` and `campaign-scalar/` have each pass's table,
  the harness's own `chunk-*.log` and `progress.log`. Paths under the container's scratch directory read `$SCRATCH`.
  Generated programs and executables are left out.

| Pass | Passed | Failed in clang's steps | Failed in Buster's |
| --- | ---: | ---: | ---: |
| `--tier1` (`campaign-vector/`) | 60 | 20 | 0 |
| `--tier1 --scalar` (`campaign-scalar/`) | 60 | 20 | 0 |

- The two passes' 80 lines are identical, status and every step.
- Each pass's 80 lines equal the 9700X campaign's at buster#1204's head `c5f4863a`, by the same path, status and every
  step: `diff-head-c5f4863a/campaign.tsv` and `diff-scalar-head-c5f4863a/campaign.tsv` in that record.
- The 20 failures are clang -O0's own:
  - 14 compiles that fail (`sig=clang-o0-compile:exit`). Thirteen are YARPGen's arrays past the small code model,
    which Buster refuses at both tiers too. The fourteenth, `yarpgen-3437`, Buster compiles and runs at both tiers,
    and both print the same bytes (SHA-256 `b16e66ad…`), as on the 9700X;
  - 2 compiles past clang's output limit, which Buster compiles and runs at both tiers (`sig=clang-o0-compile:output-limit`);
  - 4 runs past 30 s (`sig=clang-o0-run:timeout`), where Buster's runs pass 30 s too.

## The head against its main on the 9700X (`9700x/`)

Everything here ran on the Ryzen 7 9700X (benchpress), reached over the tailnet from the cloud session: Linux
6.18.50-2-lts, clang 23.1.1, perf 7.2.9. Each build and each measurement held `~/buster-fast-bench/exclusive.sh` once
(owner `claude-141-1245`), and every timed process was pinned to CPU 2. Lock-wait lines are removed from the logs.

- `queue.sh` runs it all, in order:
  - builds both trees, `BUSTER_DEBUG_INFO=0 ./build.sh` (`build.sh`, `logs-build/`);
  - runs `perf stat` of `--tier1 -c` of the frozen `sqlite3.c` (`bisect.sh`, `bisect/`): 11 runs a hold, 3 rounds in a
    rotating order, and a `perf record` of each tree;
  - compares the two `sqlite3.o` byte for byte (`bisect/cmp.txt`);
  - runs `ab`, 5 rounds of 21 runs (`ab/`);
  - compiles the tree's own `src/buster/compiler/main.c` by `--tier1 --tier1-report --tier1-refusals -march=native`
    (`selfhost/`).
- `common.sh` has the paths, the options and the lock's metadata.
- The input is the record of buster#1204's: the frozen `sqlite3.c` 3.53.2, SHA-256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with
  `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`. It has no
  thread-local, 64-byte vector argument or address past a disp32.

| Measurement | main `94d253b4` | head `f3de5433` | Change |
| --- | ---: | ---: | ---: |
| Instructions (`perf stat`, mean of 3 holds) | 5,874.446 M | 5,874.160 M | −286,478 (−0.005%) |
| Cycles (`perf stat`) | 2,410.80 M | 2,399.45 M | −0.47% |
| Wall time (`ab`, median of the rounds' medians) | 452.48 ms | 450.45 ms | −0.45% |
| `sqlite3.o` | | | identical |

- The two trees write the same `sqlite3.o`, so the head changes nothing in code without what it adds.
- The instructions differ by 0.005%: clang's choices around the changed functions.
- The cycles and wall time differ by about 0.5%. Every round has the head faster: medians of 450.33 to 450.96 ms
  against 452.33 to 452.68 ms. With the same output and 0.005% fewer instructions, that is in the code placement swing
  this repository's records see between builds (buster#509).

The compiler's own `main.c` by `--tier1 -march=native` (`selfhost/`), its 1,108 functions on this host:

| Tree | By Tier 1 | Stopped at the lowering to the IR | At selection | At emission | Naked |
| --- | ---: | ---: | ---: | ---: | ---: |
| main `94d253b4` | 931 | 115 | 10 | 51 | 1 |
| head `f3de5433` | 992 | 115 | 0 | 0 | 1 |

- At main, the 51 emission refusals are thread-locals: the arenas' and the oracle cache's functions among them.
- The 10 selection refusals are 9 calls of two 64-byte vectors and one address past a disp32 (`lane_test_arenas`).
- The head takes all 61. The 115 that stop at the lowering to the IR are vectors and x86 builtins it doesn't
  represent (buster's `docs/tier1.md`).

## Limitations

- The campaign ran in the cloud container with its clang, so its clang steps are a different clang's than the 9700X
  campaigns'. Its result is a correctness result: every step's status equals the 9700X's.
- Cycles and wall time swing by about 0.5% to 1% between builds that differ in code placement alone; instruction counts
  are deterministic to a few hundred.
