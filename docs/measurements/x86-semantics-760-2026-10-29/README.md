# x86 semantics of the X86 rows' VEX and EVEX forms, Buster #760

Compiler branch: `claude/solve-760` of buster14a/buster (buster#838), for
[this claim on #760](https://github.com/buster14a/buster/issues/760#issuecomment-6489450831), a piece of #221.

The branch gives `x86_semantics.c` effects rows for every VEX and EVEX form the front end's X86 rows may have (3,148
covered forms, from 712), an opmask column in the resolved effects (`x86_instructions_effects_opmasks`, on both
paths), the vector resolver's lanes for `vvvv` operands, which those forms make common, Tier 0's form check on the
tables (`tier0_operation_form_valid`), and #180's target rows for the forms. This record measures what that costs on
the 9700X: the tables' initialization, the effects and choice loops, the target table's construction, and `-c` of
`sqlite3.c` and of a unit of two functions, with the head's suites.

## Sources and host

Each tree is a `git archive` of its commit (`trees.txt`), extracted into a fresh directory on the 9700X and built there
by `BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job builds (`logs/build-*.log`, each executable's SHA-256 in
`logs/all.out`):

- **main:** `5c7a0bd72bb51c7d4f4249cd04f9f59e5ad4217f`, the branch's base;
- **head:** `62c638ac4f739c366ed51af3da2968e98f48f028`, the branch's one commit then. The commit after it (`ff972baa`,
  the wide harness's AVX512BW condition) changes only `test-x86-semantics`' host check and AGENTS.md.

The receipt (`logs/receipt.txt`): the AMD Ryzen 7 9700X, its kernel, clang 23.1.1, perf, GNU as 2.47, CPU 2's governor
and energy preference (performance), each tree's manifest (the SHA-256 of its files' hashes) and executable's
SHA-256. `-c`'s input is the 9700X job's frozen `sqlite3.c`
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`) with the job's compile-time options (`-c
-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite`), and
`scripts/tiny.c`, two functions.

## Method

`scripts/all.sh` runs `receipt.sh`, `build.sh`, `receipt.sh`, `tests.sh`, `sem.sh`, `target.sh` and `compile.sh`, each
build, suite and round in a hold of the host's lock (`~/buster-fast-bench/exclusive.sh`) of its own, every measurement
pinned to CPU 2, the rounds running the trees in an order alternating by round:

- **Suites** (`tests.sh`): the head's `test-x86-semantics` with and without `--cross-check`, `test-x86-target`,
  `test-checker --program-vectors`, `test-tier0` and `test-assembler --cross-check`, each timed by bash's `time`
  (`logs/tests/`).
- **`benchmark-x86-semantics`** (`sem.sh`): five rounds, each one hold running both trees: the full run, then the
  effects and choice loops alone (`--only effects-avx512`, `--only choose-avx512`), back to back and after 200 ms of
  their scalar twins, and the head's opmask column alone (`--only effects-opmasks`) both ways (`logs/sem/`).
- **`benchmark-x86-target`** (`target.sh`): five rounds of the AVX-512 builder alone (`--only avx512`) and of one
  table after 100 ms of predefines (`--after-predefines 100`) (`logs/target/`).
- **`-c`** (`compile.sh`): five rounds, each one hold of `perf stat -r 11 -e task-clock,cycles:u,instructions:u` of
  `sqlite3.c` and `perf stat -r 51` of `tiny.c` per tree (`logs/compile/`), then the objects' SHA-256 (`logs/all.out`).

`scripts/summarize.py` takes each figure's median over the rounds (`logs/summary.txt`). The lock's waiting messages,
which name other sessions' and CI jobs' commands and links, are left out of the logs: each locked log starts at its
command's first line, the rounds' logs were written inside their holds, and `logs/all.out` keeps only the lines the
scripts print (`scripts/clean_logs.py`).

## Results

Medians of the five rounds.

| Measurement | main | head | Change |
| --- | ---: | ---: | ---: |
| Covered forms | 712 | 3,148 | |
| `x86_semantics_initialize` (cycles, µs) | 45,750 (8.3) | 97,285 (17.5) | +51,535 cycles |
| Choice, AVX-512 (cycles per request) | 3.33 | 3.33 | 0 |
| Effects, AVX-512, -O0's shape (cycles, instructions per record) | 5.45, 23.63 | 6.19, 25.50 | +13.6% cycles |
| Effects, AVX-512, -O2's shape | 5.50, 23.63 | 6.23, 25.50 | +13.3% cycles |
| Effects, AVX-512, after 200 ms of the twin, -O0 / -O2 | 5.45 / 5.49 | 6.19 / 6.23 | +13.6% / +13.5% |
| Effects' scalar twin, -O0 / -O2 (full run) | 46.86 / 46.34 | 72.43 / 71.59 | +54.6% / +54.5% |
| Opmask column, AVX-512, -O0 / -O2 (new) | | 8.89 / 8.93 | |
| `x86_encode` of the same records, -O0 (the reference) | 3.28 | 3.27 | 0 |
| #180's table, AVX-512 (cycles per table, ns) | 707 (128.7) | 795 (143.5) | +12.4% |
| #180's table after 100 ms of predefines | 706 (129.2) | 794 (145.1) | +12.5% |

The effects loop takes `vvvv` operands as a lane's third role, which used to send a record to the scalar twin, and
every record pays for the role; the twin walks three roles and checks the opmask roles, `/is4` operands, VEX gathers
and the merges for every record. Neither runs on `-c`'s default path: the loop's consumers are the Tier 1 scheduler
and the unwind analyzer, both opt-in (the C driver reads the frame Tier 0 publishes).

`-c`: each tree's median of the five rounds' `perf stat` means, the change the head's median against main's, and in
parentheses the range of the five rounds' paired differences (each round's head against the same round's main):

| Unit | Measurement | main | head | Change |
| --- | --- | ---: | ---: | ---: |
| `sqlite3.c` | instructions:u | 1,314,232,138 | 1,314,514,107 | +281,969, +0.021% (rounds +281,968 to +281,975) |
| | cycles:u | 599.84 M | 603.30 M | +0.58% (rounds +0.23% to +0.70%) |
| | task-clock | 126.76 ms | 127.19 ms | +0.34% (rounds +0.13% to +0.59%) |
| `tiny.c` | instructions:u | 12,145,078 | 12,460,007 | +314,929, +2.59% (rounds +314,927 to +314,929) |
| | cycles:u | 3.539 M | 3.652 M | +3.2% (rounds +2.8% to +3.8%) |
| | task-clock | 1.06 ms | 1.07 ms | +0.01 ms |

buster#838's docs give `tiny.c`'s +314,928 instructions, the median of the rounds' paired differences: the same cost,
by the other statistic.

Both trees write the same objects: `sqlite3.c`'s SHA-256 `9048dda48896c43fd071e610d050c465d05d141a23689669bf272f1b35bbdcd0`
and `tiny.c`'s `d1f4836f77987565a1cb163e002a1f7c63bbaf050b8ebb4fa17d77f4c314f746`. The instructions are a fixed cost per
process, about 0.3 M whatever the unit (the larger tables' initialization; `tiny.c`'s +0.01 ms is the initialization's
+9.3 µs). `sqlite3.c`'s cycles grew more than its instructions: no placement comparison was run, so the rest isn't
attributed.

**Suites** on the 9700X at the head, all passing: `test-x86-semantics` (6,129,490 checks of the executed forms; 2,739
covered forms executed 12 times each and more until every write showed, 41 left to the fixtures, and the 368 not
executed all forms #180's table doesn't classify, so every classified form ran, AVX512-VP2INTERSECT's and AVX-VNNI's
among them; 0.387 s), with `--cross-check` (0.404 s), `test-x86-target` (75,992 GNU as gate comparisons, 194 explicit
gaps; 0.623 s), `test-checker --program-vectors` (4,663 checks; 2.986 s), `test-tier0` (7,196,370 checks; 2.152 s) and
`test-assembler --cross-check` (1,890,898 checks; 2.117 s).

## Limits

`benchmark-x86-semantics`' records are shaped like clang's -O0 and -O2 code (branch sizing's generator): legacy forms
almost all, so the effects loop's cost here is its common records' and says nothing of code that is mostly VEX and
EVEX, which the loop now keeps in its lanes. `-c`'s figures are the default path's; no Tier 1 or unwind analysis ran.
