# Tier 0's vector class: what it costs code without vectors, 2026-10-27

Branch `claude/tier0-vectors-136` (buster14a/buster) adds a class, VECTOR, of 16-, 32- and 64-byte vector values that
live in a 64-byte frame slot per integer depth, and a kind, X86, a machine operation of a function's rows (#136). Nothing
produces them yet, and a function without vectors (`Tier0Function.vectors` false) runs the selection, measuring and
emitting it ran before; the X86 entries' effects are a pass of their own (`tier0_operation_effects`) that only a function
with vectors runs. This measures what the branch costs such functions: Tier 0's own benchmark on generated programs, and
`-c` of the frozen `sqlite3.c`, the whole compile with Tier 0 among it.

| Measure | base (main `18b663e9`) | head (`d150b4d7`) | change |
| --- | --- | --- | --- |
| `benchmark-backend`, vector path | 14.39 ns/entry, 169.85 instructions | 14.45 ns/entry, 169.90 instructions | +0.42%, +0.03% instructions |
| `benchmark-backend`, scalar path | 41.88 ns/entry, 570.95 instructions | 41.52 ns/entry, 569.94 instructions | -0.86%, -0.18% instructions |
| `benchmark-backend`, branch sizing and encoding | 1.11 and 0.89 ns/entry | 1.12 and 0.89 ns/entry | 12.62 and 17.78 instructions on both |
| `-c` of `sqlite3.c`, wall (`time-runs`) | 188.538 ms | 186.913 ms | -0.86% |
| `-c` of `sqlite3.c`, user instructions (`perf stat`) | 2,218,459,153 | 2,218,876,926 | +417,773 (+0.019%) |
| `-c` of `sqlite3.c`, user cycles | 882.5 M | 874.4 M | -0.92% |
| `-c` of `sqlite3.c`, peak resident set | 712,164 to 712,192 KB | 713,260 to 713,284 KB | +1.1 MB |

`benchmark-backend` is the median of five rounds, each the median of its 21 passes (`ab_backend.log`); the head's
vector-path rounds are 14.44 to 14.47 ns/entry, the base's 14.34 to 14.48. The `-c` rounds don't overlap
(`ab_lower.log`: the base's 188.35 to 188.71 ms, the head's 186.67 to 187.30), and the head's object is the base's,
byte for byte (`inputs.sha256`: `lower_base.o` and `lower_head.o`). `perf stat`'s three rounds give each tree the same
instructions within 17 (`perf.log`).

On the 9700X the head's `test-tier0` passes, 188,033 checks with 0 failed (`test_tier0.log`), and with `--cross-check`
201,716 (`test_tier0_cross.log`); its vectors check is 9,864 of them.

## Trees

| Name | Commit | What it is |
| --- | --- | --- |
| `base` | [`18b663e9`](https://github.com/buster14a/buster/tree/18b663e9) | main, the head's merge-base |
| `head` | [`d150b4d7`](https://github.com/buster14a/buster/tree/d150b4d7) | the branch: the class and the kind (`628c4c36`), the effects' pass (`424af761`) and main merged |

Each tree was `git archive` of its commit, sent by tar into an empty directory; `source-base.sha256` and
`source-head.sha256` hold the SHA-256 of each of its files, and `inputs.sha256` the executables', the objects', the
inputs' and the host's kernel and clang. Each was built with `BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh`
(`build_base.log`, `build_head.log`).

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2 at the performance governor. Each build and each run
took the shared lock on its own (`EXCLUSIVE_OWNER=claude-126`); the lock's waiting messages, which name other sessions'
runs, are removed from the logs.

## Method

`abV.sh` ran it (`abV.log` is its output). The inputs and options are those of
[#475's record](../char-signedness-475-2026-10-26/README.md): the preprocessor oracle's frozen `sqlite/sqlite3.c` with
the pinned gnu17 predefines, `-march=znver5 -std=gnu17 -nostdinc` and the corpus's system directories, without
`--clang-features` (its atomics off), `SOURCE_DATE_EPOCH=1792454400`, `CPATH`/`C_INCLUDE_PATH` unset:

- the head's `test-tier0` and `test-tier0 --cross-check`;
- each tree's `-c` once (status 0 on both: `lower_base.log` and `lower_head.log` are empty), whose objects compare equal;
- `build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh base head` of `benchmark-backend`
  (`ab_backend.log`: 2,008 generated functions, 262,874 typed entries, both of Tier 0's paths, branch sizing and
  encoding) and of `time-runs --runs 11 --list -c -o /dev/null` (`ab_lower.log`: 11 fresh processes of the whole
  compile per round, with each one's wall time, rusage, peak resident set and page faults);
- three rounds, each tree in turn, of `perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2` of the
  whole compile (`perf.log`).

## Limits

One input, which has no vectors, and generated programs: this measures the branch's cost to code without vectors, not
vector code, which nothing produces yet. The peak resident set's 1.1 MB isn't investigated here, and the cycles' and the
scalar path's gains are within what code placement moves between builds.
