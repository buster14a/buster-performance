# Type-name prototype parameter names (#604)

Compiler issue: https://github.com/buster14a/buster/issues/604.

Reference: `buster14a/buster` at `92c025e71856d13eb34247477c5294d2cead139e`.
Candidate: `e9e8e8cae93f741369d23e193b33bffaa7b4ddd4` (implementation introduced
at `3303fa3d8ffff6bc811e2ad4e39daae3015a0c30`; follow-ups only adjust fixtures).
The first timing build uses `e202ce3496eeda1dc693d46c790ca601bd3b016b`;
the production sources are byte-identical to the final candidate.
The source hashes and `implementation.diff` identify the exact implementation
and tests. Subsequent compiler documentation changes do not change these sources.

## Algorithm and isolated work

The candidate retains one digital search tree per prototype, rooted in its
existing declarator part and stored in its parameter records. Links are record
index plus one; zero is empty. An insertion compares a previous name and follows
one low-to-high name bit at each unequal record. Consequently at most 32 unequal
records are visited; an equal name at depth 32 can add one final comparison.
The root is local to the prototype, including nested/sibling prototypes.
Unnamed parameters do not enter the tree. No hash table, identifier-sized clear,
new allocation or batched diagnostic reordering is introduced.

The part remains 40 bytes after field packing. Parameter records grow from
12 to 20 bytes. The existing scratch reservation is one parameter record per
token in the bounded type slice, so its reserved peak grows by eight bytes per
slice token; only actual appended records are initialized.

`generate.c` extracts the candidate structs and helper directly from the named
source revision to `parameter-tree.inc`, adding only `visits += 1` inside its
loop. `work-count.c` uses it on consecutive nonzero intern IDs starting at 1024
and runs the removed linked-record scan separately. This isolates duplicate
membership work from parsing, binding and type interning. These are controlled
kernel counts, not instrumented whole-compiler counts or timing evidence.
The zero-name control makes no membership visits in either algorithm.

| Parameters | Reference visits | Candidate visits |
| ---: | ---: | ---: |
| 256 | 32,640 | 1,546 |
| 512 | 130,816 | 3,595 |
| 1,024 | 523,776 | 8,204 |
| 2,048 | 2,096,128 | 18,445 |
| 4,096 | 8,386,560 | 40,974 |

The reference grows quadratically; this family has approximately P log P tree
work, with the fixed 32-bit bound also guaranteeing linear worst-case work.
Source-order insertion and dependent tree edges stay scalar. Vectorizing the
old all-prior-name comparison would retain quadratic work; the complete scalar
and vector source readers compare the replacement's semantics independently.

## Local correctness

The local host is Ryzen 9 7940HS with Clang 23.1.4. Its measurements are not
used as Zen 5 timing evidence. The build passes with `-Wall -Werror`.
`constant-corpus.log` records 43 generated real C cases: named/unnamed prototypes
at 256, 512, 1024, 2048 and 4096 parameters, early/late duplicates at each count,
both as function-body queries and as declaration-time enum initializers,
2048 small prototypes reusing the same two names, restoration of an outer
typedef after a nested prototype, and a duplicate before a later invalid
declaration. Clang accepts 22 and rejects 21; both checker paths agree with
Clang on every acceptance and first
error line, agree with each other, and report zero resource failures.

`tree-test.inc` extracts the repository's guarded independent-membership fixture.
`guard-test.c` runs it with ASan and UBSan. All 1,026 assertions pass, including a
chain exercising bit 31, a full-depth duplicate, zero names, interleaved scopes,
and records ending at a `PROT_NONE` page. This is focused helper sanitizer
coverage, not a whole-compiler sanitizer qualification.

The initial broad local run is retained as `local-checker-initial.log`: 266,980
checks with six failures. Two assertions came from an overly strong new test
that expected a duplicate's line before an invalid parameter on the next line;
the compiler's existing diagnostic selected line 2, while Clang selected line 1.
The final fixture checks ordering before a subsequent invalid declaration,
which both already diagnose alike. The four other failures are the local
Clang 23.1.4 fpclassify conditional/known-category oracle probes. This local
run is not reported as a passing checker suite.

## Reaching the affected reader

The issue's function-body `return sizeof(int (*)(int p0, ...))` reproduction
uses the ordinary declarator reader rather than `check_constant_type`. Its
reference and candidate instruction counts are already linear. The primary
family here instead uses `enum { A = sizeof(int (*)(int p0, ...)) };`, which
reaches the declaration-time reader containing the removed scan. The permanent
wide prototype regressions likewise use enum initializers; the body query is
retained as a separate source fixture and control.

`timing-1.log` is an excluded setup run. It measured the body-query controls,
and its SQLite command mistakenly included Clang's `--no-default-config`,
which the compiler's default command rejects. Its SQLite processes exited 1,
although `time-runs` accepted their consistent warm-up status. `summarize.c`
requires every timed process to exit zero and rejected the entire log.
No performance result is taken from this run. The corrected campaigns use
declaration-time families and run successful baseline/candidate SQLite
preflights before timing, with the Clang-only option removed.

## Locked Ryzen 7 9700X results

Clang 23.1.1, glibc 2.44, `BUSTER_DEBUG_INFO=0 ./build.sh`, `-march=native`
(`znver5`). Each build, qualification command and timing campaign acquired the
shared `exclusive.sh` lock. Timing parents and children were pinned to CPU 2;
its governor and EPP were `performance`, and sibling CPU 10 was offline.
`host.txt`, `binaries.sha256`, the build logs and command files retain identities.

`timing-2.log` is the ordinary campaign on the first candidate image. `timing-3.log`
uses the final image and 100 ms of untimed scalar work before every timed child.
Each has 17 rotating passes, two warm-ups and two identical executable copies
of each build. Every one of the 1,632 timed processes exited 0. `timing.csv`
contains the tool's per-copy medians, parsed by the original `summarize.c`.
The ranges below are the two copy medians, not confidence intervals.

| Parameters | Named base, ms | Named candidate, ms | Unnamed base, ms | Unnamed candidate, ms |
| ---: | ---: | ---: | ---: | ---: |
| 256 | 1.151–1.612 | 1.039–1.244 | 0.872–0.901 | 0.862–0.876 |
| 512 | 1.086–1.104 | 0.934–0.945 | 0.865–0.873 | 0.860–0.873 |
| 1,024 | 1.641–1.697 | 1.064–1.064 | 0.912–0.914 | 0.902–0.911 |
| 2,048 | 3.682–3.726 | 1.333–1.376 | 1.043–1.057 | 1.042–1.051 |
| 4,096 | 11.274–11.408 | 2.009–2.091 | 1.416–1.446 | 1.426–1.470 |

These are whole `-fsyntax-only` processes, including startup, preprocessing,
parsing, declaration checking and cleanup. At 4,096 named parameters the
ordinary campaign improves 5.46–5.61 times in corresponding copies. After
scalar work it improves 5.15–5.33 times: 11.262–11.351 ms becomes
2.113–2.204 ms. Instructions fall from 85,350,132 to 18,825,036–18,825,037
(77.94% fewer). Full process time retains fixed and linear costs, unlike the
isolated name-membership counts above. The named/unnamed instructions for
every size and both states are in the CSV and raw logs.

| Control | Ordinary base, ms | Ordinary candidate, ms | After scalar base, ms | After scalar candidate, ms |
| --- | ---: | ---: | ---: | ---: |
| 2,048 small prototypes | 4.105–4.494 | 4.450–4.454 | 4.288–4.471 | 4.391–4.481 |
| Frozen SQLite | 116.068–116.880 | 116.018–116.467 | 116.578–117.107 | 116.215–116.540 |

SQLite timing is within the copies' variation; no whole-SQLite speedup is
claimed. The small-prototype control has nearly unchanged instructions and
overlapping wall-time ranges. Its base copies differ by 9.5% ordinarily and
4.3% after scalar work, so these samples do not resolve a possible few-percent
small-prototype cost. They do not establish zero overhead or an optimal kernel.

At 4,096 unnamed parameters, peak RSS rises from roughly 27,140 KiB to
29,220 KiB, about 2 MiB (7.7%), in both campaigns. The named 4,096-parameter
family stays near 31,600 KiB. SQLite's peak rises by about 128–188 KiB on its
483,340 KiB baseline (under 0.04%). The measured RSS cliff is recorded as a
cost; the reservation accounting alone is not used to explain its cause.

Final qualification at `e9e8e8cae93f741369d23e193b33bffaa7b4ddd4` is recorded
in `qualification-final.log`: all five commands pass, including `test-types`,
266,994 checker checks, 21,591 driver checks, 1,096 deferred checks and the
43-source Clang/scalar/vector corpus. The initial 9700X qualification log has
only the two assertions from the subsequently corrected ordering fixture;
the four local Clang 23.1.4 floating-oracle differences do not occur with the
target host's Clang 23.1.1. This is targeted source/type/driver qualification,
not full compiler, sanitizer or backend acceptance.

## Reproduction

`generate.c`, `work-count.c` and `guard-test.c` are original C tooling under
Apache-2.0 WITH LLVM-exception. The extracted snippets retain the same project
terms. The generated C inputs are original; Clang runs externally as an oracle.
No external implementation or fixture corpus was incorporated. Frozen SQLite
is an external runtime input and is not included here.

From this evidence directory, with `BUSTER` naming the candidate checkout:

```sh
clang -std=c17 -O2 -Wall -Wextra -Werror generate.c -o generate
./generate "$BUSTER/src/buster/compiler/c_check_constant.c" inputs
mv inputs/parameter-tree.inc parameter-tree.inc
clang -std=c17 -O2 -Wall -Wextra -Werror work-count.c -o work-count
./work-count
clang -std=c17 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall -Wextra -Werror guard-test.c -o guard-test
ASAN_OPTIONS=detect_leaks=1 ./guard-test
"$BUSTER/build/compiler" test-checker-corpus --clang /usr/bin/clang inputs
```

The 9700X's `exclusive.sh` must wrap each build, test and timing run there,
with `EXCLUSIVE_OWNER`, `EXCLUSIVE_TITLE` and `EXCLUSIVE_LINK` supplied.
Whole-process timings use Buster's existing `time-runs` command, fixed CPU 2,
rotating process order and its per-process counters, status and peak-RSS records.
