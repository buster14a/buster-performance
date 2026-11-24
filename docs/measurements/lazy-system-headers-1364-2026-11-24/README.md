# Lazy system-header compile times on the Ryzen 7 9700X

On all three inputs reported in #1364, lazy checking on the candidate was within 0.07% of eager checking. The unused-intrinsics unit took 61.77% less wall time. The two eager controls give the scale of run-to-run variation. On the candidate their round medians differed by up to 0.14% on glibc, where lazy's pooled median was 0.061% higher. [Issue #1364](https://github.com/buster14a/buster/issues/1364) · [Compiler PR #3538](https://github.com/buster14a/buster/pull/3538)

| Input | Main eager, ms | Main lazy, ms | Candidate eager, ms | Candidate lazy, ms | Candidate change |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite object | 101.547 | 102.739 | 101.758 | 101.725 | −0.033% |
| 380-header syntax check | 68.453 | 69.659 | 68.305 | 68.347 | +0.061% |
| Mixed-library syntax check | 63.998 | 65.543 | 63.957 | 63.928 | −0.045% |
| Unused intrinsic definitions | 40.618 | 16.212 | 40.593 | 15.519 | −61.770% |

On main, lazy mode executed an additional 20.7, 21.8 and 27.8 million user instructions on SQLite, the 380-header unit and the mixed unit respectively. On the candidate these overheads were about 30,000, 25,000 and 8,000 instructions. Candidate eager and lazy peak RSS differed by at most 4 KiB on those inputs. All four SQLite objects had SHA-256 `190cf4c109792239cc1dfac8e2e2fb2fd1e11f5df9117e7766d9193f1b1b78eb`. [Pooled results](summary.tsv) · [Per-round medians and eager controls](rounds.tsv)

## Inputs and builds

* Main was `7515714d05caa655e8c2e1e2776e07aa9b8058df`. The candidate was `ca25f1d3c185583a84a087c6f30f1b280f20d37f`. The PR's follow-up commit `77e9d580` adds driver test assertions and documentation. Both measured binaries were built on benchpress under its exclusive lock using `BUSTER_HOST_ARCH=znver5 ./build.sh --config Release` and the project's Clang 23.1.4 toolchain. [Main build](build-base.log) · [Final candidate build](build-final.log)
* SQLite came from the verified CI corpus at `preprocessor-391e729af658/sqlite`. Its SHA-256 matched the compiler workflow's pin. It used `-c -w` with the CI feature defines. The source and installed third-party headers were external inputs.
* The original 380-header and mixed-library translation units survived in the reporter's `perf-audit-claude/inputs` directory on benchpress. The archived copies contain the original include lists. The mixed unit uses the installed Python, GIO and libxml2 include paths reported by pkg-config. Each header aggregate used `-fsyntax-only -w`. [380-header source](inputs/glibc380.c) · [Mixed-library source](inputs/lib_all.c)
* The skippable control includes `<immintrin.h>` and defines an empty `main`, as in #3307. The source and binary hashes, compiler inputs and installed package versions are in the environment captures, in the order printed by the stage harness. The results describe those installed headers. [Main environment](baseline-stages/environment.txt) · [Candidate environment](final/environment.txt)

## Measurement

Run `bash compare.sh` beside the two build directories on benchpress. Each of three rounds takes the host lock independently, pins to CPU 2 and uses the compiler's `time-runs` to time whole child processes. Its 24 slots cover both binaries, four inputs and three argument lists per input in eager, lazy, eager order. Each slot warms up once. The 24 timed repetitions use a Williams design to balance slot order. All 1,728 timed processes exited successfully. [Harness](compare.sh) · [Raw timings](comparison/)

The table pools 72 lazy wall times and 144 eager wall times per build and input. The percentage is 100 × (lazy median / eager median − 1). In the round table, eager B versus A compares the two identical eager commands. RSS is the child's peak from wait4. Instructions and cycles are user-mode counters. The logs retain the host load and busiest processes at the start and end of each round. Stage timings were collected in separate invocations with `bash stages.sh base baseline-stages` and `bash stages.sh candidate final`. [Stage harness](stages.sh)

## Macro run lookup

The opaque eager route selected all 2,674 SQLite bodies, all 1,213 bodies in the 380-header unit and all 2,359 bodies in the mixed unit. Each reported zero grammar-replay tokens and zero retained planner bytes. That route returns before a definition's source lookup. On the intrinsic unit the candidate only looks up runs for macro-produced tokens at the declarator, opening brace and header start. One user-cycle sample out of 14,837 in the compiler fell on the binary search at lines 169–183 of `c_check_lazy.c`. The full definition-level classification accounted for 41 samples. DWARF resolved 11,511 samples to a C source line. This profile covers the Williams harness's single warm-up and 12 lazy syntax-check processes on CPU 2. Sampling skid and source-line resolution limit the precision of this attribution. [Profile harness](profile.sh) · [Source attribution](profile/summary.txt) · [Instruction-pointer counts](profile/ip-counts.txt)

The intrinsic tree plan deferred 5,184 definitions and kept one body on both builds. Every captured workload completed without replaying the preprocessing history. Queue messages naming the previous lock holder were omitted from the logs. Lock-acquisition busy notices, process snapshots and measurement output are retained. The checksum process reported at the start of round 1 was on CPU 8. Rounds 2 and 3 reported no busy process on lock acquisition. [Local correctness and negative control](validation.txt)
