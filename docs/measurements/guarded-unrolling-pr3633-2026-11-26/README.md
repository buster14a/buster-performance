# Paired guarded vector unrolling measurements for PR 3633

The [Benchpress job](https://github.com/buster14a/buster/actions/runs/45803661464/job/139853117778) measured PR head `e5826bec` against merge base `8e4d3287`. Both compilers were built as Release for the Ryzen 7 9700X with official Clang 23.1.4. Both compiled the frozen 25-kernel loop suite with `--tier1 --tier1-passes=+vectorize,+unroll -O2 -ffp-contract=off` for `znver5` and `x86-64`. Each output target uses four text-padding placements on CPU 2 under the shared lock. All 400 rows agreed with independent Clang output digests.

Percentage changes use the median head/base ratio across four matched padding settings per kernel, then the geometric mean within each group. The six controls are `dot_f32`, `prefix_sum_i32`, `histogram_u8`, `find_u8`, `crc32_table` and `fnv1a`.

| Target and group | Wall ns/element | User cycles/element | User instructions/element |
| --- | ---: | ---: | ---: |
| znver5, 19 kernels | −23.23% | −23.81% | −27.72% |
| znver5, six controls | +0.03% | +0.01% | 0.00% |
| x86-64, 19 kernels | −10.25% | −10.31% | −14.00% |
| x86-64, six controls | +0.02% | +0.19% | 0.00% |

At `znver5`, `sum_i32` used 59.65% fewer user cycles per element. `i32_to_f32` used 6.20% more user cycles while retiring 30.63% fewer instructions. At `x86-64`, `max_i32` recorded 5.77% more user cycles with unchanged retired instructions and wall time within 0.3%. These are kernel measurements for the opt-in flags.

`kernels.txt` contains all rows. `raw-run.zip` retains the perf counter files and metadata.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
