# Tier 1's machine rows without staging copies, main against head on the 9700X (2026-11-04)

The evidence for [buster#1283](https://github.com/buster14a/buster/issues/1283) and [buster#1332](https://github.com/buster14a/buster/pull/1332). By Claude, at David's request ([the session](https://claude.ai/code/session_01TiDLnwG32Yjkqq4RG8yWvU)).

## What was measured

#1332 makes `tier1_emit_cfg_row` place a machine row's `VECTOR(j)` roles one at a time:
- a vector result is written in its destination;
- a vector operand stays in its own register where the row doesn't write it;
- staging through zmm16 + j is left for the rest.

Before #1332, every vector operand was copied into zmm16 + j and every vector result out of zmm16.

`measure-tier1-rows` (buster's `src/buster/compiler/tier1_rows_measure.c`, documented in `docs/commands/tier1.md`) builds three programs four ways and times them. The three programs:
- **rows:** `test-checker-driver`'s machine rows' unit (`c_check_tier1_driver_test.c`'s `check_test_tier1_rows_source`), 10000 rounds of its other unit's calls, hashed;
- **scan:** a lexer's byte classes over a 1 MiB C-like text, by byte vectors and byte compares into masks, 200 passes;
- **lexer:** the compiler's own lexer, `c_lexer_benchmark.c`, as `benchmark-lexer src/buster/compiler/c_lexer.c` runs it (33455 tokens, 21 timed passes each of `c_tokenize` and `c_tokenize_scalar`, after the corpus check).

The four builds:
- this tree's Tier 0;
- main's `--tier1`;
- this tree's `--tier1`;
- clang -O2.

Every unit is compiled at `-march=znver5`; each program's main is compiled by clang -O2. Every build's output was checked to agree before any timing: the rows' hash, the scan's counts, and the lexer's corpus check and token count.

## Host and revisions

`9700x/host.txt` gives the runner's identity line, CPU model and clang:
- `9700X/6.18.50-2-lts/0xb404038/gcc-16.2.1/glibc_2.44`;
- AMD Ryzen 7 9700X;
- clang 23.1.4.

The measurement ran in [the 9700X job of #1332's run 41869868903](https://github.com/buster14a/buster/actions/runs/41869868903/job/126727819799), under the shared host lock, pinned to the job's first CPU.

| Role | Commit |
| --- | --- |
| main (`--tier1 (base)`) | `48dcdc86932b686883d66cb3bb5def1bcb7880d3`, built in a worktree by `./build.sh --config Release`, `BUSTER_HOST_ARCH=znver5` |
| head | `070889c709cea24e4b68a2d506c15facfce8d76b` (#1332) |

The command, from `9700x/measure-tier1-rows.log`, which holds the step's whole output: every run's line (`tier1-rows-run`) and the tables.

```sh
taskset -c "$cpu" ./build/compiler measure-tier1-rows --runs 11 --clang clang --base "$ab/base/build/compiler" --march znver5 --lexer src/buster/compiler/c_lexer.c --directory /tmp
```

There was one warm-up round, then 11 rounds of every (program, build) pair in an order that rotates by round. Each run is a whole process, timed from its exec, with user cycles and instructions from perf_event_open.

## Moves around the rows, counted

These come from each Tier 1 build's `--tier1-report`. Main doesn't count rows or row moves (`none`); its records differ from head's by the moves removed.

| Unit | main records | head records | rows | head `row_moves` | main's moves (head's + records saved) |
| --- | ---: | ---: | ---: | ---: | ---: |
| rows | 5658 | 5526 | 58 | 18 | 150 |
| scan | 281 | 255 | 11 | 0 | 26 |
| lexer | 26697 | 26457 | 116 | 73 | 313 |

The rows unit's 150 moves are also main's object's register-to-register `vmovdqa64` count, the form row moves take. Head's 18 equal its object's count too (counted in a cloud container from the same sources).

## Run time, medians of 11

| Program | Tier 0 | `--tier1` (main) | `--tier1` (head) | clang -O2 | head / Tier 0 | head / main |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| rows, ms | 20.66 | 24.84 | 24.83 | 5.23 | 1.202 | 1.000 |
| rows, user cycles, M | 113.89 | 137.07 | 137.08 | 28.48 | 1.204 | 1.000 |
| rows, instructions, M | 117.10 | 139.02 | 136.60 | 26.27 | 1.167 | 0.983 |
| scan, ms | 54.14 | 32.80 | 31.63 | 4.78 | 0.584 | 0.964 |
| scan, user cycles, M | 299.08 | 180.87 | 174.25 | 25.55 | 0.583 | 0.963 |
| scan, instructions, M | 1254.05 | 716.64 | 644.55 | 103.87 | 0.514 | 0.899 |
| lexer, ms | 142.75 | 156.82 | 157.24 | 6.83 | 1.101 | 1.003 |
| lexer, user cycles, M | 790.38 | 867.94 | 870.66 | 36.70 | 1.102 | 1.003 |
| lexer, instructions, M | 1474.40 | 1285.38 | 1273.45 | 134.52 | 0.864 | 0.991 |

Within those runs, the lexer's own `c_tokenize` medians were:

| Build | cycles/B |
| --- | ---: |
| Tier 0 | 119.5 |
| main | 141.8 |
| head | 141.5 |
| clang -O2 | 0.784 |

## Reading

- **The scan,** whose rows sit in its loop, takes 3.7% fewer cycles and 10.1% fewer instructions by head than by main.
- **The rows unit and the lexer** retire 1.7% and 0.9% fewer instructions. Their cycles are unchanged (within 0.3%).
- **The removed moves are a small share** of Tier 1's vector code:
  - Every intrinsic is a call to its `static inline` wrapper (buster#1282); each 64-byte vector argument is copied between frame objects by eight 8-byte general-register moves, and through zmm16 and on for the call.
  - Vector locals stay in memory and are zeroed every iteration.
  - Zen 5 renames most register-to-register vector moves, so a removed `vmovdqa64` saves an instruction more than a cycle.
- **Tier 1 is slower than Tier 0** on the rows unit (1.20×) and the lexer (1.10×), and faster on the scan (0.58×). That gap isn't the rows' placement: main shows it too.

## The merged head (`4a98ff9b`), again on the 9700X

After main gained buster#1280's 4- and 8-byte vectors, #1332 merged it (head `4a98ff9b`, adding the review's gather and complex multiplication fixtures, test code only). The same step ran against that head's base, main `2244e4e7879b7559569c738dde25102728abf7bc`, in [run 41889112152](https://github.com/buster14a/buster/actions/runs/41889112152/job/126796248955), on the same host. `9700x-4a98ff9b/` has its whole log and host line.

| Unit | main records | head records | rows | head `row_moves` | main's moves |
| --- | ---: | ---: | ---: | ---: | ---: |
| rows | 5658 | 5526 | 58 | 18 | 150 |
| scan | 281 | 255 | 11 | 0 | 26 |
| lexer | 26724 | 26482 | 118 | 75 | 317 |

| Program | Tier 0 | `--tier1` (main) | `--tier1` (head) | clang -O2 | head / Tier 0 | head / main |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| rows, user cycles, M | 116.01 | 137.10 | 137.07 | 28.48 | 1.182 | 1.000 |
| rows, instructions, M | 117.10 | 139.02 | 136.60 | 26.27 | 1.167 | 0.983 |
| scan, user cycles, M | 299.12 | 180.24 | 173.62 | 25.22 | 0.580 | 0.963 |
| scan, instructions, M | 1254.05 | 716.64 | 644.55 | 103.87 | 0.514 | 0.899 |
| lexer, user cycles, M | 780.16 | 871.04 | 868.80 | 36.88 | 1.114 | 0.997 |
| lexer, instructions, M | 1474.40 | 1287.15 | 1274.93 | 134.52 | 0.865 | 0.991 |

The two runs agree: the scan takes 3.7% fewer cycles and 10.1% fewer instructions, and the rows unit and the lexer the same cycles with 1.7% and 0.9% fewer instructions. With #1280, the lexer has two more rows (118), and main's moves around them are 317.

## Limitations

- This is one job's 11 rounds on one CPU.
- The base and head compilers are separate builds; neither unit's placement was varied across code alignments.
- The lexer's corpus is one file, chosen to keep the PR job short.

The cloud container that wrote #1332 has no hardware counters. Its runs are correctness evidence only and aren't recorded here. In that container, 300 generated programs of 64-byte vector operators and row builtins were each built by `--tier1` by both paths, with and without rematerialization. All 1200 builds printed clang -O0's output.
