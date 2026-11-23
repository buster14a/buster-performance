# inflate's and the DWARF writer's exact twins (#2924, linker group, piece 1)

The first piece of the linker and executable group
([claim](https://github.com/buster14a/buster/issues/2924#issuecomment-7113415815)): `inflate_adler32`, the byte-at-a-time
twin of `inflate_adler32_vector`, and `debug.c`'s `exact` flag, which wrote every line row alone instead of four at a
time. The owner's rule 2 applied: the vector writer lost to its twin at 1 to 3 rows a function, so it was made faster
first. Base is main `68cc356a4`; head is base and the branch's three commits (tests, deletion, the writers in locals),
applied as `head1.patch` and `head2.patch` in `~/buster-fast-bench/2924-linker/head` on the 9700X. Release, every run
under `exclusive.sh` ([`scripts/run.sh`](scripts/run.sh)), timings on CPU 2.

## Classification

- `inflate_adler32`: only `inflate_test.c` called it (and `main.c`'s unused-function reference). A twin, no gate
  needed: production already ran the vector form alone.
- `debug.c`'s `exact` (`debug_line`, `debug_sections`, `debug_prepare`, `debug_write`, `DebugPlan.exact`): a twin.
  `c_check_debug.c` passed the checker's `--scalar` through to it (`debug_prepare(..., exact)`); the tests and
  `benchmark-debug` chose it. `c_check_debug.c`'s own exact rows path is another twin (C12c-4's) and stays.

## The gate: `benchmark-debug` at main

Both paths in one process, cycles per row, median of 21 passes ([`logs/gate-debug-main.log`](logs/gate-debug-main.log),
[`scripts/gate-debug.sh`](scripts/gate-debug.sh)):

| Functions × rows | Exact | Vector | Exact / vector |
| --- | ---: | ---: | ---: |
| 16 × 1 | 103.0 | 104.3 | 0.988 |
| 16 × 2 | 58.4 | 59.0 | 0.989 |
| 16 × 3 | 44.0 | 44.7 | 0.986 |
| 16 × 4 | 37.3 | 32.1 | 1.160 |
| 16 × 5 | 32.9 | 28.8 | 1.143 |
| 16 × 7 | 27.7 | 24.7 | 1.124 |
| 16 × 8 | 26.0 | 18.4 | 1.410 |
| 16 × 16 | 20.7 | 11.7 | 1.767 |
| 16 × 64 | 17.9 | 6.9 | 2.602 |
| 4,096 × 1 | 105.7 | 106.1 | 0.996 |
| 4,096 × 2 | 58.6 | 58.8 | 0.998 |
| 4,096 × 3 | 43.3 | 44.2 | 0.978 |
| 4,096 × 4 | 36.9 | 34.5 | 1.070 |
| 4,096 × 5 | 31.8 | 30.4 | 1.045 |
| 4,096 × 7 | 27.3 | 25.5 | 1.068 |
| 4,096 × 8 | 25.9 | 19.3 | 1.339 |
| 4,096 × 16 | 20.7 | 12.4 | 1.666 |
| 4,096 × 64 | 17.4 | 7.3 | 2.391 |

Below 4 rows the groups never run, so the two paths do the same work; the vector path still read 1 to 2% slower.

## The fix: the writers in locals

The first A/B, head with the deletion alone against main's two paths in alternating processes, five rounds
([`logs/ab-debug.log`](logs/ab-debug.log)), confirmed the loss at 1 row: head read 1.5 to 2.5% above main's exact path
in every round. The line program's and the sections' writers were written through the caller's `DebugWriter`. A store
through `writer->bytes` could alias the writer itself, so every byte written reloaded `bytes` and `size`: with one row
a function that chain was most of the cost. `debug_line` and `debug_sections` now write through local copies and store
them back at the end.

## Head against main

Cycles per row, median of five rounds; each round runs main's `--only scalar`, main's `--only vector` and head in
separate processes ([`logs/ab-debug2.log`](logs/ab-debug2.log), [`scripts/ab-debug2.sh`](scripts/ab-debug2.sh)):

| Functions × rows | Main's exact | Main's vector | Head | Head / main's exact | Rounds head below |
| --- | ---: | ---: | ---: | ---: | ---: |
| 16 × 1 | 100.5 | 102.5 | 80.9 | 0.806 | 5/5 |
| 4,096 × 1 | 105.8 | 105.4 | 91.9 | 0.869 | 5/5 |
| 16 × 2 | 59.4 | 59.1 | 48.9 | 0.825 | 5/5 |
| 4,096 × 2 | 58.2 | 58.9 | 50.4 | 0.865 | 5/5 |
| 16 × 3 | 44.2 | 44.7 | 37.4 | 0.846 | 5/5 |
| 4,096 × 3 | 43.5 | 44.1 | 37.9 | 0.871 | 5/5 |
| 16 × 4 | 37.4 | 31.5 | 26.7 | 0.714 | 5/5 |
| 4,096 × 4 | 36.8 | 34.6 | 29.4 | 0.799 | 5/5 |
| 16 × 8 | 26.0 | 18.4 | 15.3 | 0.588 | 5/5 |
| 4,096 × 8 | 25.8 | 19.3 | 16.6 | 0.643 | 5/5 |
| 16 × 64 | 17.9 | 6.8 | 6.5 | 0.364 | 5/5 |
| 4,096 × 64 | 17.4 | 7.3 | 7.1 | 0.408 | 5/5 |

Head is below main's exact path at every size, in every round.

## Tests

- **inflate:** `inflate_adler32_vector` against RFC 1950's definition (`inflate_test_adler32`, both sums taken modulo
  65,521 at every byte), on the known values, random inputs and every length to 300 and around the 64-byte chunks and
  4,096-chunk blocks, of random bytes and of 0xff, ending at a `PROT_NONE` page. The streams' checksums come from the
  definition too.
- **debug:** the units test freezes an FNV-1a digest of the vector writer's sections, their sizes, the fields and the
  line addresses over every case (every row count through 129, rows in other files, bodies' rows, a dense sequence),
  generated while the vector writer and its exact twin wrote the same bytes; `debug_test_decode` keeps checking each
  row's meaning independently. The digest held unchanged through the deletion and the fix.

## Mutation

Ten mutants of the vector code on the deletion ([`mutation/`](mutation/)), each built and run through `test-debug` and
`test-inflate` (the container's AVX-512 host; the counts are the failing checks):

| # | Mutant | Result |
| --- | --- | --- |
| 1 | `debug_rows_pack`'s LEB length thresholds stop at 21 | killed |
| 2 | the special-opcode bound `<=` 255 becomes `<` | killed |
| 3 | a group's last offset taken from its third row | killed |
| 4 | the groups run only while more than 4 rows remain | equivalent: the 4 rows go one at a time, in the same bytes |
| 5 | `DW_LNS_advance_line` written as `DW_LNS_advance_pc` in the packed rows | killed |
| 6 | the special rows' kept-byte mask loses bit 15 | equivalent: no row's bit 15 is ever set in `leb` |
| 7 | a body's row at the next group's first row no longer stops the groups | killed |
| 8 | the Adler-32 blocks of 8,192 chunks | killed (6 checks) |
| 9 | the weighted prefix sums times 63 | killed (513 checks) |
| 10 | the weighted sums truncated to 16 bits | killed (635 checks) |

## Correctness on the 9700X

The blocks of `tools/ci/correctness.tests` that name `test-debug`, `test-inflate`, `test-object-writer`, `test-unwind`,
`test-streaming`, `test-check-debug` and `test-executable` ([`scripts/p1.tests`](scripts/p1.tests)), through
`parallel` on head: 7 of 7 passed, with the deletion alone and with the fix
([`logs/p1-tests-head1.log`](logs/p1-tests-head1.log), [`logs/p1-tests.log`](logs/p1-tests.log)).

## The objects: byte-identical

`-c -g` of sqlite3.c, Lua 5.4.8's 34 units and musl's 1,336 units by base and head, each compiled in one directory so
that `DW_AT_comp_dir` is the same, compared byte by byte ([`scripts/objects-g2.sh`](scripts/objects-g2.sh),
[`scripts/queue11.sh`](scripts/queue11.sh), [`logs/objects2-compare.txt`](logs/objects2-compare.txt)):

| Mode | Objects | Differ |
| --- | ---: | ---: |
| default | 1,371 | 0 |
| `--scalar` | 1,371 | 0 |

Base's `--scalar` took the exact rows through `c_check_debug.c`; head writes the same bytes. A first run compiled base
and head in directories of their own and differed in every object by the directory alone
([`logs/objects-compare.txt`](logs/objects-compare.txt)).

## Sanitizers

`test-debug` and `test-inflate` pass under `BUSTER_SANITIZER=undefined`, `address` and `memory` builds of the deletion
(the container's AVX-512 host; [`scripts/sanitizers.sh`](scripts/sanitizers.sh), `logs/sanitizer-*.log`).
