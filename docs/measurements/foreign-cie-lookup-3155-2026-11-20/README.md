# Reusing a validated CIE lookup in the foreign linker

The production change belongs to [buster#3178](https://github.com/buster14a/buster/pull/3178). The base is `cc5c15033efe9f26af774fdacb223931b308fee8` and the production commit is `5e8ae407dc7d45a5b4802bd5398f6d1ec5232ba4`. The consumer runs after foreign unwind production and any pruning. It validates each FDE’s own encoded backward pointer, minimum length, target index, kind and exact offset. A frame-local index caches the most recent validated target. An invalid result stops the walk before the next iteration can use it.

## Reproduce

Use an isolated Linux x86-64 machine with the ISA in `src/buster/compiler/host_isa.h`, Clang 23.1.4, the repository’s normal build dependencies, GCC/G++, Python 3 and GNU readelf. The harness checks the CPU model and required flags. From an existing Buster checkout, create two disposable worktrees. The CPU check runs before either build. On a shared host use its regular CPU allocation.

```sh
git clone https://github.com/buster14a/buster-performance.git ../buster-cie-measurements
evidence="$(cd ../buster-cie-measurements/docs/measurements/foreign-cie-lookup-3155-2026-11-20 && pwd)"
git fetch origin refs/pull/3178/head
git worktree add --detach ../buster-cie-clean 5e8ae407dc7d45a5b4802bd5398f6d1ec5232ba4
git worktree add --detach ../buster-cie-probe 5e8ae407dc7d45a5b4802bd5398f6d1ec5232ba4
python3 -c 'import runpy, sys; runpy.run_path(sys.argv[1])["cpu"]()' "$evidence/probe.py"

(cd ../buster-cie-clean && BUSTER_HOST_ARCH=vector ./build.sh --config Debug --jobs 1 && ./build/compiler test-foreign --cross-check)
(cd ../buster-cie-probe && git apply --check "$evidence/instrumentation.patch" && git apply "$evidence/instrumentation.patch" && BUSTER_HOST_ARCH=vector ./build.sh --config Debug --jobs 1 && python3 "$evidence/probe.py" ./build/compiler)
```

The three instrumented compiler sources in this replay patch reproduce the exact blobs used in the [hosted capture](https://github.com/buster14a/buster/commit/317dff00b54050cc1557a6ded1cf85091ed942c2). The standalone Python command invokes the same workload that the temporary hosted build launched from its foreign-linker test.

The evidence-only build includes the two original validator bodies from the base and production commit and selects one for each `link-foreign` process. It wraps the named `foreign_unwind_record_at` call in a probe scope and increments the counter at each midpoint inspection inside that existing search. Both modes use the same compiler, normal vector import path, objects and output filename. Other calls to the table search, including those used for fixups, pooling or pruning, do not enter the count. Each successful case compares every FDE location and target, the atom, fixup, record and original-section maps and endpoints, full executable bytes, `.eh_frame`, GNU readelf's decoded frames and the executed program's status and streams. The head's direct old-offset comparisons are counted separately from binary-search probes.

The Clang objects define 32 or 64 independently emitted functions each. Each input object's FDEs share one CIE. The two objects present duplicate CIEs at the same local offset. GCC emits five FDEs referring to A, B, A, B, A through alternating CFI return-column declarations. The mixed link puts this object between the two shared-CIE objects. The C++ PIE includes system startup objects and catches two integers thrown from another translation unit. The no-pooling control omits `--dedup-unwind`.

The raw malformed fixtures change the second FDE’s encoded distance to underflow, point inside a CIE or name an FDE, overstate the record length, or combine two corruptions. The producer can decline malformed unwind input before the terminal validator is reached. A second test therefore copies an imported frame's bytes and record descriptors immediately before calling the planner. It checks mismatched cached pointers, underflow, interior, FDE and self targets, a sentinel target, a 16-byte FDE, a truncated record, two corruptions, and a later single corruption. The fixture reports the planner error code, first byte offset and original-relocation index.

## Observations

| Object inputs | FDEs validated | Base searches | Base midpoint probes | Head misses | Head midpoint probes | Head direct key checks | `.eh_frame` bytes | Map rows |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Clang, 2 × 32 | 64 | 64 | 384 | 2 | 12 | 62 | 1304 | 208 |
| Clang, 2 × 64 | 128 | 128 | 896 | 2 | 14 | 126 | 2584 | 400 |
| GCC, A B A B A | 5 | 5 | 15 | 5 | 15 | 4 | 152 | 33 |
| Clang + GCC + Clang | 69 | 69 | 399 | 7 | 27 | 66 | 1480 | 232 |
| Pooling disabled, 2 × 32 | 0 | 0 | 0 | 0 | 0 | 0 | 1328 | 0 |
| GCC C++ PIE with startup objects | 8 | 8 | 21 | 7 | 19 | 5 | 304 | 121 |

The direct key check compares the previous verified CIE’s `old_offset` with the current FDE’s target. The first FDE in a frame skips that comparison. Both shared-CIE cases remove one duplicate 24-byte CIE. The two input objects require one search each even when both use offset zero. The alternating control adds four direct key checks and performs all five original searches. Both linkers produced the same maps, complete ELF and frame bytes, decoded rows, diagnostics, and return value 37 on all six valid controls. The C++ program throws and catches twice.

All five raw malformed ELF files produced the same exit status 1 and byte-identical stderr. Nine internal malformed cases reported error 3 (`FOREIGN_UNWIND_ERROR_MALFORMED`), byte offset 44 and relocation index 0, including the double error. With only the later FDE corrupted, both reported offset 64. The permanent test independently corrupts the encoded pointer on a cache hit and checks the error location, untouched output and arena rollback.

The [paired vector run on an AMD EPYC 9V74](https://github.com/buster14a/buster/actions/runs/44703143045/job/136176800974) used Clang 23.1.4 and GCC/G++ 15.2.0. [The clean hosted suite on an Intel Xeon Platinum 8573C](https://github.com/buster14a/buster/actions/runs/44701642146/job/136171760495) passed 822 terminal CIE checks, 408 unwind pruning checks, 136 COMDAT/GC/CIE composition checks, 55 command deduplication checks, 705 combined pipeline checks, 72 C++ unwind checks and 1,242 DWARF checks. Each workflow marked its 9700X job skipped. The records here count operations; they contain no benchmark timings.

The initial isolated Ryzen 9 7940HS run at `198a76539df21f444e4be4e968a14f06fb43531f` independently observed the same shared and alternating baseline search counts. Separate clean base and candidate builds produced matching outputs and diagnostics on six successful and five malformed links. The local sandbox denied the debugger's ptrace call. The clean hosted foreign suite subsequently completed the debugger cases on the refreshed base.

[Paired counter and hash output](hosted-results.txt) and [clean foreign-suite output](clean-cross-check.txt) are excerpts from the two job logs. Each `RESULT` line records the case name, FDE count, baseline searches and midpoint probes, head misses and midpoint probes, direct key checks, frame byte count, map row count, and SHA-256 of the map, frame and ELF. `PLAN` includes the number and size of removed CIEs. `RAW` records the user-facing driver failure and `PLANNER` records the error, first offset and relocation index.
