# Discarded own-conversion reach experiment (#1453)

This record preserves a paired follow-up experiment for [buster PR #1453](https://github.com/buster14a/buster/pull/1453). Candidate `952018b1dd5ce3882ade7cd59f8299b3f61a5b0e`, based on integrated head `7081303c325e6c05d429698a455b6208bbf3b8ad`, tracked a node's own conversion candidate separately from its subtree reach. It was not pushed: the observed SQLite instruction improvement was small relative to added reach-bit propagation, with no clear cycle improvement. These results do not establish a general speedup, performance acceptance, or correctness qualification.

The retained scripts request Release builds with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` and invoke `exclusive.sh` separately for builds and each sample on Benchpress (Ryzen 7 9700X, Linux 6.18.50-2-lts). The parent compiler is the one built in the [current-base comparison](https://github.com/buster14a/buster-performance/pull/288); the candidate was built separately. Three interleaved pairs used CPU 2 and SQLite `-fsyntax-only`, with the flags in the candidate script. Each sample receipt records `BUSTER_9700X_HELD=1`, matching owner snapshots, the compiler hash, successful exit and output hashes. Build commands invoked the lock but positive build-lock receipts were not retained. The archived build logs redact other lock-holder descriptions with a marker; the remaining build lines are preserved. Both reported events ran for 100% of their measurement time.

| Pair | Parent instructions | Candidate instructions | Parent cycles | Candidate cycles |
| --- | ---: | ---: | ---: | ---: |
| 1 | 1,390,654,614 | 1,389,588,148 | 588,086,170 | 587,060,120 |
| 2 | 1,390,654,615 | 1,389,588,146 | 582,885,431 | 587,414,109 |
| 3 | 1,390,654,617 | 1,389,588,147 | 582,542,996 | 580,768,684 |

The median instruction difference is −1,066,468 (about −0.077%); the cycle differences vary in sign. Three pairs of a single workload do not determine a general effect. The six stdout streams are empty and each stderr stream has SHA-256 `8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35`.

The bundle and patch retain the candidate source (tree `847006e65974d911875ebc41a19cdb66897c7981`). Recorded compiler SHA-256 values are `2a0d56b9fe12dc897247102a5be960db60b18bad3f07f84fbc9df728b2734153` for parent and `94e72730a0171b14ec16073f28700d25ca2848b9f06ac1fa073329096e2e187f` for candidate. Post-collection checks found clean tracked worktrees at those revisions and matching binaries, and SQLite source SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`; they do not prove build-time source/input state, and included headers were not individually verified. A 280-case local expression comparison matched; no full candidate suite or independent code review is claimed.

The archive contains the scripts, redacted build logs, source bundles and patch, compiler-hash and post-collection checks, six counter/output records and receipts. Scripts are historical records, not a direction to rerun without checking current source and host policy. Verify preserved bytes and reported values:

```sh
sha256sum -c SHA256SUMS
mkdir -p /tmp/buster-1453-own-reach
tar -xzf raw-evidence.tar.gz -C /tmp/buster-1453-own-reach
python3 verify.py /tmp/buster-1453-own-reach
```

These checks verify preserved bytes and receipt contents, not build provenance or general performance. Collection and packaging: OpenAI Codex, model OpenAI / GPT-6, session `01a1b0e0-a314-7252-9c29-d958f2e64d73`, thread `01a1b0e1-01c7-77e3-aac3-5e875d1c15e1`. No shareable session URL was exposed.
