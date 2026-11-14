# check-input's regrowth after #1671, and a rare column read in place (Buster #1489), 2026-11-13

- **Compiler issue:** [#1489](https://github.com/buster14a/buster/issues/1489), claim
  [6862667355](https://github.com/buster14a/buster/issues/1489#issuecomment-6862667355).
- **Workload:** tools/microarch's `sq-c` (`scripts/workloads.sh`): `-c --lanes 1` of the frozen corpus's
  `sqlite3.c` (`preprocessor-391e729af658`) with the CI's options, `--time-stages`, on CPU 2. The run root is
  `~/buster-fast-bench/1340-droid/root`'s corpus, the same as the earlier #1489 records'.
- **Host:** the Ryzen 7 9700X (`benchpress`), Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9-1, CPU 2's governor and
  EPP `performance`, THP `always` (`ab/*/host.txt`).

## What was measured

| label | revision | built |
| --- | --- | --- |
| `aca9e53a` | `aca9e53aa981bb3f61d21cdd5a408ce5167a06f8`, before #1049 | here, Release, `BUSTER_DEBUG_INFO=0` (`raw/builds/build-aca9e53a.log`) |
| `old-aca9e53a` | the same revision | #1340's record's executable (`1340-droid/root/bin/compiler-pre1049-znver5`) |
| `old-0eca996a` | `0eca996a660548aff827c8b1d08789c413d6eba1`, #1488's base, the issue's 58.87 ms | #1340's record's executable (`compiler-main-znver5`) |
| `829eb71a` | `829eb71a7caf3d7191ef34c91f321fc11814e046`, main after #1671's cuts (7 November) | here, as `aca9e53a` |
| `main` | `b7a95eedbe16fbd8434654f192f8f7aab76c56e5`, main when this record began (13 November) | here, as `aca9e53a` |
| `main-g`, `829eb71a-g` | `b7a95eed`, `829eb71a` | here, `BUSTER_DEBUG_INFO=1`, for the profiles |
| `local-SHA` | `829eb71a`, seven first-parent commits 81 apart (`scripts/points.txt`), `b7a95eed`, `32560e46` | a cloud VM, clang 23.1.6, Release, `BUSTER_DEBUG_INFO=0` (`scripts/timeline.sh`, `raw/builds/`) |
| `local-branch2`, `local-branch3` | `b7a95eed` with `raw/patches/branch2-on-b7a95eed.patch`, `branch3-on-b7a95eed.patch` | the VM, as `local-SHA` |
| `local-final` | `32560e460` with `raw/patches/final-code-on-32560e46.patch`, the pull request's code | the VM, as `local-SHA` |

The executables' SHA-256 are in `raw/identity/` (`compiler-local-branch1` was built but never measured). The VM's
builds of `829eb71a` and `b7a95eed` time as the host's builds of them do (43.58 against 43.64 ms; 46.24 against
46.17 ms), so they stand in for host builds in the timeline and the A/Bs.

## Method

- **The A/Bs** (`scripts/ab.sh NAME ROUNDS VARIANT...`): each compile, and each `perf stat` run after them, holds the
  lock on its own (`exclusive.sh`), in rounds whose order rotates. Each grant appends its holder line
  (`holds.txt`), `/proc/loadavg` and the eight busiest processes before and after its run (`procs.txt`), and its exit
  status (`status.txt`). `objects.txt` has every run's object SHA-256, `diagnostics.txt` each compile's diagnostics'
  (the `time-` lines removed), and `summary.tsv` the medians with their ranges. `lock.log` has `exclusive.sh`'s waits.
- **The profiles** (`scripts/prof.sh`, `scripts/prof2.sh`): `perf record` of one compile per grant, `cycles:u` or
  `instructions:u` at `-c 200003`, and `page-faults` at `-c 1`. `perf script -F ip,dso` gave the sample addresses
  (`prof/*/*.ips`). The VM mapped them to inlined frames against copies of the debug executables, with
  `llvm-symbolizer --inlining` (`scripts/attr.py`, `within.py`, `within2.py`, `callers.py`, `diff2.py`), since the
  host's perf files don't open in the VM's older perf. `p1`'s are function-level reports of the release builds.
- **The diagnostics** (`scripts/diag.sh`): `-fsyntax-only -Wall -Wextra` of `sqlite3.c` and of `self-main.i` (the
  compiler's own main.c as #1340's root has it), on the vector path and with `--scalar`, one grant each
  (`diag/d1/hashes.tsv`).
- **The suites** (`raw/local-checks/`), on the VM, with x86-64 builds (the scalar host path):
  `test-checker --seed 133` of the final code, and `test-checker-driver --in-process` of the final code and of
  `branch2`, against the VM's clang 23.1.6.

## Results

### The same rounds: where check-input stands (`ab/r1`, `ab/pre1`)

`ab/r1`, 5 rounds, medians in ms:

| | `aca9e53a` | `829eb71a` | `main` |
| --- | ---: | ---: | ---: |
| check-input | 45.159 (45.051–46.087) | 43.644 (43.436–44.066) | 46.170 (46.124–59.640) |
| check-expressions | 10.486 | 10.191 | 11.870 |
| check-program | 10.358 | 24.661 | 23.970 |
| total | 107.474 | 119.839 | 127.108 |

`ab/pre1`, 3 rounds: `old-aca9e53a` 45.392, `old-0eca996a` 59.386, `main` 46.718 ms. `main`'s and `aca9e53a`'s
diagnostics are the same bytes; `old-0eca996a`'s differ, as #1340's warnings then did.

### The timeline (`ab/t1`, `ab/t2`)

`ab/t1`, 3 rounds, check-input in ms, with the stage's minor faults:

| build | first-parent commits after `829eb71a` | check-input | faults |
| --- | ---: | ---: | ---: |
| `local-829eb71a7` | 0 | 43.577 | 4,171 |
| `local-f0668e15e` | 81 | 44.420 | 4,850 |
| `local-16978209f` | 162 | 47.210 (44.965–48.723) | 4,854 |
| `local-e8dabee36` | 243 | 44.810 | 4,855 |
| `local-b7a95eedb` | 649 | 46.241 | 4,882 |

`local-16978209f`'s round 1 ran while this session's own `tar` and `sha256sum` of the copied executables ran on CPU 0,
outside the lock (`procs.txt`); its range is void. `ab/t2`, the other four points, was stopped after 3 of its 18 runs
(45.352 ms at 9f6c125f, 45.023 ms at 66e34536, 43.739 ms at `829eb71a`), to leave the lock to the A/Bs.

### Where it grew (`prof/p1`, `prof/p2`, `prof/i1`)

`prof/i1`, `instructions:u` by inlined frame, two compiles each, per compile, in millions of instructions, `main-g`
against `829eb71a-g`:

| function, its inlined callees with it | `829eb71a` | `main` | change |
| --- | ---: | ---: | ---: |
| `check_input_declarator_step` | 28.7 | 35.7 | +7.0 |
| `check_input_declaration` | 21.5 | 29.0 | +7.5 |
| `check_input_binding_answers` | 15.7 | 21.1 | +5.4 |
| `check_input_specifiers` | 17.2 | 20.4 | +3.2 |
| `check_input_bind_checked` (`check_input_bind` before) | 4.7 | 4.9 + 2.0 | +2.2 |
| `check_input_discarded_set` (#2409) | — | 2.1 | +2.1 |

The declarator step's own code without a line (moves, constants and records' initialization) grew from 3.6 to 5.9 M,
the specifiers' from 2.2 to 3.8 M. The cycle profiles (`prof/p1`, four compiles each, `prof/p2`, three and two) agree
by function; their per-line differences are within their noise.

### The page faults (`prof/f1`)

`page-faults` at `-c 1`, one compile each: 7,167 faults in the compiler's code for `main-g`, 6,522 for `829eb71a-g`.
`check_input_bind_checked` has 679 of `main-g`'s, at `c_check_input.c:12901`, and the old build's `check_input_bind`
none. That line is #1453's `__private_extern__` test, `reader->declaration_storage[token] == C_NAME_PRIVATE_EXTERN`:
a plain load of a rare column at every declaration, which touched nearly all of its 4-byte-a-token base pages.

### The change (`ab/r4`, `ab/r3`, `ab/r2`)

`ab/r4`: `local-32560e460` (main) against `local-final`, 9 rounds and 5 of `perf stat`:

| | main | final | change |
| --- | ---: | ---: | ---: |
| check-input | 46.026 (45.718–46.299) | 45.723 (45.330–45.994) | -0.303 |
| its minor faults | 4,899–4,900 | 4,363–4,364 | -536 |
| total | 123.056 | 122.988 | -0.068 |
| cycles:u | 595.96 M | 597.03 M | +0.18% |
| instructions:u | 1,354.954 M | 1,355.294 M | +0.03% |
| task-clock | 122.72 ms | 122.57 ms | -0.15 |

All 28 runs' objects are one SHA-256 (`998cb038…`), and all 18 compiles' diagnostics one (`dc8fa1fe…`). The two
variants this record dropped, against `local-b7a95eedb`:

| | `ab/r2`: `branch2` | `ab/r3`: `branch3` |
| --- | --- | --- |
| what | the final read, the set-only marks for local declarations alone, the unused pass's four token columns as one of flag bits | the final read and the set-only marks for local declarations alone |
| check-input, 7 and 9 rounds | 46.454 → 46.173 | 45.947 → 45.827 |
| instructions:u | +0.22 M | +0.38 M |
| cycles:u | +0.45% | -0.03% |

`instructions:u` is exact between the sets of rounds, since main's count is the same in each: the final read alone
adds 0.34 M (`BUSTER_CHECK_RARE`'s mask at each declaration), the local test 0.04 M more (its sparse lookup costs what
the skipped reads save), and the packed column takes 0.16 M off. Neither measured faster in time or cycles, so the
pull request leaves both out. `r2`'s first main round (60.106 ms, 33,461 faults) took base pages throughout, with no other
process busy in its hold, while the page cache held 54 of the host's 64 GB.

### Correctness

- `diag/d1/hashes.tsv`: `main` and `branch2` give the same `-Wall -Wextra` diagnostics, on both paths, of `sqlite3.c`
  (25 lines, `-Wuninitialized`) and `self-main.i` (294 lines, among them `-Wunused-parameter` and
  `-Wunused-const-variable`).
- `raw/local-checks/test-checker-final.log`: 837,153 checks, 0 failures.
- `raw/local-checks/test-checker-driver-final.log`, the final code on `32560e46`: 179,653 checks, 0 failures, its
  warning sweep's 1,067 fixtures with 0 differences. `test-checker-driver-branch2.log`, `branch2` on `b7a95eed`:
  151,857 checks, 0 failures, 1,040 fixtures with 0 differences.

## Limitations

- **What was left out of the receipts.** `exclusive.sh`'s waiting lines name the other sessions' commands, so each
  `lock.log` is summarized as `lock-summary.txt`: the number of waits, and the busy processes `exclusive.sh` listed as
  each grant began. The host's build logs keep only `build.sh`'s and Ninja's lines.

- **Unlocked setup work.** Each `ab.sh` run hashed the `bin/` executables before its first grant, outside the lock
  (`host.txt`'s SHA-256 list), and one copy's `tar` and `sha256sum` ran outside it during `t1` (above). Later copies
  were unpacked under the lock (`scripts/unpack.sh`).
- **Separate rounds.** `r1`, `t1`, `r2`, `r3` and `r4` are separate sets of rounds, and their main medians move by
  0.5 ms between them (45.95 to 46.45 ms); the differences above are within one set each.
- **Placement.** The final change moves the checker's code, and `check-expressions`, which it doesn't touch, moved by
  up to 0.4 ms between the variants; the whole compile's change is within that noise.
- **One input.** These are `sqlite3.c`'s numbers on one host.
