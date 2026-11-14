## -march=znver5

Builds: 2 (buster-tier1, clang-O2). Kernels whose digest differs between builds: 0

### ns per element, as linked (pad0)

| Kernel | buster-tier1 | clang-O2 | tier1 / clang-O2 |
| --- | ---: | ---: | ---: |
| sum_i32 | 0.192 | 0.015 | 13.21 |
| sum_u8 | 0.181 | 0.007 | 24.49 |
| dot_i16 | 0.293 | 0.012 | 25.29 |
| max_i32 | 0.208 | 0.006 | 32.55 |
| count_eq_u8 | 0.249 | 0.019 | 12.86 |
| cond_sum_i32 | 0.334 | 0.027 | 12.32 |
| popcount_u64 | 0.227 | 0.014 | 16.68 |
| aos_sum | 0.345 | 0.053 | 6.51 |
| add_i32 | 0.190 | 0.014 | 13.19 |
| saxpy_f32 | 0.255 | 0.015 | 16.88 |
| scale_u8 | 0.247 | 0.019 | 13.28 |
| blend_u8 | 0.542 | 0.029 | 18.81 |
| clamp_i32 | 0.725 | 0.017 | 42.13 |
| i32_to_f32 | 0.185 | 0.013 | 14.34 |
| fill_u32 | 0.184 | 0.011 | 16.15 |
| copy_u8 | 0.199 | 0.003 | 68.52 |
| stencil3_u8 | 0.361 | 0.018 | 20.08 |
| rgb_to_gray | 0.759 | 0.048 | 15.77 |
| matmul_f32 | 0.439 | 0.057 | 7.72 |
| dot_f32 | 0.709 | 0.697 | 1.02 |
| prefix_sum_i32 | 0.191 | 0.182 | 1.05 |
| histogram_u8 | 0.226 | 0.144 | 1.57 |
| find_u8 | 0.183 | 0.183 | 1.00 |
| crc32_table | 1.440 | 1.440 | 1.00 |
| fnv1a | 0.719 | 0.719 | 1.00 |

### Geometric means of ratios

| Ratio | 19 vectorized, as linked | 19 vectorized, best placement of each | 6 controls, as linked | 6 controls, best placement of each |
| --- | ---: | ---: | ---: | ---: |
| buster-tier1 / clang-O2 | 17.50 | 17.50 | 1.09 | 1.09 |

### Cycles and instructions per element (perf stat, user; N repetitions less 1 repetition)

| Kernel | buster-tier1 cycles | buster-tier1 instructions | clang-O2 cycles | clang-O2 instructions |
| --- | ---: | ---: | ---: | ---: |
| sum_i32 | 1.063 | 5.006 | 0.079 | 0.361 |
| sum_u8 | 1.005 | 5.002 | 0.041 | 0.177 |
| dot_i16 | 1.627 | 7.004 | 0.064 | 0.245 |
| max_i32 | 1.217 | 5.013 | 0.035 | 0.129 |
| count_eq_u8 | 1.384 | 9.002 | 0.107 | 0.598 |
| cond_sum_i32 | 1.852 | 11.007 | 0.148 | 0.737 |
| popcount_u64 | 1.258 | 7.013 | 0.074 | 0.378 |
| aos_sum | 1.913 | 11.025 | 0.287 | 1.484 |
| add_i32 | 1.054 | 6.009 | 0.079 | 0.252 |
| saxpy_f32 | 1.373 | 11.009 | 0.082 | 0.252 |
| scale_u8 | 1.370 | 7.002 | 0.102 | 0.364 |
| blend_u8 | 3.005 | 14.002 | 0.158 | 0.552 |
| clamp_i32 | 4.019 | 22.009 | 0.094 | 0.379 |
| i32_to_f32 | 1.027 | 8.009 | 0.070 | 0.248 |
| fill_u32 | 1.021 | 4.008 | 0.063 | 0.123 |
| copy_u8 | 1.104 | 5.002 | 0.016 | 0.047 |
| stencil3_u8 | 2.005 | 13.002 | 0.099 | 0.352 |
| rgb_to_gray | 4.209 | 22.006 | 0.263 | 0.951 |
| matmul_f32 | 2.489 | 19.355 | 0.316 | 1.377 |
| dot_f32 | 3.935 | 10.009 | 3.868 | 2.387 |
| prefix_sum_i32 | 1.057 | 6.008 | 1.009 | 2.399 |
| histogram_u8 | 1.255 | 7.002 | 0.802 | 2.378 |
| find_u8 | 1.015 | 7.001 | 1.015 | 5.001 |
| crc32_table | 7.987 | 8.002 | 7.987 | 5.378 |
| fnv1a | 3.989 | 6.002 | 3.988 | 3.378 |
