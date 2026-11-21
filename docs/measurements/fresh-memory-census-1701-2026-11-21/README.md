# Fresh memory of `-c sqlite3.c` by owner, stage and push, and a one-core survey (buster#1701, 2026-11-21)

The census that [buster#1701's claim](https://github.com/buster14a/buster/issues/1701#issuecomment-7067923237) asked
for before any change: every page `-c sqlite3.c` first touches, by the arena that owns it, the stage that touches it
and the push that took it, with and without huge pages, and which of the pushes' pages hold nothing but a fill. Beside
it, a one-core survey of the same compile on the 9700X: where the pipeline's slots go, by stage and by function.
Nothing here changes a compile: the census's patch logs and is not for main.

## What was measured

- **Revision:** buster main `bcb79bd638171eca64c3ab690a6d9a46cb353625` (2026-11-21), Release, built with CI's staged
  toolchain (LLVM 23.1.4) in a claude.ai cloud container. `binaries.sha256` has the executables:
  `build/cmake/znver5/Release/compiler` (`BUSTER_HOST_ARCH=znver5`, debug information on) and its copy without it,
  `bench/compiler-main`, which ran on the 9700X; `compiler-native-main`, main built for the container's host; and
  `compiler-census`, the same with `scripts/census/census-patch.diff`.
- **The input:** the frozen corpus of `tools/ci/fetch-corpus.sh` (archive `ceb39bf9…`), `sqlite3.c` with
  `--predefines provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc` and the corpus's three
  `-isystem` directories, as the one-core records take it.

### The 9700X survey

`scripts/9700x/survey.sh`, one hold of the lock (about 20 s) on CPU 2, after one warm-up compile: 5 `--time-stages`
compiles; `perf stat -M PipelineL1` and `-M PipelineL2`, 5 runs each; `perf stat` of user and kernel cycles,
instructions, mispredicted branches and demand fills from beyond the core's L2 (`ls_dmnd_fills_from_sys.all`, and
`.dram_io_near`), 5 runs; then two groups of counters, each 3 compiles, leader-sampled every 100,003 user cycles with
time stamps (`perf record -T`), each sample put in the stage its time falls in by the compile's own stage report,
anchored at its first sample in a `parse_` function (`scripts/9700x/reduce.py`). The stages from the lowering on
interleave by windows (#2536's step 1), so `lower`, `tier0` and the emission's rows share their work: the anchor check
against `tier0_generate`'s first sample reads 11 ms early for that reason (`results/9700x/anchors.txt`). Results:
`results/9700x/`; `by-stage-and-function.txt` and `inside-stages.txt` are the reducers' output.

### The census

In the container (4 vCPUs, CPU 2, address space randomization off: `setarch -R`), with `BUSTER_HUGE_PAGES=1` (the
9700X's policy: the arenas advised huge as there; on a virtual machine the compiler otherwise turns huge pages off) and
with `BUSTER_HUGE_PAGES=0` (base pages: the bytes actually touched, a 4 KB page at a time):

- `scripts/census/census-patch.diff` makes the compiler log, under `BUSTER_ARENA_LOG=FILE`, every reservation (with
  its caller), every table of `arena_reserve_tables`, every push of 64 KB or more (with its code address), every
  discard and every release, each with `CLOCK_MONOTONIC`; makes `--time-stages` list each run of laps of one stage with
  the time it ended (`census-lap`); and at check-input's end and at the report, scans every logged push's 4 KB pages
  through `/proc/self/pagemap` (present, the zero page's frame left out) and counts those holding one repeated byte.
- `perf record -k CLOCK_MONOTONIC -e page-faults:u -c 1 -d` records every user page fault's address.
- `scripts/census/census2.py` gives each fault the arena whose base is the nearest below its address (the arenas are
  carved 64 GB apart from one stretch, #2903), its stage by time, and its size: 2 MB where the fault is in an arena's
  huge part and is the only one in its 2 MB block, 4 KB otherwise (`census2-base.py` with base pages). A table's first
  `small` bytes are base pages, as `arena_reserve_tables` lays them out. `census3b.py` splits each arena by the push
  that covers each fault; `scan.py` reduces the scans by push site.
- Every census compile's object is the unpatched main's in the same container, byte for byte.

## The survey: where one core's slots go

`perf stat -r 5`, the whole compile:

| | |
| --- | ---: |
| elapsed | 114.25 ms (± 0.09%) |
| user cycles | 551.1 M |
| kernel cycles | 72.2 M (11.6% of both) |
| user instructions | 1,252.9 M (IPC 2.27) |
| mispredicted branches | 3.13 M (2.5 a thousand instructions) |
| demand fills from beyond L2 | 9.93 M, of them from DRAM 1.01 M |
| slots retiring | 23.0% |
| slots front-end-bound | 28.4% |
| slots backend-bound | 39.9%: by memory 31.2%, by the core 5.6% |
| slots lost to bad speculation | 7.3% (mispredicts 6.3%) |

By stage, user mode (`by-stage-and-function.txt`; M cycles a compile, under sampling, so about 3% above `perf stat`'s;
`ldnc` is the share of cycles with a load not complete at retirement; fills from beyond L2 a thousand instructions):

| stage | M cycles | IPC | mispredicts / Ki | front end, of slots | backend, of slots | ldnc, of cycles | fills / Ki | op cache misses / Ki |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| preprocess | 42.7 | 2.84 | 2.04 | 24.0% | 31.1% | 19.8% | 9.96 | 29.5 |
| parse | 22.0 | 2.12 | 2.36 | 16.5% | 47.5% | 17.1% | 12.49 | 8.3 |
| check-input | 205.7 | 2.12 | 1.80 | 29.5% | 38.7% | 42.3% | 9.24 | 57.0 |
| check-expressions | 57.0 | 3.27 | 2.33 | 27.7% | 24.9% | 33.4% | 4.28 | 30.0 |
| check-declarations | 10.9 | 2.33 | 1.16 | 14.6% | 55.0% | 61.0% | 4.46 | 21.6 |
| check-program | 108.1 | 1.70 | 4.19 | 24.6% | 44.6% | 54.3% | 8.42 | 15.2 |
| select | 4.7 | 1.44 | 4.41 | 20.7% | 52.7% | 56.5% | 22.27 | 6.1 |
| lower (with the windows' Tier 0 work inside it) | 64.1 | 2.34 | 2.71 | 33.7% | 30.4% | 36.7% | 7.00 | 62.6 |
| tier0 | 28.7 | 2.63 | 2.39 | 30.1% | 30.2% | 33.1% | 6.21 | 48.4 |
| the emission's other rows | 19.3 | | | | | | | |
| **all** | **566.5** | **2.27** | **2.46** | **27.6%** | **37.1%** | **40.3%** | **8.03** | **40.9** |

- **The stages that stall on loads most are the ones that hold the most memory:** `check-input` (36% of the user
  cycles) waits on a load in 42% of its cycles, `check-program` (19%) in 54%.
- **The front end is the second limit:** 28% of the slots, with an op cache miss every 16 to 21 instructions in
  `check-input`, the lowering and Tier 0.
- **The kernel's 72 M cycles are its pages** (#2873's census: page faults 82% of them).
- `__memset_avx512_unaligned_erms` is 13.4 M user cycles a compile at an IPC of 0.32, 8.2 M of them in `check-input`.
- The five stage clocks (`stages-*.txt`) read 113.8 to 114.9 ms with a peak RSS of 240,064 to 240,076 KB and 5,820
  to 5,823 minor faults, but the first: 140.1 ms, 186,740 KB and 56,238 faults, which took base pages (its report says
  `huge-pages` as the others do; it is the first of its hold after the warm-up, and this record doesn't say why).

## The census

### By stage and by owner

MB first touched (2^20 bytes), huge pages as on the 9700X, and base pages:

| | huge pages | base pages |
| --- | ---: | ---: |
| first touched | **277.4 MB** in 5,614 faults (128 of 2 MB) | **218.7 MB** in 55,980 faults |
| peak RSS | 231,676 KB | 180,388 KB |
| touched again after a discard | 2.0 MB | 0 |

| stage | huge | base |
| --- | ---: | ---: |
| setup | 2.5 | 1.6 |
| preprocess | 29.0 | 21.1 |
| parse | 69.6 | 34.8 |
| check-input | 116.4 | 115.9 |
| check-expressions | 26.2 | 25.4 |
| check-declarations | 6.0 | 1.9 |
| check-program | 16.0 | 9.9 |
| static-data, select and the emission's stages | 11.4 | 7.8 |

| owner (its reservation) | huge | base | its first touches, huge, by stage |
| --- | ---: | ---: | --- |
| the driver's scratch (`c_checker_driver.c:14178`) | 84.1 | 76.3 | parse 56.1, check-input 26.0, check-program 2.0 |
| the driver's arena (`:14177`): the reader's output, the graph's room | 78.0 | 52.8 | check-input 78.0 |
| the driver's output arena (`:14179`): the graph, the program | 42.1 | 38.4 | check-expressions 26.1, check-program 8.0, check-declarations 6.0, select 2.0 |
| the file cache's arenas (`c_preprocessor.c:4043`) | 15.1 | 11.3 | preprocess |
| the parser's columns (`c_parser_impl.c:11225`) | 13.5 | 10.1 | parse |
| the preprocessor's output (`pp_tokens_reserve`) | 12.2 | 6.7 | preprocess |
| the reader's sparse arena (`c_check_input.c:16990`) | 11.8 (3,020 faults) | 11.8 (3,020) | check-input |
| the program's controls (`check_program_begin`) | 6.0 | 1.0 | check-program |
| the object's arenas (`c_checker_driver.c:10314`, `:10315`) | 6.1 | 3.2 | lower to encode |
| the intern table, Tier 0's inline cache, the search directories, the rest | 8.5 | 7.1 | |

(`results/census/huge/owners.txt`, `results/census/base/owners.txt`; the pushes inside each arena:
`results/census/base/by-push.txt`.)

### What the counts say

- **Huge pages' rounding is 58.7 MB** (277.4 against 218.7), the largest part the reader's output arena (25.2 MB: the
  graph's columns start on a 2 MB boundary each, which the graph fills
  to less than half on `sqlite3.c`, #1076). It is not a lever: a 2 MB page costs about a third
  of what the same bytes cost in base pages (#2873's census: 210 K kernel cycles a MB against 642 K), so base pages pay
  only for a block of which less than a third is used.
- **Discarding and touching again is gone:** 2.0 MB, where #2873's census of 2026-11-16 had the scratch's 74 MB.
- **`check-input` holds the peak by itself.** It first touches 116 MB on top of the parse's scratch, which it reuses:
  its scratch, its output and its sparse columns take 140.9 MB in base pages (173.9 in huge pages) at once,
  206 bytes a token of the 716,136. No reuse of pages between stages lowers
  that; only fewer bytes a token in the reader does.
- **The reader's columns are dense and a token long.** In `by-push.txt` most of its pushes are 2.7 MB each (a 32-bit
  value a token for 716,136 tokens), touched whole: the declarations, the objects, the selected tokens, the
  activations, the parameters, the values' chains; the traversal it derives itself (five columns, 13.1 MB).
- **Pages that hold one repeated byte** at check-input's end (`results/census/scan/scan-0-by-site.txt`, base pages):
  53.6 MB of the large pushes' pages (35.1 MB of zeros), counted by push, so that two pushes over the same scratch
  pages count them twice. Whole columns of one byte on `sqlite3.c` (2.2 to 2.8 MB each): `check_input_asm_labels`'s,
  `check_input_intrinsic_initialize`'s, `check_input_deprecated_uses`'s (`c_check_attribute.c:11366`),
  `check_input_fallthrough_placements`', the selected tokens (`:17313`), the tag completions (`:17484`), the walk's
  stack (`:17695`), the traversal's temporaries (`:17503`), two of the parser's (`c_parser_impl.c:7818`, `:7819`).
- **The reader's sparse arena is base pages by design** (#628: its columns are written sparsely and the binding
  table's nine columns as prefixes): 3,020 faults for 11.8 MB, at three times a huge page's cost a byte.

## What it means for #1701

- **The kernel's row is the bytes a token the compile writes, not how it takes pages.** About 219 MB are genuinely
  touched; a 2 MB page is already the cheapest way to take them; nothing is touched twice. Of the 277 MB, the bounded
  pieces reach the fill-only columns and the sparse arena's base pages: about 2 to 4% of the compile together.
- **The rest goes with fewer bytes a token:** the node machine's records in place of the reader's columns and the
  graph (#2850's step 2), or the same columns a window long (#2536's steps 3 to 5).

## Beside the lifetime census of the same day

Another session measured #1701's step 1 on the same main in parallel
([lifetime-census-1701-2026-11-21](../lifetime-census-1701-2026-11-21/), its result
[on #1701](https://github.com/buster14a/buster/issues/1701#issuecomment-7068249939)): what each stage reads and
writes again of what earlier stages left resident. The two agree where they overlap: the arenas' pages touched, 207.7 MB
there (64 KB granules, `madvise` huge pages) and 218.7 MB here in base pages with the tables and the rest; the peak held
by live unit-wide data; about 3 to 4% of the compile for a lifetime plan without windows. What this record adds: the
9700X survey; first touches by stage and by owner with the 9700X's page policy and with base pages (so the rounding
and the base-page faults apart); the pushes behind each owner's pages; the pages holding one repeated byte; the sparse
arena's 3,020 base-page faults, which that record's list of pieces doesn't have.

## Reproducing

- The 9700X: copy `bench/compiler-main`, the corpus's `sqlite/sqlite3.c`, `headers/` and the predefines to
  `~/buster-fast-bench/singlecore-claude-l70yen/`, run `EXCLUSIVE_OWNER=… ~/buster-fast-bench/exclusive.sh ./survey.sh
  main`, then `python3 -I scripts/9700x/reduce.py results/9700x` and `scripts/9700x/bystage.py results/9700x
  check-input check-program lower`.
- The census: apply `census-patch.diff` to `bcb79bd6`, build Release, and for `HP` in 1 and 0:
  `BUSTER_ARENA_LOG=arena.log BUSTER_HUGE_PAGES=$HP setarch -R taskset -c 2 perf record -k CLOCK_MONOTONIC -e
  page-faults:u -c 1 -d -o faults.data compiler -c FLAGS sqlite3.c -o o.o --time-stages 2> stages.txt`, then
  `perf script --ns -F time,addr,ip,sym > faults.txt` and `census2.py arena.log stages.txt faults.txt compiler`
  (`census2-base.py` for `HP=0`). The scans are in `stages.txt` (`census-scan`); `scan.py stages.txt compiler`.
  The reducers symbolize with `addr2line` against the patched executable, which isn't kept here: `owners.txt`,
  `by-push.txt` and `scan-0-by-site.txt` are their outputs.
