# #862's half-precision values: what code without them pays, 2026-10-29

Branch `claude/loving-carson-j9sz52-intrinsics8` (buster14a/buster#862) gives the checker and the lowering
`_Float16`, `__fp16` and `__bf16` values: their constants folded and rounded as clang rounds them, their arithmetic,
conversions, calls and memory, and the intrinsics of their vectors. This record measures what that costs
`-fsyntax-only` and `-c` of code without them, and `-fsyntax-only` of `main.c`, whose headers have them, at the
branch's head after its merge of main; and two variants of that head, one of which the branch's next head takes.

Every measurement ran on the 9700X, pinned to CPU 2, each run under the 9700X's lock on its own. The inputs:

- **`sqlite3.c`**: the frozen one of corpus `preprocessor-391e729af658`, which has no half-precision value, by
  `-fsyntax-only` (`drive`) and by `-c` (`lower`), whose objects every tree made the same, byte for byte
  (`abW/abW.log` and `abW/inputs.sha256`);
- **`main.c`**: the head's own, the same file for every tree, checked with `build.sh`'s flags
  (`print-compile-flags`) and one lane (`main`).

Each tree built with `BUSTER_DEBUG_INFO=0` under its own hold of the lock, and its sources hash to the commit's
`git archive`, or to the head's with the variant's patch, which this record holds (`sources.sha256`). An A/A control
(`aa`) is a copy of the base's executable, the same bytes, run as a tree of its own. Instruction counts are
deterministic here: the A/A copy is within 152 instructions of its base in `sqlite3.c`'s runs and within 7,422 in
`main.c`'s, whose own rounds span 13,264. Cycles move more: the A/A copy differs from its base by up to 0.29%, and one
tree's three rounds by up to 0.77% (`v2`'s of `main`); the A/A copy's of `drive` span 0.64%.

## abW: the head and two variants against main

Base: main `79bc77d25048397a7f383c7e8169dfa9dae79d7b`; head: the branch's `ec27b10e87e90fa2907fa0ca278f3e3cbbb3a22f`,
its merge of that main with its review's fixes. The variants, each a patch against the head:

- **v1** (`abW/v1.patch`): the half-precision branch of `check_action_convert_plain`, a constant's conversion to a
  `_Float16`, `__fp16` or `__bf16`, out of line (`check_action_convert_half`, `noinline`), which then works out the
  constant's source type's width and signedness itself. At the head that branch is inlined into the function, whose
  every constant conversion of `sqlite3.c` and `main.c` runs, though none of `sqlite3.c`'s reaches the branch;
- **v2** (`abW/v2.patch`): v1, with the rounding's three helpers out of line too (`check_action_half_round`,
  `check_action_half_bits` and `check_action_half_value`).

abW.sh built the four trees, ran each tree's `-c` of `sqlite3.c` (the same object by all five) and `main.c`, then
three rounds of `perf stat -r 11` (`-r 5` for `main.c`) of user instructions, cycles and task-clock, whose order
rotates; the medians of the rounds (`abW/perf.log`):

| Measure | base | A/A copy | head | v1 | v2 |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c -fsyntax-only`, instructions | 1,026,664,585 | 1,026,664,433 | 1,027,309,845 | 1,027,131,772 | 1,027,128,916 |
| against base | | -152 | +645,260 (+0.063%) | +467,187 (+0.046%) | +464,331 (+0.045%) |
| `sqlite3.c -fsyntax-only`, cycles | 467.338 M | 468.687 M | 467.418 M | 467.172 M | 468.761 M |
| `sqlite3.c -c`, instructions | 1,303,223,025 | 1,303,223,017 | 1,302,788,099 | 1,302,610,199 | 1,302,607,261 |
| against base | | -8 | -434,926 | -612,826 | -615,764 |
| `sqlite3.c -c`, cycles | 592.713 M | 592.331 M | 593.011 M | 593.137 M | 594.123 M |
| `main.c -fsyntax-only`, instructions | 19,419,463,458 | 19,419,456,036 | 19,431,483,012 | 19,425,295,397 | 19,425,276,627 |
| against base | | -7,422 | +12,019,554 (+0.062%) | +5,831,939 (+0.030%) | +5,813,169 (+0.030%) |
| `main.c -fsyntax-only`, cycles | 7,371.520 M | 7,357.610 M | 7,343.986 M | 7,370.957 M | 7,354.376 M |

- **v1 is the branch's next head**, `80e2666be6b8ad86156a2e5d0d542d746234c705`, v1's patch on `ec27b10` alone:
  its `git archive`'s list of files and hashes is abW's v1's, byte for byte (`sources.sha256`). It runs 178,073 fewer
  instructions than the head in `sqlite3.c -fsyntax-only`, 177,900 fewer in `-c` and 6,187,615 fewer in `main.c`'s.
  v2's helpers out of line take 2,856, 2,938 and 18,770 more off, under 0.0003% of each, so the head takes v1, the
  smaller change.
- **What v1 leaves against main:** `sqlite3.c -fsyntax-only` runs 467,187 more instructions (0.046%), and `-c`
  612,826 fewer. These whole-command deltas differ by about 1.08 M instructions. The syntax command uses
  `--clang-features`, while the object command does not; this subtraction does not isolate lowering after checking.
  `main.c -fsyntax-only` runs 5.83 M more (0.030%); its headers' half-precision constants are folded and rounded at
  the head, where main left them unfolded (an unsupported constant), so some of that is work main didn't do. This record attributes none of
  these differences further.
- **Cycles:** every tree's median is within 0.37% of base's (the head's of `main.c`, 0.37% fewer), inside the spread
  of one tree's own three rounds (up to 0.77%, `v2/main`; A/A `drive` spans 0.64%, `abW/perf.log`); this record
  claims no speed difference.

## Files

| File | What it is |
| --- | --- |
| `abW/abW.sh`, `abW/abW.log`, `abW/perf.log`, `abW/inputs.sha256` | abW's script and log, `perf stat`'s output, and the executables', objects' and inputs' hashes. |
| `abW/v1.patch`, `abW/v2.patch` | The variants against `ec27b10`. |
| `abW/build_*.log`, `abW/lower_*.log`, `abW/main_*.log` | Its builds' reports, and each tree's `-c` and `main.c` runs' output (the lock's waits). |
| `sources.sha256` | Each tree's sources' list hashed, and the commit and patch they match. |
