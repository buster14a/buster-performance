# Hosted toolchain inputs: preparation, cache, GHCR mirror and outage drill

This record supports [Buster #1767](https://github.com/buster14a/buster/issues/1767)
and [#1768](https://github.com/buster14a/buster/issues/1768). The changes it
measures merged in [#1771](https://github.com/buster14a/buster/pull/1771) and
[#1775](https://github.com/buster14a/buster/pull/1775); the outage drill is
[#1782](https://github.com/buster14a/buster/pull/1782). It records GitHub-hosted
`ubuntu-26.04` runs only. Nothing here was timed on the 9700X, and no timing
here is a compiler performance result.

**Result.** A warm full `main` run makes **no** upstream release requests where
it used to make 306 (about 64.9 GB). A cold run makes six, from the GHCR mirror.
The real outage drill passed: upstream down was served wholly by the mirror;
mirror down fell back to upstream; both down failed in 263 s with nothing
published. Mirror and upstream installed byte-identical trees (27,998 entries).
**Per-shard setup did not get faster.** It is 5.3 s slower on average, and the
preparation job adds about 30 s of serial setup before the matrix.

## Identities

| Item | Identity |
| --- | --- |
| Lock (inputs) | [`tools/ci/hosted-tools.lock`](https://github.com/buster14a/buster/blob/ebef7ed12b8ddd9fce74fe7c9c5dddbf652fc0f9/tools/ci/hosted-tools.lock) at `ebef7ed1` |
| Inputs | LLVM 23.1.4 (`efdd1dbd…0378`), its license (`8d85c105…afee`), CMake 4.4.3 (`d6c83076…c6cc`), Ninja 1.13.2 (`5749cbc4…ead6`), mold 3.0.0 (`6c90d4a4…1189`), wild 0.10.0 (`64126550…5283`) |
| Total input bytes | 1,272,239,012 |
| GHCR manifest | `ghcr.io/buster14a/buster-hosted-inputs@sha256:01ad04c2ec4def5a0ec9260c716d549e19f8959a1042fa13a139e6d9c9624fb9`, tag `inputs-4444af0bee44de2d`, public |
| Actions cache entry | key `hosted-inputs-v1-linux-x64-e037a8b3…55be0`, 1,267,306,782 B |
| Run artifact | `hosted-inputs-<run>-<attempt>`, 1,272,239,654 B, uncompressed, 7-day retention |

## Runs

| Label | Run | Revision | What it shows |
| --- | --- | --- | --- |
| `before-main` | [42464024977](https://github.com/buster14a/buster/actions/runs/42464024977) | `main` before #1771 | Every one of the 51 test/fuzz jobs downloads all six inputs |
| `pr1771-cold-upstream` | [42474109764](https://github.com/buster14a/buster/actions/runs/42474109764) | #1771 head `e0c0e57f` | Cold preparation from upstream, mirror unpublished; 8 plain shards |
| `pr1775-cold-mirror` | [42477267582](https://github.com/buster14a/buster/actions/runs/42477267582) | #1775 head `ac33a214` | Cold preparation from the pinned mirror; 8 plain shards |
| `after-main-warm` | [42481324960](https://github.com/buster14a/buster/actions/runs/42481324960) | `main` `95fb03f0` | Warm cache in preparation and in all 51 jobs (sanitizer, O1 and fuzz rows included) |
| publisher | [42476815746](https://github.com/buster14a/buster/actions/runs/42476815746), [42480834192](https://github.com/buster14a/buster/actions/runs/42480834192) | `main` | First publication (private: anonymous read denied, 401), then a republish after the pin: no upload, same digest, public |
| drill | [42485326882](https://github.com/buster14a/buster/actions/runs/42485326882) | #1782 head `62003df1` | Real outage rehearsal, no Actions cache |

## Upstream traffic

| Run | Upstream release requests | Upstream bytes |
| --- | --- | --- |
| Before, full `main` (51 jobs × 6 inputs) | 306 | ≈ 64.9 GB |
| After, warm (any run that restores the cache) | 0 | 0 |
| After, cold, mirror pinned | 0 (6 GHCR blob reads) | 0 (1.27 GB from GHCR) |
| After, cold, mirror unavailable | 6 | 1.27 GB |

A cold run's six reads happen once, in the preparation job. Shards then read the
cache or the run artifact. Apt, corpus and checkout traffic are unchanged and
not counted.

## Setup time

These are per-step wall times from the Actions API, in [`step-seconds.tsv`](step-seconds.tsv).
"Shard setup" is the sum of a test/fuzz job's restore and install steps. Before
#1771 that was a single step that downloaded and installed.

| Run | Jobs | Shard setup, mean (s) | Shard setup, total (s) | Preparation job steps (s) |
| --- | --- | --- | --- | --- |
| `before-main` | 51 | 34.5 | 1,758 | — |
| `after-main-warm` | 51 | 39.8 (restore 12.4 + install 27.4) | 2,028 | 19 (restore 8, verify 3, artifact 8) |
| `pr1771-cold-upstream` | 8 | 76.4 | 611 | 158 (acquire 147, artifact 11) |
| `pr1775-cold-mirror` | 8 | 55.2 | 442 | 13 (acquire 5, artifact 7) |

The `after-main-warm` preparation job ran for 29 s from start to finish. PR shards
restore through the run artifact unless a `main` cache entry with the same key
already exists, which is why the two PR rows are slower than the warm `main` row.
The cold upstream acquisition took 147 s, but LLVM's 1.19 GB took only 3.9 s.
Almost all the rest was four Ninja attempts that stalled for 30 s each before
curl's stall limit retried them. A cold acquisition from the mirror took 5 s for
all six inputs.

## Outage drill

[`hosted-inputs-drill.yml`](https://github.com/buster14a/buster/blob/62003df1/.github/workflows/hosted-inputs-drill.yml)
maps the hosts of a source to the loopback address in `/etc/hosts` and confirms
they refuse connections before preparing, with no Actions cache.

| Down | Outcome | Preparation step | Job logs |
| --- | --- | --- | --- |
| upstream | all six inputs `source=mirror verified=true`, no upstream request | 37 s | [`logs/job-128745824997.log`](logs/job-128745824997.log) |
| mirror | `reason=transport stage=token`, then all six from upstream | 15 s | [`logs/job-128745824976.log`](logs/job-128745824976.log) |
| both | exit 1 at `llvm`, nothing published | 263 s (bound 420 s) | [`logs/job-128745824809.log`](logs/job-128745824809.log) |

Both successful rows installed the tree, then compiled and linked a probe with
lld and with mold, and ran wild, CMake and Ninja. The final job
([`logs/job-128746974796.log`](logs/job-128746974796.log)) found the two
inventories identical. [`installed-tree-inventory.txt`](installed-tree-inventory.txt)
is that inventory: type, mode, path and link target of each of the 27,998
entries, then the SHA-256 of every regular file. It names the upstream files
but contains none of them.

Most of the 263 s with both sources down is the upstream download's retry
budget (`--retry-max-time 240`) for the first input. The mirror's three token
retries add a few seconds.

## Other logs

- [`logs/job-128711996785.log`](logs/job-128711996785.log): #1771 cold preparation from upstream.
- [`logs/job-128721783395.log`](logs/job-128721783395.log): #1775 cold preparation from the mirror.
- [`logs/job-128733767009.log`](logs/job-128733767009.log): warm `main` preparation (cache hit, verified).
- [`logs/job-128733885402.log`](logs/job-128733885402.log): warm `main` UBSan shard 1. It restores from the cache, skips the artifact download, extracts and probes in 15 s, and passes.
- [`logs/job-128679344091.log`](logs/job-128679344091.log): `before-main` UBSan shard 1, downloading per shard.
- [`logs/job-128719905722.log`](logs/job-128719905722.log), [`logs/job-128732185662.log`](logs/job-128732185662.log): the publisher's first run (anonymous read 401) and its no-op republish.

## Method

```sh
# Per-step seconds for a run's test, fuzz and preparation jobs ($label as in step-seconds.tsv):
gh api "repos/buster14a/buster/actions/runs/$run/jobs?per_page=100" --jq ".jobs[]|select(.name|test(\"Tests on Ubuntu|libFuzzer|prepare\"))|. as \$j|.steps[]|select(.name|test(\"^Restore verified hosted|^Install official Clang|^Restore pinned|^Acquire missing|^Publish this attempt\"))|[\"$label\",(\$j.id|tostring),\$j.name,.name,.conclusion,(((.completed_at|fromdate)-(.started_at|fromdate))|tostring)]|@tsv"
# A job's log:
gh api "repos/buster14a/buster/actions/jobs/$job/logs"
```

The Actions API gives step times at one-second resolution, from shared hosted
runners. These are one run per configuration, not repeated samples. Treat a
difference of a few seconds as noise. The 64.9 GB figure is 51 × 1,272,239,012 B.
[`MANIFEST.sha256`](MANIFEST.sha256) lists this directory's files.

## Limitations

- Setup latency is not improved. A follow-up could trade the 1.2 GB per-shard
  restore for the reduced bundle #1768 originally proposed, but only after
  measuring that it pays.
- The drill takes a source down by blocking DNS names. It does not simulate
  slow or truncated transfers; the network-free fixtures cover those.
- A GitHub-wide outage still fails setup. The mirror is a separate service
  path, not an independent failure domain.
