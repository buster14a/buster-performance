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
