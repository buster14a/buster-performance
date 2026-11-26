# Exact floating conditionals on the Ryzen 7 9700X

[PR 3624](https://github.com/buster14a/buster/pull/3624) at `9ceb557e` compared with merge base `8e4d3287`. Both compilers used official Clang 23.1.4 with Release for `znver5`. The historical [random-data harness](https://github.com/buster14a/buster-performance/tree/cc38ca9708f522fd26eacab3b5234dbfa71c131b/docs/measurements/constant-arms-2678-2026-11-15/harness/run3) compiled its two-arm kernels with Tier 1 strict, `-O2`, and vectorization disabled. Each configuration executed five alternating base/head pairs on CPU 2 under the shared Benchpress lock. The integer- and floating-result checksums matched on every pair.

| Target and kernel | Median user cycles, M, base → head | Median paired cycle change | Median paired instruction change |
| --- | ---: | ---: | ---: |
| znver5 floating sum | 231.24 → 261.68 | +13.18% | +17.88% |
| x86-64 floating sum | 231.20 → 280.40 | +21.30% | +53.63% |
| znver5 integer control | 141.99 → 151.91 | +2.39% | 0.00% |
| x86-64 integer control | 142.04 → 142.02 | −0.01% | 0.00% |

The floating arm conversion regresses this random-data scalar workload at both output targets. The measurement uses one code placement per build. The integer control shows why the independent retired-instruction count matters. The raw archive preserves stdout, digest checks and perf counters for every pair.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
