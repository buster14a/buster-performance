# Nested fragments (#883): checker sanitizers and attempted-root inventory

This packet records two bounded qualifications for [Buster #883](https://github.com/buster14a/buster/pull/883):
complete default checker runs under O3 ASan/UBSan/bounds in native and baseline host builds,
and one non-timing frozen-SQLite attempted-root diagnostic with a matched-source object comparison.
It preserves the original failed checker runs as well as the corrected runs. It makes no speedup
or all-expression coverage claim.

## Exact source boundaries

The earlier successful sanitizer runs executed private archives of tree
`5648a6b82f166faea3d3d4cbc7b3c2093836ce43` **before** the corresponding integration commit
was created. The committed tree of [9b33f1331f542254fb0f0a695f052ab8ba6f3ef8](https://github.com/buster14a/buster/commit/9b33f1331f542254fb0f0a695f052ab8ba6f3ef8)
was then verified identical. That commit normally composes the original PR head
`0797050b189bde8a0c7a36beb568a80430d62dec` with main
`c78ca51554ff895c8149a8d7f05307e53236b911` and the one fixture correction described below.
All four files changed by #883 remain byte-identical to the original PR head.

The tested commit is now a public ancestor of PR head
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

## Complete checker command under combined sanitizers

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
