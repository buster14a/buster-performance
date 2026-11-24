# Tier 1 lifetime scaling on the Ryzen 7 9700X

At 16,000 unbraced returns, skipping lifetime planning in a unit with no nested blocks reduced `check-program` from **2.439 to 1.422 ms**. The same binary took **1.420 ms** with lifetimes disabled. At the same depth, the earlier fix for jumps leaving blocks reduced the stage from **505.869 to 5.865 ms** for `goto out` and from **248.443 to 5.377 ms** for `break`. [Issue #1355](https://github.com/buster14a/buster/issues/1355)

## Original return chain

Each row gives the median `check-program` time in milliseconds from seven separate object compilations. “Off” uses the same fix binary with `--tier1-no-lifetimes`. The first run at each size also wrote an object. Main, the fix, and the off control produced byte-identical objects at all four sizes. [PR #3549](https://github.com/buster14a/buster/pull/3549) · [Samples](return-fix-samples.tsv) · [Object hashes](return-objects.sha256)

| Arms | Main `7515714d0` | Fix `e986851fd` | Off | Fix / off |
| ---: | ---: | ---: | ---: | ---: |
| 4,000 | 0.705 | 0.427 | 0.428 | 1.00× |
| 8,000 | 1.224 | 0.621 | 0.625 | 0.99× |
| 16,000 | 2.439 | 1.422 | 1.420 | 1.00× |
| 32,000 | 4.619 | 2.907 | 2.924 | 0.99× |

Both historical builds already contained the fix for the quadratic return walk (#1595). The seven-run medians below show the lifetime overhead that remained before #3549. [Historical samples](stage-samples.tsv)

| Arms | #3245 parent | #3245 merge | Merge with lifetimes off |
| ---: | ---: | ---: | ---: |
| 4,000 | 0.497 | 0.659 | 0.402 |
| 8,000 | 0.903 | 1.171 | 0.573 |
| 16,000 | 1.796 | 2.387 | 1.296 |
| 32,000 | 3.540 | 4.351 | 2.605 |

## Jumps that leave blocks

The first parent of merge `555786028` already contains the fix for planning capacity on deep return chains. Comparing it with the merge isolates the subsequent change to jumps entering and leaving blocks. Both builds used the archived inputs, `-w -c --tier1 --time-stages`, and seven fresh processes per cell. “Off” uses the merge with lifetimes disabled. All table entries are median `check-program` milliseconds. [PR #1595](https://github.com/buster14a/buster/pull/1595) · [PR #3245](https://github.com/buster14a/buster/pull/3245) · [Samples, including check-input and total](stage-samples.tsv)

| Arms | Goto before | Goto after | Goto off | Break before | Break after | Break off |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 4,000 | 31.254 | 1.486 | 0.688 | 16.308 | 1.370 | 0.660 |
| 8,000 | 121.885 | 2.769 | 1.370 | 61.289 | 2.705 | 1.307 |
| 16,000 | 505.869 | 5.865 | 2.735 | 248.443 | 5.377 | 2.662 |
| 32,000 | 2021.175 | 11.425 | 5.167 | 977.419 | 10.498 | 5.013 |

On the merge at 16,000 arms, the break chain spent 362.224 ms in `check-input`. These measurements isolate the `check-program` stage implicated in #1355. The break target lookup in `check-input` changed separately after this merge. [Issue #3220](https://github.com/buster14a/buster/issues/3220)

## Other jump shapes

Each cell gives before → after median `check-program` milliseconds on the historical pair. The object-compile rows used the same flags under a 4 GiB memory cap and a 35-second timeout for each compiler process. [Object-compilation samples](supplemental-object-samples.tsv)

| Shape | 4,000 | 8,000 | 16,000 | 32,000 |
| --- | ---: | ---: | ---: | ---: |
| Nested case labels (`case`) | 23.991 → 1.720 | 95.085 → 3.639 | 378.020 → 7.074 | 1496.741 → 13.546 |
| Labels with their address taken (`addr`) | 16.168 → 1.452 | 60.585 → 2.996 | 239.505 → 5.786 | 956.170 → 11.217 |
| Asm goto (`asm`) | 16.879 → 1.892 | 71.294 → 3.767 | 289.589 → 7.641 | 1141.795 → 15.157 |
| Continue in a while loop (`cont`) | 17.065 → 0.996 | 63.496 → 1.881 | 248.090 → 3.498 | 960.724 → 6.863 |
| Continue in a for loop with locals (`contl`) | 15.860 → 1.374 | 62.384 → 2.704 | 249.955 → 5.391 | 1004.283 → 10.569 |

The original driver also runs Tier 1 lifetime planning with `-w -fsyntax-only --tier1 --time-stages`. This gives comparable before/after stage timings for inputs that exceed a downstream backend limit. As a cross-check at 16,000 goto-out arms, this entry point measured 504.316 → 5.863 ms and reported 0.000 ms in selection and code generation. The seven-run object-compilation medians for this case were 505.869 and 5.865 ms. [Syntax-only samples](syntax-samples.tsv)

| Shape | 4,000 | 8,000 | 16,000 | 32,000 |
| --- | ---: | ---: | ---: | ---: |
| Goto into the next arm (`gotoin`) | 31.597 → 1.884 | 133.130 → 4.000 | 541.500 → 7.755 | 2115.913 → 15.205 |
| Nested case labels (`case`) | 24.483 → 1.710 | 95.422 → 3.709 | 380.596 → 7.073 | 1479.153 → 13.685 |
| Labels with their address taken (`addr`) | 15.714 → 1.429 | 60.687 → 3.016 | 239.469 → 5.790 | 958.890 → 11.304 |
| Asm goto (`asm`) | 16.747 → 1.858 | 71.200 → 3.781 | 289.970 → 7.703 | 1143.425 → 15.299 |
| Continue in a while loop (`cont`) | 15.563 → 0.997 | 63.563 → 1.893 | 251.752 → 3.572 | 961.728 → 6.841 |
| Continue in a for loop with locals (`contl`) | 15.874 → 1.374 | 62.871 → 2.726 | 247.343 → 5.445 | 1001.974 → 10.647 |

## Ordinary object compilation

The Buster `ab` runner alternated revision order across seven rounds on CPU 2. The table gives median whole-compile wall time in milliseconds. SQLite used the frozen 3.53.2 amalgamation and CI’s defines. The c-testsuite row compiles all 220 programs in the declared subset in one invocation with `--lanes 1`. Each pair produced identical object hashes in all seven rounds. Each revision has one binary layout in this comparison. [Historical samples](ordinary-samples.tsv) · [Follow-up samples](ordinary-fix-samples.tsv)

| Workload | #3245 parent | #3245 merge | Change | #3549 parent | #3549 fix | Change |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| SQLite | 607.645 | 613.154 | +0.91% | 622.661 | 622.781 | +0.02% |
| c-testsuite | 79.519 | 79.924 | +0.51% | 68.696 | 67.915 | -1.14% |

## Where the checker spent its cycles

The `cycles:u` profile sampled every 100,003 user cycles at 16,000 arms. On the old `goto out` object compile, 14,970 samples landed in stamp/bypass and 13,260 in the control writer's ancestor walk, out of 32,717 samples in the process. After #3245, the nearest-block pass accounted for 53 of 4,378 whole-process samples, jump folding/scanning for four and the brace sweeps for three. For `gotoin` with syntax-only checking, the corresponding after counts were 75, three and five of 1,700. The counts attribute samples to leaf source lines in each shipping implementation. [Source-line counts](profile-summary.tsv) · [Leaf histogram](profile-leaves.tsv.gz)

Both historical builds rejected object emission for `gotoin` at 4,000 arms in Tier 1 selection (`error=6`), after `check-program` finished. One uncapped parent run at 16,000 arms reached 41,937,160 KiB peak RSS and the same diagnostic. That failure is excluded from the object medians. The syntax-only rows use the same inputs and both unmodified binaries. [Backend observations](backend-observations.tsv)

## Reproduction and verification

Benchpress ran Linux/x86-64 on a Ryzen 7 9700X with the performance governor. All four binaries used `BUSTER_HOST_ARCH=znver5 ./build.sh --config Release` and the project's Clang 23.1.4. Each compiler invocation acquired `~/buster-fast-bench/exclusive.sh` separately, then ran pinned to CPU 2. For the scaling curves the configurations rotated across repetitions. The raw tables include the first run and every succeeding measured round. [Host and binary identities](environment.txt) · [Host activity around each run](host-activity.txt.gz)

The historical pair is `5d880269932b70962e31bbcdaf71330fa263c423` and `5557860286cb2ac758367e3a9513113f67dc619c`. The follow-up pair is `7515714d05caa655e8c2e1e2776e07aa9b8058df` and `e986851fdc606adb6f9cd6272fa4515321a10990`. The archived generator at `e393a188d1337ec1b576844baf76b60a4fabc6db` reproduced all 32 input hashes for the eight named control-flow shapes at four sizes. The following command reproduced all four archived hashes for the issue’s return-only input when run with the corresponding value of `n`. [Generator](../gen1355.c) · [Input hashes](inputs.sha256)

```sh
awk -v n=16000 'BEGIN {printf "int g(int a) { "; for (i=0; i<n; i++) printf "%sif (a == %d) return %d;", i ? " else " : "", i, 3*i; print " return 0; }"}' > return16000.c
```

For object measurements the arguments were `-w -c --tier1 --time-stages INPUT -o /dev/null`. The first follow-up round wrote a real object per configuration for comparison. Off adds `--tier1-no-lifetimes`. Syntax-only uses `-w -fsyntax-only --tier1 --time-stages INPUT`. Each stage time is field 3 of its `time-stage` row, in milliseconds. Profiles ran `perf record -e cycles:u -c 100003` around one compile with the same pin and lock. The histograms use `perf script -F ip,sym,srcline,dso` on the unstripped executables. At 16,000 arms, both historical revisions emitted identical `goto out` objects in the profiled runs. They also emitted identical objects for the original returns, including the lifetimes-disabled control. [Historical object hashes](historical-objects.sha256)

The checker ran `test-checker --seed 133 --part 5/8` from each tested merge or PR tree, using its build toolchain's Clang. The historical merge passed 211,025 checks, the follow-up passed 201,004, and both reported zero failures. The new function-body-only fixture reported zero lifetime-walk steps. [Checker results](checker.txt)

The ordinary compile commands used `-w --tier1 --lanes 1 -c`. SQLite additionally used `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<sqlite> <sqlite>/sqlite3.c -o sqlite.o`. Its source SHA-256 was `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. The suite supplied the paths in `tests/c-testsuite/subset.txt` from c-testsuite commit `5c7275656d751de0e68b2d340a95b5681858ed07`. The `ab --rounds 7 --cpu 2` driver alternated the two revisions, taking the lock for each process. Wall time brackets the compiler command inside the lock, before hashing the objects. [SQLite objects](sqlite-objects.sha256) · [c-testsuite objects](suite-objects.sha256) · [Follow-up SQLite objects](sqlite-fix-objects.sha256) · [Follow-up c-testsuite objects](suite-fix-objects.sha256)
