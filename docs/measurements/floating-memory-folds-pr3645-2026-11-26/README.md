# Floating-memory folds on the Ryzen 7 9700X

[PR 3645](https://github.com/buster14a/buster/pull/3645) at `cfe7be82` compared with merge base `8e4d3287`. The original [floating memory harness](https://github.com/buster14a/buster-performance/tree/cc38ca9708f522fd26eacab3b5234dbfa71c131b/docs/measurements/tier1-fma-memory-2829-2026-11-20) built both revisions' Tier 1 code at two target levels, with the default pipeline and with opt-in unrolling, and four text paddings. Both compiler binaries used official Clang 23.1.4 in Release mode. The 800 independent Clang digest checks passed, as did the digest checks for all 384 timed observations. The timed job uses CPU 2 under the shared Benchpress lock.

The table reports the median of each placement's median-of-three paired head/base ratios. Counters cover the whole harness process per element.

| Output target | Default pipeline kernel | User cycles/element | User instructions/element |
| --- | --- | ---: | ---: |
| znver5 | saxpy_f32 | +2.00% | −30.66% |
| znver5 | i32_to_f32 | −1.48% | −12.83% |
| znver5 | matmul_f32 | −0.82% | −2.37% |
| znver5 | dot_f32 | 0.00% | 0.00% |
| x86-64 | saxpy_f32 | −6.67% | −9.81% |
| x86-64 | matmul_f32 | −3.09% | −4.34% |

With opt-in unrolling, `znver5` saxpy used +2.13% cycles and −30.66% instructions, and `x86-64` saxpy used −6.71% cycles and −9.81% instructions. At `znver5`, the folds reduce instruction count while the saxpy cycle target remains unmet for this test. See `kernels.txt` for every mode and layout.

The original static expected digests reflected a different target configuration. The timed run checks the same-target Clang reference digests freshly verified by the harness.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
