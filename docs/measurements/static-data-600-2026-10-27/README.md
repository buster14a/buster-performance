# Static-data publication: #600

Qualification of [Buster issue #600](https://github.com/buster14a/buster/issues/600).

## Sources and machine

- Baseline Buster: `92c025e71856d13eb34247477c5294d2cead139e`.
- Candidate Buster: `4e21ef63d6d7e8e4ac5766f5043bdb6b06b0d9b7`.
- Both are archived source snapshots, built on the AMD Ryzen 7 9700X with Clang 23.1.1 and `BUSTER_DEBUG_INFO=0 ./build.sh`. The build retains its normal `-O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing` flags.
- Every target build, test and measurement uses `~/buster-fast-bench/exclusive.sh`, with this issue as its owner link. Timed compiles use CPU 2 and `--lanes 1`; no machine settings were changed.
- Source, input and binary manifests accompany the logs. The archived source trees are checked against their complete SHA-256 manifests before the data qualification.
- The small `matrix` process controller was compiled with desktop Clang 23.1.4 (`clang -std=c17 -O2 -Wall -Wextra -Werror matrix.c -o matrix`). It invokes the target-built, unmodified Buster `time-runs` command for all reported repeated timing samples. The diagnostic probes and all Buster executables are built with the target toolchain. The controller's source is included so it can instead be built on the target.

## Workloads and method

`generate.c` creates original C fixtures for externally visible writable byte arrays, readonly byte arrays, arrays with one live pointer relocation, and a function returning a large string literal. Each has a 1, 4, 16 or 64 MiB payload. Three further fixtures contain 256 separate 64 KiB writable, readonly or relocation-bearing arrays (16 MiB total). Literal sizes include their terminating zero byte.

`matrix --verify` (built from `matrix-initial.c`) compiles every fixture with the baseline, candidate and installed Clang, and checks target data bytes and pointer relocations with the independent ELF reader in `verify.c`. Every baseline/candidate object must also match in its entirety. The controller records separate fresh-process resource usage during these checks. Each source snapshot's `--time-stages` report is retained for attribution. The corrected timing controller is `matrix-v2`, built from `matrix.c`.

The final timing controller makes two standard `time-runs` invocations with all nineteen argument lists, two warmups, nine measured rounds and two fresh executable copies per build. One invocation lists the baseline first; the other lists the candidate first. Each input has its own fixed-size output file, shared only by its baseline/candidate processes. Thus each build/input has thirty-six measured processes across both build orders. Every accepted sample must exit zero. Whole compilation includes object generation and writing, process startup, page faults and teardown. The official tool records wall/user/system time, peak RSS, faults and user cycles/instructions; `summarize.c` recomputes pooled upper medians from the individual rows.

An initial matrix reused one output pathname across inputs of different sizes. Its first process after a size change incurred filesystem work that the following processes did not, producing biased wall-time comparisons (for example, a 64 MiB-to-1 MiB transition). That matrix is excluded from performance claims. The final controller uses distinct output files and both build orders. Correctness and compiler source revisions did not change.

Additional runs compare the complete frozen SQLite `-c` path, two copies of the identical baseline build (A/A), and a 64 MiB explicit-zero BSS control. SQLite uses the frozen source with SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d` and the workflow's `SQLITE_OMIT_LOAD_EXTENSION`, `SQLITE_THREADSAFE=0`, `SQLITE_ENABLE_MEMSYS5`, `SQLITE_ENABLE_RTREE` options. The unmodified corpus is an external runtime input and is not vendored.

## Diagnostic traffic and arena accounting

`instrument.c`, `probe_support.h` and `probe.c` produce separate API-level diagnostic binaries. They do not supply timing samples. The rewriter changes only a generated copy of `c_check_data.c` plus the standalone harness's inclusion/linkage glue. It counts explicit copied/cleared bytes and zero-classification byte visits, and observes logical high-water/live lengths of the emitter's byte and scratch arenas. Metadata clears and small scalar copies are included. Earlier decoding, TypeTable internals, allocator/kernel page clearing and the ELF writer's own traffic are outside these counters. Whole-process RSS/faults are measured separately.

The probes use checked plans with the same payload sizes and section cases. A live relocation has a four-byte addend in the API probe; the corresponding source fixture uses `&target` with a zero addend. Both need one ABS64 fixup and the same byte volume. The full source objects are independently checked for their actual zero addends.

The uninstrumented baseline and candidate disassemblies are retained. The baseline has a full byte reduction; the candidate uses a 64-byte load/test with an early exit, followed by a masked byte tail when necessary.

## Results

All nineteen source cases passed the three-compiler data checks and exact baseline/candidate object comparison. All 1,368 timed processes in the corrected matrix exited zero. `matrix-final-summary.tsv` contains every size; the two order-specific summary files and raw logs retain the spread.

Whole `-c` upper medians, in milliseconds:

| Input | Baseline | Candidate | Change | Baseline / candidate peak KiB |
| --- | ---: | ---: | ---: | ---: |
| writable, 64 MiB | 27.412 | 22.894 | -16.48% | 152,704 / 152,600 |
| readonly, 64 MiB | 27.426 | 22.858 | -16.66% | 152,668 / 152,596 |
| one relocation, 64 MiB | 27.354 | 22.912 | -16.24% | 152,708 / 152,608 |
| literal, 64 MiB | 576.399 | 571.884 | -0.78% | 292,360 / 292,292 |
| 256 writable objects, 16 MiB total | 7.830 | 7.233 | -7.62% | 58,752 / 58,684 |
| 256 readonly objects, 16 MiB total | 7.729 | 7.206 | -6.77% | 58,820 / 58,732 |
| 256 relocation-bearing objects, 16 MiB total | 7.773 | 7.232 | -6.96% | 58,828 / 58,736 |

For the 64 MiB writable case, user instructions fell from 41,214,276 to 22,298,953 (-45.90%), and user cycles from 51,555,496 to 26,904,539 (-47.81%). Both build orders improved: their writable medians were 27.529 → 23.088 ms and 27.312 → 22.837 ms. The readonly and relocation cases likewise improved in both orders.

The 1 MiB writable median increased from 2.195 to 2.249 ms (+2.46%, 0.054 ms), with overlapping process ranges of 1.837–2.796 and 1.836–2.707 ms. Smaller inputs do not establish a general speedup. SQLite's 45 processes per build measured 147.103 → 146.697 ms (-0.28%), 1,552,457,573 → 1,551,997,669 user instructions, and 512,872 KiB peak RSS in both builds; its wall-time ranges overlap. The identical-build A/A control measured 1.687 ms for both labels.

The 64 MiB explicit-zero control measured 5.932 → 5.704 ms, with peak RSS 85,092 → 87,084 KiB. Its object files matched and retained a 64 MiB NOBITS section. It still materializes the temporary zero image; this record claims no #596 improvement. The approximately 2 MiB RSS increase is retained in the results rather than hidden by the data-payload cases.

Diagnostic API counters for a single 64 MiB object:

| Case | Copied bytes, baseline → candidate | Scanned bytes, baseline → candidate | Scratch peak, baseline → candidate |
| --- | ---: | ---: | ---: |
| writable | 67,108,865 → 1 | 67,108,864 → 64 | 67,108,912 → 48 |
| readonly | 67,108,865 → 1 | 67,108,864 → 0 | 67,108,912 → 48 |
| literal | 134,217,728 → 67,108,864 | 67,108,864 → 0 | 67,108,912 → 48 |

The retained byte arena remains 67,108,864 bytes in each of these cases, and scratch live length returns to zero. For the 256-object relocation batch, scratch peak fell from 16,805,928 to 28,712 bytes, copied bytes from 16,779,264 to 2,048, and scanned bytes from 16,777,216 to zero. All diagnostic probes passed their Link/count checks. Each raw traffic row's column order is given at the beginning of `logs/matrix-verify.txt`.

The 64 MiB writable resource trace attributes 131,152 → 65,604 KiB of new process peak to publication, followed by 2,048 → 67,584 KiB at object building. These are single attribution traces, not timing distributions. They explain why the live publication image shrinks but whole `-c` peak RSS remains essentially unchanged: the later ELF image sets the process peak.

Target correctness qualification (`logs/tests-final.txt`) passed all six groups in 22.4 s:

- checker: 284,310 checks, zero failures, including new retained-storage, late rollback and protected-tail fixtures;
- driver: 21,591 checks in each of the normal and lazy-system-header modes, zero failures;
- Link tests;
- ELF object writer: 844 external cross-checks and 192 debug cross-checks, zero failures;
- call graph: 41 units, 23,959 functions, zero disallowed cycles and zero split mutable variables.

## Scope and reproduction

The change constructs materialized payloads in an unpublished suffix of retained byte storage and publishes Link records after the existing validation and capacity checks. Failed batches restore arena lengths without changing existing Link tables or symbols. An insufficient byte arena may use scratch for classification and exact capacity accounting; such materialized temporary bytes cannot be published. Explicit-zero objects that need no emitted payload are separate work in #596.

Whole `-c` peak RSS need not fall with the emitter's peak scratch length: `check_driver_object` subsequently passes the same scratch arena to `object_build`, which allocates the complete ELF image while retained atom bytes are still live. The baseline can reuse pages that its temporary payload already committed. Large literals can instead reach their process peak earlier in the frontend. The record distinguishes these whole-process peaks from the eliminated live scratch image during static-data publication.

Place archived baseline and candidate snapshots in `base/` and `head-final/`, build each through the shared target lock, and place these harness files beside them. Create `objects/`, `copies/` and `logs/`. Run `build-probes.sh` once through the lock to build the diagnostic tools and generate inputs. Build the two controllers with `clang -std=c17 -O2 -Wall -Wextra -Werror matrix-initial.c -o matrix` and the same flags for `matrix.c -o matrix-v2`. Use separate lock acquisitions for:

```sh
(cd head-final && taskset -c 0-7 ./build/compiler parallel --jobs 8 --timeout 180 ../tests.list)
taskset -c 2 ./verify-matrix.sh
taskset -c 2 ./matrix-v2 --time
taskset -c 2 ./matrix-v2 --time-reverse
./sqlite.sh
./aa.sh
./zero-control.sh
```

The scripts and logs record exact arguments. To recompute the final matrix, concatenate the two corrected timing logs and pass that file to `summarize`; the initial shared-output log under `excluded/` must not enter the summary. The original fixtures, controller, probe adapters, reader and summary tool are authored for this record; no external compiler implementation or corpus is incorporated. The included Buster sources are accessed at build time under their existing retained terms.

Lock-wait files are excluded from this public record because they contain other sessions' commands and links. Only this campaign's own outputs and selected build diagnostics are retained.
