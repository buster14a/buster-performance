# Tier 1 allocates each function once: the implementation's measurements (buster#2538, 2026-11-12)

These are the 9700X measurements of the implementation of
[buster#2538](https://github.com/buster14a/buster/issues/2538)'s design (`docs/tier1-one-allocation.md` in buster;
the design's own record is [`tier1-compile-cost-138-2026-11-12`](../tier1-compile-cost-138-2026-11-12/)). The branch
`claude/zen-shannon-ch4f8b` of buster has one commit per step of the design, each on the one before:

| tree | commit | the design's step |
| --- | --- | --- |
| main | `33f3f442a1115ef969256ffef77c34af0c3799b9` | main, the branch's base |
| step1 | `b46a8b1089c6e1cc047b3d4de86cf2268db2d157` | 1: the CFG allocator split into prepare, assign and finish |
| step2 | `c4b597eaa5b126d54cb9f972f6bfcc5db81f4bb6` | 2: one allocator call for both problems |
| step4 | `ed681ad5754e9eae258bd759685c4078302d77b7` | 4: the crossing test from prefix counts (on step 2) |
| step3 | `7b6eb29e7cd104ecf44990c05aa063155e40ddec` | 3: the plain verdict inside the preferred assignment's call (on step 4): the branch's code |

Step 4 was committed before step 3, so `step3` is all four steps. Commits after `7b6eb29e` on the branch change
documentation only.

## Method

- **Host:** the Ryzen 7 9700X (`benchpress`), Arch Linux, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9; CPU 2
  (its SMT sibling offline, governor `performance`); transparent huge pages `always`; `/home` on btrfs with zstd.
- **Builds:** each tree by its own `./build.sh shifts` (Release, `-O3 -march=native`, the default host) with
  `BUSTER_DEBUG_INFO=0`, since the host's disk was nearly full (debug information changes no code), linked at four
  placements of `main_unit_backend.c`'s code, 0, 1,088, 2,176 and 3,264 bytes later (its `.text` is aligned to 64).
  Every build was one hold of the machine's lock (`scripts/lock.sh`, owner `claude-2538`). Round 1 built main, step 1
  and step 2 in worktrees of a blobless clone (`scripts/setup.sh`, `build.sh`); round 2 copied main's and step 2's
  placed executables into `bins/` (`setup2.sh`) and built steps 4 and 3 in turn in step 2's worktree (`build2.sh`).
  The executables' hashes are in `raw/round*/*/compiler.txt` and `raw/round2/bins.sha256`.
- **Workloads** (`scripts/corpora.sh`, the design record's): the frozen corpus's `sqlite3.c` (SHA-256 `0a409f16…`)
  with the 9700X job's options, one unit; Lua 5.4.8's 33 units (the release by its hash, `scripts/inputs.sh`); the
  corpus's musl, the first source of each base name, 1,336 units in one command. `--tier1 --lanes 1 -c` throughout.
- **Timings** (`scripts/measure.sh`, `measure2.sh`): every tree at every placement as a configuration of its own, in
  a directory of its own, whole processes under `perf stat` pinned to CPU 2 in a Williams design's order after a
  warm-up round (`scripts/runs.py`, the design record's), 9 runs a configuration (musl: 5); one corpus a hold. Each
  hold's own lock line is `raw/round*/*/holder.txt`. `scripts/analyze.py` makes `raw/round*/analysis.md`: medians per
  configuration, and each tree's change in user cycles against main's, paired by placement.
- **Objects:** every configuration's objects against main's at placement 0 (`raw/round*/*/objects.txt`).
- **Logs:** `scripts/strip_lock.py` removed `exclusive.sh`'s waiting messages from the build and queue logs, which name
  other sessions' commands and links; each hold's own lock line stays.
- **Peaks** (round 2, `scripts/peaks.sh`): every configuration without `perf` (`runs.py --plain`), 3 runs. A process's
  peak counts the executable's own file pages, which differ between files of the same code (see "Peaks" below), so
  each tree's peak is its four placements' median.

## Results

### Objects

Every configuration's objects are main's, byte for byte, in both rounds: `sqlite3.c`'s one object (SHA-256
`573889642b44…`, the design record's), Lua's 33 and musl's 1,336.

### Time (round 2, `raw/round2/analysis.md`)

User cycles against main's, the mean of the four placements' paired changes (each placement's in the analysis), and
the wall time's mean over placements:

| corpus | main | step 2 | and step 4 | and step 3 (the branch) |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 427.0 ms | 400.9 ms, −6.31% | 398.9 ms, −6.83% | 391.7 ms, −8.63% |
| Lua, 33 units | 168.4 ms | 163.5 ms, −2.86% | 163.0 ms, −3.21% | 162.5 ms, −3.59% |
| musl, 1,336 units | 1,377.8 ms | 1,365.5 ms, −0.94% | 1,363.5 ms, −1.23% | 1,359.1 ms, −1.48% |

Each step's own share, against the tree before it, paired by placement:

| corpus | step 2 against main | step 4 against step 2 | step 3 against step 4 |
| --- | --- | --- | --- |
| `sqlite3.c` | −6.31% (−6.00 to −6.68), −142.6 M cycles, −26.1 ms | −0.56% (−0.45 to −0.86), −11.8 M, −2.0 ms | −1.93% (−1.78 to −2.16), −40.6 M, −7.3 ms |
| Lua | −2.86% (−2.60 to −3.04) | −0.36% (−0.19 to −0.56) | −0.39% (−0.26 to −0.62) |
| musl | −0.94% (−0.57 to −1.09) | −0.30% (−0.15 to −0.49) | −0.25% (−0.11 to −0.35) |

Main's own spread over its placements: 0.45% (`sqlite3.c`), 0.55% (Lua), 0.90% (musl).

Round 1 (`raw/round1/analysis.md`) measured step 1 against main: user cycles −0.20%, −0.14%, −0.21% and −0.17% over
the four placements on `sqlite3.c` (mean −0.18%; instructions +0.20%), −0.11% on Lua, +0.12% on musl. Its step 2
read −6.47% on `sqlite3.c`, −2.97% on Lua and −0.93% on musl.

### Peaks (round 2)

Each tree's peak resident set, KiB, the median over its four placements (each the median of 3 runs):

| corpus | main | step 2 | and step 4 | and step 3 |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 299,048 | 295,010 | 294,826 | 292,744 |
| Lua | 102,692 | 90,866 | 90,678 | 90,764 |
| musl | 149,314 | 148,476 | 148,322 | 148,544 |

Round 1 took its peaks from placement 0 alone and read musl's at 149,316 KiB for main and 150,764 KiB for step 2,
the same in every run. That was the executables' files, not the compile's memory: locally (a Sapphire Rapids cloud
host, THP `madvise`), the same main executable measured `sigaltstack.c` alone at 16,240 KiB from the build's file
and at 17,368 KiB from a fresh copy (whole musl 113,872 against 114,828), and at the process's exit the difference
between two builds was all in the executable's own file-backed mappings (text 7,720 against 9,192 KiB resident), the
kernel's fault-around mapping more or fewer of the file's cached pages. Round 2's executables are fresh copies, four
per tree; there every tree's peak is below main's on all three corpora.

### The design's gates

| step | gate | measured |
| --- | --- | --- |
| 1 | `--tier1 -c sqlite3.c` within ±0.3% user cycles of main over placements; objects byte-identical | −0.14% to −0.21% over the four placements; identical |
| 2 | user cycles down at least 5% on `sqlite3.c` and 2% on Lua, not up on musl; peak not above main's; byte-identical | −6.31% (−6.47% in round 1), −2.86% (−2.97%), −0.94% (−0.93%); every peak below main's; identical |
| 3 | at least 1% more of `sqlite3.c`'s user cycles; byte-identical; `--verify`'s whole plain assignment agrees with every prefix verdict | −1.93% against step 4 (−1.78% to −2.16%); identical; see buster's PR for `--verify` |
| 4 | the callee-saved step at most 1.5 ms on `sqlite3.c`, from 3.5 | −11.8 M user cycles and −2.0 ms of the compile against step 2, of the step's 20.0 M cycles and 3.5 ms in the design's record: about 8 M cycles and 1.5 ms left, inferred from the whole compile, not measured by stage |

The design expected `sqlite3.c` at 393 ms with steps 2 and 3 and 389 ms with step 4 too, from 426.1 ms; the branch
measures 391.7 ms from 427.0 ms here. Lua: 162.2 ms expected, 162.5 measured. musl's main is 1,377.8 ms on this
revision against the design's 1,352.4 ms on `c5f0efb2`; the branch takes 1.48% of its user cycles.

## What isn't here

- **Eight lanes:** not measured. The cycles are the same work; the design expects about 7 ms of `sqlite3.c`'s 176 ms.
- **The callee-saved step by stage:** step 4's gate is inferred above; the lap patch of the design's record was not
  rebuilt on this branch.
- **Debug information:** the builds have none (disk); the code is the same.

## The local checks (in the buster PR)

Run on the session's cloud host, outside the lock, on the branch's builds: `test-tier1-cfg`, `test-tier1-cfg-source`
on c-testsuite's subset, the SIMD files, `sqlite3.c` and musl, `test-tier1-emit`, `test-tier1-pipeline
--cross-check`, `test-tier1-allocation`, `test-tier1-masks`, `test-tier1-wide`, `test-tier1-frame-execution`,
`test-c-testsuite --tier1` and `test-ssa-source --typed --tier1`; objects of `--tier1 -c` against main's on the three
corpora by both host paths (`--scalar`), c-testsuite's 220 single-exec tests and the compiler's own 11 units; and
`--tier1 --verify` on the corpora and the compiler's own units. The PR has the counts and the mutants each check
catches.
