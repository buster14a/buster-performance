# Tier 1 liveness #1384: exact-main verification, 2026-11-26

## Result and status

The implementation work for [buster#1384](https://github.com/buster14a/buster/issues/1384) is already merged in **`8e4d32879e17b7d9548cad54257a2f8461328366`**. This record verifies the original short-circuit inputs and the accepted nonlocal, scoped-loop, frame-object, and spill-analysis follow-ups against that exact revision. It introduces no compiler change.

All seven production shapes below compile at 64, 8,000, 16,000, and 32,000 elements in both tiers. Every Tier 1 run uses `--tier1-strict --tier1-report`; all 28 report one compiled function, zero resource failures, and zero fallbacks. Their generated code matches an independently compiled compact Clang reference for 15 inputs apiece: **840 successful comparisons**, including return values, external-call counts, and call-argument hashes.

The original 32,000-operand `||` now peaks at **112,892 KiB (110.25 MiB)** in this environment. This supports completion of the reported representation change; it is not an on-host comparison with the issue's historical 4,046 MB result. Source, build, host, and date differ. No throughput or speedup claim is made.

**The issue's previously requested Ryzen 7 9700X acceptance remains unverified.** The user's standing instruction excludes access to, and queuing work on, that machine. This record leaves that acceptance item explicit rather than declaring the entire qualification complete. No hardware workflow was started. Hosted test limitations and a distinct newly discovered address-value capacity problem are recorded below.

## Merged implementation

| PR | Implemented change |
| --- | --- |
| [#2662](https://github.com/buster14a/buster/pull/2662) | Excludes edge-local phi operands from global liveness, preserves their exit intervals and edge sources, removes `passed`, and constructs edge predecessor ordinals in linear work while preserving original phi order. |
| [#3435](https://github.com/buster14a/buster/pull/3435) | Solves genuinely nonlocal values in groups of at most 512; consumers use sorted per-block live lists. |
| [#3521](https://github.com/buster14a/buster/pull/3521) | Bounds frame-object lifetime storage with one reusable group and touched-block propagation. |
| [#3522](https://github.com/buster14a/buster/pull/3522) | Uses a touched-block liveness worklist above the 65,536 block-by-group ceiling. |
| [#3536](https://github.com/buster14a/buster/pull/3536) | Replaces full-CFG spill-slot group sweeps with touched rows and propagation of changed slot facts. |

Independent source audits are retained in [liveness-audit.md](liveness-audit.md) and [frame-audit.md](frame-audit.md). They found no concrete remaining defect in the claimed representation changes. They do not establish universal linear complexity: realized live memberships and interval fragments can themselves be quadratic.

## Production peak RSS

One compilation per cell, Linux child `wait4().ru_maxrss`, in KiB; parent-process memory is excluded. No averaging or timing comparison is implied. Every cell is a successful strict Tier 1 compilation. All inputs use `--lanes 1 -std=c17`; the 64-element runs additionally use `--verify`.

| Shape | 8,000 | 16,000 | 32,000 | 32,000, MiB |
| --- | ---: | ---: | ---: | ---: |
| `or`: one `a == i || ...` expression | 36,944 | 59,864 | 112,892 | 110.25 |
| `and`: one `a != i && ...` expression | 36,404 | 59,792 | 115,248 | 112.55 |
| `statements`: repeated `r = r || g(a + i)` | 105,532 | 197,920 | 382,340 | 373.38 |
| `nonlocal`: scoped `t = g(a+i); if (a > i) h(t)` | 167,500 | 310,952 | 627,628 | 612.92 |
| `loops`: distinct scoped loops with observable checksum | 188,436 | 306,360 | 596,932 | 582.94 |
| `returns`: repeated `if (a == i) return i*7` | 137,784 | 252,080 | 491,744 | 480.22 |
| `frame_local`: original #3521 short-lived address-taken arrays | 117,276 | 221,360 | 417,288 | 407.51 |

Raw Tier 0 and Tier 1 observations, exact compiler arguments, production selection reports, and runtime output are in [cases/](cases/). [results.tsv](results.tsv) joins the resource receipts and semantic comparison results. Tier 0 is an additional compiler path, not the independent oracle.

For `frame_local`, each scope declares `char buf[32]` and conditionally passes its address to a separately compiled `take`. The stub never reads the uninitialized buffer; it records the call through `h(1384)`. This reconstructs the original frame-lifetime stress shape without introducing undefined reads.

## Correctness and certificate coverage

The existing suites ran using the same exact-main Release product as the stress inputs:

| Command | Observed result |
| --- | --- |
| `test-tier1-cfg` | 107,509 checks, zero failures; 1,880 certified allocations; 2,068 forced-sparse/dense allocation matches and 2,003 sparse live-list/walk matches. |
| `test-tier1-emit` | 257,194 checks, zero failures. |
| `test-tier1-allocation` | 92,098 allocation checks, 2,147 certificate checks, 17 interval-certificate checks, and 57,753 successful allocations certificate-checked; zero failures. |
| `test-tier1-masks` | 211,144 checks, zero failures, including 1,280 native/interpreter results. |
| `test-tier1-frame` | 1,173,169 checks, zero failures. |
| `test-tier1-frame-execution` | 14,646 checks, zero failures. |
| `test-tier1-cfg-source` on the seven initial 64-element inputs | Seven functions certified and allocated; zero failures, malformed functions, unsupported inputs, or sparse differences. |

The source suite initially ran with `--simd` on integer-only inputs. Its semantic counters were clean, but it correctly returned failure because no mask values were exercised. The corrected invocation without `--simd` passed. Both raw logs are preserved; this input set does not claim SIMD coverage. The separate masks suite supplies the execution coverage stated above.

**`test-tier1-pipeline --cross-check` failed:** 3,959 checks, three failures, 1,088 native results, zero Clang results. Two timeout-cleanup assertions depend on `/proc/self/task/<pid>/children`, which is absent in this environment. A standalone probe confirmed `ENOENT` for that file while subreaper setup, `setsid`, orphan adoption, and `waitpid` worked. Because those assertions failed first, the suite's `cross_check && test.failures == 0` guard skipped Clang; the expected result-count assertion then failed too. This was not an observed Clang mismatch and is not reported as a passing suite. See [frame-audit.md](frame-audit.md), [tests/pipeline.log](tests/pipeline.log), and the [capability probe](probe-frame-audit/proc_children.c).

The separately linked stress-program comparisons did run and pass; they do not replace the omitted pipeline oracle coverage.

## Distinct finding: entry-defined frame addresses

An additional `frame` shape initializes a 32-byte buffer in each scope, observes its bytes through an external call, and returns early when `a == i`. It is deliberately broader than the original `frame_local` case. Its 64-element version passes both tiers and all 30 semantic comparisons; its 8,000-element version passes Tier 0 and 15 comparisons but fails strict Tier 1:

```text
Tier1 resource failure: emission, cause=cfg-allocation error=2 instruction=4294967295 detail=0 (Tier0 fallback forbidden)
```

The 8,000-case receipt records exit 1, no signal, and 673,788 KiB RSS. No Tier 1 object or semantic result is claimed. The campaign stopped this broader shape there; its generated 16,000/32,000 source hashes are retained only as generated inputs, not completed runs.

Bounded follow-up compilation succeeds at 512 scopes (68,404 KiB RSS) and fails with the same capacity error at 1,536 scopes (74,960 KiB). These two receipts retain exit status and RSS; their compiler stderr was only returned in the tool transcript. The complete failure text is retained for the 8,000 case.

Small IR and production assembly show frame-address values defined at function entry and retained until later calls. Early-return blocks fragment their live intervals. The inferred triangular number of address intervals exceeds the allocator's `1 << 20` limit around this size; the internal production interval count was not instrumented. Allocation happens before frame-object lifetime analysis and before dead rematerialized definitions are dropped. This is a separate address-placement / early-rematerialization problem, not a return of a dense block-by-value or block-by-slot matrix. See [liveness-audit.md](liveness-audit.md) and [diagnostics/](diagnostics/).

These additional successful broad-shape runs bring the raw comparison total to **885**; the original seven-shape result remains **840**. Keeping these totals separate prevents the failing broader case from being hidden in a pooled pass count.

## Binary, host, and reproduction

Local Release builds were killed before producing a usable compiler, both with four jobs and with split Release/single-job settings. Memory pressure was suspected; the retained logs report `Killed` rather than a kernel OOM diagnosis. A local linker search-path issue was resolved using the installed `libxml2.so.2`, but the subsequent frontend compile was still killed. Their logs are retained in [build-attempts/](build-attempts/).

Validation instead used the retained **unsanitized vector O3 Release artifact built from the exact audited revision** in successful hosted run [45779319802](https://github.com/buster14a/buster/actions/runs/45779319802). The archive digest, inner product digest, identity revision/tree, and all 16 product-file hashes were verified. The local ISA capability probe matched the artifact's required vector features. No new CI run was requested.

| Identity | Value |
| --- | --- |
| Source revision | `8e4d32879e17b7d9548cad54257a2f8461328366` |
| Source tree | `8bf0a22e6067a7698ca6257d3e6cbe40f49b108a` |
| GitHub repository ID | `1421805693` |
| Hosted run | `45779319802` |
| Artifact ID | `15097652285` |
| Artifact name | `vector-product-O3-1-none-83c4deb352dd5d861287ce0aea6159775aa2b074b4b89886ad28a8871da6f2ef` |
| Downloaded ZIP SHA-256 | `2fccc1df8f82a0b5485ef16fdc8000280c65032fa1e99f7aba1068b79877775d` |
| Inner product archive SHA-256 | `83c4deb352dd5d861287ce0aea6159775aa2b074b4b89886ad28a8871da6f2ef` |
| Validation CPU | Intel Xeon Platinum 8370C, cloud VM |
| Reference compiler | Clang 23.1.4, LLVM `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`, `-O2` |

[PROVENANCE.md](PROVENANCE.md) describes incorporated original material and external tools. [reproduce-notes.md](reproduce-notes.md) gives the commands and oracle contract. The C harness [validate1384.c](validate1384.c) generates every stress input, compact reference, and driver, and records child RSS without interpreting wall time. The small four-element unrolled and compact references were also compared under Clang UBSan before the large campaign; their outputs are retained in [oracle-qualification/](oracle-qualification/).

This record preserves exact source, object, and runtime-output digests. Large generated sources, executables, the downloaded toolchain, and the CI compiler binary are not duplicated in the evidence repository; their generators or upstream artifact identity are provided. No signed download URL, credentials, or private conversation content is included.

---
Agent session: `6b07ef94-8120-83eb-9da1-dd9f28574068` (OpenAI session ID; no share URL is exposed). Contributing tasks: `/root`, `/root/liveness_audit`, `/root/frame_audit`, `/root/validation_setup`.
Model: OpenAI / GPT-6 Astra Pro
