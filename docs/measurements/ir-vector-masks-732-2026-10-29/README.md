# The IR's vectors and masks, Buster #732

Compiler branch: `claude/ir-vector-masks-732` of buster14a/buster, its pull request
buster14a/buster#843, for [this claim on #732](https://github.com/buster14a/buster/issues/732#issuecomment-6489493992).

The branch gives the shared IR first-class integer vectors (`v4i32`, `v8i32`, `v16i32`) and opmasks (`m8` to `m64`),
with `vconst`, `vcmp` and `vselect`, the verifiers' rules for them, and the consumers' refusal of any function that has
one: #748's work, merged with main and continued there. This record holds the 9700X's comparison of its final head
with main, on the code every compile runs whether or not it has vectors: the verifier and the derived arrays, the
typed stream's lowering, `benchmark-ir-source`'s verification and promotion on SQLite, and `-c` of SQLite.

## Sources and host

Each tree is a `git archive` of its commit, extracted into a fresh directory on the 9700X;
`logs/pairs/manifest-*.sha256` lists every file's SHA-256 as the host had it after the runs, which matched
`git archive` of each commit file for file:

- **main:** `5104e7e720e1ba7965857e888fedc1b4e922e181`, the branch's merge base after its second merge with main;
- **head:** `79da27b28dfaf00079081d8310fec210acc87d7c`, the branch's final head.

Host (`logs/pairs/host.txt`, captured after the runs, from the same session): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts,
clang 23.1.1, perf 7.2.9, CPU 2's governor and energy preference `performance`. Every build, measurement and the
receipts took a separate hold of the host's lock (`exclusive.sh`), and every measurement ran pinned to CPU 2. The lock's
waiting messages are left out of the logs: only the lines the scripts, `build.sh` and the compiler print are kept (an
allowlist of their shapes). Builds: `BUSTER_DEBUG_INFO=0 ./build.sh`; `logs/pairs/executables.sha256` gives the
executables' SHA-256.

Input for `benchmark-ir-source`: SQLite 3.53.2's `sqlite3.c` from the host's frozen corpora
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`), SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the 9700X job's `benchmark-backend-source`
options (its pinned predefines and headers, `-std=gnu17 -march=znver5`). `-c` compiled the same file with
`-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`, under
`SOURCE_DATE_EPOCH=1792454400`.

## Main against head

`scripts/q732b.sh` (`logs/pairs/`): both builds, then main and head alternating, the order turning each round, three
rounds of `benchmark-ir` and `benchmark-ir-lowering` (whole runs, each figure a 21-pass median), of
`benchmark-ir-source --only verify`, `--only verify-scalar` and `--only promote`, and of `-c` under
`perf stat -r 11` (each round's figure the mean of 11 runs). The medians of the three rounds:

| Run | Main | Head | Change |
| --- | ---: | ---: | ---: |
| `benchmark-ir`, 32 instructions: scalar verifier, ns per instruction | 9.656 | 9.743 | +0.90% |
| vector verifier | 6.021 | 6.146 | +2.08% |
| uses | 10.848 | 10.877 | +0.27% |
| CFG | 1.748 | 1.786 | +2.17% |
| `benchmark-ir`, 262,144 instructions: scalar verifier | 8.750 | 8.929 | +2.05% |
| vector verifier | 5.388 | 5.400 | +0.22% |
| uses | 12.070 | 12.287 | +1.80% |
| CFG | 1.400 | 1.398 | −0.14% |
| `benchmark-ir-lowering`, ns per typed entry: small mixed, scalar | 36.007 | 35.509 | −1.38% |
| small mixed, vector | 32.498 | 32.205 | −0.90% |
| larger mixed, scalar | 74.567 | 74.213 | −0.47% |
| larger mixed, vector | 66.424 | 66.176 | −0.37% |
| larger with objects, scalar | 58.984 | 58.779 | −0.35% |
| larger with objects, vector | 53.098 | 52.945 | −0.29% |
| larger with the dynamic stack, scalar | 67.785 | 67.564 | −0.33% |
| larger with the dynamic stack, vector | 60.948 | 60.741 | −0.34% |
| `benchmark-ir-source` on `sqlite3.c`, ns per typed entry: `verify` | 23.02 | 23.30 | +1.22% |
| `verify-scalar` | 23.60 | 24.02 | +1.78% |
| `promote` | 159.05 | 159.06 | +0.01% |
| `-c sqlite3.c`: task-clock, ms | 127.39 | 127.96 | +0.45% |
| user cycles | 602,006,951 | 605,992,829 | +0.66% |
| user instructions | 1,314,753,042 | 1,314,719,589 | −0.0025% |

`benchmark-ir-lowering`'s isolated stack programs (`alloca`, `stack-save`, `stack-restore`, a few microseconds each)
moved by −2.8% to +1.1%, both ways; their rows are in the logs. The two trees wrote the same `sqlite3.o`
(`logs/pairs/pair-object-cmp.log` is `cmp`'s empty output).

Per typed entry of SQLite, head's verifier executes 330.93 instructions against main's 330.04 (+0.27%) and its scalar
twin 430.15 against 426.83 (+0.78%), which the vector rules' checks add to every instruction's verification.
Promotion, which now scans each function for vector values before it starts (64 instructions at a time), executes
2,519.65 against 2,523.26 (−0.14%). The verifier's time grows more than its instructions (+1.2% against +0.27% on
SQLite, and +0.2% to +2.1% in `benchmark-ir`). Where its loops fall moves its time by more than that between builds
of the same code (buster14a/buster#786), so the difference isn't its instructions' alone.

## Limitations

One corpus, SQLite, on one host, three rounds per tree. `-c`'s instruction counts include the startup and the
release, so its −33,453 instructions are the whole process's. The host receipts were captured after the runs.
