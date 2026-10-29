# GNU's `cleanup` attribute, Buster #147

Compiler pull request: [buster14a/buster#745](https://github.com/buster14a/buster/pull/745), branch
`claude/solve-147-bb48a1`, for [this claim on #147](https://github.com/buster14a/buster/issues/147#issuecomment-6478625460).

The pull request checks GNU's `cleanup` attribute as clang 23 does and calls the function at each exit from its
variable's scope. This record holds two pieces of evidence:

1. **The default path's cost**: `-c` of the frozen `sqlite3.c`, which declares no cleanup, by main and by the pull
   request's first head, over the checker unit's code placements and fresh copies of each executable (#509's method),
   with an A/A control, and a `cycles:u` profile of both.
2. **Mutation receipts** of the original commit's implementation and tests, and one mutant of the follow-up that made
   the messages clang's.

Neither is a measurement of the pull request's final head: its later commits (the review's repairs, the messages) were
not timed, and no timing claim about them follows from this record.

## Sources

| Role | Commit | Tree |
|---|---|---|
| main | `c9a433b5558d07af180dba00486f805e355b61f9` | main when the first head merged it |
| head | `c25a26ff54852ee94e17dff4545d1984cf2ea9f1` | the pull request's first head: `38b4e80c` merged with that main |
| mutation base | `38b4e80c6f4c8493175256a3517ed2104aae89b9` | the original cleanup commit |

The timed trees on the 9700X are copies whose files, outside `build/`, match `git archive` of their commits file for
file (`sources/main-c9a433b5.sha256`, `sources/head-c25a26ff.sha256`, compared when this record was assembled). The
mutants' base tree matches `38b4e80c` the same way (`sources/mutation-base-38b4e80c.sha256`).

## The default path's cost

### Host, builds and input

Author-reported host (`host.txt`): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9; CPU 2's
scaling governor read `performance` when this record was assembled, after the runs. Every build and measurement took
the host's lock (`exclusive.sh`) for itself. The lock's waiting messages are left out of the logs: they name other
jobs. Only the lines the compiler's tools print are kept (`placements/ab.log` keeps `ab`'s and `time-runs`' lines,
the build logs `build.sh`'s).

Builds: `BUSTER_DEBUG_INFO=0 ./build.sh shifts DIR main_unit_checker.c 0 688 1376 2064 2752 3440` in each tree
(`scripts/shifts.sh`), six executables per tree, each with that many bytes of padding in `.text` before the checker
unit's code. Their SHA-256, the controller's (head's `build/compiler`, which ran `ab` and `time-runs`) and the lock
script's are in `placements/identities.sha256`.

Input: the frozen SQLite 3.53.2 amalgamation of the preprocessor corpora (`sqlite3.c`, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with `sqlite3.h` and `sqlite3ext.h` beside it in
`placements/identities.sha256`). The command: `-c -I<its directory> -o <output> sqlite3.c`, without the 9700X job's
`-D` options.

### Method

`scripts/shifts.sh`: `ab --rounds 3 --cpu 2 --lock exclusive.sh <controller> -- time-runs --runs 3 --copies 3
--directory <copies> --build main <main's six> --build head <head's six> --build main-again <main's six> --list
<command>`. Each round is one `time-runs` process in one hold of the lock, pinned to CPU 2: every build's placements,
each from three fresh copies of its executable, three runs each, in a rotating order, 54 runs per build per round.
`main-again` runs main's executables again: an A/A control in the same hold. All 486 runs exit with status 0.

### Results

Medians of each round's 54 runs per build, from `time-runs`' summaries (`placements/ab.log`):

| Round | User cycles (M), main | head against main | main-again against main | Wall, head against main | main-again against main |
|---:|---:|---:|---:|---:|---:|
| 1 | 572.936 | +0.65% (placements +0.12% to +1.36%) | +0.03% | +0.51% | +0.02% |
| 2 | 573.838 | +0.67% (placements +0.23% to +1.12%) | +0.16% | +0.59% | +0.11% |
| 3 | 574.238 | +0.58% (placements +0.27% to +1.27%) | +0.20% | +0.41% | +0.08% |

Over placements and copies together, each round's head-against-main range crosses zero (cycles: -0.86% to +1.72%,
-0.25% to +1.40%, -0.47% to +1.70%). Instructions are per build alike in every run: main's median
1,237,427,701 (1,237,427,685 to 1,237,427,787), head's 1,237,251,304.5 (1,237,251,286 to 1,237,251,409): 176,397
fewer (-0.014%).

### Profile

`scripts/profile.sh`, in one hold of the lock, pinned to CPU 2: three rounds of `perf record -e cycles:u -c 200003`
over ten compiles each by main's and head's placement-0 executables. `profile/symbols.tsv` sums each symbol's samples
over the rounds, from `perf report --no-children --sort dso,symbol -F sample,dso,sym` of the recorded data
(`profile/data.sha256`; the data and executables are not included). The script's own per-symbol table read the
report's last column and named every symbol `-`; `symbols.tsv` replaces it.

Main has 87,197 samples and head 87,376 (+0.21%). The largest differences are a few hundred samples each in both
directions (`check_input_expressions` -297, `check_graph_action` +163, `check_input_run` +144,
`check_control_children` +139), among them functions this change doesn't touch. On this input every cleanup path is
behind a test of a count of cleanups that is zero.

### Reading it

Head's code costs about 0.6% more user cycles than main's on this command, consistently over three rounds whose A/A
control stays within 0.2%, while it runs 0.014% fewer instructions, and the profile spreads the difference over
functions whose code moved. The placements vary only the checker unit's `.text` offset: the two builds' other units,
`.rodata` and data differ and aren't varied, so this comparison can't separate a layout effect from the change's work.

## Mutation receipts

Host: the author's laptop, AMD Ryzen 9 7940HS (Zen 4), Linux 7.3.0-5-cachyos, clang 23.1.4. `scripts/mutate.py`
copies the `38b4e80c` tree, makes one replacement in one file, builds at `-O1` (its `build.sh`'s `-O3` replaced) and
adds an `ONLY_CLEANUP` switch to `c_checker_test.c` that runs only the cleanup and selection sections;
`scripts/run.sh` builds each mutant and runs those sections, then `test-checker-deferred`. A mutant is killed when
either exits with another status than 0. `mutants/results.txt` is the run's record, `mutants/<mutant>.log` both
commands' output.

| Mutant | Change | Outcome |
|---|---|---|
| M01-no-call | the lowering doesn't call the cleanup | killed: 20 failures |
| M02-no-reverse | cleanups run in declaration order | killed: 12 |
| M03-never-named | a named return value is never returned after the cleanups | killed: 2 |
| M04-always-named | every return is a named return value | killed: 4 |
| M05-no-into | a goto or case may enter a cleanup's scope | killed: 19 |
| M06-no-indirect-exit | a computed goto may leave a cleanup's scope | killed: 4 |
| M07-any-parameter | any parameter type is accepted | killed: 20 |
| M08-no-region | a statement expression's cleanups are dropped | killed: 2 |
| M09-no-for-end | a for statement's own variables' cleanups are dropped | killed: 2 |
| M10-break-runs-for | a break runs the for statement's own variables' cleanups | killed: 2 |
| M11-no-register-copy | a result returned in registers isn't kept before the cleanups | killed: 4 |
| M12-no-region-copy | a statement expression's aggregate value isn't kept | killed: 2 |
| M13-no-reference | the selection doesn't reference the cleanup function | killed: 8 |
| M14-lane-merge | the deferred reader merges a body with a cleanup | killed by `test-checker-deferred`: 13 |
| M15-objects-accepted | an object's argument gets the parameter count's error | **survived** |
| M16-parameter-count | a function of two parameters is accepted | killed: 4 |

M03's and M04's first builds failed (`results.txt`'s first lines for them): their first replacements compared a
pointer with null in a way `-Wtautological-pointer-compare` rejects; the recorded `mutate.py` holds the replacements
they were run with, after the others.

M15 survived because `test-checker`'s fixtures compare where clang and the checker first reject a source, not what
the error says: the mutant's "must take 1 parameter" was on the same line as clang's "is not a function". The pull
request's follow-up words the cleanup errors as clang's and compares every error's place and text with clang's in
`test-checker-driver` (`c_check_cleanup_driver_test.c`), in buster commit
`5465a1b5f450e6d72ae23435af4bcaa1a4921f56`. M15b is the same mutation of that commit's code, built the same way and
checked by `test-checker-driver --executable ./build/compiler` (`mutants/M15b-objects-accepted.log`, its last line in
`results.txt`): killed, 6 failures, the object, function pointer and enumerator fixtures on both paths, each printing
"must take 1 parameter" where clang says "is not a function".

Limitations: the mutants ran on Zen 4 at `-O1`, in the cleanup and selection sections and the deferred reader's test
alone, not the whole suite; each is one replacement chosen by the author.
