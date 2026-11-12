# Switches on a _BitInt past 128 bits: the cost to units without them on the 9700X, Buster #2220

Compiler pull request: [#2437](https://github.com/buster14a/buster/pull/2437), for
[#2220](https://github.com/buster14a/buster/issues/2220). It accepts and lowers a `switch` whose controlling
expression is a `_BitInt` wider than 128 bits. The change reaches every unit's case paths, `-fsyntax-only`
included:
- `check_program_case_value` asks one more type question for each case;
- every ordering of two cases (the conflicts' sort and searches, constant-switch selection) goes through
  `check_program_case_compare`, which tests for limbs and then compares the same order keys as before;
- each case record carries two more pointers;
- `check_lower_limb_room` walks the cases, but only in a unit that has a `_BitInt` past 128 bits.

This measures what those cost units without such a switch.

## Sources and host

Each tree is a clone of buster14a/buster at its commit, built on the 9700X by `BUSTER_HOST_ARCH=znver5
./build.sh` under the host lock (`scripts/setup.sh`, `scripts/build.sh`, `scripts/all.sh`):

- **base:** `8c67a8d61825d3c28ab88d046cca0ad2d813abd2` (main, #2437's base);
- **head:** `b03b1d5ff712d1c98cc628955de7336b327aab1e` (#2437's first head).

`logs/receipt.txt` has the host, the toolchain, both executables' SHA-256 and the inputs' SHA-256.

## Method

`scripts/run.sh` makes one `time-runs --runs 21 --warmups 3` comparison of both builds. The runs go in a
Williams design's order, under one hold of the host lock, pinned to CPU 2. The four lists are:
1. `-fsyntax-only` of SQLite's amalgamation;
2. `-c -o /dev/null` of SQLite's amalgamation;
3. `-fsyntax-only` of Buster's own `main.c`, with clang's `-march=native` predefines;
4. `-c -o /dev/null` of the same `main.c`.

`logs/run.log` is the whole output. For every run it has the wall time, rusage, peak RSS, faults, user cycles
and instructions.

## Result

| list | wall (median of 21) | user cycles | instructions |
|---|---|---|---|
| `-fsyntax-only` sqlite3.c | 101.594 → 102.660 ms (+1.05%) | 474.118 → 474.228 M (+0.02%) | 1,034,789,380 → 1,035,334,505 (+0.053%) |
| `-c` sqlite3.c | 123.663 → 122.742 ms (−0.74%) | 590.040 → 589.195 M (−0.14%) | 1,318,956,567 → 1,319,506,521 (+0.042%) |
| `-fsyntax-only` main.c | 603.406 → 604.339 ms (+0.15%) | 3027.351 → 3034.478 M (+0.24%) | 9,090,893,507 → 9,090,445,349 (−0.005%) |
| `-c` main.c | 677.522 → 680.139 ms (+0.39%) | 3426.529 → 3440.767 M (+0.42%) | 10,412,377,507 → 10,411,917,762 (−0.004%) |

The two builds do the same work, within single-build placement noise:
- Instructions differ by at most 0.053%.
- Cycles move both ways, by under half a percent.
- Wall-time medians move both ways too. sqlite3.c's `-fsyntax-only` head runs span 99.7–125.4 ms.

## Limitations

- Each tree was built once, so code placement isn't controlled.
- Neither input has a switch on a wide `_BitInt`, so the new path's own cost isn't measured. That path
  compares a case's limbs one at a time, as clang's code does.
