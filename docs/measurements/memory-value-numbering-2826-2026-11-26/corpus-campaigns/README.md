# Issue #2826: corpus and differential correctness evidence

This record compares the baseline and PR #3622 compiler products on a cloud Intel Xeon Platinum 8370C host. It establishes correctness checks and output equality for the recorded inputs. It contains no target-machine runtime or compile-time performance measurement and does not establish a default-pass acceptance result.

## Read the complete receipts

The full, unmodified record is in [receipts.tar.gz](receipts.tar.gz): 1,362 files totaling 12,958,753 uncompressed file-content bytes. This includes the original README, every corpus and object report, product and input identities, all four differential campaigns, and their checksum manifest. The commands and four top-level campaign logs are also available alongside this summary.

From this directory, verify and extract the record into a separate directory:

```bash
sha256sum --check receipts.tar.gz.sha256
mkdir receipts
tar -xzf receipts.tar.gz -C receipts
(cd receipts && sha256sum --check FILES.sha256)
```

All directory paths below are relative to the extracted `receipts/` directory. The archive was extracted and every recorded file checksum verified before publication. It retains failed/no-verdict cases without truncating their diagnostics.

## Product identity

| Product | Revision | Tree | Actions run | Artifact |
| --- | --- | --- | --- | --- |
| Baseline | `8e4d32879e17b7d9548cad54257a2f8461328366` | `8bf0a22e6067a7698ca6257d3e6cbe40f49b108a` | `45779319802` | `15097652285` |
| Patched | `fd74b08c706c470673124f4526dbd9729f2dbf54` (PR merge) | `f580b2f93402e96ff94f567c006463842d0ea7b4` | `45786727439` | `15100529235` |

The patched tree is identical to PR head `e5cff9f6490fb0763fdf9f6f84d8fcd6c8daa54e`. Both are hosted `vector none O3` products with identical host flags and toolchain digest `eda0bc02300979a219273d969c9830eb0090c72d1fa357b24bc308ade5050259`. Archive hashes and extracted-file checksums were checked before execution. Product identities and checksums are in `identity/`; exact commands and archive identities are in `commands.txt`.

## Corpus and object comparison

The same absolute inputs, working directory, flags, and `SOURCE_DATE_EPOCH=1792454400` were used for both variants. All corpus preparations succeeded and every complete `--passes` output log was byte-identical between variants, including all memory-effect counts.

| Corpus | Files | Functions | `memory` effect | `tier1-memory` effect | Failures / unprepared |
| --- | ---: | ---: | ---: | ---: | ---: |
| c-testsuite | 220 | 430 | 100 | 105 | 0 / 0 |
| SQLite | 1 | 2,602 | 3,662 | 3,737 | 0 / 0 |
| musl | 1,355 | 2,775 | 3,325 | 3,326 | 0 / 0 |

The 5,807 functions are covered by the full logs in `corpus-logs/`. Frozen corpus manifests were verified by `tools/ci/fetch-corpus.sh`; the corpus and c-testsuite identifiers are in `identity/corpus/`.

SQLite object compilation selected `--tier1 --tier1-passes=+memory --tier1-report --lanes 1`. Both variants emitted a 2,324,048-byte object with SHA-256 `0baa358ed1f6ff3abb26dfce7be2a4e96164587ac9272b0bd1605e185f77e2af`. The complete report logs were also byte-identical: 1,349 requested/admitted/compiled functions, no fallbacks or errors, and 3,252 forwarded loads. The hashes, sizes, and reports are retained in `objects/`; object binaries stay in the local validation workspace.

## Differential campaigns

Every campaign selects Buster Tier 0 and Tier 1 with `+memory` and a Tier 1 report, plus Clang `-O0` and `-O2`. The harness compares complete standard output across all four modes. The seed range is always **2826–2835** and the per-process timeout is **60,000 ms**. No fixtures or generate-only executions count as passes.

| Campaign | Generator bounds | Passed | Failed / no verdict | Directory |
| --- | --- | ---: | ---: | --- |
| Initial YARPGen | Default | 8 | 2 | `differential-yarpgen/campaign-khJ3Fz` |
| Bounded YARPGen | `--max-array-dims=3` | 10 | 0 | `differential-yarpgen-bounded/campaign-QV8OyX` |
| Initial Csmith | Default | 8 | 2 | `differential-csmith/campaign-WAsFsA` |
| Bounded Csmith | `--max-block-depth 2 --max-funcs 4 --max-block-size 3` | 9 | 1 | `differential-csmith-bounded/campaign-dIBOCJ` |

The initial YARPGen run preserves two failures. Both Clang modes reject seeds 2830 and 2834 with GOTPCREL relocation range diagnostics, and both Buster tiers also reject seed 2834 with relocation-field range diagnostics. These failed cases establish no output agreement. The documented array-dimension cap bounds generated storage for compilers without a large-memory code model; the same ten seeds were then run once with that cap. The bounded run compiled all 50 requested functions in Tier 1 with zero fallbacks or errors. It forwarded zero loads, so its coverage is enabled-pass compatibility rather than direct forwarding examples.

The initial Csmith run preserves seeds 2832 and 2834 as failed/no-verdict cases: every compiler mode timed out on execution at the configured 60-second limit. Its **eight passing cases** compiled 370 requested functions in Tier 1 with zero fallbacks/errors and forwarded 262 loads. These coverage totals exclude the two timeout cases and preflight.

One bounded Csmith follow-up used the same ten seeds with the documented uniform size controls shown above. Its **nine passing cases** compiled all 228 requested functions in Tier 1 with zero fallbacks/errors and forwarded 158 loads. Seed 2832 still timed out in every selected mode and remains failed/no verdict. The coverage totals exclude that timeout case and preflight. These controls bound generated program structure; **they do not guarantee termination**. No further Csmith campaign or seed search followed.

Across these four completed campaign configurations, 35 of 40 case executions passed and five failed without an output-agreement verdict. All failures are retained: two initial YARPGen link-range cases, two initial Csmith timeout cases, and one bounded Csmith timeout case. There were no observed output mismatches. Counts are case executions across configurations, not a claim of 40 unique source programs or full Tier 1 coverage for failed cases.

Generator versions and documented bound controls are preserved in `identity/generators/`: Csmith `0cdc710315cfee9035e22ef4363ca479270d1934` (2.4.0) and YARPGen `1adb290f453505838f3aa33dc571f292b0c1810f` (2.0). Csmith's matching runtime headers have a retained SHA-256 manifest. The exact revisions and commands identify the reproduction inputs; continued availability of local scratch installations is not assumed.

## Receipt contents

Each campaign retains its request, provenance, summary, version probes, and CPU identity, plus per-case input/result records, exact generation/compile/run command records, failure signatures, and standard-output/error captures. Command JSON also contains hexadecimal argument bytes. `generated-inputs.sha256` adds cryptographic source fingerprints to the harness's input manifest.

`case-outcomes.tsv` indexes all ten outcomes in each configuration. `passing-coverage.tsv` reports only passing cases' Tier 1 compilation and forwarding counters; failed/no-verdict cases and preflight are excluded. The original JSON and stderr receipts remain the authority for these reductions.

Executables, object files, generated `.c`/`.h` files, NUL-separated replay files, and `generate.stdout` are excluded from this compact publication copy. In Csmith, `generate.stdout` is the complete generated source stream. Input metadata and SHA-256 fingerprints, together with exact generator revisions and invocation commands, identify each reproducible input without relying on future availability of the original local scratch workspace. Compiler diagnostics may contain source excerpts emitted by the compiler.

Baseline built-in optimizer/parser logs are in `baseline-tests/`. Patched scope regressions, sanitizer checks, mutation tests, and assembly review are recorded in the [parent evidence directory](../README.md).

---
Agent session: 6b07ee68-c48c-83ed-b6be-667326b63061 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6 Astra Pro
