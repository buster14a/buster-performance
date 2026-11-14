## -march=znver4

Builds: 4 (buster-tier1, buster-tier1-hand, clang-O2, clang-O2-hand). Kernels whose digest differs between builds: 0 

### ns per element, as linked (linked)

| Kernel | buster-tier1 | clang-O2 | tier1 / clang-O2 |
| --- | ---: | ---: | ---: |
| sum_i32 | 0.424 | 0.034 | 12.64 |
| sum_u8 | 0.256 | 0.016 | 15.60 |
| dot_i16 | 0.430 | 0.015 | 27.92 |
| max_i32 | 0.425 | 0.015 | 28.35 |
| count_eq_u8 | 0.345 | 0.043 | 7.96 |
| cond_sum_i32 | 0.435 | 0.058 | 7.51 |
| popcount_u64 | 0.216 | 0.038 | 5.64 |
| aos_sum | 0.506 | 0.120 | 4.21 |
| add_i32 | 0.435 | 0.069 | 6.29 |
| saxpy_f32 | 0.442 | 0.033 | 13.32 |
| scale_u8 | 0.341 | 0.039 | 8.70 |
| blend_u8 | 0.670 | 0.064 | 10.45 |
| clamp_i32 | 0.814 | 0.038 | 21.15 |
| i32_to_f32 | 0.340 | 0.028 | 12.14 |
| fill_u32 | 0.211 | 0.026 | 8.11 |
| copy_u8 | 0.211 | 0.007 | 31.04 |
| stencil3_u8 | 0.695 | 0.037 | 18.93 |
| rgb_to_gray | 1.060 | 0.088 | 11.97 |
| matmul_f32 | 0.688 | 0.086 | 8.03 |
| dot_f32 | 0.819 | 0.786 | 1.04 |
| prefix_sum_i32 | 0.436 | 0.212 | 2.06 |
| histogram_u8 | 0.343 | 0.233 | 1.47 |
| find_u8 | 0.420 | 0.209 | 2.01 |
| crc32_table | 1.628 | 1.614 | 1.01 |
| fnv1a | 0.814 | 0.806 | 1.01 |

### Geometric means of ratios

| Ratio | 19 vectorized, as linked | 19 vectorized, best placement of each | 6 controls, as linked | 6 controls, best placement of each |
| --- | ---: | ---: | ---: | ---: |
| buster-tier1 / clang-O2 | 11.70 | 11.70 | 1.36 | 1.36 |

### The kernels written with vector operations (ns per element, best placement of each)

| Kernel | tier1, C loop | tier1, vector source | clang-O2, C loop | clang-O2, vector source | tier1 C / tier1 vector | tier1 vector / clang-O2 C | tier1 vector / clang-O2 vector |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| sum_i32 | 0.4236 | 0.0660 | 0.0335 | 0.0499 | 6.4 | 1.97 | 1.32 |
| sum_u8 | 0.2558 | 0.0077 | 0.0164 | 0.0061 | 33.2 | 0.47 | 1.26 |
| dot_i16 | 0.4299 | 0.0160 | 0.0154 | 0.0185 | 26.9 | 1.04 | 0.86 |
| max_i32 | 0.4253 | 0.0235 | 0.0150 | 0.0184 | 18.1 | 1.57 | 1.28 |
| count_eq_u8 | 0.3448 | 0.0113 | 0.0433 | 0.0070 | 30.5 | 0.26 | 1.61 |
| cond_sum_i32 | 0.4348 | 0.0790 | 0.0579 | 0.0624 | 5.5 | 1.36 | 1.27 |
| add_i32 | 0.4355 | 0.0351 | 0.0692 | 0.1609 | 12.4 | 0.51 | 0.22 |
| saxpy_f32 | 0.4421 | 0.0387 | 0.0332 | 0.0333 | 11.4 | 1.17 | 1.16 |
| scale_u8 | 0.3409 | 0.0204 | 0.0392 | 0.0191 | 16.7 | 0.52 | 1.07 |
| clamp_i32 | 0.8142 | 0.0746 | 0.0385 | 0.0346 | 10.9 | 1.94 | 2.16 |
| i32_to_f32 | 0.3400 | 0.0349 | 0.0280 | 0.0300 | 9.7 | 1.25 | 1.16 |
| fill_u32 | 0.2109 | 0.0316 | 0.0260 | 0.0267 | 6.7 | 1.22 | 1.18 |
| geometric mean |  |  |  |  | 13.25 | 0.94 | 1.10 |

