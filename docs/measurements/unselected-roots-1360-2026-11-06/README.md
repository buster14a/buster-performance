# #1360 and #1341: static selections' unselected roots in one pass, 6 November 2026

Evidence for the buster branch
[`opencode/1360-unselected-roots`](https://github.com/buster14a/buster/tree/3fcb8033675779f1511854d6c801bc910484ded1)
(head `3fcb8033`), which addresses [buster#1360](https://github.com/buster14a/buster/issues/1360) and
[buster#1341](https://github.com/buster14a/buster/issues/1341). `check_common_unselected_roots` walked back from every
`SELECT` node's token to its keyword and then visited every graph node, so a unit was quadratic in its selections. The
reader makes every `__extension__` a `SELECT`, and glibc's `assert` expands to one in each GNU mode. The branch finds
every selection's range in one pass instead. This record measures it against its base, `main` at `866e087a`.

Every timing and counter here is from the Ryzen 7 9700X (`benchpress`), CPU 2 (governor and EPP `performance`,
[`host.txt`](host.txt)), each round of runs inside one hold of the shared lock (`exclusive.sh`). The correctness runs
were on the owner's Ryzen 9 7940HS, under its `cores` queue (below).

## Sources

| Name | Revision | What |
| --- | --- | --- |
| `base` | buster `866e087abddd9327552801cc1e43fa82163755ed` | `main`, the branch's parent |
| `head` | buster `3fcb8033675779f1511854d6c801bc910484ded1` | the branch: the one-pass `check_common_unselected_roots` |

[`scripts/build-trees.sh`](scripts/build-trees.sh) made each tree with `git archive COMMIT | tar -x` into a fresh
directory with a `COMMIT` file, and built it with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh` inside one
hold of the lock ([`base-866e087a.build.log`](base-866e087a.build.log),
[`head-3fcb8033.build.log`](head-3fcb8033.build.log)). [`host.txt`](host.txt) has the kernel, clang 23.1.1, perf, the
governor and the SHA-256 of each executable.

## Workloads and method

[`scripts/measure.sh`](scripts/measure.sh) runs 7 rounds, one lock hold each ([`holds.txt`](holds.txt): the lock's owner
line at the start of each round, ours). In each round [`scripts/round.sh`](scripts/round.sh) runs every workload by both
builds, the order alternating by round and workload, each process as
`perf stat -x, -e instructions:u,cycles:u taskset -c 2 COMPILER ARGS -o OUT --time-stages`. Pinned to one CPU, the
driver's lane session takes one lane. `wall` is the time around that command (perf included); `total` and
`check-program` are the compiler's own `--time-stages` lines. [`results.tsv`](results.tsv) has every run with its exit
status (all 0); [`summary.md`](summary.md), made by [`scripts/summarize.py`](scripts/summarize.py), has the medians and
ranges.

- `sq-ci`: the frozen corpus's sqlite3.c (SHA-256 in [`inputs.sha256`](inputs.sha256)) with CI's options,
  `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`; `sq-ci-w` adds
  `-w`.
- `sq-debug`: the same with `-DSQLITE_DEBUG`, which keeps its 6,032 asserts (#1360's first table); `sq-debug-w` adds
  `-w`. `base`'s `sq-debug` ran in rounds 1 to 3 alone (6.3 s each).
- `self`: the compiler's own `main.c`, preprocessed once by `base`'s build (`-E -march=znver5 -Isrc -fwrapv
  -funsigned-char -fno-strict-aliasing --predefines`, [`self-main.i.source`](self-main.i.source)), compiled
  `-fsyntax-only --predefines predefines-znver5.h -march=znver5 -fwrapv -funsigned-char -fno-strict-aliasing`, #1341's
  command.
- `asserts-N`: one function of N `assert(x != i);` after `#include <assert.h>`, `-c` (#1360's scaling table).
- `generic-N`: N functions, each `int y = _Generic(x, int: x + 1, long: x - 1, default: 0);`, `-fsyntax-only` (#1341's
  scaling unit).
- `lua`, `lua-w`, `lua-assert`, `lua-assert-w`: Lua 5.4.8's 34 files, each `-c -std=gnu99 -DLUA_COMPAT_5_3
  -DLUA_USE_LINUX`, with `-w`, `-DLUAI_ASSERT` (which makes `lua_assert` glibc's `assert`, #1360's second table) or both,
  by [`scripts/lua-all.sh`](scripts/lua-all.sh). Its `total` and `check-program` are the sums over the files; its
  `wall` includes the wrapper's shell and awk processes, 34 times, so read `total` there.

## Results

Medians of the rounds ([`summary.md`](summary.md) has the ranges and the cycles):

| workload | base total ms | head total ms | head/base | base check-program ms | head check-program ms | base user instructions | head user instructions |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| sq-debug | 6,321.3 | **235.8** | 0.037 | 6,132.3 | 46.2 | 97,610.6 M | 2,757.5 M |
| sq-debug-w | 203.0 | 203.2 | 1.001 | 16.3 | 16.4 | 2,422.7 M | 2,422.7 M |
| sq-ci | 140.6 | 139.1 | 0.990 | 28.4 | 26.8 | 1,643.2 M | 1,625.9 M |
| sq-ci-w | 119.4 | 119.6 | 1.002 | 10.2 | 10.2 | 1,442.4 M | 1,442.4 M |
| self | 3,220.1 | **1,962.9** | 0.610 | 1,555.1 | 301.0 | 49,280.9 M | 28,878.5 M |
| lua-assert | 246.3 | 198.8 | 0.807 | 73.7 | 24.5 | 3,931.5 M | 2,201.1 M |
| lua-assert-w | 179.6 | 179.9 | 1.002 | 8.5 | 8.6 | 2,005.2 M | 2,005.2 M |
| lua | 190.5 | 189.4 | 0.994 | 18.0 | 18.1 | 1,727.4 M | 1,726.6 M |

The scaling tables' `check-program` (ms):

| N | asserts, base | asserts, head | `_Generic`, base | `_Generic`, head |
| ---: | ---: | ---: | ---: | ---: |
| 1,000 | 19.2 | 0.9 | 4.5 | 0.6 |
| 2,000 | 74.6 | 1.7 | 16.7 | 0.8 |
| 4,000 | 295.2 | 3.4 | 65.5 | 1.9 |
| 8,000 | 1,176.5 | 7.1 | 258.8 | 4.3 |

`base` multiplies by 3.9 to 4.0 per doubling of N; `head` by 1.9 to 2.3. The whole asserts-8000 compile went from
1,223.4 to 54.6 ms, generic-8000's from 291.3 to 37.5 ms.

- **sqlite3.c's debug build** goes from 6.32 s to 236 ms: 26.8× faster. (#1360 measured 12.3 s at `ef25f566`; main's
  later commits had halved it by `866e087a`.) Its gap to `-w` is now 32.6 ms (+16%), 29.8 ms of it in `check-program`
  (46.2 against 16.4 ms). The default build has the same kind of gap (139.1 against 119.6 ms, 16.6 ms
  of it in `check-program`): it is the common warnings' linear cost over a unit whose debug code makes it larger, #1340's
  subject, and no longer anything per assert (asserts-8000's `check-program` is 7.1 ms).
- **The compiler's own `main.c`** goes from 3.22 to 1.96 s, its `check-program` from 1,555 to 301 ms. #1341's reference
  before #1049 was 1,442 ms with 101.7 ms in `check-program` and 885 ms in `check-input` (at `aca9e53a`); `check-input`
  is now 1,187 ms on both builds here (#1489), and a local profile of what is left in `check-program` has
  `-Wswitch`'s enumerator scan (#1348) as its largest common-warning line.
- **The default build** (`sq-ci`) runs 1.06% fewer user instructions and 1.6 ms less `check-program` (its 5 selections'
  walks); `total` moves by −1.1%, within one round's spread of `base`'s. The `-w` rows don't run the pass, and match.
- **Lua with assertions** goes from 246.3 to 198.8 ms (the sum over its 34 files), within 10.5% of its `-w` build's
  179.9 ms, where `base` was 37% over it.

## Outputs

[`compare.txt`](compare.txt), from [`scripts/compare.sh`](scripts/compare.sh) on round 1's outputs: every workload's
diagnostics (the stage clock's lines aside) are the same lines from both builds (88 lines for `self`, sqlite3.c's
`-Wempty-body` warning and note), and every object written (`sq-*`, `asserts-*`) is byte-identical. [`stages/`](stages)
has round 1's standard error of each run.

## Correctness (7940HS)

On the owner's Ryzen 9 7940HS (Zen 4, full AVX-512), with the head's native build and a baseline `x86-64` build of the
same commit (the scalar host path):

- `test-checker-driver --executable build/compiler --part K/4`, K = 1 to 4: 7,131, 29,873, 8,870 and 12,549 checks, 0
  failures (`base`: 7,125 in part 1, 0 failures; the 6 more are the new section's). Part 1 by the `x86-64` build: 7,131
  checks, 0 failures.
- `test-checker --seed 133`: 767,882 checks, 0 failures.
- `-fsyntax-only -Wall -Werror` of `src/buster/compiler/main.c`: status 0, its diagnostics the same as `base`'s.

## Limitations

- One machine, one CPU, 7 rounds (3 for `base`'s `sq-debug`). The Lua rows' wall times include the wrapper's processes.
- `round.sh` exits 1 after round 1 because its last test (`[[ -f $obj ]]` for a Lua workload, which writes no object)
  is false: [`measure.log`](measure.log)'s "round 1 failed" is that, not a run's failure. Every run's status is in
  [`results.tsv`](results.tsv), all 0.
- The rounds waited for CI jobs between them; each round's own runs held the lock throughout. The logs here drop
  `exclusive.sh`'s waiting messages (the holders' lines), nothing else.
- `self-main.i` is `base`'s `main.c` preprocessed by `base`: both builds compile the same input, which is not `head`'s
  own source (it adds a test file and changes `c_check_common_warnings.c`).
