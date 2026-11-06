# PR #1453 current-base SQLite syntax comparison

This record compares [buster PR #1453](https://github.com/buster14a/buster/pull/1453) integrated head `7081303c325e6c05d429698a455b6208bbf3b8ad` with its main parent `2dc50258e8b33393474b64032a5cbe9f17c63def`, following the [earlier tuning measurements](../warning-candidate9-1453-2026-11-06/README.md). It captures one workload and is not full-corpus performance acceptance, correctness review, or CI qualification. The measured compiler revision can become stale as the PR or main moves.

The script built both Release compilers with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` and invoked `exclusive.sh` separately for each build and each measured process on Benchpress (Ryzen 7 9700X, Linux 6.18.50-2-lts). It then ran three pairs, alternating order, with CPU 2 and SQLite `-fsyntax-only`; see the script for the exact flags. Each sample receipt records `BUSTER_9700X_HELD=1`, matching before/after owner snapshots, the compiler hash, successful exit and output hashes. Receipt timestamps are consistent with the script order but have one-second resolution and cannot establish ordering within the same second. Build commands invoked the lock but no positive build-lock receipts were retained. Both reported counter events ran for 100% of their measurement time.

| Pair | Main instructions | PR instructions | Main cycles | PR cycles |
| --- | ---: | ---: | ---: | ---: |
| 1 | 1,363,315,064 | 1,390,654,622 | 568,110,800 | 582,186,597 |
| 2 | 1,363,315,044 | 1,390,654,614 | 566,175,700 | 587,015,877 |
| 3 | 1,363,315,069 | 1,390,654,609 | 565,331,257 | 584,518,208 |

Medians are 1,363,315,064 vs 1,390,654,614 instructions (+2.005%) and 566,175,700 vs 584,518,208 cycles (+3.240%). Three samples of one workload do not determine a corpus-wide effect. The six stdout streams are empty, and each stderr stream has SHA-256 `8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35`.

The recorded compiler SHA-256 values are `f786f812a5fd7fa73a5578fa5ce8f3ade3a9bc373e93d1e535b79e2eaf3ff3b8` for main and `2a0d56b9fe12dc897247102a5be960db60b18bad3f07f84fbc9df728b2734153` for the integrated head. Post-collection checks found clean tracked worktrees at the selected revisions and matching binaries, and SQLite source SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. Those checks do not independently prove build-time source/input state, and included headers were not individually verified. The retained merge bundle requires its recorded parents, PR predecessor `74f9cc4250874becc1c43438df5f156e54565d59` and main `2dc50258e8b33393474b64032a5cbe9f17c63def`, and preserves the selected integration commit. Independently merging those parents reproduced its exact tree `2fe3411e52c4865c60b51271f42b9d0f3660d766`.

The archive contains the script, build logs, compiler-hash and post-collection checks, merge bundle, six counter/output files and receipts. Two build-log entries identifying other lock holders were replaced with omission markers; originals remain with the collector on Benchpress. The script is a historical record, not a direction to rerun without checking current source and host policy. Verify the archive and the reported rows:

```sh
sha256sum -c SHA256SUMS
mkdir -p /tmp/buster-1453-current-base
tar -xzf raw-evidence.tar.gz -C /tmp/buster-1453-current-base
python3 verify.py /tmp/buster-1453-current-base
```

These checks validate preserved bytes and receipt contents, not build provenance or corpus-wide performance. Collection and packaging: OpenAI Codex, model OpenAI / GPT-6, session `01a1b0e0-a314-7252-9c29-d958f2e64d73`, thread `01a1b0e1-01c7-77e3-aac3-5e875d1c15e1`. No shareable session URL was exposed.
