# #898's leaves for Key Locker's, WAITPKG's and RTM's x86 builtins: what code without them pays, 2026-10-30

Branch `claude/loving-carson-j9sz52-intrinsics9e2` (buster14a/buster#898), stacked on buster14a/buster#897's, lowers 14
x86 builtins as per-unit leaves: Key Locker's 11, WAITPKG's `umwait` and `tpause` and RTM's `xbegin`. It adds two
extensions to `X86Target` (KL and WIDEKL), the effects of 14 forms in `x86_semantics.c` (Key Locker's implicit XMM
registers through a new property, `IMPLICIT_VECTORS`), and `test-x86-intrinsics`' walk over both paths of a branch.
This record measures what its head costs `-fsyntax-only` and `-c` of code that calls no x86 builtin, and
`-fsyntax-only` of `main.c`, whose headers define the intrinsics, against its parent, with an A/A control, and over
the builds' code placements.

Every measurement ran on the 9700X, pinned to CPU 2, each run under the 9700X's lock on its own. The inputs:

- **`sqlite3.c`**: the frozen one of corpus `preprocessor-391e729af658`, by `-fsyntax-only --clang-features`
  (`drive`) and by `-c` without that option (`lower`), whose objects every tree made the same, byte for byte
  (`acB/acB.log` and `acB/inputs.sha256`);
- **`main.c`**: the head's own, the same file for every tree, checked with `build.sh`'s flags
  (`print-compile-flags`, the head's) and one lane (`main`).

Each tree built with `BUSTER_DEBUG_INFO=0` under its own hold of the lock, and its sources hash to the commit's
`git archive` (`sources.sha256`). An A/A control (`aa`) is a copy of the base's executable, the same bytes, run as a
tree of its own. The campaign's files are in `acB/`.

## acB: the head against its parent

Base: #897's head `39e3c8a3951a999fc2ca980225240b4d3b1c3676`. `h9e2`: #898's head
`081f16c51c277bbdb9497f285b7120ec8a4832ed`, its batch's commit.

acB.sh built the two trees, ran each tree's `-c` of `sqlite3.c` and `-fsyntax-only` of `main.c` (each exited with
status 0), then three rounds of `perf stat -r 11` (`-r 5` for `main.c`) of user instructions, cycles and task-clock,
whose order rotates; the medians of the rounds (`acB/perf.log`):

| Measure | base | A/A copy | h9e2 |
| --- | ---: | ---: | ---: |
| `sqlite3.c -fsyntax-only`, instructions | 1,025,529,186 | 1,025,529,186 | 1,025,525,394 |
| against base | | 0 | -3,792 (-0.0004%) |
| `sqlite3.c -fsyntax-only`, cycles | 467.264 M | 468.192 M | 469.648 M |
| `sqlite3.c -c`, instructions | 1,302,992,354 | 1,302,992,359 | 1,302,991,955 |
| against base | | +5 | -399 (-0.00003%) |
| `sqlite3.c -c`, cycles | 593.762 M | 595.770 M | 593.808 M |
| `main.c -fsyntax-only`, instructions | 19,772,224,978 | 19,772,225,410 | 19,771,923,420 |
| against base | | +432 | -301,558 (-0.0015%) |
| `main.c -fsyntax-only`, cycles | 7,504.431 M | 7,500.619 M | 7,511.524 M |

- **Instructions:** one tree's three rounds span at most 71 instructions in `sqlite3.c`'s runs (base's) and 8,924 in
  `main.c`'s (base's), and the A/A copy is within 432 of its base. Against base, the head runs 3,792 and 399 fewer in
  `sqlite3.c`'s runs and 301,558 fewer in `main.c`'s, each at most 0.0015% of its command. The lowering reads the
  leaves' rows only for an x86 builtin's call, which `sqlite3.c` doesn't have, and `-fsyntax-only` lowers none of
  `main.c`'s. This record attributes none of these differences.
- **Cycles:** the head's medians are 0.51% and 0.01% above base's in `sqlite3.c`'s runs and 0.09% above in
  `main.c`'s, and the A/A copy's 0.20% and 0.34% above and 0.05% below. One tree's three rounds span up to 1.61%
  (base's of `drive`, whose third round is 474.074 M against 466.553 M and 467.264 M). Each of the head's three `drive`
  rounds, and each of the A/A copy's, is between base's second and third.
- **The layout:** the head's `.rodata` is 7,710 bytes larger than base's (`acB/sizes.log`). Of them:
  - 2,800 bytes are the 14 leaves' records (`cbuiltin_x86_helper_*`);
  - 2,178 bytes are the effects rows' table, `x86_effects_rows`, of which each executable has 11 copies, each 9 rows
    of 22 bytes larger (`nm`'s sizes: 41,272 bytes in base's, 41,470 in the head's);
  - 381 bytes are `test-checker`'s RTM program's source;
  - two static locals, of 6 and 28 bytes in each, have generated names whose numbers changed;
  - data without symbols are the rest.

  The head's `.text` starts 12,288 bytes (three pages) later than base's, at 0x8ef000 against 0x8ec000: beside
  `.rodata`'s 7,710 bytes, the sections between `.rodata` and `.text` take 4,578 bytes more, `.text`'s page alignment
  included. Its `.text` is 11,648 bytes longer.

## acB's placements: over the builds' code placements and copies

acB.sh then linked each tree again with `main.c`'s own unit, the first source, shifted by 0 to 3,840 bytes in steps of
768 (`./build.sh shifts`), which moves every unit's code. It ran `ab`'s three rounds of `time-runs`, each of three runs
of every placement from three fresh copies on tmpfs, the builds alternating in an order that rotates by run, of `-c`
and of `-fsyntax-only --clang-features` of `sqlite3.c` as above. `base-again`, base's placements a second time, is the
comparison's floor (the profiling guide's "Builds over their code's placements and copies", buster14a/buster's
`docs/profiling.md`). Each round's median user cycles against base's, with the head's range over the placements
(`acB/whole.log`):

| Command | h9e2, rounds 1 to 3 | base-again, rounds 1 to 3 |
| --- | --- | --- |
| `-c` | -0.30% [-0.81, +0.47], -0.35% [-0.95, +0.17], -0.23% [-1.09, +0.32] | -0.01%, +0.00%, +0.05% |
| `-fsyntax-only` | -0.07% [-1.01, +0.80], +0.05% [-1.12, +0.82], -0.15% [-1.02, +0.61] | -0.16%, -0.02%, +0.04% |

- **By the guide's rule**, a difference is within these floors when it is within base's against itself and its range
  over the placements includes 0. Every range of the head's includes 0.
  - Its `-fsyntax-only` is within base's against itself (-0.16% to +0.04%) in the first and third rounds, and 0.01
    points above it in the second.
  - Its `-c` is below base's against itself (-0.01% to +0.05%) in all three rounds, by 0.29, 0.34 and 0.22 points.
  - Over the three rounds the head's medians come to -0.29% (`-c`) and -0.06% (`-fsyntax-only`) on average,
    base-again's to +0.01% and -0.05%.

  The `-c` difference has one sign in all three rounds and is larger than the about 0.2% that the guide says doesn't
  show at three rounds of this (its reading of buster14a/buster#509's record). It is a decrease, and the head's
  instructions are within 407 of base's (below). This record doesn't attribute it. The shifts move the code by up to
  3,840 bytes, not by the head's 12,288-byte later start of `.text`, so they don't control for that start, and no
  control of base's code at the head's start was run.
- **Wall time:** the head's `-c` is -0.17%, -0.30% and -0.10% against base's (base-again +0.08%, -0.08% and +0.14%),
  and its `-fsyntax-only` +0.04%, -0.06% and -0.12% (base-again -0.00%, -0.14% and -0.03%).
- **Instructions:** `time-runs` counts the head's `-c` processes 407 instructions fewer than base's (the medians of
  162 processes each) and its `-fsyntax-only` ones 3,807 fewer, about as many as `perf stat` counts; base-again's
  medians are within one instruction of base's. All 972 timed processes exited with status 0.
- **Not measured:** `main.c`'s `-fsyntax-only` over placements, the events behind the cycles (branch
  mispredictions, cache misses), and a control of base's code at the head's later start of `.text`.

## Files

| File | What it is |
| --- | --- |
| `acB/acB.sh`, `acB/acB.log`, `acB/perf.log`, `acB/inputs.sha256` | acB's script and log, `perf stat`'s output, and the executables', objects' and inputs' hashes. |
| `acB/build_*.log`, `acB/lower_*.log`, `acB/main_*.log` | The builds' reports, and each tree's `-c` and `main.c` runs' output, which is empty. |
| `acB/whole.log`, `acB/whole_*.log`, `acB/acB-whole.sha256` | `ab`'s and `time-runs`' output over `main.c`'s placements, the shifted builds' reports and their executables' hashes. |
| `acB/sizes.sh`, `acB/sizes.log` | The two executables' `.rodata` and `.text`, the effects rows' table's copies and the read-only data symbols whose total size differs, run after the campaign under the lock. |
| `sources.sha256` | Each tree's sources' list hashed, and the commit it matches. |
