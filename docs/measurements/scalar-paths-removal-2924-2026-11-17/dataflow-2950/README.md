# #2950: dataflow's AVX-512 paths against their scalar twins, runs 1 to 6

#2924's dataflow gate ([`../c-dataflow-gate/`](../c-dataflow-gate/)) found the vector paths slower than their scalar
twins in three classes of real functions. These runs found why and measured the fixes.

- **Host:** the 9700X, every run under `exclusive.sh`, pinned to CPU 2.
- **Builds:** Release builds of main `8bd7f27ec` with the run's patch, which each run's directory holds with its script.
- **Summaries:** IR dataflow's logs are summarized by [`../c-dataflow-gate/summarize.sh`](../c-dataflow-gate/summarize.sh).

| Run | What | Finding |
| --- | --- | --- |
| [`exp1/`](exp1/) | knobs: both paths solving one prepared copy (`BUSTER_DF_SAME_COPY`), and a masked-blend bypass of the previous block's row (`BUSTER_DF_BYPASS`) | The class-2 loss follows the path, not the copy: 1.106 own copies, 1.105 one copy. The blend makes it worse (1.46). |
| [`exp2/`](exp2/) | the bypass as a branch; `perf stat` of the new mid-size workloads alone (`BUSTER_DF_WORKLOAD`) | `mid-sparse-nested` 354 → 143 ns (scalar 198); `ls_stlf` 62 M → 6.4 M. The sweep was bound by the 64-byte store-to-load forward of each block's row. |
| [`exp3/`](exp3/) | IR dataflow on sqlite3.c with each candidate: the branch bypass, the operands' range test (`BUSTER_DF_RANGE`), the lighter set (`BUSTER_DF_SET`), and all three | All three: prepare + solve 0.687, solve 0.629. |
| [`exp4/`](exp4/) | the production tree (`2950-a.patch`, no knobs), and the knobs with the IR's vector checks in both preparations (`BUSTER_DF_CHECKS`) | Production: solve 0.584, prepare + solve 0.670. With the checks equal, dataflow's own preparation was at parity (0.997). |
| [`exp5/`](exp5/) | `2950-b.patch`, with the empty-row early return, and the same with both preparations on the vector checks (`-checks`) | Every class wins the solve. With the checks equal, prepare + solve still lost 2–4% with phis. |
| [`exp6/`](exp6/) | `2950-c.patch`, which gathers only for cross-block operands and once per phi batch, and its `-checks` twin | `c`: solve 0.586, prepare + solve 0.604; one class loses (below). `c-checks`: every class wins (0.71 to 0.993; 0.856 in total). |

The commit is `2950-c.patch` with its documentation. Run 6's one losing class is the preparation of one- and two-block
functions with no value across blocks: 134 forms, about 50 cycles each, 9%. It is the IR's own checks. The scalar
preparation runs `ir_check_rows` and `ir_check_graph`'s scalar twins, which are faster on functions that small. With
both preparations on the vector checks (`c-checks`), that class is at 0.993.

Synthetic workloads, production tree (`exp4/bench-prod-*.log`), median ns per solve over three processes:

| Workload | Scalar | AVX-512 | AVX-512 / scalar |
| --- | --- | --- | --- |
| small-diamond (16 blocks, 127 values) | 77.6 | 35.5 | 0.46 |
| mid-sparse-nested (48 blocks, 24 values) | 194.4 | 135.5 | 0.70 |
| mid-sparse-diamond (96 blocks, 60 values) | 334.7 | 279.0 | 0.83 |
| medium-nested (256 blocks, 1025 values) | 10,583 | 3,673 | 0.35 |
| large-local (4096 blocks, 4097 values) | 1,320,714 | 441,310 | 0.33 |
| large-dispatch (4096 blocks, 4097 values) | 776,433 | 256,500 | 0.33 |
