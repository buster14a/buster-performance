# Fresh-process Lua and musl compilation with source-certified constants

Pristine public main b86eadcbd and the ordinary and `--node-window-constants` modes of corrected #3247 `a60859270d960707df809d310ae895b0672d4fef` compiled all 34 Lua and 1,336 musl objects separately by corpus on Ryzen 7 9700X CPU 2. Each single-lane timed process compiled its complete set of inputs. The two candidate modes ran the identical executable.

| Corpus | Comparison | Total cycles/token, median [min, max] | User instructions, paired median | True wall ms, median [min, max] |
| --- | --- | ---: | ---: | ---: |
| [lua](lua/samples.tsv) | plain minus baseline | +1.2866 [+0.9311, +4.6700] | -163,164.0 | +0.0675 [−0.1845, +0.0685] |
| [lua](lua/samples.tsv) | constants minus plain | +2.1433 [−1.1395, +4.5527] | -1,304,984.5 | +0.2695 [+0.0495, +0.3140] |
| [lua](lua/samples.tsv) | constants minus baseline | +3.5304 [+3.0744, +5.8393] | -1,471,987.5 | +0.3370 [−0.1350, +0.3825] |
| [musl](musl/samples.tsv) | plain minus baseline | +0.9695 [−0.1957, +1.0386] | -1,448,979.0 | −2.4375 [−11.3405, +1.1695] |
| [musl](musl/samples.tsv) | constants minus plain | +0.0426 [−0.1807, +1.3592] | -1,356,428.5 | +1.3950 [+0.2210, +3.4230] |
| [musl](musl/samples.tsv) | constants minus baseline | +1.0812 [+0.7888, +1.1635] | -2,896,023.5 | +0.9855 [−11.1195, +2.5645] |

Each of three independent rounds per series used each mode twice in symmetric order. The tables report medians and ranges of paired within-round differences. Each PMU sample observed a fresh compiler. Every independent wall observation also used a fresh compiler and followed one warm-up invocation in the same mode. Thus each corpus used 18 timed PMU processes, 18 timed wall processes, 18 additional wall warm-up processes and 9 batch qualification processes. The per-source gate separately used one fresh stage-counter process per translation unit with the constants option; each output matched the bulk compile manifests. Every PMU counter ran at 100% enabled time. The production command and the harness are included below.

The [command](constants-corpus-one.sh), [schedule](constants-corpus.sh), [corpus definitions](corpora.sh) and [manifest collector](full-chain-manifest.py) reproduce the measurements.
