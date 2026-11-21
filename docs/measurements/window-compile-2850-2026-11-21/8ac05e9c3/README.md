# Ordinary SQLite compilation and window options on the actual #3219 queue source

These measurements ran the exact GitHub merge-queue source for #3219, `8ac05e9c35594cb84685ddfa76fb2f46a5e9a3ee`. Its parents are public main b86eadcbd, which includes the #3239 Lua change, and #3219 head 90b108a71. Its complete Git tree is `7550d383851444c25f2ca9d9b8313679bcaa3c53`. The measurement began at 16:00 UTC while this source was still in the merge queue. Earlier main f0a204a9c is the independent reference. Each of the three queue-source modes uses the same native Release executable. Their direct differences isolate the options, while the comparison with f0a204a9c includes every intervening mainline change.

| Mode | Expressions taken | Ordinary nodes replaced | Final graph nodes | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| baseline | 0 | 0 | 323,623¹ | 937.1737 | 1,347,031,892.5 | 121.7130 |
| ordinary | 0 | 0 | 323,623¹ | 902.8211 | 1,307,142,345.5 | 117.1420 |
| regular | 7,617 | 20,691 | 310,549 | 897.7647 | 1,290,089,782.5 | 116.6780 |
| assignments | 8,990 | 26,183 | 306,430 | 899.8508 | 1,285,777,471.5 | 116.7665 |

¹ The ordinary graph size follows from final nodes plus ordinary nodes replaced minus summaries inserted in every opt-in mode.

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| ordinary minus baseline | −34.2825 [−38.1520, +44.8755] | −39,889,532.0 | −4.6595 [−4.9070, −3.5170] |
| regular minus ordinary | −4.4285 [−85.7916, −1.1835] | −17,052,574.0 | −0.1555 [−1.3350, +1.8190] |
| assignments minus ordinary | −2.7706 [−87.5821, +5.0324] | −21,364,865.0 | −0.1325 [−1.0230, +1.2420] |
| assignments minus regular | +1.6579 [−1.7905, +6.4718] | −4,312,321.5 | −0.3100 [−1.5665, +2.5770] |
| regular minus baseline | −39.4090 [−41.3422, −36.7704] | −56,942,123.0 | −4.8265 [−5.3710, −2.8405] |
| assignments minus baseline | −36.3838 [−42.7065, −33.1195] | −61,254,425.5 | −4.7740 [−5.9300, −2.2750] |

PMU fault counts ranged from 5,650 to 57,350. The independent wall series recorded 5,759 to 5,787 minor faults and zero major faults.

Excluding rounds with a process above 20,000 faults in the pmu series removes rounds 7. The retained paired differences are

| Paired difference | cycles/token, median [min, max] |
| --- | ---: |
| ordinary minus baseline | −34.9347 [−38.1520, −28.8132] |
| regular minus ordinary | −3.7763 [−8.5555, −1.1835] |
| assignments minus ordinary | −2.4463 [−5.6023, +5.0324] |
| assignments minus regular | +2.3055 [−1.1091, +6.4718] |
| regular minus baseline | −38.7253 [−41.3422, −36.7704] |
| assignments minus baseline | −35.6271 [−41.8470, −33.1195] |

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 120 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All four modes produced the same 25 located warning/note and summary lines with `-Wall -Wextra`. Merged [caret diagnostics](https://github.com/buster14a/buster/pull/2989) added source snippets and carets on main. The earlier binary rendered 3,701 bytes and the three newer modes rendered 5,846 identical bytes.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `f0a204a9c335d6527979834e2d3bdd6af630c224` | `128c7c958386ed9b443ad33c220ad2b97888b8fe155d52ca79a19866283d333d` |
| ordinary, regular, assignments | `8ac05e9c35594cb84685ddfa76fb2f46a5e9a3ee` | `9b72282302c0c339c765411c40c69fcae1a34577b44c0ddc31756ef9eaf24e6e` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](main-current-config.sh), [command and object checks](main-current-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [native verification](native-qualification.tsv) compared all 2,668 functions and 381,191 entry kind, class, value and source-token records. The complete disassembly and [per-function digests](native-function-digests.tsv.gz) were identical across all four controls. [Warning streams](warnings.tar.xz), [round-by-round cycles, instructions and faults](paired.tsv) accompany the measurements.

The [source and tree receipt](tree-equivalence.tsv) compares the executable checkout with the selected queue source.

## Regular windows across all four corpora

The table compares regular windows against ordinary compilation on the same release binary. Each row gives the median within-round difference and the number of rounds in which regular windows reduced the measurement.

| Whole input | Rounds | Total cycles/token | Uninstrumented elapsed ms |
| --- | ---: | ---: | ---: |
| SQLite | 7 | -4.4285 (7/7 lower) | -0.1555 (5/7 lower) |
| Lua 5.4.8 | 3 | -0.0231 (2/3 lower) | +0.1780 (1/3 lower) |
| musl | 3 | +1.1566 (0/3 lower) | +2.1955 (0/3 lower) |
| Buster compiler | 3 | +1.1785 (0/3 lower) | -0.5850 (3/3 lower) |

The [three-corpus comparison](four-corpus/README.md) also includes the assignment option, the process counts and the per-source object and diagnostic receipts.
