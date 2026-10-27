# Ryzen 7 9700X compiler microarchitecture evidence

Measurements collected on 27 October 2026; publication prepared on 28 October 2026. Buster source is pinned to [`92c025e71856d13eb34247477c5294d2cead139e`](https://github.com/buster14a/buster/tree/92c025e71856d13eb34247477c5294d2cead139e). This record changes no compiler implementation and does not measure later optimization branches.

Full object compilation of the frozen 9,507,037-byte SQLite 3.53.2 amalgamation reaches a median **187.53 MB/s on eight physical cores**, against **63.79 MB/s on one**. One GB/s aggregate needs about 5.3 times this throughput. The primary memory-controller run measures **268.73 DRAM bytes per original source byte**. Semantic data, initialization and repeated traversals dominate; backend lanes alone provide limited whole-file speedup.

- [Analysis and optimization roadmap](analysis.md)
- [Key results](results.json) and [collection manifest](collection-manifest.json)
- [370 named core-event measurements, 365 distinct encodings](tables/9700x-core-counters.csv)
- [Derived metrics](tables/derived-metrics.csv), [every metric attempt and its status](tables/metric-collection-status.csv), and [mapping/validity notes](tables/metric-validation-notes.csv)
- [Reproduction method and original collection tools](method/README.md)
- [Budget explorer](budget-explorer.html), downloadable for local use; its [source fragment](budget-explorer.fragment.html) is also retained

## Full downloadable evidence

[The release](https://github.com/buster14a/buster-performance/releases/tag/microarch-9700x-2026-10-27-92c025e7) carries the large binary files, keeping them out of Git history:

1. **`microarchitecture-9700x-2026-10-27-evidence.tar.zst`** contains the entire public evidence tree: all readable records, 15 primary/supplemental perf captures, exact compiler executables, validated SQLite objects, frozen source/header inputs, source archives, kernel symbols, runtime libraries and their corresponding source/packaging records.
2. **`microarchitecture-9700x-2026-10-27-exploratory.tar.zst`** retains the superseded exploratory captures, including the mixed recording that reproduces the READ-record parser error. These are explicitly excluded from quantitative primary evidence.
3. **`RELEASE-ASSETS.sha256`** verifies both archives. The expanded evidence tree has its own `PUBLIC-SHA256SUMS`; the exploratory archive has `EXCLUDED-SHA256SUMS`.

To restore the evidence into an empty directory:

```sh
mkdir restored-evidence
tar --zstd -xf microarchitecture-9700x-2026-10-27-evidence.tar.zst --strip-components=1 -C restored-evidence
cd restored-evidence
sha256sum -c PUBLIC-SHA256SUMS
```

The repository contains the report, tables, tools, logs and textual reports directly. Captures and reproduction/runtime-source directories arrive with the release archive. Their omission from Git is a storage decision, not missing experimental evidence. `PUBLIC-SHA256SUMS` therefore checks the expanded archive, not a text-only clone.

## Measurement interpretation

Core counters were collected in small groups: all 370 named requests have full scheduling coverage and no collection/compile errors. All 147 exposed derived metric names were also attempted individually; 142 yield finite results, four yield nonfinite values, and the unsupported generic LLC request fails before compilation. The broad simultaneous metric sweep is retained as exploratory because duty falls to 6%.

The target's final standalone IBS operation recording and simultaneous counter-group/IBS recording have zero lost samples and zero misordered timestamps. All 402,497 standalone compiler instruction samples match exact assembly addresses. The report distinguishes cycles, sampled operations, load-miss weights and overlapping retirement delays.

Full coverage does not validate every exposed alias on this CPU SKU. Same-run controls find the DF read metric at 85.08 GB/s against UMC reads at 31.65 GB/s, and almost zero DF writes against UMC writes at 19.37 GB/s. The memory budgets use UMC throughout; the DF aliases remain rejected pending mapping validation.

The local 7940HS measurements use its existing six-core grant and remain supplemental. TCC/Clang runs use different installed headers/predefines from Buster's frozen setup and provide context, not a controlled compiler ranking. The 173-row SQLite generated-code smoke test passes for Buster and its Clang/TCC controls; that does not establish full compiler conformance or generated-program performance equivalence.

## Publication and provenance

Only four disk UUID occurrences were replaced with zero UUIDs in two hardware configuration snapshots. Counters, timings, source hashes, raw capture payloads and binaries retain their measured bytes. The original primary-file digests remain in `ORIGINAL-SHA256SUMS`; public-file digests are regenerated after these metadata redactions and the addition of publication records. The original local collection remains intact.

The publication audit found no copies of current secret-valued environment entries or common credential markers in the capture tree. Raw profiling data intentionally retains the instruction/memory-address and stack information needed for analysis. See [provenance and component notices](PROVENANCE.md) for the compiler, frozen headers, system libraries and instruction measurements.
