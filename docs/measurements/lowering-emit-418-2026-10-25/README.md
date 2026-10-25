# The `-c` path after checking, main against PR #418 (#129), 2026-10-25

The 9700X's measurements for Buster PR [#418](https://github.com/buster14a/buster/pull/418)'s review: what the PR's
changes cost on the work `-c` does after checking, paired with main. The PR selects every block-scope static of an
emitted body and names the local symbols it makes as clang names them (`function.name`, `.compoundliteral`, made unique
with `.N` against every name of the unit). Its own benchmark, `benchmark-lowering-source`, measures what the selection
saves against lowering everything within one tree; it doesn't compare the PR with main, and main doesn't have it.
Cited by `docs/c-lowering.md` ("What the selection saves").

## Sources and inputs

| Tree | Buster commit | Files | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `main` | `5863eeda331dacaa1371e1fe9ca1456e9d0039ca` (the PR's base) | 450 | `39bce7bfa4dbb461fb0f250a65fce484f6ab40219b4f5e181de5819cb66d90a2` |
| `pr` | `56243f75fedb3539d1d2cd94129aa666eb44f3b3` (the PR's head under review) | 452 | `84e36acbf740c9315c123c018c1792b0163c07d183307eda130f2c66fccbbc07` |
| `fast` | `pr` with `src/buster/compiler/c_check_program_emit.c` of `a1d69701` (the review's fix) | 452 | `dd6ed79c8e2d1a4ead223b9cb8b38d964eb4ca4a50c69ad1c224ca2430f41bbd` |

Each tree is `git archive` of its commit with one harness added: `scripts/emit_ab.c` as
`src/buster/compiler/emit_ab.c`, and `scripts/main-c-registration.patch` applied to `main.c`, which includes it and
adds its command, `benchmark-emit-ab`. Each `source-*.sha256` lists the SHA-256 of every file of the tree so made (the
manifest's own SHA-256 is in the table), and the host's trees, apart from `build/`, match them. `fast`'s
`c_check_program_emit.c` is byte for byte `a1d69701`'s (`4b1ca7e198d2b910453e02dfc196270429c44d47afcce1ae54634384827355cd`).

The harness is the PR's `benchmark-lowering-source` reduced to the driver's selection, through
`check_program_select`, whose signature both trees share. Each program is checked as the driver checks it, outside the
time; then each of 21 passes times the selection, `check_program_emit` (lowering, Tier 0, branch sizing, encoding and
the link's code), the static data's publication and `object_build`, with the arenas put back after each run. Every timed
run must lower its warm-up's counts and object bytes. It prints each file's median and its counts, then the sum of the
medians over the files it lowers.

The input is c-testsuite's `tests/single-exec/*.c` at commit `5c7275656d751de0e68b2d340a95b5681858ed07` (Buster's
`tests/c-testsuite/subset.txt` commit): 220 programs, of which the checker accepts and both trees lower 219.

Host: AMD Ryzen 7 9700X, clang 23.1.1. Each tree was built there by Buster's `./build.sh` with
`BUSTER_DEBUG_INFO=0`. `scripts/queue418.sh` ran five rounds of `main` and `pr`, and `scripts/queue418b.sh` queued six
rounds of all three, of which four ran before it was stopped; each round's order rotates. Every run took the shared lock on its own through
`~/buster-fast-bench/exclusive.sh` and was pinned to CPU 2 (`taskset -c 2`), 20 s apart. The lock's waiting messages,
which name other sessions' runs, are removed from `logs/`; nothing else in them is changed.

## Results

The sums of each run's 219 per-program medians, in nanoseconds (`logs/round-*.txt`, `logs/b-round-*.txt`; the totals
lines are also in `logs/log.txt` and `logs/log-b.txt`). The first queue ran five rounds of `main` and `pr`; the second
ran four of the three trees, and was stopped before its fifth (`logs/log-b.txt` says so), its rounds being consistent.

| Series | Tree | Rounds | Range | Median | Against `main`'s median |
| --- | --- | ---: | ---: | ---: | ---: |
| first | `main` | 5 | 1,648,786 to 1,651,709 | 1,649,682 | |
| first | `pr` | 5 | 1,729,287 to 1,745,512 | 1,729,554 | +4.84% |
| second | `main` | 4 | 1,650,669 to 1,658,625 | 1,653,603 | |
| second | `pr` | 4 | 1,726,283 to 1,734,089 | 1,727,918 | +4.49% |
| second | `fast` | 4 | 1,669,625 to 1,681,842 | 1,673,043 | +1.18% |

Round by round in the second series, `pr` took 4.08 to 5.05% longer than `main`'s run of the same round, and `fast`
0.81 to 1.89%. 218 of the 219 programs lower the same functions and objects in all three trees; c-testsuite's 00208
lowers two objects more in `pr` and `fast` (its block-scope static, which nothing reads and clang emits), by design.
Over those 218, the medians are 1,639,030 (`main`), 1,712,158 (`pr`, +4.46%) and 1,657,679 (`fast`, +1.14%). `pr` and
`fast` write the same object bytes for every program.

The PR's emitter built, in every unit, a table of every symbol's name and added the source's names to it in a pass of
their own, so that no name it makes is one of them; most units make none. `fast`, which builds the table only in a
unit that makes a name, takes back about three quarters of the difference. The rest, about 1.1%, is in the PR's other
changes on this path, which these runs don't tell apart: its selection's edges from a body to its block-scope statics,
and the scan for a made name.

## Limitations

c-testsuite's programs are small: a program's `-c` path after checking takes 1.7 to 135 µs, 3.3 µs at the median, so
a fixed cost per unit weighs more here than in a large unit. These runs measure that path alone, not checking or the whole driver.
