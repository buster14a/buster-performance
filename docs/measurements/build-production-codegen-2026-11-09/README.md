# Production dependencies and parallel native code generation

This packet records the next build optimization after Buster's fixture-ownership
series. It separates changes to ordinary builds from an opt-in native-code
generation experiment. The source base is Buster
`647340a44ae189d2c0f3ec903c71597609e59640`.

The candidate source revision and exact changed-file identities are recorded in
`source-identity.json` and `source-files.sha256`. The final documentation-only
commit links back to this packet; it changes no compiled input.

## Scope of the evidence

All captures in this packet were made in the managed Linux/x86-64 development
environment with the official Clang/LLVM **23.1.4** release
(`7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`), CMake **4.4.3** and Ninja **1.13.2**.
The host can execute the complete vector feature predicate. Scalar builds use
`-march=x86-64`; vector correctness builds use `-march=znver5`. Release retains
ordinary `-O3`, warnings-as-errors and assertions, with `BUSTER_DEBUG_INFO=0`.
Debug retains its ordinary `-O0 -g` configuration.

**This is correctness, dependency and diagnostic profiling evidence. It is not
approved-host performance qualification.** The project requires paired runtime
and build measurements on the locked Ryzen 7 9700X. That host was not accessible
from this session. Any elapsed times in raw build logs or the prototype's phase
JSON are single development observations, not a supported wall-time speedup.

## 1. Ordinary build improvements

The parser's shared interface remains in `c_parser.c`; its private data and
bodies move to `c_parser_impl.c`, included only in FRONTEND or a standalone
parser consumer. The x86 target-form row enumerators and per-row policy checks
are parsed only by the table owner or a standalone consumer. Complete array
declarations retain explicit bounds checked against the canonical rows by the
owner.

The source-boundary inventory measures actual preprocessed bytes and compiler
dependencies for all 43 source translation units in both configurations:

| Measurement | Base | Candidate |
| --- | ---: | ---: |
| Scalar unity preprocessed bytes | 329,897,949 | 294,962,783 |
| Vector unity preprocessed bytes | 331,771,890 | 296,715,704 |
| Scalar parser-body edit: rebuilt units | 11 | 1 |
| Vector parser-body edit: rebuilt units | 12 | 2 |
| Scalar target-row edit: rebuilt units | 12 | 2 |
| Vector target-row edit: rebuilt units | 13 | 3 |

This removes **34,935,166 scalar unity bytes (10.59%)** and **35,056,186 vector
unity bytes (10.57%)**. Counts include the relevant standalone consumers. Shared
parser-interface edits still rebuild their consumers. A row-count change must
also update the shared bound and correctly invalidates its readers.

`source-boundaries/summary.json` names every affected unit and both before/after
counts. `dependency-inventories.tar.gz` retains the original four inventories
and all dependency captures, without duplicating several megabytes of repeated
paths in the review diff. Extract it with `tar -xzf` to inspect the `x86-64/`
and `znver5/` base/candidate directories.

### Preservation checks

The parser audit compares each complete original definition, not just names or
line counts. All **283 original functions** and **25 original static data
definitions** occur exactly once and byte-for-byte unchanged. The 270 moved
functions and 21 moved data definitions retain their relative order. The only
new helper is an unused semantic reference bridge for interface diagnostics.

For the scalar ordinary build, **42 of 43 objects are byte-identical** to the
base. FRONTEND keeps all 814 emitted function names and sizes; 813 bodies are
byte-identical. `parse_tables_initialize` differs only in nine assertion-line
arguments, and its assertion filename gains `_impl`. No `#line` remapping hides
the new source coordinates. For the vector build, 41 of 43 objects are
byte-identical; FRONTEND and the standalone parser benchmark are the two parser
consumers. Exact object hashes and the scalar frontend disassembly comparison
are included.

The independent target-form probe forces the relevant kernels to be emitted in
reader, hidden-owner and standalone modes, for both scalar and vector flags.
All six before/after object pairs are byte-identical. The representative
nonowner expansion falls from 6,296,321 to 3,350,372 bytes: it no longer parses
8,651 row enumerators or 9,093 per-row static assertions. Positive compilation
and both count-drift negative cases pass.

Ordinary scalar Release, vector Release and scalar Debug builds pass the normal
link, bake and canary gates. Full scalar/vector parser tests, scalar target
checks, vector native target selection, production ownership checks and the
vector frontend self-syntax check are recorded under `normal-builds/`.

## 2. Parallel native code generation

The optional `BUSTER_PARALLEL_CODEGEN=1` mode targets CHECKER and BACKEND, the
two longest translation units. It does not move C functions to new optimization
homes or introduce a lower optimization level:

1. The existing source command runs the normal whole-unit O3 pipeline and emits
   optimized bitcode. It is not an LTO pre-link optimization pipeline.
2. Matching `llvm-split` creates eight fixed partitions.
3. Eight ordinary Clang backend commands run under Ninja's existing job limit,
   with `-O3 -Xclang -disable-llvm-passes`. The second stage retains target/PIC
   policy and fatal backend warnings; it does not repeat the IR optimizer.
4. Matching LLD merges the native pieces in numeric order with `-r -O0`.
5. Matching llvm-objcopy restores the original external-definition boundary.
   Newly promoted private functions, data and TLS become local again. Merged
   unresolved references, including weak symbols, keep their binding.
6. The final executable link consumes one cached native object per source unit.
   Editing an unrelated unit therefore does not repeat these backend jobs.

The splitter also retains existing partition/export files when their staged
contents are identical. The regression separately proves comment-only and
timestamp-only edits perform no native compilation or link, while a private
initializer change updates exactly one partition and one native backend job.
Restoring the initializer restores the original native object bytes. This uses
Ninja's normal restat/dependency behavior and preserves stamp-last publication.

There is a separate `-pcg8` tree. The current mode accepts plain Release without
debug information, extra compile arguments, PGO, sanitizer/fuzzer flags, an
explicit old-host runtime or lexer variants. Ordinary builds retain their
existing path.

### Prototype control and contract

`parallel-codegen/` records a proof against the original, unchanged base CHECKER
unit. Compiling the optimized bitcode without splitting reproduces the original
20,820,112-byte native object **byte-for-byte**, including SHA-256. This isolates
the source/IR roundtrip from the partitioning effect.

The split object retains all 4,265 functions. Its summed function text changes
from 8,385,244 to 8,385,199 bytes. All **376 external boundary symbols**—three
definitions and 373 unresolved references—match the original in ELF type,
binding and visibility. All five private TLS objects retain local binding and
size, and their TLS relocation count is unchanged. The checker code section
retains 4,096-byte alignment; the baked table section retains writable
PROGBITS and 64-byte alignment, with 96 bytes of partition padding.

Partitioning changes machine-code layout; byte identity is claimed only for
the unsplit control. In the one-unit prototype, the final executable grows
1,593,336 bytes on disk, mainly from additional nonloaded symbol and string
tables. Allocated file-backed section bytes decrease by 16,152, and executable
section bytes are unchanged. These prototype counts are not a size claim for
the integrated two-unit mode.

The full source candidate builds both large units through this pipeline.
`integrated-codegen/` records those complete scalar/vector builds, exact binary
identities, no-op checks and runtime results. The permanent two-unit regression
uses colliding private function/data/TLS names, a shared public external, a
weak undefined symbol and a second pthread. It also checks graph invalidation,
fixed-order merging, backend failures and preservation of the previous output.

The integrated ELF audit compares both large units against the ordinary
candidate objects. All external symbols retain their exact name, type, binding,
visibility and definedness: scalar CHECKER/BACKEND have 376/293 boundary symbols,
and vector CHECKER/BACKEND have 381/299. Function counts remain 4,265/1,392 in the
scalar pair and 4,175/1,327 in the vector pair. Private TLS allocation properties
also match in every comparison.

The integrated scalar runtime packet has **27 passing commands**, including
17,200,675 Tier 0 cross-checks, 2,195,080 GVN checks, 1,483,092 IR-lowering checks,
784,181 Tier 1 selection checks and 288,066 emission checks. The vector packet
has **eight passing commands**, including full parser, native target-selection,
mask, wide-value, driver CPU-dispatch, optimizer, interpreter and baked-table
checks. Pipeline failures are recorded separately below.

The full production source call graph passes across 43 translation units,
23,284 functions and 154,518 calls: zero unallowed cycles and zero split
variables. The final scalar optional-tree ownership check passes all 548 active
fixture/support paths. Selector self-tests pass 1,681 checks. The build's seven
ordinary flag-policy cases, driver wrapper regression and strict partition
fixture also pass.

### Diagnostics and environment limits

The review caught a missing second-stage `-Werror`; the accepted backend flags
include `-Wall -Werror`, and the permanent inline-assembly warning fixture must
fail. Invalid inline assembly still fails but its second-stage diagnostic can
show `<inline asm>` without the original C file/line. Ordinary builds retain
the original frontend diagnostic context. This is documented as an
experimental-mode limitation, not hidden by disabling diagnostics.

Some checker tests form `/proc/<getpid()>/exe`. In this managed environment the
PID namespace and the mounted `/proc` PID namespace differ. A bounded semantic
diagnostic test produces the same 178 failures in 444 checks on both the base
and the prototype. Explicit-executable driver checks pass. The matching failure
logs are retained so this environment limitation is not reported as a green
complete checker run.

The integrated Tier 1 pipeline cross-check likewise reports the same three
process/subreaper/oracle-count failures in 7,308 checks on ordinary and optional
vector executables; those logs are byte-identical. Its 2,176 native results and
640 differential pairs complete. The scalar optional run prints the same
results, but its output-capture controller reaches its 150-second bound after
failed child cleanup; status 124 is retained. Driver part 2 was interrupted by
an environment update before a result and is marked uncompleted. Neither case
is counted among the passing commands.

## 3. Rejected approaches

Source-home experiments moved Tier 1 or deferred/input work before optimization.
They changed inlining and code size: the input experiment reduced CHECKER but
grew TYPES more, increasing combined function text by roughly 0.98 MB. The Tier
1 experiment saved much less code and still changed specialization. Neither
patch is included in the candidate. Their concise object/call-site evidence is
under `rejected/`.

A small common-header PCH removed too little work from the actual critical path
to justify adding it. The retained changes address avoidable parsing and
dependencies directly, then parallelize a substantial backend phase without
moving source optimization boundaries.

## Reproduction

Use the candidate Buster source revision in `source-identity.json`, with the
pinned toolchain on PATH. The ordinary and optional builds use:

```sh
BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 ./build.sh --jobs 4
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --jobs 4
BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 ./build.sh --config Debug --jobs 4
BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 BUSTER_PARALLEL_CODEGEN=1 ./build.sh --jobs 4
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 BUSTER_PARALLEL_CODEGEN=1 ./build.sh --jobs 4
cc -std=c17 -O2 -Wall -Wextra -Werror tools/ci/build_regression.c -o build/build-regression
build/build-regression --parallel-codegen-only
```

Run a second unchanged build to check the no-op contract. The complete build
regression runs the production-source fanout and count-drift checks as well as
the real optional compiler build/bake. Exact prototype and runtime argv are in
their JSON receipts; replace only the recorded checkout/toolchain root paths.

For performance acceptance, run paired clean builds and representative
implementation edits on the approved 9700X, each through the existing exclusive
host lock and core allocation. Measure the emitted compiler's representative
runtime workloads too before changing the new mode's default. No accepted
speedup percentage or runtime-regression conclusion is inferred from this
development packet.

Original probes, reports and build integration in this packet are original
contributions under Apache-2.0 WITH LLVM-exception. The compiler sources used by
the probes retain the component notices in Buster's `THIRD_PARTY_NOTICES.md`.
No LLVM implementation source is incorporated.
