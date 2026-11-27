# A conditional on a spliced line in a skipped group, at no cost (buster14a/buster#3577's follow-up)

buster's direct path (the default `-c`) skips an inactive group 64 bytes at a time
(`fast_pp_skip_inactive_in`, `src/buster/compiler/c_direct_lex.c`). Its masks took a `#` after any newline as a line's
first character, a line splice's newline too, so `int x \` then `#else` ended the group where the full pipeline
(`--no-direct`) reads no directive. The pull request reads the splices as the full pipeline does and costs nothing:
CI's instruction check on the 9700X goes from 211,930,102 to 211,238,120 (−0.33%).

Base: main `6ac6c1d5` (buster14a/buster#3597's merge). Branch: `claude/eloquent-bell-w29cra`, commit `4940eb08`, [buster14a/buster#3668](https://github.com/buster14a/buster/pull/3668). Host: benchpress (Ryzen 7 9700X), every
build and run under `~/buster-fast-bench/exclusive.sh`, the build as the 9700X job's (`BUSTER_HOST_ARCH=znver5
BUSTER_DEBUG_INFO=0 ./build.sh --config Release`, the staged Clang 23.1.4), the runs pinned to CPU 2.

## CI's check

`scripts/bp-measure.sh` runs the step "Hold sqlite3.c's compile to its instructions' baseline" (`measure-compile --runs
3 --instructions-baseline tools/ci/compile-instructions.txt` on the frozen corpus's `sqlite3.c`). The default compile's
median, user instructions:

| build | median | against main |
| --- | ---: | ---: |
| main `6ac6c1d5` (four holds: 211,930,142, 211,930,117, 211,930,105, 211,930,102) | 211,930,102 | |
| the pull request | 211,238,120 | −691,982 (−0.33%) |

`results/measure-final.log` and `results/measure-base.log` are the last two holds' logs. The pull request writes
211238120 into `tools/ci/compile-instructions.txt`, a cut's gain.

## Why earlier fixes cost 0.4 to 1.3 M, and what costs nothing

The splices' work is rare: on `sqlite3.c` the skips pass 47,333 blocks, of which 1,147 hold a backslash and 502 a
splice's newline; 20,601 blocks end in an event (9,164 directives, 5,138 of them conditionals, 11,350 comments), and no
splice there misreads a line's first character. Yet every change measured hundreds of thousands of instructions: the
skip's single loop spills its carried state, and a change to any decision's code moves the registers of every block.

To see where, `scripts/count.py` makes a build that counts the user instructions of the skip alone (a perf counter
enabled around each call of `fast_pp_skip_inactive`, which stays out of line; its code is unchanged, checked against
the base's assembly). One compile of `sqlite3.c` (`scripts/bp-count.sh`), 2,692 skips:

| variant (`variants/*.patch` against main) | the skips' instructions | against main |
| --- | ---: | ---: |
| main | 8,157,711 | |
| A: the splice masks in the backslash branch alone | 8,079,464 | −78,247 |
| E: A, the literal's scan, the splice event decided as a comment | 8,389,321 | +231,610 |
| H: E and the check of a name after `#\` | 8,359,109 | +201,398 |
| Rhead: main with two loops (blocks with no event in an inner one) | 7,435,990 | −721,721 |
| RE: E with two loops | 7,417,197 | −740,514 |
| RF: RE and an inline check after each directive's name | 7,894,414 | −263,297 |
| RG: RE and the check in a name scan of the skip's own | 7,951,572 | −206,139 |
| RH: RE and the check after `#\` | 7,511,953 | −645,758 |
| RK: RE, a splice at a block's first byte an event, its walk back to a directive's name | 7,443,637 | −714,074 |
| RKP: RK and a check after the loop for the directive that ends the group | 7,528,004 | −629,707 |
| RKC (the pull request): RK and that check in `fast_pp_drain`'s `#elif` | 7,443,638 | −714,073 |
| the pull request, `-std=c17` (no raw string literals): main 7,272,883 | 6,707,022 | −565,861 |

CI's medians of the one-loop variants (`results/measure-*.log`): v4 212,464,362, v5 212,358,118, v6 212,456,985 (the
directive's read moved into a function of its own), A 211,851,325, B 212,025,950 (the UCN branch reading the splice), C
212,022,402, D 212,543,588, E 212,161,770, F 212,555,826, G 212,276,396, H 212,131,554.

What the pull request does:

- **Two loops.** The inner loop passes the blocks with no event and leaves with the masks the event's decision reads;
  the outer one decides it. The decisions' calls no longer take the blocks' registers (a block with no event and no
  backslash: 106 instructions in main's loop, 101 in the inner one, by `hot.py` on the assembly), and clang now inlines
  the decisions' helpers (`fast_skip_hspace`, `fast_scan_ident_len`, the comment skips) instead of calling them and
  loading the loop's 14 vector constants again after each. With two loops the splices' own reads cost 7,647 (RK against
  Rhead), but a check inline at each directive still cost 0.4 to 0.5 M though it never ran (RF, RG).
- **The splice masks** in the branch that a block with a backslash already takes (for UCNs): the newlines after a
  backslash and its blanks, and the first character after each. Only where that is a `#`, a `/` or a backslash, or
  the splice or its blanks reach the block's end, or the splice is at the block's first byte, is each backslash's
  next byte an event. The masks a decision computes anyway are computed there again from an opaque copy of the block
  (`__asm__("" : "+v"(opaque))`), so that the compiler keeps none of them across the branch.
- **A splice's event is decided as a comment's**, a blank (`fast_skip_line_splices`): the dispatch sends a newline or
  a blank after the backslash there rather than to the UCN's decision. A splice at a block's first byte follows a
  decision that stopped at it; a walk back to a `#` and a name (`fast_check_spliced_directive`) reads the name past the
  splice and leaves where it is another conditional. The directive that ends the group is checked in `fast_pp_drain`
  for `#elif`'s family (`#endif`'s and `#else`'s rest already leaves at a letter).
- **The literal's scan** in the skip passes a splice with blanks or `\r\n` before its newline.

## Probes

`probes/` holds this record's probes beside round24's 18 (`direct-diagnostics-3577-2026-11-25/round24/probes/splices/`):
`e*.c`, a splice after or inside a skipped directive's name; `crlf*.c` and `loose*.c`, `\r\n` and blanks before a
splice's newline; `hc*.c`, a comment between a skipped directive's `#` and its name (a gap left: such a `#/**/else`
is still no directive to the direct path). `scripts/run.sh COMPILER FILE...` compares `-c` with `--no-direct -c`
(standard error and exit status) and prints the direct path's bail reason. With the pull request every probe matches,
round24's 18 among them; on main c01, c03, n02, s01 and s02 differ.

## Sanitizers

`scripts/bp-san.sh SANITIZER` built the branch with `BUSTER_SANITIZER=address` (ASan with UBSan and bounds) and
`memory` (MSan) on benchpress, then ran `test-direct` (247 passed, 0 failed), the differential over `tests/` (4,789
files alike, 322 direct, as main's Release build) and the 32 probes (alike): `results/san-*.log`.

## Scripts

- `bp-build.sh TREE TAG`, `bp-measure.sh TAG...`, `run-variants.sh V...`: the builds and CI's check on benchpress.
- `bp-count.sh V...` with `count.py IN OUT`: the counting builds and one compile each.
- `gen.py`, `gen2.py`, `twolevel.py`: the variants from main's `c_direct_lex.c`.
- `bp-san.sh SANITIZER`: the sanitizer builds and their tests.
- `skipasm.sh`, `strip.sh`, `hot.py`: the skip's assembly for `-march=znver5` and the instructions on a block's path.
