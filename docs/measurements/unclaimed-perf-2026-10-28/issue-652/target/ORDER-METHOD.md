# Preserved predecessor-conditioning finding

The frozen baseline's `profile_ab_tree(round, position, slot_count)` returns
`(round + position) % slot_count`. Every slot visits every ordinal position,
but almost every slot retains its predecessor: except when it begins a round,
slot s follows slot s-1 modulo slot_count. This is a source-level property;
it is not a claim about the exact hardware mechanism causing a timing change.

The 41-round same-binary A/A in `aa.log` has eight slots:

0. baseline empty syntax
1. identical-baseline control empty syntax
2. baseline empty preprocessing
3. identical-baseline control empty preprocessing
4. baseline tiny object compile
5. identical-baseline control tiny object compile
6. baseline SQLite object compile
7. identical-baseline control SQLite object compile

Baseline empty usually follows the ~144 ms SQLite control; its paired empty
control usually follows empty syntax. With identical source binaries and
nearly identical retired instructions, paired median control-role changes
are -25.91% (empty syntax), -7.57% (preprocessing), -9.86% (tiny object), and
-0.294% (SQLite). All 328 timed processes exit 0 and have zero major faults.
The raw rows and summaries are retained in aa.log; the exact argument recipe
is given below. Native
baseline SHA-256 is d4420d3786771dc3f9b851b6931bc8d8cdb7d01959b3213f4927821847fe871d.

This A/A has four lists, while the first small A/B has three. It is a
methodological reproduction, not a numerically matched correction to that
A/B. Accordingly, the original mixed-list tiny A/B estimates are provisional
and are superseded for source-effect attribution by isolated single-list
A/A, A/B and reversed B/A campaigns, preserving the original receipts.
With two roles and one input, rotation counterbalances same/other-binary
predecessors across the odd number of measured rounds. No shared compiler
profiling implementation is changed by this QA work.

Cross-list conditioning is an inference consistent with the deterministic
predecessor pattern and the observed identical-binary result. The exact
contributions of Zen 5's execution state, instruction/cache placement and
other mechanisms have not been isolated. A future separately claimed
harness change should explicitly test predecessor balance and preserve
single-input, multiple-input and semantic/status contracts.

Reproduction recipe from the remote campaign root (baseline is both
executables; this does not modify source or shared settings):

```sh
EXCLUSIVE_OWNER=codex-target652 \
EXCLUSIVE_TITLE='652 same-binary mixed A/A predecessor control' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652 \
~/buster-fast-bench/exclusive.sh taskset -c 2 ./base/build/compiler time-runs \
  --runs 41 --warmups 3 --copies 1 \
  --build base ./base/build/compiler --build control ./base/build/compiler \
  --list -fsyntax-only qa652-24e9c1f8/empty.c \
  --list -E -P qa652-24e9c1f8/empty.c -o /dev/null \
  --list --lanes 1 -c qa652-24e9c1f8/tiny.c -o qa652-24e9c1f8/aa-tiny.o \
  --list --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
    -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17 \
    --predefines corpus/gnu17-pinned-predefines.txt --clang-features \
    --target=x86_64-linux-gnu -march=znver5 -nostdinc \
    -isystem corpus/headers/usr/lib/clang/23/include \
    -isystem corpus/headers/usr/local/include \
    -isystem corpus/headers/usr/include -Icorpus/sqlite \
    corpus/sqlite/sqlite3.c -o qa652-24e9c1f8/aa-sql.o
```

The accepted isolated A/A uses only one of the first three lists per
invocation. A/B changes only control label/path to cleanup and
`./issue-652/build/compiler`. B/A reverses the `--build` argument order,
while retaining the same base/cleanup role names for analysis. Every
invocation takes its own exclusive hold. The results and exit receipts
are `raw/qa652-24e9c1f8/isolated-CASE-SCENARIO.{log,exit}`. Thus the control
is a full same-binary setup, not a list of illustrative rotation numbers.
