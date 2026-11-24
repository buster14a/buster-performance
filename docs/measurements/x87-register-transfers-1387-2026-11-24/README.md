# Long double expression transfers in buster issue 1387

The three C kernels match the affine loop, sum and dot product in [buster issue 1387](https://github.com/buster14a/buster/issues/1387). Each timing covers 4,096 elements and 20,000 calls. The driver verifies the ten significant bytes of the result against its independently compiled reference for each process. It uses deterministic normal inputs and signed integers.

Run `bash run.sh BASE_COMPILER CANDIDATE_COMPILER OUTPUT_DIRECTORY` under the 9700X hardware CI lock. One Clang -O2 driver object is linked with Tier 0 and Tier 1 from each compiler and Clang -O0 and -O2 built with FP contraction disabled. The optimized Clang reference also disables vectorization. The harness rotates the six variants and prints five elapsed times in nanoseconds per kernel and compiler. It also saves disassemblies and records cycles and store-forwarding failures for the affine loop when perf exposes the two events.

## Register costs

The repository hardware runner measured each register form on CPU 2 under the shared lock. With Clang 23.1.4 and a znver5 Release compiler, the independent fixture measured 2.0001 cycles per FST ST(0) and 0.5001 cycles per FXCH across occupied registers. The two `measure-x86-zen5 --only` processes used 10,000 iterations and seven passes. The source was buster revision `4ec6e07fc8334f223cd4f775b39c2e1caac06b8f`, with the two pending cases added to its isolated measurement build. [Raw observations](register-costs.txt) · [Hardware job](https://github.com/buster14a/buster/actions/runs/45374932757/job/138395159798)

## Kernel timings

The repository's 9700X runner executed the six variants on CPU 2 after native correctness passed, using one Clang 23.1.4 driver object. The baseline compiler was `7515714d05caa655e8c2e1e2776e07aa9b8058df`. The candidate was `67e7ea5f8fdbe528486b60f50d98e8f2ff295d95` with a workflow-only commit, `fd12fac50`. The driver checked all 90 results. Times are medians of five runs, in milliseconds. [Hardware job](https://github.com/buster14a/buster/actions/runs/45381090551/job/138416433896) · [Individual samples and object hashes](hardware/observations.txt)

| Kernel | Tier 0 baseline | Tier 0 candidate | Speedup | Tier 1 baseline | Tier 1 candidate | Speedup | Clang -O0 | Clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Affine | 1212.0 | 571.6 | 2.12× | 1082.7 | 569.7 | 1.90× | 471.9 | 176.7 |
| Sum | 689.3 | 448.2 | 1.54× | 690.2 | 448.7 | 1.54× | 388.1 | 88.1 |
| Dot product | 783.6 | 451.1 | 1.74× | 783.4 | 450.9 | 1.74× | 398.4 | 118.3 |

Over the affine kernel's 81,920,000 inner iterations, the separate perf run counted 81,927,331 store-forwarding failures on the Tier 0 baseline and 2,318 on the candidate. Tier 1 counted 4,158 and 2,374 respectively. The candidates finished 13–21% slower than Clang -O0 across the three kernels. The recorded instruction bytes, instruction order and relocations for both candidate tiers also match a local build of PR head `8f70021a9baa87035065abb1675de95518f5a0c6` after merging main. [Counter files and disassemblies](hardware/)
