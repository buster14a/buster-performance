# Ordinary public-main compiler costs before and after the enum diagnostic replay change

These are three public mainline Release compilers, all using ordinary artifact output. Historic f0a204a9c is the earlier cumulative reference. Profile is the genuine #3252 merge and enum is the next mainline commit with #3251. The difference between those last two directly measures that one merged change.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| historic | 1,571.8894 | 10,669,723,758.0 | 690.3910 |
| profile | 1,539.3007 | 10,547,697,528.5 | 676.5990 |
| enum | 1,409.1237 | 9,514,156,597.0 | 619.4135 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| profile minus historic | −32.5887 [−36.0708, −32.2225] | −122,027,004.5 | −13.4380 [−17.0675, −12.0895] |
| enum minus profile | −131.3035 [−132.4777, −121.3447] | −1,033,544,334.5 | −55.8265 [−58.4730, −54.7855] |
| enum minus historic | −163.8922 [−164.7002, −157.4155] | −1,155,571,339.0 | −71.8530 [−71.9110, −67.9160] |

PMU fault counts ranged from 14,345 to 16,512. The independent wall series recorded 14,699 to 16,874 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen Buster compiler denominator of 2,433,922 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 42 successful compiles yielded a 11,272,080-byte object with SHA-256 `f6da2c15662c96c6d222714244bd3aff34d964c360b0871da6f0036dee74309c`. Default diagnostics were empty. The two adjacent public mains emitted byte-identical warnings. The earlier public main used its older diagnostic presentation. The original warning streams and digests are included.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| historic | `f0a204a9c335d6527979834e2d3bdd6af630c224` | `128c7c958386ed9b443ad33c220ad2b97888b8fe155d52ca79a19866283d333d` |
| profile | `faff3cc89e87489229c7b0eb43fd49106dc950a1` | `0799121fafc0d727ad3feffe3ee88e85b968122b9ab0cf35ea7ad7d4a0efdbf9` |
| enum | `5bf2b3af9ad68fae14364659bcda23fc645fa71f` | `26162bfcadd29afaf0de3a9fe33586fb14d3dd2cbfcb7a7abbe7a91204e3f6f9` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](enum-public-config.sh), [command and object checks](enum-public-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [scheduler receipt](scheduling.tsv) records the completion time of each process output and whether the hardware lease was busy before that process. The largest interval between adjacent positions within one round was 0.717 s (pmu), 1.403 s (wall). These intervals also include other jobs that obtained the hardware lease between compiler invocations. All measured commands themselves ran with exclusive access.
