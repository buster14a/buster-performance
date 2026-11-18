# The casts, a pointer's subscripts and its sums: the tests on the window's fourth piece (buster#2850): 2026-11-18

The second half of buster14a/buster#2850's step 2's tests on the window, fourth piece: three kinds of operator that a
pointer sent to a test that finds nothing are left out of the loop's list. In the shadow alone
(`measure-node-machine --shadow --window-tests`): no compile takes it. [Its
specification](https://github.com/buster14a/buster/issues/2850#issuecomment-6979565234) was posted before its code.

- 9700X: CPU 2, Release, each run its own hold of the lock, the two builds in turn in each reading, each from a fresh
  copy of its compiler a reading (`turns.sh` and `tables3.py` are [the third piece's](../window-tests-calls-2850-2026-11-18/scripts),
  `job-pair.sh` and `build-label.sh` [the second's](../window-tests-listing-2850-2026-11-18/scripts) and [the first
  half's](../window-tests-2850-2026-11-17/scripts)).
- The base is buster14a/buster#2973's head `cc9c84a54` (`m5`). `p41` and `p42` are the piece on it, patches against
  that commit (`patches/`): `p41` the first complete form, `p42` the pull request's sources (two fixture lines more,
  and one edit of the tests' own code taken back, section 5).

## 1. What was counted before the code (`census/`, `scripts/`)

`census/census.patch` (on `cc9c84a54`, experiment only) gives the shadow a line for each expression listed for the
tests that read T's records, and each of its listed operators: its operator, what sent it, its own type's byte and
integer width, each operand's value's byte and operator, and what its test found. `census/*.out.gz` are its runs in
the cloud container on `sqlite3.c`, Lua, musl and the compiler's own source, with the default warnings and with
`-Wall -Wextra` (`BUSTER_CENSUS_LINES=1 compiler measure-node-machine --shadow --passes 0 --window-tests ...`; unpack
them before a script reads them).

`scripts/casts.py` (the listed casts by sender and own type), `classes.py` (the listed operators by class),
`enums.py` (what an enumeration alone sent) and `piece.py` (the three rules put through the lines) give, with the
default warnings:

| | `sqlite3.c` | Lua | musl | own source |
| --- | ---: | ---: | ---: | ---: |
| expressions the tests run on | 50,996 | 10,839 | 43,415 | 52,015 |
| listed for the tests that read T's records | 15,926 | 5,108 | 16,655 | 27,952 |
| their listed operators | 15,688 | 5,977 | 14,556 | 21,223 |
| casts | 7,370 | 1,995 | 3,849 | 2,639 |
| a pointer's, to void | 6,256 | 1,446 | 2,093 | 1,520 |
| a pointer's, to a pointer | 1,026 | 464 | 609 | 373 |
| a pointer's, to a 64-bit integer | 88 | 9 | 1,122 | 133 |
| an enumeration's | 0 | 76 | 25 | 613 |
| of them with a test that finds anything | 0 | 0 | 0 | 0 |
| subscripts with a constant operand | 3,181 | 78 | 1,582 | 2,061 |
| of them, of a plain pointer | 2,288 | 57 | 655 | 938 |
| sums of a plain pointer and a constant | 174 | 305 | 254 | 335 |
| **the rules' prediction:** casts, subscripts, sums left out | 7,282 + 2,288 + 174 | 1,986 + 57 + 305 | 2,727 + 655 + 254 | 2,506 + 938 + 335 |
| operators listed after | 5,944 | 3,629 | 10,920 | 17,444 |
| expressions listed after | 9,540 | 3,932 | 14,546 | 26,250 |
| their records, of the listed expressions' before | 61,457 of 111,130 | 35,972 of 44,374 | 80,398 of 94,609 | 198,855 of 212,071 |
| with every warning: expressions listed, after and before | 29,480, 30,663 | 6,814, 7,245 | 25,126, 25,793 | 39,667, 40,203 |

(The casts' predictions count an enumeration's casts, which nothing sends any more, with those left out.)
`scripts/steps.py` and `rules.py` are the candidates that were weighed: a cast to a 64-bit integer too (35, 1, 90 and
17 expressions more), a pointer against a null constant, an initialization's root. `left.py` and `left2.py` count what
stays listed (section 6).

## 2. The piece's own counts (`results/cloud/first`, `results/cloud/final`)

`results/cloud/first` is the first build of the three rules on `cc9c84a54`, beside `--verify`, with the default
warnings and with every warning; `results/cloud/final` the pull request's head, the same sources on main `45f3f8561`.
Both give:

| `--window-tests --verify` | `sqlite3.c` | Lua | musl | own source |
| --- | ---: | ---: | ---: | ---: |
| expressions the tests run on, that differ | 50,996, 0 | 10,839, 0 | 43,415, 0 | 52,015, 0 |
| casts left out, checked, with a test | 7,282, 7,282, 0 | 1,910, 1,910, 0 | 2,702, 2,702, 0 | 1,893, 1,893, 0 |
| operators the constants' rule leaves out, checked, with a test | 23,363, 23,359, 0 | 7,392, 7,389, 0 | 15,394, 15,386, 0 | 29,452, 29,452, 0 |
| the same before the piece | 20,900, 20,897, 0 | 7,030, 7,027, 0 | 14,484, 14,477, 0 | 28,179, 28,179, 0 |
| operators listed | 5,944 | 3,629 | 10,920 | 17,444 |
| expressions with nothing listed, checked, with another verdict | 41,456, 41,456, 0 | 6,907, 6,907, 0 | 28,869, 28,869, 0 | 25,765, 25,765, 0 |
| with every warning | 21,516 | 4,025 | 18,289 | 12,348 |

An operator left out is checked where its expression is one the tests ran on; the few others (4, 3 and 8) are records
of expressions without tests. The subscripts and the sums are the constants' rule's: 2,462, 362, 909 and 1,273 more
checked than before. The counts are section 1's predictions, to the expression.

## 3. On the 9700X (`results/9700x/m5`, `p41`, `p42`; `patches/`; `scripts/job-p41.sh`, `job-pair7.sh`)

Each build in turn with `m5` in its own job; TSC ticks a record of the expressions the tests ran on; medians of seven
readings (musl's of fifteen; with every warning of five, musl's of fifteen; the window without the tests of three for
`p41` and seven for `p42`):

| ticks a record | `sqlite3.c` | | Lua | | musl | |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| | `m5` | the build | `m5` | the build | `m5` | the build |
| `p42`, the pull request's sources: the tests on the window | 35.53 | 31.15 | 53.39 | 49.36 | 99.93 | 95.84 |
| bytes | 9.28 | 9.25 | 10.75 | 10.70 | 19.09 | 18.77 |
| loop | 1.63 | 1.64 | 2.31 | 2.49 | 4.88 | 5.60 |
| part | 9.54 | 9.48 | 9.74 | 9.56 | 17.18 | 17.22 |
| rest | 15.02 | 10.79 | 30.57 | 26.52 | 56.74 | 52.71 |
| with every warning | 63.39 | 59.69 | 71.09 | 67.20 | 126.92 | 123.01 |
| beside `--verify` (one reading) | | 85.11 | | 102.67 | | 173.36 |
| the kernel in place, without the tests | 16.36 | 16.02 | 20.86 | 20.53 | 19.11 | 19.05 |
| the front with the window | 53.11 | 53.27 | 71.00 | 70.70 | 89.86 | 92.54 |
| `p41`: the tests on the window | 35.89 | 31.18 | 53.44 | 48.97 | 98.97 | 92.70 |
| bytes | 9.29 | 9.30 | 10.77 | 10.76 | 19.22 | 18.52 |
| loop | 1.67 | 1.64 | 2.33 | 2.50 | 4.78 | 5.24 |
| part | 9.72 | 9.50 | 9.78 | 9.50 | 17.35 | 16.83 |
| rest | 15.17 | 10.73 | 30.60 | 26.14 | 55.37 | 50.17 |
| with every warning | 63.32 | 59.89 | 70.85 | 66.65 | 126.89 | 120.70 |
| the kernel in place, without the tests | 16.31 | 16.78 | 20.84 | 20.92 | 19.10 | 19.12 |
| the front with the window | 53.19 | 53.01 | 70.66 | 70.94 | 91.03 | 90.63 |

Readings of the tests: `p42` 30.6 to 31.5 for 35.4 to 36.0 on `sqlite3.c`, 49.2 to 53.9 for 53.0 to 54.2 on Lua, 88.2
to 105.0 for 93.7 to 110.2 on musl; `p41` 31.1 to 32.1 for 35.5 to 36.2, 48.7 to 51.0 for 53.2 to 56.4, 85.0 to 98.0
for 93.6 to 126.9. The kernel in place: `p42` 15.96 to 16.22 for 16.30 to 16.42 on `sqlite3.c`; `p41`'s three
readings 16.45, 16.78 and 18.69 for 16.28 to 16.35.

`-c sqlite3.c` as whole processes (21 runs of each of three copies, twice): `p42` wall -0.05% and -0.06%, user cycles
-0.01% and +0.09%, where `m5` against itself reads -0.08% and -0.16%, -0.10% and -0.08%; `p41` wall -0.18% and
+0.04%, user cycles -0.07% and -0.06%, where `m5` against itself reads -0.31% and -0.17%, -0.13% and -0.16%. No
compile runs the piece's code.

Against the specification's gates:

1. Exact: met (section 2).
2. The counts (no more than 9,600, 3,950, 14,600 and 26,300 expressions listed): met, at 9,540, 3,932, 14,546 and
   26,250.
3. The tests on the window under 31.0 on `sqlite3.c`, refuted at 32.0: missed by 0.2, at 31.15 and 31.18. Under 50.0
   on Lua, refuted at 51.0: met, at 49.36 and 48.97. musl reads no more.
4. The records' bytes and the loop together no more than 0.3 above: met on `sqlite3.c` (10.89 for 10.91, 10.94 for
   10.96) and Lua (13.19 for 13.06, 13.26 for 13.10); on musl 24.37 for 23.97 in `p42` and 23.76 for 24.00 in `p41`.
   The loop alone reads 0.2 more on Lua and 0.5 to 0.7 more on musl in both builds: some 50 ticks a chunk on each
   (244 and 2,975 chunks), which the rules' dozen operations a block don't account for. No counter was read for it.
5. What is not this piece's reads the same: the kernel in place within what two builds read (16.02 and 16.78 for
   16.36 and 16.31), the front with the window within its spread, `-c sqlite3.c` as above.

45% of `sqlite3.c`'s listed records left the list, and 28% of the ticks of the tests on T's records (10.79 for
15.02): 3,890 of the 9,540 expressions still listed are initializations, with 11,513 of the 61,457 records listed.

## 4. The cloud container's checks (`results/cloud/final`)

The pull request's head: the piece on main `45f3f8561` (the work branch's `93e88be77`; the session branch's commit
has the same sources, and the documents; 4 CPUs, native host, Release):

- `test-checker`, all eight parts: 842,789 checks, 0 failures (`test-checker-status.txt`).
- The shadow on `sqlite3.c`, Lua, musl and the compiler's own source in 12 modes: 48 runs, each status 0
  (`shadow/status.txt`; the `--window-tests` modes' outputs are beside it). The counts are section 2's.
- The self-check, the self-parse, `test-call-graph` and `check-call-graph`: status 0.
- The complete driver: one heading fails, as on main in this container ("Test the preprocessor on the repository's
  translation units against clang": the container's clang's resource directory's path).
- The sanitizer rows a pull request's checks don't run (`sanitizers-progress.txt`; native memory, address and thread,
  on the session branch's `384376af5`, the same sources): a build each, `test-checker --part 5/8` (210,342 checks, 0
  failures), and for memory and address the shadow with `--window-tests --verify` and with
  `--window-tests --verify -Wall -Wextra` on `sqlite3.c`, Lua and the compiler's own source. Every run status 0, no
  report.

## 5. Faults (`faults/`)

32 faults put into the piece's code, one at a time, in two copies of the tree (`faults.py`: the Debug compiler built,
then `test-checker --seed 133 --part 5/8`). 29 fail the tests as written; the other three didn't compile (a variable
left unused) and fail them with their texts corrected (`faults2.py`, `results2-0.txt`). They are, by part: the
table's pairs (a side removed, a side taking any kind, two pointers, the pairs in the class of `==` too); the
tables' entries (a cast sending an enumeration again, an assignment sending none, a subscript without its class); a
subscript's constant pointer (either side alone, any pointer, the mask's kind or its constant's bit alone, every
operator, no operator); the casts' mask (unsent casts too, void alone, a pointer alone, an enumeration too, any type,
every operator, a pointer to void for a pointer); and the masks and counts (the casts out of the mask of what is left
out, or left in the operators' list; each count dropped or taken from another).

Before the campaign one edit went back for doing nothing: `node_tests_operator`'s enumeration trigger asked of what
the operator sends (`sent`) where it asks of its operands (`all`). A cast that reaches that code has a pointer for
an operand, and no enumeration.

## 6. What is left, and why a call stays listed (`scripts/left2.py`, `census/calls/`)

`left2.py` on the census's lines, the piece's rules applied (default warnings):

| | `sqlite3.c` | Lua | musl | own source |
| --- | ---: | ---: | ---: | ---: |
| expressions listed | 9,540 | 3,932 | 14,546 | 26,250 |
| initializations among them | 3,890 | 1,723 | 6,333 | 16,438 |
| for an initialization's root alone | 3,439 | 1,278 | 5,828 | 13,027 |
| for a listed operator alone | 4,273 | 1,440 | 6,567 | 8,669 |
| for writes out of sequence alone | 698 | 150 | 490 | 163 |
| for a returned address alone | 92 | 162 | 327 | 55 |
| operators listed | 5,944 | 3,629 | 10,920 | 17,444 |
| of them with a test that finds nothing and sends nothing | 5,026 | 2,593 | 9,123 | 10,793 |
| assignments, of a constant, with nothing | 1,250, 1,250, 1,250 | 223, 213, 158 | 1,112, 1,099, 1,074 | 1,535, 1,247, 954 |
| of them, a zero in a plain pointer | 592 | 0 | 114 | 74 |
| subscripts, of an array by a constant | 893, 893 | 30, 21 | 931, 927 | 1,151, 1,003 |
| calls | 854 | 673 | 1,359 | 4,393 |
| conditionals and commas | 988 | 925 | 816 | 5,728 |
| casts of a pointer to a 64-bit integer | 88 | 9 | 1,122 | 133 |

`census/calls/census-calls.patch` counts, in the kernel's call rule's short path, why a call's arguments are loud
(over every run of the rule in a `--window-tests` run, so a call counts several times):

| the kernel's call rule's runs | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| calls its short path makes | 90,181 | 29,225 | 60,067 |
| their arguments quiet | 84,469 | 26,026 | 50,645 |
| an integer constant that is not zero or 1 to 126 among them | 5,579 | 2,373 | 8,547 |
| of them, a negative one | 1,869 | 2,079 | 854 |
| an aggregate; a constant of another kind | 119, 21 | 0, 21 | 182, 231 |
| an integer constant a parameter doesn't take unchanged | 7 | 819 | 546 |

Two thirds of Lua's calls that an argument keeps listed (2,079 of 3,199) have a negative constant among their
arguments, a third of `sqlite3.c`'s (1,869 of 5,712) and a tenth of musl's (854 of 9,422).

## 7. Before the next piece: what listing an initialization for its root costs (`results/9700x/e5`, `scripts/job-e5.sh`, `tables-knob.py`, `roots.py`)

3,439, 1,278, 5,828 and 13,027 expressions are listed for an initialization's root alone (section 6). `e5` is the
piece with a switch (`patches/tests-e5-on-cc9c84a5.patch`: `--census-roots-unlisted`) that lists none of them for
its root: one executable, its two settings in turn from one copy a reading. With the switch the window's verdict of
such an expression has another root's kind than the reference's (each of them differs, and the run's status is 1):
it is a bound on what a rule of the root can save, not a form of it.

| ticks a record | `sqlite3.c` | | Lua | | musl | |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| | listed | not listed | listed | not listed | listed | not listed |
| the tests on the window | 31.33 | 29.85 | 49.59 | 47.06 | 94.85 | 90.10 |
| bytes | 9.26 | 9.27 | 10.70 | 10.74 | 18.85 | 18.64 |
| loop | 1.66 | 1.65 | 2.48 | 2.45 | 5.20 | 5.22 |
| part | 9.57 | 9.41 | 9.58 | 9.55 | 16.60 | 16.76 |
| rest | 10.88 | 9.38 | 26.44 | 24.30 | 53.49 | 48.77 |
| expressions listed | 9,540 | 6,101 | 3,932 | 2,654 | 14,546 | 8,718 |

Readings of the tests: 30.8 to 31.9 and 29.5 to 30.2 on `sqlite3.c`, 48.9 to 55.4 and 46.4 to 54.6 on Lua, 89.0 to
100.2 and 82.5 to 98.8 on musl. So the roots are 1.5, 2.5 and 4.7 ticks a record at most, before what a rule's own
inputs cost. `scripts/roots.py` has the listed initializations by their object's type and their top's constant: with
the rules of this piece applied, 1, 1, 15 and 23 of those listed for their root alone have an integer constant for a
floating object, which the root's test asks the census's code about.
