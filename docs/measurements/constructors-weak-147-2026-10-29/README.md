# GNU's `constructor`, `destructor` and `weak` attributes, Buster #147

Compiler branch: `claude/solve-147-symbols` of buster14a/buster, stacked on
[buster14a/buster#745](https://github.com/buster14a/buster/pull/745), for
[this claim on #147](https://github.com/buster14a/buster/issues/147#issuecomment-6478625460).

The branch emits GNU's `constructor`, `destructor` and `weak` attributes, which emission refused by name before. This
record holds the default path's cost on `-c` of the frozen `sqlite3.c`, which uses none of them, and the branch's
mutation receipts. The method is the one of `../cleanup-147-2026-10-28/`, with the cleanup pull request's head as the
base.

## Sources

| Role | Commit | Tree |
|---|---|---|
| base | `5465a1b5f450e6d72ae23435af4bcaa1a4921f56` | #745's head when this was measured |
| head | `4e19c28bd35107383aec2bb9dce811160f716f6e` | the branch's commit; see below |

The base tree on the 9700X matches `git archive` of its commit file for file, outside `build/`
(`sources/base-5465a1b5.sha256`). The measured head tree (`sources/head-measured.sha256`) is the branch's state
before its last test change: it matches `4e19c28b` (`sources/head-4e19c28b.sha256`) in every file but two tests,
`src/buster/compiler/c_check_symbol_driver_test.c` and `src/buster/compiler/c_checker_driver_test.c`, which the
measured command doesn't run. Its commit was amended into `4e19c28b` before being pushed and isn't published.

## The default path's cost

Host, lock and builds as the cleanup record states (author-reported 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2):
`BUSTER_DEBUG_INFO=0 ./build.sh shifts DIR main_unit_checker.c 0 688 1376 2064 2752 3440` per tree, in one hold of the
lock each (`scripts/shifts2.sh`). The executables', the controller's (head's `build/compiler`), the lock script's and
the drive check's objects' SHA-256 are in `placements/identities.sha256`. Only the lines the scripts and the
compiler's tools print are kept: the lock's waiting messages are left out (`placements/run.log` keeps the script's
own lines).

A drive check first: each tree's placement-0 executable compiles the file once, pinned to CPU 2, and both objects are
the same bytes (`objects identical`, the two objects' SHA-256 alike). Then three rounds of `ab --rounds 3 --cpu 2 --lock
exclusive.sh <controller> -- time-runs --runs 3 --copies 3`, each round one hold of the lock: base's six placements,
head's six and base's again (`base-again`, the A/A control), three copies of each executable, three runs each, in a
rotating order. All 486 runs exit with status 0. The command: `-c -I<its directory> -o <output> sqlite3.c`.

Medians of each round's 54 runs per build (`placements/ab.log`):

| Round | User cycles (M), head | head against base | base-again against base | Wall, head against base | base-again against base |
|---:|---:|---:|---:|---:|---:|
| 1 | 575.797 | +0.18% (placements -0.60% to +0.63%) | +0.15% | +0.12% | +0.15% |
| 2 | 574.690 | -0.06% (placements -0.88% to +0.46%) | -0.03% | +0.00% | +0.04% |
| 3 | 575.064 | -0.03% (placements -0.42% to +0.44%) | +0.05% | -0.02% | +0.11% |

Every round's head-against-base change is within the A/A control's range of that round or near it, and each range
over placements crosses zero. Instructions per run: base's median 1,241,795,365 (1,241,795,351 to 1,241,795,473),
head's 1,241,838,021 (1,241,838,009 to 1,241,838,105): 42,656 more (+0.0034%), from the emission's attribute pass and
its arrays of weak bindings and priorities. As in the cleanup record, only the checker unit's `.text` placement
varies.

## Mutation receipts

Host: the author's laptop, AMD Ryzen 9 7940HS (Zen 4), Linux 7.3.0-5-cachyos, clang 23.1.4. `scripts/mutate2.py`
copies the measured head tree (the branch before its last test change), makes one replacement, builds at `-O1`, and
adds `ONLY_SYMBOLS` switches that run `test-checker`'s attribute sources and selection sections alone and
`test-checker-driver`'s symbol attributes' test alone; `scripts/run2.sh` runs both for each mutant.
`scripts/mutate2b.py` and `scripts/run2b.sh` do the same on `4e19c28b`'s tree, for the mutants that survived the
first tree. `mutants/results.txt` is the runs' record, `mutants/<mutant>.log` both commands' output.

| Mutant | Change | Outcome |
|---|---|---|
| P01-weak-global | weak definitions and references bound global | killed: 23 driver failures |
| P02-weak-linkage | no linkage error | killed: 20 checker failures |
| P03-weak-typedef | a typedef's weak attribute not ignored | killed: 4 checker failures |
| P04-late-kept | attributes after the definition kept | killed: 8 driver failures |
| P05-unsorted | entries left in definition order | survived the first tree |
| P06-unclamped | priorities past 65535 not clamped | killed: 6 driver failures |
| P07-no-priority-sections | no `.init_array.N` or `.fini_array.N` sections in `-c`'s object | survived the first tree |
| P08-first-declaration | the first declaration's attribute applies | killed: 6 driver failures |
| P09-structor-variables | the entries' function test removed | survived: equivalent |
| P10-priority-ignored | priorities left out of the order | killed: 6 driver failures |
| P11-no-priority-record | no priority records | survived the first tree |
| P05b-unsorted | P05 on `4e19c28b` | killed: 1 driver failure |
| P07b-no-priority-sections | P07 on `4e19c28b` | killed: 1 driver failure |
| P11b-no-priority-record | P11 on `4e19c28b` | killed: 1 driver failure |

P05, P07 and P11 survived the first tree because the linkers and the direct path's writer order entries by priority
themselves, so the programs' output didn't change. `4e19c28b` adds a check that the object's prioritized sections are
clang's, in its order, which kills all three. P09 is equivalent: entries are made only for defined functions' bodies,
so the function test it removes is redundant.

Limitations: the mutants ran on Zen 4 at `-O1`, in those sections alone, not the whole suite; each is one replacement
chosen by the author.
