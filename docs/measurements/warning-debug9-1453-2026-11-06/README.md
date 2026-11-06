# Exploratory candidate9 source profile (#1453)

This record preserves one follow-up profile of [buster PR #1453](https://github.com/buster14a/buster/pull/1453), alongside its [paired candidate9 measurements](../warning-candidate9-1453-2026-11-06/README.md) and [earlier exploratory profiles](../warning-profiles-1453-2026-11-06/README.md). It is not an acceptance measurement, a performance comparison, a correctness review, or CI qualification.

The retained script requested a separately locked debug-info build of compiler revision `6a6449565ad21e87e45fa995a2f56e294939cc77` with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=1`, then one separately locked `perf record` process on Benchpress (Ryzen 7 9700X, Linux 6.18.50-2-lts). The profile used CPU 2, SQLite `-fsyntax-only`, and user-mode retired-instruction sampling with period 50,000; the exact flags are in the script. The output reports approximately 8,000 samples and zero lost samples. The symbol report only includes entries above 0.3%; the three annotated functions were selected for exploration. The profile percentages describe sampled events, not exact instruction counts, causal attribution, or evidence of a speedup. A single sampled execution does not establish variation or represent other workloads.

The recorded compiler SHA-256 is `eeed8979503d4225dbf378a4f0579e7027d9db42ab5cf3e832a4dce868ca5ff7`. A post-collection check found the retained compiler still matched and the worktree reported the selected revision with no tracked changes; this does not establish full build-time source state. That later check also found SQLite source SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`; included headers were not individually verified. The profile stdout is empty and its stderr SHA-256 is `8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35`. The retained receipt records `BUSTER_9700X_HELD=1`, the lock owner, executable hash and success for the profile process. The build script invoked the shared lock but did not retain a positive build-lock receipt.

The archive contains the collection script, build log, hash and post-collection checks, raw `perf.data`, symbol report, annotated functions, output streams and profile lock receipt. The raw recording includes host, path and process metadata; the executable is not distributed, so reproducing symbolized reports elsewhere can require the exact retained binary and host symbol setup. This is a historical record, not a direction to rerun without checking current source and host policy. The selected compiler is an earlier PR revision, not the later corrected warning-policy head.

From this directory, verify the archived bytes, recorded diagnostics and receipt:

```sh
sha256sum -c SHA256SUMS
mkdir -p /tmp/buster-1453-debug9
tar -xzf raw-evidence.tar.gz -C /tmp/buster-1453-debug9
python3 verify.py /tmp/buster-1453-debug9
```

These checks validate the retained record, not the build-time source or the statistical meaning of a profile. Collection and packaging: OpenAI Codex, model OpenAI / GPT-6, session `01a1b0e0-a314-7252-9c29-d958f2e64d73`, thread `01a1b0e1-01c7-77e3-aac3-5e875d1c15e1`. No shareable session URL was exposed.
