# Tier 1 lifetime scaling on the Ryzen 7 9700X

At 16,000 unbraced returns, the checker took **2.439 ms on main, 1.422 ms with the fix, and 1.420 ms with lifetimes disabled**. Across all four sizes the fix and the disabled control agreed within 0.02 ms. [PR #3549](https://github.com/buster14a/buster/pull/3549) · [Issue #1355](https://github.com/buster14a/buster/issues/1355)

## Original return chain

Each cell is the median `check-program` time in milliseconds across seven fresh compiler processes on CPU 2. Main is `7515714d05caa655e8c2e1e2776e07aa9b8058df` and the fix is `e986851fdc606adb6f9cd6272fa4515321a10990`. Off uses the same proposed binary with `--tier1-no-lifetimes`. [Per-run timing data](return-fix-samples.tsv)

| Arms | Main | Fix | Lifetimes off |
| ---: | ---: | ---: | ---: |
| 4,000 | 0.705 | 0.427 | 0.428 |
| 8,000 | 1.224 | 0.621 | 0.625 |
| 16,000 | 2.439 | 1.422 | 1.420 |
| 32,000 | 4.619 | 2.907 | 2.924 |

Each configuration compiled the issue's source using `-w -c --tier1 --time-stages`. Benchpress built both executables with `BUSTER_HOST_ARCH=znver5 ./build.sh --config Release` and the project's Clang 23.1.4. Each compiler invocation acquired the host lock separately and the configurations rotated across repetitions. The three configurations produced byte-identical objects at all four sizes. [Build identities](environment.txt) · [Host activity](host-activity.txt.gz) · [Input hashes](inputs.sha256) · [Object hashes](return-objects.sha256)

The follow-up's `test-checker --seed 133 --part 5/8` passed 201,004 checks and recorded zero lifetime-walk steps on the new function-body-only fixture. [Checker results](checker.txt)

## Jumps that leave blocks

The initial acceptance comparison uses Release builds of #3245 and its first parent on the same host. Each cell is the seven-run median `check-program` time in milliseconds from object compilations. The off control uses the merge binary with lifetimes disabled. [Stage samples](stage-samples.tsv) · [PR #3245](https://github.com/buster14a/buster/pull/3245)

| Arms | Goto before | Goto after | Goto off | Break before | Break after | Break off |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 4,000 | 31.254 | 1.486 | 0.688 | 16.308 | 1.370 | 0.660 |
| 8,000 | 121.885 | 2.769 | 1.370 | 61.289 | 2.705 | 1.307 |
| 16,000 | 505.869 | 5.865 | 2.735 | 248.443 | 5.377 | 2.662 |

The historical pair produced identical objects for the 16,000-arm goto-out and return cases. At that depth, the older goto-out profile attributed 14,970 user-cycle samples to the stamp/bypass walks and 13,260 to the control writer’s ancestor walk, out of 32,717 samples in total. [Object hashes](historical-objects.sha256) · [Cycle profiles](profile-summary.tsv) · [Source-line histograms](profile-leaves.tsv.gz)

## Ordinary compilation

Before and after #3245, whole-compile median wall time was 607.645 and 613.154 ms for SQLite and 79.519 and 79.924 ms for the 220-program c-testsuite subset. Each workload emitted identical object hashes across all seven paired rounds. [Samples](ordinary-samples.tsv) · [SQLite object](sqlite-objects.sha256) · [c-testsuite objects](suite-objects.sha256)
