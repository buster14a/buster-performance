# Reader-produced graph facts: local qualification

This is local Ryzen 9 7940HS evidence, not Ryzen 7 9700X acceptance.
The parent session coordinates locked target measurements separately.

Source baseline: `bc1b486150850fe00bad1361a19f57d67706bb3b`.
Initial candidate: `05b82bfd94234f5d0f8439a3041799007e56fddc`.
Sparse counter follow-up: `7274e1bc` (branch `codex/perf-674-sparse`).
Both candidates build with the ordinary `BUSTER_DEBUG_INFO=0 ./build.sh`
through a two-core grant. No pull request was opened and nothing was pushed.

The source reader retains a purity byte and allocation counters while it builds
postorder nodes, instead of reconstructing them from cold graph columns.
An explicit verification option compares retained facts with the independent
scalar/vector validators; other producers always use those validators. The
follow-up skips exceptional counter loads/stores for ordinary nodes. Retained
assembly confirms the sparse path has no unconditional counter-vector updates.

## Correctness

- `build-final.log`: all 41 units built for `05b82bfd`.
- `checker-final.log`: seed 674, 398,971 checks, four existing local Clang
  fpclassify program-oracle mismatches. All metadata tests pass. This is not
  reported as a full-suite pass.
- `sparse/build.log` and `sparse/checker.log`: the same build and checker result
  for `7274e1bc`.
- Frozen SQLite `--verify -c` succeeds with both schedules for the initial
  candidate and with the vector schedule for the follow-up. Objects match the
  baseline byte for byte: SHA-256
  `fdc07c543a063a24ddf2a4d0928b974d710e2caf6048046e4b1e9a6abf462635`.
- Permanent tests compare both recorded schedules with verified/unverified
  runs on generated graphs, compare both validators to every common source
  fixture (including diagnostic-only prefixes), cover generated operator and
  sideband classes plus guarded columns, and corrupt every retained counter
  and purity byte to require failure and output rollback. Appending nodes
  invalidates the trusted summary and exercises ordinary validation again.

`graph_checks.c` is an original focused ASan/UBSan adapter for those permanent
graph tests. Built against `7274e1bc` with ASan/UBSan, it passes **6,251 checks,
zero failures** with leak detection and halt-on-error enabled
(`sanitizer-build-final.log`, `sanitizer-results.log`). Its failed build logs
are retained separately; failures were adapter linkage/warning setup, not test
failures.

## Local timing screen

The built-in `time-runs` executes whole fresh-process SQLite `-c` operations,
rotating build order, with two warmups and eleven measured runs per build.
All processes exit zero. Corpus and exact flags appear in each raw log. The
`corpus` symlink is a local convenience only and must not be copied into a
published evidence record. Its inputs are the frozen microarchitecture
campaign's SQLite 3.53.2, pinned predefines and frozen headers. SQLite source
SHA-256 is `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.

| Three-way screen | Baseline | Initial | Sparse follow-up |
| --- | ---: | ---: | ---: |
| Wall median, ms | 211.033 | 205.542 | 210.220 |
| User cycles median, M | 805.182 | 802.112 | 806.396 |
| Instructions median | 1,433,871,162 | 1,462,011,794 | 1,453,145,361 |
| Peak RSS median, KiB | 520,500 | 518,288 | 518,600 |

Shared-machine timing spread is broad (about 200–226 ms in this screen).
An earlier two-way screen reversed the initial wall difference: +1.78%,
versus -2.60% here. No timing gain is inferred. Instruction counts establish
that the sparse follow-up removes 8.87 million instructions of the initial
candidate's overhead, while still executing 1.34% more than the baseline.
The target must establish whether eliminating cold reads repays that producer
work at one and eight workers; this local screen does not close that gate.

All new implementation, tests and adapter source are original project material.
Clang and the existing project test generators run as external/build oracles;
no external implementation or fixture corpus is incorporated.
