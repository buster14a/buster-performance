# Exact coverage for distant operands in the step 0 sweeps

The experimental path recovers all six previously missed musl expressions. It now emits **154,132** exact entries across the same **115,610 nodes** as the scalar twin, including the 2,080 entries from those six expressions. SQLite still emits all **346,998** entries for its **257,465** taken nodes. The branch-miss budget holds in both temperature conditions. The cold cycle budget remains open.

| Full-coverage candidate | Taken share | Cycles/taken node, repeated | Cycles/taken node, after scalar | Branch misses/node, repeated / after scalar |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 96.53% | 16.35 | 22.05 | 0.025 / 0.026 |
| musl | 88.19% | 21.50 | 22.05 | 0.051 / 0.0615 |

Each cell is the median of three separate round means on the locked Ryzen 7 9700X CPU 2. Each round uses two processes per mode in symmetric order, with seven passes per process. The after-scalar series runs the complete scalar twin for 200 ms before each pass. Cold SQLite improved by a paired median of 1.70 cycles/taken node against the contemporaneous original byte-column harness, and cold musl improved by 0.45. The musl denominator increased by 852 nodes. The issue budget is at most 20 cycles/taken node and 0.2 branch misses/taken node. These are stand-alone middle-pass measurements. The ordinary compiler's front end, leaf fact production and object emission are outside these timings.

## How the expressions are recovered

The harness identifies structural operand distances over 64 while constructing the same front-end byte columns used in the original experiment. Eight musl roots and zero SQLite roots have such an edge. At emission it recomputes T, C and the template for each distant root from the scalar rules and emits it in its original position. All of that replay is timed. Six of the eight musl roots pass all the scalar rules. The other two remain refused. Admission uses the distance, the lookups and their miss bits. During a separate verification pass, the rebuilt scalar working columns and emitted stream are poisoned before writing, including the distant expressions' working facts, codes, contexts, targets and chosen templates. Every emitted kind, class and value matches the frozen oracle. Table construction and identifying distant roots are outside the interval, as is the original harness's preparation of its distance columns.

The other change is a vector template lookup. An exact displacement table maps the checked hash into a row. Eight hashes are looked up together, their full 64-bit keys checked and the eight result vectors transposed to record order. The candidate performs the lookup while computing the hashes. The two controls independently price the displacement table with scalar lookup and the fused vector version before adding distant-root recovery. Every recorded run validated its taken set and streams using the frozen oracle. The controls retain the original six musl refusals.

[Individual processes](samples.tsv), [paired results with ranges](paired.tsv), [native compiler and process logs](native-receipts.tar.xz), and [frozen input and C source hashes](inputs.tsv).

## Reproduction

Take the three upstream C sources and two baked headers from the [original step 0 record](../per-core-step0-2850-2026-11-15). Put the C sources under `tools/` and the two baked headers beside the Python scripts. Run `build-lookup.py`, `build-gather.py`, then `build-far.py` with Python 3. The last script produces `tools/fargather.c`. The three `compare*.sh` scripts record the configurations and command lines. Set their lock and frozen-dump paths for the benchmark checkout. The original learned-rule scope applies to both implementations.
