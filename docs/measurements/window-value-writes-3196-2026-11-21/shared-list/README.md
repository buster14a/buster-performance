# One list for three sources of a first entry

One experimental build for item 3 of [Buster #3196](https://github.com/buster14a/buster/issues/3196), based on [b3b6c3010](https://github.com/buster14a/buster/commit/b3b6c30102a68f47ab94247471ca4dd9924933a2). Three formerly separate lists now share a single list of the records whose first native entry carries a record payload, a stored operand or an integer constant. The list is compressed in record order. A single loop reads the shape's source byte, selects the source record and extends the integer constant when applicable. Other specialized values and numbering keep the original code.

The table reports the **combined row write and values passes, in TSC ticks per swept record**. Both executables used Release on locked Ryzen 7 9700X CPU 2. Seven rounds alternated ABBA and BAAB for each of the three corpora. Every one of the 84 invocations exited zero with the same coverage, no differing rows, and no difference between repeated executions. SQLite produced 315,461 admitted native entries, Lua 64,738 and musl 204,112.

| Corpus | First ordinary / changed | First paired change [range] | Repeat ordinary / changed | Repeat paired change [range] |
| --- | ---: | ---: | ---: | ---: |
| sqlite | 4.262 / 8.500 | +4.315 [+4.158, +4.369] | 2.794 / 4.133 | +1.344 [+1.329, +1.372] |
| lua | 6.763 / 9.274 | +2.531 [+2.408, +2.600] | 3.387 / 4.663 | +1.266 [+1.238, +1.289] |
| musl | 11.501 / 14.608 | +2.958 [+2.618, +4.479] | 4.090 / 5.570 | +1.486 [+1.379, +1.556] |

[paired.tsv](paired.tsv) includes the two intervals separately and together, all rows, the corresponding totals, and costs per admitted record. Each round averages its two readings for each binary before taking the difference. The columns give medians across rounds and the range of the seven paired differences.

[runs.tar.xz](runs.tar.xz) contains the original outputs, errors and exit statuses. To reproduce the tables, extract it and run `python3 scripts/pairs.py slots runs`. [environment.txt](environment.txt) records the source and binary revisions and host. The source difference is [experiment.patch](experiment.patch). The hardware runner and its corpus and lock scripts are in [scripts](scripts). The start script uses the already-built baseline executable in the directory of [the sweep-counter experiment](../../window-sweep-counters-3196-2026-11-21/). For the candidate, apply this patch to the same revision and build using `./build.sh --config Release`.
