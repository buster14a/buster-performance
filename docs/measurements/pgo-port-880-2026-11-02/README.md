# Bringing a profile-guided build's gains to the compiler's source (buster#880)

This record is from the Ryzen 7 9700X (`benchpress`) on 2026-11-02. It follows #182 (`pgo-layout-880-2026-10-31`), which measured profile-guided builds of the compiler. The owner then chose two things:

- port the profile's gains to the source;
- add an opt-in `BUSTER_PGO=1` build, which no CI job builds.

Every build, measurement and `perf` run held the host's lock (`~/buster-fast-bench/exclusive.sh`, `EXCLUSIVE_OWNER=claude-880`), one lock per run. Every timed process was pinned to CPU 2 (`taskset -c 2`): governor and EPP `performance`.

The logs keep only the lines the scripts themselves print. The lock's waiting messages, which name other holders, are left out.

## Sources

| tree | source | `src/` + `build.sh` manifest |
| --- | --- | --- |
| main | buster `3ce71ec3`'s `src/` (manifest `61c1296a…`, from `git archive`), with this change's `build.sh`, whose default path is main's | `73fdcda2…` |
| head | buster `b2172dd0` | `2e9ace34…` |

The trees were sent to the host by `tar`. Both manifests are in `logs/receipts.txt`: `sha256sum` of every file under `src/` and of `build.sh`, sorted, then hashed. `head`'s manifest is `b2172dd0`'s, and `main`'s `src/` is `3ce71ec3`'s.

- **Toolchain:** clang 23.1.1, wild 0.10.0, ld.lld 23.1.1, perf 7.2.9-1, kernel 6.18.50-2-lts (`logs/receipts.txt`).
- **Inputs:** the frozen corpus `/var/lib/buster-9700x/corpora/preprocessor-391e729af658`:
  - `sqlite3.c`, with #182's options;
  - 139 musl units (`logs/musl-corpus-139.txt`, #182's list), `-c` in one process.

## What the profile changes

`logs/counts-base-vs-pgo.txt` has the `perf stat` counts (four events, no multiplexing). The builds are:

- `tree-base`: `3ce71ec3`'s `src/`, `-g`;
- `tree-pgo`: the same, `BUSTER_PGO=1` with `scripts/train-corpus.sh`, which is #182's training: `sqlite3.c` in three modes, musl's units and c-testsuite.

On `-fsyntax-only`:

| | without the profile | with it |
| --- | ---: | ---: |
| instructions | 948.5 M | 873.1 M |
| calls (`ex_ret_near_ret`) | 4.91 M | 1.96 M |
| taken branches | 77.4 M | 43.7 M |
| stores | 143.5 M | 122.0 M |

Sampled attribution of the 75 M instructions was unreliable:

- `instructions:u` at a short period was throttled to a third of its samples, and at an unthrottled period it lands after stalls.
- IBS op samples (`ibs_op/cnt_ctl=1`, `logs/ibs-base-vs-pgo.txt`) put the savings on hundreds of functions, a few million each.

The variants below split the savings exactly.

## Variants (`scripts/exp.sh`)

Each variant compiles only `main_unit_checker.c`, the unit that holds the whole compile path, and links it with `exp/base`'s other objects (no `-g`, `-march=native` = znver5). The executable is then baked, and its `sqlite3.c` `-fsyntax-only` and `-c` are counted three times each. Instruction counts repeat exactly (`logs/variants.txt`; base: `logs/variants-base.txt`).

**Profile variants** compile base's source with part of `tree-pgo`'s profile (`scripts/split.py`, `scripts/split2.py`):

- `pfull`: the whole profile;
- `pa`: `check_input_*`, `check_literal_*`, `c_bindings_*` and `check_constant_*`;
- `pb`: `check_graph_*`, `check_action_*`, `check_stream_*`, `check_control_*`, `check_region_*`, `check_overload_*` and `check_query_*`;
- `pc`: the other `check_*`;
- `pd`: everything else;
- `pa1`–`pa5` and `pb1`–`pb3`: `pa` and `pb` split further;
- `pnoinl`: `pfull` with `-mllvm -hot-callsite-threshold=225 -inline-cold-callsite-threshold=225 -locally-hot-callsite-threshold=225 -inline-enable-cost-benefit-analysis=false`, which is the profile's layout without its inlining.

**Source variants** (`scripts/inline.py`, `scripts/cold.py`):

- `a`: 17 small hot callees always inlined;
- `b`: `a` plus 9 large ones;
- `c`: `b` with the diagnostics' reporters `cold, noinline` (dropped);
- `d`: `b` plus 20 more, and `check_graph_scalar_node` calling `check_action_compute` directly;
- `e`: `d` plus `type_strip_aligned`'s `__builtin_expect`. This is head's code.

The hot callees came from sampled return edges with their branch records (`perf record -e ex_ret_near_ret:u -j any_ret,u`, `scripts/calls1.sh` and `scripts/calls2.sh`; `logs/calls-base-vs-pgo.txt` and `logs/calls-variant-b-vs-pgo.txt`). The taken branches of `d` with `-g` came from `perf record -e ex_ret_brn_tkn:u -j any,u` (`scripts/taken.sh`, `logs/taken-branches-variant-d.txt`).

`-fsyntax-only` (against base; cycles the least of three runs):

| variant | instructions | cycles | calls | taken | stores |
| --- | ---: | ---: | ---: | ---: | ---: |
| pfull | -7.37% | -3.05% | -56.16% | -39.03% | -13.80% |
| pa | -3.67% | -1.76% | -29.07% | -14.05% | -4.58% |
| pb | -2.83% | -1.04% | -32.17% | -15.72% | -5.98% |
| pc | -1.55% | -1.32% | -11.07% | -3.90% | -2.98% |
| pd | -0.12% | -0.97% | -5.92% | -9.96% | +0.17% |
| pa1 | -0.46% | -0.80% | -3.87% | -5.81% | +0.05% |
| pa2 | -0.41% | -0.10% | -8.37% | -0.51% | -1.26% |
| pa3 | -0.73% | -0.39% | -8.51% | -1.30% | -0.92% |
| pa4 | -1.30% | -0.14% | -12.31% | -3.83% | -1.61% |
| pa5 | -4.02% | -2.74% | -30.69% | -13.28% | -4.67% |
| pb1 | -0.36% | -1.19% | -11.34% | -3.05% | -0.94% |
| pb2 | -0.84% | +0.69% | -5.65% | -2.14% | -1.52% |
| pb3 | -3.28% | -1.10% | -32.55% | -13.90% | -6.74% |
| pnoinl | -2.10% | -1.59% | -2.13% | -32.67% | -0.20% |
| a | -0.71% | -0.83% | -18.66% | -1.92% | -0.41% |
| b | -1.31% | -1.84% | -26.52% | -4.11% | -4.01% |
| c | -1.10% | -0.97% | -26.67% | -4.79% | -3.36% |
| d | -4.67% | -1.59% | -51.93% | -7.36% | -10.24% |
| e | -4.70% | -2.15% | -51.93% | -13.17% | -10.21% |

`-c` (against base; cycles the least of three runs):

| variant | instructions | cycles | calls | taken | stores |
| --- | ---: | ---: | ---: | ---: | ---: |
| pfull | -5.47% | -2.46% | -45.17% | -36.28% | -10.33% |
| pa | -2.82% | -1.46% | -26.93% | -11.16% | -4.06% |
| pb | -2.32% | -1.38% | -29.37% | -14.64% | -4.65% |
| pc | -0.62% | +0.33% | -10.72% | -4.80% | -1.82% |
| pd | -0.32% | -0.64% | -8.87% | -10.60% | +0.16% |
| pa1 | -0.41% | -0.15% | -7.12% | -4.66% | -0.13% |
| pa2 | -0.37% | +0.47% | -10.66% | -0.74% | -0.85% |
| pa3 | -0.61% | -0.38% | -10.77% | -1.24% | -0.13% |
| pa4 | -1.04% | +0.14% | -13.76% | -3.15% | -1.34% |
| pa5 | -3.08% | -1.78% | -28.21% | -10.47% | -4.31% |
| pb1 | -0.33% | -0.96% | -13.00% | -2.57% | -0.83% |
| pb2 | -0.69% | +0.67% | -8.52% | -1.88% | -0.84% |
| pb3 | -2.66% | -0.97% | -29.67% | -13.26% | -4.91% |
| pnoinl | -1.71% | -1.63% | +2.93% | -30.66% | -0.33% |
| a | -0.54% | -0.83% | -14.67% | -1.45% | -0.91% |
| b | -0.99% | -0.90% | -20.85% | -3.13% | -3.30% |
| c | -0.87% | -0.73% | -20.97% | -3.92% | -2.97% |
| d | -3.52% | -0.94% | -40.82% | -5.60% | -8.29% |
| e | -3.60% | -1.51% | -40.82% | -10.84% | -8.45% |

## Training on the compiler's own sources

`BUSTER_PGO=1`'s default training compiles every source as `-E -P`, `-fsyntax-only` and `-c`. The comparison is between `tree-self` (that training, `BUSTER_DEBUG_INFO=0`) and `tree-pgo` (#182's corpora, `-g`). Each is against `exp/base` (the same source, unprofiled), the least of three runs (`scripts/measure.sh`, `logs/self-vs-corpus.txt`):

| | corpora's profile, instructions / cycles | own sources' profile, instructions / cycles |
| --- | ---: | ---: |
| `-fsyntax-only sqlite3.c` | -7.95% / -3.29% | -9.39% / -5.09% |
| `-c sqlite3.c` | -5.90% / -2.18% | -7.15% / -2.79% |
| `-c` of the 139 musl units | -5.61% / -3.95% | -7.09% / -6.37% |

The `BUSTER_PGO=1` build took 2.0 minutes; 78 s of that was the instrumented compiles and the training.

## Whole-compile times (`scripts/timeruns.sh`, `logs/time-runs.txt`)

Each build is `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh shifts DIR main.c 0 256 512 768`:

- `main`;
- `head`;
- `headpgo`: head with `BUSTER_PGO=1` and its default training.

They were timed with `time-runs --runs 11 --warmups 1 --copies 2`: 88 runs per build and list, no failed process. Ranges are over placements and copies:

| | `-c sqlite3.c` wall | cycles | instructions | musl `-c` wall | cycles | instructions |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| main | 116.47 ms | 546.1 M | 1,257.1 M | 186.82 ms | 744.2 M | 2,239.5 M |
| head | -1.53% (-2.66% to -0.60%) | -1.73% | -3.64% | -1.15% (-1.80% to -0.69%) | -1.58% | -3.27% |
| headpgo | -3.76% (-4.75% to -3.06%) | -4.32% | -7.25% | -5.15% (-5.93% to -4.51%) | -7.04% | -7.24% |

Every object of `sqlite3.c` and of the 139 musl units, from each build's `compiler-0`, is byte for byte main's (`logs/receipts.txt`, which also has the executables' and profiles' `sha256sum`).

## Limitations

- The variants' cycles are single `perf stat` runs (the least of three), which move by about 1%. Only `time-runs` is a timing.
- `tree-pgo` was built with `-g` and `tree-self` without it. Clang's code with `-g` differs only in a few functions' stack slots.
- The variants link one changed object with base's other objects and bake the result, as `build.sh` does.
- The profile subsets change the profile's summary, so the subsets' gains don't add up to the whole's.
