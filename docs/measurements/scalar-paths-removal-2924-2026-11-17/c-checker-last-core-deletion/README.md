# #2924 C12c-3, core-3: the unsequenced checks, the deferred merge, the overload index and the mangling keep their vector paths alone

The checker's core twins that the driver's `--scalar` (and the corpus tool's merge option) still selected after
core-1 and core-2. The record has the sites' classification, the census of which compiles reach them, the gate with a knob for each twin, the deletion's run, its mutants and its local tests.

The deletion removes the scalar arms of:

- **The unsequenced checks:** `check_unseq_marks` and `check_unseq_repeats`.
- **The deferred merge:** `check_deferred_entries`, `check_deferred_entries64` and `check_deferred_count_bytes`, the
  expressions' append, and the token nodes' relocation.
- **The overload index's probe:** `check_overload_index_find`.
- **The mangling:** the substitutions' compare and the global tags' scan.
- **The environment's body count.**

Two twins the gate measured stay, for David to decide:

- **The string literals' step,** which loses to the blocks on short strings.
- **The condition declarations' marks,** at parity.

Every run on the 9700X is under the lock, timings on CPU 2 unless stated.

## Classification (`classification.md`)

After core-2, bit 14 of C12c's gate held the sites of fourteen files. Read against their writers, they are of four
kinds:

- **Twins only `--scalar` or a test selects (this record's subject):**
  - the environment;
  - the literals' flag;
  - the condition marks;
  - the overload index;
  - the mangling;
  - the unsequenced checks;
  - the deferred merge.
- **Scalar arms production code chooses:**
  - `CheckAction.scalar`, which the constant conditions' evaluator sets, and with it the member lookup's and the wide
    fold's twins;
  - the overload rank order, which `check_overload_explain` takes;
  - the builtins' one-lane fold, which the graph's calls take;
  - the debug rows' origin column.

  These are phase D's or need a size sweep first.
- **Owned by another piece:**
  - the debug lines' and keep's `exact` (check-debug);
  - the target features' and the unsequenced plans' `c_bindings_sort` flag (bindings);
  - the initializers (bit 30).
- **Not paths:** `check_action_is_scalar` and `check_action_scalar`.

## Census (`census/`)

`census.patch` makes `BUSTER_SCALAR_PATH` and `BUSTER_VECTOR_PATH` count each use by file and line on #3193's head
`88741d83b`. It also wraps the plain selectors: the overload index's, the unsequenced scans' and the deferred
scans'. `census.sh` runs a local Develop build of it in five modes over four lists: sqlite3.c, musl's units, buster's
`main.c` (the complete driver), and `gen.py`'s fixture of 200 groups of overloadable functions with `enable_if`
conditions.

The modes:

- `-c --lanes 1`;
- with `-Wall -Wextra`;
- `-c --lanes 4 --deferred-bodies -Wall`;
- `-fsyntax-only -Wall`;
- `--scalar`.

`census-table.txt` has each site's counts. What reaches what:

- **The unsequenced scans:** every list in every mode. Every unit enables `-Wunsequenced`.
- **The literals' flag:** every list's string literals.
- **The deferred scans:** sqlite3.c alone, with `--deferred-bodies` on 4 lanes. musl's units are too small to defer;
  `--scalar` reads in source order.
- **The overload index, the mangling and the condition marks:** the fixture alone; C units without overloadable
  functions reach none of them. `-fsyntax-only` mangles nothing.
- **The environment:** no compile mode. `-c`'s attested reader publishes none, and `--attested=off` and
  `--attested=verify` reached no count either. The readers that publish one (`check_input`, `check_input_bindings_mode`)
  are those of the corpus tool, the binding and deferred benchmarks, `ssa.c`, `ssa_verify.c` and `fuzz.c`.

## The gate (`gate/`)

`gate3.sh` takes #3193's head with `knob.diff`. That is C12c's knob builds' mask, read from the executable's name
(`compiler-areas<mask>`):

| Bit | Forces the scalar arm of |
| --- | --- |
| 0 | the literals' step |
| 1 | the unsequenced scans |
| 2 | the deferred merge's scans and copies |
| 3 | the overload index's probe |
| 4 | the mangling's scans |
| 5 | the condition marks |

One Release build; every timed build is a hard link to one fresh copy of it. `gate3b.sh` is the second round, on the
same build.

**Objects and stderr** (`logs/status.txt`): every mask, against no bit's, gave 1,411 objects each and 0 differ. Ten
lists were compared:

- `-c --lanes 1` of sqlite3.c, Lua's units and musl's units;
- `-c --lanes 4 --deferred-bodies` of sqlite3.c and Lua's units;
- the fixtures of 1, 4, 16, 64 and 256 groups.

Every mask's stderr matched no bit's but in one list, the 64 groups' fixture, where no bit's run had one line more.
`stderr64.sh` (`logs/stderr64/`) ran that compile three times by every mask, keeping the files. The only lines are the
lock's report of another process busy on the machine: `exclusive.sh: other processes busy as the lock is taken` and a
process row (perf, which I ran beside it), and the filter drops the first but not the row. The compiler's stderr is the
same.

**Whole lists** (`table.txt`, by `table.py`): user cycles against no bit, each round. Lists at three rounds of
`time-runs --runs 3`, unless the list says otherwise:

| List | The scalar arm forced | No bit again | Instructions, the bit |
| --- | --- | --- | --- |
| `-c` sqlite3.c, bit 0 (literals) | −0.28%, +0.25%, +0.12% | −0.09%, +0.09%, −0.21% | +0.26% |
| `-c` Lua's units, bit 0 | +0.24%, +0.10%, +0.20% | +0.09%, +0.10%, +0.19% | +0.17% |
| `-c` musl's units, bit 0 | −0.36%, −0.02%, +0.17% | −0.29%, −0.17%, +0.23% | +0.03% |
| `-c` sqlite3.c, bit 1 (unsequenced) | +0.43%, +0.52%, +0.45% | (as above) | +0.93% |
| `-c` Lua's units, bit 1 | +0.43%, +0.43%, +0.14% | | +0.38% |
| `-c` musl's units, bit 1 | +0.31%, +0.54%, +0.26% | | +0.27% |
| `-c --lanes 4 --deferred-bodies` sqlite3.c, bit 2, CPUs 2 to 9 (`gate3b.sh`) | +0.73%, +1.48%, +1.33% | −0.57%, −0.24%, +0.26% | +3.67% |
| the 64 groups' fixture, bit 3 (overload index), five rounds of nine runs | +0.46%, +0.65%, +0.73%, +0.21%, +0.31% | −0.03%, −0.16%, −0.08%, −0.13%, −0.14% | +0.54% |
| the 64 groups' fixture, bit 4 (mangling) | +0.26%, +0.31%, +0.29%, +0.33%, +0.07% | | +0.39% |
| the 64 groups' fixture, bit 5 (condition marks) | +0.11%, −0.11%, +0.17%, −0.09%, −0.29% | | +0.34% |
| the 256 groups' fixture, bit 3, five rounds of nine runs | +0.39%, +0.47%, +0.49%, +0.44%, +0.30% | +0.03%, −0.02%, +0.10%, +0.09%, −0.07% | +0.43% |
| the 256 groups' fixture, bit 4 | +0.38%, +0.25%, +0.33%, +0.54%, +0.23% | | +0.31% |
| the 256 groups' fixture, bit 5 | −0.00%, −0.08%, −0.11%, +0.01%, −0.03% | | +0.27% |

On one CPU (`gate3.sh`, `ab --cpu 2`) bit 2 ran the same instructions as no bit: every body took one lane and was read
in source order. On CPUs 2 to 9 Lua's units still ran the same instructions: none defers. The fixtures of 1, 4 and 16
groups read within their no-bit runs' spread (`table.txt`).

`perf record` of 20 compiles of the 256 groups' fixture by no bit, bit 5 and no bit again (`logs/perf/`) gave
`check_input_conditions`, where the marks are inlined: 649, 592 and 519 samples of 10,007 cycles. The two no-bit runs
are as far apart as either is from bit 5.

**By unit size** (`units-table.txt`, by `units.py`): musl's 447 units below 8,000 preprocessed bytes, each a command of
its own. Each had one locked `time-runs --runs 9` of no bit, bit 0, bit 1, both and no bit again. Pooled user cycles
against no bit:

| Preprocessed bytes | Units | Bit 0 | Bit 1 | No bit again |
| --- | --- | --- | --- | --- |
| below 1,000 | 9 | −0.44% | −0.05% | −0.23% |
| 1,000 to 2,000 | 42 | −0.15% | −0.03% | −0.05% |
| 2,000 to 4,000 | 86 | −0.02% | +0.12% | +0.00% |
| 4,000 to 8,000 | 310 | −0.02% | +0.09% | −0.02% |
| all | 447 | −0.03% | +0.09% | −0.02% |

The two no-bit runs' instructions differ by a median of 165 a unit, so each bit is taken against their mean:

- **Bit 0** runs a median 215 fewer instructions a unit, fewer in 437 units.
- **Bit 1** runs a median 577 more, more in 331.

**The verdicts:**

- **Deleted:**
  - The unsequenced checks' vector path is faster on every list, and at parity in musl's two smallest size bins.
  - The deferred merge's is faster on the one list that defers.
  - The overload index's and the mangling's are faster on the fixtures of 64 and 256 groups. At 1 to 16 groups they
    are within the no-bit runs' spread, and the scalar arms run more instructions at every size.
  - The environment's runs in no compile mode.
- **Kept for David:**
  - **The literals' step:** the blocks lose on short strings, by instructions in 437 of 447 small units and by
    0.10% to 0.21% of cycles against no bit again in the two smallest bins.
  - **The condition marks:** their vector path reads at parity on the fixtures of 64 and 256 groups.

## The deletion (`deletion/`)

`run.sh` compares base `844e73a12` (the tests commit, the twins present) against head `a16652352` (the deletion), both
on #3193's head `88741d83b` and taken from a bundle of the branch; Release builds.

The PR's commits are `eb73fa8ca` (tests) and `4debb2ae3` (the deletion) on main `bdba7f0ea`. They are these rebased,
with three changes:

- the tests commit gains the unsequenced lane fixture of the mutation round;
- the deletion drops the append's varargs term, dead code by the mutation round (below);
- the deletion's message corrects the environment's readers.

`final-objects.sh` compares `e4b4f2a61` against `eb180c560` the same way (`logs-final/status.txt`): 1,374 objects in
every mode, 0 differ, stderr the same. The control, head's `--tier1` objects against the warnings-on base, finds 1,304
that differ. These two commits' production code is the PR's: the PR's tests commit adds the call-argument roots to a
test file only.

`tables.txt` has every table below.

**Objects** (`logs/status.txt`): `-c` of four lists by base and head, in four modes, 1,374 objects in each, 0 differ.

- Lists: sqlite3.c, Lua's units, musl's units and buster's `main.c` with `--lanes 1`; sqlite3.c with `--lanes 4
  --deferred-bodies` on CPUs 2 to 9; and the 256 groups' fixture.
- Modes: with `-Wall -Wextra` by default, with `--scalar` and with `--tier1`, and with no warning option.
- Head's `--scalar` objects and its objects with no warning option are base's warnings-on objects. The control, head's
  `--tier1` objects against them, finds 1,304 that differ.

**Stderr** (`logs/stderr.tar.gz`, without the lock's lines): the same bytes in every mode.

**The start section** (`logs/start-*.txt`): the same 565 functions in both. Their function lists are the same too.

**Whole compiles, head against base and the parent.** `parent.sh` adds a clean Release build of their parent
`88741d83b`, whose production source is base's: `844e73a12` changes only a test. It times all of them in one `ab`
session: three rounds of `time-runs`, each three runs of three copies. User cycles against base, each round, and
instructions against base:

| List | Parent | Head | Base again | Instructions, head |
| --- | --- | --- | --- | --- |
| `-c` sqlite3.c | −0.10%, −0.12%, +0.20% | +0.31%, +0.10%, +0.54% | −0.01%, −0.02%, +0.07% | 0.550 M fewer (of 1,342.41 M) |
| `-c` Lua's units | +0.02%, −0.03%, +0.05% | +0.18%, +0.18%, +0.16% | −0.13%, −0.23%, −0.03% | 0.037 M fewer (of 851.40 M) |
| `-c` musl's units | +0.01%, +0.00%, +0.04% | +0.04%, −0.04%, +0.08% | −0.02%, +0.04%, +0.05% | 1.634 M fewer (of 6,764.02 M) |
| `-c -Wall -Wextra` sqlite3.c | +0.12%, +0.02%, +0.05% | +0.08%, +0.18%, +0.28% | +0.07%, −0.09%, +0.11% | 0.162 M fewer (of 1,554.31 M) |
| `-c -Wall -Wextra` Lua's units | +0.07%, −0.18%, +0.06% | +0.45%, +0.47%, +0.05% | +0.09%, +0.07%, −0.19% | 0.291 M more (of 875.39 M) |
| `-c -Wall -Wextra` musl's units | −0.02%, −0.06%, −0.45% | −0.10%, −0.12%, −0.29% | −0.22%, −0.21%, −0.43% | 6.178 M more (of 8,213.85 M) |
| `-c --lanes 4 --deferred-bodies` sqlite3.c, CPUs 2 to 9 | +0.05%, −0.27%, −0.14% | +0.36%, −0.21%, +0.29% | −0.08%, −0.57%, −0.36% | 0.738 M fewer (of 1,481.33 M) |
| the 256 groups' fixture | +0.31%, −0.44%, +0.13% | +0.99%, +0.54%, +1.21% | −0.10%, −0.04%, −0.12% | 0.469 M fewer (of 136.63 M) |

Parent and base run the same instructions on every list, within 0.007 M, as close as base again comes. **Head is slower:**

- +0.10% to +0.54% on `-c` sqlite3.c;
- +0.16% to +0.18% on Lua's units;
- +0.54% to +1.21% on the fixture.

It runs fewer instructions on those lists and more on Lua's and musl's units with `-Wall -Wextra`. `run.sh`'s own
session read the same (`tables.txt`).

**By area.** `areas.sh` builds base with each area's part of the deletion alone (`areas/N-*.diff`):

| Build | Area |
| --- | --- |
| 1 | the environment |
| 2 | the overload index |
| 3 | the mangling |
| 4 | the unsequenced checks |
| 5 | the deferred merge |

It times them with base, head and base again in one session. Instructions against base:

| List | Area 1 | Area 2 | Area 3 | Area 4 | Area 5 | Head |
| --- | --- | --- | --- | --- | --- | --- |
| `-c` sqlite3.c | +0.000 M | −0.080 M | −0.000 M | −0.470 M | +0.000 M | −0.550 M |
| `-c` Lua's units | +0.001 M | −0.032 M | −0.000 M | −0.120 M | −0.001 M | −0.037 M |
| `-c -Wall -Wextra` Lua's units | +0.295 M | −0.031 M | +0.226 M | −0.119 M | +0.000 M | +0.290 M |
| `-c -Wall -Wextra` musl's units | +9.369 M | −0.299 M | +7.251 M | −1.295 M | +0.001 M | +6.187 M |
| the 256 groups' fixture | +0.000 M | −0.399 M | −0.043 M | −0.028 M | +0.000 M | −0.469 M |

Two of these patches change code that the lists never run:

- **Area 1's** (`symdiff.py` over `nm -S`) changes the sizes of five symbols, all the environment's (text −1,592
  bytes). It still runs 9.37 M more instructions on musl's units with `-Wall -Wextra` and 0.30 M more on Lua's.
- **Area 3's** mangling runs on none of musl's units, and that patch runs 7.25 M more there.

What moves those instructions is the address of everything after the changed functions, code and data; the executed
code is the same size. The session's cycles are too noisy to use: base again read up to +0.88% on the fixture.

`placement.sh` times base, area 1, area 5, head and base again in a session of their own. User cycles against base:

| List | Area 1 | Area 5 | Head | Base again |
| --- | --- | --- | --- | --- |
| `-c` sqlite3.c | +0.06%, +0.09%, +0.08% | +0.10%, +0.33%, +0.24% | +0.34%, +0.61%, +0.26% | −0.25%, +0.05%, −0.16% |
| `-c` Lua's units | −0.05%, −0.00%, +0.18% | +0.19%, +0.22%, +0.39% | +0.30%, +0.33%, +0.30% | −0.01%, −0.02%, −0.05% |

The fixture's base again read −0.58% to +0.57% in this session, so its cycles aren't used.

Area 5's patch changes only the deferred merge's symbols (19, text −7,741 bytes). It runs base's instructions on these
lists, within 0.001 M, yet reads 0.10% to 0.39% slower. Area 1's (−1,592 bytes) reads as base. The placement of the
code these lists run accounts for part of head's difference; what remains (+0.1% to +0.3%) isn't separated from the
executed code of areas 2 to 4.

**Function profiles:** `perfdiff.sh` (instructions) and `perfcycles.sh` (cycles) by function, base against head
(`logs/perf/`). They have no same-build control, and a split function's samples move between symbols. So they
attribute nothing.


## Mutants (`mutation/`)

Sixteen mutants of the vector code whose twins the deletion removes (`run.py`'s list). Each is applied to an archived
copy of the deletion's tree (`a16652352`), built, and run against `test-checker`'s eight parts, `test-checker-driver`'s
eight, `test-checker-deferred` and `test-check-lanes` (`results.txt`):

- The batches run in an order that puts the area's likeliest killer first.
- A mutant stops at its first failing batch. The first two ran every batch before I added the early stop.
- The unmutated tree passes all eighteen, before the round and in each rerun.

**Killed in the first round:**

- **The unsequenced checks:**
  - u1: the marks miss a plain assignment;
  - u5: the repeats' first pass misses a plain assignment.
- **The deferred merge:**
  - d1: the entries drop each 64 tokens' last 16;
  - d2: the 64-bit entries drop each 64 tokens' last 8;
  - d3: the byte count drops each 64 tokens' last;
  - d6: the token nodes' relocation drops each 16 tokens' last.
- **The overload index's probe:**
  - o1: it drops each group's last key;
  - o2: it misses each group's last empty slot.
- **The mangling:**
  - m1: the substitutions drop each 16's last;
  - m2: the global tags miss the bodies' openings.
- **The environment:** e1, the body count drops each 64 roles' last.

**Survived, then killed by the tests commit's lane fixture:**

- **u3:** the repeats' first pass missed `^=`, the operators' range's end. The operators fixture had `+=` alone.
- **u4:** the repeats' second pass dropped each 16 nodes' last value.
- **u2:** the marks dropped each 16 nodes' last modification. With the call-argument roots (`eb73fa8ca`), `test-checker-driver`'s first part kills it (`reruns 2`).

The fixture is `check_driver_unsequenced_lanes_source`, compared with clang. Before the call-argument roots went in,
`reruns.sh`'s run killed u3 and u4 but not u2: an assignment's root is marked by its `=` whatever its increment's mark.
On `u2`'s build, the final fixture's source gives 88 warnings where clang and head give 94.

**d4** (the append relocating a none too) didn't build as first written. Rewritten, it was killed by
`test-checker-deferred`.

**d5** (the append's arguments missing a varargs call's) survived every runner. It is dead code: a token with a varargs
call is no expression part's, and a part's graph has no varargs records. So no part holds a `CHECK_OP_VARARGS` node, and
the deletion removes the term. A fixture with `va_start` in four bodies confirmed it: those bodies went to the ordered
work, and the parts stayed without them.

**u2's first round** failed `test-checker-driver`'s fifth part twice, in "clang's builds of the AVX vectors' fixture
run": clang's own builds, not the mutant. It is listed as undecided there and decided by the reruns.

`logs.tar.gz` has every run's logs.


## Local tests (cloud container, `local/`)

On the PR's head `4debb2ae3` (`final3.sh`, `final-status.txt`):

- **CI blocks** (`localcheck-results.txt`):
  - the 27 blocks of `tools/ci/correctness.tests` that run a checker test and need no corpus, through `parallel` with
    clang 23.1.4 first on `PATH`: all pass (373.1 s);
  - the two that compile the complete driver's `main.c`, one at a time: both pass;
  - the integer builtins' fourth part and the two c-testsuite blocks: all pass. The c-testsuite blocks failed at first
    because this worktree had no `build/c-testsuite` checkout, and passed once it had one;
  - the three on the frozen SQLite and musl sources: all pass.
- **MemorySanitizer and AddressSanitizer** (vector host): 24 rows, every exit 0 (`san-status.txt`). They ran
  `test-checker`'s eight parts, `test-checker-driver`'s first and second, `test-checker-deferred` and
  `test-check-lanes`.
- **Ownership:** the check on a Release build with CI's toolchain (642 fixture paths, 63 exact shared exceptions).
- **Self-checks:** `main.c` and the complete driver's, `-fsyntax-only -Wall -Werror`.

**The tests commit alone,** `eb73fa8ca` (the twins present; `tests-commit-eb73fa8ca.txt`):

- `test-checker`'s eight parts and all eight of `test-checker-driver`'s: 0 failures;
- `test-checker-deferred`: 3,832 checks, 0 failures.

