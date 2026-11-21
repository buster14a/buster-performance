# Ordinary public-main compiler costs before and after the enum diagnostic replay change

These are three public mainline Release compilers, all using ordinary artifact output. Historic f0a204a9c is the earlier cumulative reference. Profile is the genuine #3252 merge and enum is the next mainline commit with #3251. The difference between those last two directly measures that one merged change.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| historic | 938.2656 | 1,347,031,898.5 | 121.8785 |
| profile | 898.5894 | 1,300,701,188.0 | 116.3015 |
| enum | 898.5098 | 1,300,701,214.5 | 116.9875 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| profile minus historic | −40.1420 [−41.0601, −38.8463] | −46,330,711.0 | −5.4910 [−5.5770, −5.3220] |
| enum minus profile | −0.7482 [−0.9095, +4.0117] | +26.5 | +0.3985 [+0.2545, +0.7465] |
| enum minus historic | −39.7558 [−40.8902, −37.0483] | −46,330,663.0 | −5.1785 [−5.2365, −4.5755] |

PMU fault counts ranged from 5,635 to 5,665. The independent wall series recorded 5,745 to 5,773 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 42 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. The two adjacent public mains emitted byte-identical warnings. The earlier public main used its older diagnostic presentation. The original warning streams and digests are included.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| historic | `f0a204a9c335d6527979834e2d3bdd6af630c224` | `128c7c958386ed9b443ad33c220ad2b97888b8fe155d52ca79a19866283d333d` |
| profile | `faff3cc89e87489229c7b0eb43fd49106dc950a1` | `0799121fafc0d727ad3feffe3ee88e85b968122b9ab0cf35ea7ad7d4a0efdbf9` |
| enum | `5bf2b3af9ad68fae14364659bcda23fc645fa71f` | `26162bfcadd29afaf0de3a9fe33586fb14d3dd2cbfcb7a7abbe7a91204e3f6f9` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](enum-public-config.sh), [command and object checks](enum-public-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [scheduler receipt](scheduling.tsv) records the completion time of each process output and whether the hardware lease was busy before that process. The largest interval between adjacent positions within one round was 0.140 s (pmu), 0.270 s (wall). These intervals also include other jobs that obtained the hardware lease between compiler invocations. All measured commands themselves ran with exclusive access.
