# Reviewer packet: #451

## Proposal and source boundary

Complete the original issue's accounting through documentation. #462 supplies
the original whole-process/memory/release decision; #486 supplies directive
attribution/optimization and the bounded long-line cut. The new record is a
configuration refresh at exact e7f89091648f68940b595aadd648841c1ffc3ec5, not a
new optimization. The later 68e113ee lexer/page fusion and identical-assembly
alias experiment remain rejected. No source algorithm changed during this run.

## Exact gates

The local pure-e7 gates and ASan/UBSan helper are described in LOCAL-RESULTS.md.
The shared official native binary is pinned by SHA-256 in README.md and the
receipts. Root's exact-binary checker/deferred/ABI/SQLite QA is reused rather
than represented as another run in this record. The added native gates are:

```sh
test-preprocessor --clang --fuzz 0 --seed 451 --jobs 1
test-refinement src
test-files --lanes 1,2 --seed 451
```

The first PP invocation reports its missing own-header layout and exits 1.
A regular byte-identical copy at private `tree/build/compiler`, with a `src`
link to the immutable source, passes under a new tag, including 176 header/
mode/hosting sets. No timed argument or shared source/binary changed. The
corrected gate also passes 390 fixtures, 240 generated window sources/1833
preparations, 119625 cuts, 976 places, 2892217 guarded CR/LF line checks and
24 complete units/93 windowed units/128264 `__LINE__` values. Refinement passes
520 files/26584594 bytes and 9600 guarded tails; the file gate covers lanes
one/two and short-memory/resource failures. No additional broad fuzz run is
claimed (`--fuzz 0`).

All eight actual SQL/main CLI preflights pass in both modes. Complete `-E`
bytes match both modes and all four full-inclusion helper outputs. Four direct
file cases match scalar/whole/window records and every token's physical line
oracle. The instrumented helper supplies logical work counts only, never timing.

## Measurement and interpretation limits

The approved native stage contains 12 cohorts/504 timed children and 16 phase
processes, not the earlier larger proposal. Every cohort/process took a fresh
shared-lock grant on CPU 2, with official tool/resource/library paths and fixed
epoch. A/A, A/B and reverse B/A use one input and two roles of the same fresh
executable copy. The profiler's old mixed-input predecessor design is avoided.
All timed statuses are zero and every PMU field is counted; all major faults
are zero. Seeded bootstrap intervals describe within-cohort ratios only.
Two phase-process medians per configuration do not establish between-process
confidence; both ranges are retained. No automatic extra rounds were run.

Current main preparation is 55.2565 to 55.2505 ms whole to windows, with
overlapping process ranges; its whole-process differences are small/control-
or order-sensitive. SQLite favors windows in both orders, with differing
magnitude. About 2 MiB of extra peak memory stays visible in SQL's two commands
and main parsing. The historical spliced input remains a negative control:
4.6815 to 4.7655 ms preparation, whole to windows. Main replays 14633 logical
bytes over 8173523 windowed bytes; historical generated hashes/counts reproduce
#486, establishing no new source reduction.

Final audit v2 accepts only exact old/new status spellings and verifies 45
records: 44 positive plus the retained layout-negative. Its first failed audit
is preserved. Source/main dependencies are unchanged; the full SQL pack hash
is explicitly postrun. Archive export and every payload digest verify, as do
the local/native reader summaries. Publication copies are separately verified
against COLLECTION.tsv and CURATED-SHA256SUMS. No remeasurement was needed.

This evidence does not establish hosted CI success at a future docs PR head,
qualify later compiler source, close #451 automatically, or imply a new general
compile-throughput improvement.
