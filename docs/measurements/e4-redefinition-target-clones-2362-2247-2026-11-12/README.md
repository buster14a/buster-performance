# E4: function redefinition recovery (#2362) and target_clones copies (#2247), base vs head

On benchpress (Ryzen 7 9700X), under `~/buster-fast-bench/exclusive.sh`, pinned to CPU 2, by `run.sh`:
Release builds (`./build.sh`, native) of

- base `8c67a8d6` (main before buster14a/buster#2423, #2435 and #2442);
- head: buster14a/buster#2442's head (`revisions.txt`), main with #2423 and #2435 merged, plus #2442.

The head also has the other PRs merged into main since the base, so its deltas bound these three PRs' from above.

`time-runs`, 11 runs each after 2 warm-ups, in a Williams design (`results.txt`):

| command | base median wall | head median wall | wall | user cycles |
|---|---|---|---|---|
| `-fsyntax-only` sqlite3.c (frozen corpus) | 100.368 ms | 100.383 ms | +0.01% | +0.24% |
| `-c` sqlite3.c | 123.402 ms | 123.107 ms | -0.24% | -0.22% |
| `-c` main.c (the head's source) | 678.249 ms | 680.765 ms | +0.37% | +0.43% |

All within run-to-run noise. The changes add work only in a unit with a function redefinition, a visible invalid
declaration or target_clones copies, none of which these inputs have.

Agent session: https://claude.ai/code/session_01EgbxncXFaboQMqPazvMXhQ (Anthropic / claude-opus-5-5)
