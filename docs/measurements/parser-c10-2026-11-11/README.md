# Parser changes of package C10 (#1447): base against head, 2026-11-11

`benchmark-parser` on `src/buster/compiler/main.c` (2,350,245 tokens), on the
Ryzen 7 9700X (`benchpress`). Each build and each run was under
`~/buster-fast-bench/exclusive.sh`, the runs pinned with `taskset -c 2`, with
three rounds alternating base and head. The command, from each checkout:

```sh
./build/compiler benchmark-parser -march=native -Isrc -fwrapv -funsigned-char --predefines ../predefines.h src/buster/compiler/main.c
```

`run.sh` is the harness, run as `./run.sh BASE HEAD-BRANCH`. Its clang is
benchpress's `clang version 23.1.1`, which made both builds and the predefines.
The raw outputs are `1867-array-comma.log` and `1968-function-roles.log`.

| Change | Base | Head | Binaries (sha256, base / head) |
| --- | --- | --- | --- |
| buster#2127 (#1867): no comma in an array's size or a designator's index | `d43c37e5192d7e5d62df822aa2ce5c1f3facb5ca` | `f81d11d3242d6e95794aff5b657311eeb833c884` | `765a9608…` / `7971a74f…` |
| buster#2174 (#1968): a parameter list's parentheses a function's on the vector path | `d43c37e5192d7e5d62df822aa2ce5c1f3facb5ca` | `7fe466f8acf6a4c276d79c9b21eb15c8f1583c48` | `d9ed953e…` / `f664c5c7…` |

The table gives the medians per token, in cycles (one cell per round) and in
instructions (round 1).

| Row | #1867 base | #1867 head | #1968 base | #1968 head |
| --- | --- | --- | --- | --- |
| vector path, cycles | 30.76 30.71 30.87 | 31.10 31.03 30.91 | 30.67 30.99 30.86 | 30.57 30.69 30.53 |
| vector path, instructions | 58.516 | 58.560 | 58.516 | 58.921 |
| vector K6, cycles | 9.38 9.29 9.26 | 9.19 9.57 9.08 | 9.11 9.36 9.52 | 9.17 9.17 9.05 |
| twins, cycles | 130.6 130.3 131.1 | 132.6 133.1 133.0 | 130.4 130.9 131.0 | 139.2 139.0 138.6 |

**Reading:**
- **#1867:** it changes only the check tables' contents on the vector path (one more mode and group). Instructions rise by 0.04 a token, and the vector path's cycles by 0.25 (0.8%), within the spread of other runs on this host.
- **#1968:** it adds K6's masked store of each opener's and closer's group, and a masked rewrite of a parameter list's roles in the loop after K6. That costs 0.4 instructions a token (0.7%) on the vector path, with no rise in cycles. The twins pipeline (a test oracle, not the vector or scalar product path) rises by 8 cycles a token from its scalar loop.
- **Limits:** one file and three rounds a build. The 9700X was shared with other sessions' locked runs between rounds.
