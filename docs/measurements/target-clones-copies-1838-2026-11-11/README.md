# target_clones bodies compiled once per version: the cost to units without them on the 9700X, Buster #1838

Compiler pull request: [#2210](https://github.com/buster14a/buster/pull/2210), for
[#1838](https://github.com/buster14a/buster/issues/1838). It compiles a GNU `target_clones` body once per
version, as clang does. The change reaches every unit's `-c` path at two places:
- the lowering's map from a body's opening to its locals walks the bodies in reverse, and each body reads its
  locals' slice through `check_lower_local_body` (one comparison with the body before it);
- the selection's copy loop, which a unit without a `target_clones` group doesn't enter.

This measures what those cost a unit without a multiversioned function.

## Sources and host

Each tree is a clone of buster14a/buster at its commit, built on the 9700X by `BUSTER_HOST_ARCH=znver5
./build.sh` under the host lock (`scripts/setup.sh`, `scripts/build.sh`, `scripts/all.sh`):

- **base:** `684f7d4f774237f9b1b12a36393bfd0897667abe` (#2182's head, #2210's base);
- **head:** `2721ddc1dc7353ec5ca22073461beff09ad6968b` (#2210's first head).

`logs/receipt.txt` has the host, toolchain, both executables' SHA-256 and the inputs'. The later commits on
#2210 are merges of its base branch, which leave the measured paths unchanged.

## Method

`scripts/run.sh`: one `time-runs --runs 21 --warmups 3` comparison of both builds, in a Williams design's
order, under one hold of the host lock, pinned to CPU 2. It times `-c -o /dev/null` of SQLite's amalgamation
(list 1) and of Buster's own `main.c` with clang's `-march=native` predefines (list 2). `logs/run.log` is the
whole output: every run's wall time, rusage, peak RSS, faults, user cycles and instructions.

## Result

| `-c` of | wall (median of 21) | user cycles | instructions |
|---|---|---|---|
| sqlite3.c | 117.969 → 119.084 ms (+0.95%) | 565.126 → 563.628 M (−0.27%) | 1,266,419,190 → 1,266,655,692 (+0.019%) |
| main.c | 654.285 → 654.429 ms (+0.02%) | 3302.331 → 3300.099 M (−0.07%) | 10,001,871,520 → 10,000,046,160 (−0.018%) |

The two builds are the same work within single-build placement noise.
- Instructions differ by under 0.02% each way.
- Cycles go down slightly on both inputs.
- sqlite3.c's wall-time median is +0.95%, but its runs span 116.3–125.2 ms (head) against 116.8–143.2 ms
  (base), and its cycles fall.

## Limitations

- One build of each tree, so code placement isn't controlled.
- Neither input has a multiversioned function, so the copies' own cost isn't measured. It only applies to a
  unit with `target_clones`, where clang compiles the same copies.
