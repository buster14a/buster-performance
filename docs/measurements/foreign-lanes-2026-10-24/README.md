# Foreign links on lanes (#87), 2026-10-24

The 9700X's validation and lane sweeps of `link-foreign` with the foreign
conversion on lanes, for Buster's #87 (linker plan step 8). `docs/linker-scaling.md`
("Complete foreign links, 2026-10-24") and the linker design's plan cite this
record. It measures the complete foreign link, the resolution, the conversion
and the writer, phase by phase, on 1 to 20 lanes; the direct path's and
`foreign_run`'s earlier sweeps are in the scaling document itself.

## Source and host

- Source: #87's branch at `37dbecb`, on #86's `b3c7bf1` (the conversion on
  lanes and `--time`'s conversion phases, before the branch was rebased onto
  main after #380 merged, and before `link-foreign` capped its lanes at its
  CPUs; every run here had a CPU per lane but the past-the-CPUs runs, which
  measure what the cap prevents). [Source manifest](source.sha256): the
  SHA-256 of each file of `git archive 37dbecb`, SHA-256
  `78f6c1c22cb864eca2621cd76ae52711bf94c843e79b8806e90e4615e9229d83`.
- `build/compiler` SHA-256:
  `57a65144d9959efc4915dffc70a0c075d2563ae8a9b9fc5d13202cdf7ec78f8f`.
- Host ([host.txt](host.txt)): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts,
  CPUs 0-9 and 11-15 online (CPU 10, CPU 2's SMT sibling, offline), CPU 2
  under the performance governor and the others powersave, as observed.
  clang 23.1.1, GCC 16.2.1, lld 23.1.1, mold 3.0.0.
- Each step took the shared lock on its own, through
  `~/buster-fast-bench/exclusive.sh` with `EXCLUSIVE_OWNER=claude-linker-80`
  and `EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/87`, CI
  first. The lock's waiting messages, which name other runs, are removed from
  the logs; nothing else in them is changed.

The scripts are [phase87.sh](phase87.sh) (the build, the tests, the corpus, the
sweep's three rounds and the small links), [sweep87.sh](sweep87.sh) (one round)
and [phase87b.sh](phase87b.sh) (lanes past the CPUs); [tables.py](tables.py)
makes the scaling document's tables from the sweep's logs.

## Validation

- [build.log](build.log) and [callgraph.log](callgraph.log): the build, and
  the call graph check (no cycles past the 3 allowed).
- [tests.log](tests.log): the job's 68 test commands ([tests.txt](tests.txt)),
  all passed, among them `test-foreign --cross-check`, whose driver cases
  compare 1, 2, 3 and 8 lanes' outputs byte for byte.
- [corpus.log](corpus.log): `test-foreign-corpus` with SQLite 3.53.4's shell,
  Lua 5.4.8 and the compiler itself, 174 checks, 0 failures: each program
  linked by `link-foreign`, lld and mold, and by `link-foreign` on eight lanes
  into the same bytes as on one.

## Measurements

The sweep ([sweep-r1.log](sweep-r1.log), [sweep-r2.log](sweep-r2.log),
[sweep-r3.log](sweep-r3.log)) links synth's shape, `benchmark-link`'s 512
objects (96 MB) of 102,400 workers, into a 49 MB dynamic PIE with #86's command
line (the [#86 record](../foreign-link-2026-10-24/)'s `foreign-command.txt`,
its objects kept on the host in `/tmp/buster-link-benchmark-qTkbYK`): 11 links
with `--time` at each of 1 to 8, 10, 12 and 15 lanes per round, in the orders
1 to 15, 15 to 1 and 4, 1, 8, 2, 12, 3, 7, 15, 5, 10, 6, N lanes pinned to the
first N CPUs of 2, 0, 1, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15. Medians of the
33 links, ms:

| Lanes | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 10 | 12 | 15 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| The whole link | 54.18 | 37.26 | 31.36 | 29.00 | 27.94 | 27.73 | 27.55 | 28.12 | 31.19 | 32.57 | 34.72 |
| Resolution | 21.25 | 13.32 | 11.12 | 10.13 | 9.65 | 9.74 | 9.64 | 9.92 | 11.42 | 12.09 | 13.38 |
| Conversion | 20.32 | 14.78 | 11.59 | 10.19 | 9.46 | 9.05 | 8.85 | 8.81 | 9.81 | 9.95 | 10.20 |
| Write | 9.66 | 6.23 | 5.70 | 5.62 | 5.66 | 5.77 | 5.90 | 6.00 | 6.70 | 7.26 | 7.84 |

Past the CPUs ([over-r1.log](over-r1.log), [over-r2.log](over-r2.log),
[over-r3.log](over-r3.log)): 15, 16 and 20 lanes on all 15 CPUs, three rounds
in turned orders, 11 links each. The whole link took 34.47 ms on 15 lanes,
80.25 on 16 and 89.97 on 20. Each sync waited about a scheduler slice: the
writer's layout, symbols and open phases, 0.03 to 0.10 ms on 15 lanes, took
about 1.0 each on 16.

[small-hello.log](small-hello.log) and [small-tcc.log](small-tcc.log) link
the design appendix's `hello.o` and tcc on 1, 2, 3, 4 and 8 lanes (pinned to
as many CPUs, output on tmpfs), timed by the appendix's `timeit` (41 runs after
a warm-up, 20 ms apart): hello 0.598, 0.894, 1.176, 1.238 and 1.761 ms, tcc
1.094, 1.311, 1.470, 1.717 and 2.179. Each log's last link ran `--time` on 8
lanes pinned to one CPU, by mistake, which measured the same thing as the
past-the-CPUs runs on a small link: hello took 341.7 ms, each pass of the
conversion about 28.

## Limitations

Medians of `--time`'s in-process stage times (wall clock from the command's
start to the release's end), from one machine and one session; the logs give
every link. The resolution's phases are its slowest lane's times, the
conversion's and the writer's lane 0's from sync to sync, so a phase's syncs'
waits fall in the phase after it where its timer ends before them. The input is
generated: synth's shape, not a real program's objects.
