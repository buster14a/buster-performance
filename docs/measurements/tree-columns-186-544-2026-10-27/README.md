# The tree's columns derived once (buster #186, #544), 2026-10-27

Evidence for [buster14a/buster#640](https://github.com/buster14a/buster/pull/640). That PR replaces two derivations
with one (`parse_tree_columns`, three passes over the parents):
- the parser's postorder passes, `parse_postorder_sorted`, five passes with the subtree sizes;
- the checker's reader's own derivation of positions, subtree ends and child links, two passes and three fills.

The C driver now parses `tree_only`, and the reader derives the traversal into its scratch. The PR also decides #544:
the tree-less checker can't pay, by the counts and the bound in buster's `docs/c-parser-fragments.md`.

## Revisions and builds

| Name | buster commit | What it is | `build/compiler` sha256 |
| --- | --- | --- | --- |
| main | `43030b89` | the PR's base | `ccc5fdeca3a72d22a4f959b758a994b392d3d77e9e5794ca8ca31bcfc1c7bf2a` |
| head (v1) | `24972dae` | the first version: one fused backward pass | `04a87d9a955bdb7cacbb87bdf853234e746fbc5453007a00fe318c5e62e94d8e` |
| head2 | `4da1b479` | the three passes | `cf62fc79098ad2732e5b6c1f265b92faf9d72cff3894a6dea512f3371f1d2947` |
| head3 | `f1db0e4d` | head2 with the reader's temporaries popped once derived: the PR's code | `f461469a1f5405186456a0f544dbe4c60a988504b3e7340735ba08102918811e` |
| main-g | `43030b89` | main with `-g`, for the walk's profile | `a99e1ef7476642b0d5429f3564a2d53dae60079e8b9f58ad28f76283812ac166` |

The PR's later commits are docs and a merge of main `92c025e7`. Each tree went to the host by `git archive` of its
commit. Each was built there by `build.sh` with `BUSTER_DEBUG_INFO=0` (main-g with `-g`), under the lock.

## Host

The Ryzen 7 9700X (`benchpress`): Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9. Every run was pinned to CPU 2, under
`~/buster-fast-bench/exclusive.sh` (`scripts/lock.sh`).

## Inputs

| Input | Identity |
| --- | --- |
| the frozen `sqlite3.c` of `-c`'s A/B and the walk's profile | `/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`, sha256 `0a409f16...5e23d`, #520's options (`scripts/measure.sh`) |
| `sqlite3.c` of `benchmark-parser` | sha256 `b1dd5d74ec7f29055a6684fa06fb3c2f6821c87dd38f9a458dfd2e8a1db28189`, 706,586 parser tokens, the host's system headers |
| the libc corpus | the 733 files of Zig 0.14.1's `lib/libc` that clang accepts (#186's choice). The list's sha256 is `273746d6...d718ef`, the files' concatenation's `c31db339...2f71`. |
| `main.c` | main's own sources, with `clang -dM -E -march=native -fwrapv -funsigned-char` as `--predefines` (sha256 `40c31757...4c58`), 4,699,318 parser tokens |
| the micro-benchmark's parents | `sqlite3.c`'s tree as `test-parser --print-tree` printed it on a laptop build of head (v1): 706,586 tokens, sha256 `ec66578c...adf3` |

## What was run

- **`a-b/ab4.txt`, the PR's numbers:** `scripts/measure.sh main head3 ab4`, one hold of the lock. `-c` of the frozen
  `sqlite3.c` by each build, in 8 rounds alternating which goes first, each a warm-up and then `perf stat -r 3`
  (task-clock, user and kernel cycles, user instructions, page faults). Every object was compared with main's first
  (`cmp`), and all were the same. Then 11 rounds of each with `--time-stages --lanes 1`, alternating, for the stages'
  medians.
- **`a-b/ab2.txt`:** the same for head2, in another hold.
- **`benchmark-parser/`:** `benchmark-parser --only stages` (21 interleaved passes after a warm-up) on each input.
  `main-and-v1/` has two processes each of main and of head (v1) (`scripts/bench-parser.sh`). `final/` has one
  process of head3 (`scripts/hold2.sh`). The rows that matter:
  - `postorder-sorted`, main's postorder passes;
  - `tree-links`, the reader's old derivation, now `parse_tree_links`;
  - `tree` and `tree-sizes`, the new passes;
  - `postorder`, the walk.
- **`walk/`:** `perf record -F 20000` of 5 `-c` compiles of the frozen `sqlite3.c` by main-g (`scripts/hold3.sh`).
  `walk-symbols.txt` has `perf report --sort symbol`, and `walk-lines.txt` `check_input_expressions`'s samples by
  source line. Main's lines 3646 to 3681 of `c_check_input.c` are the walk's gathering of its children's values,
  1.08% of the samples. The walk itself is 9.70%.
- **`micro/`:** `tree.c` times variants of the derivation on the dumped parents and checks each one's columns against
  the old passes'. Built with `clang -O3 -march=native -fno-strict-aliasing -fwrapv tree.c -o tree` and run as
  `taskset -c 2 ./tree sqlite.parents.txt`, twice per version under the lock. `results-9700x.txt` has the outputs.
  The variants:
  - v1, one fused backward pass;
  - v2, the last children by a read-modify-write;
  - v3, each end's count as its chain's length;
  - v4, two backward passes;
  - v5, the three passes, as built;
  - v6 and v7, the counts kept in the positions column with an AVX-512 forward pass;
  - v8, v5 with the counts in the positions column;
  - v9, three backward passes.

## Results

`-c` of the frozen `sqlite3.c`, main against head3 (`a-b/ab4.txt`):

| | main | head3 | change |
| --- | ---: | ---: | ---: |
| user instructions | 1,751.69 M | 1,713.41 M | -2.19% |
| user cycles | 737.04 M | 724.81 M | -1.66% |
| task-clock | 154.48 ms | 152.28 ms | -1.42% |
| page faults | 2,070 | 1,890 | -8.70% |
| the parse stage | 9.480 ms | 7.427 ms | -2.053 ms |
| the `check-input` stage | 63.824 ms | 63.088 ms | -0.736 ms |

head2 in `ab2.txt` ran -2.33% user cycles. The two builds do the same work, so the gap between them is code
placement.

`benchmark-parser`, cycles a token:

| Input | main's postorder passes | the reader's derivation | together | head3's `tree` |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 13.43 | 15.09 | 28.52 | 10.82 |
| the libc corpus | 11.41 | 8.10 | 19.51 | 8.26 |
| `main.c` | 14.74 | 15.35 | 30.09 | 12.18 |

## Limitations

- **Placement.** Separate builds of the same work differ by up to about 0.7% in `-c`'s cycles. head2 and head3 differ
  by that much, as does `check-program`, whose code the PR doesn't change.
- **The benchmark's harness.** It times `tree-links` alone, on warm arrays. In the compile, the reader ran that code
  inside `check_input_run`, after its fills.
- **Lock messages left out.** The benchmark and A/B outputs keep only the lines the tools print (benchmark-parser's
  rows and headers, `measure.sh`'s summaries and rounds, `build.sh`'s lines). `exclusive.sh`'s waiting messages,
  which name other sessions' commands, are left out.
- **The micro-benchmark's outputs** were copied from the terminal: they were printed, not written to files.

Generated by [Claude Code](https://claude.ai/code) for buster14a/buster#640.
