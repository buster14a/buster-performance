# The checker's graph and program passes on sqlite3.c, before and after #530

Raw evidence for buster's `docs/compile-time.md` (buster14a/buster#530): the
C driver's `-c` of SQLite 3.53.2's `sqlite3.c` by two builds, interleaved on
the 9700X, with `--time-stages`' report of each stage, perf's counters of the
whole compile, and `benchmark-checker-source`'s time per node of the graph run;
and, from a laptop, the counts behind the analysis.

## Identity

- **Revisions:**
  - base: buster `373ce21baa761e4589b1b0736a14dba994ccb041`, which merges
    PR #520's head `ea673e4b7539d36816f3fb00ad89e13463766d18` (the stage clock)
    into main `ad408cf2ec956860833db81e4333c5faa78390fe`;
  - head: `0b5af444e1fc62d57847402d00cca3beef8144a5`, three commits on base
    (`78368090d76a89976aead438f956a95094ff0a65`,
    `1c8682f9d85dbe1492fe5aafedda1be6466198ae` and `0b5af444`) on branch
    `claude/github-issue-530-3ae620`.
- **Host:** `benchpress`, an AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, every
  run under the host's lock and pinned to CPU 2.
- **Compilers:** each tree built with `BUSTER_DEBUG_INFO=0 ./build.sh`
  (clang 23.1.1, `-O3 -march=native`):
  - base `187db5557e65c8edec8d95b7d9136116f42a74081c609d84bae0aa489ac00169`;
  - head `1865909bbba591b282d4355d23a3aa5695367c2333db46ab14f1c69d818f9496`.
- **Source:** `sqlite/sqlite3.c` of the frozen corpus
  `preprocessor-391e729af658`, sha256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the
  host's default headers.
- **Date:** 2026-10-27, from 13:06:44 UTC.

## Commands

`ab.sh` is the script, with every command. The options, for both builds, are
#518's (`compile-time-518-2026-10-27`):

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c"
```

- **Objects:** base, head and head with `--scalar` each wrote the object; all
  three are the same bytes (`objects identical: 0c48ff92978c3125` in `run.log`).
- **Stages:** 15 rounds of `--time-stages`, each build once a round, in an
  order that alternates by round, three holds of the lock of 5 rounds each.
- **Counters:** `perf stat -r 11 -e task-clock,cycles:u,instructions:u,branch-misses:u`
  of each build's default compile.
- **Graph run:** `benchmark-checker-source --passes 11 --only vector` of each
  build, twice, alternating: the graph run (`check_graph_run`) of the bodies'
  319,193 nodes alone, after both paths checked the whole unit and agreed
  (`comparison=identical`).

## Files

- `run.log`: the script's own lines. exclusive.sh's messages about other
  holders of the lock are removed: they name other sessions' commands and links.
- `stages.txt`: every `--time-stages` report, each line prefixed by its build.
- `stat-base.txt`, `stat-head.txt`: perf stat's reports.
- `graph.txt`: the graph benchmark's summary lines.
- `build-head.log`: head's build (base's built in an earlier run of the
  same tree).
- `laptop/`: the counts behind #530's analysis (below).
- `SHA256SUMS`: the files' hashes.

## Results

Medians of the 15 runs of each build:

| stage | base | head | change |
| --- | ---: | ---: | ---: |
| check-expressions | 20.262 ms | 15.515 ms | -4.747 ms (-23.4%) |
| check-program | 15.936 ms | 12.235 ms | -3.701 ms (-23.2%) |
| the clock's span | 190.517 ms | 181.889 ms | -8.628 ms (-4.5%) |

- **Ranges.** check-expressions ran 20.001 to 21.187 ms on base and 15.366 to
  16.980 on head; check-program 15.625 to 16.273 and 12.116 to 12.412.
- **The other stages.** Each is within 0.2 ms of base's median. `static-data`
  took 0.175 ms less, though no change touched it.
- **perf stat:**

  | | base | head | change |
  | --- | ---: | ---: | ---: |
  | task-clock | 190.19 ms | 181.67 ms | -4.5% |
  | cycles:u | 901.3 M | 854.3 M | -5.2% |
  | instructions:u | 2,227.3 M | 2,031.6 M | -8.8% |
  | branch-misses:u | 6.02 M | 5.65 M | -6.2% |

- **Graph run, a node:** base 55.2 and 54.0 ns (302.8 and 298.6 cycles), head
  40.2 and 40.3 ns (222.6 and 222.9 cycles). Base's vector path took 314,697
  nodes through actions and folded 4,496 in vectors. Head completes 147,114
  without an action: its leaves and those folds.

## The laptop's counts

`laptop/probe-frozen.txt` comes from base with `laptop/probe.patch`
(`laptop/probe530.h`, TSC laps and counters printed at exit), compiling the same
frozen `sqlite3.c` on the owner's laptop, a Ryzen 9 7940HS (Zen 4), with its own
headers. Those headers give the same unit: 715,602 tokens and 343,555 graph
nodes, which the 9700X's benchmark counts too. Each `opNN` line counts the
barrier nodes with that `CheckOp` value. Its ticks include the probes' own cost
and a loaded laptop's, so they show where time goes, not the 9700X's times:

- 203,218 of the 343,555 nodes (59%) took the scalar barrier. 70,518 of those
  are leaves (`VALUE`, op 0), then casts (28,795), `->` (24,623), assignments
  (13,910) and calls (13,685).
- The other 140,337 were in 45,283 regions, 26,823 of them of one node.
- `check_graph_validate` took 18.0 M of the 130.5 M ticks of `check_graph_run`.
- `check_program`'s passes took 85.0 M ticks. Its bodies took 46.8 M of them:
  their builds 24.9 M, their references 17.9 M. The unit-wide children lists
  took 10.7 M, their memsets 6.7 M, the cases 6.1 M and the objects 6.3 M.

## Limitations

- The caches were warm: every timed run followed a run of the same build.
- Each of the three holds of the lock ran 5 rounds. Other sessions' and CI's
  jobs ran between the holds.
- This is evidence for this source, workload, toolchain and machine only.
