# A comment between a skipped directive's `#` and its name (the gap buster14a/buster#3668 left)

The direct path's skip read `#/**/else` as no directive, since a '/' is no name's first character; the full pipeline
reads the comment as a blank and the #else after it. `m9.c` (`#if 0` / `#/**/else` / `int q;` / `#endif`) compiled on
the direct path without `q`; `m1.c` to `m8.c` matched `--no-direct` only because a later error sent them to the full
pipeline. Base: main `2e4400b6`. Branch `claude/eloquent-bell-w29cra`, commit `cf8c9b99`, [buster14a/buster#3675](https://github.com/buster14a/buster/pull/3675).

The fix reads the name after the comments in a cold helper (`fast_check_commented_directive`, through
`fast_skipped_directive_keyword`, which buster14a/buster#3668's spliced names now share) and leaves where it is a conditional's. What
asks it is the cost. The skip's instructions on one `sqlite3.c` compile (the counting build, `../scripts/count.py`,
`../scripts/bp-count.sh`), the variants from `../scripts/gen3.py`:

| variant | the skips' instructions | against main |
| --- | ---: | ---: |
| main `2e4400b6` | 7,443,637 | |
| F1: `else if (next + 1 < end && next[0] == '/' && next[1] == '*')` after the named path | 7,494,555 | +50,918 |
| F1b: `else if (next < end && *next == '/')` | 7,494,453 | +50,816 |
| F2 (the commit): '/' given class 16 in `fast_char_class`, the name test `& 18u`, the check where the scanned name is empty | 7,434,275 | −9,362 |

The branch of its own never runs on sqlite3.c, and still cost 51 K by the decision's register allocation; F2's test
rides the one each skipped directive already makes (`test $imm, (table)` with another immediate), and its length test
sits on a path that only the class-16 byte reaches.

CI's check on the 9700X (`measure-compile --runs 3`, the 9700X job's build): main 211,270,235, the commit 211,260,865
(−9,370, −0.004%), `measure-main3.log` and `measure-final3.log`. `tools/ci/compile-instructions.txt` keeps its count.

Tests: `test-direct` 273 passed (its spliced-names case gains seven comment forms; main fails it), the nine probes here
and the 32 before match `--no-direct` (`../scripts/run.sh`), and the differential over `tests/` is alike (322 direct).
ASan+UBSan and MSan builds on the 9700X (`../scripts/bp-san.sh`): `test-direct` 273 passed, the differential alike (322
direct), the 41 probes alike (`san-*-probes.log`; their three other lines are the lock's wait for another session).
