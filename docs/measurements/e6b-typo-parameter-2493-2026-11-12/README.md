# E6b: #2493's base-against-head timings on the 9700X

buster14a/buster#2493 (#1447 item 3: a parameter's and a cast's typo of a type
name). The reader's valid path gains one predicted branch per parameter's
specifier list (`check_input_specifiers`); everything else runs only in a
rejected unit. Package E6b, round E.

- Base: `d40698d8` (main when the branch started). Head: `b110f35b`
  (`e6b/typo-parameter`'s last commit). Release builds (`./build.sh`) under the lock.
- `setup.sh` clones and builds both; `tr.sh` runs `time-runs` (15 runs, 2
  warm-ups, Williams order) pinned to CPU 2 under `exclusive.sh`.
- Inputs: sqlite3.c (the copy in `1447-claude-c9`) and buster's own `main.c`
  (`-fsyntax-only -march=native -fwrapv -funsigned-char`).

| input | base median wall | head median wall | user cycles | instructions |
|---|---|---|---|---|
| sqlite3.c | 100.844 ms | 102.599 ms | +0.08% | +0.01% |
| main.c | 607.415 ms | 608.182 ms | +0.30% | +0.001% |

Flat: instructions agree to within 0.01%, and the cycles' and wall times'
differences are within the runs' spread. `time-runs.log` has every run.

---
Agent session: [private session](https://claude.ai/code/session_01EgbxndxUuoAnMnnGwSN4wD)
Model: Anthropic / claude-opus-5-5
