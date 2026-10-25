# Deployed generation acceptance

Live site: https://buster14a.github.io/buster/perf/
Source: `4f4a0bfa815f1bdbf2330f4e708cf8bc2e9934fa` (Buster PR #433).
Reviewed evidence: `1c0523ac42bb2f33e212226cf94626ac942ee4d2`.
Release timestamp: `2026-10-25T14:33:52Z`.
Generation SHA-256: `5cd87e934d750c9af3dc4331d057fbf0409e3bac2f8b177f1759aa8ecfdc99d9`.

The original C/browser implementation adds no external library, package setup,
upstream implementation, WASM, token or query service. Arrow IPC/JSONL and
Perfetto are formats. Independent qualification tools remain outside the project.

## Exact publication

`deployment.json`, `pages-generation.json`, both `pages-seal-*.json` and
HTTP header receipts identify the actual release (CRLF and trailing whitespace
normalized for readable Git storage). Two original C publisher
runs produced byte-identical trees. All twelve live assets plus the generation
were downloaded and byte-compared to the sealed artifact.
[Pages run40202984878](https://github.com/buster14a/buster/actions/runs/40202984878)
successfully published gh-pages commit
`34334dda6f6be9a750555e28ad90cc4556e6f431`.
There was no pre-existing gh-pages branch/site; future publications must preserve
other site directories.

Reproduce with separate checkouts at the source/evidence pins above, a new
output directory, and the fixed timestamp. From the Buster checkout:

```sh
bash tools/performance/build.sh
build/performance/publish . 4f4a0bfa815f1bdbf2330f4e708cf8bc2e9934fa /absolute/PERFORMANCE 1c0523ac42bb2f33e212226cf94626ac942ee4d2 docs/measurements/performance-pages-2026-10-25/site-index.json /absolute/NEW_PAGES_ARTIFACT 2026-10-25T14:33:52Z
```

Target-host builds/tests/conversions retain the existing per-run 9700X lock.
The publisher validates pinned manifests, tables and Git evidence objects before
writing the complete catalog/generation seal; corrupt/missing-resource refusal
checks passed. Data cannot supply executable commands/renderers.

Only code/schema/catalog are on Pages. Raw captures, harnesses and partitioned
history stay in durable performance-repository Git objects, via immutable raw
URLs with SHA-256/size checks, CORS metadata and download/local-open fallback.
No expiring Actions artifact is needed. Raw GitHub availability/service limits
still apply; larger future captures must declare an appropriate durable store.

## Measured budgets and production journey

`load-budget.json` counts exact uncompressed logical bytes. Catalog: 14,896 B
against 256 KiB. Conservative first dashboard: 516,073 B against 1 MiB, including
all twelve site assets, generation, manifest, census and every first-dataset
resource, including unused alternatives and original source files. The sealed
site artifact is 191,453 B. These are not compressed/network-transfer bytes.

[GitHub Pages limits](https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits)
were checked at release: 1 GB published site, soft 100 GB/month bandwidth and
10 builds/hour. These do not establish raw-GitHub bandwidth or future capture
memory budgets. Relative assets, hash routes, correct HTML/module/native MIME
and public CORS work at /buster/perf/. No root service worker, isolation headers
or WASM MIME exception is required.

`browser-production.json` records the actual history → compare → profile
journey. The initial foreign dashboard verified 288 rows in an observed 2,043 ms.
Foreign summaries remained ineligible for regression labels because independent
units/matching/correctness/coverage were unknown. Real native load verified
871 samples and the exact trace hash. In the isolated check, load-to-visible
was 248 ms (worker initialization 15.1 ms), range-to-visible 167 ms (worker
query 1.3 ms). The exact half-open range selected 500 samples / 500,000,000 ns
of source period weight. Reload restored the dataset/table/trace SHA and bounds
in 1,320 ms. Timings include automation/network/cache/render/observation overhead,
are single local-client observations, and are not compiler throughput evidence.

`memory-watch.c` is original read-only C, compiled with
`clang -std=c11 -O2 -Wall -Wextra -Werror` and checked using `clang --analyze`.
It samples /proc status every 20 ms, verifies PID start ticks, and writes a new
output only. `pages-memory-real-profile.json` records 2,236 samples over 45 s
during isolated real-profile loading and range rendering: initial 180,960 KiB,
observed peak 294,576 KiB, final 206,400 KiB RSS. The Electron renderer was
identified independently: isolated IAB tab 2 activated this PID from the spare
pool; closing that test tab removed this PID while the next spare and other
app processes remained. Earlier idle-spare measurements were excluded.

This is whole page-renderer RSS including same-process DOM/JS/worker allocations,
not incremental trace memory or total browser footprint; other GPU/network/browser
processes are excluded. Sampling can miss shorter spikes. VmHWM can be reset,
so its final value does not replace the observed RSS maximum. The worker retains
the full buffer and parsed indexes. Native decoding/materialization/drawing
refusal limits remain separate. No arbitrary byte/window slicing or universal
fixed memory cap is claimed.

## Fidelity and final checks

`reader-browser-final.json` and `profile-browser-final.json` record final
actual Chromium 156 results: 56 reader checks / 302 rows / 7,320 exact typed cells;
33 profile checks with eight synthetic and 871 real samples. Descriptions are
condensed; full original harnesses are in Buster. The earlier 31-check receipt
remains historical. Local UI checks separately verified profile→table filtering,
chart-drag→native selection and raw-nanosecond/hash deep links.

`symbol-oracle.json` checks all 232 symbolized ELF virtual-PC ranges/names
with independent system `nm -S -n --defined-only` against the exact matching
binary SHA in README.md. This is static qualification, not target performance
or a project dependency. Source/native/browser/independent Perfetto totals agree.
Unresolved libraries, unwind completeness, out-of-scope tasks, wakeup boundaries,
and actual source/assembly content remain explicit unknowns.

Exact-head required 9700X run 40201880940 and storage checks passed. Normal merge,
main containment, deployment and browser acceptance are separate receipts.
Merged-main run 40202588050 was pending in the shared main/9700X queue when this
receipt was created; no pass is inferred from PR or Pages success.

`main-acceptance.json` and its original logs now record successful focused
qualification of the exact integrated source on the approved 9700X: a separately
locked build and test action, exact source/evidence Git-archive commit comments
and hashes, native readers/import/profile checks, all frozen partitions and the
successful no-sampling launcher. This is the integrated performance acceptance;
the separate full compiler post-merge CI remains pending and is not claimed green.
The first operator attempt stopped before tests because the optional `hostname`
utility was missing; replacing it with the existing `uname -n` was the only
change. The failed attempt is retained. The independent symbol oracle's original
GNU nm 2.47 output is now retained in `symbol-oracle-nm.txt.gz` as well.
The raw test log and nm output use deterministic archival gzip to preserve their
exact original bytes, including trailing whitespace; decoded bytes were compared
to the originals. This encoding is not an application/build dependency.
