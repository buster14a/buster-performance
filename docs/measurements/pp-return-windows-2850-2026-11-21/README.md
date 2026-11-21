# Producing a return window from preprocessor output

The ordinary preprocessor emitted a usable source-keyed window for 2,237 independently proven SQLite return roots that reached native lowering. Reading its immediate early enough to omit the checker's ordinary source decoding increased complete compile time by 0.294% on SQLite. The fresh raw-source PP process with the writer took 90.507 core cycles per output token on the locked Ryzen 7 9700X. The Step 3 front target is 35. These results keep the bounded implementation experimental. [Tracker and experiment scope](https://github.com/buster14a/buster/issues/2850#issuecomment-7064248088) · [Raw paired measurements](receipts/paired-rounds.txt)

## Source production

The producer uses the keyword-resolved 64-token vector already available on the ordinary PP output path. It processes exact three-token returns whose leaf is a simple identifier, nonnegative decimal int, or eligible internally generated PP integer. It appends a sorted record containing the original return-token index, integer value or intern ID, and leaf class. The next PP token is the source operand. Identifiers still need a binding, conversions still need a type, and the existing route handles the rest of the grammar. State spans PP keyword chunks. There is no second full-unit scan in stream mode. Replay deliberately makes a separate pass over the same final output. [Guarded patch against 6e9c51b9d](patches/pp-return-window-guard.patch)

An independent oracle walks the ordinary grammar roles, requires the leaf to have the return as its parent, checks all three source positions and identifier identity, and decodes decimal spelling independently. It compares the complete ordered records from the untouched compiler, stream mode and replay. All 1,372 input files matched.

| Corpus | Files | PP output tokens | Grammar returns | Integer records | Unresolved names |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite amalgamation | 1 | 716,136 | 4,344 | 1,703 | 1,045 |
| Lua | 34 | 571,543 | 1,259 | 360 | 277 |
| musl | 1,336 | 5,039,639 | 17,814 | 856 | 8,303 |
| Buster compiler main | 1 | 2,440,352 | 7,645 | 16 | 1,444 |

The initial producer passed the full real corpus but emitted a spurious return from a C23 attribute's arbitrary token payload. The directed fixture gave the producer a return at PP token 6 and the parser's first real return at token 19. The guarded producer skips nested C23 and GNU attribute contents, keeps that state across keyword chunks and retains the pragma exclusion. All 37 directed baseline/stream/replay cases matched, including rare chunk alignments, multiline attributes and macro expansion. [Initial patch](patches/pp-return-window-first.patch) · [Initial counterexample and results](receipts/unguarded.tar.xz) · [Guarded per-file receipts and fixtures](receipts/producer.tar.xz)

SQLite used 42 keyword ranges and 11,212 vector blocks. Six rotated four-arm rounds separately measured the standalone raw-source PP process, ordinary fresh stage times, external wall and a warmed producer kernel. Medians of individual process counters follow. The total is the median of the actual user-plus-kernel sum per process. The elapsed PP interval includes the ordinary source read, lex, includes, macro work, output and producer. Process PMU also includes setup, teardown and startup.

| SQLite metric | Untouched | Candidate off | Stream | Replay |
| --- | ---: | ---: | ---: | ---: |
| User + kernel core cycles / PP token | 89.390 | 88.956 | 90.507 | 89.429 |
| User core cycles / PP token | 67.473 | 67.296 | 68.780 | 67.779 |
| Kernel core cycles / PP token | 21.666 | 21.660 | 21.629 | 21.623 |
| Raw PP interval, ms | 10.847 | 10.675 | 10.938 | 10.745 |

Streaming added 1.426% retired user instructions per PP token in each round. Ordinary fresh preprocess moved from 9.430 to 9.590 ms and complete external wall from 121.324 to 121.550 ms, with both paired ranges crossing zero. Repeating just the record producer on warm PP columns took 0.519 invariant TSC ticks per PP token, or 0.137 ns, at the median of six sessions with seven measured passes each. It emitted all 2,748 rows each pass. This consume-only clock excludes ordinary source preprocessing and uses the invariant TSC frequency.

## Carrying a PP value into native output

The integrated test applies the producer to the original opt-in source-root compiler, preserving ordinary binding, compatibility, diagnostics and fallback. Both PP statement and operand identities must match. Independent SQLite native selection accepted 2,263 whole returns. Of these, 2,237 matched the PP records, including 1,530 integers and 707 names. All 2,237 reached native lowering. Another 173 integer and 338 name records fell outside the existing native proof. The join covers a bounded class of returns within one unit. [Per-row join](receipts/pp-return-sqlite-native.tsv) · [Independent source selection and native evidence, exact compiler bb86d4685](https://github.com/buster14a/buster-performance/tree/c8fdac6121f5fdd68ce42e78e27eaa10286e9e6c/docs/measurements/window-compile-2850-2026-11-21/root-splice/source-root-lean)

The physical-payload arm checks the actual preconversion value and replaces both the graph value and Tier 0 native tape immediate on compatible whole i32 returns. It supplied 1,447 SQLite immediates. The 707 names use ordinary resolution, and the remaining 83 integer admissions require another converted type. Under `-Wall -Wextra` it matched 2,087 roots and supplied 1,314 native i32 immediates. [Physical payload patch against bb86d4685](patches/pp-return-physical.patch)

The separate checker arm consumes the PP value earlier. It removes matching literal lanes from the ordinary spelling lookup and decimal decoding before the checker loads source locations and ends. The candidate accepts one to nine original decimal digits or an eligible internal PP integer, and leaves ten-digit source spellings on the ordinary path. All 1,703 SQLite returns took this omission under both warning policies. Each policy took 24 in Lua lvm, three in musl vfprintf, and 16 in Buster main. The late physical replacement was disabled throughout this arm. [Combined patch with the early checker read against bb86d4685](patches/pp-return-decode.patch)

For each arm, default and warning builds of a linked fixture and four representative units matched the untouched compiler's full native records and complete ELF. The before, writer-only and enabled alternatives compared exact bytes. Flipping the first transferred value's low bit in either independent arm changed both the SQLite native bytes and ELF and changed the linked fixture exit from 0 to 255. The per-file lexical oracle above ran the full corpora. The native comparison used these ten source/policy pairs. [All native records' and objects' hashes, comparisons, fault receipts and timing samples](receipts/consumer.tar.xz)

## Whole-compile cost

The five rotated arms were the original bb86d4685 compiler, the candidate with both features off, the writer alone, the writer with late physical substitution, and the writer with early checker decoding. All four candidate arms use the same executable. Each source ran five rounds pinned to CPU 2 with the shared native lock, one fresh staged PMU compile with huge pages requested, and two separately timed external children after one warmup with ordinary allocation. Native capture and reporting were disabled. The unit was compiled with `--node-window-source --lanes 1 -c` throughout.

| Same-binary off → writer and early checker | External wall, ms | Median paired wall change | Whole user instructions | Check-input change |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 127.207 → 127.558 | +0.294% | +0.191% | +0.812% |
| Lua lvm | 15.483 → 15.590 | +0.409% | +0.312% | +2.647% |
| musl vfprintf | 4.221 → 4.232 | +0.213% | +0.197% | −1.285% |
| Buster main | 705.372 → 706.495 | +0.180% | +0.119% | +0.249% |

SQLite's off→early wall range was +0.125% to +0.769%, whole user-plus-kernel cycles rose 0.437%, and every sampled object matched. Versus the writer alone, the early checker read added 0.025% user instructions, while the late substitution added 0.084%. The original→early whole-wall change was +0.333% across five rising pairs. The source producer proves a real handoff and the early arm omits the targeted decode, but the discovery and lookup cost exceeds the saving for this narrow population. [Per-comparison absolute medians, paired ranges and object hashes](receipts/paired-rounds.txt)

## Reproduction

Apply the standalone patch to `6e9c51b9d238734468dccc03ab1b6c715449804e` or the physical/early patch directly to the historical source-root tree `bb86d4685abf8c8956438f88cd5b5c6d19ad2f8a`. Each patch is self-contained against its stated base. The archives contain source hashes, release build logs, raw perf and stage output, exact object/native hashes, the first negative fixture and the successful corrected comparisons. The native scripts name the frozen corpus and shared native locking conventions. The physical integrated compiler and standalone meter have different base trees and capabilities. [Scripts and independent oracle](scripts) · [Source-root tree reconstruction](https://github.com/buster14a/buster-performance/tree/c8fdac6121f5fdd68ce42e78e27eaa10286e9e6c/docs/measurements/window-compile-2850-2026-11-21/root-splice/source-root-lean)
