# First-party performance reader qualification

This generation replaces the retired dependency-based experiments with original
C and browser JavaScript. It adds no library/package dependency. Historical
receipts in `performance-site-2026-10-25` describe the earlier implementation
and are not current acceptance evidence.

- Buster source: `d7b07d3f71338b0844323fbf24b88c7bf11bff33`.
- Reference fixture archive: `8188065389d89b49b6ac5c683c1ec78e1b0dc85b`.
- Frozen original inputs: `d3453eb2099d1e4dcd9c997720fcf6e0d86b81ea`.
- Native acceptance harness: `validate.c` in this directory.

The subsequent schema-writer checkpoint is Buster
`696eba5d231fd5e39a5be93eed24e768a1096646`. Its
`native-writer-sanitizers.jsonl` receipt contains 187 checks, all passing, plus
the same 2,025 safety probes and 7,320 exact typed comparisons. It adds schema
writer round trips, native Unicode/duplicate-field probes and safe empty-string
handling. `wire-metadata-oracle.arrow` was produced independently with Apache
Arrow JavaScript 21.1.0 outside the project; `wire-metadata-first-party.arrow`
was produced by the original C writer. That independent reader also accepted
the new schema streams and verified retained schema/field metadata. The oracle
is an investigation tool only, never a project build/runtime dependency.

The C harness uses the same original tool source through `main.c`, preserving
its private function visibility for adversarial format probes. Independent
Arrow-generated fixtures and separately recorded JSONL provide the format
interoperability oracle. Every one of the 302 rows and 7,320 typed cells agrees.
The harness also checks identity, version/capability, resource, reference,
numeric-bound, Unicode, decimal and native-wire rejection cases.

The 2,025 Arrow byte/truncation mutations are memory-safety probes. Some mutate
valid data or ignored padding and correctly remain accepted; the receipt does
not claim that every mutation is malformed. Local ASan/UBSan ran with 180 checks
and no failures. Clang's static analyzer reported no diagnostics after the final
source changes. The optimized executable's only dynamic library is libc.

`browser.json` records 53 checks in actual Chromium 156 at the Buster subpath.
These include the complete exact fixture comparison, Unicode/spaced/prototype
field names, signed zero and nested exact export, resource verification,
unavailable/censored points, incompatible or incomplete populations, independent
unit identity, negative/zero baselines and the matched-pair estimator. The test
module runs directly in a browser, with no project test framework.

Reproduce the native checks from a Buster checkout:

```sh
bash tools/performance/build.sh
clang -std=c17 -D_GNU_SOURCE -O1 -g -Wall -Wextra -Werror \
  -fsanitize=address,undefined -fno-omit-frame-pointer \
  -I tools/performance \
  /path/to/buster-performance/docs/measurements/performance-first-party-2026-10-25/validate.c \
  -o build/performance/test-first-party
build/performance/test-first-party \
  /path/to/buster-performance/docs/measurements/performance-format-2026-10-24 \
  /path/to/frozen-performance-checkout \
  docs/performance/buster-manifest-v1.schema.json
```

On the approved host, every build/test/profile run takes the existing per-run
exclusive lock. Local correctness, physical-host qualification, hosted CI,
protected integration, profile fidelity and deployed-site acceptance remain
separate. This directory alone does not close the Pages roadmap.

## Frozen importer

`import.c`, `families.inc` and `import-tests.c` are original C. The importer
verifies the exact frozen inventory hash, sorted unique paths, all 1,043 Git blob
identities and sizes, and records a SHA-256 for each original file. Its frozen
CSV/TSV dialect retains escaped/multiline fields, empty records and literal
quotes inside unquoted diagnostic cells. `import-tests.json` records 25
ASan/UBSan source-preservation checks. The Buster reader/writer and adapter code
have separate source revision arguments.

The semantic foreign-string adapter reads both original CSVs directly, emits
typed JSONL and original-C Arrow schema sidecars, and checks all 7,308 cells
against the independently encoded immutable Arrow reference. Those reference
Arrow resources remain equivalent alternatives; they are imported data, not an
imported implementation. Original resource roles and unrelated metadata are
retained. No inner observations, per-case process-resource values or precision
are invented.

The complete census retains 17,789 structured source rows and 191,789 decoded
source cells. Unconverted fields stay opaque strings with explicit dispositions.
Family scope notes retain writer/process and workload-size/lane distinctions,
unavailable 0/-1 counter conventions, exact digest and source precision limits.
Opaque rows are not numeric timings, and protocol-only families emit none.

Build and run from Buster using exact source revisions:

```sh
clang -std=c17 -D_GNU_SOURCE -O2 -g -Wall -Wextra -Werror \
  -I tools/performance /path/to/this/directory/import.c \
  -o build/performance/import-first-party
build/performance/import-first-party \
  /path/to/buster-performance /path/to/frozen-performance-checkout \
  /path/to/this/directory/frozen-paths.tsv /new/output/directory \
  2026-10-25T10:45:00Z BUSTER_READER_COMMIT ADAPTER_SOURCE_COMMIT
```

The output directory must be new. Both revision arguments must identify the
actual source used. A failed conversion does not produce a sealed site catalog.
Reproducibility and full census/foreign validation are recorded separately from
these source-level probes.

`history/` is the deterministic generation from adapter source
`3a2e4beb211247af590e1c1d30c32dcbe4cf382d` and Buster
`696eba5d231fd5e39a5be93eed24e768a1096646`, with the fixed import timestamp
`2026-10-25T10:46:20Z`. Both fresh runs produced identical bytes. Native
validation passed for the census and foreign-string manifests, including
7,308 exact foreign typed cells. The independent original browser reader also
retained all 191,789 source cells exactly. `history-validation.json` records the
scope and distinguishes that module integration probe from actual browser UI
and physical-host qualification.
