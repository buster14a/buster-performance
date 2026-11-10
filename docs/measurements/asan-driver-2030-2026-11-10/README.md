# The address row's driver cost (buster#2030), 2026-11-10

The diagnosis of why buster's fused `address` sanitizer row (ASan, UBSan, bounds, LSan) runs `test-checker-driver` at
6–30× plain, and the measurements behind buster PR #2067. This record has the result lines and the scripts. The
reasoning is in the PR and in buster#2030.

## Host

`host.txt`: an AMD Ryzen 9 7940HS laptop (Zen 4, the class of the hosted pool's EPYC 9V74), Linux 7.3.3, clang/LLD
23.1.4. Not the 9700X: #2030 needs no 9700X measurements, and its question is the hosted runners' cost. Every timed
run went through the laptop's `cores` queue, on cores of its own, at niceness 19. Some runs shared the machine with
other jobs of this session (noted below).

## Executables

`trees.txt` has each executable's sha256 and size. The sources:

| Executable | Source |
|---|---|
| `compiler-plain` | buster `dbc76dd7`, plain Release (`BUSTER_DEBUG_INFO=0`, native) |
| `compiler-asan` | `dbc76dd7`, `BUSTER_SANITIZER=address`: CI's address row, a PIE |
| `compiler-asan-only`, `compiler-asan-ubsan`, `compiler-uar-runtime` | `dbc76dd7` with `cmake/BusterSettings.cmake`'s address flags edited: `-fsanitize=address` alone; `address,undefined` without bounds; `-fsanitize-address-use-after-return=runtime` |
| `compiler-asan-nopie`, `compiler-asan-nopie-baked` | `compiler-asan`'s objects relinked with `-no-pie`; then `bake-tables` |
| `compiler-fixed` | the PR's first two commits on `4fff9d82` (pre-rebase, unpublished ids; the same changes as the PR's `5eb7ef6d`, `bc59f407`) |
| `compiler-fixed4` | the PR's head tree (`trees.txt`'s last line), address row |

## Method and results

All runs use CI's options (`tools/ci/sanitizers.sh`): `ASAN_OPTIONS=halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1`, with LSan's and UBSan's matching. "nothp" runs used `scripts/tools/nothp.c` (`PR_SET_THP_DISABLE`), as on a host whose transparent huge page mode is `madvise` (Ubuntu's default). Each line of `results/driver.txt` is `label part rc wall user system reports | the run's last line`.

- **Option matrix** (`scripts/matrix.sh`, the first 7 lines of `driver.txt`): part 1/16, one variable at a time.
  `asan` 117.4 s, `asan-again` 117.5 s, `plain` 8.2 s; `detect_leaks=0` 53.9 s; `strict_string_checks=0` 122.8 s;
  `check_initialization_order=0` 115.8 s; LSan's `use_globals=0` 938 leak reports (false: globals are roots).
- **Compile-time groups** (`scripts/variants.sh`, `scripts/compare.sh`, the `r2-` lines): part 1/16, sequentially on
  one core, with other jobs on the machine part of the time: base 140.7 s; without UBSan and bounds 126.5 s; without
  bounds 124.3 s; use-after-return at runtime, on 127.1 s, off 131.6 s; fixed address 105.6 s. The differences among
  the flag groups are within this series' noise (base later 123.2 s without THP).
- **Fixed address, side by side** (`scripts/ab.sh`, the `ab` lines): part 1/16 by `compiler-asan` and
  `compiler-fixed` at the same time on two cores, nothp, two rounds: 123.7, 126.0 s against 100.8, 103.1 s.
- **Per process** (`scripts/percallc.sh`, `results/percall-receipts.txt`): 40 `-c` compiles of a two-function file,
  main's PIE against the PR's head, alternating, two rounds, with and without THP: 105–109 ms against 84–85 ms.
- **All 16 parts by `compiler-asan`** (`scripts/driver16.sh`, the `d16-base-` lines): 6 at a time, nothp. Part 13
  took 2,235 s (2,099 s user). Parts 9 and 14 fail locally with this laptop's toolchain: part 14's 2 checks fail with
  the plain build too; part 9's 18 if-conversion checks fail only under ASan here (CI's address rows pass them).
- **Part 13** (`p13-` lines): plain 17.9 s; `compiler-fixed` with `strict_string_checks=0` 160.4 s; the PR's head
  (`compiler-fixed4`) 156.5 s with every check passing. `results/part13-exec-gaps.txt` is from
  `scripts/part13-gaps.sh` (an execve-only `strace --seccomp-bpf` of a run by an intermediate build with the first
  three line-walk fixes): the driver process ran 663 s without starting a child after clang's
  `resumed-declarations-many.c` output, in `check_test_diagnostic_lines`.
- **Plain validation** (`scripts/plain16.sh`, the `plain16-` lines): all 16 parts by the PR head's plain build. Every
  part passes but part 14's 4 `asm placed` checks, which main's plain build at the PR's base `3bfa0af18` fails the same
  way on this laptop (`scripts/main-part14.sh`, the `main3bfa-14` line). Main's older `dbc76dd7` build fails part
  14's 2 `volatile order` checks instead (the `plainmain16-` lines): this laptop's, not the PR's.
- **LeakSanitizer's scan per MB** (`scripts/bss.sh`): a program with an untouched static array, CI's address flags,
  `-no-pie`: with THP 7.6 ms at 16 MB and 29.6 ms at 256 MB; without THP 11.1 ms and 64.9 ms (printed by the script,
  not kept in a file).
- **Hosted build shape** (`scripts/build-jobs.sh`, `results/build-jobs.txt`): a clean address build on a 2-core,
  4-thread grant: 517.6 s with `build.sh`'s default jobs (2), 414.2 s with `--jobs 4`.
- **Memory** (`scripts/mem.sh`, `scripts/tools/maxrss.c`, `results/mem.txt`): the four largest address-row compiles
  at once, peak RSS: checker 3.47 GB, backend 1.84 GB, frontend 1.41 GB, executable 0.73 GB.

## Limitations

- One laptop, not a hosted runner. The per-process costs depend on the kernel's THP mode and the CPU, so CI's
  multipliers differ. The PR's estimate for CI's part 1 of 4 scales these local times.
- Several series shared the machine with other jobs of this session, and the sequential compile-time-group series
  drifted by about 15%. The side-by-side runs are the comparisons to rely on.
- Intermediate builds (`compiler-fixed2`, `compiler-fixed3`) and the profiles that found the callers are not kept;
  one profiling attempt, `perf record -c 1` attached to a live process, hung the laptop's kernel and its data is lost.
- The bss-scan and earlier per-process figures quoted in the PR's first version were printed, not saved; the
  `percall-receipts.txt` rerun replaces them.
