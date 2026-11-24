# #3448 (phase D of #2924): the checker's scalar tails become masked steps

Branch `claude/2924-phase-d-tails`. Sites: `c_checker.c` (warning contexts, reports, the first node out of room),
`c_check_transitions.c` (static words), `c_check_common_warnings.c` (parents), `c_check_input.c` (system-token map;
level marks), `c_check_data.c` (nonzero bit scan).

**First form** (4f62e3b38, every step masked): objects identical in four modes, but `first-form/time-*.log` found
sqlite3.c +0.45% to +0.58% user cycles in each of three rounds and Lua +0.30% to +0.82%, with fewer instructions.

**Second form** (3470823cf): each site's step an always-inline function, the full blocks unmasked as before and the last
items one masked call. `run.sh`, `logs/`:
- objects and stderr in four modes (-Wall -Wextra, none, --tier1, -flazy-system-headers): 1,373 objects each, all
  identical; stderr the same but for the lock's process lines;
- one placement, three rounds (user cycles against base): Lua -0.15%, +0.11%, +0.01%; musl +0.09%, +0.16%, -0.20%;
  sqlite3.c +0.59%, +0.23%, +0.39%.
- `perf.sh`, `perf/`: per-symbol cycles of 15 sqlite3.c compiles each. The changed sites take the same or less
  (`check_common_parents` 0.56% to 0.53%); the difference is spread over unchanged functions of the same unity unit
  (`check_action_arithmetic` 0.35% to 0.48%, `check_program_references` 2.83% to 2.94%): placement, not the tails.
- `shifts.sh`, `logs/time-sqlite-shifts.log`: sqlite3.c over six placements of the checker's unit (0 to 3,520 bytes),
  three copies each, three rounds (#509's method). Against base, over placements: head +0.21%, +0.19%, +0.25%;
  base-again +0.04%, +0.19%, -0.04%. Placements alone spread 0.31% to 0.93%.

**Mutants** (`mutation/run.sh`, `results.txt`): each site's last step without its last lane. All eight killed, the
parents' by test-checker-driver's "common parents and cached roots" (test-checker alone doesn't reach it); the level
marks' by the test this branch adds.
