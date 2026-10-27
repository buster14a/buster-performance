# Record name validation, #614 — 2026-10-27

This record qualifies [Buster #614](https://github.com/buster14a/buster/issues/614),
implemented by [PR #633](https://github.com/buster14a/buster/pull/633).
The comparison isolates definition-time namespace validation with
`--lanes 1 -fsyntax-only`; it does not include ABI preparation or lowering.

Base source: `92c025e71856d13eb34247477c5294d2cead139e`.
Candidate source: `fee24515606be3e79e30b55976cf251109fd6016`.
The candidate initializes its name table from direct members, grows it only
when anonymous expansion fills half its slots, and grows its explicit stack
with actual anonymous depth. Named aggregate fields expose only their own name.

## Results

Normal comparison, 14 fresh-process observations per build/input, all status 0:

| Input | Base wall, ms | Candidate wall, ms | Base again wall, ms | Base instructions | Candidate instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| Nested / 2,000 | 3.100 | 2.079 | 2.400 | 21,818,268 | 17,813,300 |
| Nested / 4,000 | 5.550 | 3.517 | 5.621 | 51,404,168 | 35,566,440 |
| Nested / 8,000 | 13.928 | 5.654 | 13.913 | 132,776,144 | 69,824,704 |
| Frozen SQLite | 118.597 | 118.164 | 118.554 | 1,195,018,269 | 1,195,000,049 |

At depth 8000 the candidate uses **59.4% less wall time and 47.4% fewer user
instructions**. Its wall range is 5.575–5.732 ms, versus the base's
13.825–14.365 ms; the second base median differs by -0.11%. Depth 4000's
candidate median is 36.6% lower, with the second base +1.28%. Candidate
instruction counts approximately double as depth doubles over the measured
range. Removed instructions grow approximately fourfold with each doubling
(4.00, 15.84 and 62.95 million), consistent with removing the repeated
token-span-sized clears.

The depth-2000 control has substantial wall variation: the second base median
is 22.6% lower than the first base. Do not read a precise latency improvement
from that smallest case. Its instruction reduction is 18.4%.

SQLite saves only 18,220 instructions (0.0015%). Its -0.37% wall difference is
small and this is one code placement, so **no SQLite timing improvement is
claimed**. Peak RSS is essentially unchanged: depth 8000 is 57,656 -> 57,600 KB
and SQLite 490,212 -> 490,288 KB. `normal.csv` and `round-1.log` retain the
medians, ranges, counters, resource use and every individual measured process.

After 200 ms of lighter scalar work before each timed process, six observations
per build/input, all status 0:

| Input | Base wall, ms | Candidate wall, ms | Base again wall, ms |
| --- | ---: | ---: | ---: |
| Nested / 2,000 | 3.157 | 2.101 | 2.803 |
| Nested / 4,000 | 5.735 | 3.594 | 5.807 |
| Nested / 8,000 | 14.047 | 5.699 | 14.030 |
| Frozen SQLite | 118.195 | 117.971 | 118.165 |

The depth-8000 wall reduction is 59.4% in this state too, with approximately the
same instruction counts as the normal comparison. The small-case control
variation remains visible and SQLite's small wall difference is not a timing
claim. `conditioned.csv` and `round-4.log` retain the complete results.

## Method and identities

`host.txt` identifies the approved AMD Ryzen 7 9700X, Clang 23.1.1, Wild 0.10.0,
glibc 2.44 and Linux 6.18.50-2-lts. Each source was built with its unchanged
`BUSTER_DEBUG_INFO=0 ./build.sh`: `-O3 -march=native`, `-fwrapv`,
`-funsigned-char`, `-fno-strict-aliasing`, `-Wall -Werror`, no debug information.
Each build, checker run and measurement command takes the shared
`~/buster-fast-bench/exclusive.sh` lock separately. Measurements pin the complete
parent/child process tree to CPU 2; its governor and EPP are `performance` and
its SMT sibling, CPU 10, is offline. No machine settings were changed.

`base-source.sha256` and `head-source.sha256` cover all tracked source-tree
files at the named commits. Their target-host check logs verify the transferred
trees. `inputs.sha256` checks the included generator and generated sources.
`identities.sha256` also records the external binaries and frozen SQLite, using
their original target-host path labels; those binaries and SQLite are not
included. The benchmark runs the
candidate's retained C `time-runs` implementation, which is unchanged from base.

`run-measurements.sh` is the complete invocation glue. It first requires a
successful full target `test-checker`, under its own lock. The normal comparison
runs seven fresh processes per input, executable and copy, following one
warmup per slot. There are two fresh physical executable copies per build in
each comparison, with equal-length paths. The builds are base, candidate and the
same base again as an A/A control; argument-list and build order rotate.
A conditioned comparison uses three runs per copy with 200 ms of lighter scalar work
before each timed process. Each comparison acquires and releases the lock itself.
The qualified conditioned comparison can queue independently by passing
`conditioned`; the two comparisons may run in either order. The shell requires
successful measured exit statuses; `time-runs` also requires
each slot's statuses to match its warmup and reports failed processes.

`summarize.c` reduces only complete, successful, counted raw process rows.
Normal results use `round-1.log` (14 observations per build and input);
conditioned results use `round-4.log` (six observations). Medians use the upper middle
observation, as `time-runs` does. Wall times in the raw text have 0.001 ms
resolution. Reproduce the reduction with:

```sh
clang -std=c17 -O2 -Wall -Wextra -Werror summarize.c -o summarize
./summarize round-1.log > normal.csv
./summarize round-4.log > conditioned.csv
```

The unchanged `generate.c` is retained from
[`buster-performance` at `7d25666880d5bbdce838bab7e0f79a31d70d4c78`](https://github.com/buster14a/buster-performance/blob/7d25666880d5bbdce838bab7e0f79a31d70d4c78/docs/measurements/performance-audit-2026-10-27/generate.c).
Inputs are exactly `./generate nested N` for N = 2000, 4000 and 8000; each record
introduces one direct name. The fourth argument list is the host's frozen
SQLite amalgamation, with the exact options and frozen header paths in the
script. No SQLite or header source is incorporated here.

## Correctness and limits

The committed direct namespace regressions cover colliding identifier IDs,
multiple table and stack growth boundaries, anonymous structs/unions and aligned
wrappers, empty namespaces, unnamed bit-fields, duplicate ownership, invalid and
incomplete anonymous types, and every byte of bounded scratch capacity.
`record-name-test.c` is an original small adapter that compiles those exact
committed tests and production namespace routine with only the reader fields
that routine uses. It passes 4,142 checks normally and with ASan/UBSan locally.
Substituting the original routine causes the two intended bounded-space
regressions to fail. This is focused sanitizer coverage, not a whole-compiler
sanitizer claim. `local-host.txt` identifies that Clang 23.1.4 / Ryzen 9 7940HS
validation environment.

From this record directory, with the named source commits checked out as
`/path/to/candidate` and `/path/to/base`, the focused commands are:

```sh
clang -std=c17 -O1 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror -I/path/to/candidate/src record-name-test.c -pthread -o record-name-test
./record-name-test
clang -std=c17 -O1 -g -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror -fsanitize=address,undefined -I/path/to/candidate/src record-name-test.c -pthread -o record-name-sanitized
./record-name-sanitized
clang -std=c17 -O1 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror -I/path/to/candidate/src '-DBUSTER_RECORD_INPUT_SOURCE="/path/to/base/src/buster/compiler/c_check_record_input.c"' record-name-test.c -pthread -o record-name-mutant
./record-name-mutant
```

The first two runs exit 0 with 4,142 checks and zero failures. The original-routine
mutant exits 1 with 4,142 checks and two failures, retained in the corresponding
logs.

Both production compiler paths accept the valid layout fixtures and generated
nesting depths through 8000, and reject the duplicate fixtures on Clang-matching
first-error lines. Clang independently accepts depth 256 locally. No independent
Clang acceptance at depth 8000 is claimed. The full local checker reports four
floating-point oracle mismatches, recorded in `local-checker.log`. The approved
9700X's pinned Clang 23.1.1 run passes all 269,711 full checker checks with zero
failures (`checker-9700x.log`), before any measurements are admitted.

These are synthetic nesting stress inputs and one broader SQLite control, not
evidence of corpus-wide frequency or a universal compile-time speedup. Each tree
has one code placement; fresh copies and the second baseline expose part of the
noise but do not replace a placement campaign for small differences. Instruction
counts are not wall time. The conditioned round is a separate observation, not
pooled with normal runs.

Raw `time-runs` stdout and own checker logs are retained. Build logs retain only
their own `build.sh:` lines, excluding other sessions' lock-wait metadata.
The original record-validation changes, fixtures, generator, adapter and
invocation/reduction glue use Apache-2.0 WITH LLVM-exception. Existing Buster
modules used by the adapter retain their documented component terms.
Clang is an external semantic oracle;
no external compiler implementation or fixture corpus was copied.
