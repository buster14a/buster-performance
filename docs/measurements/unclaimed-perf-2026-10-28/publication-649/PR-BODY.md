The `-E -P` printer advances one output cursor after every token, serializing the short-token stores. This computes independent offsets with two bounded SIMD prefix sums for batches of up to 64 spellings of 1–64 bytes, then copies to those offsets. A batch needs at most 4,160 bytes. Masked tails preserve exact lengths; markers, long spellings, pragma ends and streamed embeds retain the existing path and scalar-printer oracle.

Addresses #649 with its prefix-offset direction. Spelling lookup and source-run compaction remain future work. This branch ports only the printer change onto main `321f5976`, without retaining new run metadata or other performance candidates.

Validation on publication head `927c46e1` (Clang 23.1.4, release build, separate `cores -n 2` runs):

- Full optimized 41-unit build passes.
- `test-preprocessor --clang --jobs 2` passes: 325 guarded prefix batches, every pragma alignment, >1 MiB buffer rollover, both marker modes, long/spliced/UCN/trigraph spellings and embeds; exact scalar/vector bytes.
- All 3,000 C17/C23 Clang differential fuzz cases finish with zero differences or missing results.
- CI selector self-test: 1,131 checks, zero failures; whitespace check clean.

The production patch has the frozen change's stable patch ID; the complete prefix/vector printer also matches the validated integrated `d3c1d45d` contract byte for byte. The final commit only adds the evidence link; the built production source is `09f4cd18`.

[Frozen 9700X evidence and reproduction records](https://github.com/buster14a/buster-performance/tree/4df43f7d7a685133b6beade655d9e9a306947081/docs/measurements/unclaimed-perf-2026-10-28/issue-649/target) compare `123d22ae` with `bc1b4861`, under the shared lock on CPU 2. The same frozen input tree and header paths feed both binaries. Printing falls from 4.604→3.833 ms for SQLite and 31.485→26.404 ms for the main source tree. Fresh-process `-E -P` medians across 21 rotated pairs per input fall from 15.799→14.624 ms and 85.306→78.067 ms. All 42 output files and stderr captures per input match exactly.

These are frozen-revision `-E -P` measurements, not ordinary `-c` or current-main timing claims. The later interference audit excludes the extra reversed main phase pair; the accepted phase pairs and whole-process cohorts precede the reported windows. PR #678's hosted/scalar shim companion remains pending separately; this PR keeps the native intrinsic path and adds no shim changes.

The implementation and regression fixtures are original project contributions; Clang is an external oracle only.
