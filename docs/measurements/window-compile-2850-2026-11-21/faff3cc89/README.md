# Ordinary SQLite compilation and window options on the subsequent public main

After PR #3252 merged at 2026-11-21T17:44:49Z, this independently built public-main compiler used commit faff3cc89e87489229c7b0eb43fd49106dc950a1 (Git tree 6b2103734200dc6b69017f3ea922e57073987af5). Earlier public main f0a204a9c is the reference. The three head modes use one executable. Their direct comparisons isolate the mode; comparisons against the earlier main include every intervening source change.

| Mode | Expressions taken | Ordinary nodes replaced | Final graph nodes | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| baseline | 0 | 0 | 323,623¹ | 937.5061 | 1,347,031,879.0 | 121.8055 |
| ordinary | 0 | 0 | 323,623¹ | 897.9008 | 1,300,701,178.5 | 116.6055 |
| regular | 7,617 | 20,691 | 310,549 | 894.3513 | 1,285,422,887.5 | 116.0540 |
| assignments | 8,990 | 26,183 | 306,430 | 893.9259 | 1,281,063,305.5 | 116.3625 |

¹ The ordinary graph size follows from final nodes plus ordinary nodes replaced minus summaries inserted in every opt-in mode.

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| ordinary minus baseline | −38.6929 [−44.4211, −36.8078] | −46,330,706.0 | −5.0830 [−5.8705, −4.5645] |
| regular minus ordinary | −3.7794 [−7.6299, −0.2392] | −15,278,306.0 | −0.5605 [−0.9535, +0.1630] |
| assignments minus ordinary | −3.7741 [−18.9240, +1.3615] | −19,637,881.5 | −0.3210 [−0.6680, +0.1960] |
| assignments minus regular | −0.3266 [−11.2941, +5.1812] | −4,359,580.5 | +0.2395 [+0.0080, +0.4455] |
| regular minus baseline | −43.1599 [−51.2252, −39.0772] | −61,609,012.0 | −5.6980 [−6.1625, −5.1250] |
| assignments minus baseline | −43.6330 [−62.5193, −37.3314] | −65,968,584.0 | −5.3420 [−5.7900, −4.8855] |

PMU fault counts ranged from 5,635 to 5,665. The independent wall series recorded 5,743 to 5,774 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 120 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All four modes produced the same 25 located warning/note and summary lines with `-Wall -Wextra`. Merged [caret diagnostics](https://github.com/buster14a/buster/pull/2989) added source snippets and carets on main. The earlier binary rendered 3,701 bytes and the three newer modes rendered 5,846 identical bytes.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `f0a204a9c335d6527979834e2d3bdd6af630c224` | `128c7c958386ed9b443ad33c220ad2b97888b8fe155d52ca79a19866283d333d` |
| ordinary, regular, assignments | `faff3cc89e87489229c7b0eb43fd49106dc950a1` | `0799121fafc0d727ad3feffe3ee88e85b968122b9ab0cf35ea7ad7d4a0efdbf9` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](main-later-config.sh), [command and object checks](main-later-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [native verification](native-qualification.tsv) compared all 2,668 functions and 381,191 entry kind, class, value and source-token records. The complete disassembly and [per-function digests](native-function-digests.tsv.gz) were identical across all four controls. [Warning streams](warnings.tar.xz), [round-by-round cycles, instructions and faults](paired.tsv) accompany the measurements.
The [source and tree receipt](tree-equivalence.tsv) compares the executable checkout with the selected public main source.

The [scheduler receipt](scheduling.tsv) records the completion time of each process output and whether the hardware lease was busy before that process. The largest interval between adjacent positions within one round was 1.767 s (pmu), 0.280 s (wall). These intervals also include other jobs that obtained the hardware lease between compiler invocations. All measured commands themselves ran with exclusive access.

[Public acceptance](public-merge.tsv) identifies the accepted merge, source tree, and live branch head. The [ELF section comparison](queue-elf-sections.tsv) shows that this native Release from the accepted revision shared all 27 loaded sections and addresses with the earlier queue retry. Its four differing sections carry debugging data. The measurements use the compiler built directly from the accepted commit.

## Regular windows across all four corpora

The table compares regular windows against ordinary compilation on the same release binary. Each row gives the median within-round difference and the number of rounds in which regular windows reduced the measurement.

| Whole input | Rounds | Total cycles/token | Uninstrumented elapsed ms |
| --- | ---: | ---: | ---: |
| SQLite | 7 | -3.7794 (7/7 lower) | -0.5605 (6/7 lower) |
| Lua 5.4.8 | 3 | +1.3461 (0/3 lower) | -0.0285 (2/3 lower) |
| musl | 3 | +0.0790 (1/3 lower) | +0.8420 (1/3 lower) |
| Buster compiler | 3 | -2.2876 (2/3 lower) | +3.7580 (1/3 lower) |

The [three-corpus comparison](four-corpus/README.md) also includes the assignment option, the process counts and the per-source object and diagnostic receipts.

## Ordinary compilation on the two public mains

Each corpus compares the earlier ordinary compiler at f0a204a9c with the current public main. Paired elapsed differences and throughput changes include all intervening mainline commits. The throughput calculation divides the frozen preprocessed token count by the observed whole-process wall time.

| Whole input | Total cycles/token, paired change | True wall ms, paired change | Throughput change | Current throughput (M tokens/s) |
| --- | ---: | ---: | ---: | ---: |
| SQLite | −38.693 [−44.421, −36.808] | −5.083 [−5.870, −4.564] | +4.35% [+3.91%, +5.05%] | 6.142 |
| Lua | −91.397 [−94.046, −89.892] | −9.535 [−9.604, −9.503] | +14.83% [+14.73%, +14.99%] | 8.892 |
| musl | −22.123 [−23.126, −16.883] | −19.346 [−19.438, −17.923] | +3.04% [+2.81%, +3.04%] | 7.889 |
| Buster compiler | −29.310 [−30.956, −27.319] | −16.557 [−17.109, −12.373] | +2.45% [+1.83%, +2.54%] | 3.602 |
