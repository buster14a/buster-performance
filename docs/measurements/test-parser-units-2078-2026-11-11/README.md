# test-parser's units: one table and four parsers from unit to unit (buster#2078), 2026-11-11

These are the measurements behind buster pull request #2087. It cuts `test-parser`'s own time; `test-parser --clang`
("Test the parser's snippets against clang") was the correctness inventory's longest command on the hosted x86-64
row. `trees.txt` names the sources, the executables, the machines and the hosted runs.

## The change

Before (base 15b40c9, #2076's branch), each of test-parser's generated units did all of this:

- wrote its text to a file;
- set up a fresh intern table, a preprocessor and four parsers (the vector path's and the scalar parser's, each
  again tree-only);
- ran the checks, then released everything.

There are 34,624 alignment units: the 541 snippets after 0 to 63 file-scope `;`. After (head 8adcc8b, then 1c835d9),
`parse_test_check_unit` keeps a `ParseTestUnits` from unit to unit:

- **Intern table:** one, reset before each unit (`intern_reset`).
- **Parsers:** the four parsers. Each one's scratch is cleared before a unit, so it reads as a fresh parser's.
- **Arenas:** an arena pool, as a units lane has.

Each unit still gets its own preprocessor. The alignments and the streams are preprocessed from memory
(`pp_run_source`).

## Profile (`results/profile/`, `results/local/`)

On a 4-CPU Xeon container, test-parser without files took 75–80 s. The alignments took 66–70 s of that, and the
streams 3.9–4.4 s. That time was mostly the kernel's: 44–47 s of the alignments' were system time.

`perf record --call-graph dwarf` on the base (`results/profile/base-15b40c9.txt`) gives these shares of all samples
under the per-unit check:

| Share | Where |
|---:|---|
| 23.1% | `intern_initialize`, nearly all of it page faults adding the predefined names to a fresh table |
| 11.0% | `pp_release` |
| 9.6% | the preprocessor's run (6.2% its prelude) |
| 8.0% | the tree-only parses |
| 7.5% | the parses |
| 4.8% | the kernel checks |
| 4.6% | `pp_initialize` |
| 16.3% | `munmap`, across the releases |
| 5.3% | the file's `fopen` and `fclose` |

`reuse-table-parsers.txt` and `reuse-and-pool.txt` profile the two intermediate steps.

## Coverage: identical (`results/digest/`, `scripts/digest-*.patch`)

A temporary digest (`digest-base-15b40c9.patch`, `digest-head-1c835d9.patch`; not committed) printed, for every unit
that the alignments, streams and nesting check:

- the tokens' kinds, intern ids, sources and flags;
- both parsers' trees (roles, node depths, parents);
- postorders, subtree sizes and the four columns;
- diagnostics, errors, fatal message and statistics;
- the vector path's outcome;
- the kernel tallies after the unit, and the failures.

The `DIGEST` and `PARTS` lines of all 36,634 units are byte for byte the same for base 15b40c9, head 8adcc8b and head
1c835d9: `*-digests.txt.gz`, one SHA-256 for all three. Standard output differs only in the driver section's limit
walks (below).

**Before the scratch clearing, one unit differed.** In an earlier version, without the clearing, stream 1485's vector
statistics changed: fallback items 1, flagged tokens 0, against 6 and 77. Everything else matched, tree and
diagnostics included (`before-zeroing-*.txt`).

- **Cause:** the vector path's K5 reads temporaries the unit didn't write. A reused parser's scratch held what an
  earlier unit wrote there; a fresh parser's reads zero. Filed as buster#2086.
- **Repro:** `results/k5/first.c`, then `second.c`, on one parser (`scripts/k5-experiment-8adcc8b.patch`). With the
  scratch zeroed, K5 reports `statements_ok 0`; kept dirty, `statements_ok 1`.
- **What it ruled out:** a fresh parser whose scratch was pre-filled with a uniform byte (0x00, 0xa5, 0xff or 0x01)
  gave the fresh verdict. Zeroing the scratch restored it; zeroing `ParseKernels` didn't.

So the head clears each reused parser's scratch before every unit.

## Results

### Local: a 4-CPU Xeon container (`results/local/`)

These builds carry `scripts/timing-*.patch` (per-section times on standard error).

| | Base 15b40c9 | Head 1c835d9 |
|---|---:|---:|
| `test-parser`, without files or clang | 79.7, 78.0, 75.2, 76.7 s | **21.6, 21.3 s** |
| the alignments | 70.4, 68.1, 65.8, 66.9 s | **15.0, 14.7 s** |
| the streams | 3.9, 4.4, 3.9, 4.3 s | **1.07, 1.09 s** |
| the repository's 33 units (`--files-only`) | 19.9, 20.1, 20.0 s | 19.8, 19.7, 19.6 s |

**Head 8adcc8b** zeroed each scratch to its all-time peak (`arena_poison`). On the repository's units, that cleared
14.9 GB over 33 files, every pushed page of the largest unit before each later file. That left the units command
level locally and 4% slower on a hosted EPYC 7763: 60.5 s against 57.8–58.4 s.

**Head 1c835d9** fixes that:

- up to 1 MB, it clears in place (a generated unit's scratch peaks at 55 KB at the median, 123 KB at the 99th
  percentile);
- past that, it gives the pages back with `MADV_DONTNEED`, as a fresh mapping would;
- then it sets the peak back to 0.

### The 9700X (`results/9700x/`)

Each run held the lock once (`scripts/9700x-run.sh` under `exclusive.sh`), pinned to CPU 2 (`taskset -c 2`).
Rounds are interleaved ABBA. Runs are timed by bash's `time`, with `perf stat`'s task-clock, page faults and context
switches.

| Command | Base 15b40c9 | Head 1c835d9 | Head 8adcc8b (first campaign) |
|---|---:|---:|---:|
| `test-parser` (plain) | 12.06, 12.00†, 12.16 s; 12.14, 12.07†, 12.10 s | **5.94, 5.89, 5.95 s** (−51%) | 5.92, 6.03, 6.04 s |
| `test-parser --clang` | 15.23, 15.33, 15.16 s; 15.19, 15.18†, 15.20 s | **9.02, 9.07, 9.08 s** (−40%) | 9.03, 9.06, 9.08 s |
| the repository's 33 units | 6.58, 6.40, 6.41 s | **6.38, 6.37, 6.38 s** (−1.3%) | |

- **Where the time went:** plain, base spent 2.6 s user and 8.8 s system; head 2.6 s user and 3.3 s system. Page
  faults fell from 7.93 million to 5.31 million.
- **Same inputs:** the units command read the base tree's sources and one `predefines.h` for both builds.
- **The units rows in `results.tsv`** (status 126) are a script error and aren't measurements: the file list was
  passed with its newlines. `results-units.tsv` is the corrected campaign.
- **† Base failed the driver section in 3 of its 12 timed plain and `--clang` runs**, all in round 2, where base ran
  second. Each reported "a run in a child gave status …, not …": a probe child didn't leave its address space or
  descriptors as they were (`log-base-*-2.txt`). The same check failed once locally, on the base under `perf
  record`. Head passed all 12 of its runs, and all 6 units runs passed.

### Hosted plain rows (`scripts/hosted-times.sh`, `results/hosted/`)

Times are the parallel runner's report ("TITLE: passed in WALL s, CPU s of CPU"), with each job's runner CPU.

- **Befores, served:** #2076's three runs (`before-served-2076.tsv`), the same configuration as #2087. The x86-64
  row serves clang's runs; the native row runs each both ways (`BUSTER_DRIVER_DIFFERENTIAL`).
- **Befores, unserved:** seven runs (`before-unserved.tsv`), which #2076's record also used.
- **Afters:** #2087's two runs (`after.tsv`): 43003637336 at 8adcc8b and 43009836443 at 1c835d9.

`test-parser --clang` ("Test the parser's snippets against clang"):

| Row | CPU | Before | After | Change |
|---|---|---:|---:|---:|
| native, both ways | EPYC 7763 | 235.1, 237.1, 230.2 s (served) | **89.7 s** (8adcc8b) | −62% |
| x86-64, served | Xeon 8573C | 165.8 s (served) | **72.7 s** (1c835d9) | −56% |
| native, both ways | EPYC 9V74 | 178.9, 177.1 s (unserved) | **52.5 s** (1c835d9) | −70%, across configurations |
| x86-64, served | EPYC 9V74 | 261.6 s (unserved) | **72.2 s** (8adcc8b) | −72%, across configurations |

The first two rows pair the same row, CPU model and configuration. The last two compare against unserved befores,
since no served before ran on those models. Serving changes this command little: on the native EPYC 7763, served
befores averaged 234.1 s and unserved 235.5 s.

The repository's units (`--files-only`), which has no clang runs:

| Row | CPU | Before | After |
|---|---|---:|---:|
| x86-64 | EPYC 9V74 | 50.3–52.3 s (5 runs, mean 51.4) | 50.7 s (1c835d9) |
| native | EPYC 7763 | 57.8, 58.4, 58.0, 58.2 s | 57.3 s (1c835d9); 60.5 s (8adcc8b, before its fix) |

**Each row's longest command:**

- **x86-64, before:** test-parser `--clang`, in all three served runs (165.8–229.3 s) and four of the seven
  unserved ones (234.0–261.6 s).
- **x86-64, after:** the semantic driver's part 1 or 2, at 170.7 s and 162.4 s. test-parser took 72 s.
- **Native, before and after:** the semantic driver's parts (279–370 s).

test-parser no longer bounds either row's critical path (buster#2031). The part split the issue offered wasn't
needed. Both of #2087's runs passed every job.

## Other observations

- **Driver limit walks:** the number of runs in each walk ("N reservations and mappings failed in turn") varies
  with the process's earlier work, in the base too. Base: 143 or 146 for one file at different `--streams` counts.
  Head: 84–85 against base 86, 140–142 against 141. The walk still fails each reservation in turn: an admitted run
  halves the limit, so the count follows where the compact fallbacks admit.
- **Local and container measurements** are noisy: the container's load is beside each local timing. The 9700X's and
  the hosted runs are the comparisons that count.

## Reproduction

- `scripts/9700x-build.sh`, `9700x-update.sh` and `9700x-run.sh`: the 9700X builds and campaigns, in
  `~/buster-fast-bench/2078-claude`.
- `scripts/timing-*.patch`: the per-section times.
- `scripts/digest-*.patch`: the per-unit digests. Run `./build/compiler test-parser 2> err` on each tree, then
  compare `grep -E '^(DIGEST|PARTS)' err`.
- `scripts/k5-experiment-8adcc8b.patch`: buster#2086's repro. Run
  `K5DEBUG=1 [K5KEEP=1] ./build/compiler test-parser --files-only first.c second.c`.
- `scripts/hosted-times.sh RUN...`: the hosted extraction. It needs curl and jq; `GITHUB_TOKEN` authenticates.
- `scripts/agg.py` and `scripts/callers.py`: the profile summaries, from `perf script -F comm,ip,sym`.
