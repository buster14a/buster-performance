# Fresh-process compilation across Lua, musl and Buster

All modes ran the same native Ryzen 7 9700X Release compiler from Buster `8ac05e9c35594cb84685ddfa76fb2f46a5e9a3ee` on CPU 2. Each timed workload used one new compiler process and one lane. That process compiled all source files of its corpus. Lua had 34 output objects, musl 1,336 and Buster one. All three modes used `--lanes 1 -c`. Regular added `--node-window` and assignments added `--node-window-assignments`.

| Corpus | Comparison | Total cycles/token, median [min, max] | User instructions, paired median | True wall ms, median [min, max] |
| --- | --- | ---: | ---: | ---: |
| [lua](lua/samples.tsv) | regular minus default | −0.0231 [−1.4115, +0.5177] | -2,100,175.5 | +0.1780 [−0.0165, +0.3270] |
| [lua](lua/samples.tsv) | assignments minus default | +2.1674 [+1.3080, +2.6664] | -2,223,162.5 | +0.2265 [+0.0710, +0.2965] |
| [lua](lua/samples.tsv) | assignments minus regular | +2.1905 [+2.1487, +2.7195] | -121,236.0 | +0.0485 [−0.0305, +0.0875] |
| [musl](musl/samples.tsv) | regular minus default | +1.1566 [+1.0665, +3.1353] | -10,016,127.5 | +2.1955 [+2.1195, +2.7025] |
| [musl](musl/samples.tsv) | assignments minus default | +2.2365 [+1.9641, +2.9972] | -8,145,012.0 | +2.5465 [+1.7770, +2.7435] |
| [musl](musl/samples.tsv) | assignments minus regular | +0.8976 [−0.1382, +1.0800] | +1,776,813.0 | +0.3510 [−0.9255, +0.6240] |
| [main](main/samples.tsv) | regular minus default | +1.1785 [+0.8749, +1.3808] | -11,076,575.0 | −0.5850 [−1.8155, −0.5820] |
| [main](main/samples.tsv) | assignments minus default | +2.1411 [+1.9581, +4.5286] | -6,890,340.5 | +1.0955 [+0.2125, +6.0800] |
| [main](main/samples.tsv) | assignments minus regular | +1.0832 [+0.9627, +3.1478] | +4,183,117.5 | +2.0280 [+1.6805, +6.6620] |

Each of three independent rounds per series used each mode twice in symmetric order. The tables report medians and ranges of paired within-round differences. Each PMU sample observed a fresh compiler. Every independent wall observation also used a fresh compiler and followed one warm-up invocation in the same mode. Thus each corpus used 18 timed PMU processes, 18 timed wall processes, 18 additional wall warm-up processes and 9 batch qualification processes. The per-source gate additionally used six independent ordinary processes and three independent stage-counter processes for every translation unit. Every PMU counter ran at 100% enabled time. The production command and the harness are included below.

The [command](main-window-corpus-one.sh), [schedule](main-window-corpus.sh), [corpus definitions](corpora.sh) and [manifest collector](full-chain-manifest.py) reproduce the measurements.
