# Signed memory operands for scalar integer-to-float conversions

[Buster PR #3120](https://github.com/buster14a/buster/pull/3120) compares parent `8bfdf2f9584680af813f2adad7b139cf839afe8c` with `7b6272d08e82bc754e714160dc13599066eaa37b`. Both compilers used the repository Release build, pinned Clang 23.1.4 and `BUSTER_HOST_ARCH=znver5`. Buster's one-lane Tier 1 compiled the unmodified #2743 array kernels. The same Clang-built driver was linked with both objects.

## Ryzen 7 9700X

The integer-to-float array loop converted 2,048 elements per call over 65,536 repetitions. CPU 2, Linux 6.18.50-2-lts, performance governor, boost enabled. Each compiler, guest architecture and pipeline had one warmup and five AB/BA pairs at each of four matched function placements. The harness used the shared 9700X lock separately for each run and verified the same output digest on all 192 observations. Counters cover the whole process, including the driver. CPE and IPE are cycles and retired instructions divided by 134,217,728 elements.

| Guest target | Unroll pass | Parent CPE | PR CPE | Paired cycle change | Range across four placements | Parent IPE | PR IPE |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| znver5 | Default | 1.036 | 1.030 | −0.54% | −0.63% to −0.54% | 8.027 | 7.027 |
| znver5 | Enabled | 1.018 | 0.796 | −21.85% | −21.87% to −21.82% | 5.405 | 4.405 |
| x86-64 | Default | 1.036 | 1.030 | −0.54% | −0.63% to +0.27% | 8.027 | 7.027 |
| x86-64 | Enabled | 1.019 | 0.796 | −21.83% | −21.84% to −21.83% | 5.405 | 4.405 |

Each placement uses the median of its five measured observations or paired percent changes. The summary uses the median of the four placement medians. Independent column medians and the median pairwise change can differ. `native-counters.tsv` contains every observation, including warmups, counters, UTC start/end and load averages. `native-layouts.tsv` records the function addresses and per-placement results. The symbol starts at the same address for each base/head pair.

## Code and correctness

Only `k_i32_to_f32` changed in the kernel suite. Its default body shrank from 33 to 31 bytes. With unrolling enabled it shrank from 254 to 220 bytes. The legacy conversion retains its explicit `xorps` destination dependency break. `kernel-code.tsv` records every named kernel's length and byte hash. All 800 driver digests matched an independent Clang -O0 build across 25 kernels, two guest targets, two pipelines, four placements and both compiler revisions. The columns in `all-digests.tsv` are kernel, target, compiler, pipeline, placement, oracle digest and observed digest.

The separate `rounding.c` driver compared signed i32/i64 to f32/f64 with a Clang -O0 reference, including random and extreme inputs, all four rounding modes, floating-point exception flags and guard-page boundary loads. The reference and both compilers gave 20,700 identical results and exception sets. The selector regression tests cover explicit IR volatile flags and intervening memory effects. On the parent, the C pointer-to-volatile leaf in `leaves.c` reaches Tier 1 as an ordinary load. Claims about the eligibility check apply to the flags present in IR.

From 1,336 musl x86-64 compilation units, every file compiled on both revisions and only `src/math/__rem_pio2_large.c` changed, saving seven text bytes. `musl-objects.tsv` records the complete object hash and text size for each pair. SQLite 3.53.2 speedtest1 (in-memory, size 4) gave identical verification hashes for the main, fp, orm, cte and json sets. Each compiler built the engine and driver. Clang independently reproduced all five hashes in `sqlite/`.

## Reproduction

With both Buster executables built and Clang on PATH, run `./build-kernels.sh /absolute/path/to/base /absolute/path/to/head`. The `kernels` symlink refers to the original #2743 harness in this repository. `./verify-programs.sh` prints the independent digest comparisons. On an available 9700X, set `EXCLUSIVE_OWNER` to your session and run `./confirm-kernels.sh`. It exits when another lease or queued CI is present. Program and input hashes are in `input-build-sha256.txt`.

Compile `rounding.c` with Clang -O0, then link it and libm separately with `leaves.c` compiled by Clang -O0, the parent Buster, and the candidate Buster. For both Buster compilations use `--tier1 -O2 --lanes 1 -march=znver5`. The three expected outputs are recorded with the driver.
