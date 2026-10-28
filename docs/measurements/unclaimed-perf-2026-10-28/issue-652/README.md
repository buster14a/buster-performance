# Issue 652 local work and qualification

Frozen cleanup-only target qualification is complete in `target/README.md`.
Isolated A/A, A/B and reversed B/A validate tiny-process gains with no
meaningful SQLite regression; objects and preprocessor bytes match. A
mixed-list predecessor-order bias was found and preserved in
`target/ORDER-METHOD.md`. Accepted gains use the superseding isolated controls.

Source baseline: `bc1b486150850fe00bad1361a19f57d67706bb3b`.
Cleanup-only candidate: `24e9c1f8d9c8fb32d06768b08cd6867d1252bc32` on local branch `codex/perf-652`.
No push or pull request was created.

The candidate uses terminal modes only at main's C/check/-E dispatch. Output handles and worker teams are completed before return; mappings are reclaimed at process exit. Existing reusable command wrappers retain explicit cleanup. The driver regression checks two successful invocations and a rejected-option invocation, retaining the same VmSize after each reuse.

## Rejected page-policy experiment

The ordinary prefix was initially widened from 64 KiB to 1 MiB, preserving explicit smaller-prefix mapping alignment. That experiment was rejected and is absent from the final source. `lane-prefix-experiment.c` retains its functionally equivalent arena implementation; it is the repository's MIT lane source with only the default prefix and alignment-room condition changed. The original MIT notices remain. `arena_screen.c` is an original C adapter measuring explicit 64/256/512/1024 KiB prefixes independent of the default.

The local 7940HS screen (`BUSTER_DEBUG_INFO=0`, normal release build, allocated cores, rotated executable order, one copy each) found:

| Whole process | Baseline median | 1 MiB prefix + terminal cleanup |
| --- | ---: | ---: |
| empty -fsyntax-only, 41 runs | 2.340 ms | 2.653 ms |
| tiny -c, 41 runs | 4.301 ms | 4.434 ms |
| empty -E -P, 41 runs | 1.986 ms | 2.339 ms |
| SQLite -c lanes 1, 11 runs | 191.680 ms | 208.267 ms |

These are local negative screens, not 9700X results or final cleanup-only results. All timed processes returned 0. SQLite object bytes matched. The arena-only page-touch screen explains increased base-page faults; it does not establish target-machine costs.

`prefix-1m-small-ab.txt`, `prefix-1m-sqlite-ab.txt`, `arena-screen.txt`, `build.log`, `arena-sanitizer.txt`, and the original head/base syscall logs belong to that rejected experiment. `arena-sanitizer.txt`'s 70 checks include exploratory explicit-prefix boundary fixtures; those fixtures were removed with the rejected policy. `final-build.log` was interrupted after the policy was rejected and must not be used as final build evidence.

## Final candidate recipe

Build with `BUSTER_DEBUG_INFO=0 ./build.sh`. On the 9700X run every build/test/measurement through the shared exclusive lock, timings pinned to CPU 2. Use the common campaign corpus/options and retain hashes.

Use `time-runs --runs 41 --warmups 3 --copies 1 --build base BASE --build cleanup HEAD` with separate lists for `-fsyntax-only empty.c`, `-E -P empty.c -o /dev/null`, and `--lanes 1 -c tiny.c -o tiny.o`; use at least 11 rotated runs for SQLite. Whole-process elapsed time includes the kernel's exit teardown. A zero release stage is not itself a whole-process speedup.

Count `mmap,madvise,munmap` with `strace -f -c` for each command. Compare object/preprocessor/diagnostic bytes against baseline. Run `test-checker-driver --executable ./build/compiler`, `test-parser --clang` (including reusable -E teardown/error checks), and `./build.sh check-call-graph`.

## Final cleanup-only local results

`cleanup-build.log`: normal 41-unit release build passed,129.9 s. Executable SHA-256 `1c3315c71d95c5db195c52dd324fbf22f46941243fcc2806968ef4756889aaaa`; baseline executable SHA-256 `f6eb260cb332bdb46812f30a27d10817bcc701f1c65057d0d46ff065845082c9`. Source remained the exact committed candidate throughout this build and these checks.

- `cleanup-driver.txt`:21,644 checks,zero failures,including the new reused success/rejected-option VmSize checks and default CLI/direct reusable driver routes.
- `cleanup-parser.txt`:`test-parser --clang` passed. Existing repeated driver tests cover17 cases/272 runs and allocation-failure cleanup: valid source127 failed reservations; invalid and warned source176 each; directives/warning177; `-E` warned source164 and warning/directives165. Each failure was reported and released.
- `cleanup-callgraph.txt`:41 translation units,25,111 functions,149,481 calls,zero disallowed cycles,three existing allowed cycles,zero split variables.
- Final SQLite objects and tiny preprocessed output match baseline bytes (`cleanup-sha256.txt`).
- `cleanup-empty-syscalls.txt`:92 mmap,144 madvise,zero munmap; baseline92/144/79.
- `cleanup-pp-syscalls.txt`:74 mmap,123 madvise,zero munmap; baseline74/123/61.

Rotated local whole-process results,all processes returned0:

| Whole process | Baseline median | Cleanup-only median | Change |
| --- | ---: | ---: | ---: |
| empty -fsyntax-only,41 runs | 2.354 ms | 2.084 ms | -11.45% |
| tiny -c,41 runs | 4.014 ms | 3.910 ms | -2.59% |
| empty -E -P,41 runs | 1.942 ms | 1.753 ms | -9.71% |
| SQLite -c lanes1,11 runs | 222.340 ms | 228.893 ms | +2.95% |

The local SQLite results have broad ranges (about200-269ms),while user cycles fell2.71%. This is not evidence of a SQLite speedup or timing neutrality; target qualification remains necessary. These measurements include exit teardown. Main's source was not rebuilt or changed during the runs; every process returned0 even though the parent briefly restored its baseline executable from an identical stable copy elsewhere in the workspace. Both baseline hashes were checked equal after the run.
