# Macro replacement-list classification on the Ryzen 7 9700X

The cached-word results below have a known mask-boundary defect. [Reduced input and correction](#correction-for-files-with-more-than-255-remaining-tokens)

The requested gate for `pp_define` includes short definitions, preparation and the complete preprocessor. The candidates below were applied separately to compiler `0a2c3034cf6093cda0f461e519ceb04484739259`. All timed runs used the shared exclusive lock and CPU 2. The scalar twin remains in the compiler.

**Per-directive summaries.** The directive table recorded the last position plus one of each of three tokens within a definition. The parser could test those positions against the actual replacement-list start, including when the formal parameters contained a special name. The table builder cached the source word so neighboring definitions could share its classification. The Clang oracle passed, and each corpus produced the same preprocessing output. Across three interleaved rounds the whole preprocessor took 3.74–4.44% more user cycles on Lua, 1.48–2.08% more on SQLite, and 1.77–2.64% more on musl. [Candidate](prepared-candidate.patch)

**Direct one-token classification.** A one-token replacement list compares its kind with all three relevant kinds at once. In a single executable, selected by hard links, the old vector, scalar, candidate and repeat-vector control all produced identical output and diagnostics. Against scalar, the median of five round ratios was −0.32% on Lua, −0.01% on SQLite and +0.22% on musl. Against the old vector path, the changes were +0.02%, −0.00% and −0.42%, respectively. [Candidate](single.patch)

**File-wide absence proof.** The refiner already loads token kinds and interned identifier IDs. It records whether any logical-line interior contains `#` or `##`, or any identifier is `__VA_OPT__`. A file with none can skip replacement-list validation for those operators on every definition. This version includes the one-token vector comparison for files that need the scan. The full Clang preprocessor oracle, C17/C23 fuzz and refinement fixtures passed. Stdout and stderr were identical for each corpus. The five whole-preprocessor rounds ranged from −1.53% to −1.13% on musl, −0.01% to +0.26% on Lua, and −0.59% to +0.64% on SQLite against the baseline executable. SQLite's candidate exceeded its repeat-baseline control in every round. [Candidate](filter.patch)

**Per-size measurement.** Build `micro.c` with the pinned Clang at `-O3 -march=native -Wall -Werror`. Run `taskset -c 2 ./a.out` under the lock three times. Each run checks 444 layout/length/spacing cells, with nine rotations per cell. It includes all lengths 0 through 65 and boundary lengths through 257. The prepared arm includes building and reading the per-directive summaries. Across three runs it matched or beat scalar in 242–247 of 444 cells. An exploratory 16-lane direct scan won for one-token inputs in all three layouts and lost in longer cases. The benchmark excludes parsing and preprocessing, which the whole-driver tests cover. The production driver only calls the scanner for nonempty bodies. [Harness](micro.c)

The corpora and flags are those of the campaign's single-lane C driver. The `single-corpus` and `filter-corpus` scripts record the exact commands on the shared machine. The archive includes the per-size samples, complete timing tables, checksums, diagnostic files and oracle logs. [Measurement files](measurements.tar.xz)

## Ordinary definitions and the diagnostic slow path

A fourth candidate keeps diagnostics for special operators out of the ordinary definition path and classifies one-token bodies directly. Five rounds of five locked, pinned runs used one executable with four invocation names. Each run kept the compiler options and corpus fixed. The median candidate/scalar changes were −0.466% on Lua, −0.476% on SQLite and +0.105% on musl. Corpus stdout and diagnostics agreed across all four arms. The Clang preprocessor oracle passed, including both sets of 64 fuzz cases.

The size fixture preprocesses 256 distinct definitions in each input and expands every sixteenth definition. It covers body lengths 0 through 65 plus 95–97, 127–129 and 255–257 where the syntax allows. Five runs per arm rotate arm order with size. Identical preprocessing output and empty diagnostics were required for every fixture. The candidate matched or beat scalar in 57/75 literal, 53/74 parameter, 26/73 stringize, 29/72 paste and 19/71 variadic-optional cells. Its 184 wins across 365 cells leave the per-size gate open.

The archive supplies the patch against the baseline above, the same-image instrumentation, fixture generator, driver, raw timing tables, per-input output digests and oracle summary. Apply the patch in a clean checkout, run the instrumentation there, build native Release and create hard links named `pp-marks0`, `pp-marks1`, `pp-marks2` and `pp-marks4` for old vector, scalar, candidate and repeat control. [Marked-definition experiment](marked-fixtures.tar.xz)

## Replacement-list event masks

The candidate marks `#`, `__VA_OPT__` and relevant parentheses in blocks of 16 tokens. Ordinary replacement tokens require no per-token visit during validation. The compiler baseline was `0a2c3034cf6093cda0f461e519ceb04484739259`. To reproduce, apply `marked.patch`, run `events.py` followed by `events-bench.py`, build Release, and use `events-qualified-run`. Its four executable names must live under `build/` so the preprocessor locates its resource headers.

The 9700X results against scalar were optional 65/71, paste 19/72, stringize 70/73, parameter 48/74, literal 59/75. Each comparison uses median whole-preprocessor user cycles across five repetitions. For the untouched application corpora the median of five rounds was -0.447% on Lua, -0.121% on SQLite and +0.097% on musl. All outputs matched. Both the marked and event versions passed the preprocessor suite, including the Clang comparisons and fuzz cases. The remaining size losses keep this candidate experimental. [Candidate, shape generator, exact cycles and oracle receipts](replacement-events.tar.xz)

## Cached body words and file-wide replacement facts

The first implementation caches the hash, paste and optional-identifier masks for the most recently classified 64-token word. The second also carries two facts from token refinement into definition processing. Files without an optional replacement token can skip the identifier comparison. Both retain vector classification for the general case.

The first five columns count body sizes at which the candidate matched or beat scalar in whole-preprocessor user cycles. The application columns give the median paired change across five rounds of five runs. The file-facts comparison uses separate production builds so the measured command pays the cost of producing the facts. The cache-only comparison selects the implementation in a common binary. All 365 output comparisons and both Clang-backed preprocessor suites passed. Each implementation still lost at individual sizes. [Reproduction, exact cycles, digests and oracle receipts](cached-body-words.tar.xz)

| Candidate | Literal | Parameter | Stringize | Paste | Optional | Lua | SQLite | musl |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| cached | 37/75 | 43/74 | 72/73 | 34/72 | 68/71 | -0.380% | -0.123% | -0.007% |
| facts | 0/75 | 1/74 | 53/73 | 0/72 | 49/71 | -0.804% | +0.033% | +0.006% |

## Preparing body marks with directive records

This candidate computes the paste, stringize and optional-identifier marks when preparing each directive, alongside its kind. Macro definition processing reads the resulting byte. The benchmark uses separate production builds and charges the candidate for preparing the marks. Each cell compares five whole-preprocessor runs on 256 generated definitions, including 16 expansions. The three complete application comparisons each use five balanced rounds of five processes. All 365 output and stderr comparisons and all 419 Clang-backed fixtures passed.

| Candidate | Literal | Parameter | Stringize | Paste | Optional | Lua | SQLite | musl |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| directives | 0/75 | 0/74 | 54/73 | 0/72 | 49/71 | +2.239% | +0.692% | +1.707% |

Individual sizes still lose to the scalar definition scan. [Patches, exact timings, digests and tests](directive-body-marks.tar.xz)

## Proving the optional macro spelling absent

The cached event implementation also checked whether the token source could contain the literal spelling of the optional-argument operator and whether escapes or trigraphs might synthesize it. A file without either possibility can skip reading the full token identity column for that operator. The native sweep retained the independent output and stderr comparisons at all 365 shapes and sizes. The complete Clang-backed preprocessor suite passed 419 fixtures. Each corpus timing uses five paired rounds of five processes per build.

| Candidate | Literal | Parameter | Stringize | Paste | Optional | Lua | SQLite | musl |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| spelling | 0/75 | 0/74 | 37/73 | 0/72 | 40/71 | +1.719% | +0.329% | +3.302% |

The remaining losses keep the definition-body scalar path in place. [Sources, exact size timings, output digests and checks](spelling-body-marks.tar.xz)

## Correction for files with more than 255 remaining tokens

The cached replacement-word prototype used the token count remaining in the file directly as the index for BZHI. The instruction reads the low eight bits of that index. At 256 remaining tokens it produced an empty mask, even though all 64 token slots in the word were live. The directive-marks and spelling variants inherit this expression. Their prior timing tables describe implementations with this correctness defect.

A native test put an invalid paste at the start of a macro body and varied the number of following literal tokens. Clang and the production scalar path diagnosed all 26 inputs. The cached prototype silently accepted eight, for 252–255 and 508–511 padding tokens. The corrected expression uses a full mask whenever at least 64 tokens remain. [Exact inputs, both diagnostic streams, reproduction driver, fix and exit statuses](body-mask-boundaries.tar.xz)

Three boundary diagnostics were checked at all 26 padding lengths on the corrected build. All 78 cases matched Clang’s exit status and the production compiler’s complete output and diagnostics. [Driver and per-case results](corrected-boundaries.tar.xz)

## Sharing a bounded token-event mask between definitions

Each 64-token cache word records the union of pastes, stringizes and optional-argument identifiers. The input bound uses all lanes when at least 64 tokens remain. The scalar and candidate produced identical output across five shape families and the three corpora. The patched compiler passed all 419 preprocessor fixtures and the independent boundary tests above.

Against the scalar path the candidate reached parity on 300/365 individual sizes. Ordered by literal, parameter, stringize, paste and optional-argument bodies, the counts were 51/75, 63/74, 72/73, 47/72, 67/71. The medians over five pairs of five whole-compiler runs were -0.336% on Lua, -0.018% on SQLite and -0.605% on musl. The remaining losses keep this version experimental. [Patch, exact cell results, corpus samples, output digests and oracle](bounded-body-events.tar.xz)

## Publishing a validated definition in one write

On main `cc7d4ffb4`, the bounded event classifier wrote the completed macro directly into the expandable macro array and compared a single packed file/word cache key. The Clang oracle, expanded output, diagnostics and exit status agreed. The table reports per-shape counts of five-run medians at parity or faster and median paired whole-corpus user-cycle changes against scalar. The 58 losing sizes keep this candidate below the per-size gate.

| Form | Literal | Parameter | Stringize | Paste | Optional | Lua | SQLite | musl |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| publish | 54/75 | 63/74 | 71/73 | 51/72 | 68/71 | -0.375% | -0.055% | -0.625% |

[Per-size results, corpus controls, production patch and reproduction drivers](published-macro-records.tar.xz)

## Validating replacement operators and publishing known definitions

All three variants used native Release builds on the 9700X and matched the macro outputs and diagnostics across the five sweep families, the three corpora and the Clang-backed preprocessor suite. The operator variant recognizes valid one-parameter stringizing and simple optional expressions while scanning. The publication variant also sets the known live macro directly and filters diagnostic-history lookups. The table counts five-run process medians that meet the scalar cost at each length. Its final columns give median paired changes in whole-corpus user cycles over five rounds.

| Candidate | Literal | Parameter | Stringize | Paste | Optional | Lua | SQLite | musl |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Index 64 directives | 52/75 | 50/74 | 70/73 | 33/72 | 67/71 | +0.873% | -0.005% | +0.168% |
| Validate operator operands | 30/75 | 44/74 | 73/73 | 34/72 | 71/71 | -0.351% | -0.102% | +0.113% |
| Publish known live definitions | 54/75 | 60/74 | 73/73 | 54/72 | 71/71 | -0.319% | -0.141% | -0.621% |

The publication implementation met the end-to-end limit in 312 of 365 cells. The separate 21-pass definition-only measurement met it in 351 cells, including all literal, stringizing and optional-expression lengths. Five parameter lengths and nine paste lengths remained slower in that measurement. The scalar route remains in production.

[Source changes, per-size counters, corpus results and oracle logs](definition-publication-and-operators.tar.xz)
