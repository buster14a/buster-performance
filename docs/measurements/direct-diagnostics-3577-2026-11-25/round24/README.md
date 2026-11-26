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

## The lines next to the rule (`probes/lines/`, `probes/c23-numbers/`)

Probes of the directive lines beside the skipped group's rule found more the full pipeline's lexer reads and the direct
path didn't, 9 of 23 differing:
- an `#elif`'s operands after a taken group (#3655's inactive directive operands): `fast_pp_skip_rest_of_line` passed
  them unread;
- main's direct path's own gaps, which the full pipeline reported before #3655: a pragma nothing acts on (passed unread
  the same way), a definition and an argument nothing uses (`fast_lex_one` made the stray backslash an other token);
- in C23, a digit separator after a `.` (`1.'5`) and after an exponent's sign (`1e+'5`, `0x1p-'5`).

The follow-up (b753417b4) leaves at a backslash that starts a UCN past any splices in the line's walk and the lexer's
default case (`fast_pp_stray_backslash`), and takes the two separators (`fast_quote_may_separate`). Written inline
(1ac2a5652), the walk lengthened `fast_lex_one`'s hot paths (647 to 695 instructions, its registers and its branches'
order reshuffled) and the C23 test the skip loop's (1528 to 1577): CI's instruction check read 212,267,040, 0.30 M over
the gated fix. In cold, never-inlined helpers the lexer has 649 instructions, the skip loop 1506 and the line's walk 295
(306 before), and the check reads 211,927,404: 43 K under the gated fix, 0.091 M over the merge (`results/v2.txt`).

## The pushed head's checks (`scripts/v2-checks.sh`, `results/v2-checks.log`)

On the tree pushed as b753417b4 (and 97a900f5d, which writes 211,927,404 into `tools/ci/compile-instructions.txt`),
in this container: sqlite3.c's object identical to f8c4f8e1e's in both configurations; every C file under `tests/`
alike (310 direct of r2's list, 322 of today's 4,789), c-testsuite 192 and musl 1,002 direct and alike; eight `tests/`
files leave at the new rules, none of them direct before; the probe sets alike but for the two known loops' empty bodies;
`./build.sh check-call-graph` without a new cycle; `test-direct` (246), the differential and the newer probe sets under
ASan with UBSan and under MSan; CI's count unchanged at -0.788% (37,297,211 against 37,593,648).

## Eight placements (`scripts/bp-vsweep.sh`, `results/vsweep.txt`)

Main a62529650 and the head b753417b4, each built at the eight `BUSTER_CHECKER_OFFSET`s 0 to 3696 in steps of 528
(they move the code's alignment within 64 bytes too), measured in one hold in rotation, 3 rounds of 5 (rounds 2 and 3):

| arm | cycles | instructions |
| --- | ---: | ---: |
| main a62529650 | 76.00 M | 195.780 M |
| the head b753417b4 | 81.85 M | 211.928 M |

+5.85 M cycles (+7.7%) and +16.15 M instructions (+8.25%). Round 23's sweep (another hold, main 1e1ca2dd6) read +6.30 M
(+8.4%); this round's own changes add 0.09 M instructions, so the difference between the two sweeps is the holds' and
main's, not a gain of this round.
