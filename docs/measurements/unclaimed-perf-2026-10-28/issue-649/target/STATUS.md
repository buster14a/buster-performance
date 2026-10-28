# Target QA state

Root authorized diagnostics_636 agent to run target QA for #636 and #649 only.
Remote root: `~/buster-fast-bench/unclaimed-perf-20261028`. Every build/test/
benchmark/capture uses `exclusive.sh`, with EXCLUSIVE_OWNER/TITLE/LINK and CPU2
for timings. Do not change host settings. No PR, push or GitHub comments.

- Base bc1b4861 binary SHA d4420d3786771dc3f9b851b6931bc8d8cdb7d01959b3213f4927821847fe871d.
- #636 frozen source 60ff4b25 binary SHA 4a1b45dba932f9273f7227c055d87ef2d398a986e5e65348865a6bd86f369687.
- #649 frozen source 123d22ae binary SHA 3b375bfeb0547b11a63803c4749f3ad5e580925e1a3804e7037f98cf588aadb2.
- #649 full native test-preprocessor --clang passes, including 325 prefix
  batches, protected tails, rollover, both marker modes and 3,000 fuzz cases.
- #636 tiny startup: 61 paired samples each of A/B, A/A and reversed B/A.
  Base/candidate 1.390134/1.388250 ms; A/A role0/1 1.394552/1.398389 ms;
  reversed candidate/base 1.393649/1.396234 ms. No regression; no code followup.
- #636 all six 21-pair diagnostic timing cohorts completed, all statuses0.
  Local target JSON and per-case summary JSON exist in evidence-636/target.
- #649 whole SQLite -E-P: 21 paired samples each role, all42 pass,
  15.799383→14.623850 ms. Full frozen base/main.c using host headers:
  85.306138→78.067190 ms. All42 outputs per input are byte-identical;
  byte-oracle.log downloaded locally. Main output SHA d97203fa0cdc8abab405d739f5f671a7b2092d37b69509eeabf031154a22f776.
- Failed pinned-header main trials (main-base-0.log, whole-main-ab/) hit missing
  linux/audit.h in the SQLite-only header capsule. Retain/exclude these failures.
  Valid main-host-* and whole-main-host-ab/ read one frozen base/src tree and
  identical native header paths. Predefines stay pinned.

All target work is complete. 29864 capture matrix completed0, all12 captures
and their byte comparisons pass. 1140 raw #636 collection completed0. 6864 tcc orientation, 27076 main printer repeat, 99420 diagnostic
oracle/header identities and 33008 #649 raw collection all completed0.
85636 SQLite printer3pairs, 61874 diagnostic timings, 84261 output oracle,
34965 tiny controls and 28549 whole-main also completed0. Do not poll completed
sessions. The valid #649 target report is now README.md in this folder.

#649 complete raw archive is ../target-all-raw.tar.gz, 163 MiB, SHA-256
461235a57e503b52ad3456011af09c8a962b6790aac2945224b71f38d0919c12.
All data, including large preprocessed outputs, remain in that checked archive;
logs/metrics/identities are also extracted locally. No outputs were discarded.

#636 report, syscalls.tsv, parsed timings and all raw files are now local in
work/evidence-636/target. Its ../target-all-raw.tar.gz is 874 KiB, checked,
SHA-256 5d67c11a8b61fcfbb0b65b3e8a1c289c3bd6736adbedddbfae8655e37dcfeb19.
No further remote work or source edits are pending. Remote data
in evidence-636/target and evidence-649/target. Do not stop remote loops or alter
frozen sources while queued/running. CI jobs repeatedly hold the shared host.
