# Interpreter byte maps and call setup on the Ryzen 7 9700X

[PR 3626](https://github.com/buster14a/buster/pull/3626) at `96d8cc67` compared with merge base `8e4d3287`. Both compilers were built in Release for `znver5` using official Clang 23.1.4. Three alternating base/head pairs ran the existing `test-ssa-source --typed --tier1 --keep` workload on CPU 2 under the shared Benchpress lock. Each pair ran case 00040 and the complete frozen 220-program subset. All native and interpreter outputs matched, including the hash of each of the five outputs per case. Both revisions recorded the same step totals.

| Workload | Median user cycles, billion, base → head | Median retired instructions, billion, base → head |
| --- | ---: | ---: |
| 00040 | 120.07 → 119.66 (−0.34%) | 710.19 → 714.85 (+0.66%) |
| Full 220 | 121.03 → 122.11 (+0.89%) | 717.76 → 722.60 (+0.67%) |

Full-subset user-cycle changes across the three matched pairs were +0.89%, +2.70%, and −0.20%. Each pair retired more instructions. The archive contains perf counters, stdout, stderr and digest manifests. These totals describe the full test driver, which includes all interpreter modes and native verification.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
