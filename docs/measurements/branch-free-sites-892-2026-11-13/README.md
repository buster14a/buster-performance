# Branch-free forms at `-c sqlite3.c`'s mispredicted sites, Buster #892

Compiler issue: [#892](https://github.com/buster14a/buster/issues/892). Compiler PR: [#2655](https://github.com/buster14a/buster/pull/2655) (branch `claude/upbeat-shannon-nu1fs0`).

## Sources

- **Base:** main `26f0bb0e1ab0ae8fc0a7c119064796dfd4b0d5fa`, a worktree of a fresh clone.
- **The change:** `3657eb0431973f7898b30710601510c177d919d8` (tree `1a39c9979bcd6fef6c552da009a6fd39cd904ae5`), main with
  `noA-final.patch`. On the host it is the tree `head2`: `git add -A && git write-tree` there printed the same tree id.
- **The change with check_graph_run's blocks** (item 6, not taken): main with `final.patch`, the tree `head`
  (`9c4b50b25daec7aafd0b592733ce20c7a340cc09` by the same check). It is the change plus `final.patch`'s `c_checker.c`
  hunk; that commit was amended away before any push.
- **Earlier builds, kept for what they showed:**
  - `head-first`: the blocks plus the forms of the change, and a split of `check_common_evaluated_tree`'s roots loop
    that was dropped;
  - `head2-first`: the change before its last comments, the same code.

Each was built with `./build.sh` (Release, `-O3 -g`, `-march=native`, which is `znver5` there), one locked build each.
`results/builds.txt` has the builds' status and time lines. The placements are full builds with
`BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=1040` and `=2080` (#1233), each in a worktree of its own
(`scripts/placements.sh`, `scripts/head2-placements.sh`).

## Host and method

The Ryzen 7 9700X (`benchpress`), pinned to CPU 2 (governor `performance`), perf 7.2.9, LLVM's `llvm-symbolizer`
(`results/*/host.txt`). Every build, test and measurement ran through `~/buster-fast-bench/exclusive.sh`, one hold per
run. The runs from the third main run on write the holder's line, the owner file's first, to a receipts file as they
take the lock:
- `holds.txt` in `main`, `head`, `head2`, `abtr-p1`, `abtr-p2` and `stages-s1`;
- `objects.holds`, for the two object comparisons behind `head` and `head2` (main's hashes in `main` are from them).

The earlier runs (`main-first`, `main-second`, `head-first`, `head2-first`, `ab-r1`, `ab-a1`, `tr-t1`) kept no
receipts.

`ab-r1` and `ab-a1` held the lock around a series of rounds, against the per-run rule. They are kept only for the
huge-page trap below, and no figure in buster's documentation comes from them.

The workload is `-c --lanes 1` of the frozen corpus's `sqlite3.c`, with the CI's defines and the corpus's pinned
predefines and headers, from a run root whose `corpus` links `/var/lib/buster-9700x/corpora/preprocessor-391e729af658`.

- **Counters** (`scripts/lbr.sh`): `perf stat -x, -r 11` of
  `{cycles:u,instructions:u,ex_ret_brn:u,ex_ret_brn_misp:u,ex_ret_msprd_brnch_instr_dir_msmtch:u}` (`stat.csv`) and
  `{cycles:u,instructions:u,ex_ret_brn_tkn:u,ex_ret_brn_tkn_misp:u,ex_ret_brn_ind_misp:u}` (`stat2.csv`).
- **Sites** (the same script): `perf record -j any,u -e cycles:u -c 200003` over 8 compiles.
  - `perf script -F brstacksym` is reduced to every LBR entry's from-site, all entries and the mispredicted ones
    (`sites.raw`).
  - The 150 sites with the most mispredicted entries (`sites.top`) are symbolized with
    `llvm-symbolizer --inlining` on the measured executable (`sites.sym`).
  - `scripts/sites.py` prints them by source line.
- **Objects** (`scripts/objects.sh`): the object and diagnostics of `-c` by default, `--lanes 1`, `--scalar`,
  `--verify` and `-g`, and `-fsyntax-only -Wall` of the compiler's own `main.c`, hashed (`objects.sha256`), with their
  statuses (`objects.status`).
- **Time over placements** (`scripts/abtr2.sh`, `abtr-p2`). This is `docs/profiling.md`'s #509 method:
  `compiler ab --rounds 3 --cpu 2 --lock` of `time-runs --runs 3 --copies 3` over main, the change, the change with
  the blocks, and main again. Each build is at the checker offsets 0, 1040 and 2080, and runs from fresh copies on
  tmpfs. Each round is one locked `time-runs` process. `abtr-p1` is the same without the change alone.
- **Stages** (`scripts/stages.sh`, `stages-s1`). `compiler ab --rounds 12 --cpu 2 --lock` of `--time-stages` runs of
  main, the change with the blocks, and the change. Each run is from a copy made on tmpfs just before it
  (`scripts/fresh.sh`), in its own hold.

The logs keep only the lines these scripts and tools print. Every other line, such as the lock's messages about other
sessions' runs, is dropped by an allowlist of line shapes (`results/statuses.txt` has each run's status line).

## Results

**Objects:** the change's are the same bytes as main's in every mode, and so are those of the change with the blocks
(`objects.sha256` in `main`, `head`, `head2`).

**Counters**, `perf stat -r 11`, main's third run (with receipts) against the change:

| | main | the change | |
| --- | ---: | ---: | ---: |
| mispredicted branches | 3,606,688 | 3,425,535 | −5.0% |
| per 1,000 instructions | 2.667 | 2.510 | −5.9% |
| mispredicted taken | 1,912,433 | 1,795,634 | −6.1% |
| retired branches | 204,949,708 | 204,407,474 | −0.3% |
| instructions | 1,352,147,171 | 1,364,757,460 | +0.9% |

Main's first run had 3,604,750 mispredicted, and its second 3,613,287. The second ran between the placement builds,
with user cycles spread 1.2% over its 11 runs.

**Sites.** The LBR's mispredicted entries, at main's third run (14,941 of 388,838 entries) and at the change (14,103 of
391,607). Lines are main's.

| site | main | the change |
| --- | ---: | ---: |
| `parse_brackets_avx512`, `c_parser_impl.c:7690`, `:7694` | 298 | 0 |
| `check_input_binding_answers`, `c_check_binding.c:540` | 151 | 0 |
| `check_input_discarded_set`, `c_check_binding.c:98`, `:104` | 73 | 0, and 19 at its separators' loop |
| `tier0_select_vector_entries`, `tier0.c:13700` | 43 | 0 |
| `check_common_next_op`, `c_check_common_warnings.c:4570` | 142 | 0 |
| `check_common_next_token`, `c_check_common_warnings.c:4508` | 136 | 0 |
| `check_common_unreachable`, `c_check_common_warnings.c:9335` | 101 | 0 |
| `check_program_reference_roots`, `c_check_program.c:3376` | 72 | 0 |

**Time over placements** (`abtr-p2`), each round's medians against main's, with the range over the placements:

| round | the change: user cycles | its range | the change with the blocks | main again |
| --- | ---: | ---: | ---: | ---: |
| 1 | −0.54% | −1.04% to −0.24% | −0.31% | +0.10% (−0.34% to +0.29%) |
| 2 | −0.42% | −0.55% to −0.20% | −0.27% | −0.18% (−0.42% to +0.15%) |
| 3 | −0.56% | −0.70% to −0.32% | −0.36% | −0.03% (−0.28% to +0.35%) |

Wall time: the change −0.46%, −0.45% and −0.35%; main again +0.03%, −0.26% and +0.05%.

**Stages** (`stages-s1`), medians of 12 runs, in ms:

| stage | main | the change with the blocks | the change |
| --- | ---: | ---: | ---: |
| check-expressions | 11.411 | 11.230 | 11.470 |
| lower.statements | 7.691 | 7.952 | 7.774 |
| tier0 | 5.417 | 5.363 | 5.351 |
| total | 124.039 | 123.555 | 123.296 |

## Item 6: the graph run's blocks

The blocks take `check_graph_run`'s nodes 64 at a time, a block's leaves first.

What they remove:
- the leaf test's site (155 entries at main);
- 7.7 M instructions;
- 0.24 ms of `check-expressions`.

But the compile misses as many branches (3,433,952 against 3,425,535 without them). Over the placements the change
with them is about 0.2% slower than the change without them, in every round. The LBR's totals by function move
between builds' layouts: `check_graph_run` has 579 mispredicted entries at main's first run, 614 at its second, 564
in `head-first` and 461 in `head2-first`.

## The huge-page trap

`ab-r1` and `ab-a1` ran each executable in place many times. The change's file had its text collapsed into file huge
pages: `peak-rss-start-kb` was 5,636 against 1,908 to 1,918, user time about 3 ms lower and system time about as much
higher. Their stage tables are confounded that way. `tr-t1` (`scripts/tr.sh`, one placement, fresh copies) and
everything after it run from fresh copies.

## Limitations

- One host and one workload, `sqlite3.c`'s `-c`.
- The placements move the checker's section (`BUSTER_CHECKER_OFFSET`); the parser's and Tier 0's code move only as
  the section's size moves them.
- The LBR records taken branches only, so a site's not-taken misses are counted by the totals alone.
