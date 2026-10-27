# Overload declaration indexing — Buster #612

Paired qualification of compiler PR [#638](https://github.com/buster14a/buster/pull/638). On the retained 8,000-prototype declaration-only input, median compilation falls from **449.819 ms to 24.087 ms (18.675× faster)** and user instructions fall **98.233%**. Median peak RSS increases **4,068 KiB**. The exact compatibility checks remain in the matching signature buckets.

## Sources and build identity

- Parent: [`92c025e71856d13eb34247477c5294d2cead139e`](https://github.com/buster14a/buster/commit/92c025e71856d13eb34247477c5294d2cead139e).
- Fix: [`8b6f52351b34e85896203d626542486b7bdc4889`](https://github.com/buster14a/buster/commit/8b6f52351b34e85896203d626542486b7bdc4889).
- Both compiler images were built natively on the AMD Ryzen 7 9700X with Clang 23.1.1 and `BUSTER_DEBUG_INFO=0 ./build.sh`, including the repository's release `-O3 -march=native` flags. Each build held the shared exclusive lock. [Build logs](9700x/base-build.txt), [head build log](9700x/head-build.txt), [host metadata](9700x/host.txt) and [binary/input/helper hashes](9700x/SHA256SUMS) are retained.
- The [parent source manifest](9700x/base-source.sha256) covers 646 tracked files; the [head manifest](head-source.sha256) covers 648. The [head target-tree check](9700x/head-source-check.txt) verifies every file against the recorded source bytes.
- The generic x86-64 generator and process runner were built on the development 7940HS with Clang 23.1.4, without `-march`. Their [build identity](local-helper-build.txt) and target-used binary hashes are retained. They orchestrate the native target compiler images.

## Measurement method

One short locked `procbench --paired --rounds 5` invocation measures all four adjacent parent/fix pairs. Pair order rotates by round and the order inside every pair alternates. Every executable/argument list gets one discarded warmup before its timed process in every round: **40 timed processes and 40 additional warmups**. Each compiler child is pinned to CPU 2 and compilation explicitly uses `--lanes 1`. CPU 2's performance governor and offline sibling CPU 10 are recorded in the metadata.

Wall time spans releasing the child through `wait4`; it includes fresh-process startup, compilation, object output and teardown. Hardware counters are enabled at the child's exec, inherit to its threads, and exclude kernel/hypervisor execution. RSS is Linux's child peak in KiB. Table columns have independent medians. Every warmup and timed process exited **0**, all counters were positive without a multiplexing marker, and all 80 processes had zero major faults.

[Raw samples](9700x/overload-matrix.tsv), the [exact command list](9700x/commands.list), [summary](summary.tsv) and [strict summary receipt](summary-validation.txt) are retained. The summary reader rejects nonzero exits, missing/multiplexed counters and incomplete sample sets. Independent known-statistic and rejection fixtures are recorded with the harness. All 160 stdout/stderr captures were empty; their [names and sizes](9700x/captures.tsv) are retained. Lock-wait messages naming other sessions are omitted from the published evidence.

The declaration inputs use the unchanged [original generator](https://github.com/buster14a/buster-performance/blob/7d25666880d5bbdce838bab7e0f79a31d70d4c78/docs/measurements/performance-audit-2026-10-27/generate.c). Their exact bytes and hashes are retained in [inputs/](inputs/) and the hash manifest. These files declare distinct pointer-to-struct overloads and contain no calls.

## Declaration-only results

| Prototypes | Parent wall median (range), ms | Fix wall median (range), ms | Speedup | Parent user instructions | Fix user instructions | Parent / fix peak RSS, KiB |
|---:|---:|---:|---:|---:|---:|---:|
| 2,000 | 34.334 (33.673–34.584) | 7.199 (7.158–7.244) | 4.769× | 974,866,593 | 76,497,783 | 64,712 / 66,716 |
| 4,000 | 119.041 (118.859–119.271) | 13.140 (13.070–13.198) | 9.059× | 3,734,032,616 | 137,293,917 | 98,952 / 100,912 |
| 8,000 | 449.819 (448.364–478.027) | 24.087 (23.742–24.334) | 18.675× | 14,652,392,147 | 258,913,488 | 144,148 / 148,216 |

Growing the input fourfold increases measured instructions **15.030×** in the parent and **3.385×** in the fix. This qualifies the retained distinct-signature declaration workload. The transient index adds bounded memory; the measured peak increases are 2,004, 1,960 and 4,068 KiB.

The reader uses eight-lane signature bucket probes with an exact scalar twin. Incremental type fingerprints reuse the append-only type DAG and stop at nominal tags; the small dependency chain created at each ordered declaration is hashed once. Exact signature/return/ABI/linkage checks still decide matching keys. Checked snapshots can summarize older compatibility and attribute state; ordinary declarations must first have their complete history checked. Source candidate chains remain immutable. The existing source-order gate for overloadable units remains in place.

## Default-path control

The same paired invocation compiles the frozen SQLite translation unit and pinned predefines under `/var/lib/buster-9700x/corpora/preprocessor-391e729af658`, with the frozen include directories and `SOURCE_DATE_EPOCH` specified in the command list. [Control input hashes](9700x/control-input.sha256) identify those external corpus inputs; their implementation is not copied into this record.

| Metric | Parent | Fix | Change |
|---|---:|---:|---:|
| Wall median (range), ms | 144.133 (143.735–144.953) | 144.063 (143.543–144.411) | −0.049% |
| User instructions | 1,529,976,023 | 1,530,076,001 | +0.0065% |
| User cycles | 677,400,546 | 678,789,798 | +0.205% |
| Peak RSS, KiB | 505,904 | 505,892 | −12 KiB |

The wall ranges overlap. One frozen optimized image per source supplies insufficient evidence for a small timing change or neutrality; no layout-copy/shift campaign was performed. These synthetic declarations establish no corpus-wide frequency, broader compiler speedup or call-site overload-resolution speedup.

## Correctness qualification

- Locked 9700X full checker, Clang 23.1.1: **265,650 checks, zero failures** ([output](9700x/test-checker.txt), [status](9700x/test-status.tsv)).
- Local release driver: **21,591 checks, zero failures**; inline-assembly and type suites also pass ([full local output](local-validation.txt)).
- Focused overload/source checks under ASan/UBSan: **2,615 checks, zero failures** ([receipt](local-overload-sanitize.txt)). The focused harness uses the source's checker/test code with static homes and section pragmas removed; it is a correctness run, not a performance image. Leak detection is disabled, as the recorded command shows.
- Disabling the checked-history guard produces the expected regression failure ([mutant receipt](local-overload-mutant.txt)). Scalar/vector index probes cover forced bucket collisions, distinct scopes, a full table, an exact guarded tail, allocation failure, aligned type DAGs and 1,024 declarations compared with the original full-history oracle. Source fixtures cover scope restoration, linkage/ABI conflicts and inheritance, attributes, definitions and non-transitive old-style return compatibility.
- Local full checker has four `fpclassify` differences against Clang 23.1.4. The two unchanged parent-source fixtures reproduce the same four differences ([parent control](local-parent-fpclassify.txt)); the physical full checker above passes. The parent control uses the recorded isolated harness, not a full optimized parent build on the development host.
- Call graph: **41 units, 23,965 functions, 143,500 calls; zero unallowed cycles and zero split variables**, with three existing allowed cycles ([receipt](local-call-graph.txt)).
- The queued duplicate target driver/asm/type runs were stopped after the physical checker passed; their local counterparts already passed ([scope record](9700x/target-test-scope.txt)). Full GitHub CI is tracked separately on PR #638.

## Reproduction and provenance

The [harness directory](harness/) retains the C generator, process runner, strict statistics reader, focused correctness harnesses and orchestration commands. Set up native parent/fix trees as `base/` and `head/` under the recorded campaign directory, build both through the shared lock, build the generic helper binaries with the recorded commands, then run `run-measure.sh` and `run-controls.sh`. The latter records control identities already measured by the matrix. Analyze with `clang -std=c17 -O2 -Wall -Wextra -Werror summarize.c -o summarize` followed by `./summarize evidence`.

`procbench.c` is adapted from this repository's `docs/measurements/link-foreign-team-501-2026-10-26/procbench.c` at `b2e5db81e06e1570d23d143d7fc34747cc54abbd` (blob `78cabb8f8315a62ee8be80a0289781e53dfd6725`). The local changes exclude kernel/hypervisor events and add paired round ordering. Its original SPDX/copyright notice is retained. The generator is byte-identical to the discovery generator. `main-smoke.c` is derived from Buster's `main.c` at the recorded source: its section pragmas are removed and `BUSTER_ELSEWHERE` is static; its header is retained. The parent control executes the two existing fixtures from `c_check_program_test.c`. No external implementation or fixtures are imported; Clang runs externally as an oracle. This record follows the repository's retained Apache-2.0 WITH LLVM-exception terms.
