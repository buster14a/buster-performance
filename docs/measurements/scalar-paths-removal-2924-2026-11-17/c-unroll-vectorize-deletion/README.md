# C9d: the unroller's and the loop vectorizer's twins deleted (#2924)

Base `2cb2413d4` is the tests commit, with the twins present; it sits on C9c's head. Head `b7949c8fb` is the deletion.
[`run.sh`](run.sh) ran on the 9700X: Release, every run under the lock, timings on CPU 2. The gate is
[`../c-ir-gate-again/`](../c-ir-gate-again/), under `--tier1-passes=+all`. In every size bin the twin took 1.07 to
1.22 times as long for the loop vectorizer and 1.05 to 1.13 for the unroller.

## Objects

`--tier1` and `--tier1 --tier1-passes=+all` of sqlite3.c, Lua 5.4.8, musl's units and buster's `main.c`: 1,372 of 1,372
objects byte-identical in each mode ([`logs/status.txt`](logs/status.txt)).

## Whole compiles

`ab`, three rounds, around `time-runs` of base, head and base again; `-c --lanes 1`
([`logs/time.log`](logs/time.log)). The figures are user cycles against base.

| Compile | Head | Base again | Instructions, head against base |
| --- | --- | --- | --- |
| sqlite3.c, `--tier1` | −0.55%, −0.46%, −0.43% | −0.04%, +0.07%, +0.02% | 0.005 M fewer |
| Lua's units, `--tier1` | −0.55%, −0.70%, −0.68% | −0.03%, −0.08%, −0.08% | 0.06 M fewer |
| sqlite3.c, `--tier1 --tier1-passes=+all` | −0.14%, −0.24%, −0.25% | −0.02%, −0.11%, −0.03% | 0.54 M fewer (−0.003%) |

Head retires the same instructions, within 0.003%. Yet it reads 0.12 to 0.62 points fewer cycles than base again,
under the default passes too, where neither the unroller nor the vectorizer runs. That is code placement, not the
deletion. `.text.buster_start` is the same size in both, and the two executables have the same function symbols.

## Tests

On head, all 58 lines of [`logs/status.txt`](logs/status.txt) pass:
- the IR, SSA and Tier 1 tests, with `test-ir-unroll` and `test-ir-vectorize` and their frozen digests;
- the source tests on c-testsuite's 220-program subset, with `test-ir-source --passes`'s verification of every
  unrolled and vectorized function;
- `test-call-graph`, `check-call-graph` and the unity ownership check;
- the complete driver's checks of `main.c`.

## Mutants

[`mutation/`](mutation/) holds the runner, the mutants and their logs: 12 mutants of the two passes' vector scans on head,
each run against `test-ir-unroll`, `test-ir-vectorize` and `test-ir-optimize`. All 12 are killed
([`final.results`](mutation/final.results)).
- **The unroller:** the classes' last lane and phi test, the union's last lane and its reduction, and the remap's
  optional operands, last lane and c column.
- **The vectorizer:** the kinds' flags' last lane, the access flags and the stores, and the refusing kinds' scan's bits
  and last lane.
