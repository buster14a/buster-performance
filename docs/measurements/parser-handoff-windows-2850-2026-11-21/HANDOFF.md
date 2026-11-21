# Omitting full-unit parser columns

All four experiments below use the frozen main, stable arguments, locked CPU and independent row oracle described in [the first receipt](README.md). The kernels report actual user core cycles per grammar token. The separate cold tree clock reports invariant TSC ticks, which have a different frequency. Each paired change is the median of within-round changes; absolute columns are per-arm medians. [SQLite summaries](native/paired-steps.txt) · [Per-corpus paired summaries and object hashes](native/paired-corpora.txt)

## Contiguous PP output is an implicit source map

The ordinary parser maps one source index per grammar row. A surviving pragma is removed and a doubled colon splits, while straight input rows have identical PP and grammar indices. The candidate's vector conversion starts without writing the 32-bit source column, keeping its virtual reservation. Encountering the first special token publishes the whole prior identity run, then the normal explicit map. Existing synthetic, repaired, prefix and attested views each keep their own explicit map. The scalar, vector and gather consumers reproduce zero on the padded sentinel rows. There is no preliminary source scan. SQLite omits 2,864,544 previously written bytes. [Measured source](source/pp-parser-identity.patch)

| Corpus | Implicit files | All files | Implicit grammar rows | Total grammar rows |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 1 | 1 | 716,136 | 716,136 |
| Lua | 34 | 34 | 571,543 | 571,543 |
| musl | 1,323 | 1,336 | 4,973,170 | 5,039,561 |
| Buster main | 0 | 1 | 0 | 2,439,993 |

Six three-arm rounds rotate untouched main, candidate-off and candidate-on. Each arm runs the seven-pass consume benchmark, one fresh staged compile with PMU and two external time-runs children after one warmup. SQLite results follow.

| Measure | Untouched | Candidate off | Candidate on | Paired untouched→on | Off→on |
| --- | ---: | ---: | ---: | ---: | ---: |
| Conversion, cycles/token | 3.732 | 3.604 | 2.963 | −20.428% | −17.514% |
| Combined keyword/conversion, cycles/token | 2.256 | 2.238 | 1.405 | −38.593% | −36.956% |
| Fresh parse, ms | 7.059 | 7.123 | 6.927 | −1.766% | −2.798% |
| Check-input, ms | 45.049 | 45.165 | 44.840 | −0.288% | −0.257% |
| External ordinary wall, ms | 121.076 | 121.198 | 120.463 | −0.247% | −0.563% |
| Wait4 peak, KiB | 245,573 | 245,741 | 243,636 | −0.789% | −0.857% |

All six untouched→on fresh parse differences were favorable (−2.181% to −0.536%), as were the six ordinary-wall differences (−0.695% to −0.090%). Lua lvm, musl vfprintf and Buster main whole wall changes each spanned both signs. The claim concerns the handoff and measured fresh parse. The row gather and 128 sentinel positions matched with unwritten rows actively poisoned. The original and candidate streams matched byte-for-byte over 1,372 frozen files, including 478,615,991 PP, grammar and tree bytes. Clang-backed parser tests, 41 focused files, full syntax diagnostics and representative normal/warning objects passed. Separate poisoned checker runs passed attestation, semantic diagnostics, program selection, overloads, embed initializers and request handling. [Locked runs, admission counts, exact row checks and commands](native/source-map.tar.xz)

## Read bracket depth from the K1 block

K1 already writes each 64-token window’s signed prefix depths. A 32-bit starting depth and one mask of the rare scalar block's clamped unmatched closers recover its live absolute depths. Both fields fit the existing aligned block. This omits the full 32-bit absolute-bracket-depth allocation and its writes. K3's sparse typedefs and K2 read the window's base and live offsets. Secondary-bracket accumulation widens the signed offsets in each quarter block. The final derived node depth, traversal and externally visible parser roles are unchanged. [Measured source](source/pp-parser-bracket.patch)

On seven alternating SQLite rounds, K1 took 2.014 → 1.824 cycles/token (−9.387%), its secondary accumulation 0.884 → 0.794 (−10.124%), and the complete vector parse 29.675 → 28.686 (−3.333%). The fresh parse stage took 7.079 → 6.814 ms, −3.806%, with every round between −4.358% and −2.206%. Check-input moved +0.206% across both signs. Ordinary full wall moved −0.168% (−0.567% to +0.338%) and huge-allowed wall −0.059% (−0.234% to +0.011%). A separate raw oracle compared 54,579,240 initialized bytes for 20,520 bracket sequences, including 20,180 unmatched ones, across all tail lengths. Every live depth, enclosing opener, per-lane relative byte, opener lane, and open mask matched. The four-corpus initialized PP/grammar/tree witness and ordinary/warning objects passed. [Raw measurements, Clang checks and malformed-depth oracle](native/bracket-depth.tar.xz)

## Sparse fallback requests

A separate parser leaves the regular K6 and tree representation in place. Its existing flag-publication pass writes only flagged block indices into dead K4 scratch. Fallback recovers the declaration boundaries around those blocks. It caps each backward scan at the previously submitted declaration’s end, preserving classification across earlier scalar tree rewrites. [Measured source](source/pp-parser-requests.patch)

Seven SQLite rounds put the complete vector parser at 29.713 → 29.238 cycles/token (−1.493%, all seven faster), the fallback itself at 1.361 → 1.176 (−13.593%, all seven faster), and fresh parse at 7.067 → 7.000 ms (−1.125%, range −3.513% to +7.606%). Ordinary wall was +0.141% (−0.049% to +0.853%); huge-allowed wall was +0.025% (−0.379% to +0.422%). Five rotations of Lua lvm, musl vfprintf and Buster main improved every isolated fallback measurement but gave mixed full-process results. Tests included 70 deterministic flag patterns, dense and sparse, injected into each of 12 source alignments, plus the 1,372-TU row witness and complete-object comparisons. The source remains experimental. [Raw checks, fault injection, counts and measurements](native/fallback-sparse.tar.xz)

## Cold traversal within ordinary checking

A separate build instrumented only the actual traversal function, with both choices in the same executable, on four fresh ordinary compilations, while uninstrumented wall used another same executable toggled between width zero and 4,096. Seven ABBA rounds charged normal parsing and checking. On SQLite the actual traversal took 9.705 → 9.592 TSC ticks/token, −1.168% with a −2.484% to +1.029% range. Check-input took 44.825 → 45.077 ms (+0.641%) and uninstrumented complete wall took 121.052 → 121.239 ms (+0.215%), each spanning both signs. The other three sources' cold tree changes also spanned both signs. This rejects cache tiling as a production change on these measurements. [Clocked source](source/pp-parser-tree-account.patch) · [Complete raw cold/ordinary pairs](native/tree-charged.tar.xz)
