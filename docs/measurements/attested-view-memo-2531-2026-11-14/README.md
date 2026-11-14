# Attested declarations: step 3's view and step 4's memo across processes (2026-11-14)

[buster#2531](https://github.com/buster14a/buster/issues/2531)'s step 3 (a unit that skips is read as its view, its
parse without the skipped declarations' tokens) and step 4 (`--attested-memo`, a memo kept across processes), on the
9700X. **In progress:** the scripts and the local checks are here; the 9700X's results are added as their queue
finishes.

- `scripts/`: `run.sh`, `run2.sh` (census and profiles), `run4.sh` (step 4), `queue1.sh`, `queue2.sh` (the order the
  9700X ran them, each line one hold of the lock through `bp.sh`), `build.sh`, `stats.py` (medians of `perf stat`),
  `probe.patch` (the measurement-only probe tree's change), and the cloud VM's `common.sh`, `compare.sh`, `matrix.sh`,
  `ppu.sh`.
- `local/`: the cloud VM's comparisons of every object and diagnostic (`matrix1.txt`) and its test runs (`tests1.txt`).
