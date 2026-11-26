# Inline assembly control-flow replay for PR 3652

[PR 3652](https://github.com/buster14a/buster/pull/3652) at `2146c7d3` compared with merge base `5ce76f08c` on the Ryzen 7 9700X. The compilers used official Clang 23.1.4 in Release mode at `znver5`. The [historical asm goto kernel](https://github.com/buster14a/buster-performance/tree/cc38ca9708f522fd26eacab3b5234dbfa71c131b/docs/measurements/asm-goto-direct-2351-2026-11-12) ran 50 million iterations per sample at output targets `znver5` and `x86-64`. Five alternating base/head pairs per tier and target ran on CPU 2 under the shared Benchpress lock. Every result matched.

| Output target and mode | Median user cycles, M, base → head | Median paired cycle change | Median paired instruction change |
| --- | ---: | ---: | ---: |
| znver5, Tier 0 | 594.01 → 594.03 | 0.00% | 0.00% |
| znver5, Tier 1 | 600.25 → 442.56 | −26.27% | −18.65% |
| x86-64, Tier 0 | 594.01 → 594.01 | 0.00% | 0.00% |
| x86-64, Tier 1 | 600.25 → 442.57 | −26.27% | −18.65% |

The replay measures asm goto control flow. It does not exercise directive-bearing template placement. The raw archive preserves per-run output, counters and compilation reports.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
