# Value numbering with memory: re-measurement and forwarding policies (#2826)

Ryzen 7 9700X (`benchpress`), each run under `~/buster-fast-bench/exclusive.sh`, pinned to CPU 2, Release builds,
the 9700X job's Clang 23.1.4. Busy processes and `/proc/loadavg` before and after each run are in its log.

Trees:

- `main`: buster14a/buster `9ba3d792b53928a584bd067fe8579fe26e247218`.
- `br`: `99c559b633bff1b3a38217138732aeeca97b548a` (branch `claude/memory-vn-policy-2826`: one root per symbol, early
  exits, compressed derivation).
- `exp`: `main` plus `scripts/exp2.patch`, the branch's pass with a temporary forwarding-policy switch
  (`--tier1-memory-policy=N`, standing for `--tier1-passes=+memory` under policy bits N). It never went into a commit.

Inputs: the 9700X corpus's `sqlite3.c` (sha256 `0a409f16…e23d`), SQLite's `speedtest1.c` (sha256 `b5eaf4bb…9675`),
Lua 5.4.8 and the five scripts of buster-performance `818cfbbc0be238da287c16d8e2a91fd7275cf228`'s
`tier1-reciprocal-141-2026-11-01/9700x/lua`.

## Run time: `measure-tier1-programs --runs 11`

User cycles, each variant over `--tier1` without the pass in the same run.

`9700x/main-programs.log` (main, `--variant --tier1-passes=+memory --variant --tier1-passes=+memory,+gvn`):

| Variant | speedtest1 | Lua's five scripts |
| --- | ---: | ---: |
| `+memory` | 0.9940 | 0.9934 |
| `+memory,+gvn` | 1.0111 | 1.0395 |

Policies (`9700x/polA.log`, `9700x/polB.log`, the `exp` tree). Policy bits: 1 no forwarding from a load across blocks;
2 no forwarding from a load at all (stores' values only); 4 no forwarding from a store across blocks; 8 no forwarding
from a load whose single user is an integer operation that could fold it; 16 no forwarding across a call.

| Policy | speedtest1 | Lua's five scripts | Lua instructions |
| --- | ---: | ---: | ---: |
| 0 (the pass as it is) | 0.9881 | 0.9815 | 1.0183 |
| 16 | 0.9806 | 0.9828 | 1.0179 |
| 8 | 0.9814 | 0.9882 | 1.0193 |
| 24 (8, 16) | 0.9842 | 0.9937 | 1.0191 |
| 1 | 0.9879 | 0.9950 | 1.0008 |
| 9 (1, 8) | 0.9769 | 0.9932 | 0.9992 |
| 2 | 0.9897 | 1.0004 | 1.0006 |
| 5 (1, 4: within a block) | 0.9877 | 1.0102 | 0.9998 |

Policy 16 forwards nearly what policy 0 does (a call already writes general memory; only private slots' values crossed
one). An earlier run in which, by a bug of the switch, all four variants took policy 8 measured four identical builds at
0.9892, 0.9937, 0.9908 and 0.9916 (speedtest1) and 0.9919, 0.9915, 0.9906 and 0.9835 (Lua): about 1% between equal
builds. No restriction beats the pass as it is beyond that; forwarding only stores' values, or only within a block,
loses Lua's gain.

## Kernels: `time-runs --runs 11` (`scripts/kernels.sh`)

User cycles, M (`9700x/kernels-main.log`, `9700x/kernels-br.log`); each kernel's loads forwarded by `+memory` on the
branch: m1 3, m2 2, m3 1, m4 0 (main: 3, 2, 0, 0).

| Kernel | clang -O2 | `--tier1` | `+memory`, main | `+memory`, branch |
| --- | ---: | ---: | ---: | ---: |
| m1: a struct's fields read twice | 304.1 | 318.0 | 319.0 | 319.0 |
| m2: a field stored, then read | 200.2 | 217.6 | 205.1 | 205.1 |
| m3: #3309's globals | 187.8 | 200.2 | 200.2 | 137.6 |
| m4: an element stored, then read at a recomputed index | 209.2 | 273.2 | 273.2 | 273.2 |

m3's code under `--tier1` depends on its placement (#3309's record `store-motion-3309-2026-11-22` measured one object at
272M and 400.2M cycles); the branch's object is one placement.

## Compile time: `measure-compile --runs 11 --variant --tier1-passes=+memory`

`-c --tier1 --lanes 1` of `sqlite3.c` (`9700x/main-compile.log`, `9700x/br-compile.log`):

| Tree | Default, ms | `+memory`, ms | Ratio | User cycles, M (default, `+memory`) |
| --- | ---: | ---: | ---: | ---: |
| main | 603.6 | 622.4 | 1.031 | 3245.3, 3348.7 |
| branch | 604.0 | 622.7 | 1.031 | 3247.6, 3350.5 |

The branch's early exits and compressed derivation don't change the pass's cost measurably.
