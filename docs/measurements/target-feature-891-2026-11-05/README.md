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

`-E` still enters `main_unit_checker` during command dispatch before falling
back to preprocessing. The control excludes the target-feature **code-generation
check**, not every instruction in the checker translation unit.

A second bounded `-E` control used **the same executable path and argv** for
each compiler, copying the respective binary to that path before its separate
locked run. Base counted 197,340,294 instructions and head 197,352,637
(+12,343, +0.006255%); the preprocessed output hash matched the one above in
both runs. The respective copied executables' hashes matched their original
binary hashes. This reproduces the preprocessing delta and makes differing
executable-path spelling an unlikely explanation for it. It does not identify
the cause of the full `-c` delta.

The two builds' `main_unit_frontend.c.o` files were byte-identical (SHA-256
`7662f57b2f9d7b992242fff118bce31ad17b6b8530f314557d48ab20e0f63462`), as
were `main.c.o` (SHA-256
`12f6df8282f2d5016d24bfe01a7f7267c18786f4e93ce679acabb823005a50cf`);
`main_unit_checker.c.o` differed. The `-E` observation and these object hashes
are consistent with indirect link or runtime-layout effects, but do not prove
which effect caused the delta.

## Hybrid attribution control

One diagnostic build used head `5929d0e2` including its tests, but substituted
the exact `src/buster/compiler/c_check_target_feature.c` from base `441db242`
before building. Its SHA-256 is
`59626d6a29c7a4b55eff7dfa496c32344ffcf30b9d91b86c0adb0fdb8e07c0f2`.
The substituted file's SHA-256 was
`636401d06a8fcded081bbc3b0a44d43fcd0b66b6990adf743429c0ea1bec77f2`.
The source was restored after this build and the original head binary restored;
the hybrid is not a PR commit or a correctness-qualified compiler. The build
used the same Clang, Release, architecture and debug settings as above; its
[build log](raw/hybrid-build.log) is retained.

In the isolated head checkout, the substitution was made with
`git show 441db2428d2bd8d28503037b28c1b3740fe4b25a:src/buster/compiler/c_check_target_feature.c`,
then built using `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh
--jobs 4` under one lock grant. The pre-existing head binary was saved before
the build, and the resulting hybrid binary saved before restoration. The
intermediate build directory contains hybrid objects and must be rebuilt
before reuse as a head build.

The base, hybrid and head binaries were copied in turn to the same executable
path and each ran `-E` and `-c` once using the same options, input, output
path, CPU, event and individual lock grants as above. All `-E` output hashes
matched each other and all `-c` object hashes matched each other. These are
single-sample attribution controls, not repeated performance measurements.

| Mode | Base | Hybrid | Head |
| --- | ---: | ---: | ---: |
| `-E` | 197,340,288 | 197,334,948 | 197,352,640 |
| `-c` | 1,971,930,833 | 1,971,925,537 | 1,971,990,752 |

The production-file substitution changes the measured binary and correlates
with the difference; it does not distinguish executed startup/dispatch code
from indirect code or data placement effects. All three binaries are ET_EXEC
with 252 `.rela.dyn` entries. The hybrid and head `main_unit_checker` symbols
have the same address (`0x10587d0`) and size (`0x11ef`); inspection shows
the same dispatcher instruction sequence with relocated addresses changed,
including some strings shifted by 32 bytes. The no-attribute target-feature
early path in the head has one fewer load than the hybrid. These observations
do not establish the cause of the whole-process instruction delta. The raw
control counters are [here](raw/).

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

For the second `-E` control, the base and then head compiler were copied to
one shared `same/compiler` path. Each was run under its own lock grant as
`taskset -c 2 perf stat -x, -e instructions:u -- same/compiler -E` followed
by the same `-D`, `-I`, input and output options as above, with the same
`same/output` path. The two raw receipts are `base-same-E.perf` and
`head-same-E.perf`; both records report 100% event running. The single pair
is diagnostic evidence, not a repeated measurement of variability.

No instrumentation or code changes were made for these counts. The current
source retains an early return when target-attribute keys and the x86 builtin
count are absent; assembly around that return differs in register and stack
setup between these two binaries. No causal claim follows from that inspection.
