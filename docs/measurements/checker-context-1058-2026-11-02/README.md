# Checker semantic context and provenance — #1058, 2026-11-02

Source: [buster#1096](https://github.com/buster14a/buster/pull/1096), for
[buster#1058](https://github.com/buster14a/buster/issues/1058).

This is a single-run before/after check on the approved Ryzen 7 9700X. It is
not an interleaved A/B campaign and makes no throughput-improvement claim. The
change moves the checker's shared semantic context into `CheckContext` and
centralizes provenance transfers; the implementation is candidate `8fb93304`
(tree `0d795e28a1b5a1f3b0e8c8f74b014ae164195f6a`) based on main `0ab06fb9`.

## Baseline

The exact-main push run for `0ab06fb9` did not reach Benchpress: the unrelated
native MSan `test-ssa-source` job failed first. The baseline is therefore the
comment-only PR [buster#1133](https://github.com/buster14a/buster/pull/1133)
(`e3a434a7`), which adds only comments in `c_check_actions.c` and
`c_check_clock.c` to `0ab06fb9`. It ran through the same pull-request workflow
on the same 9700X. PR #1133 was closed without merging after the measurement.

## Runs

- Candidate: [workflow run 41446345066](https://github.com/buster14a/buster/actions/runs/41446345066),
  Benchpress job `125288973983`.
- Baseline: [workflow run 41450668841](https://github.com/buster14a/buster/actions/runs/41450668841),
  Benchpress job `125303237780`.

Both jobs built with `BUSTER_DEBUG_INFO=0`, ran the complete correctness suite,
and measured the frozen SQLite source (`preprocessor-391e729af658/sqlite/sqlite3.c`)
with `benchmark-checker-source` and `measure-compile` on CPU 2. The filtered
raw benchmark lines are `pr-8fb93304.txt` and `baseline-0ab06fb9.txt`.

## Results

`benchmark-checker-source` on frozen `sqlite3.c`, ns per body-graph node:

| Path | Baseline `0ab06fb9` | Candidate `8fb93304` | Change |
| --- | ---: | ---: | ---: |
| scalar, all passes | 53.731 | 53.157 | -1.1% |
| vector, all passes | 37.583 | 37.082 | -1.3% |
| level order, all passes | 39.556 | 38.716 | -2.1% |
| vector, isolated | 36.002 | 36.501 | +1.4% |
| vector, after scalar work | 37.191 | 36.916 | -0.7% |
| level order, isolated | 38.225 | 38.717 | +1.3% |
| level order, after scalar work | 38.214 | 38.806 | +1.5% |

`measure-compile`, `sqlite3.c` whole compile, median of 11 runs:

| Metric | Baseline | Candidate | Change |
| --- | ---: | ---: | ---: |
| clock span, ms | 116.621 (116.147–117.365) | 116.859 (116.362–119.486) | +0.2% |
| default wall, ms | 117.803 (117.227–118.207) | 117.992 (117.461–118.626) | +0.16% |
| wait4 peak, KiB | 323,728 | 323,596 | -0.04% |
| minor faults | 5,135 | 5,130 | -0.1% |

The path differences are within the observed run-to-run variation and the
whole-compile ranges overlap. No material checker or whole-compile time or
memory regression is visible in this comparison.

## Limitations

These are two separate processes, not the repository's interleaved `ab` or
`time-runs` A/B method, and each side is one Benchpress job. The baseline is a
comment-only revision of the same main because the exact-main push run was
skipped; comments do not change the built code, but the runs' clock and thermal
states may differ. The compiler's generated-code quality is outside this
measurement. Raw workflow logs are linked above; only the benchmark lines are
retained in this directory.
