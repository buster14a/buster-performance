# Tier 0's vector class after #556's reviews: what it costs code without vectors, 2026-10-27

Branch `claude/tier0-vectors-136` (buster14a/buster, #556) adds Tier 0's VECTOR class and X86 kind (#136).
[The first record](../tier0-vectors-136-2026-10-27/README.md) measured the first version (`d150b4d7`). This one measures
the branch after its two review rounds, with main's `ad408cf2` merged, on the same inputs: Tier 0's own benchmark on
generated programs and `-c` of the frozen `sqlite3.c`, in two runs:

- `efd034cd/`, the first review's fix (`5f3359a4`) with main merged, ran 5.08 million more instructions on `-c`
  than main (+0.23%), the same in every round. The lowering validates every function it lowers
  (`tier0_validate_inline`), and the fix had put a vector test on each of the validator's operand pops, beside the
  branch's test per entry that sends a vector's entry on. `-fsyntax-only` and Tier 0's own work
  (`benchmark-backend-source` on `sqlite3.c`, locally) didn't change, and code shifts of main's build left its count
  unchanged within 100, which ruled out placement.
- `599d0cca/`, the head: only a CONVERT and a compare test for a vector's operand, and the test of an unknown kind or
  class sends a vector's entry on (X86 and VECTOR are the last kind and class), so other entries run no test of their
  own for vectors. Measured once as the first record measured, then over code placements.

| Measure | main (`ad408cf2`) | `efd034cd` | head (`599d0cca`) |
| --- | --- | --- | --- |
| `-c` of `sqlite3.c`, user instructions (`perf stat`) | 2,192,136,597 | 2,197,208,815 (+0.232%) | 2,191,936,053 (-0.009%) |
| `-c`, user cycles, one executable per tree | 891.3 M | 884.0 M (-0.75%) | 900.5 M (+1.03%) |
| `-c`, user cycles over six placements, three rounds | 881.9, 882.5, 882.4 M | | -0.09%, -0.02%, -0.01% against main |
| `-c`, wall over six placements, three rounds | 186.7, 186.6, 186.8 ms | | -0.06%, +0.12%, -0.03% against main |
| main's executables again, cycles over placements | | | +0.23%, -0.08%, +0.04% against main |
| `benchmark-backend`, vector path | 14.63 ns/entry, 170.90 instructions | 14.56 ns/entry, 170.97 | 14.49 ns/entry, 170.97 (-0.96%) |
| `benchmark-backend`, scalar path | 42.45 ns/entry, 573.79 instructions | 41.77 ns/entry, 571.88 | 43.07 ns/entry, 571.88 (+1.46%) |

The main column is `599d0cca`'s run's (its base was `efd034cd`'s run's build, hard links of its directory);
`efd034cd`'s run measured main at 2,192,131,464 instructions and 890.6 M cycles, and the `efd034cd` column's changes
are against those.

Both runs' `-c` wrote main's object byte for byte (`inputs.sha256`: `lower_base.o` and `lower_head.o`), and on the
9700X the head passes `test-tier0` (216,461 checks, 0 failed) and `test-tier0 --cross-check` (234,705).

**The placements.** One executable per tree put the head's `-c` at +1.03% cycles with fewer instructions. Over six
placements of the checker's unit and what follows it, with three copies each, the head is main's within 0.1% in each
round, as close as main's own executables run against themselves (`ab_placements.log`). The head's spread over its
placements is 1.8% to 2.2% where main's is 0.5% to 0.8%: its unshifted executable (shift 0, the one the single-
executable comparison timed) runs 895 to 898 M cycles in every round, and its other five placements 878 to 885 M.

## Trees

| Name | Commit | What it is |
| --- | --- | --- |
| `base` | [`ad408cf2`](https://github.com/buster14a/buster/tree/ad408cf2) | main, the merge-base of both heads |
| `efd034cd` | [`efd034cd`](https://github.com/buster14a/buster/tree/efd034cd) | the first review's fix (`5f3359a4`) with main merged |
| `head` | [`599d0cca`](https://github.com/buster14a/buster/tree/599d0cca) | both reviews' fixes and the validator's cost removed |

Each tree was `git archive` of its commit, sent by tar into an empty directory; each run's `source-base.sha256` and
`source-head.sha256` hold the SHA-256 of each of its files, and its `inputs.sha256` the executables', the objects', the
inputs' and the host's kernel and clang. Each was built with `BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh`, the
placements' copies with `./build.sh shifts` (`shifts_*.log`; `shifts.sha256`: twelve executables, all different).

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2 at the performance governor. Each build and each run
took the shared lock on its own (`EXCLUSIVE_OWNER=claude-126`); the lock's waiting messages, which name other sessions'
runs, are removed from the logs, which leaves those of runs that printed nothing (`lower_*.log`) empty.

## Method

Each run's `abV.sh` ran it (`abV.log`), with the first record's inputs and options: the preprocessor oracle's frozen
`sqlite/sqlite3.c` with the pinned gnu17 predefines, `-march=znver5 -std=gnu17 -nostdinc` and the corpus's system
directories, without `--clang-features`, `SOURCE_DATE_EPOCH=1792454400`, `CPATH`/`C_INCLUDE_PATH` unset:

- the head's `test-tier0` and `test-tier0 --cross-check`;
- each tree's `-c` once, whose objects compare equal;
- `build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh base head` of `benchmark-backend`
  (`ab_backend.log`) and of `time-runs --runs 11 --list -c -o /dev/null` (`ab_lower.log`);
- three rounds, each tree in turn, of `perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2` of `-c`
  (`perf.log`).

Then `599d0cca/placements.sh` (`placements.log`), as `docs/profiling.md`'s "Builds over their code's placements and
copies" has it: each tree's executable at shifts of 0, 688, 1376, 2064, 2752 and 3440 bytes of `main_unit_checker.c`'s
code and what follows it, and `ab --rounds 3 --cpu 2` of `time-runs --runs 3 --copies 3` over main's six, the head's six
and main's six again, the copies fresh in a directory of their own, each process's user cycles counted from its exec.

## Limits

One input, which has no vectors: this measures the branch's cost to code without vectors. Locally, Tier 0 on
`sqlite3.c`'s own functions (`benchmark-backend-source`) ran 153.64 and 153.75 instructions per entry on main and on
`efd034cd`, which isn't recorded here.
