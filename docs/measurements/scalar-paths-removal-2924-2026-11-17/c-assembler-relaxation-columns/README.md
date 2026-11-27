# Section-order assembler relaxation

The production assembler partitions fragments by section and lays out alignments, branches and LEB128 events. A census of the scalar relaxation counted adjacent source IDs and the longest run of ordinary fragments per section. At 128 functions the registers and SIMD benchmarks only used the separate record adapter. The mixed and AT&T workloads reached both the normal partition and fragment relaxation. [Compiler revision](https://github.com/buster14a/buster/tree/7e28b4ed7b1eeaff78fe8852fb9953e6e44469c9) · [Issue #3429](https://github.com/buster14a/buster/issues/3429)

| Input | Fragments | Adjacent source IDs | Alignments | LEB128s | Branches | Longest ordinary run |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| mixed | 6,146 | 95.850% | 128 | 0 | 256 | 384 |
| registers | 0 | — | 0 | 0 | 0 | 0 |
| simd | 0 | — | 0 | 0 | 0 | 0 |
| att | 6,146 | 95.850% | 128 | 0 | 256 | 384 |
| sqlite3-gcc.s | 301,894 | 99.655% | 17,898 | 0 | 35,130 | 2,567 |
| sqlite3-clang-intel.s | 321,678 | 99.833% | 3,321 | 0 | 42,350 | 2,831 |
| lvm-clang.s | 7,016 | 99.772% | 227 | 0 | 789 | 84 |

All three candidates record branch eligibility during instruction matching and compute initial offsets using a 16-lane prefix sum. The first candidate puts sizes and roles in section order in relaxation scratch. The second additionally creates the stable partition from consecutive source-section runs. The third reads each fragment’s size and role together during the initial layout, removing the separate full gather pass.

The 9700X ran three independent locked repetitions. Each generated workload covers twelve powers of two from 1 through 2,048 functions. Each cell gives the count of layout medians at parity or better, followed by the median candidate/baseline ratios for layout and total assembly. The underlying benchmark reports the median of 21 passes. Ratios use its original nanosecond precision.

| Input | Scratch columns | Section runs | Fused initial read |
| --- | ---: | ---: | ---: |
| mixed | 1/12, 1.009 / 1.004 | 4/12, 1.051 / 1.011 | 5/12, 1.011 / 1.001 |
| registers | 1/12, 1.008 / 0.999 | 12/12, 0.982 / 0.992 | 12/12, 0.983 / 0.992 |
| simd | 3/12, 1.006 / 1.004 | 12/12, 0.981 / 1.001 | 11/12, 0.987 / 1.003 |
| att | 4/12, 1.010 / 1.012 | 4/12, 1.036 / 1.012 | 5/12, 1.014 / 0.998 |
| sqlite3-gcc.s | 1/1, 0.999 / 1.001 | 0/1, 1.009 / 1.006 | 0/1, 1.006 / 0.994 |
| sqlite3-clang-intel.s | 1/1, 0.968 / 0.990 | 1/1, 0.976 / 1.006 | 1/1, 0.986 / 1.008 |
| lvm-clang.s | 1/1, 0.971 / 0.988 | 1/1, 0.989 / 1.011 | 1/1, 0.986 / 0.998 |

The first candidate sped up layout on all three real assembly files. All three candidates lost at individual generated sizes. Each passed 1,974,444 assembler checks, including GNU assembler comparisons, and each reproduced the same three real objects byte for byte. The independent ASan/UBSan drivers matched 19,200 layouts and 55,692 stable partitions, including post-layout appends at exact arena bounds. Twelve mutations of event recording, overflow, alignment and repeated placement were detected. [Source patches, test drivers, exact timings and checks](assembler-layout.tar.xz)

## Updating only offsets affected by relaxation

The fourth implementation keeps each event’s previously placed size. It propagates the change in fragment offsets across consecutive intervening fragments in AVX-512 lanes and skips runs whose offsets stayed the same. All 19,200 independent layouts matched, and the native assembler passed 1,974,444 checks. The three real objects matched baseline byte for byte.

| Input | Layout sizes at parity or better | Layout ratio | Total assembly ratio |
| --- | ---: | ---: | ---: |
| mixed | 5/12 | 1.041 | 1.018 |
| registers | 12/12 | 0.985 | 0.990 |
| simd | 12/12 | 0.977 | 0.998 |
| att | 4/12 | 1.052 | 1.008 |
| sqlite3-gcc.s | 0/1 | 1.016 | 1.001 |
| sqlite3-clang-intel.s | 1/1 | 0.990 | 0.986 |
| lvm-clang.s | 0/1 | 1.025 | 1.002 |

The register-only and SIMD-only workloads prepare records without normal fragment relaxation. All twelve sizes improved there. On the two synthetic workloads reaching real relaxation, only five of twelve mixed sizes and four of twelve AT&T sizes improved. Clang’s SQLite assembly improved on both layout and total time. GCC’s SQLite assembly and Lua did not meet parity. [Patch, guarded differential test, native receipts and all 306 timing files](changed-offsets.tar.xz)
