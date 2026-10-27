# The checker's source reader on the 9700X (#529)

Raw evidence for buster14a/buster#529: the C driver's `-c` of SQLite 3.53.2's
`sqlite3.c` by main's compiler and by the branch's, as whole processes in
alternating order; the same pair with #520's stage clock merged into both, for
the stage table; and the reader alone (`benchmark-checker-bindings`).

## Identity

- **Date:** 2026-10-27, from 12:09 to about 12:30 UTC (the `perf stat` files have their start times).
- **Host:** `benchpress`, an AMD Ryzen 7 9700X, Linux 6.18.50-2-lts. Every
  run was pinned to CPU 2 and ran under the host's lock, one hold per script.
- **Compilers:** each tree was built on the host with
  `BUSTER_DEBUG_INFO=0 ./build.sh` (clang 23.1.1, `-O3 -march=native`), in a
  hold of its own. `identities.txt` has each executable's sha256.
- **Source:** `sqlite/sqlite3.c` of the frozen corpus
  `preprocessor-391e729af658`, sha256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.

The trees, by the directory each was built in:

| tree | revision | what it is |
| --- | --- | --- |
| `main-nd` | `ad408cf2ec956860833db81e4333c5faa78390fe` | main |
| `r1` | `0205c53b4a5521cc8a4757e5eeecfefef5a1574f` | the branch's first two commits: value chains counted, one count of the tokens and the scans |
| `b2` | `fc515daac84784827d19a59822f0c8db701c7a62` | the branch's head: and the walk's syntax bits |
| `m520` | `ea673e4b7539d36816f3fb00ad89e13463766d18` | PR #520's head: main `ad408cf2` and the stage clock |
| `b2-520` | tree `dc647c6b3feacd810bbd39b8e114a8a0c283c835` | `git merge-tree --write-tree fc515daa ea673e4b`: the head and the stage clock, never committed |

`manifests/` holds the sha256 of every file of each revision, from
`git archive`. Each tree on the host had the same files with the same hashes,
and one more, its `build.log`.

## Commands

The options of every compile:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c"
```

These are #518's step's options (`compile-time-518-2026-10-27`).

- `scripts/measure.sh A B OUT` takes the lock once:
  - It writes A's object as the reference.
  - Then 8 rounds. Each runs both executables in an order that alternates by
    round: a warm-up compile, then `perf stat -r 3 -e
    task-clock,cycles:u,instructions:u,cycles:k`. Every object must be the
    reference's, byte for byte (`cmp`).
  - Then `benchmark-checker-bindings --only direct --passes 11` of each, A's
    process then B's, with the options of the 9700X job's binding step.
- `scripts/stages.sh A B OUT` takes the lock once and runs #520's
  `measure-compile --runs 11` twice: A's with B's compiler as the reference,
  then B's with A's. Each rotates the default compile, `--time-stages` and the
  reference over 11 rounds after a warm-up.
- `scripts/queue2.sh` builds `b2`, `m520` and `b2-520`, then runs
  `measure.sh main-nd b2` and `stages.sh m520 b2-520`. `measure.sh main-nd r1`
  ran before it, by itself.

## Files

- `runs/m-r1`: main against round 1 (`r1`).
  - `stat-A-N.csv` and `stat-B-N.csv`: round N's `perf stat` CSV, A main's.
  - `bindings-A.txt` and `bindings-B.txt`: the reader alone.
  - `summary.txt`: `measure.sh`'s summary.
- `runs/m-b2`: the same for main against the head (`b2`).
- `runs/s-b2`: `measure-A.txt` (main with the clock, against the head with it)
  and `measure-B.txt` (the other way round).
  - Each holds every run's wall, user and system times, peak RSS and faults.
  - Each also holds the medians and the stage table.
- `queue2.log`: `queue2.sh`'s output, with the lock's messages about other
  holders left out.
- `scripts/`: the scripts, as they ran.

## Results

**The whole compile,** main against the head (`runs/m-b2`), medians of the 8
rounds. Every round's user cycles were apart: main 901.0 to 905.2 M, the head
817.9 to 822.5 M.

| | main | round 1 | head |
| --- | ---: | ---: | ---: |
| user cycles | 903.3 M | 825.6 M | 820.9 M |
| user instructions | 2,227.2 M | 2,064.8 M | 2,014.0 M |
| task clock | 190.93 ms | 176.98 ms | 176.12 ms |
| kernel cycles | 155.8 M | 155.2 M | 156.1 M |

Round 1's column is `runs/m-r1`'s, in its own hold. Main's medians there were
901.5 M cycles, 2,227.2 M instructions and 190.65 ms.

**The stages,** #520's clock, medians of 11 (`runs/s-b2`):

| | main | head |
| --- | ---: | ---: |
| `check-input` | 80.342 ms (79.735 to 80.830) | 64.795 ms (64.273 to 65.328) |
| span | 189.800 ms | 175.070 ms |
| default compile, wall | 190.170 ms | 175.514 ms |
| peak RSS | 673,272 KB | 677,560 KB |

The other stages moved by at most 0.4 ms each, in both directions. The
per-stage system times come from `getrusage`, and they vary between the two
processes by more than the stages differ.

**The reader alone,** `check_input` on warm, reused pages:

| | main | round 1 | head |
| --- | ---: | ---: | ---: |
| median | 67.258 ms | 55.104 ms | 54.410 ms |
| range | 66.899 to 67.915 ms | 54.925 to 55.254 ms | 54.215 to 54.614 ms |
| scratch written | 251,731,032 B | 254,555,992 B | 255,262,232 B |

Main's and the head's medians are `runs/m-b2`'s. Round 1's is `runs/m-r1`'s;
main's there was 67.312 ms.

## Limitations

- **One executable per tree.** These aren't #509's placements and copies,
  whose floor for a whole `-c` is about ±1%. The differences here are about
  ten times larger, and every round's sample is apart.
- **The reader's benchmark wasn't interleaved.** It ran A's process, then B's,
  in one hold.
- **The stage clock's trees are merges.** `b2-520` was never committed. It is
  the head with #520 merged in, which made no conflict.
