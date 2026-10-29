# #896's x86 builtins: what code without them pays, 2026-10-29

Branch `claude/loving-carson-j9sz52-intrinsics9d` (buster14a/buster#896), stacked on buster14a/buster#895's, gives the
lowering rows
for AVX10.2's saturating conversions, bf16 operations, conversions to and from 8-bit floats, conversion of two
vectors of floats to halves and dot products of halves, MOVRS's vector loads and AVX512-BMM's products of bit
matrices, with MOVRS and AVX512-BMM extensions of `X86Target`'s and the effects of 197 forms in `x86_semantics.c`.
This record measures what its head costs `-fsyntax-only` and `-c` of code that calls no x86 builtin, and
`-fsyntax-only` of `main.c`, whose headers define the intrinsics, against its parent; then, over the builds'
placements and with a control of its own, where the difference in cycles that it found comes from.

Every measurement ran on the 9700X, pinned to CPU 2, each run under the 9700X's lock on its own. The inputs:

- **`sqlite3.c`**: the frozen one of corpus `preprocessor-391e729af658`, by `-fsyntax-only --clang-features`
  (`drive`) and by `-c` without that option (`lower`), whose objects every tree made the same, byte for byte
  (`abZ/abZ.log`, `abZ/abZ5.log` and `abZ/inputs.sha256`);
- **`main.c`**: the head's own, the same file for every tree, checked with `build.sh`'s flags
  (`print-compile-flags`, the head's) and one lane (`main`).

Each tree built with `BUSTER_DEBUG_INFO=0` under its own hold of the lock, and its sources hash to the commit's
`git archive` (`sources.sha256`); every later build of a tree made the same executable, byte for byte
(`abZ/inputs.sha256` and `abZ/abZ5.sha256`). An A/A control (`aa`) is a copy of the base's executable, the same
bytes, run as a tree of its own. The five campaigns ran in one directory, abZ's, and their files are in `abZ/`.

## abZ: the head against its parent

Base: #895's head `a5a7d86c76790423c0844994d2309f607fd720a3`. `h9d`: #896's head
`8a9363704f2a0fe5d707e857e7e5bd17c2d63e63`, its batch's commit.

abZ.sh built the two trees, ran each tree's `-c` of `sqlite3.c` and `-fsyntax-only` of `main.c`, then three rounds
of `perf stat -r 11` (`-r 5` for `main.c`) of user instructions, cycles and task-clock, whose order rotates; the
medians of the rounds (`abZ/perf.log`):

| Measure | base | A/A copy | h9d |
| --- | ---: | ---: | ---: |
| `sqlite3.c -fsyntax-only`, instructions | 1,025,520,389 | 1,025,520,375 | 1,025,555,151 |
| against base | | -14 | +34,762 (+0.0034%) |
| `sqlite3.c -fsyntax-only`, cycles | 468.944 M | 470.725 M | 470.355 M |
| `sqlite3.c -c`, instructions | 1,302,946,339 | 1,302,946,328 | 1,303,032,776 |
| against base | | -11 | +86,437 (+0.0066%) |
| `sqlite3.c -c`, cycles | 594.141 M | 595.753 M | 596.950 M |
| `main.c -fsyntax-only`, instructions | 19,726,203,729 | 19,726,203,683 | 19,726,636,975 |
| against base | | -46 | +433,246 (+0.0022%) |
| `main.c -fsyntax-only`, cycles | 7,510.002 M | 7,495.087 M | 7,505.016 M |

- **Instructions:** one tree's three rounds span at most 15 instructions in `sqlite3.c`'s runs and 6,298 in
  `main.c`'s (the base's), and the A/A copy is within 46 of its base. Against base, the head runs 34,762, 86,437 and
  433,246 more, each at most 0.0066% of its command. The lowering reads the rows only for an x86 builtin's call, which
  `sqlite3.c` doesn't have, and `-fsyntax-only` lowers none of `main.c`'s. `-c`'s emission initializes
  `x86_semantics.c`'s effects table (`c_check_program_emit.c`), to which the head adds the rows of 197 forms, and
  `-fsyntax-only` emits nothing. This record attributes none of these differences further.
- **Cycles:** the head's medians are 0.30% and 0.47% above base's in `sqlite3.c`'s runs and 0.07% below in
  `main.c`'s, and the A/A copy's 0.38% and 0.27% above and 0.20% below. One tree's three rounds span up to 0.38% (the
  A/A copy's of `lower`), and each of the head's three `lower` rounds is above each of base's. One executable of each
  tree measures each build at one placement of its code and from one set of physical pages (the profiling guide's
  "Builds over their code's placements and copies", buster14a/buster's `docs/profiling.md`), so abZ2 to abZ5 measure
  the difference over placements and copies.

## abZ2 to abZ4: over the builds' placements and copies

Each of the three linked each tree again with one unit's code shifted by six offsets within a page
(`./build.sh shifts`), then ran `ab`'s three rounds of `time-runs`, each of three runs of every placement from three
fresh copies on tmpfs, the builds alternating in an order that rotates by run, of `-c` and of
`-fsyntax-only --clang-features` of `sqlite3.c` as abZ runs them; `base-again`, base's placements a second time, is
the comparison's floor. The unit: abZ2 the checker's (`main_unit_checker.c`, 0 to 3,440 bytes in steps of 688), abZ3
the front end's (`main_unit_frontend.c`, 0 to 3,840 in steps of 768) and abZ4 `main.c`'s own, the first source, whose
shift moves every unit's code (0 to 3,840 in steps of 768). Each round's median user cycles against base's, with the
head's range over the placements (`abZ/placements.log`, `abZ/front.log` and `abZ/whole.log`):

| Shifted | Command | h9d, rounds 1 to 3 | base-again, rounds 1 to 3 |
| --- | --- | --- | --- |
| the checker's unit | `-c` | +0.52% [+0.08, +0.97], +0.36% [+0.04, +0.78], +0.49% [-0.01, +0.80] | +0.12%, -0.01%, +0.02% |
| | `-fsyntax-only` | +0.31% [-0.27, +0.66], +0.28% [-0.13, +1.21], +0.49% [-0.09, +1.13] | +0.01%, -0.14%, -0.06% |
| the front end's unit | `-c` | +0.38% [-0.27, +0.80], +0.55% [+0.01, +0.87], +0.35% [+0.01, +0.62] | +0.01%, -0.09%, -0.17% |
| | `-fsyntax-only` | +0.25% [-0.35, +1.10], +0.16% [-0.29, +0.92], +0.19% [-0.09, +0.76] | +0.01%, -0.20%, -0.18% |
| `main.c`'s unit | `-c` | +0.44% [+0.02, +0.77], +0.42% [-0.26, +0.64], +0.41% [-0.22, +0.99] | -0.06%, +0.10%, -0.25% |
| | `-fsyntax-only` | +0.07% [-0.53, +0.48], +0.08% [-0.37, +0.54], +0.46% [-0.49, +1.00] | -0.09%, -0.18%, +0.06% |

- **By the guide's rule**, a difference is within these floors when it is within base's against itself and its range
  over the placements includes 0. The head's `-c` is outside them in all nine rounds: +0.35% to +0.55%, where base
  against itself is -0.25% to +0.12%; so is its wall time (+0.24% to +0.39%, base against itself -0.25% to +0.07%).
  Its `-fsyntax-only` is +0.07% to +0.49%, and within them only in abZ4's first two rounds.
- **Instructions:** `time-runs` counts the head's `-c` processes 86,423 or 86,424 instructions more than base's (each
  campaign's median), and its `-fsyntax-only` ones 34,628 to 34,765, as abZ does.

## abZ3: the events behind the cycles

abZ3.sh first ran `perf stat -r 11` of three sets of events (five counters at a time, each set with the instructions
and the cycles) on base's executable at the checker unit's shift 0 (abZ2's `compiler-0`), a copy of it (`aa`) and the
head's, three rounds whose order rotates; the medians against base's (`abZ/events.log`):

| Event | `-c`: aa | `-c`: h9d | `-fsyntax-only`: aa | `-fsyntax-only`: h9d |
| --- | ---: | ---: | ---: | ---: |
| cycles | +0.15% | +0.82% | +0.44% | +0.94% |
| branch mispredictions | +0.00% | +1.99% | +0.00% | +1.12% |
| instruction cache misses | -1.40% | +3.19% | -1.53% | +1.85% |
| op cache misses | +0.51% | -0.17% | +2.64% | +1.58% |
| L1 iTLB misses that hit the L2 TLB | +0.62% | -1.03% | +1.89% | +1.03% |
| L2 iTLB misses | -0.30% | -0.79% | +0.44% | -0.92% |
| data cache fills (`ls_any_fills_from_sys.all`) | -0.35% | -0.16% | +0.01% | -0.16% |
| ops from the x86 decoders | +0.89% | -0.59% | +0.91% | -0.65% |
| L2 misses of the caches' requests | -0.17% | +0.46% | -0.35% | -0.32% |

- The head's extra cycles come with branch mispredictions that the copy of base's executable doesn't have: 67,011 more
  in `-c` (3,434,409 against 3,367,398) and 27,765 more in `-fsyntax-only`, their three rounds within 0.37% of each
  other, at almost the same instructions; and with 3.19% and 1.85% more instruction cache misses, where the copy's
  differ by 1.4% to 1.5% too. The TLBs, the data cache's fills and the L2's misses don't change.

## abZ5: base's code where the head's is

The head's `.rodata` is 31,308 bytes larger than base's: 26,136 bytes of it are its effects rows' table,
`x86_effects_rows`, of which each executable has 11 copies, one in each translation unit that compiles the effects'
initialization (`nm`'s sizes: 38,368 bytes each in base's, 40,744 in the head's, 108 more rows of 22 bytes), and strings
without symbols the rest. `.text` follows `.rodata` and the sections after it (the unwind tables, `.init` and `.fini`),
aligned to a page, so the head's whole `.text` starts 32 KB later, at 0x8ec000 against 0x8e4000 (`abZ/abZ5.log`), an
offset that keeps each address the same modulo 32 KB, which abZ2's to abZ4's shifts within a page don't vary. abZ5.sh
built `pad`, base's tree with an unused array of 31,308 bytes in `main_unit_x86.c`'s `.rodata`
(`abZ/pad_main_unit_x86.c`, `__attribute__((used, retain))`), whose `.text` starts at 0x8ec000 with base's code (the
same 0x1570b2c bytes of `.text`) and whose `-c` object of `sqlite3.c` is base's; then `perf stat -r 11` of base's,
`pad`'s and the head's executables, three rounds whose order rotates; the medians against base's (`abZ/padded.log`):

| Event | `-c`: pad | `-c`: h9d | `-fsyntax-only`: pad | `-fsyntax-only`: h9d |
| --- | ---: | ---: | ---: | ---: |
| instructions | +4,097 | +86,395 | +4,093 | +34,812 |
| cycles | +0.19% | +0.21% | +0.75% | +0.33% |
| branch mispredictions | +1.14% | +2.06% | +1.39% | +1.33% |
| instruction cache misses | +1.49% | +3.84% | +5.19% | +3.95% |
| op cache misses | +3.02% | +0.36% | +3.98% | +2.43% |

- **Base's code at the head's addresses runs about as slowly as the head's:** `pad` ran about as many extra cycles
  as the head in `-c` (+0.19% against +0.21%) and more in `-fsyntax-only` (+0.75% against +0.33%), with as many extra
  branch mispredictions in `-fsyntax-only` (+1.39% against +1.33%) and more than half of the head's in `-c` (+1.14%
  against +2.06%), while it runs 4,097 instructions more than base. So the head's extra cycles in these runs are what
  its code's placement, 32 KB later, costs base's own code too, rather than code the head runs.
- **Not attributed:** these runs are of one executable each, whose cycles a byte-identical copy alone moves by about
  0.3% (the profiling guide's buster14a/buster#502), so the record compares `pad`'s cycles with the head's no finer
  than that; and the rest of the head's mispredictions in `-c`, 30,660 more than `pad`'s (0.9% of base's), it doesn't
  attribute.
- **The table:** `x86_effects_rows` is read only by `x86_semantics_initialize`, which builds the effects' records
  from it, and its copies lie in `.rodata` ahead of `.text`, so that each row a batch adds, 242 bytes in all, moves all
  of the code after it.
- **Not measured:** `main.c`'s `-fsyntax-only` over placements or with `pad`, and the branch's later heads.

## Files

| File | What it is |
| --- | --- |
| `abZ/abZ.sh`, `abZ/abZ.log`, `abZ/perf.log`, `abZ/inputs.sha256` | abZ's script and log, `perf stat`'s output, and the executables', objects' and inputs' hashes. |
| `abZ/build_*.log`, `abZ/lower_*.log`, `abZ/main_*.log` | Its builds' reports, and each tree's `-c` and `main.c` runs' output (the lock's waits). |
| `abZ/abZ2.sh`, `abZ/abZ2.log`, `abZ/placements.log`, `abZ/shifts_*.log`, `abZ/shifts.sha256` | abZ2's script and log, `ab`'s and `time-runs`' output, the shifted builds' reports and their executables' hashes. |
| `abZ/abZ3.sh`, `abZ/abZ3.log`, `abZ/events.log`, `abZ/front.log`, `abZ/front_*.log`, `abZ/abZ3.sha256` | abZ3's script and log, `perf stat`'s events, `time-runs`' output over the front end's placements, those builds' reports and the executables' hashes. |
| `abZ/abZ4.sh`, `abZ/abZ4.log`, `abZ/whole.log`, `abZ/whole_*.log`, `abZ/abZ4.sha256` | abZ4's, the same over `main.c`'s placements. |
| `abZ/abZ5.sh`, `abZ/abZ5.log`, `abZ/padded.log`, `abZ/build_pad.log`, `abZ/lower_pad.log`, `abZ/abZ5.sha256`, `abZ/pad_main_unit_x86.c` | abZ5's script and log (with the three executables' `.rodata` and `.text`), `perf stat`'s output, `pad`'s build and `-c` run, the hashes, and `pad`'s `main_unit_x86.c`. |
| `sources.sha256` | Each tree's sources' list hashed, and the commit it matches. |
