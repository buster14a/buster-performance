# The units' memory budget and huge pages on VMs (#1109), 2026-11-02

Evidence for [buster#1109](https://github.com/buster14a/buster/issues/1109): the C driver's units held to a memory
budget (each unit's estimated peak from its preprocessed tokens), and transparent huge pages off on a virtual machine.
The design summary is in buster's `docs/translation-units.md` ("The units' memory", "Huge pages on a virtual machine").

## Sources

Each run below measures one named buster revision, on branch `claude/problem-1109-cbe654` (buster#1165) or main, and
no number here is of any other. The branch's commits, in order, and what each changed:

- `3ce71ec312efb45fbcab4d66775e069e30d7e513`: main when the branch started; run 2's base.
- `282c4494c0641355355ab624487a4e48edf8e4ce`: the change's first code: the budget, its reader and the page policy on
  virtual machines. Runs 1 to 3 measure it.
- `f680fd32`, `823b9b75`, `e60f30f5`: tests and documentation only. `cd25240d`: `c_check_clock.c` includes
  `<sys/prctl.h>` itself, which the standalone `tests/peak-rss.c` build needed, and changes nothing else. Merges of
  main: `871bcd86`, `f86b58f9` (which resolved #1137's conflict in the driver's options), `2851c34f`.
- `a5f0fbc232fa75997e43c60e5d63abac5fdddac5`: a lane gives its memory back before it helps on the board, the fix for a
  deadlock a review found (`c_checker_units.c`). Run 4 measures it, with the merges above.
- `f1561074`, `ed6a1108`, `8c20ad59`: tests and documentation only. Merges of main: `0c5d8eaf`, `077c5b57`,
  `eaf0df1f`, `e3c826a0`, `ea03e1f8` (which joined main's release of a lane's memory before it helps, buster#1186, with
  the budget in `c_checker_units.c`), `cb901dab`, whose main parent is `a4a2182ad770bd22f25f843b934ba690bac9b1c8`.
- `08cf75ceeb6e326bbe689a322f8ac64794794d40`: the budget counts the lanes still taking units itself, so that without
  the board only the last lane keeps its pages; a cgroup limit whose `memory.current` can't be read leaves no memory
  (`c_checker_units.c`). Run 5 measures it, buster#1165's head then, against its main parent `a4a2182a`. The branch
  merged main again after it (`fc2506bc`), which no run here measures.

Each 9700X tree was `git archive` of its commit, with a `COMMIT` file, built by `./build.sh` (build.sh's defaults:
`-march=native`, `-O3`) under the host lock; `9700x/build-*.log` and `9700x/environment-head.txt` have build.sh's own
lines and the binaries' sha256.

## Machines

- `9700x/environment-9700x.txt`: Ryzen 7 9700X, Linux 6.18.50, clang 23.1.1, 64 GB, transparent huge pages `always`
  (defrag `madvise`), CPU 2 at governor and EPP `performance`, no hypervisor flag; the binaries' and inputs' sha256.
  `9700x/environment-head.txt` is the same host for run 5, on 2026-11-03.
- `laptop/laptop-environment.txt`: the owner's laptop (Ryzen 9 7940HS, Zen 4), Linux 7.3.1, clang 23.1.4, THP
  `always`, no hypervisor flag. Its binary (sha256 `964ad291...`) is a build of 282c4494 whose working tree also had a
  comment-only change in `c_check_units_test.c` (the status lines in the file).

## Runs

Every 9700X build and timed run was started through the host's lock (`exclusive.sh`), each its own hold, as the queue
scripts show, and timed inside it. Run 5's scripts also append the lock's owner line, which `exclusive.sh` writes as a
run takes the lock, to `9700x/units2-holds.txt`, `9700x/units3-holds.txt` and `9700x/link2-holds.txt`; runs 2 to 4
kept no such receipt, so their holds rest on the scripts. The inputs are `sqlite3.c` and Lua 5.4.8's `src/*.c` (sha256
in the environment file).
"build.sh's flags" below are its language flags, `laptop/flags-buster.txt` (`-march=native -Isrc -fwrapv
-funsigned-char -fno-strict-aliasing -fno-stack-protector -Wno-unused-function -Wno-psabi`), without its `-g`, `-O3`,
warnings and defines.

1. **Calibration** (`scripts/calibrate.sh`, laptop): for each file, its tokens (the first line of `benchmark-parser
   --passes 1 --only stages`) and the peak resident set that `--time-stages --lanes 1 -c` adds to the process's
   (`peak-rss-kb` less `peak-rss-start-kb`). `laptop/calibration-buster.tsv` holds build.sh's 41 sources with
   `laptop/flags-buster.txt`; `laptop/calibration-corpora.tsv` (37 rows) an empty file, one of 45 headers, `sqlite3.c`
   and Lua's 34 files with `-O0`. Columns: file, status, tokens, peak KB, start KB, `--time-stages` total ms. Memory is
   what these measure; the times ran on a shared machine and are not comparable.
2. **The 41 sources at once** (`scripts/units-queue.sh`, `scripts/units-run.sh`, 9700X): build.sh's sources in one
   `--time-stages -c` command of each tree's compiler (default lanes: 8), in a fresh directory, two interleaved rounds
   of main by default, the head by default, and the head with `--units-memory=12884901888` (12 GiB) and
   `=6442450944` (6 GiB). `9700x/units1.tsv` columns: run, status, wall ms, peak RSS KB, lanes, objects written, the
   `units memory:` report, error lines.
3. **Huge pages vs base pages** (`scripts/thp-round.sh`, 9700X, CPU 2, `--lanes 1`): interleaved pairs of
   `BUSTER_HUGE_PAGES=1` (as the system has them) and `=0` (off): `lvm.c -c` (10 pairs), `sqlite3.c -c` (6),
   `main.c -fsyntax-only` with build.sh's flags (3), in one hold of the lock. `9700x/thp2.tsv` is the head tree
   (282c4494); `9700x/thp1.tsv` an earlier round on the working tree before that commit (`BUSTER_CHECK_UNITS_UNIT_BYTES`
   64 MB, which single-file commands don't read). Columns: unit, setting, status, wall ms, `--time-stages` total ms,
   system ms, peak RSS KB, the reported `huge-pages` setting.
4. **The 42 sources linked into one executable** (`scripts/link-queue.sh`, `scripts/units-link.sh`, 9700X): buster
   `a5f0fbc232fa75997e43c60e5d63abac5fdddac5` (Sources; its build.sh has 42 sources), built under the lock
   (`9700x/build-a5f0fbc2.log`, with the binary's sha256); then two rounds of #1109's own command, `-o selfhost ... -lm
   -lpthread` with build.sh's flags, by default and with `--units-memory=12884901888`, and `-c` with that budget.
   `9700x/link1.tsv` columns: run, status, wall ms, peak RSS KB, lanes, the self-hosted compiler's `--version` status
   (0: it runs; `-c` runs give the objects' count instead), the `units memory:` report, error lines.
5. **Buster#1165's head against its main parent** (`scripts/head-queue.sh`, `scripts/units-run.sh`,
   `scripts/units-link.sh`, 9700X): `08cf75ce` and `a4a2182a`, each built under the lock (`9700x/environment-head.txt`:
   the host, build.sh's lines and the binaries' sha256); then two interleaved rounds of runs 2's and 4's commands with
   build.sh's 42 sources: `-c` by main and by the head by default, and by the head with 12 GiB and 6 GiB; linked by main
   and by the head by default, and by the head with 12 GiB. `9700x/units2.tsv` and `9700x/link2.tsv` have runs 2's and
   4's columns. Main's two default `-c` runs differed by more than the head's difference from main, so
   `scripts/extra-queue.sh` then ran three more interleaved rounds of main and the head by default (`9700x/units3.tsv`,
   its receipts in `9700x/units3-holds.txt`). `units-run.sh` and `units-link.sh` are run 5's versions: runs 2 and 4 ran
   them without the receipt line.

## Results

Calibration: 78 units, all status 0; units of 300,000 tokens or more took 446 to 644 bytes a token (`main.c` 534,
`sqlite3.c` 460), and the estimate (600 bytes a token and 48 MB) is 1.02 to 1.46 times their peaks and 1.17 to 2.85
times the smaller units'.

The 41 sources at once (9700X):

| run | wall | peak | units that waited |
|---|---|---|---|
| main `3ce71ec3` | 8.89, 8.69 s | 27.8, 27.9 GiB | |
| head `282c4494`, default budget | 8.66, 8.65 s | 27.8, 28.0 GiB | 0 |
| head, `--units-memory` 12 GiB | 10.73, 10.77 s | 10.8, 10.9 GiB | 9 |
| head, `--units-memory` 6 GiB | 22.11, 22.15 s | 5.6, 5.6 GiB | 21 |

Huge pages vs base pages (9700X, head, medians):

| unit | huge pages | base pages | peak, huge | peak, base |
|---|---|---|---|---|
| `lvm.c`, `-c` (10 runs each) | 12.64 ms | 12.78 ms | 82 MB | 36 MB |
| `sqlite3.c`, `-c` (6) | 117.38 ms | 144.59 ms | 315 MB | 248 MB |
| `main.c`, `-fsyntax-only` (3) | 1,709.89 ms | 2,106.25 ms | 3,484 MB | 3,251 MB |

The 42 sources linked (9700X, `a5f0fbc2`; the self-hosted compiler ran `--version` in every link run):

| run | wall | peak | units that waited |
|---|---|---|---|
| linked, default budget | 9.35, 8.63 s | 27.7, 28.1 GiB | 0 |
| linked, `--units-memory` 12 GiB | 10.97, 10.93 s | 10.99, 10.98 GiB | 9, 9 |
| `-c`, `--units-memory` 12 GiB | 10.87, 10.76 s | 10.86, 10.92 GiB | 9, 9 |

The links the lanes keep add 60 to 130 MB to the budgeted peak, inside the eighth the budget leaves.

Buster#1165's head `08cf75ce` against its main parent `a4a2182a`, the 42 sources at once with `-c` (9700X; five
interleaved rounds by default, `9700x/units2.tsv` then `9700x/units3.tsv`, and two with a budget):

| run | wall | peak | units that waited |
|---|---|---|---|
| main `a4a2182a` | 9.22, 6.55, 6.62, 6.56, 6.58 s; median 6.58 | 24.6 to 25.4 GiB; median 25.3 | |
| head `08cf75ce`, default budget | 7.00, 6.72, 6.58, 6.53, 6.57 s; median 6.58 | 25.1 to 25.5 GiB; median 25.4 | 0 |
| head, `--units-memory` 12 GiB | 10.95, 10.97 s | 7.7, 7.6 GiB | 9, 9 |
| head, `--units-memory` 6 GiB | 17.63, 17.66 s | 4.9, 4.9 GiB | 26, 24 |

Each revision's first run is the slowest of its five (main 9.22 s, the first timed run after the builds; the head
7.00 s); rounds 2 to 5 of both lie between 6.53 and 6.72 s. Each budgeted run reported that one lane kept its pages
for the exit, as a command without a link does.

The link failed at both revisions (`9700x/link2.tsv`, status 1): `undefined reference to '__bss_start'`, for main as for
the head. Since buster's `3f8e6032` (#652), `lane.c` reads `__bss_start`, which buster's linker defines only for static
executables. So the link runs measure the units up to that error: main 7.00 and 6.69 s, 25.4 and 25.5 GiB; the head
6.68 and 6.58 s, 25.5 and 25.5 GiB; the head with 12 GiB 10.97 and 10.95 s, 8.0 and 7.7 GiB, 9 units waiting in each,
and no lane keeping its pages, since a command with a link releases every lane's.

## Limitations

- No VM was measured here: the VM side is #1109's own A/B (a 4-core cloud VM, `PR_SET_THP_DISABLE` before `exec`),
  which the policy reproduces. The 9700X shows only what the policy leaves alone on bare metal.
- The budget runs set `--units-memory` to model a smaller machine on the 64 GB 9700X; the default budget there
  (seven eighths of `MemAvailable`, about 49 GB at the time) made nothing wait.
- Peaks are the process's VmHWM at `--time-stages`' marks, rounded up by huge pages where they were on.
- Run 3 always ran huge pages before base pages within a pair, with 10, 6 and 3 pairs and no uncertainty estimate; the
  medians are a direction, not a bound.
- The link runs check the self-hosted compiler only by its `--version`, not by a test suite.
- Each run measures its own revision (Sources); a later revision's behavior and cost are its own to measure.
