# The all-core path at main `b7d0b5ed`, the chain from the back, and the first tiles (buster#2536, 2026-11-23)

[buster#2536](https://github.com/buster14a/buster/issues/2536) is the design of what eight compiles at once cost each
of them, and of the change that removes it. This record measures where main stands eleven days after the design's
figures, what the chain built so far (`--windowed-loop`, step 2.2c.4) gives, and the first pieces of the order the
design then took: the stages run tile by tile **from the front**, the parser first, and the arenas' pages of 64 KB for
the kernel's part.

Everything is `-c --lanes 1` of the frozen `sqlite3.c` (9,507,037 bytes, the 9700X job's `compile_time` options) on the
9700X (`benchpress`), under the lock, by step 0's gauge (`tools/allcore/allcore.c`): a cohort of one worker on CPU 2 and
one of eight on CPUs 0 to 7, each run counted by its own counters. No stray process is in any cohort
(`*.strays.txt` are empty).

**In short.**

- **Main:** 83.2 MB/s alone and 322.0 MB/s on eight workers; a compile beside seven others costs 1.92 times the cycles
  of one alone (1.97 on 12 November).
- **`--windowed-loop` loses:** 314.8 MB/s on eight workers (2.2% less) and 80.6 alone (3.1% less), and its stages
  inflate exactly as before (1.75 times against 1.74).
- **The parser by tiles of 4,096 tokens** (`--parse-tile=4096`): 337.2 MB/s against 320.3 in one hold (+5.3%), the
  parse 8.7 ms at eight workers against 22.0, a compile alone the same time. The same object at every tile size.
- **64 KB pages** for a busy host's arenas: 2% to 5% at eight workers in three pairs; 16 and 32 KB pages cost the
  kernel more than base pages do. With the parser's tiles, 357.0 MB/s against 323.6 (+10.3%).

## The executables

All four are Release builds made on the host under its lock by `scripts/setup1.sh` and `scripts/setup2.sh`, with the
9700X job's toolchain. Each tree is main `b7d0b5ed` with one patch (`scripts/*.patch`).

| tree | patch | `build/compiler` SHA-256 | what it adds |
| --- | --- | --- | --- |
| `main` | none | `9dc96f2d2a74edc8134ec767e6cbd3973aee86d62c41fa75be218796d4724d9c` | |
| `medium` | `medium1.patch` | `5e5af7916c73e6f76d1299d7c546f8d0458d3e9e81358ee774be606b97373a88` | `BUSTER_HUGE_PAGES=medium`: the arenas advised as on an idle host, the first page of every 2 MB advised a base page |
| `tiles` | `tiles2.patch` | `e8ccd6d77b08b5d65bb562808a2789baa37b05c4301cf2c46343c6267c3d5e7b` | `medium`, and the parser by tiles, first version (`BUSTER_PARSE_TILE=N`): the kernels' arrays still as long as the unit |
| `tiles3` | `tiles3.patch` | `92f3e18f2ef69ec22875317cc4a524c791ece580560209f5578a85e684428bd5` | `medium`, and the parser by tiles with a workspace a tile long (`--parse-tile=N`), as the pull request has it |

Every compile of every configuration wrote the same object,
`190cf4c109792239cc1dfac8e2e2fb2fd1e11f5df9117e7766d9193f1b1b78eb` (`results/*/objects.txt`).

## Main today

`scripts/gauge1.sh main gauge-main-b7d0b5ed`: the gauge's two parts, six rounds each
(`results/gauge-main-b7d0b5ed/whole.tsv` and `table.tsv`).

| | one worker | eight workers |
| --- | ---: | ---: |
| MB/s | 83.16 | 321.98 |
| wall ms a compile | 114.18 | 232.91 |
| user cycles | 552.1 M | 968.5 M |
| kernel cycles | 76.5 M | 239.3 M |
| user instructions | 1,282.4 M | 1,282.4 M |
| peak RSS | 245.6 MB | 194.3 MB |
| faults | 5,630 | 56,057 |

| stage | ms, 1 → 8 | user M cycles, 1 → 8 | times | kernel M cycles, 1 → 8 | faults at 8 |
| --- | --- | --- | ---: | --- | ---: |
| preprocess | 9.25 → 15.11 | 42.5 → 59.0 | 1.39 | 9.0 → 16.3 | 5,537 |
| parse | 6.86 → 22.38 | 22.0 → 72.6 | 3.29 | 16.0 → 41.7 | 9,032 |
| check-input | 40.59 → 94.40 | 193.4 → 382.2 | 1.98 | 29.4 → 104.0 | 29,226 |
| check-expressions | 10.71 → 18.73 | 54.7 → 77.6 | 1.42 | 4.9 → 15.8 | 6,088 |
| check-declarations | 2.57 → 3.94 | 13.0 → 19.5 | 1.50 | 1.1 → 1.3 | 556 |
| check-program | 23.18 → 43.60 | 123.3 → 209.9 | 1.70 | 3.8 → 13.4 | 3,148 |
| select | 1.00 → 2.84 | 4.5 → 10.4 | 2.30 | 1.1 → 4.0 | 790 |
| lower | 11.60 → 18.03 | 61.8 → 91.7 | 1.48 | 1.7 → 0.4 | 926 |
| emission | 5.94 → 8.16 | 32.4 → 39.1 | 1.21 | 0.1 → 0.6 | 281 |
| object | 1.18 → 2.10 | 3.9 → 5.9 | 1.50 | 2.6 → 4.1 | 38 |
| the process's start and end | 0.23 → 0.29 | 0.6 → 0.7 | | 6.6 → 37.5 | 374 |
| total | 113.10 → 229.59 | 552.1 → 968.5 | 1.75 | 76.5 → 239.3 | 55,996 |

## A profile by function

`scripts/prof1.sh main prof-main-b7d0b5ed`: `perf record -a` of `cycles:u` and `cycles:k`, a sample every 100,003, over
twelve compiles on CPU 2 and over six on each of CPUs 0 to 7 (48), each cohort a hold; `scripts/reduce1.sh` counts
the samples by symbol (`one.sym.tsv`, `eight.sym.tsv`), and `scripts/fam.py` and `scripts/diff.py` make
`families.txt` and `functions.txt`, in millions of cycles a compile.

| family, user cycles | alone | at eight | more | times |
| --- | ---: | ---: | ---: | ---: |
| the reader's other functions (`check_input_*`) | 77.6 | 139.5 | 61.9 | 1.80 |
| the parser | 30.5 | 79.3 | 48.7 | 2.60 |
| the reader's expressions | 55.3 | 102.3 | 47.0 | 1.85 |
| the program and its controls | 71.7 | 118.6 | 46.9 | 1.65 |
| page-fault entries sampled as user cycles | 3.4 | 38.4 | 35.0 | 11.2 |
| warnings | 54.6 | 89.1 | 34.5 | 1.63 |
| the lowering | 56.7 | 84.2 | 27.4 | 1.48 |
| the reader's walk and bindings | 32.9 | 52.4 | 19.5 | 1.59 |
| libc's `mem*` | 15.6 | 35.0 | 19.4 | 2.25 |
| the graph's run and the C rules | 51.7 | 68.0 | 16.3 | 1.31 |
| the preprocessor and the lexer | 46.0 | 61.6 | 15.6 | 1.34 |
| initializers and static data | 14.6 | 21.6 | 7.0 | 1.48 |
| the emission | 31.6 | 34.6 | 3.0 | 1.10 |

- **No function is the cause.** The 391 M more user cycles are spread over every family but the emission.
- **A pass that only streams over the unit inflates most:** `check_input_count_tokens` 5.5 times,
  `parse_tokens_from_output` 8.7, `check_input_expression_classes` 4.5, `check_input_deprecated_marked` 4.3,
  `parse_top_parents8_avx512` 3.8, `memset` 2.5. Eight workers share what one stream alone would take of the bus.
- **The kernel's 177 M more cycles are the faults' bookkeeping:** `_raw_spin_lock` 44 M, `do_anonymous_page` 42 M,
  `native_queued_spin_lock_slowpath` 16 M, `lock_vma_under_rcu` 10 M, and the exit's `folio_remove_rmap_ptes`,
  `folios_put_refs` and `unmap_page_range` 26 M.

## The chain from the back: `--windowed-loop`

`scripts/gauge1.sh main gauge-main-windowed --windowed-loop`, the same executable and gauge
(`results/gauge-main-windowed/`).

| | main | `--windowed-loop` |
| --- | ---: | ---: |
| eight workers, MB/s | 321.98 | 314.77 |
| their wall ms | 232.91 | 238.94 |
| their user cycles | 968.5 M | 988.2 M |
| their kernel cycles | 239.3 M | 250.8 M |
| one worker, MB/s | 83.16 | 80.61 |
| its wall ms | 114.18 | 117.91 |
| user instructions | 1,282.4 M | 1,299.1 M |
| `check-program`, `select`, `lower` and the emission, ms 1 → 8 | 41.72 → 72.63, 1.74 times | 45.13 → 78.75, 1.75 times |

The windowed code served in every compile (`windowed-loop served 1` in the reports). The loop and the lowering chained
this way still read the graph, the stream and the reader's columns, which the stages outside the chain wrote for the
whole unit: the chain costs its second selection and gains nothing.

## The parser by tiles

`--parse-tile=N` runs the parser's kernels and its fallback over a run of top-level declarations of about N tokens at a
time, each tile through every kernel before the next
([its design](https://github.com/buster14a/buster/blob/main/docs/c-parser.md#tiles-2536)).

**The pull request's version** (`tiles3`, a workspace a tile long), `scripts/run9.sh tiles3 tiles3-pair2 3 ...`: three
passes of three rounds a configuration, the configurations in turn, all in one hold (`results/tiles3-pair2/`,
`scripts/summary.sh` and `scripts/stages.sh` reduce it).

| | unit as one | tiles of 4,096 | tiles of 16,384 |
| --- | ---: | ---: | ---: |
| eight workers, MB/s | 320.29 | 337.16 | 341.65 |
| their wall ms | 232.57 | 220.61 | 219.83 |
| their user cycles | 968.6 M | 912.3 M | 912.4 M |
| their kernel cycles | 231.6 M | 226.9 M | 217.2 M |
| their faults | 56,057 | 55,284 | 55,285 |
| the parse, ms 1 → 8 (reports' medians) | 6.82 → 21.99 | 4.80 → 8.73 | 4.96 → 8.97 |
| `check-input`, the same | 41.07 → 93.67 | 42.49 → 95.24 | 42.31 → 94.72 |
| the compile by its stages, the same | 114.32 → 229.20 | 113.70 → 216.62 | 113.79 → 216.34 |
| one worker, wall ms | 115.51 | 114.78 | 114.82 |
| its user cycles | 558.0 M | 554.6 M | 555.2 M |
| user instructions | 1,282.3 M | 1,284.7 M | 1,284.5 M |

- **Eight workers:** +5.3% by tiles of 4,096 and +6.7% by 16,384, within what the passes differ by (the hold before
  had 338.9 and 338.0).
- **One worker isn't slower.** Three of the unit-as-one's twelve one-worker compiles in this hold found the host busy
  and took base pages (`huge_pages` reads `system=9 busy=3`), which is its 115.51 ms; in the evening's other holds it
  measured 114.53 to 114.78 ms. By tiles the parse alone is 2.0 ms shorter (the unit's kernel arrays took 25 huge pages
  that the kernel cleared in the parse) and `check-input` 1.4 ms longer (it now takes those pages itself).

**The first version** (`tiles`: the kernels' arrays as long as the unit, each tile writing their start),
`scripts/run5.sh tiles pair-tiles ...`, two passes (`results/pair-tiles/`):

| | unit as one | tiles of 4,096 | of 1,024 | of 16,384 |
| --- | ---: | ---: | ---: | ---: |
| eight workers, MB/s | 325.1 | 338.9 | 337.8 | 338.0 |
| their user cycles | 966.9 M | 912.0 M | 914.3 M | 910.6 M |
| the parse at eight, ms | 22.43 | 9.66 | | |
| one worker, wall ms | 114.65 | 115.30 | 115.40 | 115.11 |

It was 0.5% slower alone: `check-input` took 0.53 ms more and the parse no less, since every array's first huge page
was still cleared for a tile's use. The workspace of `tiles3` removes that.

**Small units, one worker** (`scripts/small11.sh`, `time-runs` on CPU 2 in one hold, `results/small-units/`), the unit
as one against tiles of 4,096:

| unit | wall ms | user cycles | instructions |
| --- | --- | --- | --- |
| `tests/driver/alias_redefinition.c`, `-c`, 41 runs | 0.603 → 0.606 | 0.944 M → 0.944 M | 1,188,786 → 1,190,356 |
| `c_lexer.c`, `-fsyntax-only`, 21 runs | 54.33 → 53.31 | 255.9 M → 250.5 M | 665.3 M → 667.3 M |
| `main.c`, `-fsyntax-only`, 9 runs | 551.3 → 550.0 | 2,776 M → 2,771 M | 8,437 M → 8,444 M |

A unit of one tile pays 1,570 instructions; a larger one alone is as fast or faster.

**The same bytes** (in the session's cloud container, `scripts/twin.sh`): `sqlite3.c`'s and `main.c`'s objects by tiles
of 1, 64, 4,096 and 16,384 tokens are the unit's as one; the objects, stderr and exit statuses of c-testsuite's 220
programs and of the repository's 1,571 C files under `tests/` by tiles of 1 and 64, with `-Wall -Wextra`, are too.
`test-parser` compares every unit it checks by tiles of 1 and 64 with the unit as one: 1,204,227 tiles in its
alignments, none differing.

## 64 KB pages for a busy host's arenas

A busy host's arenas take base pages (buster#1561). `BUSTER_HUGE_PAGES=medium` (the `medium` tree's experiment)
advises them as on an idle host and advises the first page of every 2 MB a base page, so that no 2 MB page fits and
the kernel gives the largest size it has enabled for an advised mapping. The host's
`/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/enabled` knobs are all `never`; with the owner's leave, the
scripts set the sizes a configuration names to `madvise` inside the hold and put them back to `never` before it ends
(`results/*/switch.txt` has every change and the restore).

**The sizes** (`scripts/run7.sh medium pages-sizes 2 ...`, two passes, one hold, `results/pages-sizes/`):

| pages | eight workers, MB/s | user cycles | kernel cycles | faults | one worker, wall ms |
| --- | ---: | ---: | ---: | ---: | ---: |
| base pages (the busy host's policy; alone, 2 MB pages) | 323.27 | 967.0 M | 229.3 M | 56,056 | 114.56 |
| 16 KB | 325.07 | 950.9 M | 245.8 M | 24,169 | 123.99 |
| 32 KB | 325.96 | 956.8 M | 240.2 M | 19,094 | 120.33 |
| 64 KB | 338.94 | 960.7 M | 192.0 M | 17,132 | 118.73 |
| 128 KB | 338.53 | 974.3 M | 195.6 M | 17,258 | 118.83 |
| 16, 32 and 64 KB | 328.90 | 958.5 M | 235.5 M | 15,812 | 119.16 |

**64 KB against today, twice more:** `results/pair-pages/` (two passes): 335.1 MB/s against 328.0, kernel cycles
204.2 M against 223.6 M. `results/pair-both/` (the `tiles` tree, two passes): tiles of 4,096 with 64 KB pages 357.0 MB/s
against the unit as one with base pages 323.6, kernel cycles 187.7 M against 229.5 M, wall 212.3 ms against 230.7.

- **64 KB pages are 2% to 5% at eight workers**, and with the parser's tiles 10.3% together.
- **Smaller pages cost more than base pages** in kernel cycles, though they fault less.
- **Alone, 2 MB pages stay better** (114.6 ms against 118.7).
- The arenas of tables stay base pages in this experiment, about 5,000 of the 17,000 faults left.

In the session's cloud container (a 4-CPU virtual machine, Linux 6.18, where the compiler turns huge pages off;
`scripts/runs.py`, medians of 7 compiles): base pages 279.3 ms a compile with 85.6 ms in the kernel and 55,807 faults;
the `medium` experiment 230.8 ms with 45.8 ms and 17,142.

## The page policy as built

The policy as its pull request has it (`scripts/pages1.patch` over main `3f4ff4c7`, the `pages` tree, executable
`233bfec3badefd1a`): a busy host's arenas take the medium pages where the host's `hugepages-64kB/enabled` knob says
`madvise` or `always`, and base pages otherwise; the compiler reads the knob and turns nothing on.

**Its checks on the 9700X**, which is no virtual machine (`scripts/smoke12.sh`, one hold, `results/pages-smoke/`):
`test-lanes`, `test-checker-deferred` and `test-checker-driver --part 2/16` (the part with the policy's cases) pass;
`sqlite3.c` compiled with the busy test and the knob's reading forced each way (`BUSTER_TEST_HOST_BUSY`,
`BUSTER_TEST_MEDIUM_PAGES`) reports `system`, `busy` and `medium` and gives one object.

**The pair** (`scripts/run9.sh pages pages-final 3 ...`, three passes in turn, one hold, `results/pages-final/`): the
same executable with the knob `never` and with it `madvise`, set for the configuration's rounds and put back.

| | knob `never` | knob `madvise` |
| --- | ---: | ---: |
| eight workers, MB/s | 325.88 | 337.10 |
| their wall ms | 231.55 | 224.88 |
| their user cycles | 965.4 M | 968.6 M |
| their kernel cycles | 234.0 M | 196.8 M |
| their faults | 56,060 | 17,137 |
| their reports | 96 `busy` | 96 `medium` |
| their peak resident set | 188.0 MB | 193.9 MB |
| one worker, wall ms | 114.97 | 114.19 |
| its faults | 5,636 | 4,586 |

- **+3.4% at eight workers**, the kernel's cycles 16% fewer, the objects the same bytes (9 a pass of each configuration).
- **One worker is as before**: it is not busy and keeps its 2 MB pages. The knob gives its few advised mappings that no
  2 MB page fits 64 KB pages too, which is its 1,050 fewer faults. One of the 36 one-worker compiles with the knob on
  found the host busy and took the medium pages.
- The third configuration, `--deferred-bodies`, is the first again: on one lane the driver reads the bodies in source
  order (`time-process` says so), so it measured nothing of its own.

**A fault round** in the session's container (`scripts/pages-faults.py` with `pages-harness.c`, which builds
`lane.c` and its tests alone): 21 faults in the policy's code (the split's page, stride, rounding and end, the budget,
the two commit paths' hooks and their first byte, the tables, the knob's text, the choice of policy), each killed by
`test-lanes`' new checks.

## The reader by the parse's tiles

Four trees over the parser's pull request (`06321630`), each with switches in the environment so that one executable
is its own twin; `scripts/t2a.patch`, `t3.patch`, `t5.patch` and `t6.patch` are what each was built from. Every pair is
one hold, three passes in turn; the figures are medians of the passes.

| tree, hold | configuration | eight workers, MB/s | user cycles | kernel cycles | one worker, wall ms | peak alone |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| `t2`, `t2a-pair` | tiles alone (the pull request) | 341.68 | 907.7 M | 220.3 M | 114.11 | 238.2 MB |
| | the tree's columns derived in the parser's tile, in the parser's arena | 347.16 | 889.4 M | 210.1 M | 115.81 | 253.1 MB |
| `t3`, `t3-pair` | tiles alone | 340.68 | 909.0 M | 223.4 M | 114.59 | 240.0 MB |
| | the reader's sink: its counts and prefixes as each tile is parsed | 335.86 | 906.5 M | 231.8 M | 114.39 | 241.9 MB |
| | the columns in the parser's arena | 347.58 | 891.6 M | 206.8 M | 116.18 | 254.8 MB |
| | both | 350.49 | 883.9 M | 210.0 M | 116.35 | 256.8 MB |
| `t5`, `t5-pair` | tiles alone | 338.06 | 910.6 M | 228.0 M | 114.36 | 238.1 MB |
| | the sink (counts and prefixes) | 337.79 | 908.6 M | 231.7 M | 114.35 | 238.1 MB |
| | the sink with the traversal, on the scratch | 351.41 | 882.8 M | 216.4 M | 114.43 | 238.1 MB |
| | the expressions' walk by tiles (ends from the tree's roots) | 341.91 | 899.1 M | 225.6 M | 114.00 | 238.1 MB |
| | the traversal and the expressions | 350.15 | 874.4 M | 222.9 M | 114.38 | 238.1 MB |
| `t6`, `t6-pair` | tiles alone | 342.64 | 909.9 M | 220.9 M | 114.31 | 238.2 MB |
| | the sink with the traversal | 350.39 | 881.2 M | 211.6 M | 114.52 | 238.1 MB |
| | the sink and the walk's columns cleared a tile ahead | 339.74 | 913.4 M | 220.2 M | 114.77 | 238.2 MB |
| | the traversal and the expressions (ends from the parse's tiles) | 354.02 | 870.2 M | 211.3 M | 114.06 | 238.2 MB |
| | the traversal, the expressions and the clears | 356.29 | 876.3 M | 203.3 M | 114.40 | 238.2 MB |

Every configuration's 9 objects a pass are the same bytes (`objects.txt`).

| stage, ms alone → at eight (`t6-pair`) | tiles alone | the traversal and the expressions |
| --- | --- | --- |
| `parse` | 4.79 → 8.84 | 7.40 → 15.72 |
| `check-input` | 42.49 → 95.51 | 39.70 → 80.11 |
| `check-expressions` | 10.80 → 18.78 | 10.81 → 18.54 |

- **The tree's traversal derived as each tile is parsed** is the gain: +2.3% and +3.9% at eight workers in two holds,
  28 M user cycles a compile, the reader 14 ms shorter there for 7 ms more in the parse. In the parser's own arena it
  cost a compile alone 1.4% (15 MB more at its peak, 1,270 faults more); on the scratch, where the reader had it, a
  compile alone takes the same time and memory.
- **The expressions' walk by tiles** (each tile's classes, then its coded walk) takes 11 M user cycles off at eight
  workers, and with the traversal the pair is **+3.3%** (354.0 against 342.6 MB/s, 39.7 M user cycles fewer), a compile
  alone 0.2% shorter.
- **The counts and the prefixes in the sink** alone are within the passes' spread (2 to 3 M user cycles fewer, the
  kernel's a few M more in both holds); they come with the sink.
- **The walk's columns cleared a tile ahead** are within the spread too (356.3 against 354.0 MB/s at eight workers
  with 6 M more user cycles and 8 M fewer kernel cycles; 114.40 against 114.06 ms alone): built, checked and not kept.
  `scripts/t6.patch` has it, with its check and poison readings.

**What the clears' check found first.** By tiles whose ends were the tree's roots' (`t5`'s way, used for the clears
before `t6`), two of the repository's programs with old-style definitions (`tests/checker/musttail/0017.c`,
`tests/checker/non-prototype/merge.c`) had columns written ahead of their tile: an old-style definition's parameter
declarations are roots of their own, and the walk at the declarator writes at the body's brace. The parse's own tiles
end at declarations (or refuse the unit), and by them no program writes ahead; so the reader takes its tiles' ends from
the parse (`t6`).

**The same bytes** (the session's container, `scripts/twin_env2.sh` and `twin_opt.sh`): objects, stderr and statuses
of c-testsuite's 220 programs and the repository's 1,578 test programs, with `-Wall -Wextra`, by tiles of a
declaration and of 16 tokens with every piece on, are the unit's as one; `sqlite3.c`'s object by tiles of 1, 64 and
4,096 too. The clears were also run in their check reading (no entry written ahead) and their poison reading.

## What disturbed the runs

- **`results/tiles3-pair-invalid-option-not-passed/` measures nothing about tiles.** `scripts/pair7.sh` passed each
  configuration's option with a leading space (the options were split with `IFS=,`), so the compiler took
  ` --parse-tile=4096` for a second source file and compiled the unit by its units' path: the object is the same and
  every stage of the report reads 0.000. `scripts/pair9.sh` resets `IFS`; `results/tiles3-pair2/` is the pair.
- **The lock had 18 to 31 waiters all evening**, so each configuration set is one hold: the passes of a pair share the
  host's state, and the pairs of different holds are not compared with each other but for the unit-as-one figures above.
- **The busy test flipped three one-worker compiles** of `tiles3-pair2`'s unit as one, and one of `pair-pages`' (the
  `huge_pages` column of each `whole.tsv`).
- The logs' lines that name other sessions' holds of the lock are removed.

## The files

- `scripts/`: every script as run on the host, the patches each tree was built from, and the container's `runs.py`,
  `twin.sh`, `twin_env2.sh`, `twin_opt.sh` and the page policy's fault round. `t6-with-clears-local.patch` is the
  container's tree when the clears were taken out, with `--reader-tiles=` in place of the environment's switches.
- `results/<name>/`: a gauge's `whole.tsv` and `table.tsv` (or, for a pair, one directory a configuration and pass,
  `<configuration>.<pass>/whole.tsv`), the rows, the strays' files, `switch.txt` and `busy.txt`, and the per-run stage
  reports packed in `reports.tar.xz`.
- `results/*.log`: the builds' and the queues' logs.
