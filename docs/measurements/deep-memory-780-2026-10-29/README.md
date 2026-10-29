# Tier 0's deep values beside long double, __int128 and vectors, Buster #780

Compiler branch: `claude/deep-memory-780` of buster14a/buster, for
[this claim on #780](https://github.com/buster14a/buster/issues/780#issuecomment-6488590421).

Tier 0 refused every function with long double, `__int128` or vector values once its stacks passed the depth tables.
The branch gives those functions the deep slots: their values keep their 16- and 64-byte slots by their true depths,
and an entry of theirs that uses a stack's registers past the tables runs at its window's depths with its frame's
memory and vector areas shifted to match. This record keeps:

1. the default path's cost on the 9700X: `-c` of the frozen `sqlite3.c`, and `benchmark-backend-source` on its
   functions, main against the head (`measure.log`, `backend.log`, `scripts/`);
2. the mutation check of the fix's tests (`mutants/`);
3. stb_image, whose `_mm_set1_epi8` stopped `-c` at the refusal, compiled with buster#759's SSE builtins and decoding
   images as clang's build of it does (`stb_image/`).

## Sources

Each measured tree is a `git archive` of its commit, extracted on the 9700X with a `COMMIT` file that names it:

- **m780, the base:** `bc11fddbc595e3a7baa855f37eae9d5cc558bd62`, main, the merge-base;
- **h780, the head:** `02c1fa27a4da2e07fc5a57c5b89170cd62295c44`, the branch's head: the fix (`f9299a9f`), the
  test-check-lanes programs that relied on the refusal (`bad82dda`), and main merged into them.

`manifests/` has each commit's file manifest (the SHA-256 of every file of its `git archive`, sorted by path), and
`compare.txt` the comparison with the trees on the 9700X: the same files and bytes, but for each tree's `build.log`,
the build's transcript (and `build/` and `COMMIT`, which the comparison leaves out).

## Method

`scripts/queue-780.sh` built each tree (`scripts/build-tree.sh`, `BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job
builds), then ran `scripts/measure.sh` and `scripts/backend.sh`, each in a hold of the host's lock of its own.

- **`-c` of `sqlite3.c`:** the 9700X job's compile-time step's command, `-c -DSQLITE_OMIT_LOAD_EXTENSION
  -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<its directory>` of the frozen SQLite
  amalgamation, pinned to CPU 2. `measure.log` is its whole transcript: the receipts (the date, `uname -a`, the CPU,
  CPU 2's governor, clang's and perf's versions, the lock's owner line, the trees' commits, and the SHA-256 of both
  executables and of `sqlite3.c`), a drive check of each tree (its status, and the two objects compared), and 8
  rounds in which each tree, in an order alternated by round, runs 3 times under `perf stat -e
  instructions:u,cycles:u,task-clock`, each run's exit status beside its counters. `scripts/analyze.py` takes each
  round's mean of a tree's runs, then the median of the rounds' means and the median, minimum and maximum of the
  per-round ratios; its output is `analysis.txt`.
- **`benchmark-backend-source`:** the 9700X job's step on the frozen `sqlite3.c`'s functions, with its options
  (`--predefines` of the pinned gnu17 predefines, `-march=znver5`, the frozen headers), pinned to CPU 2: 3 rounds,
  each tree once per round, in an order alternated by round. Each run checks that both of Tier 0's paths compile
  every function alike, then reports 21-pass medians of each variant per typed entry. `backend.log` is the whole
  transcript.

The lock's waiting messages went to separate files, which this record leaves out: they name other jobs.

## Results

Both trees build with status 0 (`build-*.log`, with each executable's SHA-256) and write byte-identical objects of
`sqlite3.c` (SHA-256 `9048dda4…`). All 48 timed `-c` runs and all 6 benchmark runs exit 0, and each benchmark run
checked that both of Tier 0's paths compile every function of the file alike.

**`-c` of `sqlite3.c`** (`analysis.txt`): the medians of the rounds' means, and the per-round ratios' median and
range:

| | m780 | h780 | h780 against m780 |
|---|---:|---:|---:|
| instructions | 1,247,221,787 | 1,247,301,187 | +79,400 (+0.0064%) |
| cycles | 576.17 M | 577.72 M | +0.25% (−0.03% to +0.69%) |
| task clock | 122.35 ms | 122.58 ms | +0.16% (−0.01% to +0.45%) |

Each tree's instructions vary by at most 159 within a round. The head's cycles lean higher in 7 rounds of 8, but one
executable per tree is one placement of each build's code: [buster#509's record](../placements-509-2026-10-26/) read
heads that change no code these commands run at −0.46% to +0.36% that way (`-fsyntax-only` of the same file), and
Tier 0's own paths measure faster on this head (below). The instructions are the precise comparison.

**`benchmark-backend-source`** on the file's 2,602 functions, 396,872 typed entries, 14,005 of them deferred
(`backend-analysis.txt`), the medians of the 3 rounds per typed entry:

| variant | cycles, m780 → h780 | instructions, m780 → h780 |
|---|---:|---:|
| vector (`tier0_compile`) | 65.31 → 64.59 (−1.10%) | 152.82 → 153.00 (+0.12%) |
| scalar (`tier0_compile_scalar`) | 181.33 → 175.28 (−3.34%) | 528.81 → 528.35 (−0.09%) |
| sizing | 5.45 → 5.48 (+0.55%) | 11.37 → 11.37 |
| encode | 3.88 → 3.95 (+1.80%) | 14.17 → 14.17 |
| validate | 12.73 → 12.77 (+0.31%) | 30.09 → 30.07 (−0.07%) |
| validate-scalar | 45.85 → 45.83 (−0.04%) | 129.53 → 129.41 (−0.09%) |
| choose | 1.74 → 1.69 (−2.87%) | 3.32 → 3.32 |
| choose-scalar | 7.61 → 7.60 (−0.13%) | 20.10 → 20.10 |

Every head round of the vector and the scalar paths is faster than every base round. The encoder and the form choice,
whose code and instructions don't change, move by +1.8% and −2.9%: these cycles, too, are the builds' placements. The
vector path runs 0.18 more instructions per entry, about 71,000 over the file, most of `-c`'s 79,400, and the scalar
path 0.46 fewer: that is what the change costs functions within the depth tables. The deep paths it adds run only in
functions past them.

## Mutation check

`scripts/mutants.sh` built two mutants locally, each the fix's commit `f9299a9f` with one line changed
(`mutants/*.diff`), and ran the test that covers it (`mutants/results.txt` has the host's receipts, the builds and
the failures):

- **unshifted-slots:** a deep `__int128` entry's records given the frame as it is, rather than shifted to its true
  depths. `test-tier0`'s `int128` check fails 3 checks: the sums of 15, 16 and 40 `__int128`s (class 12) differ.
- **deep-call-long-double:** a deep call's long double argument on the stack read as an integer's, rather than
  copied from its slot by `fld` and `fstp`. `test-checker` fails `memory-classes-past-the-depth-tables` on both
  paths (at n = −3, ours 15366 against clang's −59209).

## stb_image

`stb_image/run.sh` ran locally on a build of the branch's head with buster#759's diff applied (`git diff 39732990
d9a474cf`, which adds the SSE builtins stb_image calls); `stb_image/receipts.txt` is its transcript. The unit and
stb's sources are [buster#759's record's survey's](../sse-builtins-148-2026-10-28/survey/). With `-march=native`:

- this compiler compiles stb_image with `--verify`, by both paths into the same object; before this branch, with
  buster#759 and buster#741, it stopped at `_mm_set1_epi8`'s call of `_mm_set_epi8` (buster#759's record's
  `survey/results-head-with-741.txt`);
- a driver that clang compiles (`stb_image/driver.c`) decodes 14 images with this compiler's object and with clang
  -O0's, each as 8-bit, 16-bit and float pixels, with the file's channels and as RGBA: the 84 decodes' sizes and
  pixel hashes are the same (`ours.txt`, `clang.txt`). The images are 12 that ImageMagick makes from one plasma
  fractal (JPEGs with 4:2:0, 4:2:2 and 4:4:4 sampling, progressive and gray ones, PNGs with alpha and a palette, a
  BMP and a GIF; `deep16.png` is `base.png` again, which this ImageMagick writes 16-bit already) and two of the
  host's JPEGs, which the record doesn't hold (their SHA-256 are in the receipts);
- gdb stops in `stbi__idct_simd` and `stbi__YCbCr_to_RGB_simd` in this compiler's build: the JPEG decoder runs its
  SSE2 kernels, not its scalar ones.

## Limits

- One host and one lane, and one build of each tree. The cycles' differences sit within the placement noise that two
  builds of the same work show on `sqlite3.c` (0.7%, buster#536's record); the instruction counts are the precise
  comparison.
- The mutation check and the stb_image check ran on the laptop (Ryzen 9 7940HS, Zen 4), not the 9700X. The mutants
  were built before main was merged into the branch: from `f9299a9f`.
- A first measurement, of main `9bb5060e` against `f9299a9f`, was void and isn't kept: its head tree's directory was
  renamed while it ran, so its head runs failed (status 127).
