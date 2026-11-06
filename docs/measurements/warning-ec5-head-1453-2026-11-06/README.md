# PR #1453 comparison after #1524 integration

This record compares [buster PR #1453](https://github.com/buster14a/buster/pull/1453) integrated head `ef2384afa7ed23d9b646ae930274b4e512967e23` with its main parent `ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b`, after main merged #1524. It follows the [previous head comparison](https://github.com/buster14a/buster-performance/pull/290). The result covers one SQLite syntax-only workload, not full-corpus performance acceptance, correctness review, or CI qualification. The selected source revisions can become stale.

The script built both Release compilers with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` and invoked `exclusive.sh` separately for each build and each measured process on Benchpress (Ryzen 7 9700X, Linux 6.18.50-2-lts). Three pairs alternate order, use CPU 2 and SQLite `-fsyntax-only`; the script lists exact flags. Each sample receipt records `BUSTER_9700X_HELD=1`, matching owner snapshots, compiler hash, successful exit and output hashes. Build commands used the shared lock but no positive build-lock receipts were retained. The archived build logs redact other lock-holder descriptions with a marker; remaining build lines are preserved. Both measured events report 100% running.

| Pair | Main instructions | PR instructions | Main cycles | PR cycles |
| --- | ---: | ---: | ---: | ---: |
| 1 | 1,362,924,214 | 1,390,263,926 | 569,904,340 | 582,633,816 |
| 2 | 1,362,924,211 | 1,390,263,928 | 571,986,134 | 584,504,899 |
| 3 | 1,362,924,235 | 1,390,263,930 | 569,834,606 | 585,388,530 |

Medians are 1,362,924,214 vs 1,390,263,928 instructions (+2.006%) and 569,904,340 vs 584,504,899 cycles (+2.562%). Three pairs of one workload do not determine a corpus-wide effect. All stdout streams are empty and each stderr stream has SHA-256 `8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35`.

Recorded compiler SHA-256 values are `51fa8ef2c145ba232daf21fbe69257a10feaacb5e87e7be7aeae0bdd2dd92c59` for main and `2d80a3e01650bdc3218facdbb5870b96ad5929c74b9d91b5ff37e1563d838ab9` for the integrated head. Post-collection checks found clean tracked worktrees at those revisions and matching binaries, and SQLite source SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`; they do not independently prove build-time source/input state, and included headers were not individually verified. The retained merge bundle requires its recorded parent commits.

The archive contains the script, redacted build logs, compiler-hash and post-collection checks, merge bundle, six counter/output records and receipts. The script is a historical record, not a direction to rerun without checking current source and host policy. Verify the archive and reported rows:

```sh
sha256sum -c SHA256SUMS
mkdir -p /tmp/buster-1453-ec5-head
tar -xzf raw-evidence.tar.gz -C /tmp/buster-1453-ec5-head
python3 verify.py /tmp/buster-1453-ec5-head
```

These checks validate preserved bytes and receipt contents, not build-time provenance or corpus-wide performance. Collection and packaging: OpenAI Codex, model OpenAI / GPT-6, session `01a1b0e0-a314-7252-9c29-d958f2e64d73`, thread `01a1b0e1-01c7-77e3-aac3-5e875d1c15e1`. No shareable session URL was exposed.
