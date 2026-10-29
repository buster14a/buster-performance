# #772's target attributes: what reading them costs, 2026-10-29

Branch `claude/loving-carson-j9sz52-intrinsics5` (buster14a/buster#772) gives a function its own instruction set
from GNU's `__attribute__((target("...")))`. The static objects' pass keeps the functions' declarations with a target
or `target_clones` attribute. `check_program_targets` then sorts them by object, finds each body's and reads its
string.

This record measures three builds on the 9700X, each pinned to CPU 2:

- **base**: the branch's base, #771's `7dae48fbbfb68944075cab83dc7582edabaaf4fb`;
- **head**: the pull request's first commit, `6ab01f93e4f1ba9d437325a094eebac866410075`;
- **head2**: head with `abT2.patch`. That is `f22f751af07eb921aeff8a8bd6da62a554ee40fc`'s source change, which this
  record led to: `check_program_targets` takes an attribute whose string is the one before as that one was read, and
  doesn't search the keys for a body outside their objects' range. head2's sources are that commit's but for
  `docs/c-checker.md` (`sources.sha256`).

The inputs:

- **`sqlite3.c`**: the frozen one of corpus `preprocessor-391e729af658`, which has no target attribute.
- **`main.c`**: head's own, whose 5,344 target attributes are the clang headers' intrinsics. It is checked with
  `build.sh`'s flags (`print-compile-flags`) and one lane.

Each tree's sources hash to the commit's `git archive` (`sources.sha256`). Every run took the 9700X's lock on its own
(`abT.sh`, `abT2.sh`, `abT-stages.sh`).

## Campaign 1: head against base, with an A/A control

`aa` is a copy of base's executable (the same bytes: `inputs.sha256`), run as a third tree. There were three rounds,
the trees in the same order in each. Each round ran `perf stat -r 11` (`-r 5` for `main.c`) of user instructions,
cycles and task-clock. The medians of the rounds (`perf.log`):

| Measure | base | A/A copy | head | head against the A/A copy |
| --- | --- | --- | --- | --- |
| `sqlite3.c -fsyntax-only`, instructions | 959,757,394 | 959,757,700 | 959,273,273 | -484,427 (-0.050%) |
| `sqlite3.c -fsyntax-only`, cycles | 451.359 M | 449.054 M | 451.561 M | +0.56% |
| `sqlite3.c -c`, instructions | 1,238,490,927 | 1,238,491,233 | 1,237,966,559 | -524,674 (-0.042%) |
| `sqlite3.c -c`, cycles | 576.127 M | 574.186 M | 576.318 M | +0.37% |
| `main.c -fsyntax-only`, instructions | 13,371,713,672 | 13,371,719,205 | 13,377,594,446 | +5,875,241 (+0.044%) |
| `main.c -fsyntax-only`, cycles | 5,062.28 M | 5,064.66 M | 5,072.88 M | +0.16% |

The three trees' `sqlite3.c -c` objects are the same, byte for byte (`abT.log`; `inputs.sha256`).

The A/A copy differs from base by up to 0.51% in cycles, though it is the same executable. Head's cycles are within
0.56% of the copy's, so they show no time cost and no time gain. The task-clock medians are 98 ms for `sqlite3.c
-fsyntax-only`, 121 ms for `-c` and 1,019 to 1,021 ms for `main.c` in every tree.

## Where head's fewer instructions on `sqlite3.c` are

Head adds work to `sqlite3.c`'s compile: the static objects' pass tests each attribute record of a declaration that
has any. It still runs fewer instructions. To place the difference, `abT-stages.sh` split the compile by stage, `perf
stat -r 5` of each, one round (`stages.log`):

| Stage (`sqlite3.c`) | base | A/A copy | head | head against base |
| --- | --- | --- | --- | --- |
| `-E -o /dev/null` | 311,965,936 | 311,965,936 | 311,943,104 | -22,832 |
| `parse -fsyntax-only` (the parser's driver) | 172,442,759 | 172,442,763 | 172,420,384 | -22,375 |
| `-fsyntax-only` | 959,757,681 | 959,757,678 | 959,273,806 | -483,875 |

About 22 thousand are in the preprocessor's setup, where head moves `predefines_resolve`'s features into
`predefines_apply`. The other 461 thousand are in checking, which head's code reaches only through
`check_program` and the static objects' pass.

clang compiles those functions differently in the two builds. `symbol-sizes.txt` lists the 107 names whose sizes
differ between base's and head's executables (`nm -S`), each with every copy's size. Among them:

| Function | base | head |
| --- | --- | --- |
| `check_program` | 28,266 bytes | 32,883 bytes |
| `check_program_static_objects` | 1,223 bytes | 346 bytes |
| `check_program_static_object` | 905 bytes | 1,784 bytes |
| `check_input_target_supported` | 3,214 bytes | 923 bytes |

Besides tests and benchmarks, the list's other names are the driver's (`run_check_command_mode`), the lowering's,
`check_program_diagnose` and `check_program_select_mode`, and the preprocessor's setup (`pp_parse_options`,
`pp_predefines`, `pp_run_prelude` and the `predefines_` functions). No function of the parser or of the
preprocessor's main loop is on it. This record doesn't attribute the difference further. A sampling profile (`perf record` of user instructions) was tried. On this host it couldn't resolve a 0.05%
difference, and it isn't part of the record. So the record claims no speed-up, only that the instruction counts move
by these amounts.

## Campaign 2: head2 against head, with an A/A control

`aa2` is a copy of head's executable (`inputs2.sha256`). Head2 was built under its own hold of the lock
(`build_head2.log`), and its `sqlite3.c -c` object is head's (`abT2.log`). The medians of three rounds (`perf2.log`):

| Measure | head | A/A copy | head2 | head2 against the A/A copy |
| --- | --- | --- | --- | --- |
| `sqlite3.c -fsyntax-only`, instructions | 959,273,633 | 959,273,634 | 959,259,491 | -14,143 |
| `sqlite3.c -fsyntax-only`, cycles | 450.834 M | 449.636 M | 448.961 M | -0.15% |
| `main.c -fsyntax-only`, instructions | 13,377,592,768 | 13,377,596,344 | 13,372,966,994 | -4,629,350 (-0.035%) |
| `main.c -fsyntax-only`, cycles | 5,075.89 M | 5,054.25 M | 5,067.19 M | +0.26% |

The A/A copy differs from head by up to 0.43% in cycles, and head2's cycles are within that spread.

Instruction counts are deterministic here. The A/A copies differ from their originals by at most 5,533 instructions,
so the two campaigns compare by instructions. Head2 against base:
- `main.c -fsyntax-only` runs 1,253,322 more instructions (+0.0094%), for its 5,344 target attributes;
- `sqlite3.c -fsyntax-only` runs 497,903 fewer (-0.052%).

## The builds

Each tree built under its own hold of the lock, with `BUSTER_DEBUG_INFO=0`, once each (`build_base.log`,
`build_head.log`, `build_head2.log`): base in 29.8 s, head in 29.9 s and head2 in 30.1 s. Host: Linux
6.18.50-2-lts, clang 23.1.1 (`inputs.sha256`).

## Files

| File | What it is |
| --- | --- |
| `abT.sh`, `abT.log`, `perf.log`, `inputs.sha256` | Campaign 1: the script, its log, `perf stat`'s output, the executables', objects' and inputs' hashes. |
| `abT-stages.sh`, `stages.log` | The stage split of `sqlite3.c`'s compile. |
| `abT2.sh`, `abT2.patch`, `abT2.log`, `perf2.log`, `inputs2.sha256` | Campaign 2: head2's patch, the script and its outputs. |
| `symbol-sizes.txt` | Each name whose sizes differ between base's and head's executables: the name, then base's and head's sizes (bytes, every copy's, comma-separated). |
| `sources.sha256` | Each tree's sources hashed (`find . -type f`, sorted, `sha256sum`, hashed again), and the commit they match. |
| `build_*.log` | The builds' reports. |
