# PR #1453 one-return head comparison

This record measures [buster PR #1453](https://github.com/buster14a/buster/pull/1453) head `55f7f86752a3c9d2290ffd3ac33bb9e7b71c31e8`, which changes one warning-type renderer to use the repository's one-return style. It compares the head to parent `7081303c325e6c05d429698a455b6208bbf3b8ad` and to main `2dc50258e8b33393474b64032a5cbe9f17c63def`. This is one SQLite syntax-only workload, not full-corpus performance acceptance, correctness review, or CI qualification. The selected head and base can become stale.

The head was built Release with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`; parent and main reuse the compilers built in [the earlier paired comparison](https://github.com/buster14a/buster-performance/pull/288). The retained scripts invoke `exclusive.sh` separately for the head build and each sample on Benchpress (Ryzen 7 9700X, Linux 6.18.50-2-lts). The head build receipt records lock ownership and successful exit; the earlier record notes the parent and main builds did not retain positive build-lock receipts. Every sample receipt records `BUSTER_9700X_HELD=1`, matching owner snapshots, compiler hash, successful exit and output hashes. The scripts specify alternating pair order, CPU 2 and SQLite `-fsyntax-only` with the recorded flags, and both events report 100% running. Receipt timestamps are consistent with that order but one-second resolution cannot establish within-second ordering.

| Pair | Parent instructions | Head instructions | Parent cycles | Head cycles |
| --- | ---: | ---: | ---: | ---: |
| 1 | 1,390,654,958 | 1,390,654,977 | 588,284,424 | 583,985,634 |
| 2 | 1,390,654,961 | 1,390,654,972 | 584,795,780 | 583,772,360 |
| 3 | 1,390,654,953 | 1,390,654,970 | 586,713,645 | 584,238,436 |

The head is 11–19 instructions above parent in these pairs. Their executables have different hashes. Three pairs do not establish a general timing change.

| Pair | Main instructions | Head instructions | Main cycles | Head cycles |
| --- | ---: | ---: | ---: | ---: |
| 1 | 1,363,315,020 | 1,390,654,070 | 566,634,897 | 584,749,291 |
| 2 | 1,363,315,021 | 1,390,654,077 | 566,492,394 | 586,409,232 |
| 3 | 1,363,314,998 | 1,390,654,078 | 565,266,296 | 584,340,871 |

Medians are 1,363,315,020 vs 1,390,654,077 instructions (+2.005%) and 566,492,394 vs 584,749,291 cycles (+3.223%). Three pairs of one workload do not determine a corpus-wide effect. The twelve stdout streams are empty; all stderr streams have SHA-256 `8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35`.

Recorded compiler SHA-256 values are `f786f812a5fd7fa73a5578fa5ce8f3ade3a9bc373e93d1e535b79e2eaf3ff3b8` (main), `2a0d56b9fe12dc897247102a5be960db60b18bad3f07f84fbc9df728b2734153` (parent) and `af29480fadd7731fa3aad10f2cb64ea56a26ee24125612ce95ea0e3ce1e7f295` (head). Post-collection checks found clean tracked worktrees at those revisions and matching binaries, and SQLite source SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`; these do not independently establish build-time source or input state, and included headers were not individually verified. The retained bundle requires the recorded parent commit and resolves to head tree `b5b6dfdf386e9a968a130248421bd2627ba3727c`.

The archive contains the scripts, head source bundle and build log/receipt, compiler-hash and post-collection checks, and twelve counter/output records and sample receipts. The scripts are historical records, not a direction to rerun without checking current source and host policy. Verify the archive, output and reported rows:

```sh
sha256sum -c SHA256SUMS
mkdir -p /tmp/buster-1453-style-head
tar -xzf raw-evidence.tar.gz -C /tmp/buster-1453-style-head
python3 verify.py /tmp/buster-1453-style-head
```

These checks validate preserved bytes and recorded receipts, not build-time provenance or general performance. Collection and packaging: OpenAI Codex, model OpenAI / GPT-6, session `01a1b0e0-a314-7252-9c29-d958f2e64d73`, thread `01a1b0e1-01c7-77e3-aac3-5e875d1c15e1`. No shareable session URL was exposed.
