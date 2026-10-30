# #897's system instructions' x86 builtins: what code without them pays, 2026-10-30

Branch `claude/loving-carson-j9sz52-intrinsics9e` (buster14a/buster#897), stacked on buster14a/buster#896's, gives
the lowering rows of 35 x86 builtins of system instructions (RAO-INT's atomic operations of memory, CLDEMOTE,
SERIALIZE, UINTR's, PTWRITE, WAITPKG's UMONITOR, LWP's control block, MOVRS's integer loads and prefetch, RTM's XEND
and XTEST, TSXLDTRK's, AMX-TILE's configuration, ENQCMD's and USER_MSR's), with twelve more extensions of
`X86Target`'s and the effects of 35 forms in `x86_semantics.c`, and `test-x86-intrinsics`' comparison of the cases'
effects. This record measures what its head costs `-fsyntax-only` and `-c` of code that calls no x86 builtin, and
`-fsyntax-only` of `main.c`, whose headers define the intrinsics, against its parent, with an A/A control, and over
the builds' code placements.

Every measurement ran on the 9700X, pinned to CPU 2, each run under the 9700X's lock on its own. The inputs:

- **`sqlite3.c`**: the frozen one of corpus `preprocessor-391e729af658`, by `-fsyntax-only --clang-features`
  (`drive`) and by `-c` without that option (`lower`), whose objects every tree made the same, byte for byte
  (`acA/acA.log` and `acA/inputs.sha256`);
- **`main.c`**: the head's own, the same file for every tree, checked with `build.sh`'s flags
  (`print-compile-flags`, the head's) and one lane (`main`).

Each tree built with `BUSTER_DEBUG_INFO=0` under its own hold of the lock, and its sources hash to the commit's
`git archive` (`sources.sha256`). An A/A control (`aa`) is a copy of the base's executable, the same bytes, run as a
tree of its own. The campaign's files are in `acA/`.

## acA: the head against its parent

Base: #896's head `4c8ae0391e11b95670636d62631eea716cc0ca18`. `h9e`: #897's head
`39e3c8a3951a999fc2ca980225240b4d3b1c3676`, its batch's commit.

acA.sh built the two trees, ran each tree's `-c` of `sqlite3.c` and `-fsyntax-only` of `main.c` (each exited with
status 0), then three rounds of `perf stat -r 11` (`-r 5` for `main.c`) of user instructions, cycles and task-clock,
whose order rotates; the medians of the rounds (`acA/perf.log`):

| Measure | base | A/A copy | h9e |
| --- | ---: | ---: | ---: |
| `sqlite3.c -fsyntax-only`, instructions | 1,025,555,110 | 1,025,555,114 | 1,025,529,147 |
| against base | | +4 | -25,963 (-0.0025%) |
| `sqlite3.c -fsyntax-only`, cycles | 468.184 M | 469.060 M | 470.167 M |
| `sqlite3.c -c`, instructions | 1,303,032,722 | 1,303,032,722 | 1,302,992,292 |
| against base | | 0 | -40,430 (-0.0031%) |
| `sqlite3.c -c`, cycles | 594.549 M | 595.277 M | 595.780 M |
| `main.c -fsyntax-only`, instructions | 19,740,344,172 | 19,740,349,704 | 19,741,076,508 |
| against base | | +5,532 | +732,336 (+0.0037%) |
| `main.c -fsyntax-only`, cycles | 7,504.638 M | 7,503.739 M | 7,512.242 M |

- **Instructions:** one tree's three rounds span at most 71 instructions in `sqlite3.c`'s runs (the head's) and
  11,060 in `main.c`'s (the A/A copy's), and the A/A copy is within 5,532 of its base. Against base, the head runs
  25,963 and 40,430 fewer in `sqlite3.c`'s runs and 732,336 more in `main.c`'s, each at most 0.0037% of its command.
  The lowering reads the rows only for an x86 builtin's call, which `sqlite3.c` doesn't have, and `-fsyntax-only`
  lowers none of `main.c`'s. This record attributes none of these differences.
- **Cycles:** the head's medians are 0.42% and 0.21% above base's in `sqlite3.c`'s runs and 0.10% above in
  `main.c`'s, and the A/A copy's 0.19% and 0.12% above and 0.01% below. One tree's three rounds span up to 0.78% (the
  A/A copy's of `main`). Each of the head's three `lower` rounds is above each of base's, as two of the A/A copy's
  are, and each of the A/A copy's three `drive` rounds is above each of base's, as two of the head's are.
- **The layout:** the head's `.rodata` is 6,178 bytes larger than base's. Of them 5,808 are its effects rows' table,
  `x86_effects_rows`, of which each executable has 11 copies, each 24 rows of 22 bytes larger (`nm`'s sizes: 40,744
  bytes in base's, 41,272 in the head's), the only read-only data symbol whose size differs (but a static local of 6
  bytes in each, `x86_break_instruction.modes`, whose generated name's number changed); data without symbols are the
  rest (`acA/sizes.log`). Both executables' `.text` starts at 0x8ec000, so, unlike #896's head against its parent
  (buster14a/buster-performance#129's record, its "abZ5"), the head's code starts where base's does, and its `.text`
  is 928 bytes longer.

## acA's placements: over the builds' code placements and copies

acA.sh then linked each tree again with `main.c`'s own unit, the first source, shifted by 0 to 3,840 bytes in steps of
768 (`./build.sh shifts`), which moves every unit's code, and ran `ab`'s three rounds of `time-runs`, each of three
runs of every placement from three fresh copies on tmpfs, the builds alternating in an order that rotates by run, of
`-c` and of `-fsyntax-only --clang-features` of `sqlite3.c` as above; `base-again`, base's placements a second time,
is the comparison's floor (the profiling guide's "Builds over their code's placements and copies", buster14a/buster's
`docs/profiling.md`). Each round's median user cycles against base's, with the head's range over the placements
(`acA/whole.log`):

| Command | h9e, rounds 1 to 3 | base-again, rounds 1 to 3 |
| --- | --- | --- |
| `-c` | +0.24% [-0.35, +0.56], +0.14% [-0.25, +0.72], -0.04% [-0.58, +0.68] | +0.01%, +0.09%, -0.11% |
| `-fsyntax-only` | +0.34% [-0.12, +0.91], +0.04% [-0.60, +0.99], +0.08% [-0.87, +0.95] | -0.04%, -0.01%, -0.05% |

- **By the guide's rule**, a difference is within these floors when it is within base's against itself and its range
  over the placements includes 0. Every range of the head's includes 0. Its `-c` is within base's against itself
  (-0.11% to +0.09%) in the third round and above it by 0.15 and 0.05 points in the first two; its `-fsyntax-only` is
  above base's (-0.05% to -0.01%) in all three, by 0.05 to 0.35 points. Over the three rounds the head's medians come
  to +0.11% and +0.15% on average, base-again's to -0.00% and -0.03%: below the about 0.2% that the guide says
  doesn't show at three rounds of this (its reading of buster14a/buster#509's record). This record attributes none of
  it.
- **Wall time:** the head's `-c` is +0.08%, -0.01% and +0.01% against base's (base-again -0.11%, -0.04% and -0.15%),
  and its `-fsyntax-only` +0.19%, -0.00% and -0.01% (base-again -0.04%, -0.00% and -0.00%).
- **Instructions:** `time-runs` counts the head's `-c` processes 40,400 instructions fewer than base's (the medians of
  162 processes each) and its `-fsyntax-only` ones 25,991 fewer, about as many as `perf stat` counts; base-again's
  medians are base's. All 972 timed processes exited with status 0.
- **Not measured:** `main.c`'s `-fsyntax-only` over placements, the events behind the cycles (branch
  mispredictions, cache misses), and a control of base's code at another `.rodata` size.

## Files

| File | What it is |
| --- | --- |
| `acA/acA.sh`, `acA/acA.log`, `acA/perf.log`, `acA/inputs.sha256` | acA's script and log, `perf stat`'s output, and the executables', objects' and inputs' hashes. |
| `acA/build_*.log`, `acA/lower_*.log`, `acA/main_*.log` | The builds' reports, and each tree's `-c` and `main.c` runs' output, which is empty. |
| `acA/whole.log`, `acA/whole_*.log`, `acA/acA-whole.sha256` | `ab`'s and `time-runs`' output over `main.c`'s placements, the shifted builds' reports and their executables' hashes. |
| `acA/sizes.sh`, `acA/sizes.log` | The two executables' `.rodata` and `.text`, the effects rows' table's copies and the read-only data symbols whose total size differs, run after the campaign under the lock. |
| `sources.sha256` | Each tree's sources' list hashed, and the commit it matches. |
