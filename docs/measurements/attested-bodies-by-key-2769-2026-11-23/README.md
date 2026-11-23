# #2769: the attested passes on a large unit (2026-11-23)

[buster14a/buster#2769](https://github.com/buster14a/buster/issues/2769): the attested passes' share of `-c sqlite3.c`'s
user cycles with a warm memo (`--attested-memo`), on the 9700X, halved if possible, with every object and diagnostic
`--attested=off`'s. Main is `968a085f`; the change is the PR's `c_check_attested.c`.

## How it was measured

- **Builds.** Every binary timed here was built in a cloud container with CI's staged toolchain (LLVM 23.1.4) by
  `BUSTER_HOST_ARCH=znver5 ./build.sh --config Release`, main (`basez5`) the same way, and copied to the 9700X
  (`results/compilers-local.sha256`, `patches/` for each head's source against main). The lock's queue had 20 to 40
  waiters all evening, so no build held it. `record-base.txt`, `stat-base-*`, `record-head1.txt` and `stat-head1-*`
  are the first round's, built on the 9700X; head1's page faults varied ±42% between runs (huge pages there are
  `madvise`, with 4 GB free), so every later round interleaves its builds.
- **The A/B** (`scripts/ab.sh`, one hold of the lock a round, CPU 2, `setarch -R`): each tree's warm memo of
  `sqlite3.c` made by its own compiler once; then 11 rounds (15 for `final`), each running every tree's `-c sqlite3.c`
  with the memo and with `--attested=off`, one `perf stat` each, in the round's order; medians of cycles:u,
  instructions:u and page faults (`results/ab-LABEL-medians.txt`, the runs in `ab-LABEL.csv`). Then `perf record` of
  five warm compiles a tree at 50 kHz, the attested symbols' shares (`ab-LABEL-record-TREE.txt`, about 28,000 samples).
- **Annotations** (`scripts/annotate.sh` on the 9700X, `scripts/addr.sh` here: each sampled address's line by
  `llvm-addr2line` on the same binary, since the 9700X has no copy of the sources).
- **musl's command** (`scripts/abmusl.sh`): the 1,336 units as one `-c` command, one lane, `--attested=on` and
  `off`, 7 interleaved rounds.
- **Equivalence** (`scripts/equiv.sh`, in the container, Develop builds): a temporary patch (`scripts/dump.py`,
  never committed) adds a per-unit hash of every declaration's hit, reach (with and without the runtime names) and of
  the file-scope declarations' lists (bounds, flags, entries, declared keys, strings) to both main's build and the
  head's; then `measure-attested --twins` of musl's 1,336 units and of `sqlite3.c` with `shell.c` (report and every
  unit's hashes compared), musl's command with `--lanes 1` (each unit's hits, reach and skips, objects and
  diagnostics), and `-c sqlite3.c` cold and warm with the memo and musl's command on four lanes (objects and
  diagnostics against main's and `--attested=off`'s).

## Where main's cycles went

`record-base.txt` and `annotate-base-*` (main, built on the 9700X): the passes 2.32% of the user cycles.

| pass | share | where |
| --- | ---: | --- |
| `check_attested_lists` | 0.90% | the file-scope stack walk; a function body's dedup by key (`body_marks`, 147,602 identifiers) |
| `check_attested_reach` | 0.39% | each body entry's rise: the name's state by key, its list |
| `check_attested_chain` | 0.24% | each callee of each body declared (a list entry and a hash step), the memo's probe |
| `check_attested_ids` | 0.19% | a `memcpy` call a name, for its last bytes |
| `check_attested_levels` | 0.18% | a 16-lane gather a 16 tokens |
| `check_attested_hashes` | 0.17% | the vector own hashes |
| `check_attested_literals` | 0.14% | half on the same `memcpy`, a literal's spelling |
| `check_attested_after` | 0.08% | a token at a time for the impure bits |

## The heads

| head | what it adds |
| --- | --- |
| head1 | bodies by key (`namings`, `declarings`, `builtin_ids`); events at their own tokens; `intern_hash_bytes`; levels aliased where `identity_sources` |
| head2/head3 | the walk steps only tokens with a part (64 at a time, `vpermi2b` tables); the memo's probes after the chain; `check_attested_impure` |
| head4 | a body's stores only for keys declared before it (bitmap) |
| head5 | the literals listed, then hashed with their spellings fetched ahead |
| head6 | a body in one pass, its names stored by key in one loop; the hashes' columns fetched ahead; the bounds jump over bodies |
| head7 | a branch-free walk step; ids four at a time (`intern_hash_vectors4_short`) |
| head7b | head7 with head6's walk step |
| head8/head9 | the memo's probes and the key words fetched ahead; a command of one source file walks the unit (no bounds pass) |
| head10 | each entry's list kept by the chain for the reach |
| head11 | the walk's state in a local copy |
| head12 | the current level in the walk's fields, the stack only at openers and closers |
| final | head9 without what measured nothing (head4, head5, head6's prefetch and bounds jump, head7, head8's prefetches, head10 to head12) |

## The rounds

Attested symbols' share of the user cycles, and the medians' M cycles of `-c sqlite3.c` with the memo and with
`--attested=off` (each round's own `basez5`):

| round | basez5 | heads |
| --- | --- | --- |
| z5 | 2.37%; 567.4, 557.4 | head3 1.60%; 565.6, 558.3 · head4 1.67%; 565.3, 557.1 |
| z5b | 2.35%; 567.2, 556.7 | head3 1.63%; 564.8, 557.4 · head6 1.50%; 563.6, 556.9 |
| z5c | 2.39%; 567.7, 555.8 | head6 1.52% · head7 1.83% (+12.5 M instructions) · head7b 1.49%; 562.0, 556.2 |
| z5e | 2.41%; 565.9, 554.3 | head7b 1.46%; 563.7, 555.1 · head9 1.39%; 561.4, 554.6 |
| z5f | 2.39%; 564.8, 553.1 | head9 1.44% · head10 1.45% · head11 1.44%; 562.3, 554.2 |
| z5g | 2.38%; 564.6, 553.2 | head11 1.41%; 561.6, 554.9 · head12 1.46%; 561.8, 554.9 |
| final (15 rounds) | 2.38%; 564.8, 554.6 | **final 1.39%; 561.1, 554.1** |

musl's command, one lane (`abmusl-m1`, 7 rounds, M cycles): main 2,801.4 with `--attested=on`, 3,845.3 off; head9
2,780.1 on, 3,821.8 off. Off runs the same 9,831.1 M instructions on both and differs by 0.6%: the measure's own
noise; on, head9 runs 0.24% more instructions.

musl's command for the final (`abmusl-m2`): main 2,805.4 on, 3,847.9 off; final 2,779.5 on (6,764.8 M instructions
against main's 6,768.8 M), 3,827.1 off.

## The result

The final against main, 15 interleaved rounds (`ab-final-*`):

| | main | final |
| --- | ---: | ---: |
| the attested symbols' share of `-c sqlite3.c`'s user cycles | 2.38% | **1.39%** |
| the issue's table's passes alone (lists, reach, chain, ids, levels, own hashes, literals) | 2.27% | **1.30%** |
| `-c sqlite3.c` with the warm memo, M cycles (instructions) | 564.8 (1,326.9) | 561.1 (1,324.3) |
| … with `--attested=off` | 554.6 | 554.1 |
| what the memo costs over `off` | 10.2 M | 7.1 M |

By pass, final: `check_attested_list_tokens` 0.56% (the lists, with the bounds and the bodies; main's
`check_attested_lists` 0.87% and the levels' 0.17% are gone into it or away), chain 0.25%, own hashes 0.15%, reach
0.14% (0.40%), literals 0.12%, ids 0.08% (0.19%), after 0.06%.

The issue's gate is half (1.14%): this is 43% off, not half. What is left is the walk's scalar step a file-scope token
with a part (about 95,000 on `sqlite3.c`, some 26 cycles each; neither a branch-free step, head7, nor the walk's
state in registers, head11 and head12, made it cheaper), the chain's per-name work, and the own hashes and literals.

## Equivalence

Every head's `scripts/equiv.sh` (the final source's last): the census reports of musl's units and of `sqlite3.c` with
`shell.c` are main's line for line; every unit's hits, reach and file-scope lists hash as main's; `--twins` finds no
difference (the new check of every event in a function body by the body's names marked and by a search included);
musl's command on one lane skips the same 259,860 declarations as main, unit by unit, with 0 units read again and 0
unlisted events; and every object and diagnostic is main's and `--attested=off`'s (musl on one and four lanes,
`sqlite3.c` alone with a cold and a warm memo).

## The census (`measure-attested --passes 5`, lane mode, least of 5 runs)

`results/census-{sqlite,musl}-{basez5,final}.txt`, cycles a token (first run's after the slash):

| pass | sqlite3.c with shell.c, main → final | musl's 1,336 units, main → final |
| --- | --- | --- |
| lists (with the own hashes) | 4.80/9.75 → 3.52/8.36 | 7.62/11.72 → 7.21/11.05 |
| literals | 1.13/1.69 → 0.90/1.53 | 2.06/3.48 → 1.70/3.00 |
| chain | 1.34/1.62 → 1.34/1.70 | 3.04/6.83 → 3.00/6.24 |
| reach | 3.05/3.53 → 1.22/1.67 | 1.88/5.05 → 2.10/5.51 |
| all | 10.34/16.63 → 7.00/13.30 | 14.78/27.84 → 14.20/26.55 |

musl's reach rises a little: a unit's rise over every declared key's list and its builtins' loop are fixed costs, and
musl's units have few bodies (musl's command itself is no slower, above).

