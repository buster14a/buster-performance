# Nested fragments (#883): checker sanitizers and attempted-root inventory

This packet records two bounded qualifications for [Buster #883](https://github.com/buster14a/buster/pull/883):
complete default checker runs under O3 ASan/UBSan/bounds in native and baseline host builds,
and one non-timing frozen-SQLite attempted-root diagnostic with a matched-source object comparison.
It preserves the original failed checker runs as well as the corrected runs. It makes no speedup
or all-expression coverage claim.

## Exact source boundaries

The successful sanitizer runs executed private archives of tree
`5648a6b82f166faea3d3d4cbc7b3c2093836ce43` **before** the corresponding integration commit
was created. The committed tree of [9b33f1331f542254fb0f0a695f052ab8ba6f3ef8](https://github.com/buster14a/buster/commit/9b33f1331f542254fb0f0a695f052ab8ba6f3ef8)
was then verified identical. That commit normally composes the original PR head
`0797050b189bde8a0c7a36beb568a80430d62dec` with main
`c78ca51554ff895c8149a8d7f05307e53236b911` and the one fixture correction described below.
All four files changed by #883 remain byte-identical to the original PR head.

The tested commit is now a public ancestor of PR head
`b68c62de6f3a15eb70056835925979bc3079a433`, whose tree is
`88dc687093996c6f9360676bd0e40c5a4101c073`. **The full sanitizer and inventory results in
this packet apply to 9b33/5648, not to b68/88dc or later main.** The later composition's
ordinary checker runs and [CI run 41043258950](https://github.com/buster14a/buster/actions/runs/41043258950)
are separate evidence and are not included or reclassified here.

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

## Non-timing SQLite attempted-root diagnostic

After both corrected sanitizer checker runs finished, a fresh archive of the same tree was built
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
- `inventory/`: raw attempted-root records, original C aggregator and its controls, exact trace patch,
  input/source/binary/object identities, commands, failures, successful results and object comparison.
- `source/`: raw-copy ledger/checks, public commit/tree identities, and the 41-unit metadata audit.
- `PROVENANCE.md`: origins, derivations and omitted artifacts. `package.sha256` verifies the packaged bytes.

All 206 copied raw files are byte-identical to their recorded local sources. Recorded
`compile_commands.json` files are Clang `-MJ` fragment streams, not JSON arrays; the accompanying
`compile_commands.normalized.json` files remove only each line's trailing comma and wrap the
objects in an array for inspection. `original/compile-flags-native.argv.txt` renders the preserved
NUL-delimited argv as one argument per line. Neither derivation changes compilation flags.

Compiler/probe/aggregator executables, object files, frozen corpus contents, full source archives,
Git index files and generated failed-test binaries are omitted. NUL-delimited **argument metadata**
is retained as raw data. Historical hash lists retain original paths, including references to
omitted artifacts; they are identities, not portable package-verification commands. Use
`package.sha256` for this package. No compiler DCO policy or license files are imported or changed.
