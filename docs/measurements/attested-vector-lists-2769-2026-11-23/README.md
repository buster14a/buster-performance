# #2769: attested declarations' lists by a vector path (2026-11-23)

The 9700X (benchpress), Release builds, each run under `exclusive.sh`, pinned to CPU 2 with `setarch -R`
(`step.sh`, `queue*.sh`). The trees ran from `/tmp/2769-claude`: benchpress's `/home` was full (473 of 475 GB) and cut
two of the head's builds off with no error.

- base: main `a891cc05` (Release; its compiler copied from `~/buster-fast-bench/2769-claude/base`, sha256 `031ce5f3...`)
- head: branch `claude/2769-attested-vector-lists` `1e30a5cc` (file-scope lists by `check_attested_list_run`, each lane miss
  a run of one)
- head2: `1221d2b1` (a lane's run of misses one run; in-register compresses; one depth reduction a block)
- head3: `5c08f63b` (head2, a level's base in two bits, and a body's dedup marking 64 entries before compacting them)

The `stat-base-*` files are base's last round (queue4), beside head3's. Earlier rounds' figures are below.

## -c sqlite3.c (warm memo, 15 runs a round; user cycles)

| round | base memo | head memo | base off | head off |
| --- | ---: | ---: | ---: | ---: |
| head, 1 | 557.6 M | 563.8 M (page faults +32% spread) | 555.6 M | 551.0 M |
| head, 2 | 555.7 M | 592.4 M (±1.58%) | 547.9 M | 548.9 M |
| head2 | 554.7 M | 556.7 M | 547.5 M | 546.4 M |
| head3 | 557.6 M | 557.5 M | 548.9 M | 548.3 M |

Instructions: base 1,298.8 M with the memo, head3 1,294.1 M. Objects, stdout, diagnostics and status: every tree's memo run
the same bytes as its `--attested=off` run and as base's (`compare*.txt`).

## perf record, five warm compiles (about 27,000 samples)

`check_attested_lists` 0.90% on base; `check_attested_list_run` 0.84% (head2), 0.87% (head3), plus
`check_attested_listing` (the bounds, inlined in base's) 0.11%. The annotations (`annotate-head*.txt`) put most of the
run's cycles in a function body's dedup (each entry's mark by key), which base has too, not in the file-scope blocks.

## measure-attested --passes 5 (lists pass, cycles a token: all runs, first run)

| | sqlite3.c | musl's 1,336 units |
| --- | --- | --- |
| base | 4.79, 9.71 | 7.65, 11.58 |
| head | 7.67, 12.80 | 8.98, 12.71 |
| head2 | 6.49, 9.91 | 7.89, 11.71 |
| head3 | 6.65, 10.34 | 7.88, 11.80 |

The lists and every outcome, listed declaration, event and cache count are base's (`--twins`: no difference).
