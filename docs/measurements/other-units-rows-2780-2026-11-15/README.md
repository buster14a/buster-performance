# #2780, #2410 and #2216: the other units' SIMD rows, wide _BitInt builtins and wide vectors (2026-11-15)

This record backs buster14a/buster#2824, which is part of three issues:

- [buster14a/buster#2780](https://github.com/buster14a/buster/issues/2780): the 74 SIMD machine rows left in the compiler's other units now decode into the IR.
- [buster14a/buster#2410](https://github.com/buster14a/buster/issues/2410): the elementwise builtins of `_BitInt`s wider than 128 bits, limb by limb.
- [buster14a/buster#2216](https://github.com/buster14a/buster/issues/2216): vectors of more than 1,024 elements.

## Contents

- **`compile-time/`**: the PR's compile-time A/B on the Ryzen 7 9700X: main `750f6a04` against the merged head `c1e072b4`. `final.sh` is the script and `progress.txt` its log.
  - Release builds without `-g`.
  - `ab --rounds 3` of `time-runs --runs 3 --copies 3`: base, head and base again; each run held the 9700X's lock on CPU 2.
  - `tr-c.txt` is `-c main.c` at `-march=native`; `tr-t1.txt` the same with `--tier1`.
- **`zen5/`**: `measure-x86-zen5 --missing --table` on the #2780 head (`2f67c7b2`), and `test-x86-zen5`. No row was missing: every form the decodes and Tier 1's selections back emit already had its 9700X row (2,005 cases, none incomplete). `--missing` exits with a failure when there is nothing to measure; `zen5-table.txt` has its reference rows alone.
- **`run2780.sh`**: the #2780 job, `1935a91f` against `2f67c7b2`. It measured the Zen 5 rows and the machine rows of every unit at `--tier1 -march=znver5`; it also self-builds the seven units that had rows by each `--tier1` and runs the suites on the head's. Its row counts and self-built results are added here when it finishes.

## Results

### Compile time (`-c main.c`, `-march=native`)

| Compile | Instructions, main → head (mean of 27 runs) | Wall against main | User cycles against main | Main against itself (wall, cycles) |
| --- | --- | --- | --- | --- |
| `-c` | 10,703,842,428 → 10,703,954,628 (+0.001%) | +0.02% (copies −0.78% to +0.86%) | +0.16% (copies −0.96% to +1.31%) | −0.39%, −0.17% |
| `--tier1 -c` | 19,358,955,506 → 19,351,700,328 (−0.037%) | −0.25% (copies −0.62% to −0.06%) | −0.11% (copies −0.38% to +0.06%) | −0.02%, +0.07% |

- **Tier 0's `-c`** is unchanged: within the copies' spread and main's own against itself.
- **`--tier1 -c`** is 7.3 M instructions cheaper. The rows #2780 decodes take Tier 1's ordinary IR paths rather than the machine rows' placement.
- **#2410's and #2216's code** runs only for `_BitInt`s past 128 bits and for vectors past the target's registers. `main.c`'s units have neither.

### Machine rows at `--tier1 -march=znver5` (the 9700X's builds, so far)

| Unit | `1935a91f` | `2f67c7b2` |
| --- | ---: | ---: |
| `main_unit_frontend.c` | 0 | 0 |
| `main_unit_backend.c` | 0 | 0 |
| `main_unit_checker.c` | 29 | 0 |
| `main_unit_check_builtins.c` | 9 | 0 |
| `main_unit_types.c` | 5 | 0 |
| `main_unit_assembler.c` | 6 | 0 |

The records and fallbacks of each unit are the same by both.
