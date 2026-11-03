# One request's configuration and source preparation: their cost (#1057), 2026-11-03

Evidence for buster14a/buster#1057's last done-when item: the preparation cost of
buster14a/buster#1141, which made the C driver and the real-source benchmarks
share one request's configuration (`c_check_request.c`) and one source
preparation (`c_check_source_prepare.c`), measured on the locked 9700X.

**In progress:** `scripts/run.sh` is running on the 9700X. Its logs and the
results will be added to this record when it ends.

## Source revisions and trees

- main: `754475d4cc8f27813cf0b2f029fbae0012ab11fe`, the first parent of
  #1141's merge on buster14a/buster `main`.
- head: `4670b2ebf5ca104feb5c902015ad6a2179d8c2e7`, #1141's merge.

Each tree is `git archive` of its commit, sent to the 9700X by tar.
`trees/manifest-*.txt` are the trees' `sha256sum`s made before sending
(`LC_ALL=C` order), which the host's must equal (`logs/receipts.txt`).

## Commands

`scripts/run.sh` builds the trees, each in its own hold of the host's lock,
then holds the lock once for `logs/measure.sh`, which runs, with main's
executable driving `time-runs` (whole processes, the builds interleaved in a
rotating order, one warm-up, `taskset -c 2`):

- a tiny file (`inputs/tiny.c`: one function, no header) by `-c` and by
  `-fsyntax-only`, 41 runs;
- `tools/ci/changes.c` by `-c`, 21 runs;
- the frozen corpus's `sqlite3.c` by `-c` and by `-fsyntax-only`, with its
  pinned predefines and headers as the 9700X workflow passes them, 11 runs;
- `benchmark-backend-source` and `benchmark-lowering-source` over
  `sqlite3.c`, the benchmarks whose preparation #1141 shares, 5 runs each;
- each build's `-c` objects of the three files, compared byte for byte.
