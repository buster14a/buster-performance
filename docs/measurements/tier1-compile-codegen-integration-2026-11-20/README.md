# Buster built by Buster, and linked C programs

These local correctness and code-size measurements cover four individual compiler changes and six changes combined. Every comparison uses the same 43 source units at Buster commit `5449b579cdc4bd21e8d7c7e0c71ac0eb1ad3c6cd`, compiled in the same directory with one lane, Tier 1, `-O2 -march=znver5`. The source and flag lists are included in both text and the harness’s NUL-separated format. The test host was a Ryzen 9 7940HS.

| Compiler change | Identical objects / 43 | Sum of object .text, bytes | Functions smaller / larger | Linked stage-2 .text, bytes |
| --- | ---: | ---: | ---: | ---: |
| #3117 scaled integer products | 12 | 42,528,915 → 42,523,445 | 619 / 2 | 50,042,915 → 50,037,219 |
| #3119 inliner summary | 43 | 42,528,915 → 42,528,915 | 0 / 0 | 50,042,915 → 50,042,915 |
| #3120 signed conversions | 40 | 42,528,915 → 42,528,909 | 2 / 0 | 50,042,915 → 50,042,915 |
| #3122 scalar FMA, compared with #3120 | 42 | 42,528,909 → 42,528,909 | 2 / 0 | 50,042,915 → 50,042,915 |
| Six changes combined | 11 | 42,528,915 → 42,523,439 | 621 / 2 | 50,042,915 → 50,037,219 |

Each object set contains 10,464 matched ELF function symbols. On #3117 the two larger functions are the two unity-object copies of `foreign_unwind_prune`, each 67 bytes larger. Individual function sizes omit inter-function alignment. Section sizes include it. A full-object match also covers data, relocations and symbol tables. The per-function and per-section tables give exact bytes and digests. The measurements here describe the generated compiler’s size. Runtime counters for individual changes belong to their respective hardware records.

All nine stage-1 compilers in `compilers.tsv` passed the repository’s self-host harness. Each built 43 units, linked the resulting compiler with the pinned host toolchain, passed 14 stage-2 smoke commands and compiled five probes with each stage. Ten byte comparisons and ten executable runs passed per harness invocation. Run the `tools/ci/selfhost.c` harness built with the pinned Clang 23.1.4 from the frozen source checkout, passing `STAGE1 ABSOLUTE_SOURCES_ARGV ABSOLUTE_TIER1_FLAGS_ARGV NEW_OUTPUT_DIRECTORY 900`. The paths in `compilers.tsv` name those output directories for `compare-bootstrap.py`. Set `BUSTER_TEST_HOST_BUSY=0` to model an idle host in the arena-policy smoke test. The stage-2/3 full compiler binary fixed point was outside this harness.

The combined candidates were the functional changes of #3117, #3119, #3120, #3121, #3122 and #3123, applied to the frozen source commit. Reproduce the candidate tree by replaying `735e25f71`, `2115a6e1c`, `7b6272d08`, `786e48c3b`, `7dd1a7aba`, `a5e74c987`, and `aba549e23` without committing. The tree ID was `11f42f5cc5bc90caa1c7c972c243def282ac4dde`. These builds precede any later scheduling-model measurements.

The baseline and combined candidate also passed every program in the upstream c-testsuite at `5c7275656d751de0e68b2d340a95b5681858ed07`. All 220 linked programs passed against Clang and all 430 functions went through Tier 1. The size comparison matched 380 stripped program functions. Their combined size fell from 62,350 to 62,298 bytes and total text fell from 63,662 to 63,598. Both exceed the existing, unenforced Clang comparison. The size reference contained 45,748 matched bytes and 48,981 total text bytes. Use `test-c-testsuite --cross-check --tier1 --code-size --jobs 2 --timeout 45 --clang CLANG --subset tests/c-testsuite/subset.txt CORPUS` from each source checkout.

An initial ambient-load bootstrap exposed eleven arena resource-profile test failures. The same eleven reproduced on both original compilers and both generated compilers when the documented busy-host override was set. With the idle override both generated compilers passed all 146 arena checks and the complete harness. No arena implementation or expectation was edited.

## Full compiler fixed points

The baseline and the six-change candidate each compiled its own source tree twice through the self-host harness, using the first generated compiler to produce the next. For each variant all 43 object files and the complete linked stage-2 and stage-3 executables matched byte for byte. Each stage also passed the smoke and executable probes. The baseline executable’s SHA-256 was `4e693e0f6ff037bdc13034c5fe8c41cf7ae4eba0ccd53ad11c11417a7edb952a`. The combined-source executable’s was `f6bf3cadc2d83673909ac00d515927cf8d937e629497a519a091382ea938d282`. The per-file comparisons are in `fixed-point.tsv`. This follow-up uses the candidate source when checking the candidate fixed point. The earlier table compiles one common source as the code-size workload.
