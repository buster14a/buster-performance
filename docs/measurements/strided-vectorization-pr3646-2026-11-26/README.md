# Paired strided vectorization measurements for PR 3646

The [Benchpress job](https://github.com/buster14a/buster/actions/runs/45803656293/job/139853099251) measured PR head `3bb1ff6b` against merge base `8e4d3287`. Both compilers were built as Release for the Ryzen 7 9700X with official Clang 23.1.4 and ran the frozen 25-kernel loop suite with `--tier1 --tier1-passes=+vectorize -O2 -ffp-contract=off`. Both output targets, `znver5` and `x86-64`, used four text-padding placements on CPU 2 under the shared lock. All 400 base and head measurements matched the independent Clang output digests.

The table gives medians across the four placements at `znver5`. Each wall-time result uses the minimum of seven calibrated repeats at its placement, following the original harness.

| Kernel | ns/element, base → head | User cycles/element, base → head | User instructions/element, base → head |
| --- | ---: | ---: | ---: |
| `aos_sum` | 0.08245 → 0.05215 | 0.45428 → 0.27866 | 2.68945 → 2.06445 |
| `rgb_to_gray` | 0.06745 → 0.05575 | 0.36184 → 0.30140 | 2.37656 → 1.69634 |
| `count_eq_u8` | 0.00455 → 0.00460 | 0.02789 → 0.02723 | 0.19226 → 0.19226 |

At `x86-64`, user instructions per element for these three kernels were unchanged at the printed precision. The frozen suite measures throughput for its original kernel inventory. The PR's additional gather, scatter and protected-page fixtures have their own correctness record.

`kernels.txt` has all 400 rows and `raw-run.zip` has the raw perf counter files and the run metadata.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
