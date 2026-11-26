# Round 24: main a62529650 merged, and three refusals the merge needs

[buster#3597](https://github.com/buster14a/buster/pull/3597) after main a62529650 (2026-11-26): main's #3655 has the
full pipeline report a basic, control or surrogate character's UCN that starts a token in a skipped group, as clang's raw
lexer does, and #3654's fixtures name a block-scope static's symbol with an asm label (`f.n`), which the full pipeline
refuses. The PR's correctness block (`test-direct --differential`) found the direct path quiet on five of the new files
on the merged copy (`tests/preprocessor/raw-errors/0017.c`, `0019.c`, `tests/driver/programs/static-label/0001.c` to
`0003.c`), and the merge conflicted in the cost tables (#3654's heading beside the branch's), so the queue dropped the
PR.

The merge is 3be61f2a6 (the tables are `costs refresh`'s output again); the fix is f8c4f8e1e:
- the skip of an inactive group (`fast_pp_skip_inactive_in`) also stops at a backslash before a `u`, `U` or `N`, or
  before another backslash (a line splice between a backslash and its letter); past the splices
  (`fast_skip_splices`, c_lexer.c's `escaped_newline_size`), a UCN's start leaves, whatever it names;
- in C23 a quote after a number's character is a digit separator, which opens no literal, so the literal the skip took
  it for hid a UCN or a comment's start (`1'000; \u0041` was quiet, the full pipeline's error): a quote after a name's
  or a number's character leaves there, in C23 alone;
- an asm label with a `.` leaves (the direct path names its statics `n.0`).

## Gate (`scripts/u-checks.sh`, `results/u-checks.log`)

Against r2's binary (472cc48a3's code, before the merge), in this container:

- sqlite3.c's object (the host's headers, and the count's corpus configuration): identical, direct;
- every C file under `tests/` (r2's list of 4,637): alike, 310 direct (r2 310); all 4,789 of today's: alike, 322 direct;
- c-testsuite: 220 alike, 192 direct (r2 192); musl: 1,355 alike, 1,002 direct (r2 1,002);
- one file takes a new reason, `tests/preprocessor/cases/0144.c`, which left at a later escape before;
- the probes (`probes/`, 22, and `probes/c23/` in C23 and in GNU17) alike, and the earlier sets' as before.
- `test-direct` (246) and the differential over `tests/` under ASan with UBSan and under MSan: passed, all alike, 322
  direct; the probes under both: alike; `./build.sh check-call-graph`: no new cycle;
- CI's count against main a62529650 (`results/u-checks.log`): -0.788% (37,297,211 against 37,593,648), stated -0.79%.

## The check's cost (`scripts/bp-ucn.sh`, `bp-ucn-g.sh`, `bp-ucn-h.sh`, `bp-ucn-prof.sh`, `bp-ucn-base.sh`)

The 9700X job's builds (`BUSTER_HOST_ARCH=znver5`, Release), sqlite3.c with the host's headers, `taskset -c 2`, perf
stat 3 rounds of 7 at one placement each:

| build | instructions | cycles (rounds 1-3) | skip loop's cycles |
| --- | ---: | --- | ---: |
| main a62529650 | 195.780 M | 76.65, 76.50, 76.61 M | |
| the merge 3be61f2a6 | 211.836 M | 82.31, 81.59, 81.60 M | 1.99 M |
| f8c4f8e1e: the letters looked for in every block | 212.470 M | 82.59, 81.84, 81.91 M | 2.13 M |
| g (b83a9671b): only in a block with a byte after a backslash | 211.971 M | 83.40, 82.20, 82.33 M | 2.06 M |
| h (498c67a31): the test joined with the block's other events | 212.546 M | 82.77, 81.97, 81.99 M | 2.18 M |

The skip loop's cycles are `fast_pp_skip_inactive`'s share of cycles:u sampled every 100,000 (below the host's
63,300/s limit) over 100 compiles a build (`results/ucn-prof.txt`, `results/prof-u-*.tsv`; h's in a later hold against
the merge's again, 2.59% against 2.42%). Every block of skipped text paid the letters' compares in f8c4f8e1e (about a
dozen instructions and spills more a block); g pays a test of the backslash mask, and the compares only where a block
has a byte after a backslash. h's single test sends each block with any event (a comment, a directive's line) through
the compares too, which costs more than g's second test. g's cycles at this placement are 0.4 to 0.9 M over the merge's
in all three rounds, but its profile puts the difference elsewhere, spread over functions it doesn't change
(`fast_cc_expr` +0.36 M, `fast_pp_drain` +0.27 M, `fval_to_gp_full` -0.22 M): the placement's. The PR takes g
(969573021, the same tree); CI's instruction check reads 211,970,371 on it (`results/ucn-base.txt`), now
`tools/ci/compile-instructions.txt`, and sqlite3.c's object is the merge's (`aef0e35896a7e863`).
