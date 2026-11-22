# Tier 1's switches of constants as value tables (#3298), 2026-11-22

buster14a/buster#3298: a dense `switch` whose arms only give constants compiled
under `--tier1` to a jump table and an indirect jump per call. The change
(`ir_switch_table.c`, Tier 1's `tables` pass item, on by default) keeps the
dispatch's bounds check and its 32-bit load, makes the dispatch take the loaded
entry as the value, and has the emission write the constants into the jump
table in place of the labels' offsets.

Host: the Ryzen 7 9700X (`benchpress`), every run under
`~/buster-fast-bench/exclusive.sh`, the compiler a Release build
(`build.sh --config Release`, the 9700X job's Clang 23.1.4) of the commits the
logs name: round 1 `d604382ba` (the pass), round 2 `9e034fba3` (the summary
path too, the pull request's code). Every binary runs `taskset -c 2`.

## The kernel (`bench.c`, `run.sh`)

The issue's `f`: 16 dense `return K` arms and a default, 40,000,000 calls of
`f((x >> 16) & 15)`, x a 32-bit LCG. `k-tier1-off` is the same compiler with
`--tier1-passes=-tables` (main's code). 11 runs each, medians (round 2;
round 1 within 0.2% of each):

| build | ms | branch misses |
| --- | ---: | ---: |
| buster `--tier1 --tier1-passes=-tables` (before) | 269.30 | 37,522,891 |
| buster `--tier1` (after) | 36.94 | 12,982 |
| buster Tier 0 | 274.08 | |
| clang -O2 | 29.75 | 11,332 |
| clang -O0 | 316.27 | |

`--tier1` is 7.29 times faster and 1.24 times clang -O2's time (6.9 times in the
issue's container measurement). The rest is the call: Tier 1's `f` is
`lea; cmp $0xf; ja; mov %edi,%ecx; mov (%rax,%rcx,4),%eax; ret`
(`kernel*.log`'s disassembly), and the loop around it isn't clang's.

## Compile time (`compile.sh`)

`sqlite3.c -c --tier1` (the frozen corpus, `-march=znver5 -std=gnu17`), the
same build with and without the pass, `time-runs --runs 11 --warmups 1` in a
Williams order. No switch of sqlite3.c qualifies (`value_tables=0`, the objects
are the same size), so this measures what the pass costs where it does nothing:

| round | with the pass | `-tables` | instructions |
| --- | ---: | ---: | ---: |
| 1 (`compile.log`) | 609.29 ms | 605.71 ms | +0.75% |
| 2 (`compile2.log`) | 604.61 ms | 604.08 ms | +0.005% |

Round 1's cost was a body with jump tables taking its own pipeline instead of
its inlining summary (which skipped the pass); round 2 converts in the summary
too, which no caller expands (a body with labels isn't inlined), and the
difference is noise.
