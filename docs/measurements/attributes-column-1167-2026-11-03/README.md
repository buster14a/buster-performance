# The reader's attributes as a wide sparse column, and its declaration bits (buster#1167), 2026-11-03

Buster's branch `claude/solve-628-529-1167` makes `CheckInput.attributes`, a pointer a token, a wide column of the
reader's sparse pool (`src/buster/compiler/c_check_sparse.c`'s `CheckSparseWide`), and turns its four whole-column
scans into scans of its directory; then it packs seven of the reader's byte columns into one byte a token
(`CheckInput.declaration_bits`). This record holds the 9700X measurements of `-c` of the frozen `sqlite3.c`, main
against the change, main's profile, and a map of what `-c` holds at its peak (on the laptop), from which the change and
#628's next steps were chosen.

## Sources

| tree | Buster commit | what |
| --- | --- | --- |
| `main-b70deb47` | [`b70deb476d3a16463f398d0214853680b920d350`](https://github.com/buster14a/buster/tree/b70deb476d3a16463f398d0214853680b920d350) | main when the work started |
| `head-ebd8cf4e` | [`ebd8cf4ed0a79694c15e60298fd89c757c465072`](https://github.com/buster14a/buster/tree/ebd8cf4ed0a79694c15e60298fd89c757c465072) | the attributes' change on `b70deb47` (round 4) |
| `main-703ae9f5` | [`703ae9f581b00c2cbb4061e907d0951b11ea9637`](https://github.com/buster14a/buster/tree/703ae9f581b00c2cbb4061e907d0951b11ea9637) | main when the branch was last merged with it |
| `head-49f066ba` | [`49f066baf6763825d05e7a9b153e1410e61abaef`](https://github.com/buster14a/buster/tree/49f066baf6763825d05e7a9b153e1410e61abaef) | the branch, both changes, merged with `703ae9f5` (round 5) |

Each tree is `git archive` of its commit, with a `COMMIT` file, built by its own `./build.sh` (Clang 23.1.1,
`-march=native`, which is znver5 there, with debug info). The branch's next commit, `94c8167b`, changes the wide
group's two masked loads to their unaligned form, which the baseline host's intrinsics have; the measured executable
has the aligned form, on addresses that are aligned either way.

`receipts.txt` (round 4's) and `round5/receipts.txt` have the host (`uname`), the CPU, CPU 2's governor and EPP, clang's and perf's versions, both executables'
SHA-256 and the input's. The input is the frozen corpus's `sqlite3.c`, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the `compile_time` step's options:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c
```

## Method

On the Ryzen 7 9700X (`benchpress`), pinned to CPU 2, under the host's lock (`exclusive.sh`), one hold per script
(`scripts/`, run by `round4.sh` and `round5.sh`):

- `build.sh TREE`: the tree's `./build.sh`.
- `objects.sh BASE HEAD OUT`: `-c` by each tree, by default, `--scalar`, `--lanes 8` (unpinned) and `-g`, each object
  compared with `cmp`, and the default's `--time-stages` (`round4/*.stages`).
- `ab.sh A B OUT`: 8 rounds, the order alternating by round, of a warm-up and `perf stat -r 3` of each, events
  `task-clock,cycles:u,instructions:u,cycles:k,instructions:k,page-faults` (`round4/stat-A-N.csv`, `stat-B-N.csv`),
  every object compared with A's first (`ab-inner.sh`); then `measure-compile --runs 11` by each with the other as its
  reference (`round4/measure-A.txt`, `measure-B.txt`).
- `prof.sh TREE`: main's profile, `perf stat -r 5` and `perf record -F 20000` of 5 compiles (`profile-main/`).

`round4/summary.txt` and `round5/summary.txt` keep the scripts' own output lines; the host lock's messages, which name other sessions'
commands, are left out.

The peak map (`peak-map/`) ran on the laptop (Ryzen 9 7940HS, Linux 7.3), on main `b70deb47` with
`scripts/peak-map.patch`, pinned to one CPU, so on one lane:
- every arena push of 32 KiB or more is logged with its call stack (`backtrace`);
- `peak_dump` reads `/proc/self/status`, the mappings' `Rss` and `AnonHugePages` from `/proc/self/smaps`, and, for
  each logged push, its present pages from `/proc/self/pagemap`, a page going to the latest push that covers it;
- `BUSTER_PEAK_MAP=FILE` writes a dump at the reader's end, and each stage mark's `VmRSS` and `VmHWM`;
  `BUSTER_PEAK_FULL=N` a full dump at stage mark N as well (7 is `check-declarations`' end);
- the reader's end also counts each of the reader's rare columns' entries;
- `BUSTER_RARE_BASE=1` puts the rare columns' arena in base pages, the probe in `rare-pages-probe.txt`.

`scripts/peak-sites.py` ranks a dump's pushes by their present KiB (`reader-end-sites.txt`,
`check-declarations-sites.txt`). A push's present pages are what its range maps, which counts a page that only a read
mapped (the zero page) too; the mappings' `Rss` lines are the kernel's own account.

## Results

`round4/`, `main-b70deb47` (A) against `head-ebd8cf4e` (B), medians of the 8 rounds and of `measure-compile`'s 11 runs:

| measure | main | wide `attributes` |
| --- | ---: | ---: |
| task clock | 114.255 ms | 113.300 ms |
| user cycles | 545.99 M | 541.28 M |
| user instructions | 1,276.40 M | 1,275.76 M |
| kernel cycles | 87.29 M | 87.17 M |
| page faults | 4,970 | 4,969 |
| peak RSS (`measure-compile`'s `wait4`) | 291,208 KiB | 287,104 KiB |
| `check-input` (`measure-compile`'s stages) | 45.731 ms | 44.957 ms |

Every round has B 0.64 to 1.42 ms faster. Every object is the same bytes, by all four variants.

`round5/`, `main-703ae9f5` (A) against `head-49f066ba` (B), the whole branch, the same way:

| measure | main | both changes |
| --- | ---: | ---: |
| task clock | 111.590 ms | 109.250 ms |
| user cycles | 530.39 M | 520.66 M |
| user instructions | 1,204.84 M | 1,204.06 M |
| kernel cycles | 88.03 M | 85.50 M |
| page faults | 4,973 | 4,970 |
| peak RSS (`measure-compile`'s `wait4`) | 295,172 KiB | 287,028 KiB |
| `check-input` (`measure-compile`'s stages) | 44.374 ms | 43.145 ms |

Every round has B 1.76 to 2.80 ms faster, and every object is the same bytes, by all four variants. Main's peak rose from
`b70deb47`'s 291,208 KiB to `703ae9f5`'s 295,172 KiB, by main's own changes between them.

`profile-main/symbol.txt`: `clear_page_erms` 11.95% of `-c`'s samples, `check_input_run` 7.22% (most of it the
expressions' coded walk, `c_check_expression_input.c`, inlined), `check_input_resolve_range` 4.74%,
`check_input_asm_labels` 0.81%.

The peak map on main (`peak-map/stages.txt`, KiB): `VmRSS` is 290,920 at the reader's end and 260,540 once its arena of
rare columns is released; `check-expressions` takes it to 295,468, and `check-declarations`' end sets the peak, 297,580.
There (`check-declarations-sites.txt`), `attributes` holds 5,596 KiB, and each of eleven of the twelve byte columns
700. The reader's rare columns (`rare-columns.txt`) hold almost nothing at its end, six of the sixteen no entry and
`warning_suppressed` the most, 3,637, but their writes take about 30 MB of huge pages, which the release gives back
before the peak. In base pages (`rare-pages-probe.txt`) `check-input` takes 9,978 faults rather than 3,179.

## Limitations

- One build of each tree: one code placement, without a `time-runs` sweep. The 4.7 M fewer user cycles are about
  `check_input_asm_labels`' 0.81% of main's, whose scan of the column goes with the other three, but a placement can
  move `sqlite3.c`'s `-c` by as much.
- `measure-compile`'s user and system split comes from `getrusage` deltas, which it marks as low-confidence.
- The peak map is the laptop's, on main, with logging that adds a call and, for large pushes, a `backtrace`; its huge
  pages' alignment differs from the 9700X's, where the change's peak is 4.1 MB lower rather than the laptop's 5.5 MB.
