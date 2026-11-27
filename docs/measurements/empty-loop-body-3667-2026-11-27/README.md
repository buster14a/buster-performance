# The direct path's check of a loop's empty body (`c_direct`, buster#3667)

[buster#3667](https://github.com/buster14a/buster/issues/3667): the default `-c` direct path compiled a `for` or
`while` whose body is a lone `;` quietly where the full pipeline warns `-Wempty-body` (the `;` on the `)`'s line, the
loop a block's own statement, the next statement a block or starting past the keyword's column). The change, on
buster's branch `claude/loving-volta-ycew42` (base main `6ac6c1d5`), marks each loop keyword the preprocessor reads
from a file's text with its place (`BUSTER_FTOK_PLACED`) and, where a loop's `)` a `;` follows, reads the text again
from the keyword (`fast_cc_empty_statement`). This record has each form's 9700X readings, the cold path's single-step
counts, and the probes and corpora the check was held to.

- **Host:** `benchpress` (Ryzen 7 9700X), every run under `~/buster-fast-bench/exclusive.sh`, CPU 2. Directory there:
  `~/buster-fast-bench/3667-claude` (`base` at main, `head` at the branch, `var` at main with `vars/vN`'s
  `c_direct*.c` copied in).
- **Unit:** CI's instruction step's: the corpus's `sqlite3.c` with the host's headers,
  `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`
  (`measure-compile --runs N`, the default runs' median user instructions).
- **Builds:** each tree's `./build.sh --config Release` with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`, as the
  9700X job builds.
- **Scripts:** `measure.sh` (base and the first form, three rounds), `measure2.sh` (the second form, and a throttled
  profile), `measure3.sh` (variants, `VARIANTS="vN ..."`), `profile4.sh` (instruction samples of 400 compiles),
  `measure5.sh` (base and the final form alternating, five rounds of five), `measure6.sh` (base, v10 and the final
  form alternating, four rounds of five); `stepcount.c` with `direct_harness_main.c` (a ptrace counter of the cold
  path's instructions, a call at a time, on the standalone harness in a cloud container); `probe-one.sh` and
  `musl-one.sh` (default `-c` against `--no-direct`); `mutants.py` (the check's mutation round).

## Result

| 9700X, `sqlite3.c`, CPU 2 | instructions | vs main | |
| --- | ---: | ---: | --- |
| main `6ac6c1d5` | 211,929,780 | | |
| first form `d957adfa` | 212,389,950 | +460 K | `measure-*-*.log` |
| second form `8bed534f` | 212,380,730 | +451 K | `measure2-*-*.log` |
| v1: the preprocessor's side alone, the place computed inline | 212,215,216 | +285 K | `measure3-v1.log` |
| v2: v1 and the statement compiler's call at each empty statement, its helper empty | 212,488,101 | +558 K | `measure3-v2.log` |
| v5: the preprocessor's side, the place out of line | 211,924,286 | -5.5 K | `measure3-v5.log` |
| v6: v5, the call at each empty statement, the check | 212,453,494 | +524 K | `measure3-v6.log` |
| v10: v5 and the call at a loop's `)`, its helper empty | 211,929,901 | +121 | `measure3-v10.log` |
| v9: v10 with the check read a token at a time | 212,090,669 | +161 K | `measure3-v9.log` |
| v11: the header read 64 bytes a step | 211,974,905 | +45 K | `measure3-v11.log` |
| **final `41e9fcab`** (v12, and five rounds of five) | **211,972,302** | **+42.5 K (+0.020%)** | `measure3-v12.log`, `measure5-*` |

- **Where the first form's cost was:** the window emitter's new branch used the name's text pointer, which then
  stayed live across the inlined identifier lookup, an instruction for each of the unit's ~265 K names (+285 K);
  out of line and recomputed from the window it is -5.5 K. The check asked at each empty statement ran 7,508 times
  (sqlite3.c's asserts and testcases, reduced to their `;` by the window's emitter) and reshuffled
  `fast_cc_compile_func`'s registers; asked at a loop's `)` it runs 20 times, and with an empty helper reads +121.
- **The cold path:** 20 calls on this unit (19 loops, one of them in an inline body compiled twice). Read a token at
  a time it took 6.5 K instructions a call, 148 a token, mostly the token function's fixed costs (the same counter on
  that form: 128,967 for the 20). Read 64 bytes a step, with the names compared with the stream's before any macro
  table lookup and the next statement's token from one load, it takes 1.8 K a call: 36,111 instructions for the 20
  in the container's harness (`cold-path-steps.txt`), 42.5 K on the 9700X's build.
- **Cycles:** base, v10 and the final form alternating, 20 compiles each (`measure6-*`): user cycles' medians
  81,725,047, 81,738,365 (+0.02%) and 81,935,825 (+0.26%), the quartiles 0.4 M apart in each; `--time-stages`' span
  medians 15.94, 15.89 and 15.94 ms. The hot paths cost nothing; the 20 cold calls, with their code and the text's
  lines out of cache, about 0.2% of cycles by the median, inside the runs' spread. `measure5-*`, 25 compiles a side:
  81,809,173 against 82,076,303 (+0.33%), spans 15.910 against 15.938 ms.
- **CI's count** (`tools/ci/compile-count.sh`, in a cloud container with clang 23.1.6): 37,297,281 against
  37,317,209, +0.053% (`compile-count.txt`).
- **The object:** sqlite3.c's is byte-identical to main's and the direct path's (`readelf -p .comment`: `buster
  direct`) in three configurations: CI's instruction step's, the compile count's (corpus headers and predefines) and
  a plain `-c` with the host's headers.

## Correctness

- **Probes** (`results/probes/`, each ending in a comment of more than 80 bytes so the window lexer runs): 105 forms,
  default `-c -std=gnu17` against `--no-direct`, all alike in stderr and exit status (on main, 19 of the first 40
  differed). `probes2/sys` is a system header's (`-isystem`).
- **tests/:** `test-direct --differential --jobs 4 --direct-floor 260 tests`: 4,789 files alike, 322 direct, as main.
- **c-testsuite** (pinned `5c727565`): 220 files alike, 192 direct, as main.
- **musl** (the corpus's 1,524 `src/**/*.c`, `-std=c99 -ffreestanding` as `tools/microarch/workloads.sh` has them):
  1,048 direct, 431 the full pipeline's, 45 no object (other architectures' files), all alike, the same units direct as
  main (`musl-main.txt`, `musl-head.txt`). Three units the check first sent to the full pipeline came back: a statement
  starting with an object macro whose body is a name (`libc`), an `#else` between the loop's `;` and the next
  statement (`dup2.c`), and a compound literal in a header's macro (`timer_create.c`).
- **test-direct:** 272 passing; under ASan, UBSan and bounds in the standalone harness, 272 passing.
- **Mutants** (`mutants.py`, 29 single-site changes of the check): 25 fail test-direct. Alive: the parentheses' and
  `;`s' count beside the names' comparison and the vector reader's `for` separators (a later check makes each), the
  literals' mask (without it the token reader reads them, slower), and the header's own newlines' count (only those
  between the `)` and the `;` decide).
