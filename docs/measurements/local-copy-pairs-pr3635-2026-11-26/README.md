# Tier 1 paired local-copy timings on the Ryzen 7 9700X

[PR 3635](https://github.com/buster14a/buster/pull/3635) at `7d40f6ec` compared with merge base `8e4d3287`. The exact PR C fixture was compiled with both Clang-built Release compilers in Tier 1 strict mode with `--verify -O2` at `znver5` and `x86-64`. The shared driver invokes a fixture function 20 million times per run, reads back the last word and checks matching checksums across each base/head pair. Each of the two targets ran five pairs across three sizes and both source patterns, pinned to CPU 2 under the shared lock.

| Output target | Fresh 64-byte local | Fresh 128-byte local | Fresh 256-byte local |
| --- | ---: | ---: | ---: |
| znver5 | −22.97% | −17.22% | −2.73% |
| x86-64 | −32.15% | −17.55% | −4.70% |

Changes are median head/base ratios of paired whole-process user cycles, including the shared driver and call overhead. On `znver5`, median cycles per call including that overhead were 21.61 → 16.58, 36.48 → 30.21 and 65.39 → 63.64. All six cold-copy controls were within 0.01% in user cycles. Every pair matched output. The raw record also includes retired instructions and branch misses. These runs use one link layout per compiler and target.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
