# Preprocessor file comparisons in the merge queue

[Issue #2658](https://github.com/buster14a/buster/issues/2658) targets the wall time and runner-minutes of passing merge candidates. This experiment covers the inventory command “Test the preprocessor on the repository's translation units against clang [2 CPUs]”.

| Revision | Change |
| --- | --- |
| `2d20b182634bf61233675a8c7b7921bbda8c5ce8` | Parent of both changes |
| `417d1afb16575c33fae7811d96b9f2c8c5956ed6` | Share the recorded compile between the scalar and deferred-history comparisons. Reuse the marked text in the exact-text, directive and placement checks. [PR #3523](https://github.com/buster14a/buster/pull/3523) |
| `079138b0e5c8d91cb2e2178aa08c55fe672212f4` | Start another file when a worker finishes. Collect counts and print diagnostics in argument order. [PR #3529](https://github.com/buster14a/buster/pull/3529) |
| `8d7232b646430144a91c6e00a836bd94b51979fc` | Limit the polling header to the frontend unity unit. The scheduling implementation is identical to `079138b0e`. This is the submitted head of [PR #3529](https://github.com/buster14a/buster/pull/3529). |

## Paired command measurements

Each binary reads an identical checkout of the parent revision. The inventory includes the preprocessor test's own source through `main.c`, so holding the input revision fixed matters. The vector Release builds use the repository's pinned LLVM 23.1.4 toolchain, `-O3` and the configured sanitizer and runtime options. Each comparison uses the same Clang server build. The changed executables relink the owning frontend object with the other objects from the corresponding baseline, except the final MSan executable, which uses the normal full Release build. The address build uses the same post-link table baking as the baseline.

The cloud machine has an AMD EPYC 9V74 and a four-CPU quota. Each timed command has affinity to CPUs 0–3. On the Ryzen 7 9700X, each run takes the shared host lock, uses the same executable and has affinity to CPUs 4,12,5,13. In both environments the inventory command receives its normal grant of two CPUs. Clang's resource headers come from `clang -print-resource-dir`. Each sanitizer uses the runtime options emitted by `tools/ci/sanitizers.sh configure`.

From the parent source tree, with the selected compiler, Clang server and runtime settings in the environment, run

```bash
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
export BUSTER_HOST_ARCH=vector BUSTER_PARALLEL_CPUS=2
export BUSTER_CLANG_RESOURCE_DIR="$(clang -print-resource-dir)"
mapfile -d '' -t host_flags < <(./build.sh print-host-flags)
"$compiler" test-preprocessor --clang -target x86_64-pc-linux-gnu \
    "${host_flags[@]}" -Isrc -fwrapv -funsigned-char -DBUSTER_COMPLETE_DRIVER=1 \
    src/buster/compiler/main.c src/buster/compiler/*_benchmark.c \
    --clang-server "$server"
```

Bash's `time` reports elapsed, user and system seconds including children. For a hosted job the compiler's parallel runner reports elapsed seconds, CPU seconds and peak MiB. Compare test command times within a host, target and sanitizer. The queue draws a mix of CPU models for a single candidate.

## Ordering and resource checks

`check-file-order.sh COMPILER` wraps Clang for three files and grants two CPUs. The first file waits for the third and the third requires the second to have reached its final macro check. The old scheduler reaches the wrapper timeout. The new scheduler completes all three and prints their warnings in input order. The 66-file descriptor check uses one file containing 50,000 declarations, 65 small inputs and a soft descriptor limit of 24. Guard, macro dump, line placement and token comparisons also ran with `-dD`, `-dI`, both options and without the Clang oracle.

## Merge-queue accounting

The job TSV columns are job ID, name, start, completion and conclusion for the specified attempt. Running minutes sum elapsed job time for jobs that executed. Wall time runs from workflow creation to completion. The JSON command excerpts retain the reported CPU model, host target and sanitizer. The original issue's 32.8 minutes and 962 runner-minutes describe an earlier suite. Candidate-wide differences across revisions also include concurrent main changes, runner draws and queue conditions.

## Results on fixed inputs

### Ryzen 7 9700X

| Sanitizer | Parent elapsed | #3523 elapsed | Both changes elapsed | Elapsed reduction | Parent CPU | Both changes CPU |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ASan, UBSan and LSan | 66.83 s | 63.84 s | 41.59 s | 37.8% | 86.07 s | 81.82 s |
| MSan with origins | 37.86 s | 34.65 s | 23.73 s | 37.3% | 49.27 s | 46.37 s |
| TSan | 52.08 s | 48.89 s | 32.66 s | 37.3% | 67.92 s | 64.03 s |

The last column pair uses revision `079138b0e`.

### AMD EPYC 9V74 cloud instance

| Sanitizer | Parent elapsed | #3523 elapsed | Both changes elapsed | Elapsed reduction | Parent CPU | Both changes CPU |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ASan, UBSan and LSan | 186.67 s | — | 122.25 s | 34.5% | 242.58 s | 239.83 s |
| MSan with origins | 183.97 s | 168.20 s | 114.57 s | 37.7% | 237.44 s | 222.19 s |
| TSan | 159.90 s | 186.37 s | 102.07 s | 36.2% | 207.37 s | 198.62 s |

The last column pair uses revision `079138b0e`.

Every timed command compared all 66 inputs and their system levels, served all 133 Clang requests and reported zero differences. The source inputs and token totals match within each host. The systems supply different headers, yielding 30,793,478 tokens on the 9700X and 30,791,614 in the cloud. CPU seconds include the children. Each cell uses the median of the recorded samples at that revision. [Per-command values and sample counts](command-times.tsv)

## Passing merge-queue candidates

| Revision | Passing candidate | Wall minutes | Runner-minutes |
| --- | --- | ---: | ---: |
| Branch parent | [45353862009](https://github.com/buster14a/buster/actions/runs/45353862009) | 24.6 | 388.9 |
| Queue parent of #3523 | [45363391633](https://github.com/buster14a/buster/actions/runs/45363391633) | 24.6 | 377.1 |
| #3523 | [45363394830](https://github.com/buster14a/buster/actions/runs/45363394830) | 26.7 | 384.8 |
| Next queue candidate containing #3523 | [45363397899](https://github.com/buster14a/buster/actions/runs/45363397899) | 24.6 | 384.3 |

Each command is compared with earlier passing candidates using the same CPU model, compiler target and sanitizer. The controls come from jobs that ran before either change. Runner assignments and other changes in a queue group can still affect a command. [CPU seconds, control runs and job IDs](queue-command-comparisons.tsv)

| Candidate | Target and sanitizer | CPU | Earlier samples | Earlier median | Candidate | Elapsed change |
| --- | --- | --- | ---: | ---: | ---: | ---: |
| #3523 | native none | Xeon 8370C | 1 | 41.5 s | 37.2 s | -10.4% |
| #3523 | vector memory | AMD EPYC 9V74 | 3 | 186.5 s | 169.0 s | -9.4% |
| #3523 | vector address | Xeon 8573C | 3 | 252.5 s | 236.7 s | -6.3% |
| #3523 | vector thread | Xeon 8370C | 2 | 265.95 s | 239.1 s | -10.1% |
| #3523 | vector none | Xeon 8573C | 3 | 49.5 s | 46.7 s | -5.7% |

## Remaining work, ranked from the parent candidate

1. **Critical-path MSan product build and correctness run.** The last vector worker spent 512 seconds building the product, 619 seconds in the correctness inventory and 100 seconds compiling `main.c` alone. Profile the build and its longest translation units with the owners of #2639 and #2627. [Worker steps](base-critical-worker-steps.tsv)
2. **Product waits and coverage builds.** Twelve consumers spent a total of 80.5 runner-minutes waiting for their vector configuration's product. The later #3523 candidate spent 75.9 runner-minutes on this step. Three instrumented coverage builds accounted for 41.2 runner-minutes in the parent. These totals rank throughput opportunities. The vector pool is tracked in #2033 and shared products in #2032. [Parent step totals](base-step-totals.tsv) · [#3523 step totals](first-step-totals.tsv)
3. **Typed postorder fixtures and semantic-driver comparisons.** On vector TSan, typed postorder part 6 took 358.3 seconds and semantic-driver part 10 took 303.7 seconds. Vector MSan typed postorder part 7 took 195.3 seconds, and its semantic-driver part 4 took 179.9 seconds. These commands can overlap on a runner, so elapsed seconds do not add directly to the candidate. [Inventory headings and CPU times](base-inventory-excerpts.tsv)
4. **Per-file work on repository translation units.** This separate command took 276.7 seconds on vector TSan and 200.5 on vector MSan. The previously unprofiled flat frozen C library command took 12.1 and 6.9 seconds respectively on the same candidate. The repository-input command merits the next per-file profile. [Inventory headings and CPU times](base-inventory-excerpts.tsv)
