# Nested fragments (#883): checker sanitizers and attempted-root inventory

This packet records two bounded qualifications for [Buster #883](https://github.com/buster14a/buster/pull/883):
complete default checker runs under O3 ASan/UBSan/bounds in native and baseline host builds,
and non-timing frozen-SQLite attempted-root diagnostics with matched-source object comparisons.
It preserves the original failed checker runs as well as the corrected runs. It makes no speedup
or all-expression coverage claim. The separate `propagated-cecd/` addendum adds fresh
ordinary/combined-sanitizer checker and native TSan shared-emission qualification on a
later integration commit. Its separately executed `propagated-cecd/inventory/` now adds
a fresh SQLite diagnostic/object comparison on that exact commit. No timing campaign is added.

## Exact source boundaries

The earlier successful sanitizer runs executed private archives of tree
`5648a6b82f166faea3d3d4cbc7b3c2093836ce43` **before** the corresponding integration commit
was created. The committed tree of [9b33f1331f542254fb0f0a695f052ab8ba6f3ef8](https://github.com/buster14a/buster/commit/9b33f1331f542254fb0f0a695f052ab8ba6f3ef8)
was then verified identical. That commit normally composes the original PR head
`0797050b189bde8a0c7a36beb568a80430d62dec` with main
`c78ca51554ff895c8149a8d7f05307e53236b911` and the one fixture correction described below.
All four files changed by #883 remain byte-identical to the original PR head.

The tested commit became a public ancestor of recorded PR head
`b68c62de6f3a15eb70056835925979bc3079a433`, whose tree is
`88dc687093996c6f9360676bd0e40c5a4101c073`. The historical `original/`, `corrected/`
and `inventory/` records retain their original scopes. **New `final-head-b68/` sanitizer
and SQLite diagnostic runs execute exact b68/88dc; the earlier inventory remains scoped
to 9b33/5648.** Neither set executes later main. Ordinary checker runs and [CI run 41043258950](https://github.com/buster14a/buster/actions/runs/41043258950)
remain separate evidence and are not reclassified as these sanitizer executions.

The original failed runs used clean composition tree
`d7dd1b1c7b94be3c318132c4db72c19a7c35e541`, from the same original PR/main parents.
Its only difference from corrected tree 5648 is `src/buster/compiler/c_check_program_half_test.c`:
the correction is exact blob `7eb7806fdf8274770958ca0d713f5a5e83f6276b` from
`d8738fb064bda854703be433f0acb360720eab8a`. It constructs special bfloat16 fixture values
through pointer output instead of returning a bfloat16 scalar. The special inputs and comparisons
remain, and the per-architecture checker counts are unchanged. See `source/commit-trees.txt`,
`source/original-corrected-paths.txt`, and the original/corrected source receipts.

## Propagated shared-emission repair: cecd/4558

Fresh qualification executed actual commit
[`cecd49628570e28004254a5639f10d74a13d3346`](https://github.com/buster14a/buster/commit/cecd49628570e28004254a5639f10d74a13d3346),
tree `4558f8ae3a7260670a186df0871088b250df1a3f`. It normally merges recorded public
#883 head `b68c62de` with accepted main `ce1bea1eeb8ece6db744726875b136fba023d317`,
which includes the [shared-emission lifetime repair #918](https://github.com/buster14a/buster/pull/918).
The commit existed before all five fresh source archives and executions. Each archive's
807 source blobs and executable modes were independently matched to the exact commit;
all post-run source and binary checks passed. The four owned fragment implementation/test
files still match original `0797050b` byte-for-byte; every other entry matches ce1.

These are newly observed results on cecd, with one invocation per role:

| Host build / instrumentation | Full command | Checks | Failures | Test exit | Audit exit |
| --- | --- | ---: | ---: | ---: | ---: |
| native ordinary O3 | `test-checker --seed 133` | 538,217 | 0 | 0 | n/a |
| baseline x86-64 ordinary O3 | same | 540,321 | 0 | 0 | n/a |
| native O3 ASan/UBSan/bounds | same | 538,217 | 0 | 0 | 0 |
| baseline x86-64 O3 ASan/UBSan/bounds | same | 540,321 | 0 | 0 | 0 |
| native O3 TSan | `test-check-units --keep` | 552 | 0 | 0 | 0 |

Clang 23.1.4 and lld built all 41 units per role on the Ryzen 9 7940HS. Both address
configurations instrument all units with `address,undefined,bounds`, and TSan instruments
all 41 with `thread`. Ordinary builds have zero sanitizer-instrumented units. Each address
role passes eight fresh fatal symbolized detector controls; TSan passes a fresh fatal
symbolized race control, each expected-failure exit 86. The actual-suite report audits
are empty. The approved fatal/leak/stack-lifetime runtime policy is retained, with audits
after the tests regardless of status. Existing host-feature skips and TSan's existing
reservation-test exclusion remain explicit; no additional case filter, suppression,
relaxation or successful retry replaces a failure.

The native TSan test observes 314 shared helper parts and retains the existing shared
object/linked-output identity and generated-program execution controls. This qualifies
the complete recorded checker commands and focused shared-emission test, not the whole
repository correctness inventory or fuzzing. No unsupported target instruction is forced.
Heavy calls use separate core grants: proof 1, build 2, checker/test 3 physical cores.
Exact cwd, NUL argv, grants, compiler arguments, metadata, binary hashes, policy, logs,
statuses and before/after source checks are retained in `propagated-cecd/raw/`.

The raw ordinary `metadata-counts.txt` files mistakenly call the total-unit alias
`instrumented_units=41`. They are preserved unchanged beside the frozen controller.
`propagated-cecd/raw/METADATA-NOTE.txt` and `metadata-summary.tsv` explicitly correct that label from the
actual compile records: ordinary sanitizer units 0, address/thread 41. Independent review
checked the flags directly; no execution was repeated for this bookkeeping correction.
The earlier post-merge wrapper's reserved-variable error is likewise retained in preparation
history; it caused no compiler/checker retry and no lost numeric merge status is invented.

`propagated-cecd/raw-copy-verification.tsv` maps all 202 copied raw receipts to their local
originals; every copy is byte-identical. Its inspection files only normalize Clang `-MJ`
fragments into JSON arrays or render retained NUL argv as lines. Compiler/probe binaries,
objects, generated temporary test inputs, full source archives and Git index files are
omitted. The raw guards record public #883 still at b68 through qualification; main had
advanced to `bfcfc35f11ceecfebf00d1b708656047703a1f50` afterward, outside this executed tree.

Historical d7dd failures, 9b33/5648 successes/inventory and b68/88dc successes/inventory
remain unchanged and keep their original scopes. Those five qualification roles contain
no SQLite inventory or timing campaign; the separate new inventory is described below.
Older attempted-root counts/object identities do not transfer to cecd.
These checks make no throughput, global-expression-coverage, original-material certification,
draft-readiness, bare-parent or later-main execution claim.

The retained controllers/copy script use historical absolute working paths and refuse
existing destinations. They are audit/reproduction context, not a portable automatic rerun.
Raw shell-escaped command captures retain their trailing argument separator through a
narrow whitespace attribute for those captures; the NUL argv remains alongside them.
The previous package manifest is retained as `propagated-cecd/previous-package.sha256`;
use the current top-level `package.sha256` to verify the expanded record.

### Fresh cecd/4558 SQLite diagnostic and object comparison

After source cecd was public and the five-role qualification was complete, one fresh
non-timing diagnostic executed exact `cecd49628570e28004254a5639f10d74a13d3346` / tree
`4558f8ae3a7260670a186df0871088b250df1a3f`. Independent setup review matched all 807
archive paths, blobs and modes. Only the byte-exact reviewed trace patch enables the
existing diagnostic in `build.sh`; the original C17 aggregator is likewise byte-identical.
All 41 trace-build units use native O3 without sanitizers; the trace compiler SHA256 is
`16abf9f9f50af1ffbc331ea415452d7e97cd7fe1b19f8c8eb1bff82c1a454f72`.

The comparison reuses the source-matched cecd native O3 ASan/UBSan/bounds compiler
qualified above, SHA256
`b7e4c7e1bbd2b7301922ea60ddb7418acc7bbd7581b309bd8232029ec23956e0`.
Its sanitizer host instrumentation differs from the plain trace build; these binaries
are not represented as otherwise identical. Its previous full checker/detector execution
is not rerun or relabeled. The new input compile has fresh approved fatal runtime policy,
separate reports and an unconditional audit, which exits 0 with no compiler/child report.

Both new compiles use identical complete target argv, cwd, output path and
`SOURCE_DATE_EPOCH=1792454400`: one lane, `-c`, explicit x86_64-linux-gnu target, `-march=znver5`,
GNU17, `-nostdinc`, pinned predefines and three frozen include directories. Only the output
directory changes from the earlier corrected original target argv; no unsupported-option
bypass is introduced. No generated target object is executed. Each compile has its own
one-core grant; trace/tool builds use separate two/one-core grants.

The fresh input checks verify SQLite SHA256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, GNU17 predefines
`a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`, and all 781 frozen
header-tree files (manifest SHA256 `2375b54d1e13fa840facbf6c2bf0be68bf360faff0c7092342e2d0462390e691`).
Both 807-file source manifests, the frozen inputs and both compiler identities are rechecked
after execution. Public-head guards observe cecd before and after the comparison.

| Newly observed cecd diagnostic | Count |
| --- | ---: |
| Attempted-root calls | 11,290 |
| Accepted calls | 275 |
| Accepted visited-node sum | 1,473 |
| Emitted typed entries | 1,472 |

The new raw trace has 11,290 records, 627,965 bytes and no other stderr lines. Full outcomes
and visit/entry bands remain in the TSV; independent reaggregation and arithmetic reproduce
them exactly. These are calls that reach the nested-fragment gate after the adjacent path
fails. Adjacent successes/pre-gate refusals are omitted; refusal visits can be partial,
and fallback can attempt descendants. Graph indices lack function/source attribution and
are not deduplicated. There is no all-expression denominator, rejection percentage, unique
expression coverage or per-operator attribution in this schema.

Trace compile, aggregation, untraced compile, strict audit and comparison all exit 0.
The two new unmodified objects compare identically at SHA256
`9c75f7ea5e3230be22028f593bc804565cb22fabb0360a5541ee4d1896c3d3cc`.
Counts, trace/TSV hashes and object bytes happen to equal earlier records, but these are
distinct new executions with their own source, binaries, commands, policy and status receipts.
The equality establishes identity for these two frozen-input compiles only; no older result
was substituted, and no corpus-wide semantic or throughput conclusion follows.

`propagated-cecd/inventory/raw/` contains 84 byte-identical copies from the new execution.
Its own copy ledger/check log maps them to original paths and hashes. `inspection/` only
normalizes the retained Clang metadata or renders NUL argv; `CURATION.txt` records those
native CLI transformations. Compiled tools/compilers, objects, full source archives and
frozen corpus contents are omitted. The redundant full host macro dump remains local with
its original hash; inspection retains only the first-party `BUSTER_HOST_VECTOR=1` predicate.
Original hash lists retain the omitted dump's identity and are not portable package checks.
The preceding 593-entry package manifest is retained
as `propagated-cecd/inventory/previous-package.sha256`; all preceding raw records remain
unchanged. Final measured compositions, timing, original-material certification and draft
readiness remain separate; this record makes no later-main or performance claim.

## Earlier complete checker command under combined sanitizers

Host: AMD Ryzen 9 7940HS (Zen 4), Linux, Clang 23.1.4. This host meets the native AVX-512
predicate; `BUSTER_HOST_ARCH=x86-64` separately exercises the baseline scalar fallback.
Each stage builds the complete compiler with `BUSTER_SANITIZER=address`,
`BUSTER_SANITIZER_OPTIMIZATION=3`, `BUSTER_LINKER=lld`, and the relevant host architecture.
Every one of 41 recorded compile commands in each of four configurations carries
`-O3 -fsanitize=address,undefined,bounds` (`source/build-metadata-audit.tsv`).

Each unfiltered command is:

```sh
cores -n 2 -- timeout 1800 ./build/compiler test-checker --seed 133
```

`CPATH`, `C_INCLUDE_PATH` and the oracle cache are unset. There are no test-selection flags,
changed counts, skipped checker sections or standalone substitute harnesses. Existing host-feature
skips printed by the checker remain in the logs. This is the complete default **checker command**,
not the entire repository correctness inventory.

The approved sanitizer helper configures fatal symbolized ASan/LSan/UBSan reports, leaks,
stack lifetime, strict strings/init-order and child-report auditing. Each of the four build
configurations separately passes eight expected-fatal symbolized detector controls: heap overflow,
use-after-free, use-after-return, use-after-scope, leak, undefined shift, bounds, and function type.
Their nonempty proof reports live under `probes/`; each checker's own `reports/` was separate and
empty. The child-report audit runs even after a failed checker exit. Complete commands and runtime
settings are retained in `original/run-checker.sh`, `corrected/run-checker.sh` and each `sanitizer.env`.

| Source stage | Host build | Checks | Assertion failures | Checker exit | Child-report audit exit |
| --- | --- | ---: | ---: | ---: | ---: |
| Original d7dd | native | 537,526 | 12 | 1 | 0 |
| Original d7dd | x86-64 | 539,630 | 12 | 1 | 0 |
| Corrected 5648 | native | 537,526 | 0 | 0 | 0 |
| Corrected 5648 | x86-64 | 539,630 | 0 | 0 | 0 |

All 12 original failures **in each architecture** concern the half-unary-chains,
half-conversions and bf16-arithmetic oracle comparisons. Those complete failure logs are retained;
they are not passes. Neither stage emitted a checker sanitizer report. The corrected results
qualify this checker command on the exact corrected tree; they do not establish O1, TSan, MSan,
fuzz acceptance, a 9700X performance result, or compiler-contribution certification.

## New published-head qualification: b68/88dc

The historical packet landed through [buster-performance #133](https://github.com/buster14a/buster-performance/pull/133).
The separate `final-head-b68/` addendum records **new execution** of public commit
[b68c62de6f3a15eb70056835925979bc3079a433](https://github.com/buster14a/buster/commit/b68c62de6f3a15eb70056835925979bc3079a433),
tree `88dc687093996c6f9360676bd0e40c5a4101c073`, after its publication. The public head
was independently checked before and after the runs. Both fresh source archives were
verified against all 805 tracked blobs of that exact public tree.

Each complete native/baseline build again records 41 O3 units with
`address,undefined,bounds` instrumentation, followed by the same unfiltered
`test-checker --seed 133` command under the approved fatal runtime configuration.
All eight **fresh** fatal symbolized detector proofs pass in each configuration;
proof reports remain separate from the empty real checker report directories.
Both child-report audits run unconditionally. The host is the same Ryzen 9 7940HS,
with Clang 23.1.4, native AVX-512 and baseline scalar configurations, using the
two-core FIFO budget. No test filters or changed counts are introduced.

| Exact b68/88dc host build | Checks | Assertion failures | Checker exit | Child-report audit exit |
| --- | ---: | ---: | ---: | ---: |
| native | 537,526 | 0 | 0 | 0 |
| x86-64 | 539,630 | 0 | 0 | 0 |

The new binaries' SHA-256 identities are recorded, with no executable included:

- Native: `1c1db11d64f8ece9fd40ce3b4a0ed1ee4c30dd4a66a8771578fd383c82419ff2`.
- Baseline: `bb416c36d7e26221863cfa1acf409d82682923b66d9495b55eed2825fc2fe5dd`.

`final-head-b68/receipt.txt`, source/blob manifests, per-architecture compiler versions,
arguments, compile metadata, detector proofs, checker logs, statuses, policy and audit
files provide the new evidence. This qualifies the complete default checker command
under the combined O3 sanitizers on exact b68/88dc. The new inventory below is separately
executed; the earlier inventory/object comparison is not relabeled. These checker runs
do not qualify the entire correctness inventory, other sanitizer modes, performance,
contribution certification, or any later source composition.

### Fresh b68/88dc SQLite diagnostic and object comparison

After both final-head sanitizer checker runs finished, a new plain native O3 trace compiler
was built from a fresh archive of exact public b68/88dc plus the same reviewed trace-only
patch. Its SHA-256 is
`2a777f00263fe20128ec4c61a6bae256436827073f76a3209a8a89b4008ac480`.
The aggregator and patch are byte-identical to the reviewed earlier tools. Both 805-file
source manifests and all 781 frozen headers are rechecked after execution.

The fresh one-lane diagnostic uses the frozen inputs, explicit target/header/predefine
flags and source epoch described below; its exact argv/cwd are in
`final-head-b68/inventory/`. These are newly collected results:

| Fresh b68/88dc diagnostic | Count |
| --- | ---: |
| Attempted-root calls | 11,290 |
| Accepted calls | 275 |
| Accepted visited-node sum | 1,473 |
| Emitted typed entries | 1,472 |

The raw stream contains 11,290 records and 627,965 bytes with no other stderr lines.
Full refusal outcomes and visited/entry-size bands are in the new TSV. The independently
collected counts equal the earlier ones; their source and execution receipts remain
separate. The dispatch-attempt, partial-subtree and source-attribution limits described
below apply equally here. No all-expression coverage or performance inference is made.

The new source-matched untraced compile reuses the final-head native **ASan O3** binary
identified above (`1c1db11d…`); its host instrumentation differs from the plain trace
build. Both runs use identical complete target argv, cwd, input/output arguments and
`SOURCE_DATE_EPOCH=1792454400`, with fresh approved fatal sanitizer policy and audit for
the untraced run. Trace compile, aggregation, untraced compile, audit and object comparison
all exit 0. Both new objects have SHA-256
`9c75f7ea5e3230be22028f593bc804565cb22fabb0360a5541ee4d1896c3d3cc`.
The equality is freshly observed, not assumed from the historical hash. It establishes
object identity only for these two frozen-input compiles. Public PR head b68 was checked
before the trace build and after comparison. No timing or source-branch change was made.

## Earlier 9b33/5648 SQLite attempted-root diagnostic

After both earlier corrected sanitizer checker runs finished, a fresh archive of tree 5648 was built
with only the existing `BUSTER_CHECK_LOWER_FRAGMENT_TRACE` diagnostic enabled by the recorded
`inventory/trace-flag.patch`. The build is separate, native O3 without sanitizer instrumentation;
its pre/post source manifests differ only at `build.sh`. It must not be used for timing.

Frozen SQLite SHA-256 is
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`;
the GNU17 predefines hash is
`a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`.
All 781 frozen header files are pinned by `inventory/frozen-headers.sha256`. The successful
command uses one lane, `-c`, explicit predefines, target `x86_64-linux-gnu`, `-march=znver5`,
`-std=gnu17`, `-nostdinc` and the three recorded frozen include paths. Full NUL-delimited
arguments, working directory and `SOURCE_DATE_EPOCH=1792454400` are recorded in the inventory receipts.

The original C aggregator produces the following **attempted-root call counts**:

| Outcome | Calls |
| --- | ---: |
| Accepted | 275 |
| Order | 1,268 |
| Bound | 9 |
| Operator | 7,978 |
| Effect | 1,196 |
| Type | 160 |
| Conversion | 404 |
| Payload | 0 |
| Capacity | 0 |
| Total attempted roots | 11,290 |

The accepted calls account for 1,473 visited nodes and emit 1,472 typed entries. They follow the
existing adjacent fast path's failure and the nested-fragment dispatch gate. The trace omits
adjacent-fast-path successes and roots rejected before that gate. Refused `visited` counts can
be partial subtrees, and fallback can attempt descendants. Root indices have no function/source
attribution in this schema; aggregation does not deduplicate them. These counts establish neither
an all-expression rejection percentage nor unique source-expression coverage. The outcome named
`operator` does not identify the operator. Full size bands and raw records are retained.

The matched untraced compile reuses the source-identical corrected native **ASan O3** compiler;
its host instrumentation differs from the plain trace build and is explicitly disclosed. Both
use the same complete target argv, input/output arguments, working directory and source epoch.
The shared output pathname is renamed only after success, without changing bytes. Trace compile,
aggregation, untraced compile and strict untraced child-report audit all exit 0. The two objects
are byte-identical (`cmp` exit 0), with SHA-256:
`9c75f7ea5e3230be22028f593bc804565cb22fabb0360a5541ee4d1896c3d3cc`.
This is object identity for these two frozen-input compiles, not corpus-wide semantic acceptance.

Two resolved setup failures remain disclosed in `inventory/status.tsv`: direct invocation of the
nonexecutable sanitizer shell helper returned 126 before being correctly run through Bash; the
first compiler command rejected Clang-only `--no-default-config` before reading SQLite (exit 1,
no object or attempted roots; aggregation exit 2, unavailable). The direct-driver retry omits
that unsupported option, which the corpus harness itself strips. No general flag bypass,
sanitizer suppression, source branch rewrite or timing campaign was introduced.

## Files, provenance and exclusions

- `original/` and `corrected/`: unmodified build, detector-proof, checker, audit, status, runtime,
  source and binary-hash receipts. Empty checker-report lists represent the audited empty report directories.
- `final-head-b68/`: separate fresh published-head source, build, detector, checker, binary-identity,
  policy, status and audit receipts, plus its byte-copy ledger and metadata-inspection derivations.
- `final-head-b68/inventory/`: the separately executed b68 diagnostic, exact source/tools/argv,
  raw trace/aggregation and matched-source sanitized-host object comparison, with its own copy ledger.
- `inventory/`: earlier 9b33/5648 attempted-root records, original C aggregator and its controls, exact trace patch,
  input/source/binary/object identities, commands, failures, successful results and object comparison.
- `source/`: raw-copy ledger/checks, public commit/tree identities, and the 41-unit metadata audit.
- `PROVENANCE.md`: origins, derivations and omitted artifacts. `package.sha256` verifies the packaged bytes.

All 206 earlier raw files remain unchanged; the 76 new published-head sanitizer files and
55 fresh inventory files are also byte-identical to their recorded local sources. Recorded
`compile_commands.json` files are Clang `-MJ` fragment streams, not JSON arrays; the accompanying
`compile_commands.normalized.json` files remove only each line's trailing comma and wrap the
objects in an array for inspection. The accompanying `*.argv.txt` files render preserved
NUL-delimited compile argv as one argument per line. Neither derivation changes compilation flags.

Compiler/probe/aggregator executables, object files, frozen corpus contents, full source archives,
Git index files and generated failed-test binaries are omitted. NUL-delimited **argument metadata**
is retained as raw data. Historical hash lists retain original paths, including references to
omitted artifacts; they are identities, not portable package-verification commands. Use
`package.sha256` for this package. No compiler DCO policy or license files are imported or changed.
