# #1447 accepted refusals: base-vs-head -fsyntax-only (2026-11-09)

The base-vs-head measurement for buster14a/buster#1901, #1902, #1903 and #1904, taken on the Ryzen 7 9700X (benchpress) in one hold of its lock.

- **base**: main `4842317c1`, built on benchpress with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`.
- **head**: `4842317c1` with the four PRs merged in, built in a container with the same settings and copied over. Their heads were `ccfccdb14` (#1901), `f63c3d4e5` (#1902), `5cf03dea` (#1903) and `19108675d` (#1904).
- **Command**: `taskset -c 2 head/build/compiler time-runs --runs 21 --warmups 3 --build base … --build head …`, from base's tree, timing:
  - list 1: `-fsyntax-only sqlite3.c` (`frontend-baseline-claude/baseline/sqlite3.c`);
  - list 2: `-fsyntax-only -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing src/buster/compiler/main.c`.

`time-runs.txt` is the raw output.

| input | base median wall | head median wall | user cycles, head vs base | instructions, head vs base |
| --- | --- | --- | --- | --- |
| sqlite3.c | 94.715 ms | 94.755 ms (+0.04%) | -0.36% | 975,751,429 → 973,257,206 (-0.26%) |
| main.c | 2947.143 ms | 2946.057 ms (-0.04%) | +0.00% | 58,653,026,954 → 58,645,329,940 (-0.01%) |

There is no measurable difference, and every run's ranges overlap.

`ids.txt` holds the SHA-256 of both executables and of both inputs, with the host's kernel, CPU and system clang. `run.sh` is the script that took the lock once and ran `time-runs`. Base built with clang 23.1.1 on benchpress; head built with clang 23.1.5 in the container.
