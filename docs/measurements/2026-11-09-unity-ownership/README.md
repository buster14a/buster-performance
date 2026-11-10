# Unity fixture ownership evidence

Original structural/validation evidence for Buster drafts
[#2046](https://github.com/buster14a/buster/pull/2046),
[#2047](https://github.com/buster14a/buster/pull/2047),
[#2048](https://github.com/buster14a/buster/pull/2048),
[#2049](https://github.com/buster14a/buster/pull/2049),
[#2050](https://github.com/buster14a/buster/pull/2050),
[#2051](https://github.com/buster14a/buster/pull/2051) and
[#2052](https://github.com/buster14a/buster/pull/2052).
No benchmark campaign or authoritative wall-time claim is made. This is a
source-dependency and deterministic-output comparison on the owner's desktop;
the approved exclusive Benchpress lock was not acquired or a hardware job
requested merely to obtain a fixture timing number.

## Identities and scope

Base: `buster14a/buster` at
`b57c704e3a5e9bbe3d8627927d277af396c44bb2`, after merged #2044 and #2045.
The current draft stack's reviewed source heads are:

| Packet | Head |
| --- | --- |
| #2046 | `10873be46b8869ac6a417f6449efbe15137f54e6` |
| #2047 | `a2e69634e7e2a308f7fc7c1b31a92dc530811e5a` |
| #2048 | `56392f8b7f4587c17caf0f85da35dcade5d98564` |
| #2049 | `b82294086476cb4e5b4a0828be61b3c138d3bc26` |
| #2050 | `a0e5ec06f512a9e2728ee54c0f90d96f8d8480a1` |
| #2051 | `c8988e984e9938b857da1921b7287c57cc13679f` |
| #2052 checker code | `0445f2ce9ba04749346b09190fe2e156b2af22bb` |

Early packet logs predate two harness-only standalone-consumer fixes and
rebasing their descendants. Their compiler-source identities were respectively
`785ae2b5d31a26de678ac1ce221d4e305b894a44`,
`f9d8a8416d337903a8534dbec3425298ac76ccd0`,
`638614a94319c5fb8df249d9c96a64e1a78a41a5`,
`1d280804facc24fe8e22d87f6d49500d2658df70`,
`10e483d1e672c2e1f1693424a5ff6374e3d31eae` and
`a161e44d6404ce6906a4d175eee40efac34cd8c3`. Compiler source content is the
same in the corresponding final heads. The final harness logs include both
exact standalone vector consumers that hosted CI exposed: scheduling fixtures
and Tier 0 counters. The intrinsic catalog's standalone consumer was already
checked. Hosted correctness and Build checks pass for the six final source
heads in `ci-status.json`; the prevention head was still running at that snapshot.
The hardware aggregate reports draft qualification withheld, not hardware
execution failure. No full sanitizer/fuzz campaign or ready-state qualification
is established by local checks or draft admission.

Local host: Ryzen 9 7940HS / Linux x86-64 (`identity/host.txt`), Clang 23.1.4,
CMake 4.4.5, Ninja 1.13.2. Scalar settings:
`BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0`. Runs use normal repository flags;
multicore builds, syntax/preprocess batches and test runners use `cores -n 4`.
Vector (`znver5`) code is compiled/syntax-checked, not executed. No compiler
flags, warnings, sanitizer coverage, production behavior or command homes were
changed. Compiler-driver work belongs to a separate session.

## Results and evidence

- All 43 scalar Release objects and compiler compare byte for byte with the
  base. Both SHA256 inventories are under `identity/`; compiler digest:
  `ebdf87d69030587e2aa19cd2d3260cecd17b9327bb8196967b773838d9b09e4d`.
- Scalar and vector all-43 dependency sets remove 957 repository edges and add
  five, plus remove 48 system-header edges. All 32 standalone sets are unchanged
  in each mode. Per-packet and cumulative deltas are under `dependencies/`.
- Actual expanded unity source volume falls by 54,891,256 scalar bytes and
  54,892,879 vector bytes with the same Debug flags. The per-unit inventory and
  hashes are included. These bytes/edges do not establish a time percentage.
  `deps.c`'s weighted source-byte subtotal uses current complete file sizes,
  including guarded spans; it is not a token/CPU-work or timing measurement.
- The expanded checker validates 548 scalar / 546 vector active fixture/support
  paths: 487 private, 61 / 59 exact shared rows, with 41 structural root pins.
  Full path/owner/reason inventories avoid repeating the audit. Extra shared
  rows include production implementations/data reached through fixture includes;
  their descendants inherit no exception.
- Logs cover normal Debug/Release builds, per-packet focused runtime lists,
  standalone preprocessing, exact scalar Ninja edit plans, no-op/configuration
  switches, 27 structural cases, direct/nested/outside/collision leaks and
  bad/widened/obsolete sharing, stale/truncated/count-mismatched records, actual
  unbuilt edits and detached compiler copies. Checker fixtures pass ASan/UBSan
  with leak detection; CI selector self-tests report 1,659 checks, zero failures.
- Owning BACKEND preprocessing was unchanged ignoring blank lines for the
  optimizer packet; BACKEND/CHECKER scalar preprocessing similarly matched for
  the source-preparation packet. All 22 Debug/Release unity symbol tables have
  no emitted interface-reference functions. ABI/import assertion coordinates
  and six forced semantics globals were retained. The early ABI object
  comparison exposed shifted assertion coordinates; those were restored before
  the accepted byte comparison.

The raw scalar Ninja capture contains the build's Debug and Release records;
the comparator selects Release. Vector `.d` files are real Clang dependency
outputs for all 43 units with normal vector Debug flags. The `*-vector-deps.txt`
files reformat those sets into the comparator's Ninja-like input syntax. Their
literal `VALID`/mtime fields are synthetic formatting, **not evidence of a built
vector Ninja tree**. Actual Ninja no-op and edit-plan checks were scalar.
Depfile record order is immaterial; archived converter replay reproduces the
same sets, even when directory enumeration order differs.

Build-log elapsed values are incidental diagnostics, from single local
validation runs without controlled thermal/cache sampling or repetitions. Do
not use them to infer speedup. Preprocessed files, compiler binaries and objects
are intentionally not incorporated; their hashes, exact source revisions,
commands and tools support reproduction without copying system-header contents.

## Reproduction

Clone Buster and this repository separately. Run from the intended Buster
checkout with a sibling `work/` directory, using the exact revisions above.
Put disposable tools and output captures in that sibling directory. These
original C tools retain the experiment's relative scratch/output layout;
archival copies add SPDX notices and make wrapper includes portable with `-I.`.

```sh
export BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0
cores -n 4 -- ./build.sh
cores -n 4 -- ./build.sh --config Debug
cc -std=c17 -O2 -Wall -Wextra -Werror tools/ci/build_regression.c -o ../work/build-regression
../work/build-regression --ownership-only "$(./build.sh print-output --config Release)"
../work/build-regression --ownership-only "$(./build.sh print-output --config Debug)"
```

Set `evidence` to this directory's absolute path. Build `tools/units.c` and
`tools/deps.c` with `cc -std=c17 -O2 -Wall -Wextra -Werror`. For separate base
and candidate builds, retain the actual Ninja snapshots and Release outputs:

```sh
ninja -C build/cmake/x86-64-g0 -f build-Release.ninja -t deps > ../work/deps.txt
cores -n 4 -- env ALL_SOURCES=1 ../work/units syntax znver5 ../work/vector
cores -n 4 -- ../work/units preprocess x86-64 ../work/pp
cores -n 4 -- ../work/units preprocess znver5 ../work/pp
```

Create output directories first. `units.c` obtains NUL-delimited normal flags
and source lists from the build driver; its syntax mode emits `.d` files.
`depfiles.c` reformats vector `.d` sets; `deps.c BASE FINAL` compares owner
sets. `pp_inventory.c` uses the experiment's `../baseline-pp` and `../final-pp`
directories. These flat tools assume the recorded paths contain no spaces.

Compile wrappers with `-I.` so they include this pinned checkout's actual
`tools/ci/build_regression.c`. `existing.c` selects standalone, incremental and
configuration checks without the full clean/failure/interruption campaign;
run it through `cores -n 4`. `ownership_selftest.c` calls the checker fixtures;
compile with `-fsanitize=address,undefined -fno-omit-frame-pointer` to reproduce
sanitizer validation. `graph_inventory.c` checks the actual graph (or a supplied
reformatted vector capture) and prints structural pins; `OWNERSHIP_ALL=1`
prints the full classified path/owner/reason inventory. Its normal mode expects
the recorded `x86-64-g0` build path. `ownership_negative.c` expects a sibling
`../build-regression` executable; it tests a temporary source timestamp change
and detached copy, restoring timestamps and removing the copy. Use an isolated
checkout with no concurrent build when reproducing source-edit checks.

Run each `packetN.tests` through that configuration's compiler `parallel` command
under the core queue, with the normal Clang resource directory. Some native
cross-check sections can skip unavailable external tools; inspect the logs.
The full Build workflow supplies clean/failure/interruption validation beyond
the local wrapper. Draft PRs withhold hardware qualification by policy.

All incorporated tools and reports are original first-party work under
Apache-2.0 WITH LLVM-exception. External compiler/system headers and test corpus
inputs are runtime dependencies of the named Buster revision; none is imported
here. This evidence is not a reviewed CI harness pin or permission to merge.
