# The units' memory budget and huge pages on VMs (#1109), 2026-11-02

Evidence for [buster#1109](https://github.com/buster14a/buster/issues/1109): the C driver's units held to a memory
budget (each unit's estimated peak from its preprocessed tokens), and transparent huge pages off on a virtual machine.
The design summary is in buster's `docs/translation-units.md` ("The units' memory", "Huge pages on a virtual machine").

## Sources

- Base: buster `3ce71ec312efb45fbcab4d66775e069e30d7e513` (main at the time).
- Head: buster `282c4494c0641355355ab624487a4e48edf8e4ce` on branch `claude/problem-1109-cbe654`, the change's code.
  The branch's later commits change tests and documentation only.
- Each 9700X tree was `git archive` of its commit, with a `COMMIT` file, built by `./build.sh` (build.sh's defaults:
  `-march=native`, `-O3`) under the host lock; `9700x/build-*.log` are build.sh's own lines.

## Machines

- `9700x/environment-9700x.txt`: Ryzen 7 9700X, Linux 6.18.50, clang 23.1.1, 64 GB, transparent huge pages `always`
  (defrag `madvise`), CPU 2 at governor and EPP `performance`, no hypervisor flag; the binaries' and inputs' sha256.
- `laptop/laptop-environment.txt`: the owner's laptop (Ryzen 9 7940HS, Zen 4), Linux 7.3.1, clang 23.1.4, THP
  `always`, no hypervisor flag. Its binary (sha256 `964ad291...`) is a build of 282c4494 whose working tree also had a
  comment-only change in `c_check_units_test.c` (the status lines in the file).

## Runs

Every 9700X run held the host's lock (`exclusive.sh`) for itself alone; times were taken inside the hold. The inputs are
`sqlite3.c` and Lua 5.4.8's `src/*.c` (sha256 in the environment file).

1. **Calibration** (`scripts/calibrate.sh`, laptop): for each file, its tokens (the first line of `benchmark-parser
   --passes 1 --only stages`) and the peak resident set that `--time-stages --lanes 1 -c` adds to the process's
   (`peak-rss-kb` less `peak-rss-start-kb`). `laptop/calibration-buster.tsv` holds build.sh's 41 sources with
   `laptop/flags-buster.txt`; `laptop/calibration-corpora.tsv` an empty file, one of 45 headers, `sqlite3.c` and Lua's
   33 files with `-O0`. Columns: file, status, tokens, peak KB, start KB, `--time-stages` total ms. Memory is what these
   measure; the times ran on a shared machine and are not comparable.
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

## Limitations

- No VM was measured here: the VM side is #1109's own A/B (a 4-core cloud VM, `PR_SET_THP_DISABLE` before `exec`),
  which the policy reproduces. The 9700X shows only what the policy leaves alone on bare metal.
- The budget runs set `--units-memory` to model a smaller machine on the 64 GB 9700X; the default budget there
  (seven eighths of `MemAvailable`, about 49 GB at the time) made nothing wait.
- Peaks are the process's VmHWM at `--time-stages`' marks, rounded up by huge pages where they were on.
