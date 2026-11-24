# Long double expression transfers in buster issue 1387

The three C kernels match the affine loop, sum and dot product in [buster issue 1387](https://github.com/buster14a/buster/issues/1387). Each timing covers 4,096 elements and 20,000 calls. The driver verifies the ten significant bytes of the result against its independently compiled reference for each process. It uses deterministic normal inputs and signed integers.

Run `bash run.sh BASE_COMPILER CANDIDATE_COMPILER OUTPUT_DIRECTORY` under the 9700X hardware CI lock. One Clang -O2 driver object is linked with Tier 0 and Tier 1 from each compiler and Clang -O0 and -O2 built with FP contraction disabled. The optimized Clang reference also disables vectorization. The harness rotates the six variants and prints five elapsed times in nanoseconds per kernel and compiler. It also saves disassemblies and records cycles and store-forwarding failures for the affine loop when perf exposes the two events.

## Register costs

The repository hardware runner measured each register form on CPU 2 under the shared lock. With Clang 23.1.4 and a znver5 Release compiler, the independent fixture measured 2.0001 cycles per FST ST(0) and 0.5000 cycles per FXCH across occupied registers. The two `measure-x86-zen5 --only` processes used 10,000 iterations and seven passes. The source was buster revision `4ec6e07fc8334f223cd4f775b39c2e1caac06b8f`, with the two pending cases added to its isolated measurement build. [Raw observations](register-costs.txt) · [Hardware job](https://github.com/buster14a/buster/actions/runs/45374932757/job/138395159798)
