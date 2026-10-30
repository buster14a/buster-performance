# Runtime-declaration qualification provenance

This packet continues only item 2 of [buster#877](https://github.com/buster14a/buster/issues/877)
and qualifies [buster#920](https://github.com/buster14a/buster/pull/920).
The implementation remains the original three source/test blobs. A signed,
additive integration brings accepted main `aca7ee0e1581d93d052482a045e8efd5381eebc9`
into the original contribution; it does not rewrite historical authorship.

The maintainer's authentic [certification comment](https://github.com/buster14a/buster/pull/920#issuecomment-6526779648)
covers the original contribution through `13e4acbbd324fa629b19f563547d950127600d68`.
Integration `f33d3a7e22dade61c9e028197eabe767025ec799` carries the current
session's prospective sign-off under the compiler repository's existing opt-in.
These are compiler-contribution certifications; they are not an approval event,
merge authority, or a blanket certification for this separate evidence repository.

The packet's original C diagnostic generator, trace reader and small Bash
orchestration are agent-assisted first-party work. They use existing repository
interfaces and contain no imported compiler implementation. Their SPDX notices
are preserved. Evidence commits do not invent a personal sign-off where no
applicable evidence-repository opt-in has been supplied.

## Reused bounded placement proof

The ELF object/linked-image proofs, inside-hot padding tool and context-checked
x87 roundtrip normalizer are reused unchanged from evidence commit
`a7211b80e1b8490fa6d65abf41a3e49051aade4e`
([performance#142](https://github.com/buster14a/buster-performance/pull/142),
merged as `54654094d8f4e7be1808d4846cdb51b1327f44dc`). Their complete original
files and notices, including the pre-adaptation originals, are retained under
`proof-tools/`. The local driver pins exact hashes before and after use.
There is no new ELF-reader acceptance in this campaign.

The reused proof supports only the disclosed ET_REL/ET_EXEC translation cases:
the exact hot section's symbol/addend/relocation movement, ordinary supported
file-backed sections including `.eh_frame`, bounded local-section PLT32
references with actual signed-32-bit linked target checks, contribution ownership
inferred independently before duplicate-symbol selection, and the narrowly
bounded Wild NULL-row exception. The original linked and object bytes are
retained as the reference. It does not establish arbitrary linker equivalence,
performance invariance, or semantics by itself. Whole zero-object and final-image
identity and separate runtime parity are mandatory.

The prior normalizer substitutes original `dc c0` bytes only for one exact
ambiguous printed x87 `fadd` in the uniquely named
`check_test_action_constraints` function. It refuses a different context/count;
whole-object identity must still pass. This preserves the original code rather
than accepting an assembler spelling's different encoding.

The original nine structural negative controls are rerun against hash-bound
copies of this baseline's real object and linked image. They target missing,
double and wrong addend translation; a wrong actual linked target; wrong
ownership base and duplicate ambiguity; and wrong/extended/noncanonical NULL
metadata. They inspect files without executing compiler images.

## Tool, build and input boundary

Both measured sources use official upstream Clang 23.1.4, LLVM revision
`7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`, binary SHA256
`c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67`.
The task-owned copy comes from the already configured verified Benchpress cache;
all 327 resource headers match the remote cache. The resource manifest digest is
`679c21861a19df62fd8e084f9d0a8a06e46ba4f7c05aff823369d4e1d9f5ba39`.
Both binaries are linked locally using Wild 0.11.0, SHA256
`da1bd2ff0b126524a664b70ef1e0d5522ce335f73a0cae32024ee8e8038122a5`.
The measurement host's separate installed linker is not used to build these
prebuilt executables.

The common `aca7ee0e` baseline build is shared read-only with #919's independent
qualification campaign. Its complete build/object/command/flag manifest was
independently checked before copying; copied artifacts are byte-identical. No
#919 modified source or candidate executable is used here. A temporary
host-distribution Clang baseline from that other campaign is excluded from this
primary packet and was never substituted for the upstream compiler.

The source archives, complete tracked-source manifests, retained per-unit
commands, NUL-delimited production flags/source order, ordinary executable
hashes and all 41 object hashes bind the builds. The build wrapper differs only
by retaining the otherwise temporary object directory. All 40 non-checker
objects must match across sources. Actual retained checker arguments and
expanded NUL flags must match before a shared diagnostic flags file is used.

SQLite uses the repository's frozen corpus/header/predefine manifest and
explicit GNU17/target/Zen5 flags. Lua `lstrlib.c` and its source-directory headers
are copied into a task-owned frozen directory; their complete file manifest is
retained. The Lua source SHA256 is
`3257cd857653560773947d70b65c8b8bf8ef43f920ed449587fa662224d859e1`.
These third-party sources are inputs to the compiler, not imported into its
implementation or committed as this packet's original material. Their source
notices remain with the configured/frozen inputs.

## Diagnostic scope

`runtime_probe_source.c` is a narrowly anchored original C source generator.
It refuses the other revision's source, repeated instrumentation, unknown modes
and an existing output path. The ordinary baseline clone retains the count
from the producer already called in production; it adds no new producer pass.
The candidate clone copies the complete preseeded runtime table, including
errno, runs the existing full-token scalar helper into the copy, and compares
it with the normal production helper's table in that same checked program.

The reported `visited` values are derived traversal trip counts from the
unconditional loop bounds, not instrumented dynamic counters or instruction
counts. Both production versions still pay for the existing compaction/list,
reverse initializer/local walk, lookups and every other lowering cost. Only
untimed clones add tracing and the full-token oracle pass. Their complete output
objects must equal the uninstrumented outputs. A separate clone flips one copied
errno slot immediately before comparison, with core dumps disabled; acceptance
requires a nonzero refusal and no nonempty output object.

The strict trace reader requires exercised spelled/native/scalar branches,
matching full/compact cardinalities and errno index, exact trip-count formulas,
and successful full-table oracle comparisons. Its synthetic controls establish
reader rejection behavior, not hardware executions.
