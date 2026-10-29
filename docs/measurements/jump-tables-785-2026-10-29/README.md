# A jump table's br_indirect to its own labels, Buster #785

Compiler branch: `claude/jump-tables-785` of buster14a/buster, pull request
[#842](https://github.com/buster14a/buster/pull/842), for
[this claim on #785](https://github.com/buster14a/buster/issues/785#issuecomment-6489490596).

The branch gives Tier 0's typed stream two optional columns for jump tables
(each label's table, `label_tables`, and each table's `JUMP_INDIRECT`,
`table_jumps`), which the checker's lowering writes and `tier0_validate`
checks, and lets the IR's `br_indirect` list the labels it goes to, so that
the typed-stream adapter gives each jump table's jump a `br_indirect` of its
own table's labels rather than sending every `JUMP_INDIRECT` through one
dispatch block of every label. This record holds the IR's counts before and
after on the frozen `sqlite3.c`, and the 9700X's main-against-head comparisons
of `-c`, `benchmark-backend-source` and `benchmark-ir-source`.

## Sources and host

Each tree is a `git archive` of its commit, extracted into a fresh directory on
the 9700X; `logs/manifest-*.sha256` lists every file's SHA-256 as the host had
it after the runs, which matched `git archive` of the commits file for file:

- **main:** `e85d634af17bd9f2bf7991815aff695fde326170`, the branch's base;
- **head:** `fa87e1a70662a678601746402bd9925e412c37c8`.

Host (`logs/host.txt`, captured after the runs, from the same session): AMD
Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2's governor
and energy preference `performance`. Every build, measurement and the receipts
took a separate hold of the host's lock (`exclusive.sh`), and every measurement
ran pinned to CPU 2. The lock's waiting messages are left out of the logs, since
they name other jobs: only the lines the scripts, `build.sh`, `ab` and
`time-runs` print are kept (an allowlist of their shapes).

Builds: `BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job builds.
`logs/executables.sha256` gives the executables' SHA-256 as the host had them
after the runs; the placement step (`scripts/q785b.sh`) rebuilt each tree's
`build/compiler` from the same sources and flags before linking its shifted
copies, so the `perf stat` pairs ran the executables before that rebuild.

Input: SQLite 3.53.2's `sqlite3.c` from the host's frozen corpora
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`), SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`: for `-c`,
with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5
-DSQLITE_ENABLE_RTREE`; for the benchmarks, with the 9700X job's
`benchmark-backend-source` options (its pinned predefines and headers,
`-std=gnu17 -march=znver5`).

## The IR before and after

`scripts/phis.sh` ran each tree's `test-ir-source --print sqlite3VdbeExec` and
`benchmark-ir-source --only lower` on a Zen 4 laptop (the counts don't depend
on the host), its output in `local/`:

| | main | head |
| --- | ---: | ---: |
| `sqlite3VdbeExec`'s `br_indirect`s | 1 | 5 |
| `sqlite3VdbeExec`'s promoted phis | 443 | 267 |
| `sqlite3VdbeExec`'s promoted phi pairs | 6,089 | 3,187 |
| `sqlite3.c`'s lowered instructions | 598,568 | 598,388 |
| `sqlite3.c`'s lowered bytes | 13,986,379 | 13,986,315 |
| `sqlite3.c`'s promoted instructions | 493,934 | 493,515 |
| `sqlite3.c`'s promoted bytes | 12,227,119 | 12,196,975 |

## The 9700X

`scripts/q785.sh` (`logs/progress`), main and head alternating, the order
turning each round:

- `-c` of `sqlite3.c`, `perf stat -r 11` per tree per round
  (`logs/pair-compile-*.csv`, exit statuses in `logs/pair-compile.log`): the
  objects are byte-identical (`logs/pair-object-cmp.log`, `cmp`'s status 0 in
  `logs/progress`); user instructions 1,314.136 million (main) against
  1,314.210 million (head), each round alike; user cycles 598.8, 599.7 and
  599.6 million against 603.6, 604.3 and 603.5 million (+0.67%).
- `benchmark-backend-source`, three rounds (`logs/pair-backend-source-*.log`):
  `validate` 2.29 ns per typed entry in both, `validate-scalar` 8.29 against
  8.34, the others within their rounds' spread.
- `benchmark-ir-source --only lower`, three rounds
  (`logs/pair-ir-source-*.log`): 47.70, 47.79 and 47.58 against 46.74, 46.72
  and 46.72 ns per typed entry.

`scripts/q785b.sh` (`logs/progress-b`, `logs/placements.log`) then compared
`-c` over its code's placements, by #509's method: each tree linked six times
with the checker's unit shifted by 0, 640, 1,344, 2,048, 2,752 and 3,456 bytes
(`logs/shifts-*.log`), each link run from three fresh copies, and main's links
a second time as the floor (`main-again`), in three rounds of `time-runs`
under `ab`, which took the lock for each round:

| Round | head, user cycles | main-again, user cycles | head, wall | main-again, wall |
| ---: | ---: | ---: | ---: | ---: |
| 1 | −0.10% | +0.19% | −0.11% | +0.02% |
| 2 | +0.09% | +0.05% | +0.06% | +0.05% |
| 3 | −0.08% | +0.01% | +0.03% | +0.08% |

Every range over the placements includes 0. The +0.67% of the `perf stat`
pairs, one placement of each tree, is the placement's: the 74,000 more
instructions of the columns' stores and the validator's passes are 0.006%.

## Limitations

The `perf stat` pairs compare one link of each tree; only the placement
comparison separates the code's placement from its work. The host receipts were
captured after the runs. The IR's counts come from a laptop, not the 9700X.
