# Tier 0 shape-inlining measurements for PR 3637

[PR 3637](https://github.com/buster14a/buster/pull/3637) at `03d4e4af` compared with merge base `8e4d3287`. The compilers were built with official Clang 23.1.4 in Release for the Ryzen 7 9700X. The 11 interleaved compile pairs were pinned to CPU 2 under the shared Benchpress lock, using the frozen SQLite amalgamation and the candidate tree's compiler main.c.

| Workload and mode | Median wall ms, base → head |
| --- | ---: |
| SQLite, default | 15.345 → 15.403 |
| SQLite, shapes | 112.737 → 112.590 |
| Compiler main.c, default | 598.417 → 599.861 |
| Compiler main.c, shapes | 629.327 → 613.760 |

The separate lexer replay self-built the same candidate source tree using each compiler with both flag settings, then ran `benchmark-lexer src` three times per build. The table reports `c_tokenize`, median across those runs.

| Bootstrap compiler and mode | Wall ms | Cycles/byte | Instructions/byte |
| --- | ---: | ---: | ---: |
| Base, default | 578.381 | 48.694 | 63.531 |
| Head, default | 576.204 | 48.517 | 63.531 |
| Base, shapes | 591.213 | 49.776 | 64.785 |
| Head, shapes | 581.971 | 48.988 | 63.532 |

The head's shapes-enabled lexer took 1.56% less time than the base's shapes-enabled lexer and 1.00% more time than the head's default lexer. The replay covers compile cost and self-built lexer throughput. Generated SQLite and Lua program runtime was outside these runs.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
