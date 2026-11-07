# #1374: the bit builtins as one instruction each, on the 9700X

Record for [buster#1651](https://github.com/buster14a/buster/pull/1651), which fixes
[buster#1374](https://github.com/buster14a/buster/issues/1374) and the byte-swap half of
[buster#1385](https://github.com/buster14a/buster/issues/1385): `__builtin_ctz*`, `clz*`, `popcount*`, `parity*`,
`ffs*` and `bswap16/32/64` become an `X86` row of their instruction by the function's target (`bsf`/`tzcnt`,
`bsr`+`xor`/`lzcnt`, `popcnt`, `bswap`), which the IR takes as pure intrinsics, in place of SWAR recipes.

## Sources and builds

- base: buster `c3fcc7e236bc860096f8ced8c455ef9568766c7c` (main);
- head: buster `8570c6bbfd695da560247591cc5a09ef908198f2` (the PR's code commit; its later commit `5cddc761` changes
  documentation only).

Each tree is `git archive` of its commit (`scripts/build-trees.sh`), built with `BUSTER_HOST_ARCH=znver5
BUSTER_DEBUG_INFO=0 ./build.sh` in one lock hold per build (`base-c3fcc7e2.build.log`, `head-8570c6bb.build.log`).
`host.txt` has the kernel, clang 23.1.1, CPU 2's governor and EPP (`performance`), both commits and the SHA-256 of
both compilers and every kernel binary and object.

## The kernels

`scripts/kern.c` has the issue's kernel, `kernel(x) = __builtin_popcountl(x) + __builtin_ctzl(x | 1) +
__builtin_clzl(x | 1)`, and the comment's, `swaps(x) = __builtin_bswap32(x) ^ (unsigned)__builtin_bswap64((unsigned
long)x << 7)`. `scripts/drv.c`, compiled once by clang -O2, calls each 20 M times on a xorshift sequence and prints
the best of 5 repetitions of each loop. `scripts/prepare.sh` (one lock hold) compiles `kern.c` by each tree's
compiler, by Tier 0 (`-c`) and Tier 1 (`--tier1 -c`), at `-march=x86-64`, `x86-64-v3` and `znver5`, and by clang
23.1.1 `-O0` and `-O2` at the same targets, each linked with the same driver object.

`scripts/measure.sh` runs every binary once per round on CPU 2 (`taskset -c 2`), all of a round in one lock hold, in
an order that rotates by round. Three rounds ran (`results/round-0.txt` to `round-2.txt`); a fourth was stopped
while it waited for the lock, as the rounds varied by at most 0.5 ms. `results/holds.txt` has each hold's own line of
the lock's owner file. `kernels.tsv` has each binary's three rounds and their median:

| `kernel`, ms | main Tier 0 | main Tier 1 | PR Tier 0 | PR Tier 1 | clang -O0 | clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `x86-64` | 90.8 | 84.2 | 35.7 | 33.6 | 29.7 | 25.9 |
| `x86-64-v3` | 90.8 | 84.2 | 21.9 | 21.6 | 22.2 | 21.6 |
| `znver5` | 90.8 | 84.2 | 21.9 | 21.6 | 22.2 | 21.6 |

| `swaps`, ms | main Tier 0 | main Tier 1 | PR Tier 0 | PR Tier 1 | clang -O0 | clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `x86-64` | 44.2 | 42.9 | 21.6 | 21.6 | 21.6 | 21.7 |
| `x86-64-v3` | 44.4 | 42.9 | 21.8 | 21.6 | 21.6 | 21.6 |
| `znver5` | 44.3 | 42.9 | 21.8 | 21.6 | 21.6 | 21.8 |

The driver's loop alone (the xorshift step's dependency chain and the call) takes about 21.6 ms: clang -O2's
`x86-64-v3` kernel, six instructions, takes no more. The PR's kernels at `x86-64-v3` and `znver5`, and its byte swaps
at every target, hide behind it as clang's do; at `x86-64`, popcount is still the recipe (no POPCNT), as clang -O0's
is a sequence too.

`instructions.tsv` counts each kernel's instructions in its object (`objdump -d`, without padding):

| | main Tier 0 | main Tier 1 | PR Tier 0 | PR Tier 1 | clang -O0 | clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `kernel`, `x86-64` | 188 | 120 | 62 | 40 | 36 | 26 |
| `kernel`, `x86-64-v3` | 188 | 120 | 16 | 11 | 17 | 6 |
| `swaps`, any target | 98 | 58 | 10 | 7 | 12 | 6 |

## Compile time

`scripts/compile.sh` (its generated `results/sqlite.sh` and `results/main.sh`, each one lock hold) compiles the
frozen `sqlite3.c` (SHA-256 in `results/sqlite.txt`) with the 9700X workflow's `compile_time` options (`-c
-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`, the default
`x86-64` target) and the same with `-march=znver5`: 11 alternating whole processes per tree with `--time-stages`
(`results/stages/`), then `perf stat -r 11` of each (`results/perf-sqlite-*.csv`). Every compile exited 0.

| sqlite3.c `-c` | main | PR |
| --- | ---: | ---: |
| default target: wall, median of 11 | 132.57 ms | 132.46 ms |
| default target: user instructions (perf, mean of 11) | 1,402,188,323 | 1,402,169,514 |
| default target: user cycles | 628.45 M | 628.30 M |
| `-march=znver5`: wall | 132.50 ms | 132.38 ms |
| `-march=znver5`: user instructions | 1,402,343,914 | 1,402,324,854 |
| `-march=znver5`: user cycles | 630.10 M | 629.46 M |

The compile's time doesn't change: the unit has one of these builtins (a `__builtin_clzll`), and the PR's typed
stream for it is shorter. `--time-stages`' medians are within 0.1 ms of each other in every stage (`lower`
10.51 → 10.56 ms, `tier0` 5.19 → 5.18 ms); `check_lower_bits_row` is out of line, called from the lowering's rare
path (`check_lower_expand_rare`). The objects differ only by that call's code: `.text` is 1,557,569 bytes by main
and 1,557,313 by the PR at both targets.

The compiler's own `main.c`, `-c` with its znver5 build's flags (`results/main-flags.txt`) on one lane, 3
alternating processes per tree: main 2,615, 2,318 and 2,237 ms, the PR 2,453, 2,230 and 2,194 ms (each tree's first
run the slowest); `.text` 1,923,399 → 1,917,679 bytes. Three runs don't establish a difference in its time.

A first `compile.sh` failed before these (`results/failed-sqlite.txt`, `results/failed-main.txt`, holds at 11:43
and 11:50): it passed `--no-default-config`, which the C driver doesn't take (a test command's option), and a glob
matched a build log beside the tree, so `main.c`'s flags were empty. Those runs measured nothing; the fixed script
replaced the generated scripts and their outputs.

## Limitations

- The kernels are synthetic loops of the issue's shape; programs whose time isn't in these builtins don't change.
  The driver's floor hides how much faster than clang -O0 the PR's code is where both are under it.
- One host (the 9700X), one clang (23.1.1), CPU 2 only; three rounds of one process per binary, each the best of 5
  repetitions.
- The lock-wait messages that `exclusive.sh` writes (other sessions' commands, some of many lines) are removed:
  from the build and run logs by their `exclusive.sh: waiting` and `title:`/`link:`/`pull request:` lines, and from
  `results/sqlite.txt`, `main.txt` and the `failed-*.txt` by keeping only the lines the scripts and the compilers
  print. Each log is otherwise as written. `scripts/chain.sh` ran `prepare.sh`, `measure.sh` (stopped after its
  third round) and the first `compile.sh`; the fixed `compile.sh` ran alone after it.
