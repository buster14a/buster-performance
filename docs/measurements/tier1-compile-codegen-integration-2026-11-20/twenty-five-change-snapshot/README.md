# Twenty-five compiler changes together

The [manifest](heads.tsv) records every input PR head. Main `3804c5e7b9468772d22209774843f06aabd70990` and the local integration commit `240c6f5a966964ab1fd7f80ca525defaa529ec2e` supplied the two compiler builds. To reproduce the source, decompress the [combined Git patch](combined.patch.gz) and apply it to the recorded main checkout. The patch also passed a clean apply check on later main `a8604029966a07c5ebcc16aaf24c73b80a13695e`, which merged two unrelated reducer files. The [merge tree](later-main-merge-tree.txt) and [changed filenames](later-main-files.txt) record that additional compatibility check. All performance figures below use the original controlled baseline.

The combined emitter capacity includes the sparse vector allowance and adds the x87 references once. Test merges retain all conversion directions, measured instruction assertions and the FMA addend and factor cases. The complete source patch includes those resolutions.

## Local compiler throughput

Eight alternated-order paired real compilations per workload ran on one lane of a Ryzen 9 7940HS. The table gives medians of the within-pair differences. All eight cycle pairs improved in each row. The [release](normal-summary.txt) and [debug](debug-summary.txt) summaries give observed ranges, with raw counters in the two process tables. The [six complete compiler profiles](profiles/) cover these three inputs in release and debug modes and include both function and source-line weights.

| Translation unit | Retired instructions | User cycles |
|---|---:|---:|
| Release SQLite | −2.350% | −2.248% |
| Debug SQLite at -O2 | −20.973% | −13.924% |
| Debug Lua VM | −32.146% | −24.307% |
| Debug Lua parser | −6.128% | −5.751% |

## Generated code and self-host correctness

Both compilers reached a byte-for-byte [self-host fixed point](fixedpoints.tsv) for 43 objects and the linked executable between stages two and three. On the same 43 source files, 801 of 10,476 matching functions shrank and 2 grew. Combined object text fell 68,292 bytes. On that identical source, the linked compiler used 68,896 fewer text bytes and 69,632 fewer file bytes. The [three linked compiler sizes](linked-compilers.tsv) also show the separately built candidate on its own source. [Totals](selfhost-totals.tsv) and [function-by-function changes](selfhost-function-changes.tsv).

Both release compilers passed 220 C programs and compiled all 430 functions with Tier 1, as well as the debug, pipeline, emitter, selector and inliner suites. In this corpus the candidate's 380 matched functions occupy 62,298 bytes versus 45,748 with Clang. The size comparison is recorded as a non-enforced failure in the [raw C-suite result](suites/candidate-c-testsuite.txt). The main-side release suite receipts use the exactly identical baseline compiler already qualified in the eighteen-change run.

The [suite receipts](suites/status.tsv) give individual exit codes. For ASan/UBSan and separate MemorySanitizer, six compiler suites completed in each configuration and the compiler, runner and child-report audits were clean.

## Full SQLite Tcl suite

The official testfixture runner compiled the same amalgamation for pinned Clang at -O0 and both Buster tiers, then ran the upstream full permutation with two jobs. The [runner summary](sqlite/summary.log) includes the check totals and comparisons. The individual test outcome and worker logs are retained in [the same directory](sqlite/).

The [direct 9700X measurements](9700x/) cover all three real inputs, with three post-warm-up pairs and complete hardware counter and object receipts.

The [fresh differential campaign](generated-programs/) records 238 common passes, 13 Clang reference timeouts and five common Tier 0 argument-limit diagnostics across 256 seeds.

[Six complete upstream Lua suites and 320 timed interpreter processes](lua/) cover language, C API and generated-program behavior.
