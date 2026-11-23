# #2924 C12c-5 (a): the bindings keep their vector paths alone, with one form of the radix sort

C12c-5's first piece (session_01Egbxncfc7e7gHQWNmaafL1): the scalar twins of the bindings (`c_bindings.c`,
`c_parser_bindings.c`, `c_check_binding.c`, `c_check_body_bindings.c`) and `c_bindings_sort`'s `vector` flag at every
caller. C12c's gate (buster#2924, comment 7014944772) found the bindings' scalar arms 0.5% to 2.0% slower and the sort
at parity, so the owner's rule 3 (parity or a win: delete the twin) applied, but for the sort: `c_check_data.c` chose the
scalar sort below 65,536 keys, so the sort was timed by size first.

Commits (buster branch `claude/2924-front`): tests `5dd46ea1b`, deletion `2231ad85c` (on main `968a085fe`). The 9700X's
deletion run measured `dd9fae6ee` against `d5c2d4deb`, whose code is the same; the PR's commits add a test fixture and
a docs link.

## The sort (`sort/`)

`sortbench.c` copies `c_bindings_sort`'s two arms; `candidate.h` is the single form the deletion writes. One locked run
on CPU 2, cycles a sort, the least of 7 rounds, keys `high << 32 | position` for 2 to 65,536 keys whose high halves vary
in their low byte (`ff`), low two (`ffff`), low three (`ffffff`), all four (`ffffffff`) or second byte (`ff00`).

- `arms.tsv`: the two arms. The vector arm skips constant bytes (the producer's `varying`), so it wins where one byte
  varies, but each pass costs about 8 cycles a key against the scalar arm's 2: it loses at every size where all four
  bytes vary, above 64 keys where three do, and above 512 where two do.
- `arms-and-candidate.tsv`: the single form beside them. Up to 16 keys: stable ranks in one register (each lane counts
  the lanes with a smaller high half and the earlier lanes with an equal one), keys stored at their ranks. More: an
  LSD radix pass per varying byte, a counting loop, the buckets' starts by an in-register prefix sum, a store a key. It
  is at least as fast as both arms at every size and byte pattern: 48 cycles at 2 keys (scalar 768 to 807, vector 257 to
  1,143); 258 k at 65,536 keys with two bytes varying (scalar 474 k, vector 1,008 k); 521 k with all four (scalar 523 k).

## Objects and stderr (`objects/`)

`objects.sh`, in the session's container (Release builds with CI's toolchain), to keep the 9700X's lock queue short:
-c --lanes 1 of sqlite3.c, Lua's units, musl's units and buster's main.c (complete driver), and sqlite3.c with
--lanes 4 --deferred-bodies, with -Wall -Wextra, --scalar -Wall -Wextra, --tier1 -Wall -Wextra and no warning option.
`status.txt`: 1,373 objects in each of the four modes, 0 differ; every stderr the same.

## Timings (`deletion/`)

`run.sh` on the 9700X: Release builds of base and head, then `ab --rounds 3` around `time-runs --runs 3 --copies 2` of
base, head and base again, CPU 2 (the deferred list on CPUs 2 to 9). Logs in `deletion/logs/`.

User cycles, head against base, in each of the three rounds (`base-again`, base timed again, is the control), and the
lists' instructions (median, millions):

| List | head | base-again | instructions base → head |
| --- | --- | --- | --- |
| sqlite3.c -Wall -Wextra | −0.02%, −0.36%, −0.41% | +0.46%, −0.04%, +0.39% | 1,420.46 → 1,415.83 |
| Lua -Wall -Wextra | −0.20%, +0.05%, −0.13% | +0.13%, +0.00%, +0.10% | 793.26 → 791.48 |
| musl -Wall -Wextra | +0.12%, +0.17%, +0.22% | +0.39%, +0.01%, −0.37% | 8,502.1 → 8,502.9 to 8,503.3 |
| sqlite3.c | −0.39%, −0.74%, −0.41% | −0.02%, −0.33%, +0.27% | 1,279.43 → 1,274.62 |
| musl | −0.56%, −0.31%, −0.41% | −0.16%, −0.05%, −0.16% | 6,809.4 → 6,798.5 |
| sqlite3.c, 4 lanes, deferred bodies | −0.55%, −0.59%, +0.38% | +0.18%, −0.29%, +0.50% | 1,473.04 → 1,468.23 |

musl's units with the warnings on run 0.7 M to 1.2 M more instructions (0.01%): their warnings sort many short lists,
which the register sort ranks with a loop of a step a key; the cycles are within the control's spread. Every other list
runs fewer instructions and as many or fewer cycles. `.text.buster_start` holds the same functions (`start-*.txt`).

## Mutants (`mutation/`)

`mutants.py` and `run.py`: each mutant of the deletion's vector code, built (Develop) and run through test-bindings,
test-checker's 8 parts, test-checker-deferred, test-check-lanes, test-parser-bindings, test-environments and
test-checker-driver's 8 parts until one fails. `results*.txt`:

- `results-1.txt` (on the first deletion commit, which also held the attested declarations' deletion, since moved to a
  later piece): the sort's seven mutants (equal lanes counted, `<=` for `<`, the prefix sum's carry, a scan step, the
  last pass, the register sort's bound, the carry's lane) are killed by test-bindings; b3 (no undo base) by test-checker.
  b1, b2 and b4 didn't build (a variable left unused) and were rewritten.
- `results-2.txt`: b1 (uses counted as restores) killed; b2 (no file activation's point check) survived, and so the
  tests commit gains a fixture (a file-scope activation past a body's opening leaves the body without a span), which
  kills it (`results-3.txt`); b4 (`<=` for `<` against the span's end) survived and is equivalent: an end equal to the
  slice's length is unreachable by every event in it, as no end is, so `b4b` (`< end - 1`) replaces it and is killed;
  r1 (the reader's answers without their lists) survived and is equivalent: without lists the passes visit every event,
  the fallback for a reader with no scratch, and give the same answers, more slowly.
- 18 mutants, 16 killed, 2 equivalent.

## Local checks (`local/`)

- `area-*-status.txt`: every block of `tools/ci/correctness.tests` that names the area's runners (41, `area.tests`),
  through `compiler parallel --jobs 4` with CI's clang 23.1.4: all pass, the four frozen-corpus blocks with
  `BUSTER_CORPUS` set to a copy of the 9700X's corpora.
- `sanitizers.sh`: the area's runners under MemorySanitizer, AddressSanitizer (with UBSan) and UBSan builds.

`sanitizers-status.txt`: test-bindings, test-parser-bindings, test-environments, test-checker-deferred and test-checker's
8 parts under each of the three builds of the PR's head (36 runs): all pass.
