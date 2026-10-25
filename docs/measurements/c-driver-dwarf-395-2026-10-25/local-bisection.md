# Where f0ef458's extra instructions came from (laptop bisection)

Exact user-instruction counts (`perf stat -e instructions:u -r 5`, two rounds each; the counts repeat within a few
hundred instructions) of a whole compile of `rows3-f0ef458/`'s generated program (`benchmark-check-debug --print`,
2,000 functions, the file whose SHA-256 is in `binaries-rows3-rows4.sha256`) to an executable, without `-g`, by
variant builds of the trees. Every build is `BUSTER_DEBUG_INFO=0 ./build.sh` on the author's laptop (AMD Zen 4,
clang 23.1.3, Linux): the counts are this machine's code, not the 9700X's, and serve only to attribute the 9700X's
difference (`rows3-f0ef458/perfstat.log`: +3,145,000 user instructions) to its causes. The variants were made by
editing copies of the trees; each row says what changed.

| Build | What it is | User instructions | Against main |
| --- | --- | ---: | ---: |
| main | `5863eed` | 629,889,380 | |
| part1 | `f0ef458` | 633,041,390 | +3,152,010 |
| v1 | part1 without the lowering's per-task save and restore of the source token | 631,405,290 | +1,515,910 |
| v2 | part1 with that save and restore under `if (writer->sources)` | 633,071,531 | +3,182,151 |
| v3 | part1 without any source tracking in the lowering (no save, restore, stores or token column stores) | 631,072,910 | +1,183,530 |
| v8 | v3 without the driver's `-g` branch | 631,073,040 | +1,183,660 |
| vb | part1 with expression tasks saving and restoring no token (their node gives it) | 631,570,430 | +1,681,050 |
| m1 | main with part1's `tier0.c` alone | 629,935,560 | +46,180 |
| m2 | main with part1's lowering alone (its emission asks for no sources) | 631,702,770 | +1,813,390 |
| m8 | main with vb's lowering alone | 630,231,350 | +341,970 |
| m9 | m8 with part1's emission, debug module, `tier0.c`, `debug.c` and tests, the driver asking for no rows | 631,444,090 | +1,554,710 |
| m10 | m9 with the raw rows' code out of the emission's loop | 631,444,110 | +1,554,730 |
| m11 | m9 with main's `debug.c` | 631,443,080 | +1,553,700 |
| m12 | m10 with main's `tier0.c` | 631,394,070 | +1,504,690 |
| m13 | vb with `test-check-debug` and `benchmark-check-debug` in another unit and `test-checker`'s sources check removed | 631,421,880 | +1,532,500 |
| m14 | m13 without the driver's `-g` branch: nothing in the checker's unit asks for sources or rows | 630,275,680 | +386,300 |
| c1 | main with an unused function inserted before the lowering (a layout control) | 629,889,450 | +70 |
| final | `a0c5b8c` (the `-g` unit, `BUSTER_CHECK_SOURCE_ROWS`) | 629,935,020 | +45,640 |

- About 2 million were the lowering's own tracking (part1 against v3). A branch on `writer->sources` costs as much
  as the store it guards (v2).
- About 1.2 million came from the checker's unit, which compiles the default C command, holding callers that lower
  with sources or emit rows: with any such caller (v3, v8, m9-m13), clang compiles `check_program_lower` and
  `check_program_emit` differently for every caller; with none (m8, m14), the cost is gone. Moving the rows' code out
  of line (m10), `debug.c` (m11) and `tier0.c` (m12) change nothing.
- Moving code alone (c1) changes no count.
- The fix puts the `-g` link in a unit of its own, where alone the tracking compiles (`BUSTER_CHECK_SOURCE_ROWS`):
  46,000 instructions remain, Tier 0's per-function check of `entry_records` (m1's), and the compile writes
  main's executable byte for byte.
