# Tier 1 verifier cost on the Ryzen 7 9700X

The patched compiler reduced the verifier’s share on both workloads and emitted byte-identical objects. SQLite remains above the issue’s few-percent goal. [Issue #1379](https://github.com/buster14a/buster/issues/1379) · [Compiler PR #3554](https://github.com/buster14a/buster/pull/3554)

| Input | Issue’s six symbols | Expanded verifier symbols | Compile cycles | Compile instructions |
|---|---:|---:|---:|---:|
| SQLite | 9.94% → 6.54% | 10.75% → 7.01% | -4.25% | -7.14% |
| Lua | 6.66% → 4.42% | 7.08% → 4.82% | -2.03% | -3.96% |

## Sampled user cycles

| Input | Build | Row checks | Dominance | CFG construction | Graph | Liveness plan | Shape |
|---|---|---:|---:|---:|---:|---:|---:|
| SQLite | base | 6.18% | 1.49% | 1.19% | 0.27% | 0.60% | 0.20% |
| SQLite | final | 3.03% | 1.34% | 1.13% | 0.00% | 0.82% | 0.22% |
| Lua | base | 3.92% | 1.10% | 0.85% | 0.21% | 0.45% | 0.14% |
| Lua | final | 2.15% | 0.88% | 0.82% | 0.00% | 0.43% | 0.14% |

Each share is the median of two independent profiles. For each run, the numerator is the sum of the sampled periods for the symbol and its split copies. The denominator is the full profile’s user-cycle event count. Totals use the unrounded periods. The expanded count includes the new join helper, the old reachable-block check and the named verifier wrappers and helpers in [summary.c](summary.c). These are symbol self shares. CFG construction also serves SSA and other consumers.

## Whole-compile counters

| Input | Build | Median cycles:u | Median instructions:u | Cycles relative to base |
|---|---|---:|---:|---:|
| SQLite | base | 3,216,949,377 | 7,766,436,347 | +0.00% |
| SQLite | control | 3,215,301,173 | 7,766,436,367 | -0.05% |
| SQLite | final | 3,080,145,133 | 7,211,887,491 | -4.25% |
| Lua | base | 110,124,389 | 309,197,000 | +0.00% |
| Lua | control | 110,534,373 | 309,197,034 | +0.37% |
| Lua | final | 107,892,257 | 296,944,594 | -2.03% |

Each median covers three single-compilation measurements. The control is a byte-for-byte copy of the base executable. Its cycle difference gives an A/A comparison on this sequence. With three observations these results describe the recorded runs.

## Build and capture

- Base was `7515714d05caa655e8c2e1e2776e07aa9b8058df`. Final was `79cad6b5ecd04012fd4119b83badb9a1a11f2873`. Both are Release builds using `BUSTER_HOST_ARCH=znver5` and the pinned Clang 23.1.4. The `clang` found on the host’s normal path has a different version. All 15 changed compiler files matched their Git blobs. [Source hashes](raw/acceptance-sources.sha256) · [Executable hashes](raw/acceptance-binaries.sha256) · [Build toolchain](raw/build-toolchain.txt)
- The `build-tenth.log` label refers to the build that compiled the final source. The final invocation reused its output and produced the identical executable digest. [Compilation log](raw/build-tenth.log) · [Final build log](raw/build-final.log)
- Each run acquired benchpress’s shared exclusive lock and bound the compiler to CPU 2. The command was `-c -w --tier1 --lanes=1`, with `SQLITE_OMIT_LOAD_EXTENSION` and `SQLITE_THREADSAFE=0` for SQLite. Each `perf record -e cycles:u -F 9999` capture contains three compiles of sqlite3.c or ten of Lua 5.4.8’s lvm.c. Counters use a separate `perf stat` compile. [Capture commands](capture-final.sh) · [Input hashes](raw/inputs.sha256)
- Rounds 11, 12 and 13 used final/base/control, base/control/final and control/final/base, respectively. Each visit ran SQLite then Lua. Rounds 11 and 12 profiled base and final. All three rounds took separate counters for all labels. Before/after load and process snapshots are in the corresponding logs. Unrelated lock-queue messages were omitted and report trailing spaces trimmed. [Raw data, reports, symbol tables and counters](raw/)
- To regenerate the tables from this directory, run `cc -std=c11 -O2 summary.c -o /tmp/verifier-shares && /tmp/verifier-shares`. The program prints both per-run shares and their medians.

## Repetition and correctness

GDB counted executed entries at every distinct machine address of the three functions, including split copies in different compilation units. Over the same 32 Lua functions, row checks went from **163 to 146**, dominance checks from **178 to 115** and CFG builds from **265 to 198**. Full row and dominance checks still occur when promotion and the final optimizer publish new IR. [GDB script](entries.gdb) · [Base stacks](raw/entries-base.log) · [Final stacks](raw/entries-final.log)

Every profile and counter run produced SHA-256 `92d936a8711afe28ee9d72025fd7af95b17222a033c6299f9b8040f3ebacfa9e` for SQLite and `d94a1fc86152353c5584a5be1059349a1a6860fe694a27520815ddb5c868805e` for Lua. The GDB runs also produced the same Lua object. The final native Tier 1 pipeline passed 6,145 checks, including 1,088 native and 1,088 Clang results. [Native test output](raw/pipeline-final.log) · [Local suite and AddressSanitizer results](raw/local-qualification.txt) · [GDB object hashes](raw/entry-objects.sha256) · [November 23 historical campaign](../tier1-verifier-1379-2026-11-23)
