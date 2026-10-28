# #664: bounded register-home selection, 9700X qualification

Source baseline is `bc1b486150850fe00bad1361a19f57d67706bb3b`; candidate is
`be441ff8786d47f56cc2d6e05bb416e8091d1bdc`. Both ordinary release builds use
Clang 23.1.1, `BUSTER_DEBUG_INFO=0`, on Ryzen 7 9700X / Linux 6.18.50-2-lts.
Native executable SHA-256 values are respectively
`d4420d3786771dc3f9b851b6931bc8d8cdb7d01959b3213f4927821847fe871d` and
`22d0f3fe9dd320e617106363c96362c3e870ab5f122feaeaa3c2a02721317ad2`.
All builds, tests and measurements use the shared target lock. Measurements
are pinned to physical CPU 2. No machine settings were changed.

## Work removed

The former insertion sort ordered every local. The candidate retains each
register kind's stable prefix of at most 16 eligible locals. Its work is
bounded per input local and its order scratch is 32 u32 values. The existing
vector rank path for at most 64 locals remains unchanged. Independent full
ordering, complete home/save-mask, protected-page and tie-mutation checks are
described in `../README.md`.

## Native correctness

`664-native-checks.log` records five baseline/candidate byte-identical object
pairs and 1,285 independently expected runtime cases, all successful. Inputs
are popcount 4k/8k, overflow 2k/4k and expect 8k. The individual native Tier 0
suite passes **95,965 checks, zero failures**, including external Clang and
mixed-record native oracles. Local ASan/UBSan passes 5,342 home checks; the
permanent tie-order mutation fails 988 of them.

All 42 ordinary SQLite control objects have SHA-256
`cb578161715c2ecf83659069957077739447d8eccb7be54953faeb30990d9755`.
Object files, statuses and per-child resource observations are retained in
`results/`; `object-identities.sha256` is independently regenerated locally.

## Scaling and end-to-end process time

Each `measure-compile` invocation rotates ordinary, instrumented and reference
processes. Popcount uses 11 measured runs after two warmups; overflow/expect
use seven after two. Each compiler is measured once in each role, with zero
failures and instrumented/default object equality throughout. Stage-clock and
whole-process medians below are separate observations, not additive terms.

| Input | Tier 0 baseline → candidate, ms | Ordinary whole compile baseline → candidate, ms |
| --- | ---: | ---: |
| popcount 4k | 13.267 → 2.052 | 22.754 → 11.635 |
| popcount 8k | 49.633 → 4.081 | 67.070 → 21.378 |
| overflow 2k | 27.246 → 0.924 | 36.488 → 10.394 |
| overflow 4k | 106.532 → 1.784 | 123.601 → 19.237 |
| expect 8k | 8.007 → 0.675 | 23.553 → 16.229 |

Doubling popcount grows baseline Tier 0 time 3.74× and candidate 1.99×;
overflow grows 3.91× and 1.93×. Raw reverse-role results and ranges remain in
the `664-*.log` files. These large-input results support the complexity fix;
they do not establish general compiler throughput improvements.

## Ordinary-input controls and costs

SQLite uses the frozen campaign headers/predefines and exact flags recorded
in the campaign method. Twenty-one rotated pairs of fresh one-task processes
give baseline **143.915 ms** and candidate **144.111 ms** (+0.136%). All 42
processes succeed; one candidate major fault is retained. Median peak RSS is
517,116 / 517,044 KiB. No A/A or placement campaign was run for this control,
so it establishes neither a small gain nor a material regression.

`benchmark-backend --seed 664` validates both paths on 2,024 functions /
262,817 typed entries. Vector baseline/candidate ns per entry are
14.64 / 14.73 in the plain paired benchmark, 14.39 / 14.37 in isolated mode,
and 14.71 / 14.67 after 200 ms scalar work. Instructions per entry are
171.79 / 171.52. These single-image controls are near-neutral observations.
The scalar twin costs **42.12 → 43.55 ns/entry** and **572.12 → 581.24
instructions/entry** in the plain run; this cost is retained explicitly.
It must not be converted into a claim that the production vector path became
faster relative to an unchanged scalar reference.

## Reproduction and retained artifacts

`../generate_builtin.c`, `../run_builtin.c` and `../target-checks.sh` are
original project helpers. The source/input/executable identities are in
`664-target-identities.log`; all commands and queue receipts are retained.
The original `samples.c` and `cohort.c` method controls rotate role order,
pin each child, retain status and resource metrics, and write real objects.

`../target-all-raw.tar.gz` retains the native objects/programs and complete
SQLite control output tree. Its SHA-256 is
`6b6d3bba215333c10861315ad9f388d213dae4559af40dad1ea6d7248fdb8101`.
Timing/build logs are stored separately alongside this report. The archive
was compressed after these measurements, from 12:27:37.850 to 12:27:40.604 UTC.
Compression accidentally ran outside the shared lock; its overlap with
another issue's cohort was reported to that owner, retained, and replaced by
a complete clean balanced pass. This interval overlaps none of #664's samples.

This qualification describes the frozen individual revision. Later merged
main and the private #678 compatibility combination require their own checks.
No PR or remote branch was created.
