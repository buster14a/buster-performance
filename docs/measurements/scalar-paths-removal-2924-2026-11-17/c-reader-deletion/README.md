# #2924 C12c-1: the reader keeps its vector path alone

The checker's reader (`c_check_input.c` and its `c_check_*_input.c` files) loses its scalar twins, which the C12c area
gate ([`../c-checker-gate`](../c-checker-gate)) measured at +30% to +64% of user cycles on whole compiles (bit 10).

## The 9700X run (`run.sh`)

Base `dc1514dfa` (the tests commit, the twins present) against head `fd9bb83f5` (the deletion), both on main
`8bdb83b8d`, Release, every run under the lock, timings on CPU 2. The PR's commits were rebased onto main `ec9f8f712`
(#3025 and #3003) after this run; the deletion's diff is the same, and the two commits after it change tests alone.

**Objects and stderr** (`logs/status.txt`): `-c --lanes 1` of sqlite3.c, Lua's units, musl's units and buster's `main.c`
(the complete driver) by base and head, by default, with `--scalar` and with `--tier1`: 1,376 files each (1,372 objects
and four stderr files), 0 differ. Head's `--scalar` objects against base's default objects: 1,372 of 1,372 identical.
The comparison's control, head's `--tier1` objects against base's default objects, finds 1,293 of 1,372 differ.

**Whole compiles:** `ab`, three rounds, around `time-runs` (three runs of three copies) of base, head and base again
(`logs/time-*.log`). User cycles against base, each round:

| List | Head | Base again | Instructions, head against base |
| --- | --- | --- | --- |
| `-c` sqlite3.c | −0.51%, −0.07%, −0.29% | −0.19%, +0.17%, +0.23% | 7.027 M fewer (of 1,357.42 M) |
| `-c` Lua's units | −0.06%, −0.22%, −0.12% | +0.28%, −0.07%, +0.07% | 2.552 M fewer (of 856.97 M) |
| `-c` musl's units | −0.18%, +0.02%, −0.20% | −0.06%, +0.07%, −0.17% | 23.745 M fewer (of 6,809.70 M) |
| `-fsyntax-only` sqlite3.c | −0.02%, +0.02%, −0.08% | +0.37%, +0.12%, −0.18% | 7.027 M fewer (of 1,069.09 M) |

Head's minor faults: +1.8 a process on sqlite3.c (5,829.1 against 5,827.3), +3.3 with `-fsyntax-only`, +3.0 and +2.6
over Lua's and musl's whole lists.

**The start section** (`startsec.sh`, `logs/start-*.txt`): the same 565 functions in base and head. Functions head has
outside it that base hasn't (`logs/functions-*.txt`): `check_input_identifier_entry`, the identifiers' entry for a unit
past the gathers' signed 32-bit offsets, no longer inlined;
`check_input_declaration_starts`, base's `check_input_declaration_starts_vector` renamed, outside the section in both;
nine `.buster_split` parts of other functions; and two test functions.

## Mutants (`mutation/`)

Ten mutants of the reader's vector code (`run.py`'s list), each applied to an archived copy of the tree, built, and run
against `test-checker`'s four parts and then `test-checker-driver`'s first part (`results.txt`, `logs.tar.gz`):

- **First round, on the deletion `fd9bb83f5`:** seven killed. m7's tests failed in three parts, then its walk looped,
  and its four test processes were stopped by hand after 19 minutes without output. The runner then gained the
  timeouts it has now; the first round ran without them. Three survived:
  - m3, the region transfer stopping one position early: its test compared the walk with itself once the flag no
    longer selected the full walk;
  - m6, the x86 contexts' scan dropping each step's last lane: no fixture's selection fell there;
  - m10, the literal grammar letting a number follow a number: no test list had one.
- **`rerun.sh`, on `e372e6cd3`** (the region transfer against its definition, the x86 fixtures at every lane): m3
  killed by part 2 (12 failures of the definition's comparison), m6 by part 4 (three fixtures at the padding that puts
  the selection at lane 15), and m10 survived again.
- **`final.sh`, on `e526b3bfb`** (the grammar on random lists): m10 killed by part 4. That commit, unmutated, passes all
  four parts with 0 failures.

## Local tests (cloud container, Develop)

On the deletion and the unrecorded-digest commit rebased onto main `ec9f8f712` (`c1176bb2d`'s tree):
- `test-checker`'s four parts: 0 failures; 1,084 of the runs' cases found their digest line and 4 had none (#3003's
  cleanup cases, merged after the table was recorded). The same with a 93-character `$TMPDIR`.
- `test-checker-driver`'s four parts, `test-check-units`, `test-checker-deferred`, `test-call-graph`, the complete
  driver's `-fsyntax-only -Wall -Werror` and the self-check of `main.c`: all pass.
- `test-checker-corpus --clang clang --deferred 8 --id-order 153` on c-testsuite's `single-exec`: 220 files, 0
  differences.
- `test-check-lanes`: its first run failed two token-growth checks while mutant m7's four looping processes held every
  core; run again, 8,576 checks, 0 failures.
- The digest table's controls: one digest altered fails that case alone, one line deleted passes and counts one case
  without a line, and the table moved away fails every case of the part (106 of 106).

On `e526b3bfb`: `test-checker`'s four parts, 0 failures. On `e372e6cd3` with MemorySanitizer and with
AddressSanitizer (vector host): `test-checker`'s four parts and `test-checker-driver`'s first, 0 failures and no
sanitizer report.
