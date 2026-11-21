# Reusing node depths between the parser's vector passes

The parser’s second bracket pass (K1) stores a 32-bit node depth per token. Before constructing precedence parents, K4 reads that column to find whether any node exceeds its eleven-bit key. K4 then narrows each group of 64 depths to form precedence keys. K6 computes another set of relative depths and a block range to validate syntax.

Three implementations on `1dccf51a7cbb4b73690d7feb359b34ccb6142fdf` explore these repeated reads. The first recovers relative depths from the upper three bits of existing K4 precedence keys when a block has a depth span of at most six. Wider blocks keep the full-width path. The second makes K1 publish one 72-byte record per block, containing 64 relative bytes and the exact minimum and maximum. Both K4 and K6 can read it. The third keeps the original K4 keys and accumulates high bits during the existing K1 depth stores. K4 can use that predicate directly when choosing its wide fallback. Its final partial block includes only live tokens.

## Agreement with the full depth column

An evidence-only executable independently scanned every live 32-bit depth in each block to recover its range. It checked both endpoints from the K1 record and each of its relative byte answers where K6 admits the span. It also decoded each stored K4 key where K4 admitted the block. Every live lane that the corresponding reader would use matched. For an entire unit beyond K4’s maximum depth, K4 uses its scalar parents path and the tally puts every block in the wide column.

| Input | Translation units | Tokens | Narrow K4 blocks | Wide K4 blocks | Differences |
| --- | ---: | ---: | ---: | ---: | ---: |
| Nested boundary fixture | 1 | 9,284 | 0 | 146 | 0 |
| SQLite | 1 | 716,136 | 11,008 | 182 | 0 |
| Lua | 34 | 571,543 | 7,475 | 1,473 | 0 |
| musl | 1,336 | 5,039,561 | 74,215 | 5,158 | 0 |
| Buster compiler main | 1 | 2,434,443 | 37,613 | 426 | 0 |

The range check in the syntax kernel admits differences up to 63. All blocks in these inputs fit. The boundary fixture includes a depth of 2,100, which sends its complete TU to K4’s scalar path. The ordinary parser tests separately force K6’s block fallback periodically and compare its flags and classes. The native Clang suite also passed 557 snippets, 2,000 generated streams and the compiler source. Its main had 2,434,448 tokens with the local host predefines. The locked replay above used the fixed Zen 5 predefines.

## Ordinary compiler and parser measurements

Every run used the frozen 9700X and CPU 2 under the shared lock. The initial SQLite stage series compared each Release build with its exact parent in seven four-invocation rounds for each fixed page policy. Each revision occurs twice per round, and the starting order reverses on alternate rounds. The compiler read raw source and produced an ELF object. All 168 stage invocations emitted the same SHA-256. The original no-extra-storage and packed series each had one preliminary parent sample before the copying harness encountered an executable still busy. The full series uses an atomic rename to the same executable pathname. Every reported measurement comes from the complete series.

| Source change | Base-page parse | System huge pages allowed, parse | Ordinary compile user instructions |
| --- | ---: | ---: | ---: |
| Reuse K4 keys | −0.92% (−2.32% to +1.24%) | −0.18% (−1.78% to +1.08%) | −0.041% |
| K1 produces relative-depth blocks | +1.55% (−2.08% to +2.16%) | +2.25% (−0.23% to +3.67%) | −0.060% |
| Reuse K4 keys and carry K1’s deep-unit predicate | −0.26% (−0.92% to +0.64%) | −0.80% (−2.55% to +1.19%) | −0.074% |

Percentages are the median candidate/parent change across complete rounds. Parenthetical values are the observed range. Moving block production into K1 made K4 and K6 cheaper in the warm harness, but increased the median raw-source parse time in both page regimes. The other designs retired fewer instructions and had smaller median parse times with ranges crossing zero.

The separate standard `benchmark-parser` runs use preprocessed tokens. Its `--only vector` region times all vector grammar passes, their scalar fallback and handoff through `parse_vector`. Its `--only stages` regions isolate individual passes. Neither timing includes raw lexing, identifier refinement or macro preprocessing. Six orders used seven internal passes for each real-source input. K4’s preparation is part of K4’s total and the two times should not be added.

| Change | Frozen SQLite vector parser | Lua lvm.c vector parser | musl vfprintf.c vector parser |
| --- | ---: | ---: | ---: |
| Reuse K4 keys | −1.44% | −0.35% | −0.05% |
| K1 produces relative-depth blocks | −0.80% | −1.58% | −0.42% |
| Reuse K4 keys and carry the predicate | −1.49% | −0.99% | −2.00% |

With K4 keys alone, the SQLite K6 syntax check fell 3.10% in cycles and 4.68% in retired instructions. With the K1-packed record, K1’s secondary-bracket work took 16.69% more cycles, K4 took 12.21% fewer and K6 took 2.71% fewer. For the combined no-new-column candidate K1’s secondary work rose 0.85% and K4 fell 3.79%. The warm SQLite vector parser used 27.36 cycles per token on that candidate, compared with 27.75 for its parent in the same series. This number excludes upstream preprocessing and the ordinary driver's remaining parser work. It cannot by itself be compared with Step 3’s 35-cycle gate.

Every build produced the same diagnostics for SQLite, Lua, the complete musl set and the compiler source under default warnings and `-Wall -Wextra`. The same eight representative objects matched in size and SHA-256. All four binaries passed the parser’s depth-boundary suite on 26 translation units covering depths on both sides of 6, 63 and 2,047, and changes to the last SIMD block’s length. The combined candidate also passed the locked Clang-backed parser suite and the 2,434,443-token main file with no differences. [Source of the combined candidate](https://github.com/buster14a/buster/commit/098f2491b82a39b9ccfb66cbd0628fda794d52a9)

## Same-executable control

A dedicated Release executable contains the complete original K1-secondary and K6 block implementations alongside the combined candidate’s. A startup environment setting chooses which paths run on the same raw source. K4 either performs its former full-depth scan or reads K1’s predicate. Both variants retain the ordinary compiler, allocator, parser fallback, checker and backend. Each paired round ran both paths twice, reversing the order on alternate rounds. All 248 objects were identical.

| Ordinary SQLite cost | Base pages | System huge pages allowed |
| --- | ---: | ---: |
| Parser, dense → carried median | 9.587 → 9.546 ms | 7.176 → 7.111 ms |
| Median paired parse change | −0.453% | −0.842% |
| Rounds with lower parser time | 21 / 31 | 25 / 31 |
| Median interval from ranks 10 and 22 | −0.89% to +0.05% | −1.11% to −0.61% |
| Ordinary compile user-instruction change | −0.064% | −0.064% |
| Median paired complete compile time | +0.187% | +0.013% |

The table’s ordered-rank interval describes the median of the 31 paired changes. The two-sided sign tests gave 0.071 and 0.0009 for the parser. The fixed huge-page policy result supports a modest improvement in the ordinary parse stage. Whole-compiler timing overlaps in both modes.

Eight rotating-order rounds also measured all four distinct, uninstrumented executables with the default `-c` path and no stage clock. Each sample used `time-runs` with one warm-up. The combined candidate changed the default paired wall time by −0.257% (−1.438% to +0.201%), the huge-allowed time by −0.004% (−0.710% to +0.567%) and the base-page time by −0.156% (−1.411% to +2.521%). All 96 objects matched. These data do not resolve a complete compile wall-time improvement.

The source-level publication adds direct comparisons of the production K1 depth decision and K6 key reader against the full-depth implementations in the ordinary parser suite. The original measurements above cover `098f2491b`. [Parser test addition](https://github.com/buster14a/buster/commit/fec25cc70adfb14ab4f9a2ea5c86dac2c036993d)
