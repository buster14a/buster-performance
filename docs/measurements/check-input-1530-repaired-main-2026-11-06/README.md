# PR 1530: repaired-main measurements, 2026-11-06

This record compares the compiler at selected main commit `ee089fe78414054d04e5350c48a783e9e2f05af8` with a local integration of PR [buster#1530](https://github.com/buster14a/buster/pull/1530) head `e94fd0d2bcada50d237ac14206a32cf2b68dc1ff`. The integration tree was `507b80b88c6556df8c653302ab891684dba739d9`; an independent `git merge-tree --write-tree` of those commits reproduced that tree. The collector also checked after collection that the base worktree was clean at the base commit and the integrated worktree had that base as HEAD, the stated staged tree, and no unstaged tracked changes. This is post-run source-state evidence, not independent proof of the state when the binaries were built. The recorded refs matched those commits after collection. This record does not qualify a different head or base, establish current CI status, or substitute for correctness review.

On Benchpress (AMD Ryzen 7 9700X, Linux 6.18.50-2-lts), Clang 23.1.1 built both release compilers with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`. Their recorded SHA-256 values were `5c07df7932e9579424c4827ef6e129317f8d8d29fe5a00750414faa149a5bc04` (base) and `e2d965254d9e7ad4e05e6e04f56606c5646c0cefea92bf2d7660af9b8bc737cd` (integrated); the post-run check passed for both. Each build and each sample acquired the shared machine lock separately. All 38 sample statuses passed: 11 alternating pairs of SQLite stage measurements, five alternating pairs of SQLite performance counters, and three alternating pairs of syntax-only measurements of preprocessed compiler `main.c`. Samples used CPU 2 and one compiler lane. The governor was recorded as `performance` once before the samples, not continuously.

| Workload and metric | Base median (range), ms | Integrated median (range), ms | Samples per build |
| --- | ---: | ---: | ---: |
| SQLite check-input | 59.381 (59.070–59.865) | 50.506 (50.292–50.641) | 11 |
| SQLite total stages | 138.999 (138.510–139.469) | 130.171 (129.816–130.466) | 11 |
| Preprocessed main.c check-input | 1186.918 (1186.097–1248.194) | 1119.088 (1114.972–1125.394) | 3 |
| Preprocessed main.c total stages | 1964.825 (1954.405–2034.112) | 1885.837 (1883.078–1893.854) | 3 |

SQLite check-input and total stage differences of medians were respectively −8.875 ms and −8.828 ms. These are differences of independently summarized medians, not medians of paired differences. The `total` metric is the compiler's internal `--time-stages` total, not whole-process wall time. In the five separate SQLite `perf stat` runs per build, mean user instructions were 1,636,851,094.8 versus 1,393,114,466.6 and mean task-clock was 138.546 versus 130.112 ms; each retained event reports 100% running. These means are not derived from the 11 stage samples. All 32 uniquely named SQLite objects had the same recorded SHA-256 `61eb96dd33188557f23a27c24dcf347a8b704d8f8ec15c3656c4e447de3856f2`. No objects are retained here for a byte-by-byte comparison. After excluding timing telemetry lines beginning `time-stage`, `time-check`, `time-process`, or `lowering-nodes`, diagnostic streams match between variants for each workload, including warning/error/note lines and diagnostic summaries.

This is one host, two inputs, and one binary placement per build, with alternating but not randomized order; the three syntax-only pairs do not characterize a source-dependent compiler build. No statistical uncertainty or general speedup is established. The SQLite input, preprocessed input, two predefines files, and workload script had identical recorded hashes before and after collection; every included header was not separately hashed. The original command and workload scripts, statuses, owner receipts, counters, stage output, build logs, hashes and host snapshot are included in `raw-evidence.tar.gz`. In the two waiting sample lock logs and two build logs, only unrelated lock-holder descriptions were replaced with an omission marker. The collector retains the unredacted originals on Benchpress and locally. The scripts document the historical collection environment and should be reviewed and adapted before any new run.

To verify the retained evidence and regenerate the table (Python 3 and standard Unix tools):

```sh
sha256sum -c SHA256SUMS
mkdir -p /tmp/buster-1530-evidence
tar -xzf raw-evidence.tar.gz -C /tmp/buster-1530-evidence
python3 summarize.py /tmp/buster-1530-evidence > /tmp/buster-1530-summary.tsv
cmp summary.tsv /tmp/buster-1530-summary.tsv
```

The verifier checks identities and sample ordering, successful statuses and own lock receipts, input and binary records, output hashes, normalized diagnostic hashes, counter coverage, and all statistics. It validates retained receipts; it cannot independently establish machine isolation or reconstruct build-time source state.

Collection: OpenAI Codex, model OpenAI GPT-6, session `01a1b0e0-a314-7252-9c29-d958f2e64d73`, thread `01a1b0e0-d979-7e63-94ff-ff91f3213a51`. Audit and packaging: OpenAI Codex, model OpenAI GPT-6, same session, thread `01a1b0e1-da73-7731-9bcf-4312e3561034`. No shareable session URL was exposed.
