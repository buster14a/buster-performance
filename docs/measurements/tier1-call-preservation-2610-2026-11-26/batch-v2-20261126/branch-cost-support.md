# Unmeasured branch-cost follow-up support

This support archive preserves a focused proposal prepared **after** the
batch-v2 measurements. It is separate from the measured source
`b13983aca01ab5b48c1f3881a761f9e9a4cfb6a4` and the counts in this directory.

The proposal enables actual conditional-pair branch pricing only for the
bit-2048 batch probe with `BUSTER_TIER1_BATCH_BRANCH_COST=1`. Both semantic
successors are priced together because a changed split flag can reverse
branch orientation and change the sibling edge's cost. Copy-only
`edge_gains` continue to serve the transport certificate; an optional
`total_edge_gains` column adds branch changes for the total-instruction
certificate. A null column preserves existing behavior.

The conservative guards refuse changed conditional pairs when either
successor reaches an indirect dispatch through a single-successor chain.
They also refuse SUCCESSOR-presence changes at such targets and
PREDECESSOR-presence changes at such sources. The latter case matters even
without a split change: adding a move before a relay's first jump can
prevent a later incoming jump from being copied/fused by the dispatch pass.

The standalone C harness compiles exact extracted versions of the branch,
inverse, dispatch and path-check functions. It reports **3,718,338 checks,
502,048 interpreted emitted-record paths, 48 old/new split transitions and
zero failures**. It covers branch forms, split/fallthrough combinations,
both semantic outcomes, sibling weights, dispatch relays, predecessor
prefix insertion/removal, bounded refusal and independent certificate
columns. The modified score file also passes the retained syntax-only
check, and the patch applies cleanly to its captured originals.

These are focused mapping and refusal checks. They are not a full compiler
qualification or a dynamic workload measurement. The parent subsequently
integrated the proposal into a separate candidate; that candidate's evolving
source and results are outside this support snapshot.

`branch-cost-support.tar.gz` contains `support/` with original and proposed
source snapshots, the patch, exact emitter excerpts, C harness, validation
receipt, branch-count table, source-file digests, license and its own README.
It omits the harness executable.

```sh
sha256sum -c branch-cost-support.sha256
tar -xzf branch-cost-support.tar.gz
cd support
sha256sum -c SHA256SUMS
```

Patch SHA256:
`5e40a74262e8492e7242ef5f8449e25cc358afe35fdf39792e8488f5262e53cb`.

Guarded branch helper SHA256:
`46693b09a8a0a0331d87e24662651629edf89d0fd50496bb4270d09fcc638014`.

The measured batch-v2 candidate contains neither this helper nor these
broader dispatch guards. The support archive must not be substituted for
the measured compiler's source identity.

Agent session: 6b086a82-e9b8-83eb-aad4-587684d3a052 (OpenAI session ID; no share URL is exposed)  
Model: OpenAI / GPT-6 Astra Pro
