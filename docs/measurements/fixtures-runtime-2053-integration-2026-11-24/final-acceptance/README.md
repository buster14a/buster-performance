# Final acceptance on merged main

The compiler revision was [e347ec526](https://github.com/buster14a/buster/commit/e347ec526e0500377f0b329394810da9c879f2e4). All twelve implementation PRs for #2053 were ancestors of main. This rerun used Clang 23.1.4, x86-64 vector Release, and a configured Ninja build. The parent record and the five family records contain the before/after extraction, sizes, clean-build observations and full-suite results.

| Probe | Result |
| --- | --- |
| Add a raw C file and catalog row in the call-count suite | The configured Ninja build reported no work. The same executable ran 13 fixtures. Restoration ran 12. |
| Change source bytes or an expected warning count | The driver returned exit 1 for each change. |
| Orphan, missing file, duplicate ID, malformed row or empty catalog | Each returned exit 1. The restored checkout and an alternate fixture root passed. |
| Replace aggregates.ir with invalid IR | The IR parser failed. Restoration passed 12,226 checks across 52 functions. |
| Replace the header-diagnostic-percent golden with an incorrect line | The diagnostic comparison failed. The original golden passed before and after. |
| Change fixture timestamps, edit IR or change expected output | Ninja scheduled zero host commands. The compiler, checker object and frontend object retained their SHA-256 hashes. |
| Touch the driver runner in the checkout | Ninja scheduled one checker compile, a link and a bake. Restoring its timestamp produced an empty build plan. |
| Run the CI selector self-test | All 1,957 checks passed, including coverage for runtime fixture paths and documentation paths. |

The call-count run used `build/compiler test-checker-driver --call-counts-only --in-process --executable build/compiler`. The IR parser used `test-ir-parse --fixtures DIR`, and the diagnostic test used `test-preprocessor --part 3/64 --jobs 1 --fuzz 0 --fixtures DIR`. The Ninja target was `compiler` in `build/cmake/vector-g0/build-Release.ninja`. The saved transcripts include expected exit-1 controls.

The archived manifests match the 470 native programs, 465 private checker source and expectation files, 233 migrated preprocessor files and 107 driver inputs. One entry in the original warning manifest predates the reserved-macro fixture change in [#3524](https://github.com/buster14a/buster/pull/3524). I rebuilt the archived post-fortification C dumper with Clang and compared the output against current main. All 1,165 warning rows matched in order, including every source byte, count, flag, option and name. See `inventories.log` and `warning-extraction.log`.

The [merge-readiness record](https://github.com/buster14a/buster/issues/2053#issuecomment-7131724505) links the successful protected merge-queue workflows and records 243,200 passing checks across the 16 driver shards.
