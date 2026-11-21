# Independent reductions in ordinary expression checking

These three independent candidates each modify the ordinary CHECK pass, on one common pristine main. The leaf candidate completes adjacent compact leaf blocks. The conversion candidate conditionally writes trailing conversion fields. The condition candidate completes an unknown integer condition from the checked operand and preserves its inherited flags. The four Release executables compiled the frozen SQLite amalgamation with identical ordinary flags.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 903.7275 | 1,305,909,911.5 | 117.4320 |
| leaves | 897.3995 | 1,295,642,051.5 | 117.0190 |
| conversions | 899.1693 | 1,307,111,666.5 | 117.0610 |
| condition | 899.7570 | 1,301,168,984.5 | 116.8255 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| leaves minus baseline | −6.3280 [−7.9820, −4.9826] | −10,267,861.0 | −0.1430 [−0.6815, +0.7580] |
| conversions minus baseline | −5.2427 [−5.5994, −3.2814] | +1,201,763.0 | −0.4870 [−0.6185, +0.1115] |
| condition minus baseline | −4.3702 [−7.2590, −3.8125] | −4,740,927.0 | −0.3745 [−0.7225, −0.2710] |

PMU fault counts ranged from 5,636 to 5,642. The independent wall series recorded 5,743 to 5,751 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 56 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `325883abf9607ac726966a0af2097377832d53ac` | `a7c7e6773fd27da50d7063f9addd684ef608ea92273349132cf08d3207e2ed41` |
| leaves | `e39bc958801e42ee3977cb233a73cd19481c9b4f` | `e9e36298a635ae3cf7b457b6487b3becb832b2c852c9aada14c931867525e825` |
| conversions | `59c93aa11944c5d81c8bfcedd36b57e32115acc6` | `c6842b2d87eb6c4371f0de502e0c43e9df688da08fb56758dbe98b4f95118637` |
| condition | `69e2eea8da782b189a20a0fd6ec31da004aaf4f0` | `b8b513405e32b61b9d08a8259748c4307ccdf68cd3f12f3596841b41d8f1b05a` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](checker-fields-config.sh), [command and object checks](checker-fields-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [leaf blocks](nodes39b.patch), [conversion writes](conversion59c.patch) and [condition values](condition69e.patch) each apply independently to the same public main.

The [check-expressions stage](stage-check-expressions.tsv) has one separately timed stage-counter observation per source. The [correctness qualification](correctness/README.md) compares individual checked columns, the typed-node transcript, diagnostics and complete ELF for each native image.

The [scheduler receipt](scheduling.tsv) records the completion time of each process output and whether the hardware lease was busy before that process. The largest interval between adjacent positions within one round was 0.957 s (pmu), 0.250 s (wall). These intervals also include other jobs that obtained the hardware lease between compiler invocations. All measured commands themselves ran with exclusive access.
