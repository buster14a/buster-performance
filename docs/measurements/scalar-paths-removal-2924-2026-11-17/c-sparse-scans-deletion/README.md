# #2924 C12c-3, core-2: the sparse columns' scans, the selections and the deprecated uses keep their vector paths alone

The sparse columns' scans (`c_check_sparse.c`: `check_sparse_entries`, `check_sparse_next`, `check_sparse_wide_next`,
`check_sparse_wide_group`, `check_sparse_wide_entries`) lose their scalar twin, which the reader, the warnings, the
bindings, the attributes and the deferred expressions handed the flag on to; with them the generic masks'
(`check_generic_masks`), the selection positions' (`check_input_selection_positions`) and the deprecated uses' scan's
(`check_input_deprecated_uses`). C12c's split core ([`../c-checker-core-deletion`](../c-checker-core-deletion)) had the
attributes' hand-offs at bit 31; this record gates each twin on a knob of its own.

Every run on the 9700X is under the lock, timings on CPU 2.

## The gate (`gate/`)

`gate2.sh` takes #3186's head (`498b2f3a7`, main `eacca00de`) with `knob.diff`: the mask C12c's knob builds read from
the executable's name (`compiler-areas<mask>`), bit 0 forcing the sparse scans' scalar arm inside the five functions
(whatever their caller passes), bit 1 the generic masks' and the static selections', bit 2 the deprecated uses'. One
Release build; every timed build is a hard link to one fresh copy of it.

**Objects and stderr** (`logs/status.txt`): `-c --lanes 1 -Wall -Wextra` of sqlite3.c, Lua's units and musl's units by
no bit, each bit and all three: 1,371 objects each, 0 differ from no bit's; stderr without the lock's message the same
bytes, 25, 0 and 4,865 lines.

**Whole lists:** `ab`, three rounds, around `time-runs` (three runs) of no bit, each bit, all three and no bit again
(`logs/time-*.log`). User cycles against no bit, each round:

| List | Bit 0, the sparse scans | Bit 1, the selections | Bit 2, the deprecated uses | All three | No bit again |
| --- | --- | --- | --- | --- | --- |
| `-c` sqlite3.c | +3.22%, +2.96%, +3.42% | +2.11%, +2.50%, +2.66% | +8.52%, +8.54%, +8.79% | +14.39%, +14.53%, +14.85% | −0.17%, −0.37%, +0.17% |
| `-c` Lua's units | +1.55%, +1.54%, +1.66% | +0.09%, −0.01%, +0.06% | +1.48%, +1.37%, +1.21% | +2.95%, +2.90%, +2.84% | +0.05%, +0.08%, +0.16% |
| `-c` musl's units | +1.36%, +1.37%, +1.24% | +0.01%, +0.08%, −0.19% | +0.13%, −0.09%, −0.14% | +1.43%, +1.29%, +1.45% | +0.17%, +0.04%, +0.06% |
| `-Wall -Wextra` sqlite3.c | +6.11%, +5.59%, +5.91% | +2.07%, +1.73%, +2.03% | +7.92%, +7.49%, +7.96% | +15.52%, +15.31%, +15.52% | +0.50%, −0.01%, +0.68% |
| `-Wall -Wextra` Lua's units | +4.05%, +4.12%, +3.97% | −0.12%, −0.02%, −0.08% | +1.19%, +1.16%, +1.24% | +5.35%, +5.54%, +5.14% | −0.09%, −0.03%, −0.26% |
| `-Wall -Wextra` musl's units | +3.10%, +2.91%, +3.58% | +0.03%, +0.02%, +0.14% | +0.19%, +0.00%, +0.25% | +3.15%, +3.04%, +3.26% | +0.08%, −0.01%, +0.01% |

Bit 1 on Lua and musl and bit 2 on musl run the same instructions as no bit (0.00% apart): no unit of theirs reaches a
selection or a deprecated declaration.

**By unit size:** musl's 447 units below 8,000 preprocessed bytes, each a command of its own, one locked `time-runs
--runs 9` of no bit, bit 0, all three and no bit again (`logs/units.tsv`). Pooled user cycles against no bit:

| Preprocessed bytes | Units | Bit 0 | All three | No bit again | Instructions, bit 0 |
| --- | --- | --- | --- | --- | --- |
| below 1,000 | 9 | +0.48% | +0.27% | +0.10% | +0.64% |
| 1,000 to 2,000 | 42 | +0.24% | +0.19% | −0.18% | +1.56% |
| 2,000 to 4,000 | 86 | +0.65% | +0.67% | +0.03% | +2.40% |
| 4,000 to 8,000 | 310 | +0.99% | +1.02% | +0.02% | +3.34% |
| all | 447 | +0.89% | +0.91% | +0.01% | +3.12% |

Bit 0 read above both no-bit runs in 414 of the 447 units and below both in 12, and ran more instructions in 442 (the
other 5 reach no scan). The vector paths are the faster at every size measured.

## The deletion (`deletion/`)

`run.sh`: base `60fea8b56` (the generic masks' test, the twins present) against head `19e6a2172` (the deletion), both
on #3186's head; Release. The PR's commits, `6d6546f3f` (tests) and `88741d83b` (the deletion) on main `875980f24`, are
these with the mutation round's next-entry test folded into the tests commit, rebased: the same production code.

- **Objects** (`logs/status.txt`): `-c --lanes 1` of sqlite3.c, Lua's units, musl's units and buster's `main.c` (the
  complete driver), with `-Wall -Wextra` by default, with `--scalar` and with `--tier1`, and with no warning option:
  1,372 objects each, 0 differ. Head's `--scalar` objects and its objects with no warning option are base's
  warnings-on objects, 1,372 of 1,372 each; the control, head's `--tier1` objects against them, finds 1,293 differ.
- **Stderr** (`logs/stderr/`, without the lock's three-line wait message): the same bytes in every mode, 25, 0, 4,865
  and 74 lines with the warnings on, 0, 0, 1,554 and 0 without.
- **Whole compiles:** `ab`, three rounds, around `time-runs` (three runs of three copies) of base, head and base again
  (`logs/time-*.log`). User cycles against base, each round:

  | List | Head | Base again | Instructions, head against base |
  | --- | --- | --- | --- |
  | `-c -Wall -Wextra` sqlite3.c | −0.27%, −0.28%, −0.25% | −0.06%, +0.23%, −0.15% | 1.232 M fewer (of 1,555.77 M) |
  | `-c -Wall -Wextra` Lua's units | −0.31%, −0.11%, −0.26% | −0.11%, +0.09%, −0.01% | 0.412 M fewer (of 875.80 M) |
  | `-c -Wall -Wextra` musl's units | −0.19%, −0.20%, −0.30% | −0.21%, +0.02%, −0.01% | 3.289 M fewer (of 8,223.53 M) |
  | `-c` sqlite3.c | −0.32%, −0.29%, −0.08% | +0.15%, −0.05%, +0.40% | 1.177 M fewer (of 1,343.54 M) |

- **The start section** (`logs/start-*.txt`): the same 565 functions. Head's functions outside it that base hasn't:
  `check_lower_asm_call.buster_split` and `check_lower_asm_slot.buster_split`, the cold parts of two lowering functions
  the splitter now cuts.

## Mutants (`mutation/`)

Nine mutants of the vector code whose twins this deletes (`run.py`'s list), each applied to an archived copy of the
deletion's tree (`19e6a2172`), built, and run against `test-checker`'s eight parts, `test-checker-driver`'s eight,
`test-checker-deferred` and `test-check-lanes` (`results.txt`), after the unmutated tree, which passes all eighteen.

- **Killed:** the entries' scan dropping each block's last lane (s1: `test-checker`'s seventh part, the deferred merge
  and the lanes) or taking a block's tokens before `begin` (s2: the seventh part and the deferred merge); the next
  entry's block test dropping each block's last lane (s3: the sixth part and six of the driver's); the generic masks
  dropping the last empty lane (s8: the fifth part); a selection keyword that is another child than its close's first
  counting too (s9: the first part).
- **s4** (the next entry's block test taking tokens before `token`) makes the scan go back, so every run it reaches
  loops: `test-checker`'s first four parts ran to their 1,200 s timeout, and `hang-s4.sh` stopped the rest of its runs
  after 300 s (605 s for the parts already running when it started; the unmutated tree's longest run took 134 s), each
  counted as a failure (`hang-s4.log`). Killed by non-termination on all eighteen.
- **Survived:** the next entry's and the wide columns' directory scans skipping each 16 entries' last (s5, s6): the
  column tests stop at 200 tokens, 13 directory entries, and no other test reaches a 16th. s7 (the wide group dropping
  its high 8 tokens) left a variable unused and didn't build.
- **`rerun.py`** (an archived copy of the branch, `40a828376`, with `check_test_sparse_next`, which the tests commit
  gained: each next scan against its definition on columns of 255 to 1,100 tokens with one entry at every 7th token,
  from every start; `rerun.txt`): the unmutated tree passes `test-checker`'s seventh part (71,573 checks, 0 failures);
  s5 and s6 each fail it (1 failure), and s7, written to drop the wide group's last lane, fails it too (158 failures,
  by the wide columns' group test).

All nine are killed. `logs.tar.gz` has every run's build and test logs.

## Local tests (cloud container, `local/`)

On `9e4070625`, the deletion on main `79f565efe` (`final2.sh`, `final-status.txt`):
- the 27 blocks of `tools/ci/correctness.tests` that run a checker test and need no corpus, through the `parallel`
  runner with clang 23.1.4 first on `PATH`: all pass (359.3 s); then, one at a time, the two that compile the complete
  driver's `main.c`; then the integer builtins' fourth part and the two c-testsuite blocks, and the three on the frozen
  SQLite and musl sources: all pass (`localcheck-results.txt`);
- **MemorySanitizer and AddressSanitizer** (vector host): `test-checker`'s eight parts, `test-checker-driver`'s first
  and second, `test-checker-deferred` and `test-check-lanes`, 0 failures and no sanitizer report (`san-status.txt`);
- the ownership check on a Release build with CI's toolchain (640 fixture paths, 63 exact shared exceptions), and the
  self-check of `main.c` and the complete driver's, `-fsyntax-only -Wall -Werror`.

On the tests commit alone, `007afe62f` (the twins present): `test-checker`'s eight parts and all eight of
`test-checker-driver`'s, 0 failures. On the PR's head `88741d83b`, the same commits rebased onto main `875980f24`, which
touches none of their files: the same sixteen parts, 0 failures. Earlier, on the deletion `19e6a2172`, `test-checker`'s
eight parts, 0 failures.
