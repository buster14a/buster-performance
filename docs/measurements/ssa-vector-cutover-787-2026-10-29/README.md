# SSA promotion's vector path, Buster #787

Compiler branch: `claude/ssa-vector-path-787` of buster14a/buster, for
[this claim on #787](https://github.com/buster14a/buster/issues/787#issuecomment-6489491348).

`ssa_ir_promote`'s vector path was 6% slower than its scalar twin on the frozen
`sqlite3.c`'s functions. This record holds the 9700X runs that found why and
measured the fix. They are a profile of both paths, each function's
promotion timed by both paths, and main against head for the change.
`ssa_ir_promote` now takes the vector path only for a function of at most 16,384
(block, slot) cells, and the scalar constructor for larger ones.

## Sources and host

Each tree is a `git archive` of its commit, extracted into a fresh directory on
the 9700X; `logs/pairs/manifest-*.sha256` lists every file's SHA-256 as the host
had it after the runs, which matched `git archive` of each commit file for file:

- **main:** `74af99374e75a1325f5ffce7932fca372585a490`, the branch's base;
- **head:** `bfde0695cb4c70348037717b9157bfe0bdbde7c1`, the cutover;
- **tree:** `229c3cefcfc067e8a8f68fc5c8fe29c1cc547265`, the branch's first commit,
  which adds `benchmark-ir-source --functions` and changes nothing else.

The profile (`scripts/q787.sh`) ran main `d11a91d2470784f627e9b69537f6b491ab8f2c5b`'s
build, the base of buster14a/buster#845, whose record holds its manifest
([ir-backend-unit-784-2026-10-29](../ir-backend-unit-784-2026-10-29)).

Host (`logs/pairs/host.txt`, captured after the runs, from the same session):
AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2's
governor and energy preference `performance`. Every build, measurement and the
receipts took a separate hold of the host's lock (`exclusive.sh`), and every
measurement ran pinned to CPU 2. The lock's waiting messages are left out of the
logs: only the lines the scripts, `build.sh` and the compiler print are kept (an
allowlist of their shapes). Builds: `BUSTER_DEBUG_INFO=0 ./build.sh`;
`logs/pairs/executables.sha256` gives the executables' SHA-256.

Input: SQLite 3.53.2's `sqlite3.c` from the host's frozen corpora
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`), SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the 9700X
job's `benchmark-backend-source` options (its pinned predefines and headers,
`-std=gnu17 -march=znver5`).

## Why the vector path was slower

`scripts/q787.sh` (`logs/profile/`): `benchmark-ir-source --only promote` took
161.12 ns per typed entry and `--only promote-scalar` 152.27 (162.35 after 200 ms
of scalar work before each sample). Over whole runs (`stat-*.csv`), the vector
path executed 25.62 billion user instructions against 23.58 billion, in 9.23
billion cycles against 8.84 billion, with 458 million throttled dispatch slots
(PMCx1A0, umask 0x08) against 268 million. The symbol profiles (`report-*.txt`)
put both paths' time in `ssa_ir_promote_path` and `ir_verify_path`, into which
clang inlined the phases. A Zen 4 laptop's build without that inlining (not in
this record) split it: `ssa_construct_vector` 20.3% against the scalar
constructor's 6.4% and its simplification's 9.7%.

`scripts/q787b.sh` (`logs/profile/functions-sqlite.log`): each of the 2,602
functions' promotion timed by both paths, `benchmark-ir-source --functions`,
each path's least time per run over five samples of at least 0.5 ms together.
Totals: the vector path 40.15 ms, the scalar path 37.01 ms, each function's
faster path 35.32 ms. By (block, slot) cells, the vector path's time against the
scalar path's:

| Cells | Functions | Vector | Scalar | Ratio |
| --- | ---: | ---: | ---: | ---: |
| up to 2^4 | 1,239 | 2.94 ms | 2.91 ms | 1.009 |
| 2^5 to 2^14 | 1,355 | 23.69 ms | 24.82 ms | 0.955 |
| 2^15 and more | 8 | 13.52 ms | 9.28 ms | 1.457 |

(A function without slots, 44 of them, counts as its blocks; each row takes
the functions whose cells' log2, rounded down, falls in it. The last row's eight
include `sqlite3VdbeExec`, 763,840 cells, 6.53 ms against 3.91.) The vector path's phi placement, entry definitions and renaming
each pass over every cell, where the scalar constructor's work follows the
instructions. Taking the vector path up to a bound of cells and the scalar one
past it gave 35.96 ms at 16,384 cells; every bound from 8,192 to 32,768 came
within 0.2% of that. `local/functions-sqlite-zen4.txt` is the same run on the
laptop, where the totals were 71.99, 65.01 and 61.67 ms and the bound of 16,384
gave 62.70. `q787b.sh`'s musl run refused, since `benchmark-ir-source` refuses a
corpus with files left out.

## Main against head

`scripts/q787c.sh` (`logs/pairs/`), main and head alternating, the order turning
each round, three rounds, ns per typed entry:

| Run | Main | Head | Change |
| --- | --- | --- | ---: |
| `--only promote` | 160.69, 160.35, 160.43 | 148.60, 148.56, 148.67 | −7.37% |
| `--only promote --after-scalar 200` | 160.87, 160.89, 160.78 | 148.42, 148.73, 148.29 | −7.74% |
| `--only promote-scalar` | 152.20, 152.03, 152.33 | 151.10, 150.47, 151.43 | −0.72% |

Head's `promote` executes 2,208.3 instructions per typed entry against main's
2,535.2, and 13.36 throttled dispatch slots per IR instruction against 31.45.
The scalar path's code didn't change: its −0.72% is the comparison's floor. The
results of both paths are the same functions in both trees (`test-ir-source`
on the branch: 493,934 promoted instructions for `sqlite3.c`, as on main).

## Limitations

One corpus, SQLite, on one host. The per-function times are least-of-five
samples, not medians. The host receipts were captured after the runs.
