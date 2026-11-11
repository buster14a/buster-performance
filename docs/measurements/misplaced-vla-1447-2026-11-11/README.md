# Misplaced VLA recovery (#1447 package C3): 9700X base vs head

buster14a/buster#2286 ("Recover misplaced variable-length arrays as clang does") adds a compare per declaration (`check_input_declaration`) and per misplaced bound. This measures error-free `-fsyntax-only` before and after it.

- **Host:** benchpress, Ryzen 7 9700X (`host.txt`). Builds and timing ran under `~/buster-fast-bench/exclusive.sh`, the timing pinned to CPU 2.
- **Builds:** `BUSTER_HOST_ARCH=znver5 ./build.sh`, Release.
  - base: main `66e05fbfba750aad1639887e87c38f89fdc9de79`;
  - head: `55314dc9fd85ace2c246eacb0a94ff2b92590c6f` (branch `claude/1447-misplaced-vla`).
- **Command:** `run.sh BASE claude/1447-misplaced-vla` (`time-runs --runs 15 --warmups 2`). Raw output: `times-syntax.txt`, `run.log`.

| list | base median (range) | head median (range) | instructions |
|---|---|---|---|
| `-fsyntax-only -w sqlite3.c` | 86.315 ms (85.498–89.196) | 86.590 ms (86.076–88.814) | +0.04% |
| `-fsyntax-only sqlite3.c` | 97.016 ms (96.365–100.670) | 97.397 ms (96.680–100.239) | +0.04% |
| `-fsyntax-only … main.c` | 588.375 ms (584.028–593.796) | 587.583 ms (583.415–592.546) | +0.01% |

Flat: the medians move by −0.13% to +0.39%, inside overlapping ranges, and instructions by 0.01–0.04%.

---
Agent session: [private session](https://claude.ai/code/session_01EgbxngPtvUfDy4W16JqCMg)
Model: Anthropic / claude-opus-5-5
