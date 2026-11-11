# Declarator recovery (#1447 package C3): 9700X base vs head

buster14a/buster#2225 ("Recover typedefs' and parameters' declarator errors as clang does") adds a branch per declarator in `check_input_declaration` and a byte load per declaration in the unused-declaration pass. This measures error-free `-fsyntax-only` before and after it.

- **Host:** benchpress, Ryzen 7 9700X (`host.txt`). Each build and the timing ran under `~/buster-fast-bench/exclusive.sh`, the timing pinned to CPU 2.
- **Builds:** `BUSTER_HOST_ARCH=znver5 ./build.sh`, Release.
  - base: main `0696e795db0332edf90ed97e4170773a013e1ee3`;
  - head: `c169eb1f4f3fa93697280ed0860ea643f0c27c5a` (branch `claude/1447-typedef-parameter-recovery`).
- **Command:** `run.sh` (`time-runs --runs 15 --warmups 2`, both builds in turn). Raw output: `times-syntax.txt`, `run.log`.

| list | base median | head median | wall | user cycles | instructions |
|---|---|---|---|---|---|
| `-fsyntax-only -w sqlite3.c` | 85.833 ms | 85.873 ms | +0.05% | +0.01% | +0.07% |
| `-fsyntax-only sqlite3.c` | 96.188 ms | 96.244 ms | +0.06% | +0.40% | +0.06% |
| `-fsyntax-only … main.c` | 583.172 ms | 583.619 ms | +0.08% | +0.20% | +0.03% |

Every difference is inside the run-to-run ranges in `times-syntax.txt`. Instructions grow by 0.03–0.07%, from the new per-declarator test.

---
Agent session: [private session](https://claude.ai/code/session_01EgbxngPtvUfDy4W16JqCMg)
Model: Anthropic / claude-opus-5-5
