# Tier 1 countdown unrolling

Buster base `6427879e1143026a12fb0388a20bdea1fe4b2bc5` and head `6a92df5fb1b9159ead7b79a4bcde89a175a26c7f` compiled the same C files with the same Release toolchain, LLVM 23.1.4, CMake 4.4.3 and Ninja 1.13.2. The compiler host target was `vector`, with debug info off. The generated ELF objects targeted `-march=x86-64`. The comparison used GitHub-hosted AVX-512 runners.

## Reverse sum

`countdown.c` sums the array from its last element to its first. The baseline used the C driver on fresh main. It reached Tier 1 and counted one loop refused on its predicate. The promoted IR contains an i32 phi, a comparison against zero, and separate subtractions for the array index and for the recurrence. [Baseline job](https://github.com/buster14a/buster/actions/runs/44600285445/job/135829500972) and [baseline IR](baseline-ir.txt).

| Same C-driver invocation | Base | Head |
| --- | ---: | ---: |
| Unrolled loops | 0 | 1 |
| Array loads per steady-state iteration | 1 | 8 |
| Conditional backedges per eight elements | 8 | 1 |
| Induction decrement per steady-state iteration | 1 | 8 |
| Function .text, bytes | 23 | 102 |
| Added IR instructions reported by the unroller | 0 | 155 |
| Spill loads / stores | 0 / 0 | 0 / 0 |

The entry compares the unsigned start with 7. The eight loads use one zero-extended index, with byte displacements from 0 through −28 in steps of four. The backedge adds the i32 bit pattern for −8, compares with 7 and jumps back on unsigned above. Four partial sums combine before the original remainder loop. The default Tier 1 objects on base and head have the same SHA-256. [Paired hosted job](https://github.com/buster14a/buster/actions/runs/44602060341/job/135835796544) and [full disassembly and reports](reverse-sum-hosted.txt).

`guard.c` compared both builds against the same Clang -O2 object. It ran 76 calls per build with the array at each edge of a protected mapping. Counts included 0 through 33 and 1023 through 1025. It also summed the 79,491 bytes of main's unroller source as 19,873 little-endian words, zero-padding the last word. The result was `0x0f099ecf` on both builds.

`test-ir-unroll` passed 4,007 checks on base and 5,213 on head. Its countdown fixtures check the ordered store trace for factors 2, 4 and 8, and the live induction reaching the remainder. At factor eight, starts 15, 16 and 17 reached the remainder with 7, 0 and 1 elements. The first 17 writes and the fault on the 18th bound the test at extreme starts, including the sign boundary and `UINT32_MAX`. The probe that returns the residual induction runs only in the test. Head also passed all 290,949 `test-ir-optimize` checks.

## Buster's scheduler countdown

The second C input is Buster's own backward [flag-liveness scan](https://github.com/buster14a/buster/blob/6427879e1143026a12fb0388a20bdea1fe4b2bc5/src/buster/compiler/tier1_schedule.c#L191). `schedule-check.sh` extracts its definition and three flag macros from each revision, supplies the two integer typedefs and gives the function external linkage. The extracted C has the same SHA-256 on both revisions. The four-copy loop subtracts four and tests unsigned above three on the backedge. The body also retains its conditional branches.

| Scheduler function | Base | Head |
| --- | ---: | ---: |
| Body copies per main iteration | 1 | 4 |
| Function .text, bytes | 180 | 676 |
| Emitted spill stores / loads | 3 / 3 | 15 / 13 |

The Clang oracle compared the entire output buffer for counts 0 through 96. The input writes and output live-writes arrays were disjoint, identical, or offset by one element in either direction. All 388 comparisons passed on each revision. The larger code and additional spills make the runtime tradeoff an open question. [Hosted job](https://github.com/buster14a/buster/actions/runs/44603252699/job/135840024647) and [disassembly and results](scheduler-hosted.txt).

## Reproduction

On an ordinary Linux AVX-512 host, run `bash reproduce.sh` from this directory. It fetches the pinned revisions into a temporary checkout, verifies the host features, stages the pinned toolchain, builds both compilers and runs the C driver, guard-page and scheduler oracles, and IR tests.

The paired comparison measures emitted code shape and object size. The 155 added rows describe IR growth before cleanup. Compiler throughput and native execution time were outside this run. Hardware qualification and the default-on decision remain with [buster#2755](https://github.com/buster14a/buster/issues/2755).
