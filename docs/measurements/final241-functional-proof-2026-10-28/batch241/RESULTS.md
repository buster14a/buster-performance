# Final private functional batch: exact source scopes

The original production freeze is `4349d8fd1a8b5be358669b89b08e80e38a68b7bc`,
tree `641cb71f0fe8a5bffcd62b210323b2efa950ac2f`. It includes the main-241 and
PR-678 pins and the publication source heads recorded in `README.md`. It
excludes unqualified #665 and #628 bulk-fill `95be46e6`. Later public branch
merges were not chased. No published branch, PR or host setting was changed.

Both complete release builds passed all 41 units. Native and generic builds
ran sequentially in separate checkouts with `BUSTER_DEBUG_INFO=0`; generic used
`BUSTER_HOST_ARCH=x86-64`. Each build and test used its own `cores -n 2` grant.
Clang is 23.1.4. The original binaries remain at their original checkouts:

| Binary | SHA-256 |
| --- | --- |
| `work/final-batch-241/build/compiler` | 2b9e6efa748b1a7880c7ab771837170c1cb988c2404d88eb92fe6b05dac43eaf |
| `work/final-batch-241-generic/build/compiler` | e547380a27e4a13175b677871f91b9f6866dd6cc2bd2ba63584d79d085f29596 |

The nine originally planned functional commands all passed at that freeze:

| Suite | Native | Generic |
| --- | --- | --- |
| Full checker, seed 241, Clang | 488,854 checks / 0 failures | 491,637 / 0 |
| Driver, exact executable, Clang | 21,660 / 0 | 21,660 / 0 |
| Deferred reader | 80 fixtures, 1,423 checks / 0 | 80 fixtures, 1,423 / 0 |
| Emission lanes, seed 241, default 6 generated programs | 3,199 / 0 | 3,191 / 0 |
| Preprocessor, Clang, seed 241 | 1,500 C17 + 1,500 C23 fuzz cases; 0 differences, 0 without results | same |
| Parser, Clang | passed | passed |
| Streaming, seed 241 | 188 / 0 | 188 / 0 |
| Lane partition/sync, seed 241, 128 rounds | 1/2/3/8 lanes: 13 part inputs each, 0 wrong | same |
| Tier 0, seed 241, Clang cross-check | 268,445 / 0 | 268,427 / 0 |

The deferred suite read 29,580 bodies apart and completed 804 merges in each
mode, including the new retained-arena/poisoned-reuse, delayed-first-lane,
grouped-parts, replay fallback and allocation-failure cases. Emission lanes
explicitly printed backend startup 150/0 and worker-budget protocol 204/0 in
each mode. Driver coverage includes 1,600 dense warning-order comparisons and
reusable/terminal cleanup. Raw suite logs may contain expected diagnostics
from negative fixtures; the command status and final counters are retained.
Run-time numbers printed by some functional tests are not performance claims.

## Added ASM check and preserved negative

The dedicated `test-checker-asm --clang clang` was added after the original
matrix to exercise nullable-column capacities and malformed assembly inputs.
It passed **1,010/0 native**, but returned **1,010/2 generic** at `4349d8fd`.
The two failures are preserved in `generic/asm.log` and `generic/asm.status.txt`.
The original freeze is therefore not described as an unconditional all-suite
pass.

Both failures were the new empty-column test's storage-presence assertion.
The loop requested `scalar == false`, but current PR #678's corpus wrapper
passes `BUSTER_SCALAR_PATH(scalar)` and initializes the actual generic parser
with `parser.options.scalar == true`. Production correctly retained the dense
scalar ASM-ID oracle. The test compared storage to the loop's request instead
of the actual selected parser mode. ASM statement counts, keyword capacities,
marked IDs and sentinel traversal all passed.

## Single-assertion correction

Private correction `a07682fe6c31cdf5329a7601d2074f907e407341`, tree
`27e34f2d71f6d67bd77fef031bd02d566a599463`, changes only
`c_check_asm_test.c`'s presence predicate from `scalar != 0` to
`parser.options.scalar`. The statement condition and count, capacity, mark and
sentinel assertions are unchanged. No production code changes. The one-file
patch is `asm-parser-mode-fix.patch`; its private checkout is
`work/final-batch-241-asm-contract`. Both original source trees and binaries
remain unchanged.

Original C adapters compile the corrected production sources in native and
generic modes. `make-standalone.c` retains exact main.c text and notices,
emptying only `BUSTER_ELSEWHERE` to link module entry points in one translation
unit. The unused renamed driver is discarded by linker garbage collection.
`asm-expectation-diagnostic.c` prints requested mode, actual parser mode,
column presence, capacities, counts and marks. It evaluates both predicates
and then invokes the complete original ASM suite with the one-line correction.
Build/run commands, exit statuses, generated source and hashes are retained.

| Corrected-source focused run | Native | Generic |
| --- | --- | --- |
| Six actual-production routing cases, original predicate failures | 0 | 2 |
| Same six cases, corrected predicate failures | 0 | 0 |
| Complete ASM suite | 1,010 / 0 | 1,010 / 0 |

The generic counterfactual rows are exact: plain source requested 0, actual
parser 1, ASM column present, count/capacity/marks 0/0/0; label-only source
requested 0, actual parser 1, column present, count/capacity/marks 0/1/0. Both
old predicates fail and both corrected predicates pass. The statement source
retains its column, count 1, capacity 1 and nine marked IDs in every mode.
Native requested and actual parser modes agree, preserving nullable storage
for its two non-statement sources and the dense requested-scalar oracle.

The nine broad suites were not repeated on the new test-only commit: they
remain exact-binary results at `4349d8fd`, while the corrected ASM results are
focused-source results at `a07682fe`. This distinction is intentional. Root
owns any later public compatibility companion and its separate CI.

All raw receipts are retained. This batch establishes functional composition
under these pins, not a new performance result, a public latest-head result,
or acceptance of any excluded experiment.
