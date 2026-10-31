# Metric qualification addendum: Buster #875

This is an **offline qualification of the 2026-10-29 capture**, not a new hardware measurement. It supersedes the interpretation of the archived metric display values, without rewriting raw records, old summaries, binary identities or corpus identities. Collector/exporter changes are in [PR #171](https://github.com/buster14a/buster-performance/pull/171); the acceptance issue is [buster #875](https://github.com/buster14a/buster/issues/875).

## Frozen inputs and reader

The capture is pinned to `278231126048bbf6dbac0cedfc5004aa16b415ae`, under `docs/measurements/microarchitecture-2026-10-29/zen5/current`. The reader requires both exact Git blob identities before granting the historical collector's known `--all-user` scope; a directory name or a stored qualification tag grants nothing.

| Input | Identity |
| --- | --- |
| `measurements.jsonl` Git blob | `d7dd4d4db8248910288b21e298f59c5332b06b4a` |
| `perf-list.json` Git blob | `dd4a83af42ae9a03b31d0f50d3849e8a88367cbe` |
| `measurements.jsonl` SHA-256 | `e4560d235e7ae7d2f621e5a1f39fba7e6157288a44d997a38ddd949c344df373` |
| `perf-list.json` SHA-256 | `3210a1e4652c3e2ba8797d7b229c7685ec88e16bcd0c99be2349d09cabe9298a` |
| `metric_qualification.py` SHA-256 | `b5b769e72fea46b23e61fe7678f71935ebc734df68eeafb14ad0170c4747f4bd` |
| Tested source commit | `12e76904cfcb9143135c7a5d9ada8e58688ae739` |

The capture's compiler source is `586c2ae2e40f117f27330307944a6d64566e0882`, executable SHA-256 `cff83eaeaca04d4c34d444405fa16227a2937a31fdb3d5afb6120a27cee88d42`. Its corpus manifest SHA-256 is `391e729af6587355050881752558e790299cfe638c7dc7803bd028a8535ebcbd`; SQLite input SHA-256 is `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`; predefines SHA-256 is `a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`. The original environment records perf `7.2.9-1` and CPU 2. These identities describe the old measurement, not a newly rebuilt compiler.

## Results

[The per-formula table](historical-qualification.csv) covers all 147 formulas and all three workloads, with the exact source lines in the immutable JSONL file. Its 441 metric records classify as follows:

| Qualification | Records | Usable numeric value? |
| --- | ---: | --- |
| `valid` | 166 | Yes, recomputed from raw operands |
| `genuine-zero` | 24 | Yes, zero numerator with valid prerequisites |
| `rounded-to-zero` | 8 | Yes, nonzero recomputation; the old display remains diagnostic |
| `semantically-invalid` | 96 | No |
| `unsupported` | 75 | No |
| `unavailable` | 3 | No |
| `failed` | 69 | No |
| `underscheduled` | 0 | No |

Thus 198 records qualify; 243 do not. This is not a blanket invalidation of the campaign's counters or profiles.

The 96 semantically invalid records comprise 12 explicit-privilege records and 84 zero-duration records. `lpm_cycles_user`, `lpm_cycles_kernel`, `lpm_cycles_guest` and `lpm_cycles_total` were collected with a blanket user-only override, so their requested privilege domains were not preserved. This rejection is based on scope, **not an equality heuristic**: equal user and kernel counts are legitimate when the effective attributes prove distinct domains. The old 50/50 split and doubled total are unusable.

A positive numerator divided by zero `duration_time` is not a measured zero rate, even when perf's guarded division prints `0.0` and duty is 100%. Neither Python orchestration wall time nor a separate timing run may replace that denominator. Some zero-duration formulas also require system/uncore domains; fixing duration would not make those formulas valid process-core measurements. The table reports the first failing prerequisite, not an exhaustive list of all failures.

The compile branch-misprediction ratio is recovered from `3590833 / 211482428`, approximately `0.0169793443 per_branch`, or `1.69793443%`, instead of the rounded display `0.0`. The other rounded-to-zero recoveries are the two syntax/compile `l2_dtlb_misses_pti` records and all three `l2_itlb_misses_pti` records.

All **39 top-down records** were checked individually: `backend_bound`, `backend_bound_by_cpu`, `backend_bound_by_memory`, `bad_speculation`, `bad_speculation_from_mispredicts`, `bad_speculation_from_pipeline_restarts`, `frontend_bound`, `frontend_bound_by_bandwidth`, `frontend_bound_by_latency`, `retiring`, `retiring_from_fastpath`, `retiring_from_microcode`, and `smt_contention`, each for preprocess/syntax/compile. Their prerequisites qualify: 36 are `valid` and the three SMT-contention results are `genuine-zero`. This supports those retained formulas under the captured user-process scope; it is not a new performance comparison or proof of claims beyond those formulas.

The table's compact reason codes mean: `privilege-override`, explicit domains overridden by the collector; `zero-duration`, nonpositive duration operand; `unsupported-formula`, syntax or formula prerequisites not implemented by this reader; `unsupported-domain`, an operand outside its qualified process-core support; `operand-unavailable`, unavailable raw data; `collector-failed`, nonzero process status. Unsupported is not a claim that the hardware can never measure the event.

## Reproduce without hardware

From this campaign directory, with new destination directories:

```sh
python3 -m unittest discover -s scripts/tests -v
python3 scripts/qualify-metrics.py zen5/current --out /tmp/buster-875-audit
python3 scripts/export.py zen5/current --out /tmp/buster-875-export
```

The audit emits detailed JSONL and CSV qualifications, a separate top-down table, input/reader provenance and an affected-formula review list. Detailed rows retain original line/record hashes, formula and recursive-formula hashes, scope evidence, raw operand strings, runtime/duty and rejection reasons. The exporter exposes `process_status` separately from `eligible`, `qualification` and the recomputed `value`; a rejected result has an empty value. It never admits the rounded `reported_value` as its numeric result. Both commands refuse an existing output directory.

Hosted [CI run 41195496425](https://github.com/buster14a/buster-performance/actions/runs/41195496425) passed **58 tests** and the complete frozen-capture audit, retaining detailed outputs as artifact `metric-qualification-875`. Tests cover exact archived records, legitimate equal privilege counts, unavailable and underscheduled operands, real zeros versus zero denominators, recursive scale handling, unsupported grammar, effective-attribute mismatches, collector failures and the public exporter. The independent C time-control helper was compiled with `-std=c17 -O2 -Wall -Wextra -Werror` and exercised for success, workload failure, missing executable and receipt overwrite refusal. Collector subprocess tests use a fake perf runner; they are not PMU measurements.

## Fresh collection contract

The campaign now plans each formula before launch. Ordinary supported core formulas retain user-process scope; formulas with explicit privilege modifiers retain those domains and do not receive `--all-user`. Unsupported system/uncore formulas are recorded as unsupported rather than silently reinterpreted.

Each accepted fresh metric requires effective attributes extracted by `perf evlist -v` from that invocation's retained `perf stat record` data, together with command, data hash, raw counts, pinned inventory and explicit scope. Descendant inheritance and operand privilege consistency are checked. The historical capture did not retain these effective attributes; its scope evidence is explicitly weaker and limited to the exact pinned collector/input pair.

The evaluator does not execute formula text. It supports a bounded arithmetic/function subset and rejects unknown syntax, conflicting definitions, cycles and unresolved prerequisites. It recomputes with decimal arithmetic, uses unscaled dependent formulas, applies the top-level scale once, and requires supported units, finite nonnegative operands, positive denominators and at least 99% counter duty. Unsupported grammar or units fail closed.

For duration formulas, compile `scripts/metric-time-control.c` and supply `--metric-time-control PATH`. That helper times a separate fresh workload process with `CLOCK_MONOTONIC`, fork to wait. A positive captured duration must be within a factor of two of that independent control. This is a deliberately broad sanity bound, not calibration, and never substitutes for perf's denominator. Missing or zero duration remains invalid.

`campaign.py --metrics-only` requires explicit repeated `--metric NAME` selections and skips the unrelated counter, stage and sampling sweeps. A new output directory is required. The campaign's CPU pinning is **not** the shared-host lock: direct host operation must route each workload invocation, including its separate time control, through the existing `exclusive.sh` per-run wrapper. CI jobs whose runner hooks already hold that lock must not take it recursively.

## Acceptance still outstanding

No locked-9700X recollection was performed for this change. Before closing #875, run only the affected supported formula families and explicit controls on the 9700X, with CPU 2 affinity, the recorded governor/SMT state and shared-host serialization. Retain compiler/source/corpus identities, actual perf/kernel versions, the new formula inventory, effective attributes, data hashes and independent time receipts. Check the privilege split and sum against an independent raw control collected over the same domains; check time-based rates against a positive measured duration and the independent workload-time control. Permission or PMU failures stay unavailable/unsupported, never numeric zero.

The 32-formula `affected-metrics.txt` is a **review list**, not permission to force every entry into process scope. Several entries require separate system/uncore support. The eight rounded display values can already be recovered from archived operands and do not require a broad recollection. New records must live beside this addendum, not replace the original capture. No speedup, fresh hardware success or root cause for the captured zero duration is claimed here.

## Provenance

The additions are original project code extending the existing Python campaign, with the independent control in C, under Apache-2.0 WITH LLVM-exception. Archived fixtures are identified above; synthetic test inventories are explicitly labeled and checked separately from the complete frozen inventory. Linux perf interfaces were consulted for semantics, but no Linux implementation code is incorporated. Human DCO certification has not been fabricated by the agent session.
