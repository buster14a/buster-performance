# The identifiers' ids in another order, Buster #153

Compiler change: [buster14a/buster#739](https://github.com/buster14a/buster/pull/739), branch
`claude/solve-153-049a9d`, for [this claim on #153](https://github.com/buster14a/buster/issues/153#issuecomment-6479006064).
It merged through #749 on 2026-10-28.

#739 adds the C driver's test option `--id-order N`, which gives a unit's identifiers their ids in another order, and
checks with it that nothing the compile writes depends on the ids. This record holds the receipts of the two kinds of
evidence its description reports, as [the reviewer asked](https://github.com/buster14a/buster/pull/739#issuecomment-6480634678)
after the review. The [final review](https://github.com/buster14a/buster/pull/739#pullrequestreview-5690067347) called
them historical reports without raw pins:

- **9700X comparisons:** the default path (`-c` of the frozen `sqlite3.c`), and the times of the four tests the change
  touches, in two pairs of builds;
- **two deliberately broken builds**, which `test-check-lanes` must catch.

It also corrects #739's description, which names the wrong base for the second pair ("Corrections" below).

## Sources

Each tree on the 9700X was sent there by `tar`, without `.git`. To identify it, its files (all but `build/`) were
hashed on the host (`sources/tree-*.sha256`) and compared with `git archive` of the candidate commits, file by file:

| Tree | Built (UTC) | Matches | Differences |
| --- | --- | --- | --- |
| base | 20:09:33 | `ba379033f706652a32fcc3a64b63c5b031f34428`, main, the branch's merge-base | none |
| head | 20:13:58 | `69062dbb6471abda93a7cb5f51627b8eaf08821d`, the branch's first commit | a comment in `c_checker_driver.c` (the same lines) and two documents: `sources/head-vs-69062dbb.diff` |
| base2 | 20:22:51 | `abc6bf2455c6d1d78f16bc2d494276380c546a79`, main after #728 | none |
| head2 | 20:26:58 | `6d1d5def9537b35ddbd48fddbdc81b8150a7c85f`'s code, the branch's second commit, on main `ea16253f99cacbf0fbfb38612de5c9639fefaae2` | `docs/determinism.md` only: `sources/head2-vs-6d1d5def.diff` |

head and head2 were sent a few minutes before their commits were made: head's differences are a comment reworded within
the same lines and two documents, and head2's a document. Main `ea16253f` is the main that the branch merged
(`a416a927dc5fdde81a87d15cf02c6897dad740e0`'s second parent), and it lacks #728, which `abc6bf24` adds.

The c-testsuite programs on the 9700X (`sources/c-testsuite-9700x-tests.sha256`) are c-testsuite commit
`5c7275656d751de0e68b2d340a95b5681858ed07`'s `tests/` (`sources/c-testsuite-5c72756-tests.sha256`), all 879 files byte
for byte, without `tests/LICENSE`.

## Host

`9700x/identities.txt` is a transcript of the host and of the binaries', outputs' and inputs' SHA-256, taken at
23:04 UTC, after the runs (20:07 to 20:55 UTC):

- AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1. pacman's log has no package change since 2026-10-12, so the
  toolchain is the runs' own.
- CPU 2's governor is `performance`, and CPUs 0, 1 and 3 to 7 run `powersave`. The `-c` timings ran on CPU 2. The tests
  ran on CPUs 0 to 7 (c-testsuite's on 0 to 3), so their times are informational.
- The executables' modification times match the scripts' build lines in `9700x/status*.log`. base's executable,
  `ac01998e...`, has the same SHA-256 as the base build of the same commit in
  [the #148 record](../alloca-frame-builtins-148-2026-10-28/README.md), which another session made separately.

## Method

`scripts/run153.sh` (base against head) and `scripts/run153b.sh` (base2 against head2) ran each step through the
host's lock (`exclusive.sh`), one hold per command, and wrote each step's exit status to `9700x/status.log` and
`9700x/status2.log`:

1. **Build.** Each tree was built with `BUSTER_DEBUG_INFO=0 ./build.sh` on CPUs 0 to 7 (`9700x/build-*.log`).
2. **Output check.** Each executable ran `-c sqlite3.c -o drive-TREE.o` once on CPU 2, and `cmp` compared the two
   objects. The input is the SQLite amalgamation, byte-identical to the 9700X job's frozen corpus file
   (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`, SHA-256 `0a409f16...`).
3. **Timing.** `time-runs --runs 21 --warmups 2 --copies 3` ran on CPU 2: each build's executable as three fresh
   copies, in rotated order, 63 runs a build (`9700x/time-runs.log`, `9700x/time-runs2.log`, each run's line with
   its exit status).
4. **Tests.** Two rounds of the four tests, base's then head's, each timed by bash's `time`
   (`9700x/times.log`, `9700x/times2.log`). The head trees ran `test-checker-corpus` with `--id-order 153`, which the
   base trees don't have.

## Results

Every step exited with status 0 (`9700x/status*.log`). Each pair's two `-c` objects were the same bytes, all four of
them SHA-256 `82f7f21a...`, and so was the last timed run's (`timed.o`).

`-c sqlite3.c` on CPU 2, the medians of 63 runs (`time-runs`' summary lines):

| Pair | Wall time, base | Wall time, head | Head against base (over copies) | User cycles, head against base | Instructions, base | Instructions, head |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| base `ba379033`, head `69062dbb` | 120.539 ms | 120.416 ms | −0.10% (−0.45% to +0.26%) | −0.02% (−0.39% to +0.15%) | 1,208,225,575 | 1,208,243,400 |
| base2 `abc6bf24`, head2 `6d1d5def` | 121.582 ms | 121.678 ms | +0.08% (−0.17% to +0.22%) | +0.06% (−0.29% to +0.32%) | 1,215,952,315 | 1,215,950,896 |

The instruction counts are the first copy's medians; each build's three copies agree within 50. The two pairs'
instruction differences have opposite signs (+17,825 and −1,419), as code placement gives.

The tests' wall times, in seconds, two rounds each:

| Test (CPUs) | base | head | Added | base2 | head2 | Difference |
| --- | --- | --- | ---: | --- | --- | ---: |
| `test-check-lanes` (0 to 7) | 1.452, 1.431 | 1.757, 1.758 | +0.32 | 1.496, 1.429 | 1.759, 1.761 | +0.30 |
| `test-checker-deferred` (0 to 7) | 1.932, 1.903 | 2.774, 2.780 | +0.86 | 2.144, 2.169 | 2.456, 2.480 | +0.31, see below |
| `test-c-testsuite --jobs 4` (0 to 3) | 0.546, 0.567 | 0.596, 0.594 | +0.04 | 0.525, 0.516 | 0.557, 0.586 | +0.05 |
| `test-checker-corpus --deferred 8` (0 to 7) | 1.985, 1.996 | 2.072, 2.089 | +0.09 | 2.010, 2.015 | 2.112, 2.065 | +0.08, see below |

Only the first pair measures #739's cost:

- **First pair (base, head):** both trees differ by the branch's first commit alone. Its ordered deferred runs, on 1 and
  8 lanes, added 0.86 s to `test-checker-deferred`.
- **Second pair (base2, head2):** base2 carries #728's deferred reader and its tests (`c_check_deferred.c`,
  `c_check_deferred_test.c` with 193 lines more, `c_check_corpus.c`), and head2 doesn't. Its `test-checker-deferred` and
  `test-checker-corpus` differences mix #728's changes with #739's, so they don't measure what the second commit
  (deferred runs on 8 lanes only) costs. No run here measures that.
- **`test-check-lanes` and `test-c-testsuite`:** #728 changed only the deferred reader, its tests and benchmark and
  `c_check_corpus.c`, which neither test runs, and both pairs agree.

## The broken builds

Both builds ran on the author's laptop (`mutants/host.txt`): AMD Ryzen 9 7940HS (Zen 4), clang 23.1.4, installed
2026-10-26, before the run. Both started from the session's worktree at 20:13:33 UTC: commit `69062dbb` with main
`ea16253f` merged in, the merge resolved but not yet committed. `a416a927` committed that merge at 20:21:40 UTC. By the
session's command log, the worktree's only change in between (`c_check_deferred_test.c`, 20:21:23) stayed out of that
commit and went into `6d1d5def`. `mutants/mutant1.patch` and `mutants/mutant2.patch` are each build's change against
`a416a927`, rebuilt from the session's recorded commands:

- both builds' `build.sh` takes `-O1` for `-O3`, so that clang doesn't fold the change away;
- **mutant 1** never primes the table: `--id-order` changes nothing;
- **mutant 2** writes a letter taken from an identifier's id into the made names of function-scope statics
  (`f.counter`).

`scripts/mutants.sh` built each tree and ran three tests on it (`mutants/mutants.log`):

| Build | Built | `test-check-lanes` | `test-c-testsuite` | `test-checker-deferred` |
| --- | --- | --- | --- | --- |
| mutant 1 | status 0 | status 1: 3,638 checks, 24 failures ("the second compile has every name, most at other ids") | status 0, 220 of 220 | status 0 |
| mutant 2 | status 0 | status 1: 3,638 checks, 56 failures ("an emission with the ids in another order makes the same object or failure") | status 0, 220 of 220 | status 0 |

`test-check-lanes` catches both. The other two tests pass: c-testsuite's executables don't carry these names, and
`test-checker-deferred` emits no code. The broken trees and their executables were
deleted at 20:57 UTC, so this record has no SHA-256 of them.

## Corrections to #739's description

- The second pair's base, labelled "main `ea16253f`" there, was `abc6bf24`: main after #728, which merged at 20:14 UTC,
  between the branch's merge of `ea16253f` and the making of base2. Its `-c` numbers stand as measured (#728 changes
  the deferred reader, which `-c` doesn't run).
- For the same reason, the second pair's `+0.31 s` for `test-checker-deferred` and `+0.08 s` for
  `test-checker-corpus` aren't the cost of #739's checks (Results above).

## How the logs were made

`scripts/filter.sh RAW OUT` made every log here from the raw ones. It keeps only the lines that the scripts, `time-runs`,
bash's `time`, `build.sh` and the tests print:

- exclusive.sh's waiting messages are left out, because they name the jobs that held the host: their commands, titles
  and links;
- the laptop's core-queue messages are left out too, because they name other sessions.

The drive steps' standard errors (`drive-*.err`) held nothing else (the compiles printed nothing), so they aren't
included. The filter drops no line that a run wrote after its lock was granted: each `time-runs` log keeps all 139 lines
that follow its first run line. The unfiltered logs stay on the host, in `~/buster-fast-bench/solve-153-claude`.

## Limitations

- One host, one input and two rounds of each test. The tests' times come from CPUs under `powersave`, and the `-c`
  numbers come from one CPU.
- The host transcript was taken after the runs, and no independent record of each lock acquisition exists beyond the
  scripts' structure and their status lines.
- The broken builds' executables are gone, and their patches are rebuilt from the session's commands rather than kept
  from the trees.
