# #2924 C12c-2: the warnings keep their vector paths alone

The checker's warnings lose their scalar twins: the common warnings' driver and scans, the warning graph's passes,
undefined internals, the return facts, typo correction and the interrupt checks. C12c's area gate
([`../c-checker-gate`](../c-checker-gate)) put them at bit 12; this record has the census of which helpers' arms the
gate's lists reach, the gate with the warnings on, the synthetic units for the passes the corpora barely reach, the
gate by unit size, and the deletion's run, mutants and local tests.

Every run on the 9700X is under the lock, timings on CPU 2. The gate's executables are C12c's knob builds
(`compiler-areas<mask>`, the mask read from the executable's own name): no bit is `compiler-areas0`, bit 12 is
`compiler-areas4096`.

## Census (`census/`)

`census.patch` adds a counter at the entry of each of the area's helpers, by the arm it takes (0 the scalar twin's), on
#3047's head `e526b3bfb`; `census.sh` runs `-c --lanes 1` of sqlite3.c, Lua's units and musl's units by default and with
`--scalar`, `BUSTER_WCENSUS=FILE` collecting the counts at exit (`BUSTER_EXIT_HELPER=0`: the exit helper closes the
descriptors first). `table.py logs` prints `census-table.txt`. By default every count is the vector arm's and with
`--scalar` the scalar arm's; the helpers the corpora don't reach (typo correction, the interrupt checks, the chosen
selections' depths) have no line, and the synthetic units below reach them. The gate's own census, with `-Wall
-Wextra`, is `gate/census-table.txt`.

## The gate with the warnings on (`gate/`)

`gatew.sh`: `-c --lanes 1 -Wall -Wextra` of sqlite3.c, Lua's units and musl's units by no bit and bit 12, objects and
stderr compared; then `ab`, three rounds, around `time-runs` (three runs) of no bit, bit 12 and no bit again.

- **Objects:** 1,371 compared, 0 differ. **Stderr** (`logs/stderr.txt`): the status file's "DIFFER" is the lock's wait
  lines, which one run's stderr had and the other's hadn't; without them, 25, 0 and 4,865 lines, the same bytes.
- **User cycles, bit 12 against no bit** (three rounds; no bit again in brackets):
  - sqlite3.c: +27.71%, +28.53%, +27.88% (−0.23%, +0.04%, +0.08%)
  - Lua's units: +19.97%, +20.22%, +20.21% (−0.17%, −0.16%, −0.08%)
  - musl's units: +13.99%, +14.42%, +14.17% (+0.12%, +0.16%, +0.31%)

## Synthetic units (`synthetic/`)

`synth.py DIR` writes 60 units each of typo correction (a scope of 3,000 globals and 50 misspelled uses),
`-Wexcessive-regsave` (200 functions marked `no_caller_saved_registers`, 8 calls each) and selections (2,000 `_Generic`
and `__builtin_choose_expr` expressions); `gates.sh` times `-fsyntax-only -ferror-limit=0 -Wall` of each kind's 60
units as one command, as the gate does, and compares stderr (`logs/stderr.txt`: 6,060, 192,060 and 0 lines, the same
bytes). User cycles, bit 12 against no bit, three rounds:

- typo correction: +477.80%, +475.33%, +472.53%
- `-Wexcessive-regsave`: +27.67%, +27.11%, +26.61%
- selections: +43.15%, +44.13%, +43.24%

No bit again read −0.22% to +0.58% of no bit.

## By unit size (`units/`)

Each of musl's units a command of its own, `-c --lanes 1` (no warning option), `time-runs` of no bit, bit 12 and no bit
again; `bins.py logs/units-X.tsv` prints the tables.

- **`units.sh`** (1,336 units, three runs, the gate's three files): the two no-bit files, the same bytes, read a median
  7.4% to 12.1% apart below 16,000 preprocessed bytes, so the small bins say little. Bit 12 ran more instructions in
  every unit, and from 8,000 bytes on never read below both no-bit runs.
- **`units2.sh`** (778 units below 16,000 bytes, five runs, each build from a fresh copy in `/dev/shm` a unit): worse,
  the no-bit copies a median 12.5% to 29.3% apart.
- **`units3.sh`** (447 units below 8,000 bytes, nine runs, the three names hard links to one fresh copy, so that every
  build runs from the same pages): the no-bit pair's median within 0.21%, every unit within −4.3% to +3.1%. Bit 12
  never read below both no-bit runs, and from 1,000 bytes on read above both in every unit (the least 2.2% above the
  slower). Below 1,000 bytes (9 units, mostly assembly) it read from 1.2% below the slower no-bit run to 0.2% above the
  faster at the least. Pooled: +2.46% below 1,000 bytes, +4.32% from 1,000 to 2,000, +5.91% to 4,000, +8.91% to 8,000;
  instructions +7.79% to +21.78%.

The vector path is the faster at every size measured.

## The deletion (`run.sh`)

Base `27bc44eb8` (the tests commit, the twins present) against head `c808a4136` (the deletion), both on main
`3741c264f`, from a bundle of the two commits; Release. The PR's commits, `6d838bd46` and `40ddd9106` on main
`0ceb0e3a7`, are these with the mutation round's two test fixes folded into the tests commit, rebased: against them,
the deletion's diff changes `c_check_common_candidates_test.c` and `c_check_interrupt_driver_test.c` alone.

**Objects and stderr** (`logs/status.txt`): `-c --lanes 1` of sqlite3.c, Lua's units, musl's units and buster's
`main.c` (the complete driver) by base and head, with `-Wall -Wextra` by default, with `--scalar` and with `--tier1`,
and with no warning option: 1,376 files each (1,372 objects and four stderr files), 0 differ. With the warnings on,
stderr has 25, 0, 4,865 and 74 lines; with no warning option, 0, 0, 1,554 and 0. Head's `--scalar` objects, and its
objects with no warning option, against base's warnings-on objects: 1,372 of 1,372 identical. The comparison's control,
head's `--tier1` objects against them, finds 1,293 of 1,372 differ.

**Whole compiles:** `ab`, three rounds, around `time-runs` (three runs of three copies) of base, head and base again
(`logs/time-*.log`). User cycles against base, each round:

| List | Head | Base again | Instructions, head against base |
| --- | --- | --- | --- |
| `-c -Wall -Wextra` sqlite3.c | −0.41%, −0.34%, +0.02% | −0.24%, +0.20%, +0.17% | 6.685 M fewer (of 1,561.99 M) |
| `-c -Wall -Wextra` Lua's units | −0.38%, −0.39%, −0.31% | +0.01%, −0.13%, +0.16% | 2.847 M fewer (of 878.65 M) |
| `-c -Wall -Wextra` musl's units | −0.32%, −0.19%, −0.11% | −0.07%, −0.03%, −0.02% | 14.252 M fewer (of 8,236.86 M) |
| `-c` sqlite3.c | −0.65%, −0.83%, −0.18% | −0.29%, −0.25%, +0.07% | 7.050 M fewer (of 1,350.15 M) |

Head's minor faults: +2 or +3 over each list.

**The start section** (`logs/start-*.txt`): the same 565 functions in base and head. Head's functions outside it that
base hasn't (`logs/functions-*.txt`): `check_typo_builtins_before`, no longer inlined (typo correction runs only after
an undeclared name); base's that head hasn't, now inlined: `check_common_next_indexed_op`, `check_typo_group_open` and
`check_typo_source_token`.

## Mutants (`mutation/`)

Fourteen mutants of the vector code whose twins this deletes (`run.py`'s list), each applied to an archived copy of the
deletion's tree, built, and run against `test-checker`'s eight parts and `test-checker-driver`'s first
(`results.txt`), every test under a timeout.

- **First round (`run.py`):** six killed: the token scan's last role (m1), the operator scan's last lane (m2), the
  cached roots' last lane (m3), the parents' tree test letting a child equal its node (m4) and the candidate
  classifier's last lane (m5), all by the scans' and parents' definitions in the driver's first part; the typo filter's
  `<=` made `<` (m8), by its definition in `test-checker`'s fifth part. m7 and m9 left a variable unused and didn't
  build. Six survived.
- **`rerun.py`** (all eight driver parts; m7 and m9 written to build): m6 (the self candidates' carry across a block)
  killed by the driver's sixth part, m7 (the return facts' x86 sources) by `test-checker`'s second, m9 (the typo
  builtins' scan without semicolons) by the driver's second, m10 (the interrupt calls without varargs) by its fifth, m12
  (the side effects' scan without calls) by its seventh: the first round ran the driver's first part alone. m13 (the
  reach scan dropping its lowest bit) killed by the first part once its test asked every bit (the tests commit's fixup:
  the test had asked the bits 2 alone, and the scan's one caller asks 1, `BUSTER_CHECK_REACH_TREE`). m11 (the
  redeclaration marks' last lane) and m14 (the evaluator's calls' last lane) survived.
- **`sweep.sh`, `sweep2.sh`** (the tests commit's other fixup: the interrupt driver test's lane sweep, units after a
  function of 0 to 63 empty statements, so that each of their tokens falls at every lane of the 64-token scans, against
  clang): the unmutated tree passes (the driver's fifth part, one check more). With four units, m14 killed by the fifth
  part (the evaluator's calls, at 19 empty statements), and m11 survived: in none of the four does a declaration's own
  mark reach a call through the scan alone. With six (a redeclaration inheriting its routine's mark from the declaration
  before it, and a block's routine called in its block, each in a unit with links), m11 killed by the fifth part (the
  inheriting unit, at 9 empty statements).

All fourteen are killed. `logs.tar.gz` has every run's build and test logs.

## Local tests (cloud container, Develop)

On the PR's head `40ddd9106` (main `0ceb0e3a7`):
- the 27 blocks of `tools/ci/correctness.tests` that run a checker test and need no corpus, through the `parallel`
  runner with clang 23.1.4 first on `PATH`: all pass (279.4 s); the same on the deletion before the rebase, `c808a4136`
  and `bcd5af3ad`;
- the ownership check, the complete driver's `-fsyntax-only -Wall -Werror` and the self-check of `main.c`;
- **MemorySanitizer and AddressSanitizer** (vector host): `test-checker`'s eight parts and `test-checker-driver`'s first
  and fifth (the scans' definitions and the lane sweep), 0 failures and no sanitizer report.

On the tests commit before the rebase (`fef9d0a71`, the twins present): `test-checker`'s eight parts and all eight of
`test-checker-driver`'s, 0 failures.
