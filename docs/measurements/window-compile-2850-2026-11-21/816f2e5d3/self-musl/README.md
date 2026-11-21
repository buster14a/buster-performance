# Buster and musl on the b86-based option-order change

Pristine public main b86eadcbd and the ordinary and `--node-window-constants` modes of the b86-based #3247 revision `816f2e5d3a5cd06117b4e16c5b5123a7385d4c06` compiled the Buster compiler object and all 1,336 musl objects separately by corpus on Ryzen 7 9700X CPU 2. Each single-lane timed process compiled its complete set of inputs. The two candidate modes ran the identical executable.

| Corpus | Comparison | Total cycles/token, median [min, max] | User instructions, paired median | True wall ms, one paired round |
| --- | --- | ---: | ---: | ---: |
| [main](main/samples.tsv) | plain minus baseline | −1.5922 [−3.6381, +0.9450] | -2,312,830.0 | +4.7790 |
| [main](main/samples.tsv) | constants minus plain | −4.9796 [−11.1981, −0.6662] | -105,415,980.5 | −8.4115 |
| [main](main/samples.tsv) | constants minus baseline | −6.5718 [−10.2531, −4.3043] | -107,721,439.5 | −3.6325 |
| [musl](musl/samples.tsv) | plain minus baseline | +0.8448 [−0.1284, +3.1384] | -1,466,944.5 | +3.9125 |
| [musl](musl/samples.tsv) | constants minus plain | −0.7176 [−0.7789, +1.5003] | -1,547,226.5 | −1.5685 |
| [musl](musl/samples.tsv) | constants minus baseline | +1.3719 [+0.1272, +2.3595] | -3,021,691.0 | +2.3440 |

Three complete PMU rounds and one complete independent wall round used each mode twice in symmetric order. The source owner stopped the remaining two wall rounds when branch integration exposed additional requirements for mapping parser tokens to source. The tables report medians and ranges of paired within-round differences. Each PMU sample observed a fresh compiler. Every independent wall observation also used a fresh compiler and followed one warm-up invocation in the same mode. Thus each corpus used 18 timed PMU processes, 6 timed wall processes, 6 additional wall warm-up processes and 9 batch qualification processes. The per-source gate separately used one fresh stage-counter process per translation unit with the constants option; each output matched the bulk compile manifests. Every PMU counter ran at 100% enabled time. The production command and the harness are included below.

The [command](corrected-constants-corpus-one.sh), [schedule](corrected-constants-corpus.sh), [corpus definitions](corpora.sh) and [manifest collector](full-chain-manifest.py) reproduce the measurements.
