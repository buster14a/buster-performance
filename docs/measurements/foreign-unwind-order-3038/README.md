# Foreign unwind relocation order

A paired measurement of Buster's production `link-foreign --lanes 1` on GCC-produced objects, at base `6427879e1143026a12fb0388a20bdea1fe4b2bc5` and head `1c882f4d3a94ae8416a8c633bab7e39a26bca9dd`. The only compiler changes are in `foreign_unwind.c` and its own tests. [Buster issue #3038](https://github.com/buster14a/buster/issues/3038)

## Inputs and counted work

Two C++ translation units call the system libstdc++ implementation of `std::sort`. The losing COMDAT object has one CIE and 31 FDEs. It retains one CIE, three FDEs, 132 compact frame bytes and three 24-byte RELA entries. A second run reverses just those 31 input relocation entries. A separate link runs the section-GC path on the project's real `tools/ci/changes.c`. Its object retains one CIE, 54 FDEs, 3,312 bytes and 54 RELA entries on both visits. GCC produced zero adjacent inversions and zero ties on all three original input objects.

| Input | Owner end comparisons, base → head | Merge comparisons | Merge passes | All counted offset comparisons |
|---|---:|---:|---:|---:|
| C++ COMDAT, one prune | 156 → 62 | 79 → 0 | 5 → 0 | 266 → 93 |
| C selector object, each of two visits | 317 → 108 | 169 → 0 | 6 → 0 | 540 → 162 |
| C selector link, all six prune calls including startup objects | 638 → 220 | 338 → 0 | 12 → 0 | 1,086 → 330 |
| C++ object with reversed RELA | 156 → 159 | 75 → 75 | 5 → 5 | 262 → 266 |

The two ordered links made zero binary relocation-owner lookups on head, down from 31 and 110. Reversing the C++ table retained its 31 binary searches. Detecting the order added three record-end comparisons and one adjacent-offset comparison on that control.

The owner column counts comparisons against record ends in the binary search and in the cursor. The total adds the adjacent-offset order test, merge comparisons and the overlap check. Loop bounds, input type checks, FDE-to-CIE backlink lookups and the later relocation importer are outside these counters. The two sort index arrays each contain one `uint32_t` per input relocation and are allocated only after an inversion. The stable merge routine and the original input-order validation handle disordered fields.

The first candidate walked all intervening records. On the reversed control its first lookup checked 32 ends before the inversion was visible. The submitted version checks the current and adjacent records, then searches across a gap. Crossing a record end also proves that the offset advanced. [First paired experiment](https://github.com/buster14a/buster-performance/actions/runs/44602642748/attempts/2)

## Correctness

The base and head used the same input objects and flags on one Ubuntu 26.04 GitHub-hosted AMD EPYC 9V74 AVX-512 runner, with the repository's vector Release configuration and pinned Clang/LLD 23.1.4. GCC/G++ 15.2.0 built the inputs. The C and C++ flags were `-O1 -fPIC -ffunction-sections -fdata-sections -fasynchronous-unwind-tables`, with `-std=c++17 -fno-inline` on the C++ units and `-std=gnu17` on the C unit.

Each instrumented prune wrote all record intervals, CIE backlinks, sections, atoms, surviving .eh_frame bytes and relocated Elf64_Rela bytes before returning to the production caller. The paired job used `cmp` on those plans, complete linked executables, .text, .eh_frame, .eh_frame_hdr, decoded frames, final relocations, stdout and stderr. The clean head also produced the same executables. The final C++ image decoded to three CIEs and 34 FDEs in both relocation orders. The C image decoded to two CIEs and 55 FDEs. Both C++ links exited 42. The C selector exited 0 and produced identical output to the binaries linked by GNU ld and LLD. The C++ throw/catch/cleanup program from the full foreign suite also produced identical executable bytes and decoded frames.

`test-foreign --cross-check` passed on unmodified main and on both algorithms with the final expanded fixtures. The expanded suite had 468 pruning checks and 72 C++ unwind-runtime checks. It exercises ordered, reversed, tied and out-of-record fields, ignored R_NONE entries, gaps, rollback and original-index diagnostics, including classification errors that take precedence over an earlier overlap. [Unmodified main](https://github.com/buster14a/buster-performance/actions/runs/44600974229) · [Baseline counts](https://github.com/buster14a/buster-performance/actions/runs/44601664506) · [Final paired run](https://github.com/buster14a/buster-performance/actions/runs/44604521045)

These are source-level operation counts in the production foreign linker. The executable bytes and behavior were unchanged. Throughput qualification on Zen 5 remains separate.

## Reproduction

Use a disposable clean checkout of Buster at the base above on an ordinary AVX-512 Linux host that passes `tools/ci/vector-probe.c`. On Ubuntu 26.04 the qualification job used GCC/G++, binutils, GDB, zstd and the system development packages for zstd, XML2 and zlib. Point `record` at this directory in the measurement checkout. From the compiler checkout run

```sh
export RUNNER_TEMP="$(mktemp -d)"
export BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none BUSTER_LINKER=auto BUSTER_ORACLE_CACHE=off
export PATH="$(bash tools/ci/session-toolchain.sh stage):$PATH"
bash "$record/run.sh"
```

The script compiles the C++ sources in this directory and the C source from the pinned compiler checkout. `head.patch` is the exact PR diff. The two `*-probe.patch` files instrument only the experiment builds and count the actual owner searches and merge-loop comparisons. The script preserves the two objects and the selector input for every link, exercises the system-linker oracles, checks the flags and enforces fewer owner comparisons, sort passes and total offset comparisons on the two ordered workloads. The text receipts retain the toolchain, measured counters, hashes and test output. `paired-captures.zip` holds the hosted job's raw counts, plans, decoder output, flags and foreign-suite results.

---
Agent session: 6aff4f83-8708-8191-93c4-3f233675707c (OpenAI Codex session ID, no private session URL exposed)
Model: OpenAI / GPT-6 (Codex)
