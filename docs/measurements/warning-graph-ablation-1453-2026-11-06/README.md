# Common graph-warning pass ablation (#1453)

This diagnostic experiment investigates the remaining one-workload difference in [buster PR #1453](https://github.com/buster14a/buster/pull/1453), following its [exact-head comparison](https://github.com/buster14a/buster-performance/pull/293). It deliberately disables the common graph-warning emission pass in some runs. The disposable variants are not compiler fixes, and these results are not correctness, CI or performance acceptance. Turning off the pass suppresses diagnostics in general even though the tested SQLite output matched.

Two instrumented commits wrap only the existing `check_common_graph_warnings` call in an environment-variable condition: `f27da3b46d0ce7018411e2f81a347e1003e187c9` on main `ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b`, and `17e0d64b2f2eaa6e7a6e020d1bc89a7ce88709f4` on PR head `ef2384afa7ed23d9b646ae930274b4e512967e23`. In **on** runs the variable is absent and the pass executes; in **off** runs `BUSTER_1453_ABLATE_GRAPH=1` skips it. Graph facts and other warning passes still execute. The same instrumented executable is used on and off for each side. This source edit can also change compilation and layout, so the result does not prove an exact causal share of the normal-build difference.

The script requests separate locked Release builds (`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`) and eight individually locked samples on Benchpress (Ryzen 7 9700X, Linux 6.18.50-2-lts). Build and sample receipts record `BUSTER_9700X_HELD=1`, matching owner snapshots, successful exit and compiler hashes; samples also record output hashes. Each run uses CPU 2 and SQLite `-fsyntax-only` with the archived script's flags. The order reverses in round two. Both counters report 100% running.

| Round | Side | Pass | Instructions | Cycles |
| --- | --- | --- | ---: | ---: |
| 1 | main | on | 1,362,560,063 | 574,710,099 |
| 1 | main | off | 1,335,568,142 | 556,487,016 |
| 1 | PR | on | 1,389,396,137 | 584,732,911 |
| 1 | PR | off | 1,342,333,128 | 559,073,308 |
| 2 | main | on | 1,362,560,060 | 573,518,012 |
| 2 | main | off | 1,335,568,143 | 556,896,223 |
| 2 | PR | on | 1,389,396,153 | 580,626,064 |
| 2 | PR | off | 1,342,333,135 | 556,426,007 |

On-minus-off is 26,991,921 / 26,991,917 instructions for the instrumented main and 47,063,009 / 47,063,018 for the instrumented PR. The resulting differences of differences are 20,071,088 and 20,071,101. This points to the graph-warning pass as a substantial area to investigate in this workload; two rounds and modified binaries do not establish a corpus-wide effect or exact attribution. All stdout streams are empty and all stderr streams have SHA-256 `8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35`.

The recorded instrumented compiler hashes are `7297fcb30ebb5dba02260b679cc099a203a795571d55b5cfbd169366ec35f007` (main) and `c0715a9d80d3efdffdb6e6e294ff0a67afbc8268726e345ad93137482cdf79a8` (PR). Post-collection checks found clean tracked worktrees at the instrumented revisions and matching binaries, and SQLite source SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. These checks do not independently establish build-time source/input state, and included headers were not individually verified. Source bundles and patches are retained; the instrumented source trees are `2f17e22aaa39894222e7e5c127abc38843fe47e0` and `470c08988976f5ed9ebfad33206471634f74c713`.

The archive contains scripts, instrumented patches/bundles, build logs and receipts, post-collection checks and eight counter/output records and receipts. The script is a historical record, not a direction to rerun without checking current source and host policy. Verify preserved bytes and reported rows:

```sh
sha256sum -c SHA256SUMS
mkdir -p /tmp/buster-1453-graph-ablation
tar -xzf raw-evidence.tar.gz -C /tmp/buster-1453-graph-ablation
python3 verify.py /tmp/buster-1453-graph-ablation
```

These checks validate preserved bytes and receipt contents, not build-time provenance or general performance. Collection and packaging: OpenAI Codex, model OpenAI / GPT-6, session `01a1b0e0-a314-7252-9c29-d958f2e64d73`, thread `01a1b0e1-01c7-77e3-aac3-5e875d1c15e1`. No shareable session URL was exposed.
