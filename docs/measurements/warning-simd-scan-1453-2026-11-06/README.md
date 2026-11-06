# Discarded SIMD literal-source scan experiment (#1453)

This record preserves a paired exploration for [buster PR #1453](https://github.com/buster14a/buster/pull/1453). Candidate `a60ed16b0f7e8e1c13f067495320348fec44fee7`, based on head `55f7f86752a3c9d2290ffd3ac33bb9e7b71c31e8`, filters evaluated nodes in the vectorized scan for literal-only source contexts. It was not pushed: the observed SQLite instruction improvement was small relative to the additional scan logic, and cycle differences varied. These results do not establish a general speedup, performance acceptance, or CI qualification.

The retained script requests a separately locked Release candidate build with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` and separately locked samples on Benchpress (Ryzen 7 9700X, Linux 6.18.50-2-lts). The parent compiler is the one built in [the preceding exact-head comparison](https://github.com/buster14a/buster-performance/pull/290); its build has a positive lock receipt retained here. The candidate build used the lock but did not retain a positive build-lock receipt. Three interleaved pairs used CPU 2 and SQLite `-fsyntax-only`; the script has exact flags. Each sample receipt records `BUSTER_9700X_HELD=1`, matching owner snapshots, compiler hash, successful exit and output hashes. Both events report 100% running.

| Pair | Parent instructions | Candidate instructions | Parent cycles | Candidate cycles |
| --- | ---: | ---: | ---: | ---: |
| 1 | 1,390,654,959 | 1,389,689,397 | 584,684,108 | 583,839,562 |
| 2 | 1,390,654,957 | 1,389,689,402 | 583,559,957 | 585,367,154 |
| 3 | 1,390,654,951 | 1,389,689,403 | 584,636,701 | 583,987,044 |

The median instruction difference is −965,555 (about −0.069%); cycle differences vary in sign. Three pairs on one workload do not determine a general effect. All stdout streams are empty and each stderr stream has SHA-256 `8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35`.

The bundle and patch retain candidate source (tree `14805bf10c4b3c573b1a570d1306ab7e6a3d26c8`). Compiler SHA-256 values recorded at collection were `af29480fadd7731fa3aad10f2cb64ea56a26ee24125612ce95ea0e3ce1e7f295` for parent and `23a6de51bc16e9ac9ad1e43aee2f45d8c2c1bd337674dd4844b37e747c819f71` for candidate. Post-collection checks found clean tracked worktrees at those revisions and matching binaries, and SQLite source SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`; they do not prove build-time source/input state, and included headers were not individually verified.

A focused independent source review found no actionable issue. The reviewer reports 16,384 guard-page lane/tail comparisons and 1,152 scalar/vector diagnostic comparisons with no mismatches. The retained test sources support further inspection; the diagnostic comparison used existing locally built binaries, not independently rebuilt source-pinned executables. These checks do not constitute a full candidate suite or hardware qualification.

The archive contains the collection script, build logs, parent build receipt, source bundles and patch, compiler hashes and post-collection checks, six counter/output records and receipts, and the focused test sources. Scripts are historical records, not a direction to rerun without checking current source and host policy. Verify retained bytes and sample rows:

```sh
sha256sum -c SHA256SUMS
mkdir -p /tmp/buster-1453-simd-scan
tar -xzf raw-evidence.tar.gz -C /tmp/buster-1453-simd-scan
python3 verify.py /tmp/buster-1453-simd-scan
```

These checks validate preserved bytes and recorded receipts, not build provenance or general performance. Collection and packaging: OpenAI Codex, model OpenAI / GPT-6, session `01a1b0e0-a314-7252-9c29-d958f2e64d73`, thread `01a1b0e1-01c7-77e3-aac3-5e875d1c15e1`. Focused review: same session and model, thread `01a1b1f3-bda4-7e10-88c2-0ec52bd3418c`. No shareable session URL was exposed.
