# PR #1453 lazy warning-boundary exploratory comparison

This record compares the [PR #1453](https://github.com/buster14a/buster/pull/1453) published parent `ef2384afa7ed23d9b646ae930274b4e512967e23` with the local, unmerged candidate `72bebdfb0d7e4a1fb5122173b0a97211dc0be80b`. Its patch defers and caches warning-boundary lookups. This is an exploratory comparison with that PR parent, not against current main. It does not establish full-corpus performance, compiler correctness, CI qualification or merge readiness. The selected source revisions may become stale.

Collection used Release `znver5` builds with `BUSTER_DEBUG_INFO=0` on Benchpress (Ryzen 7 9700X, Linux 6.18.50-2-lts, Clang 23.1.1 as reported in build logs). The first script separately invoked `exclusive.sh` for the candidate build and each SQLite run, using the previously built parent from the [ec5 integration record](https://github.com/buster14a/buster-performance/pull/293); the second script separately invoked it for every synthetic-input run. Per-run receipts record `BUSTER_9700X_HELD=1`, matching owner snapshots, compiler hash, successful status, output hashes and synthetic fixture hash when applicable. The scripts contain the exact commands, and all counter rows report 100% running. The build logs have three lines of other sessions' lock-holder details redacted; no positive build-lock receipts survive, so build locking is not established by this archive. The collector reported building under the shared lock. Samples were separated by substantial host contention, rather than closely spaced pairs.

### SQLite syntax-only

| Pair | Parent instructions | Candidate instructions | Parent cycles | Candidate cycles |
| --- | ---: | ---: | ---: | ---: |
| 1 | 1,390,263,595 | 1,384,332,706 | 583,792,646 | 580,114,439 |
| 2 | 1,390,263,599 | 1,384,332,720 | 581,806,477 | 582,544,914 |
| 3 | 1,390,263,592 | 1,384,332,710 | 583,725,772 | 580,330,365 |

Medians: 1,390,263,595 versus 1,384,332,710 instructions (-0.427%), and 583,725,772 versus 580,330,365 cycles (-0.582%).

### Warning-dense synthetic input

| Pair | Parent instructions | Candidate instructions | Parent cycles | Candidate cycles |
| --- | ---: | ---: | ---: | ---: |
| 1 | 52,538,351 | 52,564,212 | 14,528,520 | 14,862,639 |
| 2 | 52,538,351 | 52,564,209 | 14,885,660 | 14,751,215 |
| 3 | 52,538,356 | 52,564,211 | 14,376,036 | 15,321,276 |

Medians: 52,538,351 versus 52,564,211 instructions (+0.049%), and 14,528,520 versus 14,862,639 cycles (+2.300%).


The SQLite record is one syntax-only workload; its empty stdout and stderr SHA-256 `8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35` match in all six runs. The synthetic fixture has SHA-256 `ccaae3bf73193177837b7f75623eddc228e01feb822027d0672d810929d3de46` and produces 2,048 warnings per run; its empty stdout and stderr SHA-256 `82d0e34518d4e92fd9411dca74eb5edbc58bfd728174099132047f1ca44fe929` match in all six runs. Three pairs per workload do not establish a general performance result or a causal attribution.

The post-collection checks identify parent and candidate tracked worktrees, their compiler SHA-256 values (`2d80a3e01650bdc3218facdbb5870b96ad5929c74b9d91b5ff37e1563d838ab9` and `a562fe9adedfcc5147a8eee5235ea0de4b1e7192a47901b15f859282bc88624f` respectively), synthetic fixture, and SQLite source SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. They do not independently prove source, binaries or SQLite input state at build time; included SQLite headers were not individually verified. The candidate bundle requires its recorded parent. At packaging time its head was listed and the patch applied to that parent reconstructed the candidate tree; see `source-reconstruction.txt`.

The archive contains the scripts, sanitized build logs, hash records, synthetic fixture, bundle and patch, post-collection checks, and all twelve counter/output/receipt records. Scripts are historical records, not directions to rerun without checking current source and host policy. Verify archived bytes and reported rows:

```sh
sha256sum -c SHA256SUMS
mkdir -p /tmp/buster-1453-lazy-boundary
tar -xzf raw-evidence.tar.gz -C /tmp/buster-1453-lazy-boundary
python3 verify.py /tmp/buster-1453-lazy-boundary
```

These checks verify preserved bytes and receipt content, not build-time provenance or broad performance acceptance. Collection: OpenAI Codex, model OpenAI / GPT-6, session `01a1b0e0-a314-7252-9c29-d958f2e64d73`, thread `01a1b0e1-01c7-77e3-aac3-5e875d1c15e1`. Packaging: same session and model, thread `01a1b273-feda-7773-8285-9aa3896e852f`. No shareable session URL was exposed.
