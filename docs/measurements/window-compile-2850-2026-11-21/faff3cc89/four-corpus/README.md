# Fresh-process compilation across Lua, musl and Buster

The default, regular and assignment modes ran the same native Ryzen 7 9700X Release compiler from Buster `faff3cc89e87489229c7b0eb43fd49106dc950a1` on CPU 2. The historical arm used public main `f0a204a9c335d6527979834e2d3bdd6af630c224` with ordinary flags. Changes against that arm include all intervening commits. Each timed workload used one new compiler process and one lane. That process compiled all source files of its corpus. Lua had 34 output objects, musl 1,336 and Buster one. All four modes used `--lanes 1 -c`. Regular added `--node-window` and assignments added `--node-window-assignments`.

| Corpus | Comparison | Total cycles/token, median [min, max] | User instructions, paired median | True wall ms, median [min, max] |
| --- | --- | ---: | ---: | ---: |
| [lua](lua/samples.tsv) | regular minus default | +1.3461 [+0.0598, +1.8008] | -1,416,198.5 | −0.0285 [−0.0360, +0.3100] |
| [lua](lua/samples.tsv) | assignments minus default | −0.9384 [−2.1230, −0.2657] | -1,538,300.0 | −0.1680 [−0.1770, +0.7500] |
| [lua](lua/samples.tsv) | assignments minus regular | −2.1829 [−2.2846, −2.0664] | -126,027.0 | −0.1320 [−0.1485, +0.4400] |
| [lua](lua/samples.tsv) | default minus historical | −91.3972 [−94.0459, −89.8919] | -128,461,837.5 | −9.5345 [−9.6040, −9.5035] |
| [lua](lua/samples.tsv) | regular minus historical | −90.0511 [−92.2451, −89.8320] | -129,877,502.5 | −9.5320 [−9.5705, −9.2940] |
| [lua](lua/samples.tsv) | assignments minus historical | −92.3357 [−94.3116, −92.0149] | -129,999,604.0 | −9.6805 [−9.7025, −8.8540] |
| [musl](musl/samples.tsv) | regular minus default | +0.0790 [−2.3596, +3.0337] | -4,248,275.0 | +0.8420 [−0.2930, +1.5235] |
| [musl](musl/samples.tsv) | assignments minus default | +1.0454 [−1.9856, +2.7976] | -2,539,218.5 | −0.0115 [−0.0145, +4.2675] |
| [musl](musl/samples.tsv) | assignments minus regular | +0.3740 [−1.9883, +2.7186] | +1,724,393.5 | +0.2785 [−0.8535, +2.7440] |
| [musl](musl/samples.tsv) | default minus historical | −22.1231 [−23.1262, −16.8831] | -119,340,404.5 | −19.3455 [−19.4380, −17.9225] |
| [musl](musl/samples.tsv) | regular minus historical | −19.2427 [−23.0472, −19.0894] | -123,553,729.5 | −18.2155 [−18.5960, −17.8220] |
| [musl](musl/samples.tsv) | assignments minus historical | −20.3286 [−21.0777, −18.8686] | -121,879,623.0 | −17.9370 [−19.4495, −15.0780] |
| [main](main/samples.tsv) | regular minus default | −2.2876 [−4.6454, +10.2596] | -2,987,923.0 | +3.7580 [−0.5225, +5.0350] |
| [main](main/samples.tsv) | assignments minus default | −0.8969 [−1.5392, +4.3524] | +1,166,019.0 | +2.0315 [−0.8665, +2.9485] |
| [main](main/samples.tsv) | assignments minus regular | +0.7483 [−5.9073, +3.7485] | +4,153,942.0 | −0.8095 [−3.0035, −0.3440] |
| [main](main/samples.tsv) | default minus historical | −29.3101 [−30.9559, −27.3187] | -122,015,026.0 | −16.5570 [−17.1085, −12.3735] |
| [main](main/samples.tsv) | regular minus historical | −29.6062 [−35.6013, −19.0505] | -125,005,608.5 | −12.7990 [−12.8960, −12.0735] |
| [main](main/samples.tsv) | assignments minus historical | −28.8579 [−31.8528, −24.9578] | -120,849,894.0 | −13.6085 [−15.0770, −13.2400] |

Each of three independent rounds per series used each mode twice in symmetric order. The tables report medians and ranges of paired within-round differences. Each PMU sample observed a fresh compiler. Every independent wall observation also used a fresh compiler and followed one warm-up invocation in the same mode. Thus each corpus used 24 timed PMU processes, 24 timed wall processes, 24 additional wall warm-up processes and 12 batch qualification processes. The per-source gate additionally used six independent ordinary processes and three independent stage-counter processes for every translation unit. Every PMU counter ran at 100% enabled time. The production command and the harness are included below.

The [command](main-history-corpus-one.sh), [schedule](main-history-corpus.sh), [corpus definitions](corpora.sh) and [manifest collector](full-chain-manifest.py) reproduce the measurements.
