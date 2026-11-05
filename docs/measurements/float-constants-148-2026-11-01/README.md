# Signaling NaNs and the `_Float16` and `__float128` constants on the 9700X (buster #148)

The base is buster's `1cd79711`. The head is `d57d5153`, which adds:

- `nans`, `nansf` and `nansl`;
- the `_Float16` and `__float128` forms of `nan`, `nans`, `inf` and `huge_val`;
- NaN payloads kept bit for bit in static data and code.

`447e1bdc` follows it and changes only tests and documentation (`tests/447e1bd.status`).

## Method

`scripts/measure.sh base head` (a copy of buster-performance#186's harness) is one hold of the host's lock. It compiles
the frozen `sqlite3.c` with the 9700X job's options and stb_image with `-march=native`, both with `-c`, base against head.

1. A drive of each tree, which compares the objects (`runs/measure.log`).
2. 8 rounds. In each, every tree compiles each unit 3 times under `perf stat -e instructions:u,cycles:u,task-clock`,
   pinned to CPU 2, with the order of the trees alternated by round.

`scripts/analyze.py runs/measure-UNIT.log base head` gives medians of the rounds' means. All 48 runs per unit exited
with status 0. Both trees write identical objects for both units.

Neither unit calls the new builtins, so these numbers measure what the catalog rows, the checks and the bitwise NaN
writers cost code that doesn't use them.

## Results

| unit | instructions | cycles | task-clock |
| --- | ---: | ---: | ---: |
| `sqlite3.c` | +100,838 (+0.0071%) | −0.0077% (per-round median −0.13%) | −0.14% |
| stb_image | +9,161 (+0.0046%) | +0.58% (per-round median +0.44%) | +0.73% |

The instruction counts vary by tens per round in `sqlite3.c` and by about 1,300 in stb_image. The two units' cycles
move in opposite directions while their instructions barely change (the per-round range is −0.82% to +1.20% in
`sqlite3.c` and +0.08% to +1.58% in stb_image). That is consistent with placement noise rather than a cost of the
change, as in `align-review-148-2026-11-01`.

## Tests

`tests/d57d515.status` holds the head's run of `scripts/float.sh`, each test in a hold of its own:

- 0 failures in `test-checker --program-float-constants`, `test-check-builtins-float`, `test-checker --seed 133`,
  `test-check-builtins`, `test-builtin-lowering`, `test-checker-deferred` and the call graph check;
- `test-checker-driver` failed 4 checks. Its library-refusal fixture still expected `nans` and `nansl` to be refused;
- `test-preprocessor --clang` failed. Its builtin inventory did not list the 11 names.

`447e1bdc` fixes both tests. `tests/447e1bd.status` holds its run of `scripts/float2.sh`: it rebuilt, then
`test-checker-driver` (48,000 checks), `test-preprocessor --clang`, `test-checker --program-library` (639) and
`test-checker --program-float-constants` (220) all passed.
