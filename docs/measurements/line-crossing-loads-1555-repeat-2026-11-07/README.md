# Line-crossing loads in the refine pass and the lexer, again: each run under its own lock (buster#1555)

The repeat that [buster#1555](https://github.com/buster14a/buster/issues/1555) and the review of
[the first record](../line-crossing-loads-1555-2026-11-06/README.md) asked for.

The first record held the 9700X's lock around whole series of runs, and kept neither perf's event-running
percentages nor each process's exit status. Here:

- **The lock:** every build, test, compile, benchmark, `perf stat`, `perf record` and `perf report` is one run of `scripts/one.sh`, which takes the host's lock (`exclusive.sh`) for that run alone. `ab` takes it itself for each `time-runs` process, as `docs/profiling.md` prescribes.
- **Each run's receipts,** in `runs/NAME/`:
  - its command and directory;
  - when the lock was requested, taken and given back;
  - whether it waited;
  - its exit status, standard output and standard error;
  - for perf, its whole CSV output with the running percentages, or its `perf.data`.
- **Holder details omitted:** `exclusive.sh`'s message naming the holder, when a run waited, isn't kept. What `one.sh` first left of multi-line holder entries, in `lock-other-messages` files, was removed before publication, as were four such blocks in `runs/placements/ab.log`, each replaced by a marker.

## Sources and identities (`runs/identities`, `runs/executables`, `runs/shifted-executables`)

- **The trees:** clean clones under `~/buster-fast-bench/1555-claude-r2/trees/`. `git status --porcelain` was empty in each before and after its build. The commits:

  | Tree | Commit |
  | --- | --- |
  | main | buster `7d403fcab4d6d9d8061cd781bed86bbe3ac6e650` |
  | lexer | `6d66d0ea2a721f33d2853c37b425434caca92f42`: main with the candidate, one `vpermt2b` of `raw[j]` and `raw[j + 1]` for the next characters (`scripts/patches/m1555-lexer.patch`) |
  | refine | `79f38d86042b14b998489cc6ef663d761d5dde8b`: main with stage 1's masked-load path for every batch (`m1555-refine.patch`) |
  | bench | `8de05b462a529db8b185911e7763b28cc716ae3d`: main with `benchmark-lexer` printing each implementation's per-pass cycles, and the candidate's `c_lexer.c` as the variant `k1` (`m1555-bench.patch`) |

- **Where the commits live:** none is pushed to buster. They reached the host as a git bundle, sha256 `4990579d…`.
- **The executables** (`BUSTER_HOST_ARCH=znver5 ./build.sh`, sha256):
  - main `0a9ab739…`;
  - lexer `f89476e8…`;
  - refine `f78bd864…`;
  - bench (`./build.sh lexer-variant control=…/c_lexer.c k1=…/c_lexer_k1_1555.c`) `34f6896d…`.

  The placement builds (`BUSTER_DEBUG_INFO=0 ./build.sh shifts DIR main_unit_frontend.c 0 704 1408 2048 2752 3456`) are listed with their hashes.
- **The host:** AMD Ryzen 7 9700X, kernel 6.18.50-2-lts, perf 7.2.9, clang 23.1.1. Every timed process ran on CPU 2.
- **The input:** the frozen `sqlite3.c` (sha256 `0a409f16…`) with `tools/microarch/workloads.sh`'s command lines and the pinned predefines (`a39036d8…`), `SOURCE_DATE_EPOCH=1792454400`.

## How the campaign ran

- **The first campaign** (`scripts/campaign.sh`) ran its first 20 runs: the builds, the tests, the outputs and two probes.
  - CI jobs then held the lock for long stretches, with up to 14 runs waiting. At that pace its ~160 runs would have taken about a day.
  - It was stopped while its next run was still waiting for the lock: no run was cut short, and that run's directory was removed.
- **`scripts/campaign2.sh`** kept the completed runs and trimmed the rest:
  - the probes once each;
  - the counters for `-c` only, over six rounds;
  - one profile per build;
  - four lexer comparisons;
  - three refine-phase rounds;
  - four placement rounds.
- **`scripts/campaign3.sh`** recorded the profiles again at half the sampling rate, after the first ones throttled.
- **The receipts:** 73 runs and the `ab` campaign, each exiting 0. `scripts/analyze.py` checks every run's receipts and summarizes them into `summary.txt`. It reports no missing receipt and no non-zero status.

## Results

**Outputs** (`runs/outputs-compared`): main's, the lexer candidate's and the refine experiment's outputs are the same bytes:

- the `-c` object, `f5d1e6f4…`;
- the `-E` output, `a984f9ca…`;
- standard output, diagnostics and exit status of `-c`, `-fsyntax-only` and `-E`.

**Tests:** these exit 0 with no failure or difference reported:

- `test-lexer` in its three modes, on the lexer candidate;
- `test-refinement` on `src`, on the refine experiment.

**Probes** (`runs/probe*`, one run each, 100% running): observations of these loops alone.

| Probe | `ls_misal_loads.ma64` | Cycles |
| --- | ---: | ---: |
| 32-byte plain, aligned / at +40 | 312 / 10.35M | 12.60M / 12.71M |
| 32-byte masked, 8 bytes enabled inside the line, aligned / at +40 | 311 / 10.31M | 16.30M / 16.31M |
| 64-byte plain, aligned / at +1 | 313 / 12.68M | 12.57M / 19.74M |
| 64-byte `vpermt2b` of two aligned lines | 299 | 12.12M |
| load-bound, 32-byte plain: aligned / at +40 | 280 / 10.08M | 9.86M / 10.47M |
| load-bound, 32-byte masked at +40 | 10.08M | 10.50M |
| load-bound, 64-byte plain: aligned / at +1 | 298 / 10.08M | 5.45M / 10.50M |

A masked load whose only crossing bytes are masked off is counted as crossing.

**Counters** (`-c`, 6 rounds, the builds' order rotating; every event ran 100% of the time):

| | main | lexer | refine |
| --- | ---: | ---: | ---: |
| user cycles, median (range) | 634.90M (628.54–682.78) | 631.52M (629.76–632.68) | 630.61M (626.70–685.01) |
| user instructions | 1,402.76M | 1,403.57M (+0.81M) | 1,401.86M (−0.90M) |
| `ls_misal_loads.ma64` | 12.18M (11.54–12.92) | 11.62M (11.28–12.18) | 12.22M (11.70–12.46) |

- **Instructions:** each build's ranges are apart from main's.
- **Cycles and line-crossing loads:** each build's ranges overlap main's.
- **Outliers:** one main process and one refine process ran about 8% slower than the rest.

**Profiles** (`perf record -e ls_misal_loads.ma64:u`, one `-c` per build, whole reports in `runs/report*`): the share of samples in each function.

| | at `-c 997`: main / lexer / refine | at `-c 1997`: main / lexer / refine |
| --- | --- | --- |
| `tokenize_c_raw_no_separators` | 1.70% / 0.06% / 1.59% | 1.93% / 0.08% / 1.98% |
| `refine_pass_b_64_plain` | 3.82% / 4.60% / 4.51% | 4.52% / 5.34% / 5.56% |

- **Throttling:** perf throttled at both rates. The host's `perf_event_max_sample_rate` is 63,300. There were 19 throttle events per run at 997, and 11 to 14 at 1997, and about half and about 80% of the counted events were sampled.
- **What the shares are:** shares of the sampled events, not counts.
- **What they show:**
  - the lexer candidate's function has nearly no line-crossing samples left;
  - stage 1's share doesn't fall with masked loads.

**The lexer, in one process** (`runs/lexer-variants-*`; `benchmark-lexer`, 21 interleaved passes; `control` is main's `c_lexer.c` built as a variant, `k1` the candidate):

- **Correctness:** both variants tokenize every file the same as `c_tokenize`.
- **Direct comparison:** each pass's `k1` cycles divided by `control`'s in the same pass.

| Corpus | `k1`/`control`, median (min–max) | passes above 1 | `control`/`c_tokenize`, median |
| --- | ---: | ---: | ---: |
| `sqlite3.c` | 1.0138 (1.0085–1.0235) | 21 of 21 | 0.9941 |
| `sqlite3.c`, `--no-digit-separators` | 1.0109 (1.0083–1.0260) | 21 of 21 | 1.0036 |
| the C library corpus | 1.0141 (1.0118–1.0156) | 21 of 21 | 0.9839 |
| main's `src` | 1.0178 (1.0172–1.0191) | 21 of 21 | 0.9798 |

**The refine phase** (`runs/refine-phase-*`; `benchmark-refinement --only refine_tokens_64` on `sqlite3.c`, three rounds alternating the two executables):

| | main | refine |
| --- | --- | --- |
| cycles per token | 5.53, 5.54, 5.55 | 5.44, 5.47, 5.46 |
| instructions per token | 19.80 | 18.80 |
| time | 1.165, 1.166, 1.167 ms | 1.145, 1.151, 1.150 ms |

This compares two builds in turn, each at one placement. `docs/profiling.md` puts such a comparison's noise at about 2%.

**Whole drivers over placements** (`runs/placements/ab.log`; buster#509's method: six placements of the frontend unit, which holds the lexer and the refine pass; two copies each; one run per `time-runs` process; four `ab` rounds; main's executables again as the floor). User cycles against main, each round's median over placements and copies:

| | `-c`, rounds 1–4 | `-fsyntax-only`, rounds 1–4 |
| --- | --- | --- |
| lexer | +0.04%, +0.01%, +0.19%, +0.02% | +0.06%, −0.37%, +0.06%, −0.04% |
| refine | −0.11%, −0.10%, +0.17%, +0.27% | +0.11%, −0.04%, +0.04%, −0.12% |
| main again | +0.00%, −0.24%, +0.08%, +0.07% | −0.19%, +0.01%, +0.13%, +0.11% |

Two rounds each had one slow placement, both of main's executables:

- **Round 2's `-c`:** placement 3, at 157 ms and 680M cycles against about 131 ms and 631M.
- **Round 4's `-fsyntax-only`:** placement 1, at 129 ms and 554M cycles against about 110 ms and 519M.

In both, main-again's processes of the same executables weren't slow, and the per-round lines in the log show each one. The round medians above are over all placements and copies, these included.

## What this supports, and what it doesn't

- **The lexer candidate:**
  - **Supported:**
    - it gives the same output;
    - it removes nearly all of its function's sampled line-crossing loads;
    - it adds about 0.8M instructions per `-c`;
    - in one process it lexes 1.1% to 1.8% slower than a control copy, in every pass of every corpus.
  - **Whole driver:** the effect is within main's own floor over placements.
  - **So:** on this host, replacing the line-crossing load with the permute costs more in the lexer than the crossing does.
- **The refine experiment:**
  - **Line crossings:** masked loads don't remove them. The counter is within main's range, and the function's share of samples doesn't fall.
  - **Whole driver:** within the floor.
  - **The refine phase:** it took fewer instructions per token, by 1.0 of 19.8, and fewer cycles per token in all three rounds. That comparison is two builds at one placement each, so it doesn't establish a speedup. It also concerns how stage 1's masks are built, not line crossings.
- **Not established:**
  - **Costs:** none of this gives the cost of the crossing loads in the application. The probes are the cost in their loops only.
  - **Other machines:** nothing about hosts other than this 9700X.
  - **C++:** the C++ corpus wasn't run.
