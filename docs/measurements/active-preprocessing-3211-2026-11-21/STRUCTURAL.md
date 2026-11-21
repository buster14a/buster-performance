# Source ranges under actual conditional execution

These experiments perform a source scan, omit raw ordinary rows, and prepare each deferred span only if the live file context enters it. The normal preprocessor evaluates its directives and includes in source order. Each accepted span is one complete ordinary region between two actual directives and has at least 4,096 physical bytes. Source admission rejects possible digraph directives, raw-literal openers, splice and UCN ambiguity, non-ASCII bytes and unfinished lexical constructs. The initial vector pass examines blocks of 64 bytes for physical directive candidates, with ordinary lexical checks over tentative spans. The real directive table must confirm the opening hash, ending hash, span position, and stand-in token. Unsupported language/input shapes take ordinary preparation. A fresh unit still owns its deferred data while shared header cache records keep their regular lifetime.

Two intermediate results exposed distinct source-location failures. The scalar structural prototype, raw2, used the first byte of each span as its stand-in. When that byte was a newline, the physical-line index and later `__LINE__` expansions changed. Vector3 preserves every physical newline. It reproduced SQLite's ordinary preprocessor output byte for byte after removal of directive marker lines, including all numeric constants, but its use of a generic expansion buffer changed marker placement around macro expansions. The passing file4 variant enters the original source file and range for the actual fragment, using original byte offsets for identifiers, literals, macro expansions and diagnostics. The rejected intermediate diffs and hashes are included to distinguish a token comparison from marker parity.

## Experimental implementations

Each source patch applies independently to Buster `875c08e9dd85c4c67bbe24a00e54bbe33f0890b5`. The file4 candidate uses an original-length source copy during preparation. Every admitted span is replaced by whitespace with all original newlines and one numeric stand-in. Runtime materialization uses only the corresponding original substring and the real lexer/refiner. Direct5 removes this source copy. Its normal window lexer stops after the confirmed opening directive, writes one internal stand-in, and resumes at the closing physical directive line. It retains the source's actual line index, and exceptional lexical boundaries fall back to the normal source. Cond6 uses the same physical jumps and additionally restricts speculative deferral to scopes containing a positive `#ifdef`, `#elifdef`, or `defined` test. This syntactic hint selects work to defer. Macro definitions, includes, tests and branch decisions still execute on the ordinary stream.

The complete file4 runs on frozen SQLite initially produce 663,239 raw rows including 377 stand-ins. Re-entering 276 spans from the live file produces 295,489 additional real rows. Relative to 1,166,437 ordinary primary rows, the compiler prepares 208,086 fewer real rows and interns 83,833 fewer identifiers. The 101 unentered ranges cover 1,522,764 source bytes. With six features enabled by flags, only 43 ranges stay unentered, saving 47,477 raw rows and 19,244 identifiers. The whole-program ordinary `-c` rate fell from 78.01 to 76.42 MB/s on the frozen configuration. Real fragment setup, extra scans, source copying, refiner work and additional working memory are all charged in the complete stage and wall results.

## Timed results

Each experiment has six rotating, mirrored three-arm rounds with a separate untouched parent, ordinary mode and the actual scheduling mode. Stage results include all preprocessing work in real single-lane compilation. External wall and throughput use the process that writes the object and the default page policy. The percentages are medians of within-round differences. See the per-experiment summaries for the six-round ranges.

| Experiment | Primary | Raw rows omitted | Names omitted | Spans entered / planned | Preprocess off → on (ms) | Paired change | Wall off → on (MB/s) |
|---|---|---:|---:|---:|---:|---:|---:|
| file4 | sqlite | 208,086 | 83,833 | 276 / 377 | 9.636 → 11.866 | +23.17% | 78.01 → 76.42 |
| file4 | features | 47,477 | 19,244 | 334 / 377 | 9.971 → 13.043 | +31.09% | 57.23 → 55.86 |
| file4 | shell | 28,261 | 10,923 | 34 / 43 | 3.880 → 4.380 | +13.05% | 33.99 → 33.37 |
| file4 | all-active | 0 | 0 | 0 / 0 | 0.812 → 0.857 | +4.86% | 41.19 → 41.23 |
| direct5 | sqlite | 208,086 | 83,833 | 276 / 377 | 9.619 → 10.912 | +12.86% | 78.07 → 76.95 |
| direct5 | features | 47,477 | 19,244 | 334 / 377 | 9.930 → 11.928 | +18.78% | 57.17 → 56.22 |
| direct5 | shell | 28,261 | 10,923 | 34 / 43 | 3.847 → 4.200 | +8.76% | 33.98 → 33.55 |
| direct5 | all-active | 0 | 0 | 0 / 0 | 0.812 → 0.835 | +2.71% | 41.19 → 40.84 |
| cond6 | sqlite | 201,466 | 81,151 | 2 / 94 | 9.377 → 10.175 | +8.84% | 78.24 → 77.50 |
| cond6 | features | 40,857 | 16,562 | 60 / 94 | 9.845 → 11.133 | +13.04% | 57.09 → 56.48 |
| cond6 | shell | 15,727 | 6,142 | 0 / 5 | 3.842 → 4.121 | +7.09% | 33.88 → 33.65 |
| cond6 | all-active | 0 | 0 | 0 / 0 | 0.808 → 0.841 | +1.25% | 40.78 → 40.79 |
| cursor7 | sqlite | 201,466 | 81,151 | 2 / 94 | 9.500 → 9.874 | +3.35% | 78.46 → 78.11 |
| cursor7 | features | 40,857 | 16,562 | 60 / 94 | 9.772 → 10.921 | +11.56% | 57.26 → 56.88 |
| cursor7 | shell | 15,727 | 6,142 | 0 / 5 | 3.830 → 3.921 | +1.61% | 33.96 → 33.93 |
| cursor7 | all-active | 0 | 0 | 0 / 0 | 0.859 → 0.828 | -1.78% | 41.09 → 41.01 |

## Source scanning and storage

The source-offset counter extracts the candidate scan from each listed compiler. Its top-level search covers all 9,507,037 SQLite bytes in 64-byte vectors. In file4 and direct5 the auxiliary lexical check processes another 4,795,745 logical bytes and admits 4,088,611 bytes. Cond6 checks 1,696,357 bytes and admits 1,481,497 bytes. The directive-line, leading-whitespace and condition-name probes are reported separately, including their overlap with the main scan. The next-byte lookahead of the lexical checker overlaps its current vector. The frozen and feature configurations have identical physical scan extents. Their different rows reflect actual macro and include execution. [Conditional scan extents](native/cond6-scan-extents.txt) · [Full-span scan extents](native/direct5-scan-extents.txt) · [Counter source](scripts/probe-structural.py)

For SQLite the primary range table reserves 55,728 bytes and initializes 9,048 bytes in file4/direct5 or 2,256 bytes in cond6. File4 additionally writes a whole 9,507,037-byte temporary copy. Direct5 and cond6 read the original source. The additional per-directive table reserves one pointer per real directive plus an end entry. Active fragment columns and file-data records remain live until unit cleanup. Every complete object timing includes stage/RSS, process resident high-water mark, faults and kernel/user PMU records. RSS includes compiler allocations outside preprocessing.

## Source and diagnostics

The scalar and vector buffer variants are rejected intermediates. Each passing native candidate has 45 comparisons across frozen SQLite, a feature variant, shell, all-active and preprocessor modes, 18 additional changing-include/edge comparisons and 15 rejected-arm/location comparisons. Each compares status, exact marker-bearing stdout, complete diagnostic text and locations, and complete object hashes for successful compilations. In a verified rejected input a false macro guard excludes 340,780 bytes while the compiler still emits the C23 extension warning at rejected-arm.c line 11754 and both malformed conditional errors at lines 11754 and 11755. An unterminated block comment or raw literal in a skipped diagnostic directive hides its apparent closing directive and produces the same unterminated-conditional error at line 751. Other inputs cover changed header macros, the line, counter and include-level builtins, raw strings, comments, alternative directive spellings, trigraphs and interrupted macro arguments.

File4 applied independently to [#2925](https://github.com/buster14a/buster/pull/2925) at `616174e3e0833af48af542be833b5ba0fc8889bb`. All 45 comparisons passed, including real marker-bearing `-C` and `-CC` output. Its SQLite comment modes use 377 deferred spans, of which 276 are entered. The compiler materializes the original comment-bearing fragments on that path. [Comment-mode receipts](native/cmfile4.tar.xz) · [Compatibility source patch](source/file4-comments-on-616174e3e.patch)

The user PMU measurements below come from two standalone `benchmark-preprocessor` invocations per arm, each reporting the median of 21 fresh-table production runs. Frozen SQLite produces 716,157 benchmark output tokens in all arms. The reported input-token count changes with the compact primary representation, so this comparison uses emitted tokens. The separate ordinary `-c` matrix includes object writing and later compiler stages. [PMU receipts](native/structural-standard.tar.xz) · [Methodology and scripts](README.md)

| Experiment | Input | Emitted tokens | First run off → on, user cycles/token | Second run off → on, user cycles/token |
|---|---|---:|---:|---:|
| file4 | sqlite | 716,157 | 63.68 → 80.55 | 64.01 → 79.96 |
| file4 | features | 980,321 | 49.86 → 64.22 | 49.84 → 64.40 |
| file4 | shell | 199,666 | 74.55 → 81.73 | 74.64 → 81.63 |
| file4 | all-active | 66,510 | 19.01 → 18.94 | 18.99 → 18.85 |
| direct5 | sqlite | 716,157 | 63.77 → 74.90 | 63.89 → 72.52 |
| direct5 | features | 980,321 | 50.34 → 58.54 | 49.68 → 58.50 |
| direct5 | shell | 199,666 | 74.45 → 79.70 | 74.85 → 79.37 |
| direct5 | all-active | 66,510 | 18.75 → 19.05 | 19.21 → 18.95 |
| cond6 | sqlite | 716,157 | 63.58 → 68.67 | 63.93 → 68.73 |
| cond6 | features | 980,321 | 49.78 → 55.61 | 49.90 → 55.70 |
| cond6 | shell | 199,666 | 74.78 → 76.64 | 74.49 → 76.94 |
| cond6 | all-active | 66,510 | 18.94 → 19.93 | 18.67 → 20.39 |
| cursor7 | sqlite | 716,157 | 64.07 → 67.59 | 64.61 → 68.07 |
| cursor7 | features | 980,321 | 49.90 → 55.28 | 49.86 → 55.42 |
| cursor7 | shell | 199,666 | 75.06 → 76.34 | 74.67 → 76.38 |
| cursor7 | all-active | 66,510 | 18.76 → 19.63 | 18.80 → 19.90 |

## Final range cursor

Cursor7 stores the raw index of the next deferred position in each file context and advances it only when a genuine conditional jump or ordinary run reaches that position. This removes the full per-directive pointer table from the previous candidates. The primary uses private mutable columns from the ordinary cache lane, leaving the shared source record immutable. Carriage-return detection is folded into the mandatory physical scan. The opt-in counters time planning separately using the native TSC. They execute in correctness runs outside the paired performance panel.

During the instrumented marker, warnings and object checks the directional planner took 0.932–0.958 ms on default SQLite and 0.932–1.072 ms with extra features, calibrated against a median invariant TSC rate of 3.792833 ticks/ns. The shell took 0.121–0.123 ms and all-active 0.018–0.026 ms. Some driver modes invoke the preprocessor twice. These standalone counts include initial access to the source and were collected outside the timed performance process. Subtracting them from whole compile times would mix different measurements.

[Range-cursor patch](source/cursor7.patch) · [Complete native timings and correctness](native/cursor7.tar.xz) · [Source scan extents](native/cursor7-scan-extents.txt) · [TSC calibration](native/tsc-rate.txt)

[Masked-source experiment](source/file4.patch) · [Direct source jumps](source/direct5.patch) · [Optional-scope scheduling](source/cond6.patch) · [Raw file4 samples](native/file4.tar.xz) · [Raw direct5 samples](native/direct5.tar.xz) · [Raw cond6 samples](native/cond6.tar.xz)
