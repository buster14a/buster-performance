# Candidate9 and paired warning measurements (#1453)

This exploratory record follows the [warning tuning](../warning-tuning-1453-2026-11-06/README.md) and [candidate8 evidence PR](https://github.com/buster14a/buster-performance/pull/283) for [buster PR #1453](https://github.com/buster14a/buster/pull/1453). It compares selected base `a581e20b8cd202196d8f2dcfff22ce7a5e09e9b6` and local candidate9 `6a6449565ad21e87e45fa995a2f56e294939cc77` on one SQLite input. Candidate9 is based on `1f88c53a59885e3ddb2a32d966561e412ed021de` and tests skipping tag spelling maps for builtin scalar types. It was not the compiler PR head at collection and this record does not qualify a different head or later base, establish correctness, or assert CI or performance acceptance.

## Three paired samples

On Benchpress (AMD Ryzen 7 9700X, Linux 6.18.50-2-lts), both Release compilers used `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`; candidate9 was built with Clang 23.1.1. The confirmation script specifies the sequence base/candidate9, candidate9/base, base/candidate9. It used CPU 2, `-fsyntax-only`, the SQLite flags recorded in the script, a common executable path and one shared-lock call per process. Each of the six retained receipts records `held=1`, the same owner before and after, copied compiler hash, successful status and output hashes. Receipt timestamps are consistent with the specified order but some share the same second, so timestamps alone do not establish within-second ordering. Both counters report 100% running.

| Metric | Base median (range) | Candidate9 median (range) |
| --- | ---: | ---: |
| User instructions | 1,363,327,839 (1,363,327,824–1,363,327,859) | 1,390,651,878 (1,390,651,872–1,390,651,884) |
| User cycles | 564,468,981 (563,569,244–566,571,126) | 583,167,441 (583,120,686–585,249,584) |

The differences of medians are +27,324,039 instructions (+2.00%) and +18,698,460 cycles (+3.31%). They are not the medians of pairwise differences. Three pairs on one input and host do not characterize uncertainty or general compiler performance. This comparison has no source-dependent compiler build workload and does not explain the remaining overhead.

Three earlier candidate9-only runs produced 1,390,652,265, 1,390,651,764 and 1,390,651,751 user instructions. Their script invokes separate locks, but they have no positive lock receipts; their unpaired cycles are not a controlled comparison. All nine captured stdout files are empty and diagnostic streams have SHA-256 `8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35`.

## Warning-policy controls

The collector subsequently ran two alternating base/candidate9 pairs per warning policy, with a separate shared-lock call and positive owner/status/binary/output receipts for each of the eight samples. The same CPU and SQLite syntax-only workload were used. The independent verifier checked the requested policy in each recorded owner command, before/after owners, hashes and 100% counter coverage. The table gives means of the two instruction counts per variant; the individual counter files are retained.

| Policy | Base mean instructions | Candidate9 mean instructions | Difference of means |
| --- | ---: | ---: | ---: |
| `-w` | 1,179,253,458.5 | 1,183,479,668.5 | +4,226,210 |
| `-Wno-return-type` | 1,354,158,694.5 | 1,387,373,950.5 | +33,215,256 |

Within each policy the captured outputs matched: both stdout and stderr were empty under `-w`, while the `-Wno-return-type` diagnostic hashes matched the default-policy diagnostics above. These flags alter warning behavior, so values across policies are not interchangeable. Two pairs do not establish statistical uncertainty, identify the functions responsible, or establish a general performance conclusion; the receipt timestamps have second resolution and cannot independently resolve order within the same second.

## Identities and limits

The six paired receipts record copied binary SHA-256 `5c07df7932e9579424c4827ef6e129317f8d8d29fe5a00750414faa149a5bc04` (base) and `2a37f20b11904ffec4caac79267606429ec919f1ba679e74db0ff7141c24901e` (candidate9). During this later audit both retained executables still matched, and their worktrees reported the stated commits with clean tracked status. This is post-run evidence, not independent proof of build-time source state. The collector identified SQLite's source hash as `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`; the same hash was checked after collection, not before every run. Included headers were not individually verified.

The preserved candidate patch applied to its stated parent reproduces candidate tree `54a066243f71535c071bbd044b0f13bca4bd11ed`; the included bundle was verified and requires that parent commit. The archive also retains the candidate build log, original scripts, all counters, owner receipts and outputs. Exploratory build and three earlier samples have no positive lock receipts. The collector reports that candidate9's local Debug build used the shared core scheduler and its checker-driver run was scheduled; this record makes no claim about those tests' outcome. No hardware measurements were rerun for this record.

From this directory, verify the archive and retained rows:

```sh
sha256sum -c SHA256SUMS
mkdir -p /tmp/buster-1453-candidate9
tar -xzf raw-evidence.tar.gz -C /tmp/buster-1453-candidate9
python3 verify.py /tmp/buster-1453-candidate9
```

The verifier checks file hashes, all 17 counter/output records and the 14 paired held/status/owner/hash receipts. It cannot prove source state at build time, independently reconstruct the lock mechanism, or qualify the compiler. Originals remain on Benchpress and in the local audit copy.

Collection: OpenAI Codex, model OpenAI GPT-6, session `01a1b0e0-a314-7252-9c29-d958f2e64d73`, thread `01a1b0e1-01c7-77e3-aac3-5e875d1c15e1`. Audit and packaging: OpenAI Codex, model OpenAI GPT-6, same session, thread `01a1b0e1-da73-7731-9bcf-4312e3561034`. No shareable session URL was exposed.
