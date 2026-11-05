# Target-feature no-attribute instruction check (#891)

On 2026-11-05, this bounded comparison measured the whole `-c` process for
the frozen SQLite input at Buster base `441db2428d2bd8d28503037b28c1b3740fe4b25a`
and [PR #1313](https://github.com/buster14a/buster/pull/1313) head
`5929d0e2e2ab5a179313c082811b59a3ccdd0e0d`. Both worktrees were clean.
This is a no-attribute acceptance check, not a general performance claim.

| Run | Base instructions:u | Head instructions:u |
| --- | ---: | ---: |
| 1 | 1,971,930,769 | 1,971,990,665 |
| 2 | 1,971,930,768 | 1,971,990,672 |
| 3 | 1,971,930,773 | 1,971,990,669 |
| Median | 1,971,930,769 | 1,971,990,669 |

The head median is **59,900 instructions higher (+0.003038%)**. All six
objects had SHA-256 `0984876ace77767114de6bedfcad11c2a43ba948fa4d10c56c57f9fb946aa8c7`.
This does not establish the literal zero instruction delta requested by #891.

As one bounded control, a single `-E` run per binary with the same input and
preprocessor options counted 197,340,285 base and 197,352,766 head
instructions (+12,481, +0.006325%). Both outputs had SHA-256
`4128ed06980ed08d97638c123d840ce2569b133404a674f4da59ca61e367b59b`.
Target-feature code-generation checking does not execute in `-E`; this control
shows part of the difference arises outside that check, but does not explain
the rest or prove the cause is binary layout. It is a single pair, not a
statistical performance comparison.

## Method and identities

- Linux x86-64, Ryzen 7 9700X, microcode `0xb404038`, kernel
  `6.18.50-2-lts`; CPU 2 pinned with `taskset`, governor `performance`.
- Clang 23.1.1 (`/usr/bin/clang-23` SHA-256
  `939a882527432ec23b094c289e7f170bf2d6ec282e74dde75e31b08602fa3eae`),
  Release O3, `BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`. Base compiler
  SHA-256 `265f2c48fa5923413eb206d87adff2d7c208a05c076d79f90fede01fa293c0dc`;
  head compiler SHA-256 `0ac7499a4a607d0a74d43b9c4734089877a2d81f72831dcd14c32c340f460fea`.
- Frozen `sqlite/sqlite3.c` SHA-256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
  Preprocessing with the base compiler and the measured options produced the
  hash above. Text searches found no `target(`, `__target__`, `target_clones`,
  `cpu_specific`, `cpu_dispatch`, or `__builtin_ia32` in that output.
- Options, in order: `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
  -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<sqlite-directory>
  <sqlite-directory>/sqlite3.c -o <same-output-path>`. The `-E` control used
  the same preprocessor options and input with `-E` instead of `-c`.
- Each process used its own shared 9700X lock grant and `perf stat -x, -e
  instructions:u`; each event ran for 100% of its measured interval. Sample
  order was base/head, head/base, base/head. [Raw perf outputs](raw/) and the
  [comparison script](compare.sh) are retained. The script names the original
  workspace paths; adjust them to reproduce. The separate `-E` control used
  the same locking, CPU and event as the script.

No instrumentation or code changes were made for these counts. The current
source retains an early return when target-attribute keys and the x86 builtin
count are absent; assembly around that return differs in register and stack
setup between these two binaries. No causal claim follows from that inspection.
