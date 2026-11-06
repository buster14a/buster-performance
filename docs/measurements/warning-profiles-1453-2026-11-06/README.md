# Exploratory warning profiles and discarded candidate (#1453)

This record preserves follow-up exploration for [buster PR #1453](https://github.com/buster14a/buster/pull/1453), alongside the earlier [warning-tuning measurements](../warning-tuning-1453-2026-11-06/README.md). It is not an acceptance measurement, a controlled estimate of candidate improvement, a correctness review, or CI qualification. No new hardware runs were performed for this record.

## Debug-info profiles

The retained collection script requested separately locked builds and `perf record` runs on Benchpress, an AMD Ryzen 7 9700X running Linux 6.18.50-2-lts. It built selected base `a581e20b8cd202196d8f2dcfff22ce7a5e09e9b6` and selected PR revision `1f88c53a59885e3ddb2a32d966561e412ed021de` with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=1`. Each was profiled once on CPU 2 compiling SQLite with `-fsyntax-only`, user-mode retired-instruction sampling period 50,000, and the flags in `1453-compare-debug-profiles.sh`. Each report lists about 8,000 samples and zero lost samples. Symbol percentages are proportions of sampled events, not absolute instruction totals, causal attribution, or evidence of an uninstrumented timing improvement; one profile per revision cannot establish variation. The report output is truncated to symbols at or above 0.3% by its original command.

The recorded binary SHA-256 values were `2c5812eb0355f8502a4bf59658ed66712a593b4a0d2aa2192c2a580fe0d80974` and `93e96c75d337e732404392309c24cd0894a53d9da6627e05313f4bbece1b8ed1`. During this later audit, the retained executables still matched these hashes and the two worktrees reported those respective commits with clean tracked status. Those post-run checks do not independently establish the full build-time source or input state. The collector identifies the SQLite source as SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`; that hash was independently rechecked after collection, not recorded before every run. Included headers were not individually verified.

## Discarded candidate

Candidate `deb6d7527b75dd1ace2ef66c55973cc28345b27a`, parent `1f88c53a59885e3ddb2a32d966561e412ed021de`, tested suppressing unnecessary conversion-warning formatting. It was not pushed to the compiler PR. The preserved bundle and patch are independent ways to reconstruct the candidate: the auditor applied the patch to its parent and obtained exact candidate tree `e2540d71402d6cdd415ea32d1c4b7aca34673b12`. The recorded candidate release binary SHA-256 `8784a46a6808372b14050450bed56d51cb0e3e104f9d7456243063832c7626b2` still matched during the later audit; that is not build-time provenance proof.

The three separate, non-interleaved candidate8 samples recorded 1,422,915,819, 1,422,915,814 and 1,422,915,823 user instructions, with user cycles 595,189,020, 592,794,848 and 591,442,122. Both events report 100% running. The collector discarded the candidate after observing no material instruction improvement relative to the earlier candidate7 batch; those batches were not paired and their cycles do not support a controlled improvement claim. The collector also reports local driver and differential checks, but the long driver test and a multicore Debug build were inadvertently run without the available local core queue; their results are not qualification evidence here. The branch was subsequently restored and rebuilt using the queue.

## Evidence and verification

The scripts invoke `exclusive.sh` separately for each build and each measured process, but **no positive lock-acquisition receipts were retained**. A script and successful-looking output alone do not prove lock ownership or exit status for every run. Five captured stdout files are empty; their stderr streams have the same SHA-256 `8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35`. The archive contains the original commands, build logs, diagnostic streams, three counter files, two raw perf recordings and reports, candidate patch and bundle, and binary-hash records. Raw recordings include host, path and process metadata; inspection found the recorded compiler process and no unrelated holder descriptions. The perf files lack recorded build IDs and the original executables are not distributed, so regenerating the same symbolized reports elsewhere may require the exact retained binaries and host symbol setup. The scripts are historical records, not instructions to rerun without reviewing current source and machine policy.

From this directory, verify file hashes and the retained counter and output values:

```sh
sha256sum -c SHA256SUMS
mkdir -p /tmp/buster-1453-exploration
tar -xzf raw-evidence.tar.gz -C /tmp/buster-1453-exploration
python3 verify.py /tmp/buster-1453-exploration
```

These checks validate archived bytes and stated counter rows, not exclusive ownership, compiler build identity, or performance conclusions. The originals remain on Benchpress and in the local audit copy. Workload scope is one SQLite input on one host, with debug and release builds as specified above.

Collection: OpenAI Codex, model OpenAI GPT-6, session `01a1b0e0-a314-7252-9c29-d958f2e64d73`, thread `01a1b0e1-01c7-77e3-aac3-5e875d1c15e1`. Audit and packaging: OpenAI Codex, model OpenAI GPT-6, same session, thread `01a1b0e1-da73-7731-9bcf-4312e3561034`. No shareable session URL was exposed.
