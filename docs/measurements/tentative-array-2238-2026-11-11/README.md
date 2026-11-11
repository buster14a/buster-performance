# `-Wtentative-definition-array` and the unit end's order: valid-unit timing (buster#2238)

The evidence behind [buster#2281](https://github.com/buster14a/buster/pull/2281). That PR adds a reader pass to every valid unit (`check_input_tentative_arrays`: one bit scan of the tentative definitions, more only in a unit with a tentative array) and moves the driver's unit-end warnings after every other diagnostic. Valid units' timing must be unchanged.

- **Base:** buster `66e05fbfba750aad1639887e87c38f89fdc9de79` (main).
- **New:** buster `a777aa5d3156515a763e86999d6bff8d72aa827f` (the PR's head when measured).
- **Host:** the Ryzen 7 9700X (`benchpress`), clang 23.1.1. Each tree built with `./build.sh` (Release) under the host lock (`setup.sh`). The executables' SHA-256 digests are in `host.txt`.
- **Workload:** `-fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall src/buster/compiler/main.c`, the new tree's source, which has no tentative array.
- **Command:** `run.sh`, one `time-runs` under `exclusive.sh`, pinned to CPU 2: 2 warm-ups, then 15 runs of each build in a Williams design's order. The raw output is `time-runs.log`.

## Result

| | base | new | new vs base |
|---|---|---|---|
| median wall (ms) | 605.095 | 604.651 | -0.07% |
| median user cycles (M) | 3038.583 | 3034.119 | -0.15% |
| median instructions | 8,999,854,211 | 9,000,496,411 | +0.007% |

The wall-time ranges overlap: base 601.074 to 611.542 ms, new 602.040 to 608.649 ms. The pass costs about 640,000 instructions, 0.007% of the run, and the time change is within noise.

## Limitations

This is one workload, one host and one session. The per-run lock ab design (`ab --rounds 20`) was started first and then stopped: the host's queue let only three runs through in twenty minutes. Its partial log isn't kept.
