# Compiler throughput and output size for guarded vector unrolling

The same [PR 3633](https://github.com/buster14a/buster/pull/3633) head `e5826bec` and merge base `8e4d3287` compiled the frozen SQLite amalgamation and the candidate tree's `src/buster/compiler/main.c` with opt-in `--tier1-passes=+vectorize,+unroll`. Both compilers used Release for `znver5` with official Clang 23.1.4. Each workload ran 11 interleaved pairs on CPU 2 under the shared Benchpress lock.

| Workload | Median wall ms, base → head | Median user cycles, M, base → head | GNU size text column, bytes, base → head |
| --- | ---: | ---: | ---: |
| SQLite | 619.082 → 618.942 | 3,333.0 → 3,334.1 | 1,622,741 → 1,624,933 (+0.135%) |
| Compiler main.c | 1,429.799 → 1,431.195 | 7,604.2 → 7,611.9 | 2,680,767 → 2,683,391 (+0.098%) |

The measured base-to-head differences in compile wall time were within 0.1%. Both comparisons are between revisions with unrolling enabled. Scripts, object-size listings and complete timing records are included.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
