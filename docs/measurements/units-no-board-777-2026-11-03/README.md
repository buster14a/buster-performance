# The units' lanes counted without the board, buster#777, 2026-11-03

This record measures the fix of the no-board path in buster's units driver, branch `claude/777-no-board`, commit
`70f0e5e3`, against its base, main `a4a2182a`. The measurements are on the Ryzen 7 9700X.

#1186's release, merged into main as `7e11a875`, read how many lanes still take units from the lanes' board alone. It
read 0 without a board. On several lanes the board's allocation may fail, and then every lane took itself for the
last: in a command without a link, each left its memory to the exit. #1165's reviews at `ea03e1f8` found this. The fix
makes the run count those lanes itself, with or without the board. It also adds a test hook,
`BUSTER_TEST_NO_UNITS_BOARD`, that stands for the board's allocation failing, and adds the count of lanes that left
their memory to the exit to `--shared-parts`' report.

This record checks two things on the 9700X:
- the change costs nothing on the path it touches, a few large units by one command;
- `test-check-units` passes at the head.

## Sources and trees

| tree | commit | `build/compiler` SHA-256 |
| --- | --- | --- |
| main | `a4a2182ad770bd22f25f843b934ba690bac9b1c8` | `2cc553a7f7adc73569d1d0901e0d3d744176181822ba8f47fd36778f256fc14a` |
| head | `70f0e5e3fc74682dcbb746928a30324ffab06e06` | `b7ed6362a8f56beb77a5f0089924ea0db54d4ff67429b8dc26e23f5c7be30042` |

Each tree is `git archive` of its commit, sent to the host by `tar`. `receipts/manifest-tree-*.txt` is each tree's
`sha256sum` on the host. `receipts/manifests-checked.txt` records that every file's hash matches `git archive` of the
commit: 1,109 files per tree, without `build/` and the `COMMIT` file that names the commit. `./build.sh` built both
trees with `BUSTER_DEBUG_INFO=0` and the default `BUSTER_HOST_ARCH=native`, under the host's lock. The build lines
are in `logs/noboard.log`.

## Host and inputs

- **Host:** AMD Ryzen 7 9700X (`benchpress`), Linux 6.18.50-2-lts, clang 23.1.1, GCC 16.2.1 (`cc`), perf 7.2.9-1.
- **Governors:** CPU 2 runs the `performance` governor and EPP. CPUs 0, 1 and 3 to 7 run `powersave` with
  `balance_performance` (`receipts/host.txt`). Every run is on CPUs 0 to 7.
- **Inputs:** SQLite 3.53.4's amalgamation, `sqlite3.c` and `shell.c`, the same files as in
  `units-control-777-2026-11-02`.

## Method

`scripts/noboard.sh` ran `scripts/ab.sh noboard 21 tree-a4a2182a tree-70f0e5e3`, then the head's `test-check-units`.
Every build, the reference compiles, the `time-runs` run and the test each held the host's lock (`exclusive.sh`) for
itself.

`ab.sh` is the A/B script of `units-control-777-2026-11-02`, unchanged. It runs one `time-runs` of six lists, 21 runs
each after a warm-up, in an order that rotates by run:
1. main's one command with `-c`;
2. the head's one command with `-c`;
3. main's two processes at once with `-c`, each one's exit status checked;
4. main's one command, linked;
5. the head's one command, linked;
6. main's two processes, then `cc`'s link.

Every list removes its outputs before each run and requires them after it. Every run must exit 0: `logs/runs.log`
has 126 runs with status 0 and `time-runs: done, 0 failed processes`. Afterwards, every list's objects are compared
with main's objects of each unit alone (`cmp`), and each executable runs `select 6 * 7;`.

`exclusive.sh`'s messages while it waited name other jobs. `logs/` drops only those lines: the `exclusive.sh:
waiting` line and the `title:`, `link:` and `pull request:` lines after it, three or four per log (`grep -v -E
'^exclusive.sh: waiting|^  (title|link|pull request):'`). Each holder's command was on its one line.

## Results (`logs/runs.log`; medians, ms; peaks are `wait4`'s, KiB)

| | main | head | two processes by main | with `cc`'s link |
| --- | ---: | ---: | ---: | ---: |
| `-c` | 107.508 (382,452) | 107.712 (380,988) | 106.965 (344,228) | |
| linked | 112.217 (386,636) | 112.334 (385,180) | | 123.587 (344,300) |

- **Speed:** the head is 0.19% slower than main with `-c` and 0.10% slower linked. Earlier records of this
  comparison saw medians move by up to 0.6% between identical rounds.
- **Instructions:** they are the same to within 0.003%: 1,562,198,459 by main and 1,562,160,159 by the head with
  `-c`, and 1,576,360,106 and 1,576,324,302 linked.
- **Outputs:** every list's objects are the reference's, and every executable printed 42.
- **Against the processes:** in this round main's one command took 0.5% more than the two processes with `-c`, and
  the head's 0.7% more.
- **Tests:** the head's `test-check-units` passed 5,335 checks with 0 failures (`logs/noboard-units.log`). Its few
  large units checked that, with `-c` by 8 lanes, one lane alone leaves its memory to the exit with the board and
  without it, and that no lane does before a link.

The PR also has the laptop's mutant check (Zen 4, not this host). With #1186's line restored, `test-check-units
--programs 1` failed exactly one check: the run without the board.

## Limitations

- One round of 21 runs per list; the change is a counter decrement per lane and a `getenv` per command, and the
  instruction counts are the same.
- The board's allocation failing is simulated by the test hook. Its effect on memory, every lane's pages kept until
  the exit, is shown by the report's count, not by a peak measured under a failed allocation.
- The comparison of the one command with the processes is from this round only. `units-control-777-2026-11-02`
  has two rounds of 31 runs for that.
