# Incremental lexer output bounds on ordinary SQLite compilation

Four compiler builds ran the same ordinary SQLite command in rotated, symmetric order. They compare pristine 232da75f9, 220f299c6 with moved lookahead mask rows, 8b3cde244 with carried block-comment selection, and adf1a5714 with lookahead, comment selection and bounded output writes.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 904.8940 | 1,307,159,743.5 | 116.9055 |
| lookahead | 901.9948 | 1,306,512,002.5 | 116.6710 |
| carried | 906.2271 | 1,306,387,605.0 | 118.4715 |
| writer | 899.3065 | 1,304,401,318.5 | 116.4430 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| lookahead minus baseline | −3.4343 [−6.0085, −2.8992] | −647,741.0 | −0.3925 [−1.8740, +0.2445] |
| carried minus lookahead | +6.4571 [+3.5675, +9.1198] | −124,397.5 | +1.5960 [+0.3920, +2.5175] |
| writer minus carried | −6.1609 [−11.8081, −2.9423] | −1,986,298.5 | −1.4005 [−2.7455, −0.5830] |
| writer minus lookahead | +0.2961 [−2.6884, +0.6252] | −2,110,667.5 | −0.1910 [−0.2280, +0.1955] |
| writer minus baseline | −5.5875 [−5.7124, −2.8091] | −2,758,408.5 | −0.5835 [−2.1020, +0.4400] |

PMU fault counts ranged from 5,652 to 5,719. The independent wall series recorded 5,761 to 5,827 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 56 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `232da75f980c7ff9f01ffa3d849d655970bbed78` | `60d2bb6f131538a8845d1bfe56dc37aac0332c2caf70d53cdae9a935741ce1ec` |
| lookahead | `220f299c60d0ee048fc36cf502f38bfbef314ecb` | `f9cad69b4264168b4892000d2f7f1feed6d75598b639958597496b2c70dd7a27` |
| carried | `8b3cde244cb59295d9ce6f2d15a1c6a53e5557da` | `3a907e3d6479792cc4c7d8ff9f731bdd3ab5cde9cc5f1dccbd8e745e008080ae` |
| writer | `adf1a57146b57f1f3e7ae82e12ff3ca1cfacc754` | `5b827759165e316f86c27e0befa4e301d3d3a04d59ddd859a1c2c861bddc81d7` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](lexer-aggregate-config.sh), [command and object checks](lexer-aggregate-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [corresponding four-mode lexer kernel](kernel/README.md), [complete cumulative source](implementation.patch), [full token, transcript, driver and range qualification](correctness/) and the [earlier three-mode ordinary run](../8b3cde244/README.md) accompany this end-to-end measurement.

The [diagnostic writer census](census/) reduced recorded output-lane iterations from 158,296 to 116,260 across 19,787 calls on raw SQLite plus its headers. The [musl source tree](kernel/musl/README.md) and [Buster checker driver](kernel/buster/README.md) each supplied a separate three-round base/final raw-lexer sensitivity comparison.

The separate [fresh preprocessor without the text printer](fresh-preprocessor/README.md) ran full include, lex, refinement and directive processing 21 times per process. It compares the same final and pristine Release builds on the 1,234,862 input-token workload.
