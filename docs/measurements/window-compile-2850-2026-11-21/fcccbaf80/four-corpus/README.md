# Current-main constant operands across four corpora

Pristine public main faff3cc89 and the ordinary and `--node-window-constants` modes of corrected #3247 `fcccbaf80b64a302d4d8e79ca393fa6f0ac82f0c` compiled the SQLite amalgamation, all 34 Lua files, all 1,336 musl files and the Buster compiler on Ryzen 7 9700X CPU 2. Each single-lane timed process compiled its complete set of inputs. The two candidate modes ran the identical executable.

| Corpus | Comparison | Total cycles/token, median [min, max] | User instructions, paired median | True wall ms, median [min, max] |
| --- | --- | ---: | ---: | ---: |
| [sqlite](sqlite/samples.tsv) | plain minus baseline | +0.3450 [−2.8267, +3.0106] | +41,781.0 | +0.0590 [−0.2810, +0.4500] |
| [sqlite](sqlite/samples.tsv) | constants minus plain | +1.8072 [+1.0330, +3.1321] | -4,603,593.5 | −0.0740 [−0.5355, +0.2500] |
| [sqlite](sqlite/samples.tsv) | constants minus baseline | +1.3779 [+0.3054, +4.8178] | -4,561,772.5 | −0.0310 [−0.0855, −0.0150] |
| [main](main/samples.tsv) | plain minus baseline | −3.3582 [−4.0877, +0.9754] | +212,519.5 | +0.4560 [−2.3975, +4.5425] |
| [main](main/samples.tsv) | constants minus plain | −11.7544 [−16.5960, −8.7029] | -102,657,460.0 | −8.6390 [−11.2455, −3.8360] |
| [main](main/samples.tsv) | constants minus baseline | −12.7906 [−19.9542, −10.7790] | -102,444,940.5 | −6.2335 [−10.7895, −4.0965] |
| [lua](lua/samples.tsv) | plain minus baseline | +2.3761 [−0.4724, +3.8133] | +17,516.0 | +0.1155 [+0.0820, +0.2170] |
| [lua](lua/samples.tsv) | constants minus plain | +0.7630 [−3.4686, +1.3648] | -1,031,256.0 | −0.1905 [−0.2315, −0.1700] |
| [lua](lua/samples.tsv) | constants minus baseline | +0.3447 [+0.2906, +3.7410] | -1,013,740.0 | −0.0545 [−0.1495, +0.0265] |
| [musl](musl/samples.tsv) | plain minus baseline | +1.4607 [+1.0238, +1.5252] | +344,141.0 | +0.9925 [−0.0740, +1.4880] |
| [musl](musl/samples.tsv) | constants minus plain | +0.7430 [−0.7000, +4.3753] | +2,049,381.5 | +0.7300 [−0.2890, +3.4465] |
| [musl](musl/samples.tsv) | constants minus baseline | +2.2682 [+0.3238, +5.8359] | +2,390,094.0 | +2.2180 [−0.3630, +4.4390] |

Each of three independent rounds per series used each mode twice in symmetric order. The tables report medians and ranges of paired within-round differences. Each PMU sample observed a fresh compiler. Every independent wall observation also used a fresh compiler and followed one warm-up invocation in the same mode. Thus each corpus used 18 timed PMU processes, 18 timed wall processes, 18 additional wall warm-up processes and 9 batch qualification processes. The per-source gate separately used one fresh stage-counter process per translation unit with the constants option; each output matched the bulk compile manifests. Every PMU counter ran at 100% enabled time. The production command and the harness are included below.

The [command](profiled-constants-one.sh), [schedule](profiled-constants.sh), [corpus definitions](corpora.sh) and [manifest collector](full-chain-manifest.py) reproduce the measurements.
