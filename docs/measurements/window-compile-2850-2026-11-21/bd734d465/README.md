# Six integrated changes in the ordinary and opt-in SQLite compiler

The regular window option was the fastest of the four measured modes. On the integrated binary it saved 0.562 ms and 5.22 total cycles per preprocessed token against its own ordinary path. Both differences favored the option in all seven rounds. Against pristine main, it saved 3.432 ms and 23.72 cycles per token, again in all seven rounds. Median compile time was 117.950 ms for the regular option and 121.609 ms for pristine main, equivalent to 80.602 and 78.177 decimal MB/s respectively.

The explicit assignment option admitted another 1,373 roots and saved another 4.31 million retired user instructions relative to the regular option. Its incremental differences in wall time and cycles spanned zero. Against pristine main it reduced both wall time and cycles in all seven comparisons. All 112 timed processes were in the low-fault range.

Before timing, four real `-c` controls produced identical 17,623,735-byte disassemblies with relocations, digest `3db190676aca92d0b0d402393d3c04a2a10400b3dcd6427bf3805fd1d466de82`. The pristine semantic driver rejected a trial `-S` invocation, so these controls used GNU objdump on the emitted objects. Separately, the [sourced native lowering probe](six-native.gdb) compared kind, class, 64-bit value and actual parser source token for each of 381,191 entries in 2,668 functions. Every mode produced the same [function-by-function digest file](native-function-digests.tsv.gz). The [qualification table](native-qualification.tsv) records both checks. The complete [source patch](integrated-source.patch), [user/kernel paired differences](paired.tsv) and [paired summary](paired-summary.tsv) accompany the end-to-end results.

The pristine compiler is main f0a204a9c, including #3218, #3227 and #3229. The private integration bd734d465 incorporates #3219, #3223, #3224, #3230, #3231 and #3236 on that base, with Git tree `192e21e74cb6cef9694a92a78a4bcbe62f31d662`. The pristine baseline and integrated ordinary mode use default `-c`. The integrated regular and assignments modes add `--node-window` and `--node-window-assignments` respectively. The same executable provides all three integration modes.

| Mode | Expressions taken | Ordinary nodes replaced | Final graph nodes | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| baseline | 0 | 0 | 323,623¹ | 933.4785 | 1,347,031,901.5 | 121.6090 |
| ordinary | 0 | 0 | 323,623¹ | 915.9023 | 1,325,999,656.0 | 118.2585 |
| regular | 7,617 | 20,691 | 310,549 | 911.1322 | 1,308,959,208.5 | 117.9500 |
| assignments | 8,990 | 26,183 | 306,430 | 911.9308 | 1,304,644,985.0 | 118.2895 |

¹ The ordinary graph size follows from final nodes plus ordinary nodes replaced minus summaries inserted in every opt-in mode.

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| ordinary minus baseline | −18.4250 [−21.6550, −17.0634] | −21,032,274.5 | −3.1090 [−3.5055, +0.0525] |
| regular minus ordinary | −5.2159 [−5.7379, −3.8285] | −17,040,983.0 | −0.5620 [−2.3685, −0.0695] |
| assignments minus ordinary | −4.4173 [−6.9348, +1.0327] | −21,354,696.0 | −0.0125 [−3.5180, +0.2585] |
| assignments minus regular | +0.7986 [−1.4659, +5.4414] | −4,314,231.0 | +0.3075 [−1.1495, +0.7740] |
| regular minus baseline | −23.7194 [−27.3731, −21.2095] | −38,072,774.5 | −3.4320 [−3.9785, −2.3160] |
| assignments minus baseline | −22.4628 [−26.5988, −18.2780] | −42,386,925.0 | −3.1770 [−3.5180, −2.7895] |

PMU fault counts ranged from 5,656 to 5,666. The independent wall series recorded 5,764 to 5,774 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 120 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 3,701 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `f0a204a9c335d6527979834e2d3bdd6af630c224` | `128c7c958386ed9b443ad33c220ad2b97888b8fe155d52ca79a19866283d333d` |
| ordinary, regular, assignments | `bd734d465ebb198e023b5d13025e12f780d9474f` | `7479c6695fd68b4230edc35008a5693f2a3d0c57d7246505656cbe4da5d0ae3e` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](six-ordinary-config.sh), [command and object checks](six-ordinary-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
