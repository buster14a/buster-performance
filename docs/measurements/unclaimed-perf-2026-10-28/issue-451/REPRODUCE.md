# Reproduce the rejected #451 experiment

Frozen source: baseline `4165454ebadf9b96c2b40ab99c55f4c0b28ba975`, prototype
`68e113ee445af2a80296412a2b8791d3bf9098a6`. Build each with the unchanged
repository `build.sh`, `BUSTER_DEBUG_INFO=0`, native Clang. Every native build,
test, timed run and packaging operation takes the existing shared lock:

```text
EXCLUSIVE_OWNER=codex-perf451
EXCLUSIVE_TITLE=<specific bounded run>
EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/451
~/buster-fast-bench/exclusive.sh COMMAND...
```

The target campaign root is `~/buster-fast-bench/unclaimed-perf-20261028`.
Build directories are `base-4165454e` and `issue-451-68e113ee`. The source is
staged from exact `git archive` outputs. Existing baseline binary identities
and the new candidate's hashes are in `native/451-qa-provenance.txt`.

From that root, define the common preprocessing arguments as:

```text
-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
-DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17
--predefines corpus/gnu17-pinned-predefines.txt --clang-features
--target=x86_64-linux-gnu -march=znver5 -nostdinc
-isystem corpus/headers/usr/lib/clang/23/include
-isystem corpus/headers/usr/local/include
-isystem corpus/headers/usr/include -Icorpus/sqlite corpus/sqlite/sqlite3.c
```

The original `lexer_facts_bench.c` includes the frozen tree's `c_lexer.c`:

```text
clang -std=gnu17 -O3 -march=native -fwrapv -funsigned-char
  -fno-strict-aliasing -Wall -Wextra -Werror
  -Iissue-451-68e113ee/src/buster/compiler
  451-qa-method/lexer_facts_bench.c -o 451-qa-method/lexer_facts_bench-68e113ee
```

Run it twice through the lock on CPU 2, once with final argument `0` and once
with `100` for milliseconds of scalar conditioning before every sample:

```text
taskset -c 2 ./451-qa-method/lexer_facts_bench-68e113ee corpus/sqlite/sqlite3.c 0
taskset -c 2 ./451-qa-method/lexer_facts_bench-68e113ee corpus/sqlite/sqlite3.c 100
```

The seven-pair preparation comparison uses equal-length copies under
`451-qa-exec`: `base000` and `head000`; the independent A/A uses `base001`
and `base002`. Copy and verify these binaries under the shared lock. Then run
the built-in controller outside the lock; its `--lock` takes it separately for
each benchmark process, as the repository's profiling protocol specifies:

```text
./base-4165454e/build/compiler ab --rounds 7 --cpu 2
  --lock /home/david/buster-fast-bench/exclusive.sh
  ./451-qa-exec/base000 ./451-qa-exec/head000 --
  benchmark-preprocessor --only vectorized COMMON_ARGUMENTS
```

Repeat with `base001`/`base002` for A/A. All processes get the owner/title/link
environment above. Use `phase_stats RAW_LOG head000` or `base002` to read them.

Whole-process A/B and A/A each run three separate fresh-copy rounds. The
controller takes the shared lock for each `time-runs` process. Each inner
`time-runs` has exactly two roles and one homogeneous argument list, so its
two-slot rotation is A/B then B/A. Every round creates a new equal-length-path
copy of each executable:

```text
./base-4165454e/build/compiler ab --rounds 3 --cpu 2
  --lock /home/david/buster-fast-bench/exclusive.sh
  ./base-4165454e/build/compiler -- time-runs --runs 21 --warmups 2 --copies 1
  --build base ./451-qa-exec/base000 --build other ./451-qa-exec/head000
  --list -E COMMON_ARGUMENTS -o /dev/null
```

Repeat separately with `--list --lanes 1 -c COMMON_ARGUMENTS -o
451-qa-results/timed001.o` for real compilation. Repeat both configurations
with `base001`/`base002` for A/A. Do not combine the two workload lists in one
rotating slot array. `-E` must be the preprocessor command's first argument.
Explicit preflights require zero status and compare real `.i` and `.o` files
byte for byte before accepting timing records.

Build the original readers with `clang -std=c17 -O2 -Wall -Wextra -Werror`.
`whole_stats RAW_LOG` requires three rounds, both role summaries, 126 timed
process records and zero nonzero statuses. `phase_stats RAW_LOG ROLE_B_NAME`
requires seven complete process pairs and consistent input/output token counts.
Their raw logs, summaries and rejected truncated-log controls are retained.

Final native acceptance commands, one lock per command:

```text
taskset -c 2 ./build/compiler test-preprocessor
taskset -c 2 ./build/compiler test-lexer
taskset -c 2 ./build/compiler test-refinement src
taskset -c 0-7 ./build/compiler test-files
```

No further timing or refinement campaign is warranted for this rejected
prototype. Preserve the frozen branch and negative evidence for future work.
