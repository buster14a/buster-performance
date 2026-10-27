# Runtime memory and string builtins, issue #599

This record compares Buster's generated programs, independently of compiler-internal SIMD throughput.
The original C inputs and measurement helpers use Apache-2.0 WITH LLVM-exception; no external implementation or fixture was incorporated.
Clang and the installed libc are external compilation/runtime oracles.

Source baseline: `buster14a/buster` at `92c025e71856d13eb34247477c5294d2cead139e`.
Source candidate: `f499888ce8d75643f94e43e33c0c1d393b2fc8a0`.
The source digest manifest identifies all changed implementation/test inputs used by the target build.

## Workloads and interpretation

`wrappers.c` is compiled separately from `runtime.c`. The same input is compiled by Buster's baseline and candidate,
Clang at `-O3 -march=x86-64`, and Clang with `BUSTER_EXTERNAL_LIBC` and `-fno-builtin` to make ordinary libc calls.
Buster also uses the baseline generated x86-64 target. The host compiler is built with the repository's normal
`-O3 -march=native` flags and `BUSTER_DEBUG_INFO=0` on the approved Ryzen 7 9700X.

Lengths are 0, 1, 8, 16, 32, 64, 256, 4096 and 1 MiB, both dynamic and fixed in the wrapper.
The length wrapper is always dynamic; its duplicated fixed-size rows are omitted by the summary.
Alignment 0 uses source/destination offsets 0/7 relative to the 128-byte buffer prefix, and alignment 7 uses 7/0.
Copy/fill have one shape. Move shapes 0/1/2 are disjoint, destination=source+1 and destination=source-1.
Comparison shapes 0/1/2/3 are equal, first mismatch, middle mismatch and last mismatch.
Each case validates return values and memory or comparison sign against the host libc before timing.
The length wrapper is also checked at all lengths 0..255 with its terminator immediately before a guard page.

Each process reports medians of three timed loops. Repetitions are `4194304/(n+1)`, clamped to 8..100000.
A complete discarded process warms each executable block. Three measured processes per variant run in rotated order:
base/head/clang/libc; libc/clang/head/base; head/base/libc/clang.
All run pinned to CPU 2 under the shared host lock, with no system settings changed.
The summary selects the upper middle of the six process/alignment medians for each key.
These are hot-buffer microbenchmarks of complete emitted wrappers, not application-wide speedups or cold-memory bandwidth.

Instructions are user hardware-counter differences for the timed loop, divided by calls and requested bytes.
They include the harness and call overhead; zero-length instruction/byte fields are zero because the divisor is zero.
Code size is the wrapper object `.text`, with per-symbol sizes and complete disassembly retained.
The separate compile-cost experiment uses the repository's `time-runs`, 21 rotating baseline/head process pairs,
with two warm-ups, pinned to CPU 2. It includes the compiler process, parsing/checking/lowering, object emission and write.

## Reproduction

Build the two source revisions independently, each under:

```sh
EXCLUSIVE_OWNER=your-session EXCLUSIVE_TITLE='Buster 599 build' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/599 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh
```

In a comparison directory containing `base/`, `head/` and this record as `evidence/`, prepare under one short build lock:

```sh
base/build/compiler -c -march=x86-64 --lanes 1 evidence/wrappers.c -o evidence/base.o
head/build/compiler -c -march=x86-64 --lanes 1 evidence/wrappers.c -o evidence/head.o
clang -O3 -c -march=x86-64 evidence/wrappers.c -o evidence/clang.o
clang -O3 -fno-builtin -DBUSTER_EXTERNAL_LIBC -c -march=x86-64 evidence/wrappers.c -o evidence/libc.o
# For each variant, link runtime.c separately, without LTO:
clang -O3 -fno-builtin evidence/runtime.c evidence/head.o -o evidence/runtime-head
```

Run each `taskset -c 2 evidence/runtime-VARIANT VARIANT` through the shared lock, in the orders above,
retaining each stdout as `runtime-VARIANT-ROUND.csv`. Build `summarize.c` with Clang and pass it all twelve CSVs.
The recorded campaign holds the lock for this single, short four-variant comparison and releases it before tests or compile-cost measurement.

Compile cost:

```sh
head/build/compiler time-runs --runs 21 --warmups 2 --build base ./base/build/compiler --build head ./head/build/compiler --list -c -march=x86-64 --lanes 1 evidence/wrappers.c -o evidence/compile-cost.o
```

Run that command under the shared host lock with `taskset -c 2`.

## Correctness checks

`test-builtin-misc-lowering` compares publication and backend twins, carries a live value across the recipes,
and executes independent libc/Clang checks at every small size through 33, every alignment through 15,
close overlap distances -17..17, unsigned differences, exact protected tails including zero, and sizes through 1 MiB.
The string inputs include zero followed by byte 1 to exercise borrow bits in the zero-byte predicate.

`source.c` and `source-check.c` compare separately compiled Buster/Clang functions on 2050 calls and all global bytes,
including constant-size argument side effects. The same source shapes are in `test-checker`.
The freestanding/no-builtin wrapper object must have no undefined symbols.

The local native recipe checks also pass ASan+UBSan with `-fno-sanitize=function`: Clang's function metadata check
cannot be used on generated machine-code entry points. This flag leaves address and other undefined-behavior checks enabled.
`misc-driver.c` is compiled from the source checkout with `-O0 -march=native -Isrc -fwrapv -funsigned-char
-fno-strict-aliasing -Wall -Werror -ffunction-sections -fdata-sections -Wl,--gc-sections
-fsanitize=address,undefined -fno-sanitize=function -fno-omit-frame-pointer`, with `ASAN_OPTIONS=detect_leaks=0`.
The host is the local 7940HS/Clang 23.1.4; this is correctness evidence, not target performance evidence.

Two deliberate source mutations, built with `-O0` in isolated include overlays, are rejected:
1. `cbuiltin_misc_lower_copy_word` copies 32 bytes while its loop advances by 16: 545 failures followed by a guarded native fault.
2. All small moves use sequential `COPY` pieces instead of loading both pieces before storing: 3815 failures.
The retained logs show these tests fail independently of scalar/vector agreement.

## Retained prototype

`prototype-40431801/` retains the complete first campaign at
`40431801feae2b9a378c2aa79317fb716db8bd40`, including its source/binary identities.
It is separate from the final candidate's results. That campaign exposed a dynamic eight-byte copy regression
(3.065 to 3.785 ns/call), prompting direct runtime paths for lengths 0, 1 and 8.
The final candidate also uses 8-byte LOAD/SET operations for moves, so close overlap respects the shared typed
stream's COPY contract instead of depending on its current single-SSE-load/store implementation for a 16-byte chunk.
The mutation receipts above apply to this retained prototype. Final native recipe sources and the complete
strengthened test inputs pass the separately recorded final local sanitizer run.

## Final qualification and results

The final implementation is `f499888ce8d75643f94e43e33c0c1d393b2fc8a0`.
The runtime campaign executed the immutable executable prepared at `3ceddefb29a9952b34a066892717e374ff092754`.
The final size-proof guard produces a byte-identical wrapper object and complete runtime executable; the common
runtime SHA-256 is `9823f1b61061a66ded5f174303556f2595ad31e7bc86c7dd8bf84ec031ec0fef`.
`binary-identity.txt` and the binary manifest retain both identities. Semantic tests and compiler-cost runs use the final compiler.

Dynamic sizes, disjoint moves and equal comparisons, upper middle of six process/alignment medians:

| Operation | 4 KiB baseline (ns) | 4 KiB final (ns) | Speedup | 1 MiB baseline (us) | 1 MiB final (us) | Speedup |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| memcpy | 1016.373 | 70.131 | 14.49x | 259.214 | 15.167 | 17.09x |
| memmove | 1016.598 | 148.509 | 6.85x | 259.286 | 35.212 | 7.36x |
| memset | 760.440 | 115.417 | 6.59x | 189.106 | 23.666 | 7.99x |
| memcmp, equal | 1494.827 | 203.685 | 7.34x | 378.735 | 47.579 | 7.96x |
| strlen | 773.199 | 193.804 | 3.99x | 193.059 | 47.459 | 4.07x |

At 1 MiB, baseline/final user instructions per requested byte are 10.000/0.625 for memcpy,
10.000/1.250 for memmove, 8.000/0.875 for memset, 16.000/1.500 for equal memcmp, and 8.000/2.125 for strlen.
These include harness/call overhead, as described above.

The libc reference at 1 MiB takes 13.356 us for copy, 13.348 us for disjoint move, 5.145 us for fill,
14.061 us for equal comparison and 5.257 us for length. It is an external
native-host reference. The final bounded inline recipes improve this compiler's baseline without establishing libc parity.
All reference timings, alignments, constant sizes, overlaps and mismatch positions are retained in the CSVs.

Short dynamic copies of 8 bytes improve from 3.063 to 1.623 ns (the prototype took 3.785 ns).
The sampled nonzero small disjoint/equal cases improve or hold; known 32-byte copies improve from 8.225 to 1.443 ns,
known 16-byte moves from 4.869 to 1.443 ns and known 32-byte fills from 7.070 to 1.443 ns.
Empty dynamic copy and comparison have about 0.18 ns of additional fixed overhead; empty move, fill and length hold.
First-byte mismatches at 4 KiB cost 1.459 to 1.646 ns, while middle/last mismatches improve substantially.
The 1 MiB first-mismatch timing has only eight calls per sample and is too short for a useful timing claim;
its functional comparison still passes. The primary tables use full-length operations.

The 41-wrapper object grows from 4486 to 6467 bytes of `.text` (+1981 bytes, including alignment).
Per-symbol sizes and disassembly show the cost of loop dispatch, exact tails and the bounded string prefix.

Compiler costs, complete processes, rotating order under a separate lock:

| Input | Baseline wall median | Final wall median | User instructions baseline/final | Peak RSS baseline/final |
| --- | ---: | ---: | ---: | ---: |
| 41 wrappers, 21 pairs | 1.912 ms | 1.805 ms | 18,681,613 / 18,840,634 | 26,380 / 29,532 KiB |
| Frozen SQLite, 11 pairs | 146.953 ms | 146.971 ms | 1,552,459,443 / 1,552,459,588 | 512,868 / 516,012 KiB |

Wrapper instruction cost increases 0.85%; user cycles increase 2.32%. Wall ranges overlap
(1.733..9.616 ms baseline, 1.754..2.002 ms final), so this is not evidence of a compiler speedup.
SQLite wall/cycles change about +0.01%, with overlapping ranges; its instruction counts are effectively equal.
The roughly 3 MiB resident-set increase is recorded without attributing it to a particular mapping or allocator.
SQLite options match the repository's compile-time campaign, plus explicit `--lanes 1`, pinned to CPU 2:
`-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I.../sqlite .../sqlite/sqlite3.c -o evidence/sqlite3.o`.
The source SHA-256 is `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.

Final target acceptance:

| Check | Result |
| --- | --- |
| Native memory/hint recipes | 172,377 checks, 0 failed |
| Integer builtin lowering | 970,101 checks, 0 failed |
| Source checker, seed 599, Clang 23.1.1 | 265,645 checks, 0 failures |
| Independent source/side-effect comparisons | 2,050 calls, 0 failures |
| Call graph | 41 units, 23,967 functions, 143,709 calls, 0 bad cycles, 3 allowed, 0 split variables |
| Freestanding/no-builtin, baseline x86-64 wrappers | No undefined symbols |
| Final native recipe ASan+UBSan, local Clang 23.1.4 | 172,377 checks, 0 failed |

The source checker includes new regressions for a copy length under changing floating-point rounding,
and for a constant query whose clean source proof is one while its runtime answer is zero and raises an FP exception.
The size proof excludes these special runtime plans. This prevents specialization from changing either copy length or evaluation effects.
