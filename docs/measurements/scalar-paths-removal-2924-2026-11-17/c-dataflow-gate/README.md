# Dataflow's gate (#2924, phase C3)

Whether dataflow's AVX-512 paths are at least as fast as their scalar twins, before the twins are deleted:
`dataflow.c`'s liveness solver, and `ir_dataflow.c`'s preparation and solve, which select their arms by one flag.

- **Build:** buster main `8bd7f27ec` (`logs/commit.txt`), Release, built on the 9700X under the lock
  (`logs/build-main.log`; `logs/compilers.sha256`).
- **Runs:** [`gate.sh`](gate.sh), each run under `exclusive.sh`, pinned to CPU 2:
  - `benchmark-dataflow --only scalar` and `--only avx512`, five processes each, alternating;
  - `benchmark-dataflow` (both, interleaved), three processes;
  - `test-ir-source --dataflow-benchmark` on `tests/dataflow/edges.c`, and on sqlite3.c with the correctness
    manifest's options (the 9700X corpus `preprocessor-391e729af658`).
- **Summaries:** `bench-summary.txt` (from the `benchmark-dataflow` logs), and `summary-edges.txt` and
  `summary-sqlite.txt` (by [`summarize.sh`](summarize.sh)). `logs/ir-sqlite.log.xz` is the 179 MB log, compressed.

## The synthetic benchmark: AVX-512 wins at every size it has

Median ns per complete solve, each process's figure:

| Workload | Scalar (only) | AVX-512 (only) | AVX-512 / scalar |
| --- | --- | --- | --- |
| small-diamond (16 blocks, 127 values) | 77.6–80.3 | 48.8–49.1 | 0.62 |
| medium-nested (256 blocks, 1025 values) | 10,367–11,010 | 3,669–3,685 | 0.35 |
| large-local (4096 blocks, 4097 values) | 1,305,151–1,310,067 | 442,250–458,331 | 0.34 |
| large-dispatch (4096 blocks, 4097 values) | 766,477–768,848 | 256,351–257,396 | 0.33 |

The interleaved runs agree. The benchmark has no workload between 16 and 256 blocks, nor any with 64 values or
fewer, so it does not cover the class below.

## Real functions (sqlite3.c, 2602 functions × 3 forms): AVX-512 wins in total, loses in classes

Hardware cycles per function, summed over every form (medians of 21 passes):

| Operation | Scalar | AVX-512 | AVX-512 / scalar | Forms AVX-512 loses by > 2% |
| --- | --- | --- | --- | --- |
| solve | 5,819,676 | 4,365,510 | 0.750 | 2,658 of 7,806 |
| prepare + solve | 129,181,506 | 115,517,943 | 0.894 | 3,370 of 7,806 |

`tests/dataflow/edges.c` (4 small functions, 12 forms) loses in total: solve 1.188, prepare + solve 1.223.

The classes AVX-512 loses (from `summary-sqlite.txt`):

1. **The phi live-out restoration** (`ir_dataflow_set`'s vector arm, after the solver): solve with phis is
   1.12–1.15× slower at 3–128 blocks (684 of 698, 1,218 of 1,452 and 305 of 360 forms), and 0.38–0.56× above.
2. **The solver itself at 33–128 blocks with 64 values or fewer, no phis:** 1.10× (152 of 208 forms). It retires
   41% fewer instructions (5,567 against 9,369 a solve) at half the IPC (2.78 against 5.20). That is memory or
   placement, not the code's work. Each path solves its own prepared copy, so the copies' placement is not yet
   ruled out.
3. **Preparation of the smallest functions:** prepare + solve is 1.09× slower at one or two blocks (757 of 1,060 forms), and
   1.10–1.27× with no cross-block values.

IR dataflow has no production caller: only its own test and benchmark run it. Tier 1 already runs `dataflow.c`'s
AVX-512 solver by default; its scalar arm runs only in Tier 1's own scalar twin tests.
