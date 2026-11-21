# Compiler integration on dca705662 for the ordinary and opt-in SQLite compile

A stock Release compiler from the earlier pristine main f0a204a9c and three modes of the integrated source compiled frozen SQLite on Ryzen 7 9700X CPU 2. The measured source has Git tree `e8f4cb9f998e10d945b64673630fffd34d47055a`, identical to the [public #3219 source](https://github.com/buster14a/buster/commit/90b108a71b7eca9b9c0a55ce6059fb90e5f8d44b). Private integration commits 2ae739d9e and aa28229b9 have the same tree. This source includes the merged #3230, #3231 and #3237 changes plus #3219. The earlier-to-integrated comparison includes every intervening mainline change. The comparisons between the three modes use one identical native executable.

| Mode | Expressions taken | Ordinary nodes replaced | Final graph nodes | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| baseline | 0 | 0 | 323,623¹ | 931.6376 | 1,347,031,892.5 | 121.5530 |
| ordinary | 0 | 0 | 323,623¹ | 898.3824 | 1,307,159,759.5 | 117.3480 |
| regular | 7,617 | 20,691 | 310,549 | 894.0528 | 1,290,106,983.5 | 116.8605 |
| assignments | 8,990 | 26,183 | 306,430 | 896.1807 | 1,285,794,760.5 | 116.8965 |

¹ The ordinary graph size follows from final nodes plus ordinary nodes replaced minus summaries inserted in every opt-in mode.

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| ordinary minus baseline | −32.7274 [−37.8687, −27.4427] | −39,872,141.5 | −4.2465 [−6.8345, −3.8275] |
| regular minus ordinary | −6.0863 [−9.2780, −3.0885] | −17,052,787.0 | −0.4875 [−2.4460, +0.0915] |
| assignments minus ordinary | −3.7335 [−6.5678, +0.8499] | −21,364,985.0 | −0.3845 [−1.3745, +0.1930] |
| assignments minus regular | +2.4735 [−0.6450, +5.9126] | −4,312,223.0 | +0.1120 [−0.7060, +1.0715] |
| regular minus baseline | −37.4573 [−40.9572, −36.2386] | −56,924,915.0 | −4.5170 [−9.2805, −4.3150] |
| assignments minus baseline | −34.2999 [−41.6021, −32.5455] | −61,237,138.0 | −4.8885 [−8.2090, −3.9945] |

PMU fault counts ranged from 5,653 to 5,665. The independent wall series recorded 5,760 to 5,773 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 120 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All four modes produced the same 25 located warning/note and summary lines with `-Wall -Wextra`. Merged [caret diagnostics](https://github.com/buster14a/buster/pull/2989) added source snippets and carets on main. The earlier binary rendered 3,701 bytes and the three newer modes rendered 5,846 identical bytes.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `f0a204a9c335d6527979834e2d3bdd6af630c224` | `128c7c958386ed9b443ad33c220ad2b97888b8fe155d52ca79a19866283d333d` |
| ordinary, regular, assignments | `2ae739d9edcdd7977b573dda5d02de047a036015` | `3fbb370d471cca6364e713823efde99265f88877cfb86d46cdd9b6fda47007b7` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](wave-main-config.sh), [command and object checks](wave-main-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [native verification](native-qualification.tsv) compared all 2,668 functions and 381,191 entry kind, class, value and source-token records. The complete disassembly and [per-function digests](native-function-digests.tsv.gz) were identical across all four controls. [Warning streams](warnings.tar.xz), [round-by-round cycles, instructions and faults](paired.tsv) accompany the measurements.

The [complete source patch](integration.patch) reproduces the compiled integration on the checkout in builds.tsv.
