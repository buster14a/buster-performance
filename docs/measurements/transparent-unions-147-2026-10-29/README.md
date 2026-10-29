# Transparent unions as their first members, Buster #147

Compiler branch: `claude/solve-147-unions` of buster14a/buster, based on main, for
[this claim on #147](https://github.com/buster14a/buster/issues/147#issuecomment-6478625460).

The branch passes a transparent union's argument, parameter and `va_arg` as the union's first member, as clang's code
does, where the lowering passed the union itself and refused a conversion of a member to the union. This record holds
the default path's cost on `-c` of the frozen `sqlite3.c`, which passes no transparent union, and the branch's
mutation receipts. The method is the one of `../cleanup-147-2026-10-28/`.

## Sources

| Role | Commit | Tree |
|---|---|---|
| base | `9bb5060ebe347de5c7a0a92ba325a7b14a567788` | main when the branch was cut |
| first head | `2d8e96d4a682338ee0605c6c22ce2ff147d65081` | the branch's first commit, measured and then amended |
| head | `73c572d339378baa860a1c7450e2c46ae5861a62` | the branch's commit |
| fix's base | `2ae4fa8274af0b5d257b8529fa37dc768eaa6616` | main, the review fix's merge parent |
| fix | `86467e46ffc66b94aa6f6b4786c42c595f7d961c` | the review's fix, on the branch's merges of main (`a1dd0b26`, and `0e944d66` with that main) |

The trees on the 9700X are `git archive` of their commits. `sources/*.sha256` list each commit's files and their
SHA-256, and the trees there matched them file for file outside `build/` when this record was assembled (compared as
sets of lines, sorted by path). The first head isn't published: its commit was amended into the head before it was
pushed. The two differ in `src/buster/compiler/c_check_program_lower.c` alone, where the head moves the new checks off
the arguments that pass no transparent union (below).

## The default path's cost

Host, lock and builds as the cleanup record states (author-reported 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2):
`BUSTER_DEBUG_INFO=0 ./build.sh shifts DIR main_unit_checker.c 0 688 1376 2064 2752 3440` per tree, in one hold of the
lock each (`scripts/shifts3.sh` for the base and the first head, `scripts/shifts3b.sh` for the head, which reuses the
base's six executables). The executables', the controllers' (each campaign's head `build/compiler`, which ran `ab` and
`time-runs`), the lock script's, the inputs' and the drive check's objects' SHA-256 are in
`placements/identities.sha256`. Only the lines the scripts and the compiler's tools print are kept: the lock's waiting
messages, which name other jobs, are left out (`placements*/run.log` keeps the scripts' own lines).

Each campaign starts with a drive check: the placement-0 executables compile the file once, pinned to CPU 2, and the
objects are the same bytes (`objects identical`; the second campaign compares the head's with the first's base
object, and all three have one SHA-256). Then three rounds of `ab --rounds 3 --cpu 2 --lock exclusive.sh
<controller> -- time-runs --runs 3 --copies 3`, each round one hold of the lock: the base's six placements, the head's
six and the base's again (`base-again`, the A/A control), three copies of each executable, three runs each, in a
rotating order. Every run exits with status 0. The command: `-c -I<its directory> -o <output> sqlite3.c`.

### The head

Medians of each round's 54 runs per build (`placements/ab.log`):

| Round | User cycles (M), head | head against base | base-again against base | Wall, head against base | base-again against base |
|---:|---:|---:|---:|---:|---:|
| 1 | 574.687 | +0.02% (placements -0.59% to +0.34%) | -0.01% | +0.02% | -0.05% |
| 2 | 575.204 | -0.08% (placements -0.58% to +0.54%) | -0.07% | -0.01% | -0.05% |
| 3 | 575.363 | -0.14% (placements -0.44% to +0.35%) | -0.16% | -0.17% | -0.19% |

Every round's head-against-base change is within 0.07% of the A/A control's, and each range over placements crosses
zero. Instructions per run: the base's median 1,242,039,252 (1,242,039,169 to 1,242,039,338), the head's 1,243,071,268
(1,243,071,182 to 1,243,071,355): 1,032,016 more (+0.083%). As in the earlier records, only the checker unit's `.text`
placement varies.

### The first head

Medians of each round's 54 runs per build (`placements-first/ab.log`):

| Round | User cycles (M), head | head against base | base-again against base | Wall, head against base | base-again against base |
|---:|---:|---:|---:|---:|---:|
| 1 | 575.494 | +0.13% (placements -0.29% to +0.56%) | +0.12% | +0.16% | +0.12% |
| 2 | 575.227 | +0.11% (placements -0.36% to +0.75%) | +0.09% | +0.10% | +0.10% |
| 3 | 575.472 | +0.07% (placements -0.50% to +0.66%) | +0.01% | +0.08% | +0.08% |

Instructions per run: the base's median 1,242,039,253 (1,242,039,237 to 1,242,039,335), the first head's 1,245,190,243
(1,245,190,232 to 1,245,190,322): 3,150,990 more (+0.254%), with the time within the A/A control's.

### Where the instructions went

On the author's laptop (AMD Ryzen 9 7940HS, Zen 4, clang 23.1.4, native builds), the same file's `-c` by each build
three times, `perf stat -e instructions:u`, pinned to one CPU. Every build's object is the base's bytes, and
`-fsyntax-only` counts alike (the base's 944,209,824 and the fourth row's build's 944,209,617), so the difference is
the lowering's:

| Build | Instructions, median (runs' range) | Against the base |
|---|---:|---:|
| base | 1,240,110,813 (812 to 820) | |
| first head | 1,243,261,660 (646 to 678) | +3,150,847 |
| the transparent test asks the parameter's kind only for an aggregate | 1,242,409,204 (001 to 234) | +2,298,391 |
| and the operands' loop asks only in a call that passes a transparent union | 1,241,786,865 (837 to 876) | +1,676,052 |
| that build without the definitions' parameter edit (V1, two runs) | 1,241,714,305 (299 to 311) | +1,603,492 |
| that build with main's `check_lower_passed` (V2, two runs) | 1,241,315,698 (687 to 709) | +1,204,885 |
| head: the refusals out of line, and the arguments' loop in main's order, a transparent union's argument changing what it computed | 1,241,139,218 (214 to 232) | +1,028,405 |

V1 and V2 are variants of the build in the table's fourth row, each undoing one edit, not published
(`instructions/laptop.csv` has every run's count): the definitions' edit cost 72,560 instructions there and the new
refusals inside `check_lower_passed` 471,167. The head's remaining 1.03M are the arguments' loop's test of each
argument (a conversion to a union, or an aggregate) and how clang's code for the lowering's inlined loops moves with any
edit there (`../aligned-objects-136-2026-10-27/` has the same effect); they weren't placed further. The 9700X's runs
give the same differences: +1,032,016 and +3,150,990.

## Mutation receipts

Host: the author's laptop (above). `scripts/mutate3.py` copies the first head's tree, makes one replacement in
`c_check_program_lower.c`, builds at `-O1` and adds `ONLY_TRANSPARENT` switches that run `test-checker`'s transparent
unions' programs (`c_check_program_transparent_test.c`), its vector programs and the call boundary fixture alone, and
`test-checker-driver`'s socket test alone; `scripts/run3.sh` runs both for each mutant. `scripts/mutate4.py` and
`scripts/run4.sh` do the same on the head's tree, for the mutants whose code the head changed.
`mutants/results*.txt` are the runs' records, `mutants/<mutant>.log` both commands' output.

| Mutant | Change | Tree | Outcome |
|---|---|---|---|
| T01, T01b | a call's argument never passes as the first member (`check_lower_transparent_argument` gives 0) | both | killed: 6 failures each |
| T02 | a definition's parameter passes as the union | first head | killed: 2 |
| T03 | `va_arg`'s plan is the union's | first head | killed: 2 |
| T04 | every first member passes by its bytes, none as a value | first head | killed: 2 |
| T05 | an integer's or a pointer's bits keep their own class (no `CONVERT`) | first head | killed: 8 |
| T06 | a temporary's address passes where the first member's value should load from it | first head | killed: 2 |
| T07 | a union value's address passes where the first member's value should load from it | first head | killed: 14 |
| T08, T08b | no refusal of a union sized or aligned otherwise than its first member | both | killed: 10 each |
| T09, T09b | no refusal of a union made transparent after a definition | both | killed: 4 each |
| T10, T10b | that refusal whatever the union's and the member's classes | both | killed: 8 each |
| T11 | an `_Atomic` union's argument passes as the member | first head | the replacement didn't build (`-Wtautological-negation-compare`, `mutants/T11-atomic-transparent.build-error.txt`) |
| T11b | the same, by another replacement | head | killed: 2 |
| T12, T12b | a conversion to the union isn't seen | both | killed: 4 each |
| T13 | `check_lower_passed_as` gives the union | first head | killed: 20 |
| T14, T14b | an argument passed by its bytes keeps its value's class | both | killed: 12 each |
| T15 | a member aggregate's value is taken as a value of a class | first head | killed: 20 |
| T16 | a vector member goes through a temporary of its class, not of its bytes | first head | killed: 4 |
| T17 | "after a definition" measured against the unit's last body | first head | killed: 4 |

Every failure is `test-checker`'s. The mutants that ran on the first head's tree change code that the head kept as it
was.

The socket test kills none: glibc's socket address unions are all pointers, whose first member passes as the union
does, so it checks the conversion's acceptance, which the program fixtures check too.

Limitations: the mutants ran on Zen 4 at `-O1`, in those sections alone, not the whole suite; each is one replacement
chosen by the author.

## The review's fix

`86467e46`, from the pull request's review, refuses a union made transparent after an initializer that names a
function, as well as after a function definition: clang classifies a function's type where its code first meets it,
and an object's initializer that names the function does. `check_lower_first_classification` finds the earliest such
place in the unit, the first time a lane asks, which only a transparent union whose first member passes otherwise
makes it do; `-c` of `sqlite3.c` passes no transparent union, so it never runs there.

### The default path's cost

The method of "The default path's cost", for `86467e46` against its main parent `2ae4fa82`
(`placements-fix/`, `scripts/shifts3c.sh`), with these differences:

- **Trees:** `git archive` of the two commits (`sources/base-2ae4fa82.sha256`, `sources/head-86467e46.sha256`), each
  matching it file for file outside `build/` and the `COMMIT` file the author added, when this record was assembled.
- **Placements:** `0 704 1408 2112 2816 3520`. The checker unit's `.text` is aligned to 64 bytes at these commits, and
  `build.sh shifts` refused the earlier campaigns' `688` as not a multiple of it: the first attempt stopped at the
  base's build (`placements-fix/run-first-attempt.log`; the build log it wrote was replaced by the second attempt's).
- **Instructions:** each tree's placement-0 executable counted by `perf stat -e instructions:u` for `-c` and
  `-fsyntax-only`, three runs each, pinned to CPU 2, before the rounds (`placements-fix/perf-*.txt`). Their exit
  statuses weren't logged; the script's raw log holds no lines but its own and the lock's messages.
- **Host:** `placements-fix/host.txt`, the same 9700X, kernel, clang and perf as above, CPU 2's governor
  `performance`.

The drive check's objects are the same bytes (`objects identical`). Medians of each round's 54 runs per build
(`placements-fix/ab.log`); every run exits with status 0:

| Round | User cycles (M), head | head against base | base-again against base | Wall, head against base | base-again against base |
|---:|---:|---:|---:|---:|---:|
| 1 | 592.149 | +0.12% (placements -0.35% to +0.76%) | -0.06% | +0.21% | -0.06% |
| 2 | 592.533 | -0.01% (placements -0.35% to +0.71%) | -0.23% | +0.04% | -0.30% |
| 3 | 592.408 | +0.12% (placements -0.35% to +0.60%) | -0.04% | +0.15% | -0.03% |

Each range over placements crosses zero, and over placements and copies the ranges are wider (cycles: -1.19% to
+1.12%, -0.82% to +1.39%, -2.05% to +1.36%). The head's user cycles are above the A/A control's by 0.18%, 0.22% and
0.16%, more than its instructions (below) would cost at an unchanged IPC. The fix's new code doesn't run on this input,
and the placements vary only the checker unit's `.text` offset: as in the cleanup record, this comparison can't tell a
layout effect from the change's work.

Instructions per run, from `time-runs`' 162 runs per build: the base's median 1,296,388,092 (1,296,388,078 to
1,296,388,176), base-again's 1,296,388,093, the head's 1,297,233,519 (1,297,233,509 to 1,297,233,660): 845,427 more
(+0.065%). `perf stat`, medians of three: `-c` 1,296,388,789 and 1,297,234,151 (845,362 more), `-fsyntax-only`
998,966,594 and 998,966,517 (77 fewer). The difference is the lowering's, and it is the whole pull request's against
this main; the head before the main merges and the fix measured 1,032,016 more against main `9bb5060e` (above).

### Mutation receipts of the fix

`scripts/mutate6.py` and `scripts/run6.sh`, as `scripts/mutate4.py` and `run4.sh`, on `86467e46`'s tree, which matches
`git archive` of the commit file for file: one replacement in `c_check_program_lower.c` each, built at `-O1`, then
`test-checker`'s transparent unions' programs, vector programs and call boundary fixture alone, and
`test-checker-driver`'s socket test alone. The unchanged copy passes (`C00-unchanged`: 2,063 and 55 checks).
`mutants/results6.txt` is the run's record, `mutants/<mutant>.log` both commands' output.

| Mutant | Change | Outcome |
|---|---|---|
| T18 | an initializer never names a function (`check_lower_initializer_names_function`) | killed: 144 failures |
| T19 | the first definition's body isn't a place | killed: 4 |
| T20 | the vector scan reads the lane after each hit | killed: 72 |
| T21 | an initializer naming an object counts, one naming a function doesn't | killed: 220 |
| T22 | a union counts as late when made transparent before the place | killed: 236 |

Every failure is `test-checker`'s; the socket test kills none, as before. Limitations as above.
