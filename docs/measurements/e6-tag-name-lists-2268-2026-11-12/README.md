# E6: a C23 list between a tag's name and its body (#2268), base against head, 2026-11-12

Base-against-head timings on the 9700X for [buster14a/buster#2448](https://github.com/buster14a/buster/pull/2448)
(issue #2268). The change reads a struct's or a union's C23 attribute lists between its name and its body
(`parse_scalar_tag`, `check_input_tag`), which puts a few compares on each tag's reading.

## Host and method

- **Host:** Ryzen 7 9700X (`benchpress`), CPU 2 (`taskset -c 2`), clang 23.1.1.
- **Builds:** each tree built with `BUSTER_HOST_ARCH=znver5 ./build.sh` (Release) under its own `exclusive.sh` hold
  (`build.sh`, run by `all.sh`).
- **Timing:** `run.sh` is one `exclusive.sh` hold around one `time-runs` (21 runs, 3 warm-ups, Williams order) of:
  1. `-fsyntax-only` of `sqlite3.c`;
  2. `-c -o /dev/null` of `sqlite3.c`;
  3. `-fsyntax-only` of the head tree's `src/buster/compiler/main.c` (`-march=native -Isrc -fwrapv -funsigned-char
     --predefines`);
  4. `-c -o /dev/null` of the same `main.c`.
- `setup.sh` checks the trees out and copies `sqlite3.c` from `~/buster-fast-bench/frontend-baseline-claude/baseline/`.

## Trees and inputs

| Name | Revision | `build/compiler` SHA-256 |
| --- | --- | --- |
| `base` | main `8c67a8d61825d3c28ab88d046cca0ad2d813abd2` | `4462216e197364c65d9a98d7e0bab5321c964362a3ef08cc1091f6afdd586a5b` |
| `head` | `e6/2268-tag-name-list` `4c17b64069f49c01bc2367ef548ac1940dc104f6` | `64f437387c9e5665a2db16e727e8c21d6f4f652cd729e1a69d7459da55e2646f` |

`sqlite3.c`: SHA-256 `b1dd5d74ec7f29055a6684fa06fb3c2f6821c87dd38f9a458dfd2e8a1db28189`.

## Results (medians of 21; `all.log` has every run)

| List | base wall | head wall | wall | base user Mcycles | head user Mcycles | cycles | instructions base → head |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 `-fsyntax-only` sqlite3.c | 100.898 ms | 101.698 ms | +0.79% | 472.909 | 471.251 | -0.35% | 1,034,789,465 → 1,034,807,759 |
| 2 `-c` sqlite3.c | 124.085 ms | 123.181 ms | -0.73% | 589.885 | 587.772 | -0.36% | 1,318,956,662 → 1,318,974,977 |
| 3 `-fsyntax-only` main.c | 603.530 ms | 601.295 ms | -0.37% | 3030.166 | 3015.086 | -0.50% | 9,090,900,894 → 9,090,058,538 |
| 4 `-c` main.c | 679.186 ms | 677.660 ms | -0.22% | 3436.295 | 3426.166 | -0.29% | 10,412,382,972 → 10,411,513,796 |

Flat: every wall and cycle median is within run-to-run spread (the ranges overlap in `all.log`). sqlite3.c's
instructions grow by about 18,000 (0.002%), the tags' added compares; main.c's fall by about 0.8 M, which is code
layout between the two builds, not this change.

## Limitations

One hold, 21 runs per list, one CPU. The base is main at the PR's branch point; the head's later main merges, if
any, aren't measured here.
