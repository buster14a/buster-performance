# #3307: lazy system headers on `<immintrin.h>` (9700X, 2026-11-22)

`measure.sh TREE OUT` runs 11 Release processes of each input (`imm1.c` is `#include <immintrin.h>` plus an empty
`main`; `sqlite3.c` from `653-claude/inputs`), `-w -fsyntax-only --time-stages`, eager and `-flazy-system-headers`,
under `~/buster-fast-bench/exclusive.sh`. `summary.sh OUT` prints medians. `summaries.txt` has all four runs.

- `base`: buster main `1f7ce98f`.
- `m1-fix`: branch `claude/lazy-intrinsics-3307` at `303d680c` (the tree planner certifies keyword-operand calls).
- `m2-fix`: branch at `13b5d3da` (deferred definitions' unread headers are skipped too).

| imm1.c, lazy | check-input ms | total ms | peak RSS KB | planner |
| --- | ---: | ---: | ---: | --- |
| base | 29.901 | 39.295 | 160,420 | bindings |
| 303d680c | 20.600 | 29.682 | 131,644 | tree |
| 13b5d3da | 7.615 | 16.123 | 120,484 | tree, skipped=5184 |

sqlite3.c's check-input is 43.4 ms in every run, eager and lazy (its lazy planner is `eager`, for its assembly).
