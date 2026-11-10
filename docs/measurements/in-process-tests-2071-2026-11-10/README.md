# Buster in-process and a clang server for the warning sweep (buster#2071), 2026-11-10

These are the measurements behind buster#2071's prototype. `test-checker-driver`'s warning sweep
(`check_test_driver_warning_fixtures`) runs buster's commands in its own process (`--in-process`) and clang's through a
persistent server (`--clang-server`, `tools/clang-server`). `--differential` runs both ways and compares. All runs were
on an AMD Ryzen 9 7940HS laptop (Zen 4) with clang 23.1.4, each through the laptop's `cores` queue. The sanitizer runs
used CI's options (`tools/ci/sanitizers.sh`) with transparent huge pages disabled (`scripts/nothp.c`).

## Executables

`trees.txt`: buster's plain Release build and its address build, both from the prototype's commit, and the clang
server built by `tools/clang-server/build.sh` against the distribution's clang 23.1.4 libraries.

## Results

- **Equivalence** (`scripts/inproc-diff.sh`, `results/differential/part-K.txt`): all 16 parts with `--in-process
  --clang-server --differential`, plain. Parts 6–9 hold the sweep's 716 fixtures. Their 4,293 clang runs and 17,172
  buster runs gave the same exit status and the same captured output both ways: 0 differences. Every part passes but
  part 14, whose 4 `asm placed` failures main's plain build also has on this laptop.
- **Plain timing** (`scripts/inproc-time.sh`, `results/timing/time-plain-*.txt`): parts 6, 7 and 8, as children and
  in-process with the server, at the same time on two cores. The sweep's own time, from the run-modes lines: 54.6 s
  against 13.9 s, 13.0 s against 4.1 s, and 19.3 s against 5.5 s. The parts' wall times, printed by the script and
  transcribed here, not kept in a file: 72.1 s against 30.7 s, 33.1 s against 23.6 s, and 26.9 s against 12.9 s.
- **Address timing** (`scripts/inproc-asan.sh`, `results/timing/time-asan-*-6.txt`, `results/timing/asan-walls.txt`):
  part 6, both ways at the same time. Sweep: 890.5 s against 28.0 s. Part: 1,064.4 s against 203.6 s. Both ran 31,870
  checks with 0 failures. Parts 7 and 8 were stopped once part 6's pair was in.
- **Clang per run** (`scripts/clang-batch.sh`, `scripts/server_check.c`, printed and transcribed):
  - `clang --version` takes 10.2 ms of CPU, and `-fsyntax-only` of a one-function file 11.8 ms;
  - 40 such files cost 0.50 s as 40 runs and 0.485 s as one multi-input clang;
  - through the server, 42 runs averaged 1.2 ms against 12.4 ms spawned, with byte-identical output and status, and
    likewise for `-c`, `-Werror` and `-w -ferror-limit=1`.

## Limitations

- One laptop, not a hosted runner or the 9700X.
- The plain wall times and the clang per-run figures were printed and are transcribed here. The sweep times and check
  counts are in the result files.
- The prototype converts one function. The rest of `test-checker-driver` still runs children.
