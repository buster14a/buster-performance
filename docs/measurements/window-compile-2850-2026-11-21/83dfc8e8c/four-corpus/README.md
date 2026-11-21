# Current-main constant operands across four corpora

Pristine public main 325883abf and the ordinary and `--node-window-constants` modes of corrected #3247 `83dfc8e8cece1658c0cc6e62f99db2c0c0f6e3a5` compiled the SQLite amalgamation, all 34 Lua files, all 1,336 musl files and the Buster compiler on Ryzen 7 9700X CPU 2. Each single-lane timed process compiled its complete set of inputs. The two candidate modes ran the identical executable.

| Corpus | Comparison | Total cycles/token, median [min, max] | User instructions, paired median | True wall ms, median [min, max] |
| --- | --- | ---: | ---: | ---: |
| [sqlite](sqlite/samples.tsv) | plain minus baseline | −0.4127 [−6.0745, +1.4528] | -575,467.0 | −0.3000 [−0.3710, +0.0845] |
| [sqlite](sqlite/samples.tsv) | constants minus plain | −3.3152 [−5.6114, −0.8931] | -5,205,686.5 | −0.3595 [−0.6740, +0.0225] |
| [sqlite](sqlite/samples.tsv) | constants minus baseline | −4.1587 [−6.9675, −3.7279] | -5,781,138.5 | −0.3485 [−0.9740, −0.2750] |
| [main](main/samples.tsv) | plain minus baseline | −6.6584 [−7.0668, −5.0289] | -2,293,344.5 | −0.2345 [−1.0605, −0.2215] |
| [main](main/samples.tsv) | constants minus plain | −11.6532 [−12.3019, −6.6305] | -105,496,707.5 | −5.9845 [−7.3665, −5.0675] |
| [main](main/samples.tsv) | constants minus baseline | −17.3309 [−18.7199, −13.2889] | -107,790,052.0 | −7.0450 [−7.5880, −5.3020] |
| [lua](lua/samples.tsv) | plain minus baseline | −1.4496 [−1.5828, +2.5907] | -162,797.0 | −0.3090 [−0.3905, −0.0410] |
| [lua](lua/samples.tsv) | constants minus plain | −1.1155 [−4.3254, +0.6436] | -1,308,931.0 | +0.0420 [−0.1110, +0.3415] |
| [lua](lua/samples.tsv) | constants minus baseline | −1.7346 [−2.5651, −0.9392] | -1,473,009.5 | −0.1520 [−0.2670, −0.0490] |
| [musl](musl/samples.tsv) | plain minus baseline | −1.7798 [−2.2121, −1.6966] | -1,476,898.0 | −4.6700 [−5.3920, −4.6665] |
| [musl](musl/samples.tsv) | constants minus plain | +0.2535 [−0.2825, +2.7793] | -1,301,279.5 | +1.8250 [−0.8690, +2.5310] |
| [musl](musl/samples.tsv) | constants minus baseline | −1.4431 [−2.0623, +0.5672] | -2,788,804.5 | −2.8610 [−5.5355, −2.8450] |

Each of three independent rounds per series used each mode twice in symmetric order. The tables report medians and ranges of paired within-round differences. Each PMU sample observed a fresh compiler. Every independent wall observation also used a fresh compiler and followed one warm-up invocation in the same mode. Thus each corpus used 18 timed PMU processes, 18 timed wall processes, 18 additional wall warm-up processes and 9 batch qualification processes. The per-source gate separately used one fresh stage-counter process per translation unit with the constants option; each output matched the bulk compile manifests. Every PMU counter ran at 100% enabled time. The production command and the harness are included below.

The [command](parser-constants-one.sh), [schedule](parser-constants.sh), [corpus definitions](corpora.sh) and [manifest collector](full-chain-manifest.py) reproduce the measurements.
