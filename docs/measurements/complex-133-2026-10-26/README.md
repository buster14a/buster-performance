# The _Complex lowering's cost on code without complex values

2026-10-26, for [buster14a/buster#133](https://github.com/buster14a/buster/issues/133):
what lowering `_Complex float`, `double` and `long double` costs a unit that
has none, measured on SQLite's amalgamation compiled with `-c`.

## Revisions

- main: `18d4c3be9db9b079480df864b62a4a6fb2d3a207`.
- the branch: `d287c9739b5799dffce52849ab7cbc6cbe8a54d1` (`claude/133-complex-lowering`, main merged), whose later
  commits change only documentation.

`manifest-*.sha256` list every file of `build.sh`, `src` and `tests` of each
commit's `git archive`; the trees measured on the 9700X matched them byte for
byte (sorted with `LC_ALL=C`). Built with `BUSTER_DEBUG_INFO=0 ./build.sh` by
clang 23.1.1 (`main/build.log`, `branch/build.log`); `build/compiler`'s
sha256: main `dd0199f7307daa8fa3af5f8d1b890bd636bf4653e1d80e583295bdfe1e04fcb3`,
branch `3d187bcf965927534418b08b991dac27465ff5c4e475301f6c96ef71ea4599db`.

## Input and host

SQLite 3.53.2's `sqlite3.c` of the frozen corpus
`preprocessor-corpora-astra-01a158dd` (sha256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`), on the
AMD Ryzen 7 9700X (Linux 6.18.50-2-lts).

## Commands

`cx-ab.sh` synced and built both trees, each build under its own hold of the
shared lock, then ran `complex-proc.sh` there: `taskset -c 2 ./build/compiler
time-runs --runs 21 --warmups 3 --list -c -I$Q -o OUT $Q/sqlite3.c`, whole
processes of each tree's compiler, two rounds, main's and the branch's in turn,
each run its own hold of the lock (`main/sqlite-*.log`, `branch/sqlite-*.log`).

## Results

| | main | branch |
|---|---|---|
| `sqlite3.c` compiled with `-c`, median of 21 | 191.096 / 191.463 ms | 191.497 / 191.415 ms |
| peak resident set | 710,064 / 711,036 KB | 710,268 / 710,324 KB |
| minor faults | 1,562 / 1,547 | 1,567 / 1,566 |

Round 1 / round 2. The difference of the rounds' medians, +0.18 ms (0.1%), is
within main's own spread between rounds (0.37 ms).

## Limitations

- One input, without complex values: the cost measured is what the lowering's
  new branches add to code that never takes them. The complex operations'
  own code is checked against clang's results, not timed.
- The lock's messages ("exclusive.sh: waiting" and their title, link and pull
  request lines) were removed from the logs; nothing else was changed.
