# Oracle replay warm-cache check, 2026-11-05

This bounded investigation supports [buster#1342](https://github.com/buster14a/buster/pull/1342) and [#1317](https://github.com/buster14a/buster/issues/1317). It compares the effect of the intermediate safety fallback with its later safe-creation revision on one existing compiler test. It is not a general compiler or cache performance campaign.

| Source | Cache state | Taken | Tool run | Whole-command elapsed | Result |
|---|---|---:|---:|---:|---|
| `3b1b0c634037f958662699f8eaa83c818f726c9a` | cold | 1 | 663 | 19 s | 8,673,562 checks, 0 failed |
| `3b1b0c634037f958662699f8eaa83c818f726c9a` | warm | 664 | 0 | 7 s | 8,673,562 checks, 0 failed |
| `5f8d1784f0e36962c9bfbb772f2f88218d5efabf` | cold | 0 | 664 | 19 s | 8,673,562 checks, 0 failed |
| `5f8d1784f0e36962c9bfbb772f2f88218d5efabf` | warm | 0 | 664 | 19 s | 8,673,562 checks, 0 failed |
| `1a5565d5bb8dd78a05da3b57c6ff2089e80e1852` source | warm, populated by `5f8d1784` | 664 | 0 | 6 s | 8,673,562 checks, 0 failed |

The cold `3b1b0c63` run's one hit is an in-run reuse. Its following run uses the same cache. The `5f8d1784` runs use a separate initially empty cache; the final `1a5565d5`-source run reuses the cache populated by those runs, not an independently warmed cache. Each row is **one observation**, in the table's chronological order, with whole seconds from Bash `SECONDS`; it is neither a paired statistical timing study nor evidence for other suites. Cache hit counts show the effect on this workload, while the single elapsed times only provide a coarse indication. The current implementation still misses when an entry must remove a present output; this test does not establish how often that happens elsewhere.

## Machine and source identity

- Ryzen 7 9700X, Linux `6.18.50-2-lts`, Clang 23.1.1 (`/usr/bin/clang-23` SHA-256 `939a882527432ec23b094c289e7f170bf2d6ec282e74dde75e31b08602fa3eae`). Both builds used `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --jobs 4`.
- The first compiler was built from exact commit `3b1b0c634037f958662699f8eaa83c818f726c9a`; its published `build/compiler` SHA-256 was `2bfcd86a3a926fb2cd08d350a96c056d04aeb8dc9d85c015b94fd81872203030`.
- The intermediate compiler was built from tree `3a1f2b756ac7de027c2b1b6b6cce283979320f89`, whose only difference from `5f8d1784` was the temporary validation workflow `.github/workflows/tier1-problem.yml`. The intermediate executable was overwritten by the incremental safe-creation build before its binary hash was captured; it is not preserved, so there is no independently verifiable hash for that executable.
- The final compiler used that same worktree with the three-file safe-creation patch later committed as `1a5565d5`. The SHA-256 hashes of the tested files, verified against that commit, are `d4cdf6bc184f07dba08cb3dd3efbaf0c875e49062fcae23815eeec8579f6595d` (`src/buster/compiler/oracle_cache.c`), `5adb3ee72dda574fb291157d9e9673f7539013c04bd5185cf3b7dc8267d610f5` (`src/buster/compiler/oracle_cache_test.c`), and `d84aabb89eb8f7b0adcd241580196458cb7a463376777ab9fd11265d059d05ed` (`docs/commands/oracle-cache.md`). Its `build/compiler` SHA-256 was `7ce128d6d25c605f4c275c793b365390368fa579233408d5713a015553a664f5`. No generated executables or external corpus files are included here.

## Method and limitations

Builds and each individual test ran as separate calls to the shared `exclusive.sh` lock with the PR link and a descriptive owner/title. Each timing ran on logical CPU 2, after it acquired the lock. The effective command inside the lock was:

```sh
BUSTER_ORACLE_CACHE=use XDG_CACHE_HOME="$CACHE" \
  timeout 120 /bin/bash -c 'SECONDS=0; taskset -c 2 ./build/compiler test-tier0 --cross-check; code=$?; printf "elapsed_s=%s\n" "$SECONDS"; exit $code'
```

The baseline cold and warm runs used a new cache directory. The intermediate cold and warm runs used another new cache directory; the final run used that latter cache. No cache was cleared between a cold run and its warm run, or between the intermediate warm run and the final run. Lock wait is outside the measured command. Reproduction requires the repository and toolchain, the same host and cache settings, and the shared-host lock; results can vary with the machine and workload.

A separate `timeout 120 ./build/compiler test-oracle-cache` on the final source, under its own lock, passed 176 checks with no failures. Its expected fault-injection diagnostics appear in [safe-create-tests.log](raw/safe-create-tests.log); they are intentional test cases, not unexpected failures. The other [logs](raw/) record the full test output and exit-status-preserving elapsed line. Their copy here replaces the home-specific benchmark root with the literal `$BENCH_ROOT/` and removes lock-wait owner/title/link lines belonging to other sessions; all benchmark and test result lines are retained. These files are therefore sanitized transcripts rather than byte-identical originals.

The test program and fixtures are original project material under the repository's existing Apache-2.0 WITH LLVM-exception terms. Clang and system tools are external runtime dependencies; no third-party implementation or corpus is imported.
