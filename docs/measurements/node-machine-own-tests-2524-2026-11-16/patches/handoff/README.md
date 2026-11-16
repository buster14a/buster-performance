# The hand-off series: buster#2524's commits that are in no branch

The session that made them handed buster#2524 off on 2026-11-16 (the owner keeps one session on this work, and asked
for nothing more to be opened). Its one branch in buster, `claude/determined-faraday-wul4wj`, was pull request
buster#2867's ("T where it sits"), merged that morning. These four commits came after it and were never pushed:

| patch | commit's subject | option | description for a pull request |
| --- | --- | --- | --- |
| `0001` | Node machine: C and X where they sit, at reader time, in the shadow | `--front-sweeps` | [reader-sweeps record](../../../node-machine-reader-sweeps-2524-2026-11-16), `patches/pull-request-body.md` |
| `0002` | Node machine: the tests where they sit, at reader time, in the shadow | `--front-tests` | [reader-tests record](../../../node-machine-reader-tests-2524-2026-11-16), `patches/pull-request-body.md` |
| `0003` | Node machine: the tests in the machine's own form, at reader time, in the shadow | `--front-own-tests`, `--front-tests-last` | `0003-pull-request-body.md` here |
| `0004` | Node machine: the front by passes, without a stack, in the shadow | `--front-flat`, `--front-flat-first` | the commit's message and the [flat-front record](../../../node-machine-flat-front-2524-2026-11-15)'s findings; none was written |

All four are the shadow only (`measure-node-machine --shadow`): no compile takes any of them.

## Applying

The series' base is main `3d0d56ed75c5406bfe53c379f37f0d3f85bfc484` (buster#2865's merge; buster#2867 and buster#2871
are before it):

```sh
git fetch origin main
git checkout -b BRANCH 3d0d56ed75c5406bfe53c379f37f0d3f85bfc484
git am PATH/buster-performance/docs/measurements/node-machine-own-tests-2524-2026-11-16/patches/handoff/000*.patch
```

`git am` keeps each commit's author, message and trailers (the sign-off each was made with, in the maintainer's own
directed session); it runs no commit-msg hook, so none is added or doubled. `SERIES.sha256` has the patches' checksums
and the tree each commit gives: after the four, `git rev-parse HEAD^{tree}` is
`522fa6b9536561e6313b20499aa75b494edc4792` (checked by applying them on a clean checkout). On a later main use
`git am --3way`.

The patches are in pull-request order: `0002` needs `0001`, and `0003` needs `0002`. `0004` is independent of them in
what it does and was put last, so the first three can go without it. A pull request's description for `0001` and `0002`
is in each one's record, written for the older base: their numbers stand, their "parent" is no longer the tree below.

## What was run, and on which tree

In the cloud container (Develop builds, 4 cores), on main `3d0d56ed7`:

| tree | what | result |
| --- | --- | --- |
| after `0003` | `test-checker --seed 133`, all eight parts | 842,465 checks, 0 failures |
| after `0003` | the own form beside the census's code, `sqlite3.c`, Lua and musl, the default warnings and `-Wall -Wextra` | 0 differences in the six runs |
| after `0003` | buster#2871's `--facts --facts-operators` on the three corpora | 0 differences; taken 97.97%, 91.82% and 95.34%, as in that pull request |
| after `0004` | `test-checker --seed 133`, all eight parts | 842,472 checks, 0 failures |
| after `0004` | the same on the `BUSTER_HOST_ARCH=x86-64` build (CI's baseline row: the scalar host paths) | 210,274 checks, 0 failures |
| after `0004` | the flat front against the lean front; the own form beside the census's code with every warning; both in one run; `--facts --facts-operators` (`sqlite3.c`, Lua) | 0 differences in each |
| after `0004` | the compiler checks and parses its own source | passes |
| after `0004` | `./build.sh check-call-graph --config Release` | 0 cycles |

Part 7 of `test-checker` wants a quiet machine in that container: beside other builds it lost one check twice to the
harness's 60 seconds a command (clang's own build of the wide vectors' oracle takes 54 there); alone it passes on both
trees and on main itself.

On the older base (main `be6515fba` with buster#2867's head, before buster#2871): the whole of `test-checker` after
`0003`, 842,455 checks, 0 failures, and every measurement of the four records (the 9700X's builds are that base's).
The 9700X's measurements were not repeated on main `3d0d56ed7`.

Not run on any tree: CI, the sanitizer rows and the 9700X's qualification jobs, which a pull request runs.

## Owed before `0003` is a pull request

Of 98 faults put into the own form one at a time, the tests show 63 and the corpora 5 more; 30 show on no input. A
line of C shows 19 of those at once: the census's fixtures have no line for them (the record's section 6;
`scripts/faults/probe/*.c` are the lines). Put those lines in a fixture with their counts, and sort the other 11 into
lines owed and conditions another repeats.

## How the series met buster#2871 and the flat front

- The series was made on buster#2867's head and re-picked on main after buster#2871 was merged. `0002` and `0003`
  each met that pull request's changes in `src/buster/compiler/c_check_node_census.c`: the usage comment's list of
  options (both sides' options kept), and the line where the command checks its options (that pull request's
  condition kept, then this series' `shadow.reader |= ...` lines). `scripts/resolve-on-main.py` is the resolution.
- `0004` was first made on buster#2867's older head, before the three others, and is here re-picked on top of them.
  Its ten hunks (the guide, the design's sections, the command's options and failure terms, the fixtures' conditions,
  the front's bits) were resolved with both sides kept in each: `scripts/resolve-flat-front.py`.
